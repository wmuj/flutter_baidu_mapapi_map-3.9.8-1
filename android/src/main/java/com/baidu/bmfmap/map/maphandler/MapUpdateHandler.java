package com.baidu.bmfmap.map.maphandler;

import android.content.Context;
import android.graphics.Point;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.map.FlutterMapViewWrapper;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapLanguage;
import com.baidu.mapapi.map.MapLayer;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.PoiTagType;
import com.baidu.mapapi.map.UiSettings;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MapUpdateHandler extends BMapHandler {

    private static final String TAG = "MapUpdateHandler";
    private BaiduMap mBaiduMap;
    private FlutterMapViewWrapper mFlutterMapViewWrapper;

    public MapUpdateHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
        mBaiduMap = bmfMapController.getBaiduMap();
        mFlutterMapViewWrapper = bmfMapController.getFlutterMapViewWrapper();
    }

    @Override
    public void handlerMethodCallResult(Context context, MethodCall call, MethodChannel.Result result) {
        if (null == call) {
            result.success(false);
            return;
        }
        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            result.success(false);
            return;
        }

        switch (methodId) {
            case Constants.MethodProtocol.MapStateProtocol.sMapZoomInMethod:
                zoomIN(result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapZoomOutMethod:
                zoomOut(result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetCenterCoordinateMethod:
                setNewLatlng(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetCenterZoomMethod:
                setNewLatLngZoom(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetMapStatusMethod:
                setMapStatus(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetScrollByMethod:
                setScrollBy(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetZoomByMethod:
                setZoomBy(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetZoomPointByMethod:
                setZoomPointBy(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapSetZoomToMethod:
                setZoomTo(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.sMapGetMapStatusMethod:
                getMapStatus(call, result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetMapTypeMethod:
                getMapType(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.MAP_GET_MAPLANGUAGE_TYPE_METHOD:
                getMapLanguage(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.MAP_GET_MAP_FONTSIZE_LEVEL_METHOD:
                getMapFontLevel(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetZoomLevelMethod:
                getZoomLevel(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetMinZoomLevelMethod:
                getMinZoomLevel(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetMaxZoomLevelMethod:
                getMaxZoomLevel(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetRotationMethod:
                getRotation(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetOverlookingMethod:
                getOverlooking(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetBuildingsEnabledMethod:
                getBuildingsEnable(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetTrafficEnabledMethod:
                getTrafficEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetBaiduHeatMapEnabledMethod:
                getBaiduHeatMapEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetGesturesEnabledMethod:
                getGesturesEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetZoomEnabledMethod:
                getZoomEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetScrollEnabledMethod:
                getScrollEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetOverlookEnabledMethod:
                getOverlookEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetRotateEnabledMethod:
                getRotateEnabled(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetMapScaleBarPositionMethod:
                getScaleControlPosition(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetLogoPositionMethod:
                getLogoPosition(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetVisibleMapBoundsMethod:
                getVisibleMapBounds(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetBaseIndoorMapEnabledMethod:
                getBaseIndoorMapEnable(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.sMapGetShowIndoorMapPoiMethod:
                getShowIndoorMapPoiEnable(result);
                break;
            case Constants.MethodProtocol.BMFMapGetPropertyMethodId.MAP_GET_SHOW_OPERATE_LAYER_METHOD:
                getShowOperateLayer(result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.SWITCH_OVERLAY_LAYER_AND_POI_LAYER:
                setOverlayUnderPoi(call, result);
                break;
            case Constants.MethodProtocol.MapStateProtocol.SWITCH_OVERLAY_LAYER_AND_POI_TAG_TYPE:
                setPoiTagEnable(call, result);
            case Constants.MethodProtocol.MapStateProtocol.SWITCH_LAYER_ORDER:
                setSwitchLayerOrder(call, result);
                break;
            default:
                break;
        }
    }

    private void setSwitchLayerOrder(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("layer") || !argument.containsKey("otherLayer")) {
            result.success(false);
            return;
        }

        Integer layer = (Integer) argument.get("layer");
        if (null == layer) {
            result.success(false);
            return;
        }

        Integer otherLayer = (Integer) argument.get("otherLayer");
        if (null == otherLayer) {
            result.success(false);
            return;
        }

        MapLayer tempLayer;
        MapLayer tempOtherLayer;

        /** android跟ios有枚举值的区别，flutter是以ios为准，对flutter层传过来的枚举值进行转换 */
        if (layer.intValue() == 1) {
            tempLayer = MapLayer.MAP_LAYER_HEATMAP;
        } else if (layer.intValue() == 2) {
            tempLayer = MapLayer.BM_LAYER_OVERLAY;
        } else {
            tempLayer = MapLayer.values()[layer.intValue()];
        }

        if (otherLayer.intValue() == 1) {
            tempOtherLayer = MapLayer.MAP_LAYER_HEATMAP;
        } else if (otherLayer.intValue() == 2) {
            tempOtherLayer = MapLayer.BM_LAYER_OVERLAY;
        } else {
            tempOtherLayer = MapLayer.values()[otherLayer.intValue()];
        }

        mBaiduMap.switchLayerOrder(tempLayer, tempOtherLayer);
    }

    private void setPoiTagEnable(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("poiTagEnable") || !argument.containsKey("poiTagType")) {
            result.success(false);
            return;
        }

        Boolean poiTagEnable = (Boolean) argument.get("poiTagEnable");
        if (null == poiTagEnable) {
            result.success(false);
            return;
        }

        Integer poiTagType = (Integer) argument.get("poiTagType");
        if (null == poiTagType) {
            result.success(false);
            return;
        }

        mBaiduMap.setPoiTagEnable(PoiTagType.values()[poiTagType], poiTagEnable);
        result.success(true);
    }

    private void setOverlayUnderPoi(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("isSwitch")) {
            result.success(false);
            return;
        }

        Boolean isSwitch = (Boolean) argument.get("isSwitch");
        if (null == isSwitch) {
            result.success(false);
            return;
        }
        mBaiduMap.setOverlayUnderPoi(isSwitch);
        result.success(true);
    }

    private void getShowOperateLayer(MethodChannel.Result result) {
        if (null == result) {
            return;
        }
        HashMap<String,Boolean> showOperateLayerMapEnabledHashMap = new HashMap<>();
        boolean isShowOperateLayerEnable = BMFMapStatus.getsInstance().isShowOperateLayerEnable();
        showOperateLayerMapEnabledHashMap.put("showOperateLayer", isShowOperateLayerEnable);
        result.success(showOperateLayerMapEnabledHashMap);
    }

    /**
     * 获取map的显示室内图
     */
    private void getBaseIndoorMapEnable(MethodChannel.Result result) {
        if (null == result) {
            return;
        }
        HashMap<String,Boolean> baseIndoorMapEnabledHashMap = new HashMap<>();

        boolean baseIndoorMapMode = BMFMapStatus.getsInstance().isBaseIndoorEnable();
        baseIndoorMapEnabledHashMap.put("baseIndoorMapEnabled",baseIndoorMapMode);
        result.success(baseIndoorMapEnabledHashMap);
    }

    /**
     * 获取map的显示室内图
     */
    private void getShowIndoorMapPoiEnable(MethodChannel.Result result) {
        if (null == result) {
            return;
        }
        HashMap<String,Boolean> showIndoorMapPoiEnabledHashMap = new HashMap<>();

        boolean indoorMapPoiEnable = BMFMapStatus.getsInstance().isIndoorMapPoiEnable();
        showIndoorMapPoiEnabledHashMap.put("showIndoorMapPoi",indoorMapPoiEnable);
        result.success(showIndoorMapPoiEnabledHashMap);
    }

    /**
     * 获取map的可视范围
     */
    private void getVisibleMapBounds(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Object> latLngBoundsHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if (null == mapStatus) {
            return;
        }
        LatLngBounds bound = mapStatus.bound;
        HashMap latLngBounds = latLngBounds(bound);
        if (null == latLngBoundsHashMap) {
            return;
        }
        latLngBoundsHashMap.put("visibleMapBounds",latLngBounds);
        result.success(latLngBoundsHashMap);
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
        HashMap northeastMap = new HashMap<String,Double>();
        if (null == northeast){
            return null;
        }
        northeastMap.put("latitude", northeast.latitude);
        northeastMap.put("longitude",northeast.longitude);
        HashMap southwestMap = new HashMap<String,Double>();
        if (null == southwest) {
            return null;
        }
        southwestMap.put("latitude",southwest.latitude);
        southwestMap.put("longitude", southwest.longitude);
        boundsMap.put("northeast",northeastMap);
        boundsMap.put("southwest",southwestMap);
        return boundsMap;
    }

    /**
     *  获取map的logo位置
     */
    private void getLogoPosition(MethodChannel.Result result) {
        if (null == result) {
            return;
        }
        if (null == mFlutterMapViewWrapper) {
            result.success(null);
            return;
        }

        HashMap<String, Integer> logoPositionHashMap = new HashMap<>();
        LogoPosition logoPosition = mFlutterMapViewWrapper.getLogoPosition();
        if (null == logoPosition) {
            result.success(null);
            return;
        }
        switch (logoPosition) {
            case logoPostionleftBottom:
                logoPositionHashMap.put("logoPosition",0);
                break;
            case logoPostionleftTop:
                logoPositionHashMap.put("logoPosition",1);
                break;
            case logoPostionCenterBottom:
                logoPositionHashMap.put("logoPosition",2);
                break;
            case logoPostionCenterTop:
                logoPositionHashMap.put("logoPosition",3);
                break;
            case logoPostionRightBottom:
                logoPositionHashMap.put("logoPosition",4);
                break;
            case logoPostionRightTop:
                logoPositionHashMap.put("logoPosition",5);
                break;
            default:
                break;
        }
        result.success(logoPositionHashMap);
    }

    /**
     *  获取map的比例尺的位置
     *
     *  要在setScaleControlPosition后才可以获取否则返回null
     */
    private void getScaleControlPosition(final MethodChannel.Result result) {
        if (null == result) {
            return;
        }
        if (null == mFlutterMapViewWrapper) {
            result.success(null);
            return;
        }
        HashMap<String, Object> scaleControlPositionHashMap = new HashMap<>();
        HashMap<String, Double> pointHashMap = new HashMap<>();
        Point scaleControlPosition = mFlutterMapViewWrapper.getScaleControlPosition();
        if (null == scaleControlPosition) {
            result.success(null);
            return;
        }
        double x = scaleControlPosition.x;
        double y = scaleControlPosition.y;
        pointHashMap.put("x",x);
        pointHashMap.put("y",y);
        scaleControlPositionHashMap.put("mapScaleBarPosition",pointHashMap);
        result.success(scaleControlPositionHashMap);
    }

    /**
     *  获取map是否支持旋转
     */
    private void getRotateEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> rotateGesturesEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }

        UiSettings uiSettings = mBaiduMap.getUiSettings();
        boolean rotateGesturesEnabled = uiSettings.isRotateGesturesEnabled();
        rotateGesturesEnabledHashMap.put("rotateEnabled",rotateGesturesEnabled);
        result.success(rotateGesturesEnabledHashMap);
    }

    /**
     *  获取map是否支持俯仰角
     */
    private void getOverlookEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> scrollEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }

        UiSettings uiSettings = mBaiduMap.getUiSettings();
        boolean overlookingGesturesEnabled = uiSettings.isOverlookingGesturesEnabled();
        scrollEnabledHashMap.put("overlookEnabled",overlookingGesturesEnabled);
        result.success(scrollEnabledHashMap);
    }

    /**
     *  获取map是否支持拖拽手势
     */
    private void getScrollEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> scrollEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }

        UiSettings uiSettings = mBaiduMap.getUiSettings();
        boolean scrollGesturesEnabled = uiSettings.isScrollGesturesEnabled();
        scrollEnabledHashMap.put("scrollEnabled",scrollGesturesEnabled);
        result.success(scrollEnabledHashMap);
    }

    /**
     *  获取map是否支持缩放
     */
    private void getZoomEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> zoomGesturesEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }

        UiSettings uiSettings = mBaiduMap.getUiSettings();
        boolean zoomGesturesEnabled = uiSettings.isZoomGesturesEnabled();
        zoomGesturesEnabledHashMap.put("zoomEnabled",zoomGesturesEnabled);
        result.success(zoomGesturesEnabledHashMap);
    }

    /**
     * 获取地图的所有手势
     */
    private void getGesturesEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> gesturesEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }

        UiSettings uiSettings = mBaiduMap.getUiSettings();
        if (uiSettings.isRotateGesturesEnabled() && uiSettings.isScrollGesturesEnabled()
                && uiSettings.isOverlookingGesturesEnabled() && uiSettings.isZoomGesturesEnabled()) {
            gesturesEnabledHashMap.put("gesturesEnabled",true);
            result.success(gesturesEnabledHashMap);
        } else {
            gesturesEnabledHashMap.put("gesturesEnabled",false);
            result.success(gesturesEnabledHashMap);
        }
    }

    /**
     * 获取是否开启百度热力图
     */
    private void getBaiduHeatMapEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> baiduHeatMapEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        boolean baiduHeatMapEnabled = mBaiduMap.isBaiduHeatMapEnabled();
        baiduHeatMapEnabledHashMap.put("baiduHeatMapEnabled",baiduHeatMapEnabled);
        result.success(baiduHeatMapEnabledHashMap);
    }

    /**
     * 获取是否开启路况
     */
    private void getTrafficEnabled(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> trafficEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        boolean trafficEnabled = mBaiduMap.isTrafficEnabled();
        trafficEnabledHashMap.put("trafficEnabled",trafficEnabled);
        result.success(trafficEnabledHashMap);
    }


    /**
     * 获取map是否现显示3D楼块效果
     */
    private void getBuildingsEnable(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String,Boolean> buildingsEnabledHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        boolean isBuildingsEnabled = mBaiduMap.isBuildingsEnabled();
        buildingsEnabledHashMap.put("buildingsEnabled",isBuildingsEnabled);
        result.success(buildingsEnabledHashMap);
    }

    /**
     * 获取map的地图俯视角度
     */
    private void getOverlooking(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Double> overlookHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        double overlook = mapStatus.overlook;
        overlookHashMap.put("overlooking",overlook);
        result.success(overlookHashMap);
    }

    /**
     * 获取map的旋转角度
     */
    private void getRotation(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Double> rotationHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        double rotate = mapStatus.rotate;
        if (rotate > 180) {
          rotate = rotate - 360;
        }
        rotationHashMap.put("rotation",rotate);
        result.success(rotationHashMap);
    }

    /**
     * 获取地图最大缩放级别
     */
    private void getMaxZoomLevel(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> maxZoomLevelHashMap = new HashMap<>();
        int maxZoomLevel = (int) mBaiduMap.getMaxZoomLevel();
        maxZoomLevelHashMap.put("maxZoomLevel",maxZoomLevel);
        result.success(maxZoomLevelHashMap);
    }

    /**
     * 获取地图最小缩放级别
     */
    private void getMinZoomLevel(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> minZoomLevelHashMap = new HashMap<>();
        int minZoomLevel = (int) mBaiduMap.getMinZoomLevel();
        minZoomLevelHashMap.put("minZoomLevel",minZoomLevel);
        result.success(minZoomLevelHashMap);
    }

    /**
     * 获取地图缩放级别
     */
    private void getZoomLevel(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> zoomHashMap = new HashMap<>();
        MapStatus mapStatus = mBaiduMap.getMapStatus();
        if(null == mapStatus) {
            return;
        }
        int zoom = (int) mapStatus.zoom;
        zoomHashMap.put("zoomLevel",zoom);
        result.success(zoomHashMap);
    }

    /**
     * 获取地图类型
     */
    private void getMapType(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> mapTypeHashMap = new HashMap<>();
        int mapType = mBaiduMap.getMapType();
        if(mapType == BaiduMap.MAP_TYPE_NONE) {
            mapTypeHashMap.put("mapType",0);
        }else if (mapType == BaiduMap.MAP_TYPE_NORMAL) {
            mapTypeHashMap.put("mapType",1);
        }else if (mapType == BaiduMap.MAP_TYPE_SATELLITE) {
            mapTypeHashMap.put("mapType",2);
        }
        result.success(mapTypeHashMap);
    }

    /**
     * 获取地图类型
     */
    private void getMapLanguage(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> mapTypeHashMap = new HashMap<>();
        MapLanguage mapLanguage = mBaiduMap.getMapLanguage();
        if (mapLanguage == MapLanguage.CHINESE) {
            mapTypeHashMap.put("languageType", 0);
        } else if (mapLanguage == MapLanguage.ENGLISH) {
            mapTypeHashMap.put("languageType", 1);
        }
        result.success(mapTypeHashMap);
    }

    /**
     * 获取地图类型
     */
    private void getMapFontLevel(MethodChannel.Result result) {
        if (null == result || null == mBaiduMap) {
            return;
        }
        HashMap<String, Integer> mapTypeHashMap = new HashMap<>();
        int fontSizeLevel = mBaiduMap.getFontSizeLevel();
        if (fontSizeLevel == 0) {
            mapTypeHashMap.put("fontSizeLevel", 0);
        } else if (fontSizeLevel == 1) {
            mapTypeHashMap.put("fontSizeLevel", 1);
        } else if (fontSizeLevel == 2) {
            mapTypeHashMap.put("fontSizeLevel", 2);
        } else if (fontSizeLevel == 3) {
            mapTypeHashMap.put("fontSizeLevel", 3);
        }
        result.success(mapTypeHashMap);
    }

    /**
     * 设置地图缩放级别
     */
    private void setZoomTo(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("zoom") || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }

        Double zoom = (Double) argument.get("zoom");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");

        if (null != zoom && null != animateDurationMs) {
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomTo(zoom.floatValue());
            mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
            result.success(true);
        } else if (null != zoom) {
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomTo(zoom.floatValue());
            mBaiduMap.setMapStatus(mapStatusUpdate);
            result.success(true);
        } else {
            result.success(false);
        }
    }

    /**
     * 缩小地图缩放级别
     */
    private void zoomOut(MethodChannel.Result result) {
        if (null == mBaiduMap) {
            result.success(false);
            return;
        }
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomOut();
        mBaiduMap.setMapStatus(mapStatusUpdate);
        result.success(true);
    }

    /**
     * 放大地图缩放级别
     */
    private void zoomIN(MethodChannel.Result result) {
        if (null == mBaiduMap) {
            result.success(false);
            return;
        }
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomIn();
        mBaiduMap.setMapStatus(mapStatusUpdate);
        result.success(true);
    }

    /**
     * 根据给定增量以及给定的屏幕坐标缩放地图级别
     */
    private void setZoomPointBy(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("amount") || !argument.containsKey("focus")
                || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }

        Double amount = (Double) argument.get("amount");
        Map<String,Double> focus = (Map<String, Double>) argument.get("focus");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");

        if (null != amount && null != focus && null != animateDurationMs) {
            Double x = focus.get("x");
            Double y = focus.get("y");
            if (x == null || y == null) {
                result.success(false);
                return ;
            }

            Point point = new Point(x.intValue(), y.intValue());
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomBy(amount.floatValue(),point);
            mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
            result.success(true);
        } else if (null != amount && null != focus) {
            Double x = focus.get("x");
            Double y = focus.get("y");
            if (x == null || y == null) {
                result.success(false);
                return;
            }

            Point point = new Point(x.intValue(), y.intValue());
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomBy(amount.floatValue(),point);
            mBaiduMap.setMapStatus(mapStatusUpdate);
            result.success(true);
        } else {
            result.success(false);
        }

    }

    /**
     * 根据给定增量缩放地图级别
     */
    private void setZoomBy(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("amount") || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }

        Double amount = (Double) argument.get("amount");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");
        if (null !=  amount && null != animateDurationMs) {
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomBy(amount.floatValue());
            mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
            result.success(true);
        } else if (null != amount) {
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.zoomBy(amount.floatValue());
            mBaiduMap.setMapStatus(mapStatusUpdate);
            result.success(true);
        } else {
            result.success(false);
        }
    }

    /**
     * 按像素移动地图中心点
     */
    private void setScrollBy(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("xPixel")
                || !argument.containsKey("yPixel")
                || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }
       Integer xPixel = (Integer) argument.get("xPixel");
       Integer yPixel = (Integer) argument.get("yPixel");
       Integer animateDurationMs = (Integer) argument.get("animateDurationMs");

       if (null !=  xPixel && null != yPixel && null != animateDurationMs) {
           MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.scrollBy(xPixel,yPixel);
           mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
           result.success(true);
       } else if (null !=  xPixel && null != yPixel) {
           MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.scrollBy(xPixel,yPixel);
           mBaiduMap.setMapStatus(mapStatusUpdate);
           result.success(true);
       } else {
           result.success(false);
       }
    }

    /**
     * 设置地图新状态
     */
    private void setMapStatus(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("mapStatus") || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }

        Map<String, Object> mapStatus = (Map<String, Object>) argument.get("mapStatus");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");
        if (null != mapStatus && null != animateDurationMs) {
            boolean b = setAnimateMapStatusImp(mapStatus, animateDurationMs);
            result.success(b);
        } else if (null != mapStatus) {
            boolean b = setMapStatusImp(mapStatus);
            result.success(b);
        } else {
            result.success(false);
        }
    }

    /**
     * 获取地图新状态
     */
    private void getMapStatus(MethodCall call, MethodChannel.Result result) {
        MapStatus mapStatus = mBaiduMap.getMapStatus();

        final HashMap<String, Object> mapStatusMap = new HashMap<>();
        mapStatusMap.put("fLevel", mapStatus.zoom);
        mapStatusMap.put("fRotation", mapStatus.rotate);
        mapStatusMap.put("fOverlooking", mapStatus.overlook);
        mapStatusMap.put("targetScreenPt", FlutterDataConveter.pointToMap(mapStatus.targetScreen));
        mapStatusMap.put("targetGeoPt", FlutterDataConveter.latLngToMap(mapStatus.target));
        mapStatusMap.put("visibleMapBounds", FlutterDataConveter.latlngBoundsToMap(mapStatus.bound));

        result.success(new HashMap<String, Object>(){
            {
                put("mapStatus", mapStatusMap);
            }
        });
    }

    /**
     * 动画形式更新地图状态参数配置
     */
    private boolean setAnimateMapStatusImp(Map<String, Object> mapStatusParameter, Integer animateDurationMs) {
        if (!mapStatusParameter.containsKey("fLevel")
                || !mapStatusParameter.containsKey("fRotation")
                || !mapStatusParameter.containsKey("fOverlooking")
                || !mapStatusParameter.containsKey("targetScreenPt")
                || !mapStatusParameter.containsKey("targetGeoPt")) {
            return false;
        }
        MapStatus mapStatus = mapStatusImp(mapStatusParameter);

        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mapStatus);
        mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
        return true;
    }

    /**
     * 更新地图状态参数配置
     */
    private boolean setMapStatusImp(Map<String, Object> mapStatusParameter) {
        if (!mapStatusParameter.containsKey("fLevel")
                || !mapStatusParameter.containsKey("fRotation")
                || !mapStatusParameter.containsKey("fOverlooking")
                || !mapStatusParameter.containsKey("targetScreenPt")
                || !mapStatusParameter.containsKey("targetGeoPt")) {
            return false;
        }
        MapStatus mapStatus = mapStatusImp(mapStatusParameter);
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mapStatus);
        mBaiduMap.setMapStatus(mapStatusUpdate);
        return true;
    }

    private MapStatus mapStatusImp(Map<String, Object> mapStatusParameter){
        MapStatus.Builder builder = new MapStatus.Builder();
        Double fLevel = (Double) mapStatusParameter.get("fLevel");
        if (null != fLevel) {
            builder.zoom(fLevel.floatValue());
        }
        Double fRotation = (Double) mapStatusParameter.get("fRotation");
        if (null != fRotation) {
            builder.rotate(fRotation.floatValue());
        }
        Double fOverlooking = (Double) mapStatusParameter.get("fOverlooking");
        if (null != fOverlooking) {
            builder.overlook(fOverlooking.floatValue());
        }
        Map<String, Double> targetScreenPt = (Map<String, Double>) mapStatusParameter.get("targetScreenPt");
        if (null != targetScreenPt) {
            if (targetScreenPt.containsKey("x") && targetScreenPt.containsKey("y")) {
                Double x = targetScreenPt.get("x");
                Double y = targetScreenPt.get("y");
                if (null != x && null != y) {
                    Point point = new Point(x.intValue(), y.intValue());
                    builder.targetScreen(point);
                }
            }
        }

        Map<String, Double> targetGeoPt = (Map<String, Double>) mapStatusParameter.get("targetGeoPt");
        if (null != targetGeoPt) {
            if (targetGeoPt.containsKey("latitude") && targetGeoPt.containsKey("longitude")) {
                Double latitude = targetGeoPt.get("latitude");
                Double longitude = targetGeoPt.get("longitude");
                if (null != latitude && null != longitude) {
                    LatLng latLng = new LatLng(latitude, longitude);
                    builder.target(latLng);
                }
            }
        }

        return builder.build();
    }

    /**
     * 设置地图中心点以及缩放级别
     */
    private void setNewLatLngZoom(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("coordinate") || !argument.containsKey("zoom") || !argument.containsKey(
                "animateDurationMs")) {
            result.success(false);
            return;
        }
        Map<String, Double> coordinate = (Map<String, Double>) argument.get("coordinate");
        Double zoom = (Double) argument.get("zoom");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");
        if (null != coordinate && zoom != null && animateDurationMs != null) {
            boolean b = setAnimateNewLatLngZoomImp(coordinate, zoom, animateDurationMs);
            result.success(b);
        } else if (null != coordinate && zoom != null) {
            boolean b = setNewLatLngZoomImp(coordinate, zoom);
            result.success(b);
        } else {
            result.success(false);
        }
    }

    /**
     * 动画形式更新地图中心点以及缩放级别
     *
     * @return 成功则返回true 否则返回false
     */
    private boolean setAnimateNewLatLngZoomImp(Map<String, Double> coordinate, Double zoom, Integer animateDurationMs) {
        if (!coordinate.containsKey("latitude") || !coordinate.containsKey("longitude")) {
            return false;
        }
        Double latitude = coordinate.get("latitude");
        Double longitude = coordinate.get("longitude");
        if (null == latitude || null == longitude) {
            return false;
        }
        LatLng latLng = new LatLng(latitude, longitude);
        float zoomValue = zoom.floatValue();
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newLatLngZoom(latLng, zoomValue);
        mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
        return true;
    }

    /**
     * 更新地图中心点以及缩放级别
     *
     * @return 成功则返回true 否则返回false
     */
    private boolean setNewLatLngZoomImp(Map<String, Double> coordinate, Double zoom) {
        if (!coordinate.containsKey("latitude") || !coordinate.containsKey("longitude")) {
            return false;
        }
        Double latitude = coordinate.get("latitude");
        Double longitude = coordinate.get("longitude");
        if (null == latitude || null == longitude) {
            return false;
        }
        LatLng latLng = new LatLng(latitude, longitude);
        float zoomValue = zoom.floatValue();
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newLatLngZoom(latLng, zoomValue);
        mBaiduMap.setMapStatus(mapStatusUpdate);
        return true;
    }

    /**
     * 更新地图中心点
     */
    private void setNewLatlng(MethodCall call, MethodChannel.Result result) {
        if(Env.DEBUG){
            Log.d(TAG, "setNewLatlng");
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("coordinate") || !argument.containsKey("animateDurationMs")) {
            result.success(false);
            return;
        }
        Map<String, Double> coordinate = (Map<String, Double>) argument.get("coordinate");
        Integer animateDurationMs = (Integer) argument.get("animateDurationMs");
        if (null != coordinate && null != animateDurationMs) {
            boolean b = setAnimateNewLatlngImp(coordinate, animateDurationMs);
            result.success(b);
        } else if (null != coordinate) {
            boolean b = setNewLatlngImp(coordinate);
            result.success(b);
        } else {
            result.success(false);
        }
    }

    /**
     * 动画更新地图中心点
     *
     * @return 成功则返回true 否则返回false
     */
    private boolean setAnimateNewLatlngImp(Map<String, Double> coordinate, Integer animateDurationMs) {
        if (!coordinate.containsKey("latitude") || !coordinate.containsKey("longitude")) {
            return false;
        }
        Double latitude = coordinate.get("latitude");
        Double longitude = coordinate.get("longitude");
        if (null == latitude || null == longitude) {
            return false;
        }
        LatLng latLng = new LatLng(latitude, longitude);
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newLatLng(latLng);
        mBaiduMap.animateMapStatus(mapStatusUpdate, animateDurationMs);
        return true;
    }

    /**
     * 更新地图中心点
     *
     * @return 成功则返回true 否则返回false
     */
    private boolean setNewLatlngImp(Map<String, Double> coordinate) {
        if (!coordinate.containsKey("latitude") || !coordinate.containsKey("longitude")) {
            return false;
        }
        Double latitude = coordinate.get("latitude");
        Double longitude = coordinate.get("longitude");
        if (null == latitude || null == longitude) {
            return false;
        }
        LatLng latLng = new LatLng(latitude, longitude);
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newLatLng(latLng);
        mBaiduMap.setMapStatus(mapStatusUpdate);
        return true;
    }
}
