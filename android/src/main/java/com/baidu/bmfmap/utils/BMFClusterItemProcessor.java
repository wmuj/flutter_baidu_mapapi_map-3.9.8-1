package com.baidu.bmfmap.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.ThreadPoolExecutor;

public class BMFClusterItemProcessor {
    private static final String TAG = "ClusterItemProcessor";
    private final ThreadPoolExecutor executor;
    private volatile boolean isShutdown = false;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    private static final int DEFAULT_THREAD_TIMEOUT = 60;

    public BMFClusterItemProcessor() {
        int corePoolSize = Math.max(2, Runtime.getRuntime().availableProcessors() - 1);

        executor = new ThreadPoolExecutor(
                corePoolSize,
                corePoolSize,
                DEFAULT_THREAD_TIMEOUT,
                TimeUnit.MILLISECONDS, // 时间单位
                new LinkedBlockingQueue<>(), // 任务队列
                new ThreadFactory() {
                    private final AtomicInteger threadCount = new AtomicInteger(1);

                    @Override
                    public Thread newThread(Runnable r) {
                        Thread thread = new Thread(r, "BMFClusterProcessor-" + threadCount.getAndIncrement());
                        thread.setPriority(Thread.MIN_PRIORITY);
                        // 设置为守护线程，避免阻止JVM退出
                        thread.setDaemon(true);
                        return thread;
                    }
                },
                new ThreadPoolExecutor.AbortPolicy()
        );
        try {
            executor.setKeepAliveTime(DEFAULT_THREAD_TIMEOUT, TimeUnit.MILLISECONDS);
            executor.allowCoreThreadTimeOut(true);
        } catch (Exception e) {
            // 一些特殊机器上，keepAliveTime 默认常量 DEFAULT_KEEPALIVE_MILLIS=0，导致allowCoreThreadTimeOut异常
            // 所以此处手动设置 setKeepAliveTime
        }
    }
    public interface ProcessCallback {
        void onSuccess(List<BMFClusterItem> items);
        void onError(String error);
    }

    public void processClusterInfosAsync(List<Object> clusterInfos, ProcessCallback callback) {
        // 参数验证前置，避免不必要的线程切换
        if (callback == null) {
            if (Env.DEBUG) {
                Log.e(TAG, "ProcessCallback is null");
            }
            return;
        }

        if (isShutdown) {
            callback.onError("Processor has been shutdown");
            return;
        }

        if (executor == null || executor.isShutdown()) {
            callback.onError("Executor is not available");
            return;
        }

        if (clusterInfos == null || clusterInfos.isEmpty()) {
            callback.onError("Cluster infos is null or empty");
            return;
        }

        executor.execute(() -> {
            try {
                List<BMFClusterItem> items = processFromObjectList(clusterInfos);
                mainHandler.post(() -> {
                    if (callback != null) {
                        callback.onSuccess(items);
                    }
                });
            } catch (Exception e) {
                if (Env.DEBUG) {
                    Log.e(TAG, "Error processing cluster infos", e);
                }
                mainHandler.post(() -> {
                    if (callback != null) {
                        callback.onError("Processing failed: " + e.getMessage());
                    }
                });
            }
        });
    }

