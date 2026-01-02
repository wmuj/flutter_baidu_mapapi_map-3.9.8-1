package com.baidu.bmfmap.map.overlayhandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Circle;
import com.baidu.mapapi.map.CircleDottedStrokeType;
import com.baidu.mapapi.map.CircleHoleOptions;
import com.baidu.mapapi.map.CircleOptions;
import com.baidu.mapapi.map.HoleOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.PolygonHoleOptions;
import com.baidu.mapapi.map.Stroke;
import com.baidu.mapapi.model.LatLng;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CircleHandler extends OverlayHandler {

    private static final String TAG = "CircleHandler";

    // 是否是添加渐变圆
    private boolean isGradientCircle;

    public CircleHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "handlerMethodCall enter");
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return;
        }

        String methodId = call.method;
        boolean ret = false;
        switch (methodId) {
            case Constants.MethodProtocol.CirclelineProtocol.sMapAddCirclelineMethod:
                ret = addCircle(argument);
                break;
            case Constants.MethodProtocol.CirclelineProtocol.MAP_ADD_GRADIENT_CIRCLE_METHOD:
                isGradientCircle = true;
                ret = addCircle(argument);
                break;
            case Constants.MethodProtocol.CirclelineProtocol.sMapUpdateCircleMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addCircle(Map<String, Object> argument) {
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("center")
                || !argument.containsKey("radius")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        CircleOptions circleOptions = new CircleOptions();

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        Map<String, Object> centerMap = (Map<String, Object>) argument.get("center");
        LatLng center = FlutterDataConveter.mapToLatlng(centerMap);
        if (null != center) {
            circleOptions.center(center);
        }

        double radius = (Double) argument.get("radius");
        circleOptions.radius((int) radius);

        if (argument.containsKey("width") && argument.containsKey("strokeColor")) {
            int width = (Integer) argument.get("width");
            String strokeColorStr = (String) argument.get("strokeColor");
            if (!TextUtils.isEmpty(strokeColorStr)) {
                int strokeColor = FlutterDataConveter.strColorToInteger(strokeColorStr);
                Stroke stroke = new Stroke(width, strokeColor);
                circleOptions.stroke(stroke);
            }

        }

        if (argument.containsKey("fillColor")) {
            String fillColorStr = (String) argument.get("fillColor");
            int fillColor = FlutterDataConveter.strColorToInteger(fillColorStr);
            circleOptions.fillColor(fillColor);
        }

        if (argument.containsKey("zIndex")) {
            int zIndex = (Integer) argument.get("zIndex");
            circleOptions.zIndex(zIndex);
        }

        if (argument.containsKey("visible")) {
            boolean visible = (Boolean) argument.get("visible");
            circleOptions.visible(visible);
        }

        List<Object> holeOptionObjList = (List<Object>) argument.get("hollowShapes");
        if (null != holeOptionObjList && holeOptionObjList.size() > 0) {
            List<HoleOptions> holeOptionsList = createHoleOptionList(holeOptionObjList);

            if (null != holeOptionsList && holeOptionsList.size() > 0) {
                circleOptions.addHoleOptions(holeOptionsList);
            }
        }

        Boolean dottedLine = (Boolean) argument.get("dottedLine");
        if (null != dottedLine) {
            circleOptions.dottedStroke(dottedLine);
        }
        setLineDashType(argument, circleOptions);

        circleOptions.setIsGradientCircle(isGradientCircle);

        if (isGradientCircle) {
            if (argument.containsKey("colorWeight")) {
                Double colorWeight = (Double) argument.get("colorWeight");
                circleOptions.setColorWeight(colorWeight.floatValue());
            }

            if (argument.containsKey("radiusWeight")) {
                Double radiusWeight = (Double) argument.get("radiusWeight");
                circleOptions.setRadiusWeight(radiusWeight.floatValue());
            }

            if (argument.containsKey("centerColor")) {
                String centerColor = (String) argument.get("centerColor");
                if (!TextUtils.isEmpty(centerColor)) {
                    circleOptions.setCenterColor(FlutterDataConveter.strColorToInteger(centerColor));
                }
            }

            if (argument.containsKey("sideColor")) {
                String sideColor = (String) argument.get("sideColor");
                if (!TextUtils.isEmpty(sideColor)) {
                    circleOptions.setSideColor(FlutterDataConveter.strColorToInteger(sideColor));
                }
            }
        }

        // 是否可点击，默认为false since 3.5.0
        Boolean clickable = (Boolean) argument.get("clickable");
        if (null != clickable) {
            circleOptions.setClickable(clickable);
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(circleOptions);

        if (null != overlay) {
            Bundle bundle = new Bundle();
            bundle.putString("id", id);
            if (customMap != null && customMap.size() > 0) {
                bundle.putSerializable("customMap", customMap);
            }
            overlay.setExtraInfo(bundle);

            mOverlayMap.put(id, overlay);
            mMapController.mOverlayIdMap.put(id, overlay);
            return true;
        }

        return false;
    }

    private void setLineDashType(Map<String, Object> circleOptionsMap,
                                 CircleOptions circleOptions) {
        if (null == circleOptionsMap || null == circleOptions) {
            return;
        }

        Integer lineDashType =
                new TypeConverter<Integer>().getValue(circleOptionsMap, "lineDashType");
        if (null == lineDashType) {
            return;
        }

        switch (lineDashType) {
            case OverlayCommon.LineDashType.sLineDashTypeNone:
                circleOptions.dottedStroke(false);
                break;
            case OverlayCommon.LineDashType.sLineDashTypeSquare:
                circleOptions.dottedStroke(true);
                circleOptions.dottedStrokeType(CircleDottedStrokeType.DOTTED_LINE_SQUARE);
                break;
            case OverlayCommon.LineDashType.sLineDashTypeDot:
                circleOptions.dottedStroke(true);
                circleOptions.dottedStrokeType(CircleDottedStrokeType.DOTTED_LINE_CIRCLE);
                break;
            default:
                break;
        }
    }

    private List<HoleOptions> createHoleOptionList(List<Object> holeOptionObjList) {

        Iterator itr = holeOptionObjList.iterator();

        List<HoleOptions> holeOptionsList = new ArrayList<>();
        while (itr.hasNext()) {
            Map<String, Object> holeOptionMap = (Map<String, Object>) itr.next();
            if (null == holeOptionMap) {
                continue;
            }

            Integer holeOptionType = (Integer) holeOptionMap.get("hollowShapeType");

            if (null == holeOptionType) {
                continue;
            }

            HoleOptions holeOptions = null;
            switch (holeOptionType) {
                case Constants.HoleType.CIRCLE_HOLE_TYPE:
                    holeOptions = createCircleHoleOption(holeOptionMap);
                    break;
                case Constants.HoleType.POLYGON_HOLE_TYPE:
                    holeOptions = createPolygonHoleOption(holeOptionMap);
                    break;
                default:
                    break;
            }

            if (null == holeOptions) {
                continue;
            }

            holeOptionsList.add(holeOptions);
        }

        return holeOptionsList;
    }

    private CircleHoleOptions createCircleHoleOption(Map<String, Object> holeOptionMap) {
        Object latLngObj = holeOptionMap.get("center");

        if (null == latLngObj) {
            return null;
        }

        CircleHoleOptions circleHoleOptions = new CircleHoleOptions();

        LatLng center = FlutterDataConveter.toLatLng(latLngObj);
        if (null == center) {
            return null;
        }

        circleHoleOptions.center(center);

        Double radius = new TypeConverter<Double>().getValue(holeOptionMap, "radius");
        if (null == radius) {
            return null;
        }

        circleHoleOptions.radius(radius.intValue());

        return circleHoleOptions;
    }

    private PolygonHoleOptions createPolygonHoleOption(Map<String, Object> holeOptionMap) {
        List<Map<String, Double>> coordinatesList =
                new TypeConverter<List<Map<String, Double>>>().getValue(holeOptionMap,
                        "coordinates");

        List<LatLng> latLngList = FlutterDataConveter.mapToLatlngs(coordinatesList);
        if (null == latLngList || latLngList.size() <= 0) {
            return null;
        }

        PolygonHoleOptions polygonHoleOptions = new PolygonHoleOptions();
        polygonHoleOptions.addPoints(latLngList);
        return polygonHoleOptions;
    }

    @Override
    public void clean() {
        super.clean();

    }

    /**
     * 更新circle属性
     *
     * @param argument
     * @return
     */
    private boolean updateMember(Map<String, Object> argument) {
        if (null == argument) {
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap == null || !mOverlayMap.containsKey(id)) {
            return false;
        }

        Circle circle = (Circle) mOverlayMap.get(id);
        if (null == circle) {
            return false;
        }

        String member = (String) argument.get("member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        String colorStr;
        int color;
        boolean ret = false;
        Stroke stroke;
        switch (member) {
            case "center":
                Map<String, Object> centerMap = (Map<String, Object>) argument.get("value");
                LatLng center = FlutterDataConveter.mapToLatlng(centerMap);
                if (null == center) {
                    break;
                }

                circle.setCenter(center);
                ret = true;
                break;
            case "width":
                Integer width = (Integer) argument.get("value");
                if (null == width) {
                    break;
                }

                stroke = circle.getStroke();
                if (null == stroke) {
                    break;
                }

                Stroke newStroke = new Stroke(width, stroke.color);
                circle.setStroke(newStroke);
                ret = true;
                break;
            case "radius":
                Double radius = (Double) argument.get("value");
                if (null == radius) {
                    break;
                }

                circle.setRadius(radius.intValue());
                ret = true;
                break;
            case "strokeColor":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                stroke = circle.getStroke();
                if (null == stroke) {
                    break;
                }

                stroke = new Stroke(stroke.strokeWidth, color);
                circle.setStroke(stroke);
                ret = true;
                break;
            case "fillColor":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                circle.setFillColor(color);
                ret = true;
                break;
            case "lineDashType":
                ret = updateLineDashType(argument, circle);
                break;
            case "dottedLine":
                Boolean dottedLine = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == dottedLine) {
                    break;
                }

                circle.setDottedStroke(dottedLine);
                break;
            case "hollowShapes":
                List<Object> holeOptionObjList = (List<Object>) argument.get("value");
                if (null != holeOptionObjList && holeOptionObjList.size() > 0) {
                    List<HoleOptions> holeOptionsList = createHoleOptionList(holeOptionObjList);

                    if (null != holeOptionsList && holeOptionsList.size() > 0) {
                        circle.setHoleOptions(holeOptionsList);
                        ret = true;
                    }
                }
                break;
            case "clickable":
                Boolean clickable = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == clickable) {
                    break;
                }

                circle.setClickable(clickable);
                break;
            default:
                break;
        }

        return ret;
    }

    private boolean updateLineDashType(Map<String, Object> argument, Circle circle) {
        Integer lineDashType = new TypeConverter<Integer>().getValue(argument, "value");

        if (null == lineDashType) {
            return false;
        }

        switch (lineDashType) {
            case OverlayCommon.LineDashType.sLineDashTypeNone:
                break;
            case OverlayCommon.LineDashType.sLineDashTypeSquare:
                circle.setDottedStrokeType(CircleDottedStrokeType.DOTTED_LINE_SQUARE);
                break;
            case OverlayCommon.LineDashType.sLineDashTypeDot:
                circle.setDottedStrokeType(CircleDottedStrokeType.DOTTED_LINE_CIRCLE);
                break;
            default:
                break;
        }

        return true;
    }
}
