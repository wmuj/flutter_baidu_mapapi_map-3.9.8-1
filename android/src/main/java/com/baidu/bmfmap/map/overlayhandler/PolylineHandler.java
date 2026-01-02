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
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.Polyline;
import com.baidu.mapapi.map.PolylineDottedLineType;
import com.baidu.mapapi.map.PolylineOptions;
import com.baidu.mapapi.model.LatLng;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class PolylineHandler extends OverlayHandler {
    private static final String TAG = "PolylineHandler";

    // 普通线0、大地曲线1、渐变色2
    private static final int SIMPLE_LINE = 0;
    private static final int GEODESIC_LINE = 1;
    private static final int GRADIENT_LINE = 2;

    private final HashMap<String, List<BitmapDescriptor>> mBitmapMap = new HashMap<>();

    public PolylineHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "handlerMethodCall enter");
        }

        if (null == result) {
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

        String methodId = call.method;
        boolean ret = false;
        switch (methodId) {
            case Constants.MethodProtocol.PolylineProtocol.sMapAddPolylineMethod:
                ret = addPolyLine(argument);
                break;
            case Constants.MethodProtocol.PolylineProtocol.sMapUpdatePolylineMemberMethod:
                ret = updateMember(argument, SIMPLE_LINE);
                break;
            case Constants.MethodProtocol.PolylineProtocol.MAP_ADD_GEODESIC_LINE_METHOD:
                ret = addGeodesicPolyLine(argument);
                break;
            case Constants.MethodProtocol.PolylineProtocol.MAP_ADD_GRADIENT_LINE_METHOD:
                ret = addGradientPolyLine(argument);
                break;
            case Constants.MethodProtocol.PolylineProtocol.MAP_UPDATE_GEODESIC_LINE_MEMBER_METHOD:
                ret = updateMember(argument, GEODESIC_LINE);
                break;
            case Constants.MethodProtocol.PolylineProtocol.MAP_UPDATE_GRADIENT_LINE_MEMBER_METHOD:
                ret = updateMember(argument, GRADIENT_LINE);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    private boolean addGradientPolyLine(Map<String, Object> argument) {
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

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        PolylineOptions polylineOptions = new PolylineOptions();
        ArrayList<Integer> indexs = (ArrayList<Integer>) argument.get("indexs");
        ArrayList<String> colors = (ArrayList<String>) argument.get("colors");
        setOptions(id, argument, polylineOptions, indexs, colors, null, GRADIENT_LINE);

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(polylineOptions);
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        bundle.putIntegerArrayList("indexs", indexs);
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);
        mOverlayMap.put(id, overlay);
        mMapController.mOverlayIdMap.put(id, overlay);
        return true;
    }

    private boolean addGeodesicPolyLine(Map<String, Object> argument) {
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

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        PolylineOptions polylineOptions = new PolylineOptions();
        ArrayList<String> colors = new ArrayList<>();
        ArrayList<String> textures = new ArrayList<>();
        String strokeColor = (String) argument.get("strokeColor");
        String textureImage = (String) argument.get("textureImage");
        if (!TextUtils.isEmpty(strokeColor)) {
            colors.add(strokeColor);
        }
        if (!TextUtils.isEmpty(textureImage)) {
            textures.add(textureImage);
        }
        setOptions(id, argument, polylineOptions, null, colors, textures, GEODESIC_LINE);

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(polylineOptions);
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        bundle.putStringArrayList("textures", textures);
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);
        mOverlayMap.put(id, overlay);
        mMapController.mOverlayIdMap.put(id, overlay);
        return true;
    }

    private boolean addPolyLine(Map<String, Object> argument) {
        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("coordinates")
                || !argument.containsKey("indexs")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }


        PolylineOptions polylineOptions = new PolylineOptions();
        ArrayList<Integer> indexs = (ArrayList<Integer>) argument.get("indexs");
        ArrayList<String> colors = (ArrayList<String>) argument.get("colors");
        ArrayList<String> textures = (ArrayList<String>) argument.get("textures");
        setOptions(id, argument, polylineOptions, indexs, colors, textures, SIMPLE_LINE);

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(polylineOptions);
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        bundle.putIntegerArrayList("indexs", indexs);
        bundle.putStringArrayList("textures", textures);
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);
        mOverlayMap.put(id, overlay);
        mMapController.mOverlayIdMap.put(id, overlay);
        return true;
    }

    private boolean setOptions(String id, Map<String, Object> polylineOptionsMap,
                            PolylineOptions polylineOptions,
                            List<Integer> indexs,
                            List<String> colors,
                            List<String> textures,
                            int linesType) {
        if (null == polylineOptionsMap || null == polylineOptions) {
            return false;
        }

        if ((linesType == SIMPLE_LINE || linesType == GRADIENT_LINE) && null == indexs) {
            return false;
        }
        
        if ( (null == colors || colors.size() <= 0)
                && (null == textures || textures.size() <= 0)) {
            return false;
        }

        List<Map<String, Double>> coordinates =
                (List<Map<String, Double>>) polylineOptionsMap.get("coordinates");
        List<LatLng> latLngList = FlutterDataConveter.mapToLatlngs(coordinates);
        if (null == latLngList) {
            if (Env.DEBUG) {
                Log.d(TAG, "latLngList is null");
            }
            return false;
        }

        polylineOptions.points(latLngList);

        Integer width = new TypeConverter<Integer>().getValue(polylineOptionsMap, "width");
        if (null != width) {
            polylineOptions.width(width);
        }

        Boolean clickable = new TypeConverter<Boolean>().getValue(polylineOptionsMap, "clickable");
        if (null != clickable) {
            polylineOptions.clickable(clickable);
        }

        Boolean isKeepScale =
                new TypeConverter<Boolean>().getValue(polylineOptionsMap, "isKeepScale");
        if (null != isKeepScale) {
            polylineOptions.keepScale(isKeepScale);
        }

        Boolean isFocus = new TypeConverter<Boolean>().getValue(polylineOptionsMap, "isFocus");
        if (null != isFocus) {
            polylineOptions.focus(isFocus);
        }

        Integer zIndex = new TypeConverter<Integer>().getValue(polylineOptionsMap, "zIndex");
        if (null != zIndex) {
            polylineOptions.zIndex(zIndex);
        }

        Boolean visible = new TypeConverter<Boolean>().getValue(polylineOptionsMap, "visible");
        if (null != visible) {
            polylineOptions.visible(visible);
        }

        Boolean isThined = new TypeConverter<Boolean>().getValue(polylineOptionsMap, "isThined");
        if (null != isThined) {
            polylineOptions.isThined(isThined);
        }

        Boolean dottedLine =
                new TypeConverter<Boolean>().getValue(polylineOptionsMap, "dottedLine");
        if (null != dottedLine) {
            polylineOptions.dottedLine(dottedLine);
        }

        if (null != colors && colors.size() > 0) {
            List<Integer> intColors = FlutterDataConveter.getColors(colors);

            if (null != intColors) {
                if (intColors.size() == 1) {
                    polylineOptions.color(intColors.get(0));
                } else {
                    int pointNumn = latLngList.size();
                    List<Integer> correctColors = correctColors(indexs, intColors, pointNumn);
                    polylineOptions.colorsValues(correctColors);
                }
            }
        }

        /*
         *colors和icons不能共存
         */
        if (null == colors || colors.size() <= 0) {
            if (null != textures && textures.size() > 0) {
                List<BitmapDescriptor> bitmapDescriptors = FlutterDataConveter.getIcons(textures);
                if (null != bitmapDescriptors) {
                    if (bitmapDescriptors.size() == 1) {
                        polylineOptions.customTexture(bitmapDescriptors.get(0));
                    } else {
                        polylineOptions.textureIndex(indexs);
                        polylineOptions.customTextureList(bitmapDescriptors);
                    }

                    clearTextureBitMap(id);
                    mBitmapMap.put(id, bitmapDescriptors);
                }
            }
        }

        setLineDashType(polylineOptionsMap, polylineOptions);
        setLineCapType(polylineOptionsMap, polylineOptions);
        setLineJoinType(polylineOptionsMap, polylineOptions);

        // 3.1.0版本新增
        setLineDirectionCross180Type(polylineOptionsMap, polylineOptions);
        if (linesType == GEODESIC_LINE) {
            polylineOptions.isGeodesic(true);
        } else if (linesType == GRADIENT_LINE) {
            polylineOptions.isGradient(true);
        }

        // 3.5版本新增，polyline支持发光
        Integer lineBloomMode = new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineBloomMode");
        if (null != lineBloomMode) {
            polylineOptions.bloomType(PolylineOptions.LineBloomType.values()[lineBloomMode]);
        }

        Double lineBloomWidth = new TypeConverter<Double>().getValue(polylineOptionsMap, "lineBloomWidth");
        if (null != lineBloomWidth) {
            polylineOptions.bloomWidth(lineBloomWidth.intValue());
        }

        Double lineBloomAlpha = new TypeConverter<Double>().getValue(polylineOptionsMap, "lineBloomAlpha");
        if (null != lineBloomAlpha) {
            polylineOptions.bloomAlpha(lineBloomAlpha.intValue());
        }

        Double lineBloomGradientASPeed = new TypeConverter<Double>().getValue(polylineOptionsMap, "lineBloomGradientASPeed");
        if (null != lineBloomGradientASPeed) {
            polylineOptions.setBloomGradientASpeed(lineBloomGradientASPeed.floatValue());
        }

        Integer lineBloomBlurTimes = new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineBloomBlurTimes");
        if (null != lineBloomBlurTimes) {
            polylineOptions.setBloomBlurTimes(lineBloomBlurTimes);
        }

        return true;
    }

    private void setLineDirectionCross180Type(Map<String, Object> polylineOptionsMap,
                                              PolylineOptions polylineOptions) {
        if (null == polylineOptionsMap || null == polylineOptions) {
            return;
        }

        Integer lineDirectionCross180Type = new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineDirectionCross180");
        if (null == lineDirectionCross180Type) {
            return;
        }

        if (lineDirectionCross180Type < 0 || lineDirectionCross180Type > PolylineOptions.LineDirectionCross180.values().length) {
            return;
        }

        polylineOptions.lineDirectionCross180(PolylineOptions.LineDirectionCross180.values()[lineDirectionCross180Type]);
    }

    /**
     * android polyline多颜色只需要设置colors
     * 但flutter传过来的colors只是一个颜色数组，没有索引的概念，需要根据indexs对其进行修正
     * 正常情况indexs的数目应该等于pointNum -1,如果indexs小于次值，则余下段的索引按照索引数组最后一个补齐，反之则按照poinNum - 1处理
     */
    private List<Integer> correctColors(List<Integer> indexs,
                                        List<Integer> colors,
                                        int pointNum) {

        // 通过colors的size对索引数组进行修正
        List<Integer> tmpIndexs = new ArrayList<>();
        for (Integer i : indexs) {
            if (i < colors.size()) {
                tmpIndexs.add(i);
            } else {
                tmpIndexs.add(colors.size() - 1);
            }
        }

        int tmpIndexSize = tmpIndexs.size();
        int lastIndexValue = tmpIndexs.get(tmpIndexSize - 1);
        // 通过pointNum对索引数组进行修正
        if (tmpIndexSize < pointNum - 1) {
            for (int i = tmpIndexSize; i < pointNum - 1; i++) {
                tmpIndexs.add(lastIndexValue);
            }
        }

        List<Integer> tmpColors = new ArrayList<>();
        for (int i = 0; i < pointNum - 1; i++) {
            tmpColors.add(colors.get(tmpIndexs.get(i)));
        }

        return tmpColors;
    }

    private void setLineDashType(Map<String, Object> polylineOptionsMap,
                                 PolylineOptions polylineOptions) {
        if (null == polylineOptionsMap || null == polylineOptions) {
            return;
        }

        Integer lineDashType =
                new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineDashType");
        if (null == lineDashType) {
            return;
        }

        switch (lineDashType) {
            case OverlayCommon.LineDashType.sLineDashTypeSquare:
                polylineOptions.dottedLineType(PolylineDottedLineType.DOTTED_LINE_SQUARE);
                break;
            case OverlayCommon.LineDashType.sLineDashTypeDot:
                polylineOptions.dottedLineType(PolylineDottedLineType.DOTTED_LINE_CIRCLE);
                break;
            default:
                break;
        }
    }

    private void setLineCapType(Map<String, Object> polylineOptionsMap,
                                PolylineOptions polylineOptions) {
        if (null == polylineOptionsMap || null == polylineOptions) {
            return;
        }

        Integer lineCapType = new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineCapType");
        if (null == lineCapType) {
            return;
        }

        if (lineCapType < 0 || lineCapType > PolylineOptions.LineCapType.values().length) {
            return;
        }

        polylineOptions.lineCapType(PolylineOptions.LineCapType.values()[lineCapType]);
    }

    private void setLineJoinType(Map<String, Object> polylineOptionsMap,
                                PolylineOptions polylineOptions) {
        if (null == polylineOptionsMap || null == polylineOptions) {
            return;
        }

        Integer lineJoinType = new TypeConverter<Integer>().getValue(polylineOptionsMap, "lineJoinType");
        if (null == lineJoinType) {
            return;
        }

        if (lineJoinType < 0 || lineJoinType > PolylineOptions.LineJoinType.values().length) {
            return;
        }

        polylineOptions.lineJoinType(PolylineOptions.LineJoinType.values()[lineJoinType]);
    }

    /**
     * 更新polyline属性
     *
     * @param argument
     * @return
     */
    private boolean updateMember(Map<String, Object> argument, int type) {
        if (argument == null) {
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (!mOverlayMap.containsKey(id)) {
            return false;
        }

        final Polyline polyline = (Polyline) mOverlayMap.get(id);
        if (polyline == null) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        boolean ret = false;
        switch (member) {
            case "coordinates":
                ret = updateCoordinates(argument, polyline);
                break;
            case "width":
                Integer width = new TypeConverter<Integer>().getValue(argument, "value");
                if (null == width) {
                    break;
                }

                polyline.setWidth(width);
                ret = true;
                break;
            case "indexs":
                ret = updateIndexs(argument, polyline);
                break;
            case "colors":
                ret = updateColors(argument, polyline);
                break;
            case "textures":
                ret = updateTextures(argument, polyline);
                break;
            case "lineDashType":
                if (type == GEODESIC_LINE) {
                    polyline.setDottedLine(true);
                }
                ret = updateLineDashType(argument, polyline);
                break;
            case "lineJoinType":
                ret = updateLineJoinType(argument, polyline);
                break;
            case "lineCapType":
                ret = updateLineCapType(argument, polyline);
            break;
            case "clickable":
                Boolean clickable = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == clickable) {
                    break;
                }

                polyline.setClickable(clickable);
                ret = true;
                break;
            case "isKeepScale":
                Boolean isKeepScale = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == isKeepScale) {
                    break;
                }

                polyline.setIsKeepScale(isKeepScale);
                ret = true;
                break;
            case "isFocus":
                Boolean isFocus = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == isFocus) {
                    break;
                }

                polyline.setFocus(isFocus);
                ret = true;
                break;
            case "visible":
                Boolean visible = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null == visible) {
                   break;
                }

                polyline.setVisible(visible);
                ret = true;
                break;
            case "zIndex":
                Integer zIndex = new TypeConverter<Integer>().getValue(argument, "value");
                if (null == zIndex) {
                    break;
                }

                polyline.setZIndex(zIndex);
                ret = true;
                break;
            case "isThined":
                Boolean isThined = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null != isThined) {
                    polyline.setThined(isThined);
                    ret = true;
                }
                break;
            case "dottedLine":
                Boolean dottedLine = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null != dottedLine) {
                    polyline.setDottedLine(dottedLine);
                    ret = true;
                }
                break;
            case "lineDirectionCross180":
                ret = updateLineDirectionCross180Type(argument, polyline);
                break;
            case "strokeColor":
                ret = updateLineStrokeColor(argument, polyline);
                break;
            case "textureImage":
                ret = updateLineTextureImager(argument, polyline);
                break;
            case "lineBloomMode":
                Integer lineBloomMode = new TypeConverter<Integer>().getValue(argument, "value");
                if (null != lineBloomMode) {
                    polyline.setLineBloomType(PolylineOptions.LineBloomType.values()[lineBloomMode]);
                    ret = true;
                }
                break;
            case "lineBloomWidth":
                Double lineBloomWidth = new TypeConverter<Double>().getValue(argument, "value");
                if (null != lineBloomWidth) {
                    polyline.setBloomWidth(lineBloomWidth.intValue());
                    ret = true;
                }
                break;
            case "lineBloomAlpha":
                Double lineBloomAlpha = new TypeConverter<Double>().getValue(argument, "value");
                if (null != lineBloomAlpha) {
                    polyline.setBloomAlpha(lineBloomAlpha.intValue());
                    ret = true;
                }
                break;
            case "lineBloomGradientASPeed":
                Double lineBloomGradientASPeed = new TypeConverter<Double>().getValue(argument, "value");
                if (null != lineBloomGradientASPeed) {
                    polyline.setBloomGradientASpeed(lineBloomGradientASPeed.floatValue());
                    ret = true;
                }
                break;
            case "lineBloomBlurTimes":
                Integer lineBloomBlurTimes = new TypeConverter<Integer>().getValue(argument, "value");
                if (null != lineBloomBlurTimes) {
                    polyline.setBloomBlurTimes(lineBloomBlurTimes);
                    ret = true;
                }
                break;
            default:
                break;
        }

        return ret;
    }

    private boolean updateLineTextureImager(Map<String, Object> argument, Polyline polyline) {
        String textureImage = new TypeConverter<String>().getValue(argument, "value");
        if (TextUtils.isEmpty(textureImage)) {
            return false;
        }
        BitmapDescriptor icon = FlutterDataConveter.getIcon(textureImage);
        if (null == icon) {
           return false;
        }
        polyline.setTexture(icon);
        return true;
    }

    private boolean updateLineStrokeColor(Map<String, Object> argument, Polyline polyline) {
        String strokeColor = new TypeConverter<String>().getValue(argument, "value");
        if (TextUtils.isEmpty(strokeColor)) {
            return false;
        }
        Integer color = FlutterDataConveter.getColor(strokeColor);
        if (null == color) {
           return false;
        }
        polyline.setColor(color.intValue());
        return true;
    }

    private boolean updateCoordinates(Map<String, Object> argument, Polyline polyline) {
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
        polyline.setPoints(latLngList);
        return true;
    }

    private boolean updateIndexs(Map<String, Object> argument, Polyline polyline) {
        List<Integer> indexs = new TypeConverter<List<Integer>>().getValue(argument, "value");
        if (null == indexs) {
            return false;
        }

        int[] nIndexs = new int[indexs.size()];
        for (int i = 0; i < indexs.size(); i++) {
            nIndexs[i] = indexs.get(i);
        }

        polyline.setIndexs(nIndexs);

        List<LatLng> points = polyline.getPoints();
        if (null != points) {
            polyline.setPoints(points);
        }

        return true;
    }

    private boolean updateColors(Map<String, Object> argument, Polyline polyline) {
        boolean ret = false;
        List<String> colors =
                new TypeConverter<List<String>>().getValue(argument, "value");
        List<Integer> indexs =
                new TypeConverter<List<Integer>>().getValue(argument, "indexs");

        List<LatLng> points = polyline.getPoints();

        if (null != colors &&
                colors.size() > 0 &&
                null != indexs &&
                indexs.size() > 0 &&
                null != points &&
                points.size() > 0) {
            List<Integer> intColors = FlutterDataConveter.getColors(colors);
            List<Integer> correctColors = correctColors(indexs, intColors, points.size());

            if (null != correctColors) {
                if (correctColors.size() == 1) {
                    polyline.setColor(correctColors.get(0));
                    ret = true;
                } else {
                    int[] nColors = new int[correctColors.size()];
                    for (int i = 0; i < correctColors.size(); i++) {
                        nColors[i] = correctColors.get(i);
                    }
                    polyline.setColorList(nColors);
                    ret = true;
                }

                polyline.setPoints(points);
            }
        }

        return ret;
    }

    private boolean updateTextures(Map<String, Object> argument, Polyline polyline) {
        List<String> icons =
                new TypeConverter<List<String>>().getValue(argument, "value");

        if (null == icons) {
            return false;
        }

        boolean ret = false;
        if (icons.size() > 0) {
            List<BitmapDescriptor> bitmapDescriptors = FlutterDataConveter.getIcons(icons);
            if (null != bitmapDescriptors) {
                if (bitmapDescriptors.size() == 1) {
                    polyline.setTexture(bitmapDescriptors.get(0));
                    ret = true;
                } else {
                    polyline.setTextureList(bitmapDescriptors);
                    ret = true;
                }

                List<LatLng> points = polyline.getPoints();
                if (null != points) {
                    polyline.setPoints(points);
                }

                Bundle bundle = polyline.getExtraInfo();
                String id = bundle.getString("id");
                clearTextureBitMap(id);
                mBitmapMap.put(id, bitmapDescriptors);
            }
        }

        return ret;
    }

    private boolean updateLineDashType(Map<String, Object> argument, Polyline polyline) {
        Integer lineDashType = new TypeConverter<Integer>().getValue(argument, "value");

        if (null == lineDashType) {
            return false;
        }

        switch (lineDashType) {
            case OverlayCommon.LineDashType.sLineDashTypeNone:
                break;
            case OverlayCommon.LineDashType.sLineDashTypeSquare:
                polyline.setDottedLineType(PolylineDottedLineType.DOTTED_LINE_SQUARE);
                break;
            case OverlayCommon.LineDashType.sLineDashTypeDot:
                polyline.setDottedLineType(PolylineDottedLineType.DOTTED_LINE_CIRCLE);
                break;
            default:
                break;
        }

        return true;
    }

    private boolean updateLineJoinType(Map<String, Object> argument, Polyline polyline) {
        Integer lineJoinType = new TypeConverter<Integer>().getValue(argument, "value");
        if (null == lineJoinType) {
            return false;
        }

        if (lineJoinType < 0 || lineJoinType > PolylineOptions.LineJoinType.values().length) {
            return false;
        }

        polyline.setLineJoinType(PolylineOptions.LineJoinType.values()[lineJoinType]);

        return true;
    }

    private boolean updateLineCapType(Map<String, Object> argument, Polyline polyline) {
        Integer lineCapType = new TypeConverter<Integer>().getValue(argument, "value");
        if (null == lineCapType) {
            return false;
        }

        if (lineCapType < 0 || lineCapType > PolylineOptions.LineCapType.values().length) {
            return false;
        }

        polyline.setLineCapType(PolylineOptions.LineCapType.values()[lineCapType]);
        return true;
    }

    private boolean updateLineDirectionCross180Type(Map<String, Object> argument, Polyline polyline) {
        Integer lineDirectionCross180Type = new TypeConverter<Integer>().getValue(argument, "value");
        if (null == lineDirectionCross180Type) {
            return false;
        }

        if (lineDirectionCross180Type < 0 || lineDirectionCross180Type > PolylineOptions.LineDirectionCross180.values().length) {
            return false;
        }

        polyline.setLineDirectionCross180(PolylineOptions.LineDirectionCross180.values()[lineDirectionCross180Type]);
        return true;
    }

    private void clearTextureBitMap(String id) {
        if (TextUtils.isEmpty(id)) {
            return;
        }

        List<BitmapDescriptor> bitmapDescriptors = mBitmapMap.get(id);
        if (null == bitmapDescriptors) {
            return;
        }

        Iterator itr = bitmapDescriptors.iterator();
        BitmapDescriptor bitmapDescriptor;
        while (itr.hasNext()) {
            bitmapDescriptor = (BitmapDescriptor) itr.next();
            if (null == bitmapDescriptor) {
                continue;
            }

            bitmapDescriptor.recycle();
        }

        mBitmapMap.remove(id);
    }

    public void clean() {
        super.clean();
        Iterator itr = mBitmapMap.values().iterator();
        List<BitmapDescriptor> bitmapDescriptors;
        BitmapDescriptor bitmapDescriptor;
        while (itr.hasNext()) {
            bitmapDescriptors = (List<BitmapDescriptor>) itr.next();
            if (null == bitmapDescriptors) {
                continue;
            }

            Iterator listItr = bitmapDescriptors.iterator();
            while (listItr.hasNext()) {
                bitmapDescriptor = (BitmapDescriptor) listItr.next();
                if (null == bitmapDescriptor) {
                    continue;
                }

                bitmapDescriptor.recycle();
            }
        }

        mBitmapMap.clear();
    }

    public void clean(String id) {
        if (TextUtils.isEmpty(id)) {
            return;
        }
        
        super.clean(id);

        List<BitmapDescriptor> bitmapDescriptors = mBitmapMap.get(id);
        if (null == bitmapDescriptors) {
            return;
        }

        Iterator itr = bitmapDescriptors.iterator();
        BitmapDescriptor bitmapDescriptor;
        while (itr.hasNext()) {
            bitmapDescriptor = (BitmapDescriptor) itr.next();
            if (null == bitmapDescriptor) {
                continue;
            }

            bitmapDescriptor.recycle();
        }

        mBitmapMap.remove(id);
    }

    private boolean updateGeodesicLineMember(Map<String, Object> argument) {
        if (null == mMapController || null == mMapController.mOverlayIdMap) {
            return false;
        }
        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }
        Polyline polyline = (Polyline) mMapController.mOverlayIdMap.get(id);
        if (null == polyline) {
            if (Env.DEBUG) {
                Log.d(TAG, "polyline is null");
            }
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            if (Env.DEBUG) {
                Log.d(TAG, "member is null");
            }
            return false;
        }

        Object object = new TypeConverter<String>().getValue(argument, "value");
        if (null == object) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        boolean isSuccess = false;
        switch (member) {
            case "coordinates":
//                updataGeodesicLineCoordinates(object, polyline);
                break;
            case "optionAndcenter":
                break;
            case "option":
                break;
            default:
                break;
        }

        return isSuccess;
    }

//    private boolean updataGeodesicLineCoordinates(Object object, Polyline polyline) {
//    }
}