    private List<BMFClusterItem> processFromObjectList(List<Object> clusterInfos) {
        List<BMFClusterItem> items = new ArrayList<>(clusterInfos.size());
        Map<String, BitmapDescriptor> iconCache = new HashMap<>();

        for (Object item : clusterInfos) {
            if (!(item instanceof Map)) {
                continue;
            }

            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> clusterInfo = (Map<String, Object>) item;
                BMFClusterItem clusterItem = createItemFromClusterInfo(clusterInfo, iconCache);
                if (clusterItem != null) {
                    items.add(clusterItem);
                }
            } catch (Exception e) {
                if (Env.DEBUG) {
                    Log.w(TAG, "Failed to process cluster item", e);
                }
            }
        }
        return items;
    }

    private BMFClusterItem createItemFromClusterInfo(Map<String, Object> clusterInfo,
                                                     Map<String, BitmapDescriptor> iconCache) {
        // 坐标解析
        Map<String, Object> coordinate = (Map<String, Object>) clusterInfo.get("coordinate");
        if (coordinate == null) {
            return null;
        }

        LatLng latLng = FlutterDataConveter.mapToLatlng(coordinate);
        if (latLng == null) {
            return null;
        }

        // 图标处理
        BitmapDescriptor bitmapDescriptor = getBitmapDescriptor(clusterInfo, iconCache);
        if (bitmapDescriptor == null) {
            return null;
        }

        // Bundle创建
        Bundle bundle = createBundle(clusterInfo);

        return new BMFClusterItem(latLng, bitmapDescriptor, bundle);
    }

    private BitmapDescriptor getBitmapDescriptor(Map<String, Object> clusterInfo,
                                                 Map<String, BitmapDescriptor> iconCache) {
        String icon = (String) clusterInfo.get("icon");
        byte[] iconData = (byte[]) clusterInfo.get("iconData");

        // 使用缓存
        String cacheKey = getCacheKey(icon, iconData);
        BitmapDescriptor cached = iconCache.get(cacheKey);
        if (cached != null) {
            return cached;
        }

        try {
            BitmapDescriptor bitmapDescriptor;
            if (!TextUtils.isEmpty(icon)) {
                bitmapDescriptor = BitmapDescriptorFactory.fromAsset("flutter_assets/" + icon);
            } else if (iconData != null && iconData.length > 0) {
                // 添加Bitmap解码选项，优化内存使用
                BitmapFactory.Options options = new BitmapFactory.Options();
                options.inPreferredConfig = Bitmap.Config.RGB_565; // 减少内存占用
                options.inSampleSize = calculateInSampleSize(iconData); // 按需缩放

                Bitmap bitmap = BitmapFactory.decodeByteArray(iconData, 0, iconData.length, options);
                if (bitmap != null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(bitmap);
                } else {
                    return null;
                }
            } else {
                return null;
            }

            if (bitmapDescriptor != null) {
                iconCache.put(cacheKey, bitmapDescriptor);
            }
            return bitmapDescriptor;
        } catch (Exception e) {
            if (Env.DEBUG) {
                Log.e(TAG, "Failed to create BitmapDescriptor", e);
            }
            return null;
        }
    }

    /**
     * 计算Bitmap采样率，避免加载过大图片
     */
    private int calculateInSampleSize(byte[] iconData) {
        if (iconData == null || iconData.length == 0) {
            return 1;
        }

        // 如果图片数据较大(超过100KB)，进行采样
        if (iconData.length > 100 * 1024) {
            // 缩小为1/2
            return 2;
        }
        return 1;
    }

    private String getCacheKey(String icon, byte[] iconData) {
        if (!TextUtils.isEmpty(icon)) {
            return "asset_" + icon;
        } else if (iconData != null) {
            return "data_" + Arrays.hashCode(iconData);
        }
        return "default";
    }

    private Bundle createBundle(Map<String, Object> clusterInfo) {
        Bundle bundle = new Bundle();
        String icon = (String) clusterInfo.get("icon");
        byte[] iconData = (byte[]) clusterInfo.get("iconData");

        if (!TextUtils.isEmpty(icon)) {
            bundle.putString("icon", icon);
        }
        if (iconData != null && iconData.length > 0) {
            bundle.putByteArray("iconData", iconData);
        }
        return bundle;
    }

    public void shutdown() {
        if (isShutdown) {
            return;
        }
        isShutdown = true;

        if (executor != null && !executor.isShutdown()) {
            try {
                executor.shutdown();

                if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
                    if (Env.DEBUG) {
                        Log.w(TAG, "Executor not terminated in 5 seconds, forcing shutdown");
                    }
                    executor.shutdownNow();

                    if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
                        if (Env.DEBUG) {
                            Log.e(TAG, "Executor did not terminate");
                        }
                    }
                }
            } catch (InterruptedException e) {
                if (Env.DEBUG) {
                    Log.w(TAG, "Shutdown interrupted, forcing shutdown");
                }
                executor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
    }

    public boolean isShutdown() {
        return isShutdown || (executor != null && executor.isShutdown());
    }

    public boolean isAvailable() {
        return !isShutdown && executor != null && !executor.isShutdown() && !executor.isTerminated();
    }
}