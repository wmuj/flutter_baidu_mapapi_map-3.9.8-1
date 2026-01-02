package com.baidu.bmfmap.map.maphandler;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.map.FlutterMapViewWrapper;
import com.baidu.mapapi.map.BaiduMap;

import android.content.Context;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public abstract class BMapHandler {
    protected BMFMapController mMapController;
    protected BaiduMap mBaiduMap;
    
    public BMapHandler(BMFMapController bmfMapController) {
        this.mMapController = bmfMapController;
        if (bmfMapController != null) {
            mBaiduMap = bmfMapController.getBaiduMap();
        }
    }

    public abstract void handlerMethodCallResult(Context context, MethodCall call,
                                                 MethodChannel.Result result);
    
    public void clean() {
    }
}
