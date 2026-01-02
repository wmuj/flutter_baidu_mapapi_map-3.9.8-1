package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.GroundOverlay;
import com.baidu.mapapi.map.GroundOverlayOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class GroundHandler extends OverlayHandler {

    private static final String TAG = "GroundHandler";

    private HashMap<String, BitmapDescriptor> mBitmapMap = new HashMap<>();

    private final HashMap<String, BitmapDescriptor> mMarkerBitmapMap = new HashMap<>();

    public GroundHandler(BMFMapController bmfMapController) {
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
            case Constants.MethodProtocol.GroundProtocol.sMapAddGroundMethod:
                ret = addGround(argument);
                break;
            case Constants.MethodProtocol.GroundProtocol.sMapUpdateGroundMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addGround(Map<String, Object> argument) {
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

        GroundOverlayOptions groundOverlayOptions = new GroundOverlayOptions();

        String image = new TypeConverter<String>().getValue(argument, "image");
        if (!TextUtils.isEmpty(image)) {
            BitmapDescriptor bitmap = BitmapDescriptorFactory.fromAsset("flutter_assets/" + image);
            if (null != bitmap) {
                if (Env.DEBUG) {
                    Log.d(TAG, "image");

                }
                groundOverlayOptions.image(bitmap);
                mBitmapMap.put(id, bitmap);
            }

        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        setGroundOptions(id, argument, groundOverlayOptions);

        final Overlay overlay = mBaiduMap.addOverlay(groundOverlayOptions);
        if (null != overlay) {
            Bundle bundle = new Bundle();
            bundle.putString("id", id);
            bundle.putString("image", image);
            if (customMap != null && customMap.size() > 0) {
                bundle.putSerializable("customMap", customMap);
            }
            overlay.setExtraInfo(bundle);

            mOverlayMap.put(id, overlay);
            mMapController.mOverlayIdMap.put(id, overlay);
            return false;
        }

        return true;
    }

    /**
     *
     */
    private void setGroundOptions(String id, Map<String, Object> groundOptionsMap,
                                  GroundOverlayOptions groundOverlayOptions) {
        if (null == groundOptionsMap) {
            return;
        }

        Double anchorX = new TypeConverter<Double>().getValue(groundOptionsMap, "anchorX");
        Double anchorY = new TypeConverter<Double>().getValue(groundOptionsMap, "anchorY");
        if (null != anchorX && null != anchorY) {
            groundOverlayOptions.anchor(anchorX.floatValue(), anchorY.floatValue());
        }

        Map<String, Object> centerMap =
                new TypeConverter<Map<String, Object>>().getValue(groundOptionsMap, "position");
        if (null != centerMap) {
            LatLng center = FlutterDataConveter.mapToLatlng(centerMap);
            if (null != center) {
                if (Env.DEBUG) {
                    Log.d(TAG, "position");

                }
                groundOverlayOptions.position(center);
            }
        }

        Double width = new TypeConverter<Double>().getValue(groundOptionsMap, "width");
        Double height = new TypeConverter<Double>().getValue(groundOptionsMap, "height");
        if (null != width && null != height) {
            groundOverlayOptions.dimensions(width.intValue(), height.intValue());
        }

        Map<String, Object> boundsMap =
                new TypeConverter<Map<String, Object>>().getValue(groundOptionsMap, "bounds");
        LatLngBounds latLngBounds = FlutterDataConveter.mapToLatlngBounds(boundsMap);
        if (null != latLngBounds) {
            if (Env.DEBUG) {
                Log.d(TAG, "bounds");

            }
            groundOverlayOptions.positionFromBounds(latLngBounds);
        }

        Double transparency =
                new TypeConverter<Double>().getValue(groundOptionsMap, "transparency");
        if (null != transparency) {
            groundOverlayOptions.transparency(transparency.floatValue());
        }

        Integer zIndex = new TypeConverter<Integer>().getValue(groundOptionsMap, "zIndex");
        if (null != zIndex) {
            groundOverlayOptions.zIndex(zIndex);
        }

        Boolean visible = new TypeConverter<Boolean>().getValue(groundOptionsMap, "visible");
        if (null != visible) {
            groundOverlayOptions.visible(visible);
        }

        Boolean clickable = new TypeConverter<Boolean>().getValue(groundOptionsMap, "clickable");
        if (null != clickable) {
            groundOverlayOptions.setClickable(clickable);
        }
    }

    @Override
    public void clean() {
        super.clean();
        Iterator iterator = mBitmapMap.values().iterator();
        BitmapDescriptor bitmapDescriptor;
        while (iterator.hasNext()) {
            bitmapDescriptor = (BitmapDescriptor) iterator.next();
            if (null != bitmapDescriptor) {
                bitmapDescriptor.recycle();
            }
        }

        mBitmapMap.clear();
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

        GroundOverlay ground = (GroundOverlay) mOverlayMap.get(id);
        if (null == ground) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        boolean ret = false;
        switch (member) {
            case "position":
                Map<String, Object> positionMap = (Map<String, Object>) argument.get("value");
                LatLng positon = FlutterDataConveter.mapToLatlng(positionMap);
                if (null == positon) {
                    break;
                }

                ground.setPosition(positon);
                break;
            case "anchorX":
                Double anchorX = (Double) argument.get("anchorX");
                if (null == anchorX) {
                    break;
                }

                ground.setAnchor(anchorX.floatValue(), ground.getAnchorY());
                ret = true;
                break;
            case "anchorY":
                Double anchorY = (Double) argument.get("anchorY");
                if (null == anchorY) {
                    break;
                }

                ground.setAnchor(ground.getAnchorX(), anchorY.floatValue());
                ret = true;
                break;
            case "dimensions":
                Double width = (Double) argument.get("width");
                Double height = (Double) argument.get("height");

                if (null == width || null == height) {
                    break;
                }

                ground.setDimensions(width.intValue(), height.intValue());
                ret = true;
                break;
            case "bounds":
                Map<String, Object> latLngMap = (Map<String, Object>) argument.get("value");
                LatLngBounds latLngBounds = FlutterDataConveter.mapToLatlngBounds(latLngMap);
                if (null == latLngBounds) {
                    break;
                }

                ground.setPositionFromBounds(latLngBounds);
                ret = true;
                break;
            case "image":
                String image = (String) argument.get("value");
                if (TextUtils.isEmpty(image)) {
                    break;
                }

                BitmapDescriptor bitmapDescriptor = mMarkerBitmapMap.get(id);

                if (null != bitmapDescriptor) {
                    bitmapDescriptor.recycle();
                    mMarkerBitmapMap.remove(id);
                }

                bitmapDescriptor = BitmapDescriptorFactory.fromAsset("flutter_assets/" + image);

                if (null != bitmapDescriptor) {
                    ground.setImage(bitmapDescriptor);
                    mMarkerBitmapMap.put(id, bitmapDescriptor);
                    ret = true;
                }

                break;
            case "transparency":
                Double rotate = (Double) argument.get("value");
                if (null == rotate) {
                    break;
                }

                ground.setTransparency(rotate.floatValue());
                ret = true;
                break;
            case "clickable":
                Boolean clickable = (Boolean) argument.get("value");
                if (null == clickable) {
                    break;
                }

                ground.setClickable(clickable);
                ret = true;
                break;
            default:
                break;
        }

        return ret;
    }

    public void clean(String id) {
        super.clean(id);
        if (TextUtils.isEmpty(id)) {
            return;
        }

        BitmapDescriptor bitmapDescriptor = mBitmapMap.get(id);
        if (null != bitmapDescriptor) {
            bitmapDescriptor.recycle();
        }

        mBitmapMap.remove(id);
    }
}