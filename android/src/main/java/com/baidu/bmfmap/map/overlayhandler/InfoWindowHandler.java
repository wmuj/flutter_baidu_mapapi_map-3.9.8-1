package com.baidu.bmfmap.map.overlayhandler;

import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.InfoWindowProtocol;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.InfoWindow;
import com.baidu.mapapi.model.LatLng;

import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class InfoWindowHandler extends OverlayHandler {

    private static final String TAG = "InfoWindowHandler";

    private HashMap<String, InfoWindow> mInfoWindows;
    private HashMap<String, BitmapDescriptor> mBitmapMap = new HashMap<>();

    public InfoWindowHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
        mInfoWindows = new HashMap<>();
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "handlerMethodCallResult enter");
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "mBaidumap is null");
            }
            return;
        }

        String methodId = call.method;

        switch (methodId) {
            case InfoWindowProtocol.sAddInfoWindowMapMethod:
                addInfoWindow(call, result);
                break;
            case InfoWindowProtocol.sAddInfoWindowsMapMethod:
                addInfoWindows(call, result);
                break;
            case InfoWindowProtocol.sRemoveInfoWindowMapMethod:
                removeInfoWindow(call, result);
                break;
            default:
                break;
        }
    }

    /**
     * 添加单个infoWindow
     *
     * @param call
     * @param result
     */
    private void addInfoWindow(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "addInfoWindow enter");
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return;
        }

        addOneInfoWindowImp(argument);
    }

    /**
     * 具体添加一个infowindow
     *
     * @param infoWindowMap
     */
    private void addOneInfoWindowImp(Map<String, Object> infoWindowMap) {

        if (mBaiduMap == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "addOneInfoWindowImp mBaidumap is null");
            }
            return;
        }

        AbstractMap.SimpleEntry<String, InfoWindow> infoWindowEntry =
                mapToInfoWindowEntry(infoWindowMap);

        if (null == infoWindowEntry) {
            return;
        }

        mInfoWindows.put(infoWindowEntry.getKey(), infoWindowEntry.getValue());
        mBaiduMap.showInfoWindow(infoWindowEntry.getValue());
    }

    private AbstractMap.SimpleEntry<String, InfoWindow> mapToInfoWindowEntry(
            Map<String, Object> infoWindowMap) {
        if (null == infoWindowMap) {
            return null;
        }
        if (!infoWindowMap.containsKey("id")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain");
            }
            return null;
        }

        final String id = new TypeConverter<String>().getValue(infoWindowMap, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "TextUtils.isEmpty(id)");
            }
            return null;
        }

        if (mInfoWindows.containsKey(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "infowindow already added");
            }
            return null;
        }

        String image = new TypeConverter<String>().getValue(infoWindowMap, "image");
        if (TextUtils.isEmpty(image)) {
            if (Env.DEBUG) {
                Log.d(TAG, "TextUtils.isEmpty(image)");
            }
            return null;
        }
        Map<String, Object> latLngMap =
                new TypeConverter<Map<String, Object>>().getValue(infoWindowMap, "coordinate");
        LatLng latLng = FlutterDataConveter.mapToLatlng(latLngMap);
        if (null == latLng) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == latLng");
            }
            return null;
        }

        Double yOffSet = new TypeConverter<Double>().getValue(infoWindowMap, "yOffset");
        if (null == yOffSet) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == yOffSet");
            }
            return null;
        }

        Boolean isAddWithBitmapDescriptor =
                new TypeConverter<Boolean>().getValue(infoWindowMap, "isAddWithBitmapDescriptor");
        if (null == isAddWithBitmapDescriptor) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == isAddWithBitmapDescriptor");
            }
            return null;
        }

        BitmapDescriptor bitmap = BitmapDescriptorFactory.fromAsset("flutter_assets/" + image);
        if (null == bitmap) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == bitmap");
            }
            return null;
        }

        mBitmapMap.put(id, bitmap);

        InfoWindow infoWindow = new InfoWindow(bitmap, latLng, yOffSet.intValue(),
                new InfoWindow.OnInfoWindowClickListener() {

                    @Override
                    public void onInfoWindowClick() {
                        if (null == mMapController || null == mMapController.getMethodChannel()) {
                            return;
                        }
                        Map<String, Object> infoWindowMap = new HashMap<>();

                        infoWindowMap.put("id", id);

                        mMapController.getMethodChannel()
                                .invokeMethod(InfoWindowProtocol.sMapDidClickedInfoWindowMethod,
                                        infoWindowMap);
                    }
                });

        return new AbstractMap.SimpleEntry<String, InfoWindow>(id, infoWindow);
    }

    /**
     * 批量添加infowindow
     *
     * @param call
     * @param result
     */
    private void addInfoWindows(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "addInfoWindows enter");
        }
        List<Object> arguments = (List<Object>) call.arguments;
        if (null == arguments) {
            if (Env.DEBUG) {
                Log.d(TAG, "arguments is null");
            }
            return;
        }

        if (mBaiduMap == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "addInfoWindows mBaidumap is null");
            }
            return;
        }

        List<InfoWindow> infoWindowList = new ArrayList<>();
        Iterator itr = arguments.iterator();
        while (itr.hasNext()) {
            Map<String, Object> infoWindowMap = (Map<String, Object>) itr.next();
            if (null == infoWindowMap) {
                continue;
            }

            AbstractMap.SimpleEntry<String, InfoWindow> infoWindowEntry =
                    mapToInfoWindowEntry(infoWindowMap);
            if (null == infoWindowEntry) {
                continue;
            }

            infoWindowList.add(infoWindowEntry.getValue());
            mInfoWindows.put(infoWindowEntry.getKey(), infoWindowEntry.getValue());
        }

        if (infoWindowList.size() > 0) {
            mBaiduMap.showInfoWindows(infoWindowList);
        }
    }

    private void removeInfoWindow(MethodCall call, MethodChannel.Result result) {

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "addInfoWindows mBaidumap is null");
            }
            return;
        }

        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            if (Env.DEBUG) {
                Log.d(TAG, "TextUtils.isEmpty(id)");
            }
            return;
        }

        InfoWindow infoWindow = mInfoWindows.get(id);
        if (null == infoWindow) {
            if (Env.DEBUG) {
                Log.d(TAG, "null == infoWindow");
            }
            return;
        }

        if (Env.DEBUG) {
            Log.d(TAG, "removeInfoWindow success");
        }
        baiduMap.hideInfoWindow(infoWindow);

        mInfoWindows.remove(id);

        BitmapDescriptor bitmapDescriptor = mBitmapMap.get(id);
        if (null != bitmapDescriptor) {
            bitmapDescriptor.recycle();
        }
    }

    @Override
    public void clean() {
        Iterator iterator = mBitmapMap.values().iterator();
        BitmapDescriptor bitmapDescriptor;
        while (iterator.hasNext()) {
            bitmapDescriptor = (BitmapDescriptor) iterator.next();
            if (null != bitmapDescriptor) {
                bitmapDescriptor.recycle();
            }
        }

        if (null != mInfoWindows) {
            mInfoWindows.clear();
        }
    }
}
