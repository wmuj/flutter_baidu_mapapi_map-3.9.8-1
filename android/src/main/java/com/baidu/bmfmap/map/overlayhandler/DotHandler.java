package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Dot;
import com.baidu.mapapi.map.DotOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.model.LatLng;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DotHandler extends OverlayHandler {

    public static final String TAG = "DotHandler";

    public DotHandler(BMFMapController bmfMapController) {
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
            case Constants.MethodProtocol.DotProtocol.sMapAddDotMethod:
                ret = addDot(argument);
                break;
            case Constants.MethodProtocol.DotProtocol.sMapUpdateDotMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addDot(Map<String, Object> argument) {
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

        if (!argument.containsKey("id")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain" + argument.toString());

            }
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        DotOptions dotOptions = new DotOptions();

        Map<String, Object> centerMap =
                new TypeConverter<Map<String, Object>>().getValue(argument, "center");
        LatLng center = FlutterDataConveter.mapToLatlng(centerMap);
        if (null == center) {
            if (Env.DEBUG) {
                Log.d(TAG, "center is null");
            }
            return false;
        }
        dotOptions.center(center);

        Double radius = new TypeConverter<Double>().getValue(argument, "radius");
        if (null == radius) {
            if (Env.DEBUG) {
                Log.d(TAG, "radius is null");
            }
            return false;
        }
        dotOptions.radius(radius.intValue());

        String colorStr = new TypeConverter<String>().getValue(argument, "color");
        if (TextUtils.isEmpty(colorStr)) {
            if (Env.DEBUG) {
                Log.d(TAG, "colorStr is null");
            }
            return false;
        }
        int color = FlutterDataConveter.strColorToInteger(colorStr);
        dotOptions.color(color);

        Integer zIndex = new TypeConverter<Integer>().getValue(argument, "zIndex");
        if (null != zIndex) {
            dotOptions.zIndex(zIndex);
        }

        Boolean visible = new TypeConverter<Boolean>().getValue(argument, "visible");
        if (null != visible) {
            dotOptions.visible(visible);
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(dotOptions);
        if (null != overlay) {
            Bundle bundle = new Bundle();
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

    /**
     * 更新Dot属性
     * @param argument
     * @return
     */
    private boolean  updateMember(Map<String, Object> argument) {
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

        Dot dot = (Dot) mOverlayMap.get(id);
        if (null == dot) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        String colorStr;
        int color;
        boolean ret = false;
        switch (member) {
            case "visible":
                Boolean visible = (Boolean) argument.get("value");
                if (null == visible) {
                    break;
                }

                dot.setVisible(visible);
                ret = true;
                break;
            case "center":
                Map<String, Object> centerMap = (Map<String, Object>) argument.get("value");
                LatLng center = FlutterDataConveter.mapToLatlng(centerMap);
                if (null == center) {
                    break;
                }

                dot.setCenter(center);
                ret = true;
                break;
            case "radius":
                Double radius = (Double) argument.get("value");
                if (null != radius) {
                    dot.setRadius(radius.intValue());
                    ret = true;
                }
                break;
            case "color":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                dot.setColor(color);
                ret = true;
                break;
            default:
                break;
        }

        return ret;
    }

    @Override
    public void clean() {
        super.clean();
        
    }
}
