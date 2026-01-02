package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Overlay;

import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class OverlayHandler {
    private static final String TAG = "OverlayHandler";

    protected BMFMapController mMapController;

    protected BaiduMap mBaiduMap;

    protected final HashMap<String, Overlay> mOverlayMap = new HashMap<>();
    
    public OverlayHandler(BMFMapController bmfMapController) {
        this.mMapController = bmfMapController;
        if (mMapController != null) {
            this.mBaiduMap = mMapController.getBaiduMap();
        }
    }
    
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

        switch (methodId) {
            case Constants.MethodProtocol.OverlayProtocol.sMapRemoveOverlayMethod:
                removeOneOverLayById(call, result);
                break;
            default:
                break;
        }
    }

    private boolean removeOneOverLayById(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();

        if (argument == null) {
            result.success(false);
            return false;
        }
        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            result.success(false);
            return false;
        }

        Overlay overlay = mOverlayMap.get(id);
        if (null == overlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "not found overlay with id:" + id);
            }
            result.success(false);
            return false;
        }

        overlay.remove();
        if (mOverlayMap != null) {
            mOverlayMap.remove(id);
        }
        result.success(true);
        
        if (Env.DEBUG) {
            Log.d(TAG, "remove Overlay success");
        }
        return true;
    }

    public void addOneOverlay(Map<String, Overlay> overlayMap) {
        if (mOverlayMap != null) {
            mOverlayMap.putAll(overlayMap);
        }
    }

    /**
     * 清理所有
     */
    public void clean() {
        if (mOverlayMap != null && mOverlayMap.size() > 0) {
            mOverlayMap.clear();
        }
    }

    /**
     * 清理指定id的overlay
     *
     * @param id
     */
    public void clean(String id) {

    }
}
