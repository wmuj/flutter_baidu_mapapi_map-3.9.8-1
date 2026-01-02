package com.baidu.bmfmap.map.maphandler;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationData;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class LocationLayerHandler extends BMapHandler {

    public LocationLayerHandler(BMFMapController bmfMapController) {
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
            case Constants.LocationLayerMethodId.sMapShowUserLocationMethod:
                setLocationEnabled(call, result);
                break;

            case Constants.LocationLayerMethodId.sMapUpdateLocationDataMethod:
                setUpdateLocationData(call, result);
                break;

            case Constants.LocationLayerMethodId.sMapUserTrackingModeMethod:
                setLoctype(call, result);

                break;
            case Constants.LocationLayerMethodId.sMapUpdateLocationDisplayParamMethod:
                setCustomLocation(call, result);
                break;
            default:
                break;
        }
    }

    /**
     * 自定义定位图层
     */
    private void setCustomLocation(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("userlocationDisplayParam")) {
            result.success(false);
            return;
        }

        Map<String, Object> locationDisplayParam = (Map<String, Object>) argument.get("userlocationDisplayParam");

        if (null == locationDisplayParam) {
            result.success(false);
            return;
        }

        MyLocationConfiguration.LocationMode  locationMode = MyLocationConfiguration.LocationMode.NORMAL;
        if (locationDisplayParam.containsKey("userTrackingMode")) {
            Integer userTrackingMode = (Integer) locationDisplayParam.get("userTrackingMode");
            if (null != userTrackingMode) {
                switch (userTrackingMode) {
                    case Env.LocationMode.NORMAL:
                    case Env.LocationMode.MODEHEADING:
                        locationMode = MyLocationConfiguration.LocationMode.NORMAL;
                        break;
                    case Env.LocationMode.FOLLOWING:
                        locationMode = MyLocationConfiguration.LocationMode.FOLLOWING;
                        break;
                    case Env.LocationMode.COMPASS:
                        locationMode = MyLocationConfiguration.LocationMode.COMPASS;
                        break;
                    default:
                        break;
                }
            } 
        } 

        boolean isEnableDirection = false;
        if (locationDisplayParam.containsKey("enableDirection")) {
            Boolean enableDirection = (Boolean) locationDisplayParam.get("enableDirection");
            if (null != enableDirection) {
                isEnableDirection = enableDirection;
            }
        }

        BitmapDescriptor bitmap = null;
        if (locationDisplayParam.containsKey("locationViewImage")) {
            String customMarker = (String) locationDisplayParam.get("locationViewImage");
            if (!TextUtils.isEmpty(customMarker)) {
                bitmap = BitmapDescriptorFactory.fromAsset("flutter_assets/" + customMarker);
            }
        }
        int strokeColor = 0x00470000;
        String color = "#";
        if (locationDisplayParam.containsKey("accuracyCircleStrokeColor")) {
            String accuracyCircleStrokeColor = (String) locationDisplayParam.get("accuracyCircleStrokeColor");
            if (!TextUtils.isEmpty(accuracyCircleStrokeColor)) {
                try {
                    strokeColor = Color.parseColor(color.concat(accuracyCircleStrokeColor));
                } catch (IllegalArgumentException e) {
                    e.printStackTrace();
                }
            }
        } 

        int fillColor = 0x00450000;
        if (locationDisplayParam.containsKey("accuracyCircleFillColor")) {
            String accuracyCircleFillColor = (String) locationDisplayParam.get("accuracyCircleFillColor");
            if (!TextUtils.isEmpty(accuracyCircleFillColor)) {
                try {
                     fillColor = Color.parseColor(color.concat(accuracyCircleFillColor));
                } catch (IllegalArgumentException e) {
                    e.printStackTrace();
                }
            }
        }
        mBaiduMap.setMyLocationConfiguration(new MyLocationConfiguration(
                locationMode, isEnableDirection,
                bitmap, fillColor, strokeColor));

        result.success(true);
    }
    
    /**
     * 设置定位模式
     */
    private void setLoctype(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }
        MyLocationConfiguration.LocationMode locationMode = MyLocationConfiguration.LocationMode.NORMAL;
        if (argument.containsKey("userTrackingMode")) {
            Integer userTrackingMode = (Integer) argument.get("userTrackingMode");
            if (null != userTrackingMode) {
                switch (userTrackingMode) {
                    case Env.LocationMode.NORMAL:
                    case Env.LocationMode.MODEHEADING:
                        locationMode = MyLocationConfiguration.LocationMode.NORMAL;
                        break;
                    case Env.LocationMode.FOLLOWING:
                        locationMode = MyLocationConfiguration.LocationMode.FOLLOWING;
                        break;
                    case Env.LocationMode.COMPASS:
                        locationMode = MyLocationConfiguration.LocationMode.COMPASS;
                        break;
                    default:
                        break;
                }
            } 
        } 

        boolean isEnableDirection = false;
        if (argument.containsKey("enableDirection")) {
            Boolean enableDirection = (Boolean) argument.get("enableDirection");
            if (null != enableDirection) {
                isEnableDirection = enableDirection;
            }
        }

        BitmapDescriptor bitmap = null;
        if (argument.containsKey("customMarker")) {
            String customMarker = (String) argument.get("customMarker");
            if (!TextUtils.isEmpty(customMarker)) {
                 bitmap = BitmapDescriptorFactory.fromAsset("flutter_assets/" + customMarker);
            }
        }

        mBaiduMap.setMyLocationConfiguration(new MyLocationConfiguration(locationMode, isEnableDirection, bitmap));
        result.success(true);
    }

    /**
     * 定位数据
     */
    private void setUpdateLocationData(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        MyLocationData.Builder builder = new MyLocationData.Builder();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("userLocation")) {
            result.success(false);
            return;
        }

        Map<String,Object> userLocation = (Map<String, Object>) argument.get("userLocation");
        if (null == userLocation) {
            result.success(false);
            return;
        }
        if (!userLocation.containsKey("location")) {
            result.success(false);
            return;
        }

        Map<String,Object> location = (Map<String, Object>) userLocation.get("location");
        if (null == location) {
            result.success(false);
            return;
        }
        if (!location.containsKey("coordinate")) {
            result.success(false);
            return;
        }
        Map<String,Double>  coordinate = (Map<String, Double>) location.get("coordinate");
        if (null !=  coordinate) {
            if (coordinate.containsKey("latitude") && coordinate.containsKey("longitude")) {
                Double latitude = coordinate.get("latitude");
                Double longitude = coordinate.get("longitude");
                if (null != latitude && null != longitude) {
                    builder.latitude(latitude);
                    builder.longitude(longitude);
                }
            }
        }
        Double course = (Double) location.get("course");
        if (null != course) {
            builder.direction(course.floatValue());
        }

        Double speed = (Double) location.get("speed");
        if (null != speed) {
            builder.speed(speed.floatValue());
        }

        Double accuracy = (Double) location.get("accuracy");
        if (null != accuracy) {
            builder.accuracy(accuracy.floatValue());
        }

        Integer satellitesNum = (Integer) location.get("satellitesNum");
        if (null != satellitesNum) {
            builder.satellitesNum(satellitesNum);
        }

        mBaiduMap.setMyLocationData(builder.build());
        result.success(true);
    }

    /**
     * 开启定位图层
     */
    private void setLocationEnabled(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mBaiduMap) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("show")) {
            result.success(false);
            return;
        }

        Boolean show = (Boolean) argument.get("show");
        if (null == show) {
            result.success(false);
            return;
        }
        mBaiduMap.setMyLocationEnabled(show);
        result.success(true);
    }
}
