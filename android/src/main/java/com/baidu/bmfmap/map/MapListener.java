package com.baidu.bmfmap.map;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.microedition.khronos.opengles.GL10;

import com.baidu.bmfmap.cluster.listener.ClusterMapStatusChangeListener;
import com.baidu.bmfmap.cluster.listener.ClusterMarkerClickListener;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.MarkerProtocol.MarkerDragState;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.MapTaskManager;
import com.baidu.bmfmap.utils.ThreadPoolUtil;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.mapapi.map.Arc;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Building;
import com.baidu.mapapi.map.Building3DListener;
import com.baidu.mapapi.map.Circle;
import com.baidu.mapapi.map.GroundOverlay;
import com.baidu.mapapi.map.MapBaseIndoorMapInfo;
import com.baidu.mapapi.map.MapPoi;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MultiPoint;
import com.baidu.mapapi.map.MultiPointItem;
import com.baidu.mapapi.map.Polygon;
import com.baidu.mapapi.map.Polyline;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;
import com.baidu.mapapi.search.core.BuildingInfo;

import android.graphics.Point;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;

@SuppressWarnings("unchecked")
public class MapListener implements BaiduMap.OnMapClickListener, BaiduMap.OnMapLoadedCallback,
        BaiduMap.OnMapStatusChangeListener, BaiduMap.OnMapRenderCallback,
        BaiduMap.OnMapDrawFrameCallback,
        BaiduMap.OnBaseIndoorMapListener, BaiduMap.OnMarkerClickListener,
        BaiduMap.OnPolylineClickListener,
        BaiduMap.OnMapDoubleClickListener, BaiduMap.OnMapLongClickListener,
        BaiduMap.OnMarkerDragListener,
        BaiduMap.OnMapRenderValidDataListener, BaiduMap.OnMyLocationClickListener,
        BaiduMap.OnMultiPointClickListener, BaiduMap.OnHeatMapDrawFrameCallBack,
        BaiduMap.OnCircleClickListener, BaiduMap.OnPolygonClickListener,
        BaiduMap.OnGroundOverlayClickListener, BaiduMap.OnArcClickListener, Building3DListener {

    private static final int DRAW_FRAME_MESSAGE = 0;
    private static final int FRAME_INDEX_MESSAGE = 1;
    private static final String TAG = "MapListener";
    private BaiduMap mBaiduMap;
    private MethodChannel mMethodChannel;
    private final Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg != null && msg.what == DRAW_FRAME_MESSAGE) {
                if (null != msg.obj) {
                    mMethodChannel.invokeMethod(
                            Constants.MethodProtocol.MapStateProtocol.sMapOnDrawMapFrameCallback,
                            (HashMap<String, HashMap>) msg.obj);
                }
            } else if (msg != null && msg.what == FRAME_INDEX_MESSAGE) {
                if (null != msg.obj) {
                    mMethodChannel
                            .invokeMethod(Constants.MethodProtocol.HeatMapProtocol.sHeatMapFrameAnimationIndexCallbackMethod,
                                    (HashMap<String, Integer>) msg.obj);
                }
            }
        }
    };
    private int mReason;

    public MapListener(FlutterMapViewWrapper mapView, MethodChannel methodChannel) {
        this.mMethodChannel = methodChannel;

        if (null == mapView) {
            return;
        }
        mBaiduMap = mapView.getBaiduMap();
        //        init();
    }

    public void init() {
        if (null == mBaiduMap) {
            return;
        }
        mBaiduMap.setOnMapClickListener(this);
        mBaiduMap.setOnMapLoadedCallback(this);
        mBaiduMap.setOnMapStatusChangeListener(this);
        mBaiduMap.setOnMapDrawFrameCallback(this);
        mBaiduMap.setOnMapRenderCallbadk(this);
        mBaiduMap.setOnBaseIndoorMapListener(this);
        mBaiduMap.setOnMarkerClickListener(this);
        mBaiduMap.setOnPolylineClickListener(this);
        mBaiduMap.setOnMapDoubleClickListener(this);
        mBaiduMap.setOnMapLongClickListener(this);
        mBaiduMap.setOnMarkerDragListener(this);
        mBaiduMap.setOnMapRenderValidDataListener(this);
        mBaiduMap.setOnMyLocationClickListener(this);
        mBaiduMap.setOnMultiPointClickListener(this);
        mBaiduMap.setOnCircleClickListener(this);
        mBaiduMap.setOnPolygonClickListener(this);
        mBaiduMap.setOnGroundOverlayClickListener(this);
        mBaiduMap.setOnArcClickListener(this);
        mBaiduMap.setOn3DBuildingListener(this);
    }

    public void release() {
        if (null == mBaiduMap) {
            return;
        }
        mBaiduMap.setOnMapClickListener(null);
        mBaiduMap.setOnMapLoadedCallback(null);
        mBaiduMap.setOnMapStatusChangeListener(null);
        // 内部有异步操作有几率会导致空指针问题
//        mBaiduMap.setOnMapDrawFrameCallback(null);
        mBaiduMap.setOnMapRenderCallbadk(null);
        mBaiduMap.setOnBaseIndoorMapListener(null);
        mBaiduMap.setOnMarkerClickListener(null);
        mBaiduMap.setOnPolylineClickListener(null);
        mBaiduMap.setOnMapDoubleClickListener(null);
        mBaiduMap.setOnMapLongClickListener(null);
        mBaiduMap.setOnMarkerDragListener(null);
        mBaiduMap.setOnMapRenderValidDataListener(null);
        mBaiduMap.setOnMyLocationClickListener(null);
        mBaiduMap.setOnMultiPointClickListener(null);
        mBaiduMap.setOnCircleClickListener(null);
        mBaiduMap.setOnPolygonClickListener(null);
        mBaiduMap.setOnGroundOverlayClickListener(null);
        mBaiduMap.setOnArcClickListener(null);
        mBaiduMap.setOn3DBuildingListener(null);
    }

    @Override
    public void onMapClick(LatLng latLng) {
        if (null == latLng || mMethodChannel == null) {
            return;
        }
        HashMap<String, HashMap> coordinateMap = new HashMap<>();
        HashMap<String, Double> coord = new HashMap<>();
        coord.put("latitude", latLng.latitude);
        coord.put("longitude", latLng.longitude);
        coordinateMap.put("coord", coord);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.MapStateProtocol.sMapOnClickedMapBlankCallback,
                coordinateMap);
    }

    @Override
    public void onMapPoiClick(MapPoi mapPoi) {
        if (null == mapPoi || mMethodChannel == null) {
            return;
        }
        HashMap<String, Double> pt = new HashMap<>();
        LatLng position = mapPoi.getPosition();
        if (null != position) {
            pt.put("latitude", mapPoi.getPosition().latitude);
            pt.put("longitude", mapPoi.getPosition().longitude);
        }
        HashMap<String, HashMap> poiMap = new HashMap<>();
        HashMap poi = new HashMap();
        poi.put("text", mapPoi.getName());
        poi.put("uid", mapPoi.getUid());
        poi.put("pt", pt);
        poiMap.put("poi", poi);
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapOnClickedMapPoiCallback,
                        poiMap);
    }

    @Override
    public void onMapLoaded() {
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapDidLoadCallback, "");
    }

    @Override
    public void onMapStatusChangeStart(MapStatus mapStatus) {
        if (null != mClusterMapStatusChangeListener) {
            mClusterMapStatusChangeListener.onMapStatusChangeStart(mapStatus);
        }
        if (null == mapStatus || mMethodChannel == null) {
            return;
        }
        HashMap<String, Double> targetScreenMap = new HashMap<>();
        Point targetScreen = mapStatus.targetScreen;
        if (null == targetScreen) {
            return;
        }
        targetScreenMap.put("x", (double) targetScreen.x);
        targetScreenMap.put("y", (double) targetScreen.y);
        HashMap<String, Double> targetMap = new HashMap<>();
        LatLng latLng = mapStatus.target;
        if (null == latLng) {
            return;
        }
        targetMap.put("latitude", latLng.latitude);
        targetMap.put("longitude", latLng.longitude);

        LatLngBounds bound = mapStatus.bound;
        if (null == bound) {
            return;
        }
        HashMap latLngBoundMap = latLngBounds(bound);
        if (null == latLngBoundMap) {
            return;
        }
        HashMap statusMap = new HashMap<>();
        HashMap status = new HashMap();
        status.put("fLevel", ((double) mapStatus.zoom));
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
            rotate = rotate - 360;
        }
        status.put("fRotation", rotate);
        status.put("fOverlooking", ((double) mapStatus.overlook));
        status.put("targetScreenPt", targetScreenMap);
        status.put("targetGeoPt", targetMap);
        status.put("visibleMapBounds", latLngBoundMap);
        statusMap.put("mapStatus", status);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.MapStateProtocol.sMapRegionWillChangeCallback, statusMap);
    }

    @Override
    public void onMapStatusChangeStart(MapStatus mapStatus, int reason) {
        if (null != mClusterMapStatusChangeListener) {
            mClusterMapStatusChangeListener.onMapStatusChangeStart(mapStatus, reason);
        }
        if (null == mapStatus || mMethodChannel == null) {
            return;
        }
        mReason = reason;
        HashMap<String, Double> targetScreenMap = new HashMap<>();
        Point targetScreen = mapStatus.targetScreen;
        if (null == targetScreen) {
            return;
        }
        targetScreenMap.put("x", (double) targetScreen.x);
        targetScreenMap.put("y", (double) targetScreen.y);
        HashMap<String, Double> targetMap = new HashMap<>();
        LatLng latLng = mapStatus.target;
        if (null == latLng) {
            return;
        }
        targetMap.put("latitude", latLng.latitude);
        targetMap.put("longitude", latLng.longitude);

        LatLngBounds bound = mapStatus.bound;
        if (null == bound) {
            return;
        }
        HashMap latLngBoundMap = latLngBounds(bound);
        if (null == latLngBoundMap) {
            return;
        }
        HashMap statusMap = new HashMap<>();
        HashMap status = new HashMap();
        status.put("fLevel", ((double) mapStatus.zoom));
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
            rotate = rotate - 360;
        }
        status.put("fRotation", rotate);
        status.put("fOverlooking", ((double) mapStatus.overlook));
        status.put("targetScreenPt", targetScreenMap);
        status.put("targetGeoPt", targetMap);
        status.put("visibleMapBounds", latLngBoundMap);
        statusMap.put("mapStatus", status);
        // reason返回值-1与flutter值对应
        statusMap.put("reason", mReason - 1);
        mMethodChannel.invokeMethod(Constants.MethodProtocol.MapStateProtocol.
                sMapRegionWillChangeWithReasonCallback, statusMap);
    }

    @Override
    public void onMapStatusChange(MapStatus mapStatus) {
        if (null != mClusterMapStatusChangeListener) {
            mClusterMapStatusChangeListener.onMapStatusChange(mapStatus);
        }
        if (null == mapStatus || mMethodChannel == null) {
            return;
        }
        HashMap<String, Double> targetScreenMap = new HashMap<>();
        Point targetScreen = mapStatus.targetScreen;
        if (null == targetScreen) {
            return;
        }
        targetScreenMap.put("x", (double) targetScreen.x);
        targetScreenMap.put("y", (double) targetScreen.y);
        HashMap<String, Double> targetMap = new HashMap<>();
        LatLng latLng = mapStatus.target;
        if (null == latLng) {
            return;
        }
        targetMap.put("latitude", latLng.latitude);
        targetMap.put("longitude", latLng.longitude);

        LatLngBounds bound = mapStatus.bound;
        if (null == bound) {
            return;
        }
        HashMap latLngBoundMap = latLngBounds(bound);
        if (null == latLngBoundMap) {
            return;
        }
        final HashMap statusMap = new HashMap<>();
        HashMap status = new HashMap();
        status.put("fLevel", ((double) mapStatus.zoom));
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
            rotate = rotate - 360;
        }
        status.put("fRotation", rotate);
        status.put("fOverlooking", ((double) mapStatus.overlook));
        status.put("targetScreenPt", targetScreenMap);
        status.put("targetGeoPt", targetMap);
        status.put("visibleMapBounds", latLngBoundMap);
        statusMap.put("mapStatus", status);

        MapTaskManager.postToMainThread(new Runnable() {
            @Override
            public void run() {
                mMethodChannel.invokeMethod(
                        Constants.MethodProtocol.MapStateProtocol.sMapRegionDidChangeCallback,
                        statusMap);
            }
        }, 0);

    }

    @Override
    public void onMapStatusChangeFinish(MapStatus mapStatus) {
        if (null != mClusterMapStatusChangeListener) {
            mClusterMapStatusChangeListener.onMapStatusChangeFinish(mapStatus);
        }
        if (null == mapStatus || mMethodChannel == null) {
            return;
        }
        HashMap<String, Double> targetScreenMap = new HashMap<>();
        Point targetScreen = mapStatus.targetScreen;
        if (null == targetScreen) {
            return;
        }
        targetScreenMap.put("x", (double) targetScreen.x);
        targetScreenMap.put("y", (double) targetScreen.y);
        HashMap<String, Double> targetMap = new HashMap<>();
        LatLng latLng = mapStatus.target;
        if (null == latLng) {
            return;
        }
        targetMap.put("latitude", latLng.latitude);
        targetMap.put("longitude", latLng.longitude);

        LatLngBounds bound = mapStatus.bound;
        if (null == bound) {
            return;
        }
        HashMap latLngBoundMap = latLngBounds(bound);
        if (null == latLngBoundMap) {
            return;
        }
        HashMap statusMap = new HashMap<>();
        HashMap status = new HashMap();
        status.put("fLevel", ((double) mapStatus.zoom));
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
            rotate = rotate - 360;
        }
        status.put("fRotation", rotate);
        status.put("fOverlooking", ((double) mapStatus.overlook));
        status.put("targetScreenPt", targetScreenMap);
        status.put("targetGeoPt", targetMap);
        status.put("visibleMapBounds", latLngBoundMap);
        statusMap.put("mapStatus", status);
        // reason返回值-1与flutter值对应
        statusMap.put("reason", mReason - 1);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.MapStateProtocol.sMapRegionDidChangeWithReasonCallback,
                statusMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.MapStateProtocol.sMapStatusDidChangedCallback, "");
    }

    @Override
    public void onMapRenderFinished() {
        HashMap hashMap = new HashMap();
        hashMap.put("success", true);
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapDidFinishRenderCallback,
                        hashMap);
    }

    @Override
    public void onMapDrawFrame(GL10 gl10, MapStatus mapStatus) {

    }

    @Override
    public void onMapDrawFrame(MapStatus mapStatus) {
        if (null == mapStatus || mMethodChannel == null) {
            return;
        }
        HashMap<String, Double> targetScreenMap = new HashMap<>();
        Point targetScreen = mapStatus.targetScreen;
        if (null == targetScreen) {
            return;
        }
        targetScreenMap.put("x", (double) targetScreen.x);
        targetScreenMap.put("y", (double) targetScreen.y);
        HashMap<String, Double> targetMap = new HashMap<>();
        LatLng latLng = mapStatus.target;
        if (null == latLng) {
            return;
        }
        targetMap.put("latitude", latLng.latitude);
        targetMap.put("longitude", latLng.longitude);

        LatLngBounds bound = mapStatus.bound;
        if (null == bound) {
            return;
        }

        HashMap latLngBoundMap = latLngBounds(bound);
        if (null == latLngBoundMap) {
            return;
        }
        final HashMap<String, HashMap> statusMap = new HashMap<>();
        HashMap status = new HashMap();
        status.put("fLevel", ((double) mapStatus.zoom));
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
            rotate = rotate - 360;
        }
        status.put("fRotation", rotate);
        status.put("fOverlooking", ((double) mapStatus.overlook));
        status.put("targetScreenPt", targetScreenMap);
        status.put("targetGeoPt", targetMap);
        status.put("visibleMapBounds", latLngBoundMap);
        statusMap.put("mapStatus", status);

        ThreadPoolUtil.getInstance().execute(new Runnable() {
            @Override
            public void run() {
                Message msg = Message.obtain();
                msg.what = DRAW_FRAME_MESSAGE;
                msg.obj = statusMap;
                mHandler.sendMessage(msg);
            }
        });

    }

    @Override
    public void onBaseIndoorMapMode(boolean isIndoorMap,
                                    MapBaseIndoorMapInfo mapBaseIndoorMapInfo) {
        if (mMethodChannel == null) {
            return;
        }
        HashMap indoorHashMap = new HashMap();
        indoorHashMap.put("flag", isIndoorMap);
        HashMap indoorMap = new HashMap();
        if (isIndoorMap) {
            if (null == mapBaseIndoorMapInfo) {
                return;
            }
            String curFloor = mapBaseIndoorMapInfo.getCurFloor();
            String id = mapBaseIndoorMapInfo.getID();
            ArrayList<String> floors = mapBaseIndoorMapInfo.getFloors();
            indoorMap.put("strFloor", curFloor);
            indoorMap.put("strID", id);
            indoorMap.put("listStrFloors", floors);
        }
        indoorHashMap.put("info", indoorMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.MapStateProtocol.sMapInOrOutBaseIndoorMapCallback
                , indoorHashMap);
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        if (Env.DEBUG) {
            Log.d(TAG, "onMarkerClick");
        }

        if (null != mClusterMarkerClickListener) {
            mClusterMarkerClickListener.onMarkerClick(marker);
        }

        if (null == mMethodChannel) {
            return false;
        }

        Bundle bundle = marker.getExtraInfo();
        if (null == bundle) {
            if (Env.DEBUG) {
                Log.d(TAG, "bundle is null");
            }
            return false;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "marker id is null ");
            }
            return false;
        }

        Map<String, Object> markerMap = createMarkerMap(marker);
        if (null == markerMap) {
            return false;
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("marker", markerMap);

        mMethodChannel.invokeMethod(Constants.MethodProtocol.MarkerProtocol.sMapClickedmarkedMethod,
                resultMap);

        return true;
    }

    private Map<String, Object> createMarkerMap(Marker marker) {
        if (null == marker) {
            return null;
        }

        Bundle bundle = marker.getExtraInfo();
        if (null == bundle) {
            if (Env.DEBUG) {
                Log.d(TAG, "bundle is null");
            }
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "marker id is null ");
            }
            return null;
        }

        String icon = bundle.getString("icon");
        byte[] data = bundle.getByteArray("iconData");
        if (TextUtils.isEmpty(icon) && (data == null || data.length <= 0)) {
            return null;
        }

        // flutter解析时需要包一层map结构
        HashMap<String, Object> iconData = new HashMap<>();
        Map<String, Object> markerMap = new HashMap<>();
        markerMap.put("id", id);
        markerMap.put("title", marker.getTitle());
        if (!TextUtils.isEmpty(icon)) {
            markerMap.put("icon", icon);
        }
        if (data != null && data.length > 0) {
            iconData.put("data", data);
            markerMap.put("iconData", iconData);
        }
        markerMap.put("position", FlutterDataConveter.latLngToMap(marker.getPosition()));
        markerMap.put("isLockedToScreen", marker.isFixed());
        Map<String, Double> centerOffset = new HashMap<>();
        centerOffset.put("y", (double) marker.getYOffset());
        centerOffset.put("x", 0.0);
        markerMap.put("centerOffset", centerOffset);
        markerMap.put("enabled", marker.isClickable());
        markerMap.put("draggable", marker.isDraggable());
        markerMap.put("scaleX", marker.getScaleX());
        markerMap.put("scaleY", marker.getScaleY());
        markerMap.put("alpha", marker.getAlpha());
        markerMap.put("isPerspective", marker.isPerspective());
        markerMap.put("isPerspective", marker.isPerspective());
        markerMap.put("screenPointToLock",
                FlutterDataConveter.pointToMap(marker.getFixedPosition()));
        markerMap.put("rotation", marker.getRotate());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            markerMap.put("customMap", customMap);
        }

        return markerMap;
    }

    @Override
    public boolean onCircleClick(Circle circle) {
        Log.d("overlay", "circle click");

        HashMap hashMap = circleClick(circle);
        HashMap<String, Object> circleMap = new HashMap<>();
        circleMap.put("overlayType", OverlayType.Circle.ordinal());
        circleMap.put("overlay", hashMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PolylineProtocol.sMapOnClickedOverlayCallback,
                circleMap);

        return true;
    }

    private HashMap circleClick(Circle circle) {
        if (null == circle) {
            return null;
        }

        Bundle bundle = circle.getExtraInfo();
        if (null == bundle) {
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return null;
        }

        HashMap circleMap = new HashMap();

        circleMap.put("id", id);
        circleMap.put("zIndex", circle.getZIndex());
        circleMap.put("visible", circle.isVisible());

        HashMap<String, Double> centerMap = new HashMap<>();
        centerMap.put("latitude", circle.getCenter().latitude);
        centerMap.put("longitude", circle.getCenter().longitude);
        circleMap.put("center", centerMap);
        circleMap.put("radius", Double.valueOf(circle.getRadius()));
        circleMap.put("width", circle.getStroke().strokeWidth);
        circleMap.put("strokeColor", Integer.toHexString(circle.getStroke().color));
        circleMap.put("fillColor", Integer.toHexString(circle.getFillColor()));
        circleMap.put("lineDashType", circle.getDottedStrokeType());
        circleMap.put("clickable", circle.isClickable());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            circleMap.put("customMap", customMap);
        }

        return circleMap;
    }

    @Override
    public boolean onPolygonClick(Polygon polygon) {
        Log.d("overlay", "polygon click");

        HashMap hashMap = polygonClick(polygon);
        HashMap<String, Object> polygonMap = new HashMap<>();
        polygonMap.put("overlayType", OverlayType.Polygon.ordinal());
        polygonMap.put("overlay", hashMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PolylineProtocol.sMapOnClickedOverlayCallback,
                polygonMap);

        return true;
    }

    private HashMap polygonClick(Polygon polygon) {
        if (null == polygon) {
            return null;
        }

        Bundle bundle = polygon.getExtraInfo();
        if (null == bundle) {
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return null;
        }

        HashMap polygonMap = new HashMap();

        polygonMap.put("id", id);
        polygonMap.put("zIndex", polygon.getZIndex());
        polygonMap.put("visible", polygon.isVisible());

        List<LatLng> points = polygon.getPoints();
        List<Object> latlngLists = new ArrayList<>();
        if (null != points) {
            for (int i = 0; i < points.size(); i++) {
                HashMap<String, Double> latlngHashMap = new HashMap<>();
                latlngHashMap.put("latitude", points.get(i).latitude);
                latlngHashMap.put("longitude", points.get(i).longitude);
                latlngLists.add(latlngHashMap);
            }
        }
        polygonMap.put("coordinates", latlngLists);
        polygonMap.put("width", polygon.getStroke().strokeWidth);
        polygonMap.put("strokeColor", Integer.toHexString(polygon.getStroke().color));
        polygonMap.put("fillColor", Integer.toHexString(polygon.getFillColor()));
        // 目前polygon没有lineDashType，所以先设置为0，否则flutter会出现转换报错
        polygonMap.put("lineDashType", 0);
        polygonMap.put("clickable", polygon.isClickable());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            polygonMap.put("customMap", customMap);
        }

        return polygonMap;
    }

    @Override
    public boolean onGroundOverlayClick(GroundOverlay groundOverlay) {
        HashMap hashMap = groundClick(groundOverlay);
        HashMap<String, Object> groundMap = new HashMap<>();
        groundMap.put("overlayType", OverlayType.Ground.ordinal());
        groundMap.put("overlay", hashMap);

        Log.d("overlay", "ground click");

        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PolylineProtocol.sMapOnClickedOverlayCallback,
                groundMap);
        return true;
    }

    private HashMap groundClick(GroundOverlay ground) {
        if (null == ground) {
            return null;
        }

        Bundle bundle = ground.getExtraInfo();
        if (null == bundle) {
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return null;
        }

        String image = bundle.getString("image");
        if (TextUtils.isEmpty(image)) {
            return null;
        }

        HashMap groundMap = new HashMap();

        groundMap.put("id", id);
        groundMap.put("zIndex", ground.getZIndex());
        groundMap.put("visible", ground.isVisible());
        groundMap.put("image", image);
        groundMap.put("width", ground.getWidth());
        groundMap.put("height", ground.getHeight());
        groundMap.put("anchorX", Double.valueOf(ground.getAnchorX()));
        groundMap.put("anchorY", Double.valueOf(ground.getAnchorY()));

        if (ground.getPosition() != null) {
            HashMap<String, Double> positionMap = new HashMap<>();
            positionMap.put("latitude", ground.getPosition().latitude);
            positionMap.put("longitude", ground.getPosition().longitude);
            groundMap.put("position", positionMap);
        }

        if (ground.getBounds() != null && ground.getBounds().northeast != null
                && ground.getBounds().southwest != null) {
            HashMap<String, HashMap<String, Double>> bounds = new HashMap<>();
            HashMap<String, Double> northeast = new HashMap<>();
            HashMap<String, Double> southwest = new HashMap<>();

            northeast.put("latitude", ground.getBounds().northeast.latitude);
            northeast.put("longitude", ground.getBounds().northeast.longitude);
            bounds.put("northeast", northeast);

            southwest.put("latitude", ground.getBounds().southwest.latitude);
            southwest.put("longitude", ground.getBounds().southwest.longitude);
            bounds.put("southwest", southwest);

            groundMap.put("bounds", bounds);
        }

        groundMap.put("transparency", Double.valueOf(ground.getTransparency()));
        groundMap.put("clickable", ground.isClickable());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            groundMap.put("customMap", customMap);
        }

        return groundMap;
    }

    @Override
    public boolean onArcClick(Arc arc) {
        Log.d("overlay", "arc click");

        HashMap hashMap = arcLineClick(arc);
        HashMap<String, Object> arcLineMap = new HashMap<>();
        arcLineMap.put("overlayType", OverlayType.Arcline.ordinal());
        arcLineMap.put("overlay", hashMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PolylineProtocol.sMapOnClickedOverlayCallback,
                arcLineMap);

        return true;
    }

    private HashMap arcLineClick(Arc arc) {
        if (null == arc) {
            return null;
        }

        Bundle bundle = arc.getExtraInfo();
        if (null == bundle) {
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return null;
        }

        HashMap arcLineMap = new HashMap();
        arcLineMap.put("id", id);
        arcLineMap.put("zIndex", arc.getZIndex());
        arcLineMap.put("visible", arc.isVisible());

        if (arc.getStartPoint() == null || arc.getMiddlePoint() == null || arc.getEndPoint() == null) {
            return null;
        }

        List<LatLng> points = new ArrayList<>();
        points.add(arc.getStartPoint());
        points.add(arc.getMiddlePoint());
        points.add(arc.getEndPoint());

        List<Object> latlngLists = new ArrayList<>();
        if (null != points) {
            for (int i = 0; i < points.size(); i++) {
                HashMap<String, Double> latlngHashMap = new HashMap<>();
                latlngHashMap.put("latitude", points.get(i).latitude);
                latlngHashMap.put("longitude", points.get(i).longitude);
                latlngLists.add(latlngHashMap);
            }
        }
        arcLineMap.put("coordinates", latlngLists);
        arcLineMap.put("width", arc.getWidth());
        arcLineMap.put("color", Integer.toHexString(arc.getColor()));
        // 目前arc没有lineDashType，所以先设置为0，否则flutter会出现转换报错
        arcLineMap.put("lineDashType", 0);
        arcLineMap.put("clickable", arc.isClickable());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            arcLineMap.put("customMap", customMap);
        }

        return arcLineMap;
    }

    @Override
    public boolean onPolylineClick(Polyline polyline) {

        Log.d("overlay", "polyline click");

        HashMap hashMap = polylineClick(polyline);
        HashMap<String, Object> polyLineMap = new HashMap<>();
        polyLineMap.put("overlayType", OverlayType.Polyline.ordinal());
        polyLineMap.put("overlay", hashMap);
        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PolylineProtocol.sMapOnClickedOverlayCallback,
                polyLineMap);

        return true;
    }

    private HashMap polylineClick(Polyline polyline) {
        if (null == polyline) {
            return null;
        }

        Bundle bundle = polyline.getExtraInfo();
        if (null == bundle) {
            return null;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return null;
        }

        ArrayList<Integer> indexs = bundle.getIntegerArrayList("indexs");
        if (null == indexs) {
            return null;
        }

        ArrayList<String> textures = bundle.getStringArrayList("textures");

        HashMap polylineMap = new HashMap();

        List<LatLng> points = polyline.getPoints();
        List<Object> latlngLists = new ArrayList<>();
        if (null != points) {
            for (int i = 0; i < points.size(); i++) {
                HashMap<String, Double> latlngHashMap = new HashMap<>();
                latlngHashMap.put("latitude", points.get(i).latitude);
                latlngHashMap.put("longitude", points.get(i).longitude);
                latlngLists.add(latlngHashMap);
            }
        }
        polylineMap.put("id", id);
        polylineMap.put("coordinates", latlngLists);

        ArrayList<String> colorList = new ArrayList<>();
        int[] colors = polyline.getColorList();
        if (null != colors) {
            for (int i = 0; i < colors.length; i++) {
                colorList.add(Integer.toHexString(colors[i]));
            }
        }

        polylineMap.put("colors", colorList);

        polylineMap.put("color", polyline.getColor());
        polylineMap.put("dottedLine", false);
        polylineMap.put("lineDashType", polyline.getDottedLineType());
        polylineMap.put("lineCapType", 0);
        polylineMap.put("lineJoinType", 0);
        polylineMap.put("width", polyline.getWidth());
        polylineMap.put("zIndex", polyline.getZIndex());
        polylineMap.put("indexs", indexs);
        polylineMap.put("textures", textures);
        polylineMap.put("lineDirectionCross180", polyline.getLineDirectionCross180().ordinal());
        polylineMap.put("isThined", polyline.isThined());
        polylineMap.put("clickable", polyline.isClickable());
        polylineMap.put("isKeepScale", polyline.isIsKeepScale());
        polylineMap.put("isFocus", polyline.isFocus());
        polylineMap.put("lineBloomMode", polyline.getLineBloomType().ordinal());
        polylineMap.put("lineBloomWidth", Integer.valueOf(polyline.getBloomWidth()).doubleValue());
        polylineMap.put("lineBloomAlpha", Integer.valueOf(polyline.getBloomAlpha()).doubleValue());
        polylineMap.put("lineBloomGradientASPeed", Float.valueOf(polyline.getBloomGradientASpeed()).doubleValue());
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            polylineMap.put("customMap", customMap);
        }

        return polylineMap;
    }

    @Override
    public void onMapDoubleClick(LatLng latLng) {
        if (null == latLng || mMethodChannel == null) {
            return;
        }
        HashMap<String, HashMap> coordinateMap = new HashMap<>();
        HashMap<String, Double> coord = new HashMap<>();
        coord.put("latitude", latLng.latitude);
        coord.put("longitude", latLng.longitude);
        coordinateMap.put("coord", coord);
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapOnDoubleClickCallback,
                        coordinateMap);
    }

    @Override
    public void onMapLongClick(LatLng latLng) {
        if (null == latLng || mMethodChannel == null) {
            return;
        }
        HashMap<String, HashMap> coordinateMap = new HashMap<>();
        HashMap<String, Double> coord = new HashMap<>();
        coord.put("latitude", latLng.latitude);
        coord.put("longitude", latLng.longitude);
        coordinateMap.put("coord", coord);
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapOnLongClickCallback,
                        coordinateMap);
    }

    @Override
    public void onMarkerDrag(Marker marker) {
        if (Env.DEBUG) {
            Log.d(TAG, "onMarkerDrag");
        }
        if (null == mMethodChannel) {
            return;
        }

        Map<String, Object> markerMap = createMarkerMap(marker);
        if (null == markerMap) {
            return;
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("marker", markerMap);
        resultMap.put("oldState", MarkerDragState.Starting.ordinal());
        resultMap.put("newState", MarkerDragState.Dragging.ordinal());

        mMethodChannel.invokeMethod(Constants.MethodProtocol.MarkerProtocol.sMapDragMarkerMethod,
                resultMap);
    }

    @Override
    public void onMarkerDragEnd(Marker marker) {
        if (Env.DEBUG) {
            Log.d(TAG, "onMarkerDrag");
        }
        if (null == mMethodChannel) {
            return;
        }

        Map<String, Object> markerMap = createMarkerMap(marker);
        if (null == markerMap) {
            return;
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("marker", markerMap);
        resultMap.put("oldState", MarkerDragState.Dragging.ordinal());
        resultMap.put("newState", MarkerDragState.Ending.ordinal());

        mMethodChannel.invokeMethod(Constants.MethodProtocol.MarkerProtocol.sMapDragMarkerMethod,
                resultMap);
    }

    @Override
    public void onMarkerDragStart(Marker marker) {
        if (Env.DEBUG) {
            Log.d(TAG, "onMarkerDrag");
        }

        Map<String, Object> markerMap = createMarkerMap(marker);
        if (null == markerMap) {
            return;
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("marker", markerMap);
        resultMap.put("oldState", MarkerDragState.None.ordinal());
        resultMap.put("newState", MarkerDragState.Starting.ordinal());

        mMethodChannel.invokeMethod(Constants.MethodProtocol.MarkerProtocol.sMapDragMarkerMethod,
                resultMap);
    }

    @Override
    public void onMapRenderValidData(boolean isValid, int errorCode, String errorMessage) {
        HashMap hashMap = new HashMap();
        hashMap.put("isValid", isValid);
        hashMap.put("errorCode", errorCode);
        hashMap.put("errorMessage", errorMessage);
        mMethodChannel
                .invokeMethod(Constants.MethodProtocol.MapStateProtocol.sMapRenderValidDataCallback,
                        hashMap);
    }

    @Override
    public boolean onMyLocationClick() {
        return false;
    }

    private HashMap latLngBounds(LatLngBounds latLngBounds) {
        if (null == latLngBounds) {
            return null;
        }
        // 该地理范围东北坐标
        LatLng northeast = latLngBounds.northeast;
        // 该地理范围西南坐标
        LatLng southwest = latLngBounds.southwest;

        HashMap boundsMap = new HashMap();
        HashMap northeastMap = new HashMap<String, Double>();
        if (null == northeast) {
            return null;
        }
        northeastMap.put("latitude", northeast.latitude);
        northeastMap.put("longitude", northeast.longitude);
        HashMap southwestMap = new HashMap<String, Double>();
        if (null == southwest) {
            return null;
        }
        southwestMap.put("latitude", southwest.latitude);
        southwestMap.put("longitude", southwest.longitude);
        boundsMap.put("northeast", northeastMap);
        boundsMap.put("southwest", southwestMap);
        return boundsMap;
    }

    @Override
    public boolean onMultiPointClick(final MultiPoint multiPoint, final MultiPointItem multiPointItem) {
        if (Env.DEBUG) {
            Log.d(TAG, "onMultiPointClick");
        }
        if (null == mMethodChannel) {
            Log.d(TAG, "onMultiPointClick mMethodChannel");
            return false;
        }
        if (null == multiPoint || null == multiPointItem) {
            if (Env.DEBUG) {
                Log.d(TAG, "onMultiPointClick multiPoint or multiPointItem  is null");
            }
            return false;
        }

        Bundle bundle = multiPoint.getExtraInfo();
        if (null == bundle) {
            if (Env.DEBUG) {
                Log.d(TAG, "bundle is null");
                return false;
            }
            return false;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "MultiPoint id is null ");
            }
            return false;
        }
        Map<String, Object> resultMap = new HashMap<>();

        Map<String, Object> itemMap = new HashMap<>();
        Map<String, Object> latLngMap = new HashMap<>();
        LatLng point = multiPointItem.getPoint();
        latLngMap.put("latitude", point.latitude);
        latLngMap.put("longitude", point.longitude);
        itemMap.put("coordinate", latLngMap);
        itemMap.put("title", multiPointItem.getTitle());

        Map<String, Object> multiPointOverlayMap = setMultiPoint(multiPoint);
        String icon = (String) bundle.get("icon");
        if (TextUtils.isEmpty(icon)) {
            multiPointOverlayMap.put("icon", icon);
        } else {
            multiPointOverlayMap.put("icon", "");
        }
        multiPointOverlayMap.put("id", id);
        resultMap.put("multiPointOverlay", multiPointOverlayMap);
        resultMap.put("item", itemMap);
        HashMap<String, Object> customMap =
                (HashMap<String, Object>) bundle.getSerializable("customMap");
        if (customMap != null && customMap.size() > 0) {
            resultMap.put("customMap", customMap);
        }

        mMethodChannel.invokeMethod(Constants.MethodProtocol.MapStateProtocol.
                        MAP_ON_CLICK_MULTI_POINT_OVERLAY_ITEM_CALLBACK,
                resultMap, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        if (Env.DEBUG) {
                            Log.d(TAG, "onMultiPointClick mMethodChannel is success: ");
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage,
                                      @Nullable Object errorDetails) {
                        if (Env.DEBUG) {
                            Log.d(TAG, "onMultiPointClick is error: errorCode "
                                    + errorCode + " errorMessage "
                                    + errorMessage);
                        }
                    }

                    @Override
                    public void notImplemented() {

                    }
                });
        return false;
    }

    private Map<String, Object> setMultiPoint(MultiPoint multiPoint) {
        Map<String, Object> multiPointMap = new HashMap<>();
//        List<MultiPointItem> multiPointItems = multiPoint.getMultiPointItems();
//        ArrayList<Map<String, Object>> itemList = new ArrayList<>();
//        for (int i = 0; i < multiPointItems.size(); i++) {
//            Map<String, Object> multiItemMap = new HashMap<>();
//            Map<String, Object> latLngObMap = new HashMap<>();
//            MultiPointItem multiItem = multiPointItems.get(i);
//            LatLng point = multiItem.getPoint();
//            latLngObMap.put("latitude", point.latitude);
//            latLngObMap.put("longitude", point.longitude);
//            multiItemMap.put("coordinate", latLngObMap);
//            multiItemMap.put("title", multiItem.getTitle());
//            itemList.add(multiItemMap);
//            multiPointMap.put("items", itemList);
//        }
        Map<String, Object> pointSizeMap = new HashMap<>();
        pointSizeMap.put("width", (double) multiPoint.getPointSizeWidth());
        pointSizeMap.put("height", (double) multiPoint.getPointSizeHeight());
        multiPointMap.put("pointSize", pointSizeMap);
        Map<String, Object> anchorMap = new HashMap<>();
        anchorMap.put("x", (double) multiPoint.getAnchorX());
        anchorMap.put("y", (double) multiPoint.getAnchorY());
        multiPointMap.put("anchor", anchorMap);
        return multiPointMap;
    }

    @Override
    public void frameIndex(int index) {
        if (mMethodChannel == null) {
            return;
        }
        final HashMap<String, Integer> hashMap = new HashMap<>();
        hashMap.put("index", index);
        ThreadPoolUtil.getInstance().execute(new Runnable() {
            @Override
            public void run() {
                Message msg = Message.obtain();
                msg.what = FRAME_INDEX_MESSAGE;
                msg.obj = hashMap;
                mHandler.sendMessage(msg);
            }
        });
    }

    @Override
    public void onBuildingFloorAnimationStop(Building building) {
        if (building == null) {
            return;
        }

        Bundle bundle = building.getExtraInfo();
        if (null == bundle) {
            return;
        }

        String id = bundle.getString("id");
        if (TextUtils.isEmpty(id)) {
            return;
        }

        if (building.getTopFaceColor() == 0) {
            return;
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("id", id);
        resultMap.put("zIndex", building.getZIndex());
        resultMap.put("visible", building.isVisible());

        resultMap.put("topFaceColor", Integer.toHexString(building.getTopFaceColor()));
        resultMap.put("sideFaceColor", Integer.toHexString(building.getSideFaceColor()));
        resultMap.put("height", Float.valueOf(building.getHeight()).intValue());
        BuildingInfo buildingInfo = building.getBuildingInfo();
        if (buildingInfo != null && buildingInfo.getHeight() > 0
                && !TextUtils.isEmpty(buildingInfo.getGeom())) {
            Map<String, Object> buildingInfoMap = new HashMap<>();
            buildingInfoMap.put("height", Double.valueOf(buildingInfo.getHeight()));
            buildingInfoMap.put("paths", buildingInfo.getGeom());
            buildingInfoMap.put("accuracy", buildingInfo.getAccuracy());
            HashMap centerMap = new HashMap<String, Double>();
            if (null != centerMap) {
               LatLng center = buildingInfo.getCenter();
               if (center != null) {
                   centerMap.put("latitude", center.latitude);
                   centerMap.put("longitude", center.longitude);
               }

            }
            buildingInfoMap.put("center", centerMap);

            resultMap.put("buildInfo", buildingInfoMap);
        }

        resultMap.put("showLevel", building.getShowLevel());
        resultMap.put("floorColor", Integer.toHexString(building.getFloorColor()));
        resultMap.put("floorHeight", building.getFloorHeight());

        List<LatLng> points = building.getPoints();
        List<Object> latlngLists = new ArrayList<>();
        if (null != points && points.size() > 0) {
            for (int i = 0; i < points.size(); i++) {
                HashMap<String, Double> latlngHashMap = new HashMap<>();
                latlngHashMap.put("latitude", points.get(i).latitude);
                latlngHashMap.put("longitude", points.get(i).longitude);
                latlngLists.add(latlngHashMap);
            }
        }
        resultMap.put("coordinates", latlngLists);

        HashMap<String, Object> buildingMap = new HashMap<>();
        buildingMap.put("prismOverlay", resultMap);

        mMethodChannel.invokeMethod(
                Constants.MethodProtocol.PrismProtocol.PRISM_OVERLAY_ANIMATION_DID_END_CALLBACK,
                buildingMap);
    }

    private enum OverlayType {
        None,

        // text
        Text,
        Ground,
        Arcline,
        Circle,
        Polyline,
        Polygon,
        MultiPoint,
        Prism,

        // 3d模型
        ThreeDModel,
        GradientLine,
    }

    private ClusterMarkerClickListener mClusterMarkerClickListener;
    private ClusterMapStatusChangeListener mClusterMapStatusChangeListener;

    public void setOnClusterMarkerClickListener(ClusterMarkerClickListener listener) {
        mClusterMarkerClickListener = listener;
    }

    public void setOnClusterMapStatusChangeListener(ClusterMapStatusChangeListener listener) {
        mClusterMapStatusChangeListener = listener;
    }

}

