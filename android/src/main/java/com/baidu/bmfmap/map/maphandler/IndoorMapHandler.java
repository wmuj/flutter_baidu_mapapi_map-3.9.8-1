package com.baidu.bmfmap.map.maphandler;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.mapapi.map.MapBaseIndoorMapInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class IndoorMapHandler extends BMapHandler {

    private static final String TAG = "IndoorMapHandler";
    
    public IndoorMapHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCallResult(Context context, MethodCall call, MethodChannel.Result result) {
        if(Env.DEBUG){
            Log.d(TAG, "handlerMethodCallResult enter");
        }
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
            case Constants.MethodProtocol.IndoorMapProtocol.sShowBaseIndoorMapMethod:
                setIndoorMap(call, result);
                break;
            case Constants.MethodProtocol.IndoorMapProtocol.sShowBaseIndoorMapPoiMethod:
                setIndoorMapPoi(call, result);
                break;
            case Constants.MethodProtocol.IndoorMapProtocol.sSwitchBaseIndoorMapFloorMethod:
                switchIndoorMapFloor(call, result);
                break;
            case Constants.MethodProtocol.IndoorMapProtocol.sGetFocusedBaseIndoorMapInfoMethod:
                getFocusedBaseIndoorMapInfo(call, result);
                break;
            default:
                break;
        }
    }


    /**
     * 室内图开关
     */
    private void setIndoorMap(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("show")) {
            result.success(false);
        }
        boolean showIndoorMap = (boolean) argument.get("show");
        mBaiduMap.setIndoorEnable(showIndoorMap);
        BMFMapStatus.getsInstance().setBaseIndoorEnable(showIndoorMap);
        result.success(true);
    }

    /**
     * 室内图poi开关
     */
    private void setIndoorMapPoi(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            result.success(false);
            return;
        }

        if(null == mBaiduMap){
            return;
        }

        if (!argument.containsKey("showIndoorPoi")) {
            result.success(false);
        }
        boolean showIndoorPoi = (boolean) argument.get("showIndoorPoi");
        mBaiduMap.showMapIndoorPoi(showIndoorPoi);
        BMFMapStatus.getsInstance().setIndoorMapPoiEnable(showIndoorPoi);
        result.success(true);
    }

    /**
     * 室内图楼层切换
     */
    private void switchIndoorMapFloor(MethodCall call, MethodChannel.Result result) {
        HashMap<String, Integer> errorMap = new HashMap<>();
        int switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.FAILED;

        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            errorMap.put("result", switchIndoorFloorSuccess);
            result.success(errorMap);
            return;
        }

        if (!argument.containsKey("floorId") || !argument.containsKey("indoorId")) {
            errorMap.put("result", switchIndoorFloorSuccess);
            result.success(errorMap);
            return;
        }
        String floorId = (String) argument.get("floorId");
        String indoorId = (String) argument.get("indoorId");
        if (floorId.isEmpty() || indoorId.isEmpty()) {
            return;
        }

        MapBaseIndoorMapInfo.SwitchFloorError switchFloorError = mBaiduMap.switchBaseIndoorMapFloor(floorId, indoorId);
        switch (switchFloorError) {
            case SWITCH_OK:
                switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.SUCCESS;
                break;
            case SWITCH_ERROR:
                switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.FAILED;
                break;
            case FOCUSED_ID_ERROR:
                switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.NOT_FOCUSED;
                break;
            case FLOOR_OVERLFLOW:
                switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.NOT_EXIST;
                break;
            case FLOOR_INFO_ERROR:
                switchIndoorFloorSuccess = Constants.SwitchIndoorFloorError.SWICH_FLOOR_INFO_ERROR;
                break;
            default:
                break;
        }

        errorMap.put("result", switchIndoorFloorSuccess);
        result.success(errorMap);
    }

    /**
     * 获取当前聚焦的室内图信息
     */
    private void getFocusedBaseIndoorMapInfo(MethodCall call, MethodChannel.Result result) {
        if (null == mBaiduMap) {
            return;
        }
        MapBaseIndoorMapInfo focusedBaseIndoorMapInfo = mBaiduMap.getFocusedBaseIndoorMapInfo();
        BMFBaseIndoorMapInfo bmfBaseIndoorMapInfo = new BMFBaseIndoorMapInfo();
        if (null != focusedBaseIndoorMapInfo) {
            bmfBaseIndoorMapInfo.strFloor = focusedBaseIndoorMapInfo.getCurFloor();
            bmfBaseIndoorMapInfo.strID = focusedBaseIndoorMapInfo.getID();
            bmfBaseIndoorMapInfo.listStrFloors = focusedBaseIndoorMapInfo.getFloors();
        }

        HashMap<String, Object> stringObjectHashMap = new HashMap<>();
        stringObjectHashMap.put("listStrFloors", bmfBaseIndoorMapInfo.listStrFloors);
        stringObjectHashMap.put("strFloor", bmfBaseIndoorMapInfo.strFloor);
        stringObjectHashMap.put("strID", bmfBaseIndoorMapInfo.strID);
        result.success(stringObjectHashMap);
    }


    static class BMFBaseIndoorMapInfo {
        private String strID = "";
        private String strFloor = "";
        private ArrayList<String> listStrFloors;
    }
}
