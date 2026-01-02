package com.baidu.bmfmap.map.maphandler;

import android.content.Context;
import android.graphics.Point;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.Projection;
import com.baidu.mapapi.model.LatLng;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static com.baidu.bmfmap.utils.Constants.ErrorCode;

class ProjectionHandler extends BMapHandler {

    private static final String TAG = "ProjectionHandler";
    private Projection mProjection = null;

    public ProjectionHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCallResult(Context context, MethodCall call, MethodChannel.Result result){
        if(Env.DEBUG){
            Log.d(TAG, "handlerMethodCallResult");
        }

        if (mMapController == null) {
            result.success(null);
            return;
        }

        if (null != mMapController && null != mMapController.getBaiduMap()){
            mProjection = mMapController.getBaiduMap().getProjection();
        }

        if (null == call) {
            result.success(null);
            return;
        }

        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            if(Env.DEBUG){
                Log.d(TAG, "methodId is null");
            }
            result.success(null);
            return;
        }

        switch (methodId) {
            case Constants.MethodProtocol.ProjectionMethodId.sFromScreenLocation:
                fromScreenLocation(call, result);
                break;
            case Constants.MethodProtocol.ProjectionMethodId.sToScreenLocation:
                toScreenLocation(call, result);
                break;
            case Constants.MethodProtocol.ProjectionMethodId.SCREEN_POINT_FROM_MAP_POINT_3METHOD:
                geoPoint3toScreenLocation(call, result);
                break;
            default:
                break;
        }
    }

    private boolean geoPoint3toScreenLocation(MethodCall call, MethodChannel.Result result) {
        if (mProjection == null) {
            return false;
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }

            result.error(String.valueOf(ErrorCode.sErrorNullFlutterParam)
                    , "MethodCall arguments is null"
                    ,null);
            return false;
        }
        if (!argument.containsKey("coordinate") || !argument.containsKey("height")) {
            return false;
        }
        Map<String, Object> coordinateMap = (Map<String, Object>) argument.get("coordinate");

        if (null == coordinateMap) {
            return false;
        }
        LatLng latLng = FlutterDataConveter.mapToLatlng(coordinateMap);
        Double height = new TypeConverter<Double>().getValue(argument, "height");
        if (null == latLng || null == height) {
            return false;
        }
        Point point = mProjection.geoPoint3toScreenLocation(latLng, height.intValue());
        if (null == point) {
            return false;
        }
        final Map<String, Double> pointMap = FlutterDataConveter.pointToMap(point);
        result.success(new HashMap<String, Object>(){
            {
                put("point", pointMap);
            }
        });
        return true;
    }

    /**
     * 将屏幕坐标转换成地理坐标
     *
     * @param call
     * @param result
     * @return 地理坐标
     */
    public boolean fromScreenLocation(MethodCall call, MethodChannel.Result result) {
        if(Env.DEBUG){
            Log.d(TAG, "fromScreenLocation enter");
        }
        if (mProjection == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if(null == argument){
            if(Env.DEBUG){
                Log.d(TAG, "argument is null");
            }

            result.error(String.valueOf(ErrorCode.sErrorNullFlutterParam)
                       , "MethodCall arguments is null"
                    ,null);
            return false;
        }

        Map<String, Object> pointMap = (Map<String, Object> )argument.get("point");

        Point point = FlutterDataConveter.mapToPoint(pointMap);

        if(null == point){
            result.error(String.valueOf(ErrorCode.sErrorParamConvertFailed)
                    , "conver pointMap failed"
                    ,null);
            if(Env.DEBUG){
                Log.d(TAG, "conver pointMap failed");
            }
            return false;
        }


        LatLng latLng = mProjection.fromScreenLocation(point);

        if(null == latLng){
            result.error(String.valueOf(ErrorCode.sErrorEngineError)
                    , "引擎调用失败"
                    ,null);
            if(Env.DEBUG){
                Log.d(TAG, "fromScreenLocation failed");
            }
            return false;
        }


        final Map<String, Double> resultMap = FlutterDataConveter.latLngToMap(latLng);

        if(Env.DEBUG){
            Log.d(TAG, "handlerMethodCallResult success");
        }

        result.success(new HashMap<String, Object>(){
            {
                put("coordinate",resultMap);
            }
        });

        return true;
    }

    /**
     * 将地理坐标转换成屏幕坐标
     *
     * @return 屏幕坐标
     */
    public boolean toScreenLocation(MethodCall call, MethodChannel.Result result) {
        if (mProjection == null) {
            return false;
        }

        Map<String, Object> argument = call.arguments();
        if(null == argument){
            if(Env.DEBUG){
                Log.d(TAG, "argument is null");
            }

            result.error(String.valueOf(ErrorCode.sErrorNullFlutterParam)
                    , "MethodCall arguments is null"
                    ,null);
            return false;
        }

        Map<String, Object> coordinateMap = (Map<String, Object> )argument.get("coordinate");

        LatLng latLng = FlutterDataConveter.mapToLatlng(coordinateMap);
        if(null == latLng){
            result.error(String.valueOf(ErrorCode.sErrorParamConvertFailed)
                    , "MethodCall arguments is null"
                    ,null);
            if(Env.DEBUG){
                Log.d(TAG, "null == latLng");
            }
            return false;
        }

        Point point = mProjection.toScreenLocation(latLng);
        if(null == point){
            result.error(String.valueOf(ErrorCode.sErrorEngineError)
                    , "MethodCall arguments is null"
                    ,null);
            if(Env.DEBUG){
                Log.d(TAG, "null == point");
            }
            return false;
        }

        final Map<String, Double> pointMap = FlutterDataConveter.pointToMap(point);

        if(Env.DEBUG){
            Log.d(TAG, "toScreenLocation success");
        }
        
        result.success(new HashMap<String, Object>(){
            {
                put("point",pointMap);
            }
        });

        return true;
    }

//    /**
//     * 该方法把以米为计量单位的距离（沿赤道）在当前缩放水平下转换到一个以像素（水平）为计量单位的距离。 在默认的Mercator投影变换下，对于给定的距离，当远离赤道时，变换后确切的像素数量会增加。
//     *
//     * @param meters 以米为单位的距离
//     * @return 相对给定距离的像素数量。在当前的缩放水平，如果沿赤道测量，返回值可能是个近似值
//     */
//    public float metersToEquatorPixels(MethodCall call, MethodChannel.Result result) {
//        if (meters <= 0) {
//            return 0;
//        }
//
//        return (float) (meters / (mBaseMap.getZoomUnitsInMeter()));
//    }

}