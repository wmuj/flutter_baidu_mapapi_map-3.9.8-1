package com.baidu.bmfmap.interfaces;

import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;

import android.graphics.Point;

/**
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
public interface BaiduMapInterface {

    void showOperateLayer(Boolean enabled);

    void showMapIndoorPoi(Boolean isShow);

    void setIndoorEnable(Boolean enabled);

    void setViewPadding(int left, int top, int right, int bottom);

    void setBaiduHeatMapEnabled(Boolean enabled);

    void setTrafficEnabled(Boolean enabled);

    void showMapPoi(Boolean isShow);

    void setBuildingsEnabled(Boolean enabled);

    void setMaxAndMinZoomLevel(float max, float min);

    void setMapType(int mapType);

    void showScaleControl(Boolean showScaleControl);

    /**
     * 创建地图时设置是否显示缩放控件
     *
     * @param showZoomControl 默认不设置
     */
    void showZoomControl(Boolean showZoomControl);

    /**
     * 创建地图时设置地图中心点
     *
     * @param center 经纬度
     */
    void setCenter(LatLng center);

    /**
     * 创建地图时设置地图缩放级别
     *
     * @param zoomLevel 地图级别
     */
    void setZoomLevel(float zoomLevel);

    void setScaleControlPosition(Point scaleControlPosition);

    void setZoomControlsPosition(Point zoomControlsPosition);

    void setLogoPosition(LogoPosition logoPosition);

    void setMapStatusLimits(LatLngBounds latLngBounds);

    /**
     * 创建地图时设置当前地图可显示范围
     *
     * @param visibleMapBounds (东北，西南)角坐标
     */
    void setVisibleMapBounds(LatLngBounds visibleMapBounds);

    void setEnlargeCenterWithDoubleClickEnable(Boolean enabled);

    void setAllGesturesEnabled(Boolean enabled);

    void setFlingEnable(Boolean enabled);

    void setPointGesturesCenter(Point point);

    void setLatLngGesturesCenter(LatLng latLng);

    void setDoubleClickGesturesCenter(Boolean enabled);

    void setCompassEnabled(Boolean enabled);

    /**
     * 创建地图时设置指南针的位置
     * 
     * @param compassPosition 屏幕坐标
     */
    void setCompassPotion(Point compassPosition);

    void setRotateGesturesEnabled(Boolean enabled);

    void setScrollGesturesEnabled(Boolean enabled);

    void setOverlookingGesturesEnabled(Boolean enabled);

    void setZoomGesturesEnabled(Boolean enabled);

    void setDoubleClickZoomEnabled(Boolean enabled);

    void setTwoTouchClickZoomEnabled(Boolean enabled);

    void clearAllOverlay();

    void setMapLanguage(Integer language);

    void setFontSizeLevel(Integer fontSize);

    void setMapBackgroundColor(Integer backgroundColor);

    void setMapBackgroundImage(BitmapDescriptor imageBitmap);

    void setDEMEnable(Boolean enabled);
}
