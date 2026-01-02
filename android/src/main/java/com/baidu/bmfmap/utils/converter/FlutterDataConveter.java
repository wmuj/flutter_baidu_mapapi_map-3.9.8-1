package com.baidu.bmfmap.utils.converter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BaiduMapOptions;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.Projection;
import com.baidu.mapapi.map.WeightedLatLng;
import com.baidu.mapapi.map.WinRound;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import android.graphics.Color;
import android.graphics.Point;
import android.text.TextUtils;

public class FlutterDataConveter {

    public static List<?> toList(Object o) {
        return (List<?>) o;
    }

    public static Map<?, ?> toMap(Object o) {
        return o != null ? (Map<?, ?>) o : null;
    }

    public static Boolean toBoolean(Object o) {
        return o != null ? (Boolean) o : null;
    }

    public static Integer toInt(Object o) {
        return o != null ? ((Number) o).intValue() : null;
    }

    public static Double toDouble(Object o) {
        return o != null ? ((Number) o).doubleValue() : null;
    }

    public static Float toFloat(Object o) {
        return o != null ? ((Number) o).floatValue() : null;
    }

    /**
     * 将map形式的经纬度信息转换为结构化的经纬度数据
     *
     * @param latlngMap
     * @return
     */
    public static LatLng mapToLatlng(Map<String, Object> latlngMap) {
        if (null == latlngMap) {
            return null;
        }

        if (!latlngMap.containsKey("latitude")
                || !latlngMap.containsKey("longitude")) {
            return null;
        }

        Object latitudeObj = latlngMap.get("latitude");
        Object longitudeObj = latlngMap.get("longitude");
        if (null == latitudeObj || null == longitudeObj) {
            return null;
        }
        return new LatLng((double) latitudeObj, (double) longitudeObj);
    }

    /**
     * 将多个map形式的经纬度信息转换为结构化的经纬度数据
     *
     * @param latlngList
     * @return
     */
    public static List<LatLng> mapToLatlngs(List<Map<String, Double>> latlngList) {
        if (null == latlngList) {
            return null;
        }

        Iterator itr = latlngList.iterator();
        ArrayList<LatLng> latLngs = new ArrayList<>();
        while (itr.hasNext()) {
            Map<String, Object> latlngMap = (Map<String, Object>) itr.next();
            LatLng latLng = mapToLatlng(latlngMap);
            if (null == latLng) {
                break;
            }

            latLngs.add(latLng);
        }

        if (latLngs.size() != latlngList.size()) {
            return null;
        }

        return latLngs;
    }

    /**
     * 将整形转换为16进制字符串
     *
     * @param number
     * @return
     */
    private static String intToHexValue(int number) {
        String result = Integer.toHexString(number & 0xff);
        while (result.length() < 2) {
            result = "0" + result;
        }
        return result.toUpperCase();
    }

    /**
     * 将16进制颜色转换为整形颜色值
     *
     * @param str 16进制颜色值
     * @return
     */
    public static int strColorToInteger(String str) {
        if (TextUtils.isEmpty(str) || str.length() < 8) {
            return 0;
        }
        String str1 = str.substring(0, 2);
        String str2 = str.substring(2, 4);
        String str3 = str.substring(4, 6);
        String str4 = str.substring(6, 8);
        int alpha = Integer.parseInt(str1, 16);
        int red = Integer.parseInt(str2, 16);
        int green = Integer.parseInt(str3, 16);
        int blue = Integer.parseInt(str4, 16);

        return Color.argb(alpha, red, green, blue);
    }

    /**
     * 批量根据icon名称获取BitmapDescriptor
     *
     * @param icons
     * @return
     */
    public static List<BitmapDescriptor> getIcons(List<String> icons) {
        if (null == icons) {
            return null;
        }

        List<BitmapDescriptor> bitmapIcons = new ArrayList<>();
        Iterator itr = icons.iterator();
        while (itr.hasNext()) {
            String icon = (String) itr.next();
            BitmapDescriptor bitmapDescriptor =
                    BitmapDescriptorFactory.fromAsset("flutter_assets/" + icon);
            bitmapIcons.add(bitmapDescriptor);
        }

        return bitmapIcons;
    }

    /**
     * 批量将16进制字符串颜色值转换为整形颜色值
     *
     * @param colors
     * @return
     */
    public static List<Integer> getColors(List<String> colors) {
        if (null == colors || colors.size() <= 0) {
            return null;
        }

        List<Integer> intColors = new ArrayList<>();
        Iterator iterator = colors.iterator();
        while (iterator.hasNext()) {
            String colorStr = (String) iterator.next();
            if (TextUtils.isEmpty(colorStr)) {
                return null;
            }

            int color = FlutterDataConveter.strColorToInteger(colorStr);
            intColors.add(color);
        }

        return intColors;
    }

