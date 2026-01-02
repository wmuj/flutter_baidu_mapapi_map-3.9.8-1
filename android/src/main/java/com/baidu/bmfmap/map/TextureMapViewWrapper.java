package com.baidu.bmfmap.map;

import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BaiduMapOptions;
import com.baidu.mapapi.map.CustomMapStyleCallBack;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapCustomStyleOptions;
import com.baidu.mapapi.map.TextureMapView;

import android.content.Context;
import android.graphics.Point;

public class TextureMapViewWrapper extends FlutterMapViewWrapper {

    private TextureMapView mTextureMapView;

    public TextureMapViewWrapper(Context context, BaiduMapOptions baiduMapOptions) {
        if (baiduMapOptions != null) {
            mTextureMapView = new TextureMapView(context, baiduMapOptions);
        } else {
            mTextureMapView = new TextureMapView((context));
        }
        mViewType = Constants.ViewType.sTextureMapView;
    }


    @Override
    public TextureMapView getTextureMapView() {
        return mTextureMapView;
    }

    @Override
    public BaiduMap getBaiduMap() {
        if (mTextureMapView != null) {
            return mTextureMapView.getMap();
        }
        return null;
    }

    @Override
    public int getWidth() {
        if (mTextureMapView != null) {
            return mTextureMapView.getWidth();
        }
        return 0;
    }

    @Override
    public int getHeight() {
        if (mTextureMapView != null) {
            return mTextureMapView.getHeight();
        }
        return 0;
    }

    @Override
    public void showScaleControl(boolean show) {
        if (mTextureMapView != null) {
            mTextureMapView.showScaleControl(show);
        }
    }

    @Override
    public void setScaleControlPosition(Point position) {
        if (mTextureMapView != null) {
            mTextureMapView.setScaleControlPosition(position);
        }
    }

    @Override
    public Point getScaleControlPosition() {
        // TODO:: native sdk没有该接口, 暂时不实现。
        return null;
    }

    @Override
    public void showZoomControl(Boolean showZoomControl) {
        if (mTextureMapView != null) {
            mTextureMapView.showZoomControls(showZoomControl);
        }
    }

    @Override
    public void setZoomControlsPosition(Point position) {
        if (mTextureMapView != null) {
            mTextureMapView.setZoomControlsPosition(position);
        }
    }

    @Override
    public void setLogoPosition(LogoPosition position) {
        if (mTextureMapView != null) {
            mTextureMapView.setLogoPosition(position);
        }
    }

    @Override
    public LogoPosition getLogoPosition() {
        if (mTextureMapView != null) {
            return mTextureMapView.getLogoPosition();
        }
        return LogoPosition.logoPostionleftBottom;
    }

    @Override
    public void setCustomMapStyleEnable(boolean enable) {
        if (mTextureMapView != null) {
            mTextureMapView.setMapCustomStyleEnable(enable);
        }
    }

    @Override
    public void setCustomMapStylePath(String path) {
        if (mTextureMapView != null) {
            mTextureMapView.setMapCustomStylePath(path);
        }
    }

    @Override
    public void setMapCustomStyle(MapCustomStyleOptions options, CustomMapStyleCallBack callBack) {
        if (mTextureMapView != null) {
            mTextureMapView.setMapCustomStyle(options, callBack);
        }
    }
}