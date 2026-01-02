package com.baidu.bmfmap.map.overlayhandler;

import static com.baidu.bmfmap.utils.Constants.MethodProtocol.ClusterProtocol.CLUSTER_CLICK_ITEM_METHOD;
import static com.baidu.bmfmap.utils.Constants.MethodProtocol.ClusterProtocol.CLUSTER_CLICK_METHOD;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.cluster.clustering.Cluster;
import com.baidu.bmfmap.cluster.clustering.ClusterManager;
import com.baidu.bmfmap.map.MapListener;
import com.baidu.bmfmap.utils.BMFClusterItem;
import com.baidu.bmfmap.utils.BMFClusterItemProcessor;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MarkerClusterHandler extends OverlayHandler implements
        ClusterManager.OnClusterClickListener<BMFClusterItem>,
        ClusterManager.OnClusterItemClickListener<BMFClusterItem> {

    private static final String TAG = "MarkerClusterHandler";

    private ClusterManager mClusterManager;

    public MarkerClusterHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
        mClusterManager = new ClusterManager<BMFClusterItem>(bmfMapController.getContext(), mBaiduMap);
        MapListener mapListener = bmfMapController.getMapListener();
        if (null != mapListener) {
            // 设置maker点击时的响应
            mapListener.setOnClusterMarkerClickListener(mClusterManager);
            // 设置地图监听，当地图状态发生改变时，进行点聚合运算
            mapListener.setOnClusterMapStatusChangeListener(mClusterManager);

            mClusterManager.setOnClusterClickListener(this);
            mClusterManager.setOnClusterItemClickListener(this);
        }
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        if (null == call) {
            result.success(false);
            return;
        }

        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            result.success(false);
            return;
        }

        boolean ret = false;
        switch (methodId) {
            case Constants.MethodProtocol.ClusterProtocol.SET_CLUSTER_MARKER_COORDINATE_METHOD:
                ret = addClusters(call);
                result.success(ret);
                break;
            case Constants.MethodProtocol.ClusterProtocol.SET_MAX_DISTANCE_ZOOM_METHOD:
                ret = setMaxDistanceZoom(call);
                result.success(ret);
                break;
            case Constants.MethodProtocol.ClusterProtocol.CLEAN_CLUSTER_METHOD:
                ret = cleanCluster(call);
                result.success(ret);
                break;
            case Constants.MethodProtocol.ClusterProtocol.UPDATE_CLUSTERS_METHOD:
                ret = updateCluster(call);
                result.success(ret);
                break;
            case Constants.MethodProtocol.ClusterProtocol.GET_CLUSTER_ON_ZOOM_LEVEL_METHOD:
                getClusterOnZoomLevel(call, result);
                break;
            case Constants.MethodProtocol.ClusterProtocol.SET_CLUSTER_VISIBLE_METHOD:
                ret = setClusterVisible(call, result);
                result.success(ret);
                break;
            case Constants.MethodProtocol.ClusterProtocol.GET_CLUSTER_VISIBLE_METHOD:
                getClusterVisible(call, result);
                break;
            default:
                break;
        }
    }

    private boolean setClusterVisible(MethodCall call, MethodChannel.Result result) {
        if (null == call || mClusterManager == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        mClusterManager.setClusterVisible((Boolean) argument.get("isClusterVisible"));

        boolean shouldRefreshCluster = (Boolean) argument.get("shouldRefreshCluster");
        if (shouldRefreshCluster) {
            mClusterManager.cluster();
        }

        return true;
    }

    private void getClusterVisible(MethodCall call, MethodChannel.Result result) {
        if (mClusterManager == null) {
            return;
        }
        result.success(mClusterManager.getClusterVisible());
    }

    private boolean getClusterOnZoomLevel(MethodCall call, MethodChannel.Result result) {
        if (null == call || mClusterManager == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        Integer zoomLevel = (Integer) argument.get("zoomLevel");
        if (null == zoomLevel) {
            return false;
        }

        List<HashMap<String, Object>> clusterInfoList = new ArrayList<>();
        Set<? extends Cluster<BMFClusterItem>> clusters = mClusterManager.getClusterOnZoomLevel(zoomLevel);
        for (Cluster<BMFClusterItem> cluster : clusters) {
            if (cluster == null) {
                continue;
            }

            HashMap<String, Object> clusterItem = getClusterItem(cluster.getPosition(), cluster.getSize());
            if (clusterItem == null) {
                continue;
            }

            clusterInfoList.add(clusterItem);
        }

        result.success(clusterInfoList);
        return true;
    }

    private boolean updateCluster(MethodCall call) {
        if (null == call || mClusterManager == null) {
            return false;
        }

        mClusterManager.clearItems();
        addClusters(call);

        return true;
    }

    private boolean cleanCluster(MethodCall call) {
        if (null == call || mClusterManager == null) {
            return false;
        }

        mClusterManager.clearItems();
        mClusterManager.cluster();
        return true;
    }

    private boolean setMaxDistanceZoom(MethodCall call) {
        if (null == call || mClusterManager == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        if (!argument.containsKey("maxDistanceInDP")) {
            return false;
        }

        Integer maxDistanceInDP = (Integer) argument.get("maxDistanceInDP");
        if (null == maxDistanceInDP) {
            return false;
        }

        mClusterManager.setMaxDistanceZoom(maxDistanceInDP);
        return true;
    }

    private boolean addClusters(MethodCall call) {

        if (Env.DEBUG) {
            Log.d(TAG, "addClusters enter");
        }

        if (null == call || mClusterManager == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        if (!argument.containsKey("clusterInfos")) {
            return false;
        }

        List<Object> clusterInfos = (List<Object>) argument.get("clusterInfos");

        if (mMapController.getProcessor() != null) {
            mMapController.getProcessor().processClusterInfosAsync(clusterInfos,
                    new BMFClusterItemProcessor.ProcessCallback() {
                @Override
                public void onSuccess(List<BMFClusterItem> items) {
                    if (null != items && !items.isEmpty()) {
                        mClusterManager.addItems(items);
                        mClusterManager.cluster();
                    }
                }

                @Override
                public void onError(String error) {
                    Log.d(TAG, error);
                }
            });
        }

        return true;
    }

    @Override
    public boolean onClusterClick(Cluster<BMFClusterItem> cluster) {
        if (mMapController == null) {
            return false;
        }

        HashMap<String, Object> clusterMap = new HashMap<>();
        List<HashMap<String, Object>> clusterInfoList = new ArrayList<>();
        MethodChannel methodChannel = mMapController.getMethodChannel();
        if (cluster == null || methodChannel == null) {
            return false;
        }

        for (BMFClusterItem item : cluster.getItems()) {
            LatLng position = item.getPosition();
            Bundle bundle = item.getExtras();
            if (position == null || bundle == null) {
                continue;
            }

            HashMap<String, Object> clusterInfo = getClusterInfo(position, bundle, false);
            clusterInfoList.add(clusterInfo);
        }

        clusterMap.put("clusterInfoList", clusterInfoList);
        clusterMap.put("size", cluster.getSize());

        methodChannel.invokeMethod(CLUSTER_CLICK_METHOD, clusterMap, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                if (Env.DEBUG) {
                    Log.d(TAG, "onClusterClick methodChannel is success: ");
                }
            }

            @Override
            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                if (Env.DEBUG) {
                    Log.d(TAG, "onClusterClick error: " +" errorCode : " +
                            ""+ errorCode + " errorMessage: " + errorMessage);
                }
            }

            @Override
            public void notImplemented() {

            }
        });
        return true;
    }

    @Override
    public boolean onClusterItemClick(BMFClusterItem item) {
        if (mMapController == null) {
            return false;
        }
        MethodChannel methodChannel = mMapController.getMethodChannel();
        if (item == null || methodChannel == null) {
            return false;
        }

        LatLng position = item.getPosition();
        Bundle bundle = item.getExtras();
        if (position == null || bundle == null) {
            return false;
        }

        HashMap<String, Object> clusterInfoMap = getClusterInfo(position, bundle, true);
        if (clusterInfoMap == null) {
            return false;
        }

        methodChannel.invokeMethod(CLUSTER_CLICK_ITEM_METHOD, clusterInfoMap, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                if (Env.DEBUG) {
                    Log.d(TAG, "onClusterItemClick methodChannel is success: ");
                }
            }

            @Override
            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                if (Env.DEBUG) {
                    Log.d(TAG, "onClusterItemClick error: " +" errorCode : " +
                            ""+ errorCode + " errorMessage: " + errorMessage);
                }
            }

            @Override
            public void notImplemented() {

            }
        });

        return true;
    }

    private HashMap<String, Object> getClusterItem(LatLng position, int size) {
        if (position == null) {
            return null;
        }

        HashMap<String, Object> itemMap = new HashMap<>();
        HashMap<String, Double> coord = new HashMap<>();
        coord.put("latitude", position.latitude);
        coord.put("longitude", position.longitude);
        itemMap.put("coordinate", coord);
        itemMap.put("size", size);

        return itemMap;
    }

    private HashMap<String, Object> getClusterInfo(LatLng position, Bundle bundle, boolean isItem) {
        HashMap<String, Object> clusterInfoMap = new HashMap<>();
        HashMap<String, Object> itemMap = new HashMap<>();
        HashMap<String, Double> coord = new HashMap<>();
        coord.put("latitude", position.latitude);
        coord.put("longitude", position.longitude);
        itemMap.put("coordinate", coord);

        String icon = bundle.getString("icon");
        byte[] data = bundle.getByteArray("iconData");
        if (TextUtils.isEmpty(icon) && (data == null || data.length <= 0)) {
            return null;
        }
        if (!TextUtils.isEmpty(icon)) {
            itemMap.put("icon", icon);
        }
        HashMap<String, Object> iconData = new HashMap<>();
        if (data != null && data.length > 0) {
            iconData.put("data", data);
            itemMap.put("iconData", iconData);
        }

        if (!isItem) {
            return itemMap;
        }

        clusterInfoMap.put("clusterInfo", itemMap);
        return clusterInfoMap;
    }

}
