package com.baidu.bmfmap.map.maphandler;

/**
 * 地图有些属性没有get接口，这个lei就用来暂存这些属性状态，供flutter端获取
 */
public class BMFMapStatus {

    private static volatile BMFMapStatus sInstance;

    public static BMFMapStatus getsInstance(){
        if (null == sInstance) {
            synchronized(BMFMapStatus.class) {
                if (null == sInstance) {
                    sInstance = new BMFMapStatus();
                }
            }
        }

        return sInstance;
    }

    public boolean isBaseIndoorEnable() {
        return mBaseIndoorEnable;
    }

    public void setBaseIndoorEnable(boolean mBaseIndoorEnable) {
        this.mBaseIndoorEnable = mBaseIndoorEnable;
    }

    public boolean isIndoorMapPoiEnable() {
        return mIndoorMapPoiEnable;
    }

    public void setIndoorMapPoiEnable(boolean mIndoorMapPoiEnable) {
        this.mIndoorMapPoiEnable = mIndoorMapPoiEnable;
    }

    public boolean isShowOperateLayerEnable() {
        return mShowOperateLayerEnable;
    }

    public void setShowOperateLayerEnable(boolean showOperateLayerEnable) {
        this.mShowOperateLayerEnable = showOperateLayerEnable;
    }

    /**
     * 室内图状态
     */
    private boolean mBaseIndoorEnable = false;


    private boolean mIndoorMapPoiEnable = true;


    private boolean mShowOperateLayerEnable = true;
}
