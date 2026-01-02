package com.baidu.bmfmap.map;

import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BaiduMapOptions;
import com.baidu.mapapi.map.CustomMapStyleCallBack;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapCustomStyleOptions;
import com.baidu.mapapi.map.MapView;

import android.content.Context;
import android.graphics.Point;

public class MapViewWrapper extends FlutterMapViewWrapper {
    FlutterMapView mFlutterMapView;

    private MapView mMapView;

    public MapViewWrapper(Context context, BaiduMapOptions baiduMapOptions) {
        if (baiduMapOptions != null) {
            mMapView = new MapView(context, baiduMapOptions);
        } else {
            mMapView = new MapView(context);
        }
        mViewType = Constants.ViewType.sMapView;
    }

    @Override
    public MapView getMapView() {
        return mMapView;
    }

    @Override
    public BaiduMap getBaiduMap() {
        if (mMapView != null) {
            return mMapView.getMap();
        }
        return null;
    }

    public FlutterMapView getFlutterMapView() {
        return mFlutterMapView;
    }

    @Override
    public int getWidth() {
        if (mMapView != null) {
            return mMapView.getWidth();
        }
        return 0;
    }

    @Override
    public int getHeight() {
        if (mMapView != null) {
            return mMapView.getHeight();
        }
        return 0;
    }

    @Override
    public void showScaleControl(boolean show) {
        if (mMapView != null) {
            mMapView.showScaleControl(show);
        }
    }

    @Override
    public void setScaleControlPosition(Point position) {
        if (mMapView != null) {
            mMapView.setScaleControlPosition(position);
        }
    }

    @Override
    public Point getScaleControlPosition() {
        if (mMapView != null) {
            return mMapView.getScaleControlPosition();
        }
        return null;
    }

    @Override
    public void showZoomControl(Boolean showZoomControl) {
        if (mMapView != null) {
            mMapView.showZoomControls(showZoomControl);
        }
    }

    @Override
    public void setZoomControlsPosition(Point position) {
        if (mMapView != null) {
            mMapView.setZoomControlsPosition(position);
        }
    }

    @Override
    public void setLogoPosition(LogoPosition position) {
        if (mMapView != null) {
            mMapView.setLogoPosition(position);
        }
    }

    @Override
    public LogoPosition getLogoPosition() {
        if (mMapView != null) {
            return mMapView.getLogoPosition();
        }
        return LogoPosition.logoPostionleftBottom;
    }

    @Override
    public void setCustomMapStyleEnable(boolean enable) {
        if (mMapView != null) {
            mMapView.setMapCustomStyleEnable(enable);
        }
    }

    @Override
    public void setCustomMapStylePath(String path) {
        if (mMapView != null) {
            mMapView.setMapCustomStylePath(path);
        }
    }

    @Override
    public void setMapCustomStyle(MapCustomStyleOptions options, CustomMapStyleCallBack callBack) {
        if (mMapView != null) {
            mMapView.setMapCustomStyle(options, callBack);
        }
    }
}