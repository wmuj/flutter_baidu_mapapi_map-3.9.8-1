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
import com.baidu.mapapi.map.CircleHoleOptions;
import com.baidu.mapapi.map.EncodePointType;
import com.baidu.mapapi.map.HoleOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.Polygon;
import com.baidu.mapapi.map.PolygonHoleOptions;
import com.baidu.mapapi.map.PolygonOptions;
import com.baidu.mapapi.map.PolylineDottedLineType;
import com.baidu.mapapi.map.Stroke;
import com.baidu.mapapi.model.LatLng;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class PolygonHandler extends OverlayHandler {
    private static final String TAG = "PolygonHandler";

    public PolygonHandler(BMFMapController bmfMapController) {
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
            case Constants.MethodProtocol.PolygonProtocol.sMapAddPolygonMethod:
                ret = addPolygon(argument);
                break;
            case Constants.MethodProtocol.PolygonProtocol.sMapUpdatePolygonMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addPolygon(Map<String, Object> argument) {
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
                || !argument.containsKey("coordinates")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        final String id = (String) argument.get("id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        PolygonOptions polygonOptions = new PolygonOptions();

        String encodedGeoPoints = (String) argument.get("encodedGeoPoints");
        if (!TextUtils.isEmpty(encodedGeoPoints)) {
            Integer encodePointType = (Integer) argument.get("encodePointType");
            polygonOptions.points(encodedGeoPoints, EncodePointType.values()[encodePointType]);
        } else {
            List<Map<String, Double>> coordinates =
                    (List<Map<String, Double>>) argument.get("coordinates");

            if (coordinates.size() < 1) {
                if (Env.DEBUG) {
                    Log.d(TAG, "coordinates.size() < 1");
                }
                return false;
            }

            List<LatLng> coordinatesList = FlutterDataConveter.mapToLatlngs(coordinates);
            if (null == coordinatesList) {
                if (Env.DEBUG) {
                    Log.d(TAG, "coordinatesList is null");
                }
                return false;
            }

            polygonOptions.points(coordinatesList);
        }

        if (argument.containsKey("width") && argument
                .containsKey("strokeColor")) {
            int width = (Integer) argument.get("width");
            String strokeColorStr = (String) argument.get("strokeColor");
            if (Env.DEBUG) {
                Log.d(TAG, "strokeColorStr:" + strokeColorStr);
            }
            if (!TextUtils.isEmpty(strokeColorStr)) {
                int strokeColor = FlutterDataConveter.strColorToInteger(strokeColorStr);
                Stroke stroke = new Stroke(width, strokeColor);
                polygonOptions.stroke(stroke);
            }
        }

        if (argument.containsKey("fillColor")) {
            String fillColorStr = (String) argument.get("fillColor");
            if (Env.DEBUG) {
                Log.d(TAG, "fillColorStr:" + fillColorStr);
            }
            if (!TextUtils.isEmpty(fillColorStr)) {
                int fillColor = FlutterDataConveter.strColorToInteger(fillColorStr);
                polygonOptions.fillColor(fillColor);
            }
        }

        if (argument.containsKey("zIndex")) {
            int zIndex = (Integer) argument.get("zIndex");
            polygonOptions.zIndex(zIndex);
        }

        if (argument.containsKey("visible")) {
            boolean visible = (Boolean) argument.get("visible");
            polygonOptions.visible(visible);
        }

        List<Object> holeOptionObjList = (List<Object>) argument.get("hollowShapes");
        if (null != holeOptionObjList && holeOptionObjList.size() > 0) {
            List<HoleOptions> holeOptionsList = createHoleOptionList(holeOptionObjList);

            if (null != holeOptionsList && holeOptionsList.size() > 0) {
                polygonOptions.addHoleOptions(holeOptionsList);
            }
        }

        if (argument.containsKey("lineDashType")) {
            Integer type = (Integer) argument.get("lineDashType");
            if (type == 1) {
                polygonOptions.dottedStroke(true);
                polygonOptions.dottedStrokeType(PolylineDottedLineType.DOTTED_LINE_SQUARE);
            } else if (type == 2) {
                polygonOptions.dottedStroke(true);
                polygonOptions.dottedStrokeType(PolylineDottedLineType.DOTTED_LINE_CIRCLE);
            }
        }

        if (argument.containsKey("clickable")) {
            Boolean clickable = (Boolean) argument.get("clickable");
            if (null != clickable) {
                polygonOptions.setClickable(clickable);
            }
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(polygonOptions);

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
                return null;
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
                return null;
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
     * 更新Polygon属性
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

        Polygon polygon = (Polygon) mOverlayMap.get(id);
        if (null == polygon) {
            return false;
        }
        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        String colorStr;
        int color;
        Stroke stroke;
        boolean ret = false;
        switch (member) {
            case "coordinates":
                ret = updateCoordinates(argument, polygon);
                break;
            case "width":
                Integer width = (Integer) argument.get("value");
                if (null == width) {
                    break;
                }

                stroke = polygon.getStroke();
                if (null == stroke) {
                    break;
                }

                Stroke newStroke = new Stroke(width, stroke.color);
                polygon.setStroke(newStroke);
                ret = true;
                break;
            case "strokeColor":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                stroke = polygon.getStroke();
                if (null == stroke) {
                    break;
                }

                stroke = new Stroke(stroke.strokeWidth, color);
                polygon.setStroke(stroke);
                ret = true;
                break;
            case "fillColor":
                colorStr = new TypeConverter<String>().getValue(argument, "value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                polygon.setFillColor(color);
                ret = true;
                break;
            case "hollowShapes":
                List<Object> holeOptionObjList = (List<Object>) argument.get("value");
                if (null != holeOptionObjList && holeOptionObjList.size() > 0) {
                    List<HoleOptions> holeOptionsList = createHoleOptionList(holeOptionObjList);

                    if (null != holeOptionsList && holeOptionsList.size() > 0) {
                        polygon.setHoleOptions(holeOptionsList);
                        ret = true;
                    }
                }
                break;
        }

        return ret;
    }

    private boolean updateCoordinates(Map<String, Object> argument, Polygon polygon) {
        List<Map<String, Double>> coordinates =
                new TypeConverter<List<Map<String, Double>>>().getValue(argument,
                        "value");

        if (null == coordinates) {
            return false;
        }

        List<LatLng> latLngList = FlutterDataConveter.mapToLatlngs(coordinates);
        if (null == latLngList) {
            return false;
        }

        polygon.setPoints(latLngList);

        return true;
    }
}