    /**
     * 将16进制字符串颜色值转换为整形颜色值
     * @param colorStr
     * @return
     */
    public static Integer getColor(String colorStr) {
        if (TextUtils.isEmpty(colorStr)) {
            return null;
        }

        int color = FlutterDataConveter.strColorToInteger(colorStr);

        return new Integer(color);
    }

    /**
     * 根据icon名称获取BitmapDescriptor
     *
     * @param iconStr
     * @return
     */
    public static BitmapDescriptor getIcon(String iconStr) {
        if (TextUtils.isEmpty(iconStr)) {
            return null;
        }

        BitmapDescriptor bitmapDescriptor =
                BitmapDescriptorFactory.fromAsset("flutter_assets/" + iconStr);

        if (bitmapDescriptor == null) {
            return null;
        }

        return bitmapDescriptor;
    }

    /**
     * 将map形式的bounds转换为LatLngBounds
     *
     * @param boundsMap
     * @return
     */
    public static LatLngBounds mapToLatlngBounds(Map<String, Object> boundsMap) {
        if (null == boundsMap) {
            return null;
        }
        if (!boundsMap.containsKey("northeast") || !boundsMap.containsKey("southwest")) {
            return null;
        }

        Map<String, Object> northeastMap = (Map<String, Object>) boundsMap.get("northeast");
        Map<String, Object> southwestMap = (Map<String, Object>) boundsMap.get("southwest");
        if (null == northeastMap || null == southwestMap) {
            return null;
        }

        LatLng northeast = mapToLatlng(northeastMap);
        LatLng southwest = mapToLatlng(southwestMap);
        return new LatLngBounds.Builder().include(northeast).include(southwest).build();
    }

    /**
     * 将LatLngBounds转换为map
     *
     * @param latLngBounds
     * @return
     */
    public static Map<String, Object> latlngBoundsToMap(LatLngBounds latLngBounds) {
        if (null == latLngBounds) {
            return null;
        }

        LatLng southwest = latLngBounds.southwest;
        LatLng northeast = latLngBounds.northeast;

        Map<String, Double> southwestMap = FlutterDataConveter.latLngToMap(southwest);
        Map<String, Double> northeastMap = FlutterDataConveter.latLngToMap(northeast);

        HashMap<String, Object> latLngBoundsMap = new HashMap<>();
        latLngBoundsMap.put("southwest", southwestMap);
        latLngBoundsMap.put("northeast", northeastMap);

        return latLngBoundsMap;
    }

    /**
     * 将map形式的带权值经纬度数据转换为结构化的带权值的经纬度数据
     *
     * @param dataList
     * @return
     */
    public static List<WeightedLatLng> mapToWeightedLatLngList(List<Map<String, Object>> dataList) {
        if (null == dataList) {
            return null;
        }

        List<WeightedLatLng> weightedLatLngList = new ArrayList<WeightedLatLng>();
        Iterator itr = dataList.iterator();
        while (itr.hasNext()) {
            Map<String, Object> data = (Map<String, Object>) itr.next();
            if (null == data) {
                return null;
            }

            if (!data.containsKey("pt")
                    || !data.containsKey("intensity")) {
                return null;
            }

            Object intensityObj = data.get("intensity");
            if (null == intensityObj) {
                return null;
            }

            double intensity = (double) intensityObj;

            Object ptObj = data.get("pt");
            if (null == ptObj) {
                return null;
            }

            Map<String, Object> ptMap = (Map<String, Object>) ptObj;

            LatLng latLng = FlutterDataConveter.mapToLatlng(ptMap);

            WeightedLatLng weightedLatLng = new WeightedLatLng(latLng, intensity);
            weightedLatLngList.add(weightedLatLng);
        }

        return weightedLatLngList;
    }

    /**
     * 将map形式的屏幕点坐标转换为Point
     *
     * @param pointMap
     * @return
     */
    public static Point mapToPoint(Map<String, Object> pointMap) {
        if (null == pointMap) {
            return null;
        }

        if (!pointMap.containsKey("x") || !pointMap.containsKey("y")) {
            return null;
        }

        Object xObj = pointMap.get("x");
        Object yObj = pointMap.get("y");
        if (null == xObj || null == yObj) {
            return null;
        }

        double x = (double) xObj;
        double y = (double) yObj;

        return new Point((int) x, (int) y);
    }

    /**
     * 将LatLng转成map存储
     *
     * @param latLng
     * @return
     */
    public static Map<String, Double> latLngToMap(LatLng latLng) {
        if (null == latLng) {
            return null;
        }

        Map<String, Double> resultMap = new HashMap<String, Double>();
        resultMap.put("latitude", latLng.latitude);
        resultMap.put("longitude", latLng.longitude);
        resultMap.put("latitudeE6", latLng.latitudeE6);
        resultMap.put("longitudeE6", latLng.longitudeE6);

        return resultMap;
    }

