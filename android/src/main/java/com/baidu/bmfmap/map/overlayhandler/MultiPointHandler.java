package com.baidu.bmfmap.map.overlayhandler;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.MultiPointItem;
import com.baidu.mapapi.map.MultiPointOption;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * 3.1.0 海量点绘制
 */
public class MultiPointHandler extends OverlayHandler {
    private static final String TAG = "MultiPointHandler";

    public MultiPointHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        super.handlerMethodCall(call, result);

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
            case Constants.MethodProtocol.MultiPointProtocol.MAP_ADD_MULTIPOINT_OVERLAY_METHOD:
                ret = addMultiPointOverlay(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    private boolean addMultiPointOverlay(Map<String, Object> argument) {
        if (mMapController == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("items")
                || !argument.containsKey("icon")) {
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

        String iconStr = (String) argument.get("icon");
        if (TextUtils.isEmpty(iconStr)) {
            if (Env.DEBUG) {
                Log.d(TAG, "icon is null");
            }
            return false;
        }

        BitmapDescriptor icon = FlutterDataConveter.getIcon(iconStr);
        if (icon == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "icon is null");
            }
            return false;
        }

        ArrayList<MultiPointItem> multiPointItems = new ArrayList<>();
        List<Map<String, Object>> items = (List<Map<String, Object>>) argument.get("items");
        if (null == items || items.size() <= 0) {
            if (Env.DEBUG) {
                Log.d(TAG, "items is null");
            }
            return false;
        }

        for (int i = 0 ; i < items.size() ; i++) {
            Map<String, Object> coordinate = (Map<String, Object>) items.get(i).get("coordinate");
            if (null == coordinate) {
                continue;
            }

            LatLng latLng = FlutterDataConveter.mapToLatlng(coordinate);
            if (null == latLng) {
                continue;
            }

            String title = (String) items.get(i).get("title");
            MultiPointItem multiPointItem = new MultiPointItem(latLng);
            if (!TextUtils.isEmpty(title)) {
                multiPointItem.setTitle(title);
            }
            multiPointItems.add(multiPointItem);
        }

        if (null == multiPointItems || multiPointItems.size() <= 0) {
            if (Env.DEBUG) {
                Log.d(TAG, "items is null");
            }
            return false;
        }
        
        MultiPointOption multiPointOption = new MultiPointOption();
        multiPointOption.setIcon(icon);
        multiPointOption.setMultiPointItems(multiPointItems);

        Map<String, Double> pointSize = (Map<String, Double>) argument.get("pointSize");
        if (null != pointSize && pointSize.size() > 0) {
            Double width = pointSize.get("width");
            Double height = pointSize.get("height");
            if (null != width && null != height) {
                multiPointOption.setPointSize(width.intValue(), height.intValue());
            }
        }
        
        Map<String, Double> anchor = (Map<String, Double>) argument.get("anchor");
        if (null != anchor && anchor.size() > 0) {
            Double anchorX = anchor.get("x");
            Double anchorY = anchor.get("y");
            if (null != anchorX && null != anchorY) {
                multiPointOption.setAnchor(anchorX.floatValue(), anchorY.floatValue());
            }
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(multiPointOption);
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        bundle.putString("icon", iconStr);
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);
        mOverlayMap.put(id, overlay);
        mMapController.mOverlayIdMap.put(id, overlay);
        
        return true;
    }
}
