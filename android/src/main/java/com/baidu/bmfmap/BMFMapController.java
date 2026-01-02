package com.baidu.bmfmap;

import com.baidu.bmfmap.interfaces.BaiduMapInterface;
import com.baidu.bmfmap.map.FlutterMapViewWrapper;
import com.baidu.bmfmap.map.MapListener;
import com.baidu.bmfmap.map.MapViewWrapper;
import com.baidu.bmfmap.map.TextureMapViewWrapper;
import com.baidu.bmfmap.map.maphandler.BMapHandlerFactory;
import com.baidu.bmfmap.map.overlayhandler.OverlayHandlerFactory;
import com.baidu.bmfmap.utils.BMFFileUtils;
import com.baidu.bmfmap.utils.BMFClusterItemProcessor;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BaiduMapOptions;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapLanguage;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.UiSettings;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import android.content.Context;
import android.graphics.Point;

import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
public class BMFMapController implements MethodChannel.MethodCallHandler, BaiduMapInterface {

    private final MethodChannel mMethodChannel;

    private FlutterMapViewWrapper mMapViewWrapper;

    private BaiduMap mBaiduMap;

    private UiSettings mUiSettings;

    private MapListener mMapListener;

    private Context mContext;

    private BMapHandlerFactory mMapHandlerFactory;

    private OverlayHandlerFactory mOverlayHandlerFactory;

    private BMFFileUtils mFileUtils;

    public final HashMap<String, Overlay> mOverlayIdMap = new HashMap<>();

    private BMFClusterItemProcessor processor;

    public BMFMapController(int id, Context context, BinaryMessenger binaryMessenger,
                            String viewType, BaiduMapOptions options) {
        mContext = context;
        mMapViewWrapper = getFlutterMapViewWrapper(context, viewType, options);

        if (mMapViewWrapper != null) {
            mBaiduMap = mMapViewWrapper.getBaiduMap();
        }

        if (mBaiduMap != null) {
            mUiSettings = mBaiduMap.getUiSettings();
        }

        mMethodChannel = new MethodChannel(binaryMessenger,
                Constants.VIEW_METHOD_CHANNEL_PREFIX + id);

        mMethodChannel.setMethodCallHandler(this);

        mMapListener = new MapListener(mMapViewWrapper, mMethodChannel);
        mMapListener.init();

        mMapHandlerFactory = new BMapHandlerFactory(this);
        mOverlayHandlerFactory = new OverlayHandlerFactory(this);

        mFileUtils = BMFFileUtils.getInstance();
        mFileUtils.setContext(context);

        processor = new BMFClusterItemProcessor();
    }

    public BMFClusterItemProcessor getProcessor() {
        return processor;
    }

    public Context getContext() {
        return mContext;
    }

    public MapListener getMapListener() {
        return mMapListener;
    }

    public void release() {
        mMethodChannel.setMethodCallHandler(null);
        mMapListener.release();
        mMapHandlerFactory.release();
        mOverlayHandlerFactory.release();
        if (mOverlayIdMap != null && mOverlayIdMap.size() > 0) {
            mOverlayIdMap.clear();
        }
        if (processor != null) {
            processor.shutdown();
            processor = null;
        }
    }

    private FlutterMapViewWrapper getFlutterMapViewWrapper(Context context, String viewType,
                                                           BaiduMapOptions options) {
        FlutterMapViewWrapper flutterMapViewWrapper = null;
        if (Constants.ViewType.sMapView.equals(viewType)) {
            flutterMapViewWrapper = new MapViewWrapper(context, options);
        } else if (Constants.ViewType.sTextureMapView.equals(viewType)) {
            flutterMapViewWrapper = new TextureMapViewWrapper(context, options);
        }
        return flutterMapViewWrapper;
    }

    public FlutterMapViewWrapper getFlutterMapViewWrapper() {
        return mMapViewWrapper;
    }

    public BaiduMap getBaiduMap() {
        return mBaiduMap;
    }


    public MethodChannel getMethodChannel() {
        return mMethodChannel;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        if (null == mMapViewWrapper || null == mBaiduMap) {
            return;
        }

        boolean ret = mOverlayHandlerFactory.dispatchMethodHandler(call, result);

        if (!ret) {
            mMapHandlerFactory.dispatchMethodHandler(mContext, call, result);
        }

    }

    @Override
    public void showOperateLayer(Boolean enabled) {
        if (mBaiduMap != null && enabled != null) {
            mBaiduMap.showOperateLayer(enabled);
        }
    }

    @Override
    public void showMapIndoorPoi(Boolean isShow) {
        if (mBaiduMap != null && isShow != null) {
            mBaiduMap.showMapIndoorPoi(isShow);
        }
    }

    @Override
    public void setIndoorEnable(Boolean enabled) {
        if (mBaiduMap != null && enabled != null) {
            mBaiduMap.setIndoorEnable(enabled);
        }
    }

    @Override
    public void setViewPadding(int left, int top, int right, int bottom) {
        if (mBaiduMap != null) {
            mBaiduMap.setViewPadding(left, top, right, bottom);
        }
    }

    @Override
    public void setBaiduHeatMapEnabled(Boolean enabled) {
        if (mBaiduMap != null && enabled != null) {
            mBaiduMap.setBaiduHeatMapEnabled(enabled);
        }
    }

