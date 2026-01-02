package com.baidu.bmfmap.map.overlayhandler;

import static com.baidu.bmfmap.utils.Constants.MethodProtocol.TraceProtocol.TRACE_OVERLAY_ANIMATION_DID_END_CALLBACK;
import static com.baidu.bmfmap.utils.Constants.MethodProtocol.TraceProtocol.TRACE_OVERLAY_ANIMATION_DID_START_CALLBACK;
import static com.baidu.bmfmap.utils.Constants.MethodProtocol.TraceProtocol.TRACE_OVERLAY_ANIMATION_RUNNING_PROGRESS_CALLBACK;
import static com.baidu.bmfmap.utils.Constants.MethodProtocol.TraceProtocol.TRACE_OVERLAY_ANIMATION_UPDATE_POSITION_CALLBACK;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.BMFFileUtils;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BM3DModelOptions;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.track.TraceAnimationListener;
import com.baidu.mapapi.map.track.TraceOptions;
import com.baidu.mapapi.map.track.TraceOverlay;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * 3.1.0 动态轨迹绘制
 */
public class TraceHandler extends OverlayHandler implements TraceAnimationListener {
    private static final String TAG = "TraceHandler";

    protected final HashMap<String, TraceOverlay> mTraceOverlayMap = new HashMap<>();

    private BMFFileUtils mFileUtils;

    public TraceHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
        mFileUtils = BMFFileUtils.getInstance();
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
            case Constants.MethodProtocol.TraceProtocol.MAP_ADD_TRACE_OVERLAY_METHOD:
                ret = addTraceOverlay(argument);
                break; 
            case Constants.MethodProtocol.TraceProtocol.MAP_REMOVE_TRACE_OVERLAY_METHOD:
                ret = removeOneTraceOverLayById(argument);
                break;
            case Constants.MethodProtocol.TraceProtocol.MAP_PAUSE_TRACE_OVERLAY_METHOD:
                ret = pauseOneTraceOverLayById(argument);
                break;
            case Constants.MethodProtocol.TraceProtocol.MAP_RESUME_TRACE_OVERLAY_METHOD:
                ret = resumeOneTraceOverLayById(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    private boolean resumeOneTraceOverLayById(Map<String, Object> argument) {
        if (mMapController == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        TraceOverlay overlay = mTraceOverlayMap.get(id);
        if (null == overlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "not found overlay with id:" + id);
            }
            return false;
        }

        overlay.resume();

        if (Env.DEBUG) {
            Log.d(TAG, "pause trace Overlay success");
        }
        return true;
    }

    private boolean pauseOneTraceOverLayById(Map<String, Object> argument) {
        if (mMapController == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        TraceOverlay overlay = mTraceOverlayMap.get(id);
        if (null == overlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "not found overlay with id:" + id);
            }
            return false;
        }

        overlay.pause();

