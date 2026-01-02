package com.baidu.bmfmap.map.maphandler;

import android.content.Context;
import android.text.TextUtils;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.ParticleEffectType;
import com.baidu.mapapi.map.ParticleOptions;
import com.baidu.mapapi.model.LatLng;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ParticleMapHandler extends BMapHandler {

    private static final String TAG = "HeapMapHandler";

    public ParticleMapHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCallResult(Context context, MethodCall call, MethodChannel.Result result) {

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
            case Constants.MethodProtocol.ParticleMethodId.SHOW_MAP_PARTICLE_METHOD:
                showMapParticle(call, result);
                break;
            case Constants.MethodProtocol.ParticleMethodId.CLOSE_MAP_PARTICLE_METHOD:
                closeMapParticle(call, result);
                break;
            case Constants.MethodProtocol.ParticleMethodId.CUSTOM_MAP_PARTICLE_METHOD:
                customMapParticle(call, result);
                break;
        }
    }

    private void customMapParticle( MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("effect") ||
                !argument.containsKey("location") || !argument.containsKey("images")) {
            result.success(false);
            return;
        }

        Integer effect = (Integer) argument.get("effect");
        if (null == effect) {
            result.success(false);
            return;
        }

        Object latLngObj = argument.get("location");

        if (null == latLngObj) {
            result.success(false);
            return;
        }

        LatLng location = FlutterDataConveter.toLatLng(latLngObj);

        if (null == location) {
            result.success(false);
            return;
        }

        List<String> images = (List<String>) argument.get("images");
        if (null == images || images.size() < 1) {
            result.success(false);
            return;
        }

        List<BitmapDescriptor> particleImages = FlutterDataConveter.getIcons(images);
        if (null == particleImages || particleImages.size() < 1) {
            result.success(false);
            return;
        }

        ParticleOptions particleOptions = new ParticleOptions();
        particleOptions.setParticlePos(location);
        particleOptions.setParticleImgs(particleImages);

        mBaiduMap.customParticleEffectByType(match(effect), particleOptions);

        result.success(true);
    }

    private void closeMapParticle(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("effect")) {
            result.success(false);
            return;
        }

        Integer effect = (Integer) argument.get("effect");
        if (null == effect) {
            result.success(false);
            return;
        }

        mBaiduMap.closeParticleEffectByType(match(effect));
        result.success(true);
    }

    private void showMapParticle(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("effect")) {
            result.success(false);
            return;
        }

        Integer effect = (Integer) argument.get("effect");
        if (null == effect) {
            result.success(false);
            return;
        }

        mBaiduMap.showParticleEffectByType(match(effect));
        result.success(true);
    }

    private ParticleEffectType match(int key) {

        ParticleEffectType result = null;

        for (ParticleEffectType s : ParticleEffectType.values()) {
            if (s.getType() == key) {
                result = s;
                break;
            }
        }

        return result;
    }
}
