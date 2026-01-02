package com.baidu.bmfmap.interfaces;

import com.baidu.mapapi.map.CustomMapStyleCallBack;
import com.baidu.mapapi.map.LogoPosition;
import com.baidu.mapapi.map.MapCustomStyleOptions;

import android.graphics.Point;

/**
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
public interface BMFMapViewInterface {
    
    int getWidth();

    int getHeight();

    void showScaleControl(boolean show);

    void setScaleControlPosition(Point position);

    Point getScaleControlPosition();

    void showZoomControl(Boolean showZoomControl);

    void setZoomControlsPosition(Point position);

    void setLogoPosition(LogoPosition position);
    
    LogoPosition getLogoPosition();

    void setCustomMapStyleEnable(boolean enable);

    void setCustomMapStylePath(String path);

    void setMapCustomStyle(MapCustomStyleOptions options, CustomMapStyleCallBack callBack);
}
