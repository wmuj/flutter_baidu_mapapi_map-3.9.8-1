package com.baidu.bmfmap.map.maphandler;

import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.TileMapProtocol;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.IOStreamUtils;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.FileTileProvider;
import com.baidu.mapapi.map.Tile;
import com.baidu.mapapi.map.TileOverlay;
import com.baidu.mapapi.map.TileOverlayOptions;
import com.baidu.mapapi.map.TileProvider;
import com.baidu.mapapi.map.UrlTileProvider;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class TileMapHandler extends BMapHandler {

    private Tile mOfflineTile;
    // 设置瓦片图的在线缓存大小，默认为20 M
    private static final int TILE_TMP = 20 * 1024 * 1024;
    private static final int MAX_LEVEL = 21;
    private static final int MIN_LEVEL = 4;

    private int mMaxLevel = MAX_LEVEL;
    private int mMinLevel = MIN_LEVEL;
    private int mTileTmp = TILE_TMP;
    private String mUrlString;

    private HashMap<String, TileOverlay> mTileOverlayMap = new HashMap<>();

    public static class TileType {
        public static final int URL_TILE_PROVIDER = 0;
        public static final int FILE_TILE_PROVIDER_ASYNC = 1;
        public static final int FILE_TILE_PROVIDER_SYNC = 2;
    }

    private static final String TAG = "TileMapHandler";

    public TileMapHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCallResult(Context context, MethodCall call,
                                        MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "handlerMethodCallResult enter");
        }
        String methodID = call.method;
        switch (methodID) {
            case TileMapProtocol.sAddTileMapMethod:
                addTile(context, call, result);
                break;
            case TileMapProtocol.sRemoveTileMapMethod:
                removeTile(context, call, result);
                break;
            default:
                break;
        }
    }

    private void addTile(Context context, MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "addTile enter");
        }
        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (null == baiduMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == mBaiduMap");
            }
            result.success(false);
            return;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            result.success(false);
            return;
        }

        TileOverlayOptions tileOverlayOptions = new TileOverlayOptions();

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (null == id) {
            result.success(false);
            return;
        }

        Integer maxZoom = new TypeConverter<Integer>().getValue(argument, "maxZoom");
        if (null != maxZoom) {
            mMaxLevel = maxZoom.intValue();
            if (Env.DEBUG) {
                Log.d(TAG, "maxZoom:" + maxZoom);
            }
        }

        Integer minZoom = new TypeConverter<Integer>().getValue(argument, "minZoom");
        if (null != maxZoom) {
            mMinLevel = minZoom.intValue();
            if (Env.DEBUG) {
                Log.d(TAG, "minZoom:" + minZoom);
            }
        }

        Integer maxTileTmp = new TypeConverter<Integer>().getValue(argument, "maxTileTmp");
        if (null != maxTileTmp) {
            mTileTmp = maxTileTmp.intValue();
        }

        Map<String, Object> visibleMapBounds =
                new TypeConverter<Map<String, Object>>().getValue(argument,
                        "visibleMapBounds");
        if (null == visibleMapBounds) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == visibleMapBounds");
            }
            return;
        }

        LatLngBounds latLngBounds = visibleMapBoundsImp(visibleMapBounds);
        if (null == latLngBounds) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == latLngBounds");
            }
            return;
        }
        tileOverlayOptions.setPositionFromBounds(latLngBounds);

        TileProvider tileProvider = getTileProvider(context, argument);
        if (null == tileProvider) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == tileProvider");
            }
            result.success(false);
            return;
        }

        tileOverlayOptions.tileProvider(tileProvider);

        if (Env.DEBUG) {
            Log.d(TAG, "addTile success");
        }
        TileOverlay tileOverlay = baiduMap.addTileLayer(tileOverlayOptions);
        mTileOverlayMap.put(id, tileOverlay);
        result.success(true);
    }

    private LatLngBounds visibleMapBoundsImp(Map<String, Object> visibleMapBounds) {
        if (!visibleMapBounds.containsKey("northeast") || !visibleMapBounds
                .containsKey("southwest")) {
            return null;
        }
        HashMap<String, Double> northeast =
                (HashMap<String, Double>) visibleMapBounds.get("northeast");
        HashMap<String, Double> southwest =
                (HashMap<String, Double>) visibleMapBounds.get("southwest");
        if (null == northeast || null == southwest) {
            return null;
        }
        if (!northeast.containsKey("latitude") || !northeast.containsKey("longitude")
                || !southwest.containsKey("latitude") || !southwest.containsKey("longitude")) {
            return null;
        }

        Double northeastLatitude = northeast.get("latitude");
        Double northeastLongitude = northeast.get("longitude");
        Double southwestLatitude = southwest.get("latitude");
        Double southwestLongitude = southwest.get("longitude");

        if (null == northeastLatitude || null == northeastLongitude
                || null == southwestLatitude || null == southwestLongitude) {
            return null;
        }

        LatLng northeastLatLng = new LatLng(northeastLatitude, northeastLongitude);
        LatLng southwestLatLng = new LatLng(southwestLatitude, southwestLongitude);
        LatLngBounds.Builder builder = new LatLngBounds.Builder();
        builder.include(northeastLatLng);
        builder.include(southwestLatLng);

        return builder.build();
    }

    private TileProvider getTileProvider(Context context, Map<String, Object> tileProviderMap) {
        Integer tileType = new TypeConverter<Integer>().getValue(tileProviderMap, "tileLoadType");
        if (null == tileType) {
            return null;
        }

        TileProvider tileProvider = null;
        switch (tileType) {
            case TileType.FILE_TILE_PROVIDER_ASYNC:
            case TileType.FILE_TILE_PROVIDER_SYNC:
                tileProvider = getFileTileProvider(context);
                break;
            case TileType.URL_TILE_PROVIDER:
                tileProvider = getUrlTileProvider(context, tileProviderMap);
                break;
            default:
                break;
        }
        return tileProvider;
    }

    private TileProvider getFileTileProvider(final Context context) {
        TileProvider tileProvider = new FileTileProvider() {
            @Override
            public Tile getTile(int x, int y, int z) {
                // 根据地图某一状态下x、y、z加载指定的瓦片图
                String filedir =
                        "flutter_assets/resoures/bmflocaltileimage/" + z + "/" + z + "_" + x + "_"
                                + y + ".jpg";
                //                FlutterMain.getLookupKeyForAsset();
                Bitmap bm = getFromAssets(context, filedir);
                if (bm == null) {
                    return null;
                }
                // 瓦片图尺寸必须满足256 * 256
                mOfflineTile = new Tile(bm.getWidth(), bm.getHeight(), toRawData(bm));
                bm.recycle();
                return mOfflineTile;
            }

            @Override
            public int getMaxDisLevel() {
                return 0;
            }

            @Override
            public int getMinDisLevel() {
                return 0;
            }
        };

        return tileProvider;
    }

    private TileProvider getUrlTileProvider(Context context, Map<String, Object> tileProviderMap) {
        TileProvider tileProvider = null;
        if (tileProviderMap.containsKey("url")) {
            Object urlObj = tileProviderMap.get("url");
            if (null != urlObj) {
                mUrlString = (String) urlObj;
                         /*定义瓦片图的在线Provider，并实现相关接口
                     MAX_LEVEL、MIN_LEVEL 表示地图显示瓦片图的最大、最小级别
                     urlString 表示在线瓦片图的URL地址*/
                tileProvider = new UrlTileProvider() {
                    @Override
                    public int getMaxDisLevel() {
                        return mMaxLevel;
                    }

                    @Override
                    public int getMinDisLevel() {
                        return mMinLevel;
                    }

                    @Override
                    public String getTileUrl() {
                        return mUrlString;
                    }
                };
            }
        }

        return tileProvider;
    }

    /**
     * 瓦片文件解析为Bitmap
     *
     * @param fileName
     * @return 瓦片文件的Bitmap
     */
    public Bitmap getFromAssets(Context context, String fileName) {
        AssetManager assetManager = context.getAssets();
        InputStream inputStream = null;
        Bitmap bitmap;

        try {
            if (Env.DEBUG) {
                Log.d(TAG, fileName);
            }

            inputStream = assetManager.open(fileName);

            bitmap = BitmapFactory.decodeStream(inputStream);
            return bitmap;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            IOStreamUtils.closeSilently(inputStream);
        }
    }

    /**
     * 解析Bitmap
     *
     * @param bitmap
     * @return
     */
    byte[] toRawData(Bitmap bitmap) {
        ByteBuffer buffer = ByteBuffer.allocate(bitmap.getWidth() * bitmap.getHeight() * 4);
        bitmap.copyPixelsToBuffer(buffer);
        byte[] data = buffer.array();
        buffer.clear();
        return data;
    }

    private void removeTile(Context context, MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "removeTile enter");
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            result.success(false);
            return;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            result.success(false);
            return;
        }

        TileOverlay tileOverlay = mTileOverlayMap.get(id);
        if (null != tileOverlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "remove tile success");
            }
            tileOverlay.removeTileOverlay();
            result.success(true);
        } else {
            result.success(false);
        }
    }
}