    @Override
    public void setTrafficEnabled(Boolean enabled) {
        if (mBaiduMap != null && enabled != null) {
            mBaiduMap.setTrafficEnabled(enabled);
        }
    }

    @Override
    public void showMapPoi(Boolean isShow) {
        if (mBaiduMap != null && isShow != null) {
            mBaiduMap.showMapPoi(isShow);
        }
    }

    @Override
    public void setBuildingsEnabled(Boolean enabled) {
        if (mBaiduMap != null && enabled != null) {
            mBaiduMap.setBuildingsEnabled(enabled);
        }
    }

    @Override
    public void setMaxAndMinZoomLevel(float max, float min) {
        if (mBaiduMap != null) {
            mBaiduMap.setMaxAndMinZoomLevel(max, min);
        }
    }

    @Override
    public void setMapType(int mapType) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapType(mapType);
        }
    }

    @Override
    public void showScaleControl(Boolean showScaleControl) {
        if (mMapViewWrapper != null && showScaleControl != null) {
            mMapViewWrapper.showScaleControl(showScaleControl);
        }
    }

    @Override
    public void showZoomControl(Boolean showZoomControl) {
        if (null != mMapViewWrapper && null != showZoomControl) {
            mMapViewWrapper.showZoomControl(showZoomControl);
        }
    }

    @Override
    public void setCenter(LatLng latLng) {
        if (mBaiduMap != null && null != latLng) {
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newLatLng(latLng));
        }
    }

    @Override
    public void setZoomLevel(float zoomLevel) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.zoomTo(zoomLevel));
        }
    }

    @Override
    public void setScaleControlPosition(Point scaleControlPosition) {
        if (mMapViewWrapper != null) {
            mMapViewWrapper.setScaleControlPosition(scaleControlPosition);
        }
    }

    @Override
    public void setZoomControlsPosition(Point zoomControlsPosition) {
        if (mMapViewWrapper != null) {
            mMapViewWrapper.setZoomControlsPosition(zoomControlsPosition);
        }
    }

    @Override
    public void setLogoPosition(LogoPosition logoPosition) {
        if (mMapViewWrapper != null) {
            mMapViewWrapper.setLogoPosition(logoPosition);
        }
    }

    @Override
    public void setMapStatusLimits(LatLngBounds latLngBounds) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapStatusLimits(latLngBounds);
        }
    }

    @Override
    public void setVisibleMapBounds(LatLngBounds visibleMapBounds) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapStatus(MapStatusUpdateFactory.newLatLngBounds(visibleMapBounds));
        }
    }

    @Override
    public void setEnlargeCenterWithDoubleClickEnable(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setEnlargeCenterWithDoubleClickEnable(enabled);
        }
    }

    @Override
    public void setAllGesturesEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setAllGesturesEnabled(enabled);
        }
    }

    @Override
    public void setFlingEnable(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setFlingEnable(enabled);
        }
    }

    @Override
    public void setPointGesturesCenter(Point point) {
        if (mUiSettings != null && point != null) {
            mUiSettings.setPointGesturesCenter(point);
        }
    }

    @Override
    public void setLatLngGesturesCenter(LatLng latLng) {
        if (mUiSettings != null && latLng != null) {
            mUiSettings.setLatLngGesturesCenter(latLng);
        }
    }

    @Override
    public void setDoubleClickGesturesCenter(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setDoubleClickGesturesCenter(enabled);
        }
    }

    @Override
    public void setCompassEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setCompassEnabled(enabled);
        }
    }

    @Override
    public void setCompassPotion(Point compassPosition) {
        if (null != mBaiduMap && null != compassPosition) {
            mBaiduMap.setCompassPosition(compassPosition);
        }
    }

    @Override
    public void setRotateGesturesEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setRotateGesturesEnabled(enabled);
        }
    }

    @Override
    public void setScrollGesturesEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setScrollGesturesEnabled(enabled);
        }
    }

    @Override
    public void setOverlookingGesturesEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setOverlookingGesturesEnabled(enabled);
        }
    }

    @Override
    public void setZoomGesturesEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setZoomGesturesEnabled(enabled);
        }
    }

    @Override
    public void setDoubleClickZoomEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setDoubleClickZoomEnabled(enabled);
        }
    }

    @Override
    public void setTwoTouchClickZoomEnabled(Boolean enabled) {
        if (mUiSettings != null && enabled != null) {
            mUiSettings.setTwoTouchClickZoomEnabled(enabled);
        }
    }

    @Override
    public void clearAllOverlay() {
        if (mBaiduMap != null) {
            mBaiduMap.clear();
        }
    }

    @Override
    public void setMapLanguage(Integer language) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapLanguage(MapLanguage.values()[language]);
        }
    }

    @Override
    public void setFontSizeLevel(Integer fontSizeLevel) {
        if (mBaiduMap != null) {
            mBaiduMap.setFontSizeLevel(fontSizeLevel);
        }
    }

    @Override
    public void setMapBackgroundColor(Integer backgroundColor) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapBackgroundColor(backgroundColor);
        }
    }

    @Override
    public void setMapBackgroundImage(BitmapDescriptor imageBitmap) {
        if (mBaiduMap != null) {
            mBaiduMap.setMapBackgroundImage(imageBitmap);
        }
    }

    @Override
    public void setDEMEnable(Boolean enabled) {
        if (mBaiduMap != null) {
            mBaiduMap.setDEMEnable(enabled);
        }
    }
}
