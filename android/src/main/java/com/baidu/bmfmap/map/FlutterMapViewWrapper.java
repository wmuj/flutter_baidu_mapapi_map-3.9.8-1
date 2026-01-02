package com.baidu.bmfmap.map;

import com.baidu.bmfmap.interfaces.BMFMapViewInterface;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.TextureMapView;

public abstract class FlutterMapViewWrapper implements BMFMapViewInterface {
    protected String mViewType;

    public String getViewType() {
        return mViewType;
    }
    
    public MapView getMapView() {
        return null;
    }

    public TextureMapView getTextureMapView() {
        return null;
    }

    public abstract BaiduMap getBaiduMap();
}