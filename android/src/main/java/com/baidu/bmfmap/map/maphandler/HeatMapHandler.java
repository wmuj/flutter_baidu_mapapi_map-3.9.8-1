package com.baidu.bmfmap.map.maphandler;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.HeatMapProtocol;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.ThreadPoolUtil;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.Gradient;
import com.baidu.mapapi.map.HeatMap;
import com.baidu.mapapi.map.HeatMapAnimation;
import com.baidu.mapapi.map.WeightedLatLng;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class HeatMapHandler extends BMapHandler {
    private static final String TAG = "HeapMapHandler";

    private HeatMap mHeatMap = null;

    private boolean isUpdateHeatMap = false;

    public HeatMapHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCallResult(final Context context, final MethodCall call,
                                        MethodChannel.Result result) {
        if (null == call) {
            result.success(false);
            return;
        }

        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            result.success(false);
            return;
        }

        final boolean[] ret = {false};
        switch (methodId) {
            case HeatMapProtocol.sMapAddHeatMapMethod:
                isUpdateHeatMap = false;
                ThreadPoolUtil.getInstance().execute(new Runnable() {
                    @Override
                    public void run() {
                        ret[0] = addHeapMap(context, call);
                    }});
                break;
            case HeatMapProtocol.MAP_UPDATE_HEATMAP_METHOD:
                isUpdateHeatMap = true;
                ThreadPoolUtil.getInstance().execute(new Runnable() {
                    @Override
                    public void run() {
                        ret[0] = addHeapMap(context, call);
                    }});
                break;
            case HeatMapProtocol.sMapRemoveHeatMapMethod:
                ret[0] = removeHeatMap(context, call);
                break;
            case HeatMapProtocol.sShowHeatMapMethod:
                ret[0] = isShowBaiduHeatMap(call);
                break;
            case HeatMapProtocol.sStartHeatFrameAnimationMethod:
                ret[0] = startHeatMapFrameAnimation();
                break;
            case HeatMapProtocol.sStopHeatFrameAnimationMethod:
                ret[0] = stopHeatMapFrameAnimation();
                break;
            case HeatMapProtocol.sSetHeatFrameAnimationIndexMethod:
                ret[0] = setHeatMapFrameAnimationIndex(call);
                break;

            default:
                break;
        }

        result.success(ret[0]);
    }

    public boolean startHeatMapFrameAnimation() {
        if (null == mBaiduMap) {
            return false;
        }

        mBaiduMap.startHeatMapFrameAnimation();
        return true;
    }

    public boolean stopHeatMapFrameAnimation() {
        if (null == mBaiduMap) {
            return false;
        }

        mBaiduMap.stopHeatMapFrameAnimation();
        return true;
    }

    public boolean setHeatMapFrameAnimationIndex(MethodCall call) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return false;
        }
        if (null == mBaiduMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "mBaiduMap is null");
            }
            return false;
        }

        if (!argument.containsKey("index")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain" + argument.toString());
            }
            return false;
        }

        Integer index = (Integer) argument.get("index");
        if (null == index) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument index is null");
            }
            return false;
        }
        mBaiduMap.setHeatMapFrameAnimationIndex(index);

        return true;
    }

    /**
     * 是否显示百度热力图
     */
    public boolean isShowBaiduHeatMap(MethodCall call) {
        Map<String, Object> argument = call.arguments();
        if (argument == null || !argument.containsKey("show")) {
            return false;
        }
        Boolean show = (Boolean) argument.get("show");
        if (null == show) {
            return false;
        }
        if (null == mBaiduMap) {
            return false;
        }
        mBaiduMap.setBaiduHeatMapEnabled(show);

        return true;
    }

    public boolean addHeapMap(Context context, MethodCall call) {

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return false;
        }

        Object heatMapObj = argument.get("heatMap");
        if (null == heatMapObj) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == heatMapObj");
            }
            return false;
        }

        final Map<String, Object> heatMapMap = (Map<String, Object>) heatMapObj;
        if (null == heatMapMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == heatMapMap");
            }
            return false;
        }

        if (!heatMapMap.containsKey("data")
                || !heatMapMap.containsKey("opacity")
                || !heatMapMap.containsKey("gradient")
                || !heatMapMap.containsKey("datas")
                || !heatMapMap.containsKey("mMaxHight")
                || !heatMapMap.containsKey("mMaxIntensity")
                || !heatMapMap.containsKey("mMinIntensity")
                || !heatMapMap.containsKey("animation")
                || !heatMapMap.containsKey("frameAnimation")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain" + argument.toString());

            }
            return false;
        }

        final HeatMap.Builder builder = new HeatMap.Builder();
        List<WeightedLatLng> weightedLatLngList = getData(heatMapMap);
        if (null != weightedLatLngList) {
            builder.weightedData(weightedLatLngList);
        }


        List<List<WeightedLatLng>> weightedLatLngData = getDatas(heatMapMap);
        if (null != weightedLatLngData) {
            builder.weightedDatas(weightedLatLngData);
        }

        if (null == weightedLatLngList && null == weightedLatLngData) {
            return false;
        }

        Object gradientObj = heatMapMap.get("gradient");
        if (null == gradientObj) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == gradientObj");
            }
            return false;
        }
        Map<String, Object> gradientMap = (Map<String, Object>) gradientObj;
        Gradient gradient = getGradient(gradientMap);
        if (null == gradient) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == gradient");
            }
            return false;
        }
        builder.gradient(gradient);

        Double opacity = new TypeConverter<Double>().getValue(heatMapMap, "opacity");
        if (null != opacity) {
            builder.opacity(opacity);
        }

        
        Integer maxHight = new TypeConverter<Integer>().getValue(heatMapMap, "mMaxHight");
        if (null != maxHight) {
            builder.maxHigh(maxHight);
        }
       

        Double maxIntensity = new TypeConverter<Double>().getValue(heatMapMap, "mMaxIntensity");
        if (null != maxIntensity) {
            builder.maxIntensity(maxIntensity.floatValue());
        }
        

        Double minIntensity = new TypeConverter<Double>().getValue(heatMapMap, "mMinIntensity");
        if (null != minIntensity) {
            builder.minIntensity(minIntensity.floatValue());
        }
        

        Map<String, Object>  initAnimationMap = (Map<String, Object>) heatMapMap.get("animation");
        if (null != initAnimationMap) {
            HeatMapAnimation initAnimation = getHeatMapAnimation(initAnimationMap);
            if (null != initAnimation) {
                builder.initAnimation(initAnimation);
            }
        }
        
        
        Map<String, Object>  frameAnimationMap = (Map<String, Object>) heatMapMap.get("frameAnimation");
        if (null != frameAnimationMap) {
            HeatMapAnimation frameAnimation = getHeatMapAnimation(frameAnimationMap);
            if (null != frameAnimation) {
                builder.frameAnimation(frameAnimation);
            }
        }

        if (heatMapMap.containsKey("radius")){
            Integer radius = new TypeConverter<Integer>().getValue(heatMapMap, "radius");
            if (null != radius) {
                builder.radius(radius);
            }
        }

        // 设置热力图点半径（米），默认为12米，当mRadiusIsMeter为true时生效，范围[10~50]，since 3.5.0
        if (heatMapMap.containsKey("radiusMeter")) {
            Integer radiusMeter = new TypeConverter<Integer>().getValue(heatMapMap, "radiusMeter");
            if (null != radiusMeter) {
                builder.radiusMeter(radiusMeter);
            }
        }

        // 设置热力图点半径单位是否是米，默认为false，范围[10~50]，since 3.5.0
        if (heatMapMap.containsKey("radiusIsMeter")) {
            Boolean radiusIsMeter = new TypeConverter<Boolean>().getValue(heatMapMap, "radiusIsMeter");
            if (null != radiusIsMeter) {
                builder.isRadiusMeter(radiusIsMeter);
            }
        }

        // 设置热力图最大显示等级，默认为22，范围[4~22]，since 3.5.0
        if (heatMapMap.containsKey("maxShowLevel")) {
            Integer maxShowLevel = new TypeConverter<Integer>().getValue(heatMapMap, "maxShowLevel");
            if (null != maxShowLevel) {
                builder.maxShowLevel(maxShowLevel);
            }
        }

        // 设置热力图最小显示等级，默认为4，范围[4~22]，since 3.5.0
        if (heatMapMap.containsKey("minShowLevel")) {
            Integer minShowLevel = new TypeConverter<Integer>().getValue(heatMapMap, "minShowLevel");
            if (null != minShowLevel) {
                builder.minShowLevel(minShowLevel);
            }
        }

        mHeatMap = builder.build();

        if (null == mHeatMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == mHeatMap");
            }
            return false;
        }

        if (null == mBaiduMap) {
            return false;
        }

        if (isUpdateHeatMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "updateHeatMap enter");
            }
            mBaiduMap.updateHeatMap(mHeatMap);
        } else {
            if (Env.DEBUG) {
                Log.d(TAG, "addHeatMap enter");
            }
            mBaiduMap.addHeatMap(mHeatMap);
        }

        return true;
    }

    private HeatMapAnimation getHeatMapAnimation(Map<String, Object> animationMap) {
        if (!animationMap.containsKey("duration") || !animationMap.containsKey("type")) {
            return null;
        }

        Integer duration = new TypeConverter<Integer>().getValue(animationMap, "duration");
        if (null == duration) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == duration");
            }
            return null;
        }
        Integer type = new TypeConverter<Integer>().getValue(animationMap, "type");
        if (null == type) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == type");
            }
            return null;
        }
        HeatMapAnimation.AnimationType value = HeatMapAnimation.AnimationType.values()[type];
       return new HeatMapAnimation(true, duration, value);
    }

    private List<WeightedLatLng> getData(Map<String, Object> heatMapMap) {
        List<WeightedLatLng> weightedLatLngList = null;
        Object dataObj = heatMapMap.get("data");
        if (null == dataObj) {
            return null;
        }

        List<Map<String, Object>> dataList = (List<Map<String, Object>>) dataObj;
        if (null == dataList) {
            return null;
        }

        weightedLatLngList = FlutterDataConveter.mapToWeightedLatLngList(dataList);

        return weightedLatLngList;
    }


    private List<List<WeightedLatLng>> getDatas(Map<String, Object> heatMapMap) {
        List<List<WeightedLatLng>> weightedLatLngLists = new ArrayList<List<WeightedLatLng>>();
        List<List<Map<String, Object>>>  datasList = (List<List<Map<String, Object>>>) heatMapMap.get("datas");
        if (null == datasList) {
            return null;
        }

        for (int i = 0; i < datasList.size(); i++) {
            List<Map<String, Object>> datas = datasList.get(i);
            if (null == datas) {
                return null;
            }
            List<WeightedLatLng> weightedLatLngList = FlutterDataConveter.mapToWeightedLatLngList(datas);
            if (null == weightedLatLngList) {
                return null;
            }
            weightedLatLngLists.add(weightedLatLngList);
        }

        return weightedLatLngLists;
    }

    private Gradient getGradient(Map<String, Object> heatMapMap) {
        if (!heatMapMap.containsKey("colors") || !heatMapMap.containsKey("startPoints")) {
            return null;
        }

        Object colorsObj = heatMapMap.get("colors");
        Object startPointsObj = heatMapMap.get("startPoints");
        if (null == colorsObj || null == startPointsObj) {
            return null;
        }

        List<String> colorsList = (List<String>) colorsObj;
        List<Double> startPointsList = (List<Double>) startPointsObj;
        if (null == colorsList || null == startPointsList) {
            return null;
        }

        int[] intColors = new int[colorsList.size()];
        Iterator<String> itr = colorsList.iterator();
        int i = 0;
        while (itr.hasNext()) {
            String colorStr = itr.next();
            int color = FlutterDataConveter.strColorToInteger(colorStr);
            intColors[i++] = color;
        }

        float[] startPoints = new float[startPointsList.size()];
        Iterator<Double> startPointsItr = startPointsList.iterator();
        i = 0;
        while (startPointsItr.hasNext()) {
            startPoints[i++] = startPointsItr.next().floatValue();
        }

        Gradient gradient = new Gradient(intColors, startPoints);
        return gradient;
    }

    public boolean removeHeatMap(Context context, MethodCall call) {
        if (Env.DEBUG) {
            Log.d(TAG, "switchHeatMap enter");
        }

        if (null == mHeatMap) {
            return false;
        }

        mHeatMap.removeHeatMap();
        mHeatMap = null;

        return true;
    }

}