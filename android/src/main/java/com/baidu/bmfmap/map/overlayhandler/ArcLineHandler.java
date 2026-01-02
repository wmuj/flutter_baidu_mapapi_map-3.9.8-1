package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.ArcOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.Arc;
import com.baidu.mapapi.model.LatLng;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ArcLineHandler extends OverlayHandler {
    private static final String TAG = "ArcLineHandler";

    public ArcLineHandler(BMFMapController bmfMapController) {
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
            case Constants.MethodProtocol.ArclineProtocol.sMapAddArclinelineMethod:
                ret = addArcLine(argument);
                break;
            case Constants.MethodProtocol.ArclineProtocol.sMapUpdateArclineMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addArcLine(Map<String, Object> argument) {
        if (null == argument) {
            return false;
        }

        if (mBaiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("coordinates")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        ArcOptions arcOptions = new ArcOptions();

        final String id = (String) argument.get("id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        List<Map<String, Object>> coordinates =
                (List<Map<String, Object>>) argument.get("coordinates");

        if (coordinates == null || coordinates.size() < 3) {
            if (Env.DEBUG) {
                Log.d(TAG, "latlngs.size() < 3");
            }
            return false;
        }

        LatLng latLngStart = FlutterDataConveter.mapToLatlng(coordinates.get(0));
        LatLng latLngMiddle = FlutterDataConveter.mapToLatlng(coordinates.get(1));
        LatLng latLngEnd = FlutterDataConveter.mapToLatlng(coordinates.get(2));

        if (null == latLngStart
                || null == latLngMiddle
                || null == latLngEnd) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == latLngStart\n" +
                        "        || null == latLngMiddle\n" +
                        "        || null == latLngEnd");
            }
            return false;
        }

        arcOptions.points(latLngStart, latLngMiddle, latLngEnd);

        if (argument.containsKey("width")) {
            int width = (Integer) argument.get("width");
            arcOptions.width(width);
        }

        if (argument.containsKey("color")) {
            String strokeColorStr = (String) argument.get("color");
            int strokeColor = FlutterDataConveter.strColorToInteger(strokeColorStr);
            arcOptions.color(strokeColor);
        }

        if (argument.containsKey("zIndex")) {
            int zIndex = (Integer) argument.get("zIndex");
            arcOptions.zIndex(zIndex);
        }

        if (argument.containsKey("visible")) {
            boolean visible = (Boolean) argument.get("visible");
            arcOptions.visible(visible);
        }

        if (argument.containsKey("clickable")) {
            boolean clickable = (Boolean) argument.get("clickable");
            arcOptions.setClickable(clickable);
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = mBaiduMap.addOverlay(arcOptions);

        if (overlay != null) {
            Bundle bundle = new Bundle();
            bundle.putString("id", id);
            if (customMap != null && customMap.size() > 0) {
                bundle.putSerializable("customMap", customMap);
            }
            overlay.setExtraInfo(bundle);

            mOverlayMap.put(id, overlay);
            mMapController.mOverlayIdMap.put(id, overlay);
        }

        return true;
    }

    @Override
    public void clean() {
        super.clean();

    }

    /**
     * 更新arcline属性
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

        Arc arc = (Arc) mOverlayMap.get(id);
        if (null == arc) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        boolean ret = false;
        switch (member) {
            case "coordinates":
                ret = updateCoordinates(argument, arc);
                break;
            case "width":
                Integer width = new TypeConverter<Integer>().getValue(argument, "value");
                if (null == width) {
                    break;
                }

                arc.setWidth(width);
                ret = true;
                break;
            case "color":
                String colorStr = new TypeConverter<String>().getValue(argument, "value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                int color = FlutterDataConveter.strColorToInteger(colorStr);
                arc.setColor(color);
                ret = true;
                break;
            case "lineDashType":
                // arc不支持虚线
                break;
            case "clickable":
                Boolean clickable = new TypeConverter<Boolean>().getValue(argument, "value");
                if (null != clickable) {
                    break;
                }

                arc.setClickable(clickable);
                ret = true;
                break;
            default:
                break;
        }

        return ret;
    }


    private boolean updateCoordinates(Map<String, Object> argument, Arc arc) {
        List<Map<String, Double>> coordinates =
                new TypeConverter<List<Map<String, Double>>>().getValue(argument,
                        "value");

        if (null == coordinates) {
            return false;
        }

        List<LatLng> latLngList = FlutterDataConveter.mapToLatlngs(coordinates);
        if (null == latLngList || latLngList.size() < 3) {
            return false;
        }

        LatLng latLng0 = latLngList.get(0);
        LatLng latLng1 = latLngList.get(1);
        LatLng latLng2 = latLngList.get(2);
        arc.setPoints(latLng0, latLng1, latLng2);

        return true;
    }
}
