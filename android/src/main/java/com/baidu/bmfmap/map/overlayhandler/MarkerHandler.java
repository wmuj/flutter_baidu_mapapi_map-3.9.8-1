package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.TitleOptions;
import com.baidu.mapapi.model.LatLng;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MarkerHandler extends OverlayHandler {

    private static final String TAG = "MarkerHandler";

    private final HashMap<String, Overlay> mMarkerMap = new HashMap<>();
    private final HashMap<String, BitmapDescriptor> mMarkerBitmapMap = new HashMap<>();

    public MarkerHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
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

        boolean ret = false;
        switch (methodId) {
            case Constants.MethodProtocol.MarkerProtocol.sMapAddMarkerMethod:
                ret = addMarker(call);
                break;
            case Constants.MethodProtocol.MarkerProtocol.sMapAddMarkersMethod:
                ret = addMarkers(call);
                break;
            case Constants.MethodProtocol.MarkerProtocol.sMapRemoveMarkerMethod:
                ret = removeMarker(call);
                break;
            case Constants.MethodProtocol.MarkerProtocol.sMapRemoveMarkersMethod:
                ret = removeMarkers(call);
                break;
            case Constants.MethodProtocol.MarkerProtocol.sMapCleanAllMarkersMethod:
                ret = cleanAllMarker(call);
                break;
            case Constants.MethodProtocol.MarkerProtocol.sMapUpdateMarkerMemberMethod:
                ret = updateMarkerMember(call, result);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    @Override
    public void clean() {
        if (mMarkerMap != null && mMarkerMap.size() > 0) {
            Iterator overlayIterator = mMarkerMap.values().iterator();
            Overlay overlay;
            while (overlayIterator.hasNext()) {
                overlay = (Overlay) overlayIterator.next();
                if (null != overlay) {
                    overlay.remove();
                }
            }
            mMarkerMap.clear();
        }

        if (mMarkerBitmapMap != null && mMarkerBitmapMap.size() > 0) {
            Iterator bitmapDescriptorIterator = mMarkerBitmapMap.values().iterator();
            BitmapDescriptor bitmapDescriptor;
            while (bitmapDescriptorIterator.hasNext()) {
                bitmapDescriptor = (BitmapDescriptor) bitmapDescriptorIterator.next();
                if (null != bitmapDescriptor) {
                    bitmapDescriptor.recycle();
                }
            }
            mMarkerBitmapMap.clear();
        }
    }

    private boolean addMarker(MethodCall call) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        return addMarkerImp(argument);
    }

    private boolean addMarkerImp(Map<String, Object> argument) {
        if (Env.DEBUG) {
            Log.d(TAG, "addMarkerImp enter");
        }
        if (null == argument) {
            return false;
        }

        if (mMapController == null) {
            return false;
        }

        if (mBaiduMap == null) {
            if (Env.DEBUG) {
                Log.d(TAG, "addOneInfoWindowImp mBaidumap is null");
            }
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("position")) {
            return false;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mMarkerMap.containsKey(id)) {
            return false;
        }

        MarkerOptions markerOptions = new MarkerOptions();

        setScreenLockPoint(argument, markerOptions);

        String icon = null;
        byte[] iconData = null;

        if (argument.containsKey("icon")) {
            icon = (String) argument.get("icon");
        }

        if (argument.containsKey("iconData")) {
            iconData = (byte[]) argument.get("iconData");
        }

        if (TextUtils.isEmpty(icon) && (iconData == null || iconData.length <= 0)) {
            return false;
        }

        if (!setMarkerOptions(argument, markerOptions, id, icon, iconData)) {
            return false;
        }

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        Overlay overlay = mBaiduMap.addOverlay(markerOptions);

        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        if (!TextUtils.isEmpty(icon)) {
            bundle.putString("icon", icon);
        }
        if ((iconData != null && iconData.length > 0)) {
            bundle.putByteArray("iconData", iconData);
        }
        if (customMap != null && customMap.size() > 0) {
            bundle.putSerializable("customMap", customMap);
        }
        overlay.setExtraInfo(bundle);

        mMarkerMap.put(id, overlay);

        return true;
    }

    private boolean setScreenLockPoint(Map<String, Object> argumentMap,
                                       MarkerOptions markerOptions) {
        if (null == argumentMap || null == markerOptions) {
            return false;
        }

        Boolean isLockedToScreen =
                new TypeConverter<Boolean>().getValue(argumentMap, "isLockedToScreen");
        if (null == isLockedToScreen || false == isLockedToScreen) {
            return false;
        }

        Map<String, Object> screenPointToLockMap =
                new TypeConverter<Map<String, Object>>().getValue(argumentMap, "screenPointToLock");
        if (null == screenPointToLockMap
                || !screenPointToLockMap.containsKey("x")
                || !screenPointToLockMap.containsKey("y")) {
            return false;
        }

        Double x = new TypeConverter<Double>().getValue(screenPointToLockMap, "x");
        Double y = new TypeConverter<Double>().getValue(screenPointToLockMap, "y");
        if (null == x || null == y) {
            return false;
        }

        Point point = new Point(x.intValue(), y.intValue());

        markerOptions.fixedScreenPosition(point);
        return true;
    }

    /**
     * 解析并设置markertions里的信息
     *
     * @return
     */
    private boolean setMarkerOptions(Map<String, Object> markerOptionsMap,
                                     MarkerOptions markerOptions, String id, String icon, byte[] iconData) {

        Map<String, Object> latlngMap = (Map<String, Object>) markerOptionsMap.get("position");

        LatLng latLng = FlutterDataConveter.mapToLatlng(latlngMap);
        if (null == latLng) {
            if (Env.DEBUG) {
                Log.d(TAG, "latLng is null");
            }
            return false;
        }
        markerOptions.position(latLng);

        BitmapDescriptor bitmapDescriptor = null;
        if (!TextUtils.isEmpty(icon)) {
            bitmapDescriptor =
                    BitmapDescriptorFactory.fromAsset("flutter_assets/" + icon);
        } else {
            if (null == iconData || iconData.length <= 0) {
                return false;
            }
            Bitmap bitmap = BitmapFactory.decodeByteArray(iconData, 0, iconData.length);
            if (bitmap == null) {
                return false;
            }

            bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(bitmap);
        }

        if (null == bitmapDescriptor) {
            return false;
        }

        markerOptions.icon(bitmapDescriptor);
        mMarkerBitmapMap.put(id, bitmapDescriptor);

        //centerOffset
        Map<String, Object> centerOffset =
                new TypeConverter<Map<String, Object>>().getValue(markerOptionsMap, "centerOffset");
        if (null != centerOffset) {
            Double y = new TypeConverter<Double>().getValue(centerOffset, "y");
            if (null != y) {
                markerOptions.yOffset(y.intValue());
            }
        }

        Boolean enable = new TypeConverter<Boolean>().getValue(markerOptionsMap, "enabled");
        if (markerOptionsMap.containsKey("enabled")) {
            if (Env.DEBUG) {
                Log.d(TAG, "enbale" + enable);
            }
            markerOptions.clickable(enable);
        }

        Double anchorX = new TypeConverter<Double>().getValue(markerOptionsMap, "anchorX");
        Double anchorY = new TypeConverter<Double>().getValue(markerOptionsMap, "anchorY");
        if (null != anchorX && null != anchorY) {
            markerOptions.anchor(anchorX.floatValue(), anchorY.floatValue());
        }

        Boolean draggable = new TypeConverter<Boolean>().getValue(markerOptionsMap, "draggable");
        if (null != draggable) {
            markerOptions.draggable(draggable);
        }

        Integer zIndex = new TypeConverter<Integer>().getValue(markerOptionsMap, "zIndex");
        if (null != zIndex) {
            markerOptions.zIndex(zIndex);
        }

        Boolean visible = new TypeConverter<Boolean>().getValue(markerOptionsMap, "visible");
        if (null != visible) {
            markerOptions.visible(visible);
        }

        Double scaleX = new TypeConverter<Double>().getValue(markerOptionsMap, "scaleX");
        if (null != scaleX) {
            markerOptions.scaleX(scaleX.floatValue());
        }

        Double scaleY = new TypeConverter<Double>().getValue(markerOptionsMap, "scaleY");
        if (null != scaleY) {
            markerOptions.scaleY(scaleY.floatValue());
        }

        Double alpha = new TypeConverter<Double>().getValue(markerOptionsMap, "alpha");
        if (null != alpha) {
            markerOptions.alpha(alpha.floatValue());
        }

        Boolean isPerspective =
                new TypeConverter<Boolean>().getValue(markerOptionsMap, "isPerspective");
        if (null != isPerspective) {
            markerOptions.perspective(isPerspective);
        }

        Boolean isOpenCollisionDetection =
                new TypeConverter<Boolean>().getValue(markerOptionsMap, "isOpenCollisionDetection");
        if (null != isOpenCollisionDetection) {
            markerOptions.isJoinCollision(isOpenCollisionDetection);
        }

        Boolean isForceDisplay =
                new TypeConverter<Boolean>().getValue(markerOptionsMap, "isForceDisplay");
        if (null != isForceDisplay) {
            markerOptions.isForceDisPlay(isForceDisplay);
        }

        Integer collisionDetectionPriority =
                new TypeConverter<Integer>().getValue(markerOptionsMap, "collisionDetectionPriority");
        if (null != collisionDetectionPriority) {
            markerOptions.priority(collisionDetectionPriority);
        }

        // 开启poi碰撞检测
        Boolean isOpenCollisionDetectionWithMapPOI =
                new TypeConverter<Boolean>().getValue(markerOptionsMap, "isOpenCollisionDetectionWithMapPOI");
        if (null != isOpenCollisionDetectionWithMapPOI) {
            markerOptions.poiCollided(isOpenCollisionDetectionWithMapPOI);
        }

        // 设置marker的title since 3.5.0
        Map<String, Object> titleOptionsMap =
                new TypeConverter<Map<String, Object>>().getValue(markerOptionsMap, "titleOptions");
        if (null != titleOptionsMap) {
            TitleOptions titleOptions = new TitleOptions();

            String bgColorStr = (String) titleOptionsMap.get("bgColor");
            if (!TextUtils.isEmpty(bgColorStr)) {
                Integer bgColor = FlutterDataConveter.getColor(bgColorStr);
                if (null != bgColor) {
                    titleOptions.titleBgColor(bgColor);
                }
            }

            String fontColorStr = (String) titleOptionsMap.get("fontColor");
            if (!TextUtils.isEmpty(fontColorStr)) {
                Integer fontColor = FlutterDataConveter.getColor(fontColorStr);
                if (null != fontColor) {
                    titleOptions.titleFontColor(fontColor);
                }
            }

            Integer fontSize = (Integer) titleOptionsMap.get("fontSize");
            if (null != fontSize) {
                titleOptions.titleFontSize(fontSize);
            }

            String text = (String) titleOptionsMap.get("text");
            if (!TextUtils.isEmpty(text)) {
                titleOptions.text(text);
            }

            Integer titleYOffset = (Integer) titleOptionsMap.get("titleYOffset");
            Integer titleXOffset = (Integer) titleOptionsMap.get("titleXOffset");
            if (null != titleYOffset && null != titleXOffset) {
                titleOptions.titleOffset(titleXOffset, titleYOffset);
            }

            Double titleRotate = (Double) titleOptionsMap.get("titleRotate");
            if (null != titleRotate) {
                titleOptions.titleRotate(titleRotate.floatValue());
            }

            Double titleAnchorX = (Double) titleOptionsMap.get("titleAnchorX");
            Double titleAnchorY = (Double) titleOptionsMap.get("titleAnchorY");
            if (null != titleAnchorX && null != titleAnchorY) {
                titleOptions.titleAnchor(titleAnchorX.floatValue(), titleAnchorY.floatValue());
            }

            markerOptions.titleOptions(titleOptions);
        }

        // 设置Marker的旋转角度
        Double rotate = new TypeConverter<Double>().getValue(markerOptionsMap, "rotation");
        if (null != rotate) {
            markerOptions.rotate(rotate.floatValue());
        }
        return true;
    }

    private boolean addMarkers(MethodCall call) {

        if (Env.DEBUG) {
            Log.d(TAG, "addMarkers enter");
        }
        if (null == call) {
            return false;
        }

        List<Object> arguments = call.arguments();
        if (null == arguments) {
            return false;
        }

        Iterator itr = arguments.iterator();
        while (itr.hasNext()) {
            Map<String, Object> argument = (Map<String, Object>) itr.next();
            addMarkerImp(argument);

        }
        return true;
    }

    private boolean removeMarker(MethodCall call) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        removeMarkerImp(argument);
        return true;
    }

    private boolean removeMarkerImp(Map<String, Object> argument) {
        if (mMarkerMap == null) {
            return false;
        }
        String id = new TypeConverter<String>().getValue(argument, "id");
        Overlay overlay = mMarkerMap.get(id);
        BitmapDescriptor bitmapDescriptor = mMarkerBitmapMap.get(id);

        boolean ret = true;
        if (null != overlay) {
            overlay.remove();
            mMarkerMap.remove(id);
        } else {
            ret = false;
        }

        if (null != bitmapDescriptor) {
            bitmapDescriptor.recycle();
            mMarkerBitmapMap.remove(id);
        } else {
            ret = false;
        }

        return ret;
    }

    private boolean removeMarkers(MethodCall call) {
        List<Object> markersList = call.arguments();
        if (null == markersList) {
            return false;
        }

        Iterator itr = markersList.iterator();
        while (itr.hasNext()) {
            Map<String, Object> marker = (Map<String, Object>) itr.next();
            if (null != marker) {
                removeMarkerImp(marker);
            }

        }

        return true;
    }

    private boolean cleanAllMarker(MethodCall call) {
        clean();
        return true;
    }

    /**
     * 更新marker属性
     *
     * @param call
     * @param result
     * @return
     */
    private boolean updateMarkerMember(MethodCall call, MethodChannel.Result result) {
        if (mMarkerMap == null) {
            return false;
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            return false;
        }

        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (!mMarkerBitmapMap.containsKey(id)) {
            return false;
        }

        Marker marker = (Marker) mMarkerMap.get(id);
        if (null == marker) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        Object value = argument.get("value");
        if (null == value) {
            return false;
        }

        boolean ret = false;
        switch (member) {
            case "title":
                String title = (String) value;
                if (!TextUtils.isEmpty(title)) {
                    marker.setTitle(title);
                    ret = true;
                }
                break;
            case "position":
                Map<String, Object> position = (Map<String, Object>) value;
                LatLng latLng = FlutterDataConveter.mapToLatlng(position);
                if (null != latLng) {
                    marker.setPosition(latLng);
                    ret = true;
                }
                break;
            case "isLockedToScreen":
                Boolean isLockedToScreen = (Boolean) value;
                if (null != isLockedToScreen && isLockedToScreen) {

                    Map<String, Object> pointMap =
                            new TypeConverter<Map<String, Object>>().getValue(argument,
                                    "screenPointToLock");

                    if (pointMap != null && pointMap.size() > 0) {
                        Point point = FlutterDataConveter.mapToPoint(pointMap);
                        if (null != point) {
                            marker.setFixedScreenPosition(point);
                            ret = true;
                        }
                    }
                }

                break;
            case "icon":
                String icon = (String) value;
                if (!TextUtils.isEmpty(icon)) {
                    BitmapDescriptor bitmapDescriptor1 = mMarkerBitmapMap.get(id);

                    if (null != bitmapDescriptor1) {
                        bitmapDescriptor1.recycle();
                        mMarkerBitmapMap.remove(id);
                    }

                    bitmapDescriptor1 = BitmapDescriptorFactory.fromAsset("flutter_assets/" + icon);

                    if (null != bitmapDescriptor1) {
                        marker.setIcon(bitmapDescriptor1);
                        mMarkerBitmapMap.put(id, bitmapDescriptor1);
                        ret = true;
                    }
                }
                break;
            case "iconData":
                byte[] iconData = (byte[]) value;
                if (iconData != null && iconData.length > 0) {
                    Bitmap bitmap = BitmapFactory.decodeByteArray(iconData, 0, iconData.length);
                    if (bitmap != null) {
                        BitmapDescriptor bitmapDescriptor2 = mMarkerBitmapMap.get(id);

                        if (null != bitmapDescriptor2) {
                            bitmapDescriptor2.recycle();
                            mMarkerBitmapMap.remove(id);
                        }

                        bitmapDescriptor2 = BitmapDescriptorFactory.fromBitmap(bitmap);

                        if (null != bitmapDescriptor2) {
                            marker.setIcon(bitmapDescriptor2);
                            mMarkerBitmapMap.put(id, bitmapDescriptor2);
                            ret = true;
                        }
                    }
                }
                break;
            case "centerOffset":
                Map<String, Object> centerOffset = (Map<String, Object>) value;
                if (null != centerOffset) {
                    Double y = new TypeConverter<Double>().getValue(centerOffset, "y");
                    if (null != y) {
                        marker.setYOffset(y.intValue());
                        ret = true;
                    }
                }
                break;
            case "enabled":
                Boolean enabled = (Boolean) value;
                if (null != enabled) {
                    marker.setClickable(enabled);
                    ret = true;
                }
                break;
            case "draggable":
                Boolean draggable = (Boolean) value;
                if (null != draggable) {
                    marker.setDraggable(draggable);
                    ret = true;
                }
                break;
            case "visible":
                Boolean visible = (Boolean) value;
                if (null != visible) {
                    marker.setVisible(visible);
                    ret = true;
                }
                break;
            case "zIndex":
                Integer zIndex = (Integer) value;
                if (null != zIndex) {
                    marker.setZIndex(zIndex);
                    ret = true;
                }
                break;
            case "scaleX":
                Double scaleX = (Double) value;
                if (null != scaleX) {
                    marker.setScaleX(scaleX.floatValue());
                    ret = true;
                }
                break;
            case "scaleY":
                Double scaleY = (Double) value;
                if (null != scaleY) {
                    marker.setScaleY(scaleY.floatValue());
                    ret = true;
                }
                break;
            case "alpha":
                Double alpha = (Double) value;
                if (null != alpha) {
                    marker.setAlpha(alpha.floatValue());
                    ret = true;
                }
                break;
            case "isPerspective":
                Boolean isPerspective = (Boolean) value;
                if (null != isPerspective) {
                    marker.setPerspective(isPerspective);
                    ret = true;
                }
                break;
            case "anchor":
                Double anchorX = (Double) value;
                Double anchorY = (Double) argument.get("value1");
                if (null != anchorX && null != anchorY) {
                    marker.setAnchor(anchorX.floatValue(), anchorY.floatValue());
                    ret = true;
                }
                break;
            case "rotation":
                Double rotate = (Double) value;
                if (null != rotate) {
                    marker.setRotate(rotate.floatValue());
                }
                break;
            default:
                break;
        }

        return ret;
    }
}