    /**
     * 将Point转成map存储
     *
     * @param point
     * @return
     */
    public static Map<String, Double> pointToMap(Point point) {
        if (null == point) {
            return null;
        }

        Map<String, Double> resultMap = new HashMap<String, Double>();
        resultMap.put("x", (double) point.x);
        resultMap.put("y", (double) point.y);

        return resultMap;
    }

    /**
     * 将flutter传过来的BMFRect转换为WinRound
     * BMFRect结构：
     * /// 屏幕左上点对应的直角地理坐标
     * final BMFPoint origin;
     * <p>
     * /// 坐标范围
     * final BMFSize size;
     * <p>
     * WinRound结构:
     * public int left = 0;
     * public int right = 0;
     * public int top = 0;
     * public int bottom = 0;
     */
    public static WinRound bmfRectToWinRound(Map<String, Object> bmfRect) {
        if (null == bmfRect) {
            return null;
        }

        if (!bmfRect.containsKey("origin") || !bmfRect.containsKey("size")) {
            return null;
        }

        Map<String, Object> pointMap = (Map<String, Object>) bmfRect.get("origin");
        Point point = FlutterDataConveter.mapToPoint(pointMap);
        if (null == point) {
            return null;
        }

        Map<String, Object> sizeMap = (Map<String, Object>) bmfRect.get("size");
        if (null == sizeMap) {
            return null;
        }

        Double width = new TypeConverter<Double>().getValue(sizeMap, "width");
        Double height = new TypeConverter<Double>().getValue(sizeMap, "height");

        if (null == width || null == height) {
            return null;
        }

        WinRound winRound = new WinRound();
        winRound.left = point.x;
        winRound.top = point.y;
        winRound.right = point.x + width.intValue();
        winRound.bottom = point.y + height.intValue();
        return winRound;

    }

    public static WinRound insetsToWinRound(Map<String, Object> insets) {
        if (null == insets) {
            return null;
        }

        if (!insets.containsKey("top")
                || !insets.containsKey("left")
                || !insets.containsKey("bottom")
                || !insets.containsKey("right")) {
            return null;
        }

        Double top = new TypeConverter<Double>().getValue(insets, "top");
        Double left = new TypeConverter<Double>().getValue(insets, "left");
        Double bottom = new TypeConverter<Double>().getValue(insets, "bottom");
        Double right = new TypeConverter<Double>().getValue(insets, "right");
        if (null == top
                || null == left
                || null == bottom
                || null == right) {
            return null;
        }

        WinRound winRound = new WinRound();
        winRound.left = left.intValue();
        winRound.top = top.intValue();
        winRound.right = right.intValue();
        winRound.bottom = bottom.intValue();
        return winRound;

    }

    public static LatLngBounds bmfRectToLatLngBounds(BaiduMap baiduMap,
                                                     Map<String, Object> bmfRect) {
        if (null == baiduMap || null == bmfRect) {
            return null;
        }

        WinRound winRound = FlutterDataConveter.bmfRectToWinRound(bmfRect);

        Point notrhEastPoint = new Point();
        notrhEastPoint.x = winRound.left;
        notrhEastPoint.y = winRound.top;
        Point southWestPoint = new Point();
        southWestPoint.x = winRound.right;
        southWestPoint.y = winRound.bottom;

        Projection projection = baiduMap.getProjection();
        LatLng northEast = projection.fromScreenLocation(notrhEastPoint);
        LatLng southWest = projection.fromScreenLocation(southWestPoint);

        return new LatLngBounds.Builder().include(northEast).include(southWest).build();

    }

    public static Point toGraphicsPoint(Object object) {
        final Map<?, ?> data = toMap(object);
        if (data == null) {
            return null;
        }

        Object xObj = data.get("x");
        Object yObj = data.get("y");
        if (null == xObj || null == yObj) {
            return null;
        }

        int x = toInt(xObj);
        int y = toInt(yObj);
        return new Point(x, y);
    }

    public static LatLng toLatLng(Object object) {
        final Map<?, ?> data = toMap(object);
        if (data == null) {
            return null;
        }

        Object latitude = data.get("latitude");
        Object longitude = data.get("longitude");
        if (null == latitude || null == longitude) {
            return null;
        }
        return new LatLng(toDouble(latitude), toDouble(longitude));
    }

