package com.baidu.bmfmap.map.overlayhandler;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.BMFFileUtils;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BM3DModel;
import com.baidu.mapapi.map.BM3DModelOptions;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.model.LatLng;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BM3DModelHandler extends OverlayHandler {
    private static final String TAG = "BM3DModelHandler";

    private BMFFileUtils mFileUtils;

    public BM3DModelHandler(BMFMapController bmfMapController) {
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
            case Constants.MethodProtocol.BM3DModelProtocol.MAP_ADD_3DMODEL_OVERLAY_METHOD:
                ret = addBM3DModelOverlay(argument);
                break;
            case Constants.MethodProtocol.BM3DModelProtocol.MAP_UPDATE_3DMODEL_OVERLAY_MEMBER_METHOD:
                ret = update3DModel(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    private boolean update3DModel(Map<String, Object> argument) {

        if (null == mMapController || null == mMapController.mOverlayIdMap) {
            return false;
        }
        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "id is null");
            }
            return false;
        }
        BM3DModel bm3DModel = (BM3DModel) mMapController.mOverlayIdMap.get(id);
        if (null == bm3DModel) {
            if (Env.DEBUG) {
                Log.d(TAG, "bm3DModel is null");
            }
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            if (Env.DEBUG) {
                Log.d(TAG, "member is null");
            }
            return false;
        }

        Object object = new TypeConverter<String>().getValue(argument, "value");
        if (null == object) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        boolean isSuccess = false;
        switch (member) {
            case "center":
                isSuccess = update3DModeCenter(object, bm3DModel);
                break;
            case "optionAndcenter":
                isSuccess = updateCenter3DModeOption(object, bm3DModel);
                break;
            case "option":
                isSuccess = update3DModeOption(object, bm3DModel);
                break;
            default:
                break;
        }

        return isSuccess;

    }

    private boolean updateCenter3DModeOption(Object object, BM3DModel bm3DModel) {
        HashMap<String,Object> valueMap = (HashMap<String,Object>) object;
        if (null == valueMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        HashMap<String,Object> optionMap = (HashMap<String, Object>) valueMap.get("option");
        if (null != optionMap) {
            imp3DModeOption(optionMap, bm3DModel);
        }
        HashMap<String,Object> centerMap = (HashMap<String, Object>) valueMap.get("center");
        if (null != centerMap) {
            LatLng position = FlutterDataConveter.mapToLatlng(centerMap);
            if (null != position) {
                bm3DModel.setPosition(position);
            }
        }
        return true;
    }

    private boolean update3DModeOption(Object object, BM3DModel bm3DModel) {
        HashMap<String,Object> valueMap = (HashMap<String,Object>) object;
        if (null == valueMap) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return false;
        }

        HashMap<String,Object> optionMap = (HashMap<String, Object>) valueMap.get("option");
        if (null != optionMap) {
            imp3DModeOption(optionMap, bm3DModel);
        }
        return true;
    }

    private void imp3DModeOption(HashMap<String, Object> valueMap, BM3DModel bm3DModel) {
        String modelPath = (String) valueMap.get("modelPath");
        if (null == mFileUtils) {
            return;
        }
        String parentPath = mFileUtils.getDirPath(modelPath);
        if (!TextUtils.isEmpty(parentPath)) {
            bm3DModel.setModelPath(parentPath);
        }
        String modelName = (String) valueMap.get("modelName");
        if (!TextUtils.isEmpty(modelName)) {
            bm3DModel.setModelName(modelName);
        }

        Double scale = (Double) valueMap.get("scale");
        if (null != scale) {
            bm3DModel.setScale(scale.floatValue());
        }
        Boolean zoomFixed = (Boolean) valueMap.get("zoomFixed");
        if (null != zoomFixed) {
            bm3DModel.setZoomFixed(zoomFixed);
        }

        Double rotateX = (Double) valueMap.get("rotateX");
        Double rotateY = (Double) valueMap.get("rotateY");
        Double rotateZ = (Double) valueMap.get("rotateZ");
        if (null != rotateX && null != rotateY && null != rotateZ) {
            bm3DModel.setRotate(rotateX.floatValue(), rotateY.floatValue(), rotateZ.floatValue());
        }
        Double offsetX = (Double) valueMap.get("offsetX");
        Double offsetY = (Double) valueMap.get("offsetY");
        Double offsetZ = (Double) valueMap.get("offsetZ");
        if (null != offsetX && null != offsetY && null != offsetZ) {
            bm3DModel.setOffset(offsetX.floatValue(), offsetY.floatValue(), offsetZ.floatValue());
        }

        // 以下只支持带有animations标签的GLTF模型
        // 模型动画是否可用，默认为false：添加后不执行动画，值为true时添加后立即按照配置参数执行动画，since 3.5.0
        Boolean animationIsEnable = (Boolean) valueMap.get("animationIsEnable");
        if (null != animationIsEnable) {
            bm3DModel.setSkeletonAnimationEnable(animationIsEnable);
        }

        // 模型动画重复执行次数，默认0：动画将一直执行动画，since 3.5.0
        Integer animationRepeatCount = (Integer) valueMap.get("animationRepeatCount");
        if (null != animationIsEnable) {
            bm3DModel.setAnimationRepeatCount(animationRepeatCount);
        }

        // 当前模型动画索引值，since 3.5.0
        Integer animationIndex = (Integer) valueMap.get("animationIndex");
        if (null != animationIndex) {
            bm3DModel.setAnimationIndex(animationIndex);
        }

        // 模型动画倍速，默认：1.0，since 3.5.0
        Double animationSpeed = (Double) valueMap.get("animationSpeed");
        if (null != animationSpeed) {
            bm3DModel.setAnimationSpeed(animationSpeed.floatValue());
        }
    }

    private boolean update3DModeCenter(Object object, BM3DModel bm3DModel) {
        HashMap<String,Object> valueMap = (HashMap<String,Object>) object;
        if (null == valueMap) {
            return false;
        }
        LatLng position = FlutterDataConveter.mapToLatlng(valueMap);
        if (null == position) {
            if (Env.DEBUG) {
                Log.d(TAG, "position is null");
            }
            return false;
        }
        bm3DModel.setPosition(position);
        return true;
    }


    private boolean addBM3DModelOverlay(Map<String, Object> argument) {
        if (mMapController == null) {
            return false;
        }

        if (mFileUtils == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("center")
                || !argument.containsKey("option")) {
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

        Map<String, Object> center = (Map<String, Object>) argument.get("center");
        if (null == center || center.size() <= 0) {
            return false;
        }
        
        LatLng position = FlutterDataConveter.mapToLatlng(center);
        if (null == position) {
            if (Env.DEBUG) {
                Log.d(TAG, "position is null");
            }
            return false;
        }

        Map<String, Object> option = (Map<String, Object>) argument.get("option");
        String modelPath = (String) option.get("modelPath");
        if (TextUtils.isEmpty(modelPath)) {
            if (Env.DEBUG) {
                Log.d(TAG, "modelPath is null");
            }
            return false;
        }

        String modelName = (String) option.get("modelName");
        if (TextUtils.isEmpty(modelName)) {
            if (Env.DEBUG) {
                Log.d(TAG, "modelName is null");
            }
            return false;
        }

        String parentPath = mFileUtils.getDirPath(modelPath);
        if (TextUtils.isEmpty(parentPath)) {
            return false;
        }
        BM3DModelOptions bm3DModelOptions = new BM3DModelOptions();
        bm3DModelOptions.setPosition(position);
        bm3DModelOptions.setModelPath(parentPath);
        bm3DModelOptions.setModelName(modelName);
        
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

        Boolean visible = new TypeConverter<Boolean>().getValue(argument, "visible");
        if (null != visible) {
            bm3DModelOptions.visible(visible);
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

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(bm3DModelOptions);
        if (null == overlay) {
            return false;
        }

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);
        mOverlayMap.put(id, overlay);
        mMapController.mOverlayIdMap.put(id, overlay);
        return true;
    }
}