        if (Env.DEBUG) {
            Log.d(TAG, "resume trace Overlay success");
        }
        return true;
    }

    private boolean addTraceOverlay(Map<String, Object> argument) {
        if (mMapController == null) {
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

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }

        if (mTraceOverlayMap.containsKey(id)) {
            return false;
        }

        List<Map<String, Double>> coordinates =
                (List<Map<String, Double>>) argument.get("coordinates");
        List<LatLng> latLngList = FlutterDataConveter.mapToLatlngs(coordinates);
        if (null == latLngList) {
            if (Env.DEBUG) {
                Log.d(TAG, "latLngList is null");
            }
            return false;
        }

        final TraceOptions traceOptions = new TraceOptions();
        traceOptions.points(latLngList);
        
        Map<String, Object> traceOverlayAnimateOption = 
                (Map<String, Object>) argument.get("traceOverlayAnimateOption");
        if (null != traceOverlayAnimateOption && traceOverlayAnimateOption.size() > 0) {
            Boolean animate = (Boolean) traceOverlayAnimateOption.get("animate");
            if (null != animate) {
                traceOptions.animate(animate);
            }

            Double delay = (Double) traceOverlayAnimateOption.get("delay");
            if (null != delay) {
                traceOptions.animationDuration(delay.intValue() * 1000);
            }

            Double duration = (Double) traceOverlayAnimateOption.get("duration");
            if (null != duration) {
                traceOptions.animationTime(duration.intValue() * 1000);
            }

            Integer easingCurve = (Integer) traceOverlayAnimateOption.get("easingCurve");
            if (null != easingCurve) {
                traceOptions.animationType(TraceOptions.TraceAnimateType.values()[easingCurve]);
            }

            Boolean trackMove = (Boolean) traceOverlayAnimateOption.get("trackMove");
            if (null != trackMove) {
                traceOptions.setTrackMove(trackMove);
            }

            Boolean isPointMove = (Boolean) traceOverlayAnimateOption.get("isPointMove");
            if (null != isPointMove) {
                traceOptions.setPointMove(isPointMove);
            }

            Boolean isRotateWhenTrack = (Boolean) traceOverlayAnimateOption.get("isRotateWhenTrack");
            if (null != isRotateWhenTrack) {
                traceOptions.setRotateWhenTrack(isRotateWhenTrack);
            }

            String icon = (String) traceOverlayAnimateOption.get("icon");
            if (!TextUtils.isEmpty(icon)) {
                BitmapDescriptor bitmapDescriptor =
                        BitmapDescriptorFactory.fromAsset("flutter_assets/" + icon);
                traceOptions.icon(bitmapDescriptor);
            }

            Map<String, Object> modelOption =
                    (Map<String, Object>) traceOverlayAnimateOption.get("modelOption");
            if (null != modelOption && modelOption.size() > 0) {
                BM3DModelOptions bm3DModelOptions = addBM3DModelOverlay(modelOption);
                if (bm3DModelOptions != null) {
                    traceOptions.icon3D(bm3DModelOptions);
                }
            }
        }

        Integer width = (Integer) argument.get("width");
        if (null != width) {
            traceOptions.width(width);
        }

        String fillColorStr = (String) argument.get("fillColor");
        if (!TextUtils.isEmpty(fillColorStr)) {
            Integer fillColor = FlutterDataConveter.getColor(fillColorStr);
            if (null != fillColor) {
                traceOptions.color(fillColor);
            }
        }

        // 轨迹的strokeColors 用于颜色绘制 since 3.5.0
        // 注意：strokeColors 长度与轨迹点的个数必须保持一致
        List<String> strokeColors = (List<String>) argument.get("strokeColors");
        if (strokeColors != null && strokeColors.size() > 0) {
            int[] colors = new int[strokeColors.size()];
            for (int i = 0 ; i < strokeColors.size() ; i++) {
                colors[i] = FlutterDataConveter.getColor(strokeColors.get(i));
            }
            traceOptions.colors(colors);
        }

        // 是否使用渐变色 默认为false since 3.5.0
        // 注意：要配合strokeColors使用，否则无效
        Boolean isGradientColor = (Boolean) argument.get("isGradientColor");
        if (null != isGradientColor) {
            traceOptions.useColorArray(isGradientColor);
        }

        // 是否使用发光效果 默认为false since 3.5.0
        Boolean isTrackBloom = (Boolean) argument.get("isTrackBloom");
        if (null != isTrackBloom) {
            traceOptions.setTrackBloom(isTrackBloom);
        }

        // 轨迹发光参数 since 3.5.0
        // 取值范围 [1.0f ~ 10.0f]，默认值为 5.0f
        // 注意：渐变发光模式下该属性生效
        Double bloomSpeed = (Double) argument.get("bloomSpeed");
        if (null != bloomSpeed) {
            traceOptions.setBloomSpeed(Double.valueOf(bloomSpeed).floatValue());
        }

        // 是否需要对TraceOverlay坐标数据进行抽稀，默认为true since 3.5.0
        Boolean isThined = (Boolean) argument.get("isThined");
        if (null != isThined) {
            traceOptions.setDataReduction(isThined);
        }

        // 是否需要对TraceOverlay坐标数据进拐角平滑，默认为true since 3.5.0
        Boolean isCornerSmooth = (Boolean) argument.get("isCornerSmooth");
        if (null != isCornerSmooth) {
            traceOptions.setDataSmooth(isCornerSmooth);
        }

        final Double fromValue = (Double) argument.get("fromValue");
        final Double toValue = (Double) argument.get("toValue");
        final String strokeColor = (String) argument.get("strokeColor");

        final TraceOverlay overlay = baiduMap.addTraceOverlay(traceOptions, new TraceAnimationListener() {
            @Override
            public void onTraceAnimationUpdate(float percent) {
                MethodChannel methodChannel = mMapController.getMethodChannel();
                if (null == methodChannel) {
                    return;
                }
                HashMap<String, Object> traceOverlayMap = new HashMap<>();
                HashMap<String, Object> optionMap = traceOverlayOptionMap(traceOptions,
                        fromValue, toValue, strokeColor, id);
                traceOverlayMap.put("traceOverlay", optionMap);
                traceOverlayMap.put("progress", (double) percent);
                if (percent == 0) {
                    methodChannel.invokeMethod(TRACE_OVERLAY_ANIMATION_DID_START_CALLBACK, traceOverlayMap,
                            new MethodChannel.Result() {
                        @Override
                        public void success(@Nullable Object result) {
                            if (Env.DEBUG) {
                                Log.d(TAG, "onTraceAnimationUpdate methodChannel is success: ");
                            }
                        }

                        @Override
                        public void error(String errorCode, @Nullable String errorMessage,
                                          @Nullable Object errorDetails) {
                            if (Env.DEBUG) {
                                Log.d(TAG, "error: " + " errorCode : " + errorCode
                                        + " errorMessage: " + errorMessage);
                            }
                        }

                        @Override
                        public void notImplemented() {

                        }
                    });
                }

                methodChannel.invokeMethod(TRACE_OVERLAY_ANIMATION_RUNNING_PROGRESS_CALLBACK, traceOverlayMap,
                        new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        if (Env.DEBUG) {
                            Log.d(TAG, "onTraceAnimationUpdate methodChannel is success: ");
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                        if (Env.DEBUG) {
                            Log.d(TAG, "onTraceAnimationUpdate error: " + " errorCode : " +
                                    errorCode + " errorMessage: " + errorMessage);
                        }
                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }

            @Override
            public void onTraceUpdatePosition(LatLng latLng) {
                MethodChannel methodChannel = mMapController.getMethodChannel();
                if (null == latLng || null == methodChannel) {
                    return;
                }
                HashMap<String, Object> coordinateMap = new HashMap<>();
                HashMap<String, Double> coord = new HashMap<>();
                coord.put("latitude", latLng.latitude);
                coord.put("longitude", latLng.longitude);
                coordinateMap.put("coord", coord);
                methodChannel.invokeMethod(TRACE_OVERLAY_ANIMATION_UPDATE_POSITION_CALLBACK,
                        coordinateMap, new MethodChannel.Result() {
                            @Override
                            public void success(@Nullable Object result) {
                                if (Env.DEBUG) {
                                    Log.d(TAG, "onTraceUpdatePosition methodChannel is success: ");
                                }
                            }

                            @Override
                            public void error(String errorCode, @Nullable String errorMessage,
                                              @Nullable Object errorDetails) {
                                if (Env.DEBUG) {
                                    Log.d(TAG, "onTraceUpdatePosition error: " +" errorCode : " +
                                            ""+ errorCode + " errorMessage: " + errorMessage);
                                }
                            }

                            @Override
                            public void notImplemented() {

                            }
                        });
            }

            @Override
            public void onTraceAnimationFinish() {
                MethodChannel methodChannel = mMapController.getMethodChannel();
                if (null == methodChannel) {
                    if (Env.DEBUG) {
                        Log.d(TAG, "onTraceAnimationFinish:  methodChannel is null");
                    }
                    return;
                }
                Log.e(TAG, "onTraceAnimationFinish: " );
                HashMap<String, Object> traceOverlayMap = new HashMap<>();
                HashMap<String, Object> optionMap = traceOverlayOptionMap(traceOptions,
                        fromValue, toValue, strokeColor, id);
                traceOverlayMap.put("traceOverlay", optionMap);
                traceOverlayMap.put("flag", true);
                methodChannel.invokeMethod(TRACE_OVERLAY_ANIMATION_DID_END_CALLBACK,
                        traceOverlayMap, new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object result) {
                        if (Env.DEBUG) {
                            Log.e(TAG, "onTraceAnimationFinish is success: ");
                        }
                    }

                    @Override
                    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                        if (Env.DEBUG) {
                            Log.d(TAG, "onTraceAnimationFinish error: " +" errorCode : " +
                                    ""+ errorCode + " errorMessage: " + errorMessage);
                        }
                    }

                    @Override
                    public void notImplemented() {

                    }
                });
            }
        });
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        mTraceOverlayMap.put(id, overlay);
        return true;
    }

    private BM3DModelOptions addBM3DModelOverlay(Map<String, Object> option) {
        if (mFileUtils == null) {
            return null;
        }

        String modelPath = (String) option.get("modelPath");
        if (TextUtils.isEmpty(modelPath)) {
            if (Env.DEBUG) {
                Log.d(TAG, "modelPath is null");
            }
            return null;
        }

        String modelName = (String) option.get("modelName");
        if (TextUtils.isEmpty(modelName)) {
            if (Env.DEBUG) {
                Log.d(TAG, "modelName is null");
            }
            return null;
        }

        String parentPath = mFileUtils.getDirPath(modelPath);
        if (TextUtils.isEmpty(parentPath)) {
            return null;
        }

        BM3DModelOptions bm3DModelOptions = new BM3DModelOptions();
        bm3DModelOptions.setModelPath(parentPath);
        bm3DModelOptions.setModelName(modelName);

        Integer yawAxis = (Integer) option.get("yawAxis");
        if (null != yawAxis) {
            bm3DModelOptions.setYawAxis(BM3DModelOptions.ModelYawAxis.values()[yawAxis]);
        }

        Integer type = (Integer) option.get("type");
        if (null != type) {
            bm3DModelOptions.setBM3DModelType(BM3DModelOptions.BM3DModelType.values()[type]);
        }

        Double offsetX = (Double) option.get("offsetX");
        Double offsetY = (Double) option.get("offsetX");
        Double offsetZ = (Double) option.get("offsetX");
        if (null != offsetX && null != offsetY && null != offsetZ) {
            bm3DModelOptions.setOffset(offsetX.floatValue(), offsetY.floatValue(), offsetZ.floatValue());
        }

        Double rotateX = (Double) option.get("rotateX");
        Double rotateY = (Double) option.get("rotateY");
        Double rotateZ = (Double) option.get("rotateZ");

        if (null != rotateX && null != rotateY && null != rotateZ) {
            bm3DModelOptions.setRotate(rotateX.floatValue(), rotateY.floatValue(), rotateZ.floatValue());
        }

        Double scale = (Double) option.get("scale");
        if (null != scale) {
            bm3DModelOptions.setScale(scale.floatValue());
        }

        Boolean zoomFixed = (Boolean) option.get("zoomFixed");
        if (null != zoomFixed) {
            bm3DModelOptions.setZoomFixed(zoomFixed);
        }

        // 以下只支持带有animations标签的GLTF模型
        // 模型动画是否可用，默认为false：添加后不执行动画，值为true时添加后立即按照配置参数执行动画，since 3.5.0
        Boolean animationIsEnable = (Boolean) option.get("animationIsEnable");
        if (null != animationIsEnable) {
            bm3DModelOptions.setSkeletonAnimationEnable(animationIsEnable);
        }

        // 模型动画重复执行次数，默认0：动画将一直执行动画，since 3.5.0
        Integer animationRepeatCount = (Integer) option.get("animationRepeatCount");
        if (null != animationIsEnable) {
            bm3DModelOptions.animationRepeatCount(animationRepeatCount);
        }

        // 当前模型动画索引值，since 3.5.0
        Integer animationIndex = (Integer) option.get("animationIndex");
        if (null != animationIndex) {
            bm3DModelOptions.animationIndex(animationIndex);
        }

        // 模型动画倍速，默认：1.0，since 3.5.0
        Double animationSpeed = (Double) option.get("animationSpeed");
        if (null != animationSpeed) {
            bm3DModelOptions.animationSpeed(animationSpeed.floatValue());
        }

        return bm3DModelOptions;
    }

    private boolean removeOneTraceOverLayById(Map<String, Object> argument) {
        if (mMapController == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }
        
        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        TraceOverlay overlay = mTraceOverlayMap.get(id);
        if (null == overlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "not found overlay with id:" + id);
            }
            return false;
        }

        overlay.remove();
        if (mTraceOverlayMap != null) {
            mTraceOverlayMap.remove(id);
        }

        if (Env.DEBUG) {
            Log.d(TAG, "remove Overlay success");
        }
        return true;
    }
    
    @Override
    public void onTraceAnimationUpdate(float i) {

    }

    @Override
    public void onTraceUpdatePosition(LatLng latLng) {

    }

    @Override
    public void onTraceAnimationFinish() {

    }

    @Override
    public void clean() {
        super.clean();

        if (mTraceOverlayMap != null && mTraceOverlayMap.size() > 0) {
            mTraceOverlayMap.clear();
        }
    }

    private HashMap<String, Object> traceOverlayOptionMap(TraceOptions traceOptions, Double fromValue,
                                                           Double toValue, String strokeColor, String id) {

        HashMap<String, Object> optionMap = new HashMap<>();
        HashMap<String, Object> traceOverlayAnimateOptionMap = new HashMap<>();
        traceOverlayAnimateOptionMap.put("animate", traceOptions.isAnimation());
        traceOverlayAnimateOptionMap.put("delay", (double) traceOptions.getAnimationDuration());
        traceOverlayAnimateOptionMap.put("duration", (double) traceOptions.getAnimationTime());
        // android 不支持此参数，回调给用户传入的参数
        if (null != fromValue) {
            traceOverlayAnimateOptionMap.put("fromValue", fromValue);
        } else {
            traceOverlayAnimateOptionMap.put("fromValue", 0.0d);
        }

        if (null != toValue) {
            traceOverlayAnimateOptionMap.put("toValue", toValue);
        } else {
            traceOverlayAnimateOptionMap.put("toValue", 0.0d);
        }
        traceOverlayAnimateOptionMap.put("trackMove", traceOptions.isTrackMove());
        traceOverlayAnimateOptionMap.put("easingCurve", traceOptions.getAnimateType().ordinal());
        traceOverlayAnimateOptionMap.put("isPointMove", traceOptions.isPointMove());
        traceOverlayAnimateOptionMap.put("isRotateWhenTrack", traceOptions.isRotateWhenTrack());

        optionMap.put("width", traceOptions.getWidth());
        optionMap.put("fillColor", Integer.toHexString(traceOptions.getColor()));
        if (null != strokeColor) {
            optionMap.put("strokeColor", strokeColor);
        } else {
            optionMap.put("strokeColor", "");
        }
        optionMap.put("traceOverlayAnimateOption", traceOverlayAnimateOptionMap);
        List<Object> latlngLists = new ArrayList<>();
        List<LatLng> points = traceOptions.getPoints();
        if (null != points) {
            for (int i = 0; i < points.size(); i++) {
                HashMap<String, Double> latlngHashMap = new HashMap<>();
                latlngHashMap.put("latitude", points.get(i).latitude);
                latlngHashMap.put("longitude", points.get(i).longitude);
                latlngLists.add(latlngHashMap);
            }
        }
        optionMap.put("coordinates", latlngLists);
        optionMap.put("id", id);
        return optionMap;
    }
}