    public static LatLngBounds toLatLngBounds(Object object) {
        final Map<?, ?> data = toMap(object);
        if (data == null) {
            return null;
        }

        Object northeast = data.get("northeast");
        Object southwest = data.get("southwest");
        if (null == northeast || null == southwest) {
            return null;
        }

        LatLng northeastLatLng = toLatLng(northeast);
        LatLng southwestLatLng = toLatLng(southwest);

        if (null == northeastLatLng || null == southwestLatLng) {
            return null;
        }

        return new LatLngBounds.Builder().include(northeastLatLng).include(southwestLatLng).build();
    }

    public static BaiduMapOptions toBaiduMapOptions(Object args) {
        if (args == null) {
            return null;
        }

        final Map<?, ?> optionsData = toMap(args);

        BaiduMapOptions baiduMapOptions = new BaiduMapOptions();
        final Object mapType = optionsData.get("mapType");
        if (mapType != null) {
            baiduMapOptions.mapType(toInt(mapType));
        }

        if (optionsData.containsKey("compassEnabled")) {
            final Boolean compassEnabled = toBoolean(optionsData.get("compassEnabled"));
            if (compassEnabled != null) {
                baiduMapOptions.compassEnabled(compassEnabled);
            }
        }

        if (optionsData.containsKey("rotateEnabled")) {
            final Boolean rotateEnabled = toBoolean(optionsData.get("rotateEnabled"));
            if (rotateEnabled != null) {
                baiduMapOptions.rotateGesturesEnabled(rotateEnabled);
            }
        }

        if (optionsData.containsKey("zoomEnabled")) {
            final Boolean zoomEnabled = toBoolean(optionsData.get("zoomEnabled"));
            if (zoomEnabled != null) {
                baiduMapOptions.zoomGesturesEnabled(zoomEnabled);
            }
        }

        if (optionsData.containsKey("scrollEnabled")) {
            final Boolean scrollEnabled = toBoolean(optionsData.get("scrollEnabled"));
            if (scrollEnabled != null) {
                baiduMapOptions.scrollGesturesEnabled(scrollEnabled);
            }
        }

        if (optionsData.containsKey("overlookEnabled")) {
            final Boolean overlookEnabled = toBoolean(optionsData.get("overlookEnabled"));
            if (overlookEnabled != null) {
                baiduMapOptions.overlookingGesturesEnabled(overlookEnabled);
            }
        }

        if (optionsData.containsKey("showMapScaleBar")) {
            final Boolean showMapScaleBar = toBoolean(optionsData.get("showMapScaleBar"));
            if (showMapScaleBar != null) {
                baiduMapOptions.scaleControlEnabled(showMapScaleBar);
            }
        }

        if (optionsData.containsKey("mapScaleBarPosition")) {
            final Point mapScaleBarPosition =
                    toGraphicsPoint(optionsData.get("mapScaleBarPosition"));
            if (mapScaleBarPosition != null) {
                baiduMapOptions.scaleControlPosition(mapScaleBarPosition);
            }
        }

        if (optionsData.containsKey("showZoomControl")) {
            final Boolean showMapZoomControl = toBoolean(optionsData.get("showZoomControl"));
            if (showMapZoomControl != null) {
                baiduMapOptions.zoomControlsEnabled(showMapZoomControl);
            }
        }

        if (optionsData.containsKey("mapZoomControlPosition")) {
            final Point mapZoomControlPosition =
                    toGraphicsPoint(optionsData.get("mapZoomControlPosition"));
            if (mapZoomControlPosition != null) {
                baiduMapOptions.zoomControlsPosition(mapZoomControlPosition);
            }
        }

        if (optionsData.containsKey("logoPosition")) {
            final Integer logoPosition = toInt(optionsData.get("logoPosition"));
            if (logoPosition != null) {
                baiduMapOptions.logoPosition(LogoPosition.values()[logoPosition]);
            }
        }

        MapStatus.Builder statusBuilder = new MapStatus.Builder();

        if (optionsData.containsKey("center")) {
            final LatLng center = toLatLng(optionsData.get("center"));
            statusBuilder.target(center);
        }

        if (optionsData.containsKey("overlooking")) {
            final Float overlooking = toFloat(optionsData.get("overlooking"));
            if (overlooking != null) {
                statusBuilder.overlook(overlooking);
            }
        }

        if (optionsData.containsKey("rotation")) {
            final Float rotation = toFloat(optionsData.get("rotation"));
            if (rotation != null) {
                statusBuilder.rotate(rotation);
            }
        }

        if (optionsData.containsKey("zoomLevel")) {
            final Float zoomLevel = toFloat(optionsData.get("zoomLevel"));
            if (zoomLevel != null) {
                statusBuilder.zoom(zoomLevel);
            }
        }

        baiduMapOptions.mapStatus(statusBuilder.build());

        return baiduMapOptions;
    }
}
