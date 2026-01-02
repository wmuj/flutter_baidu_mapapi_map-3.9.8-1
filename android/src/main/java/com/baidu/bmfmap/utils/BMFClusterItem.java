package com.baidu.bmfmap.utils;

import android.os.Bundle;

import com.baidu.bmfmap.cluster.clustering.ClusterItem;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.model.LatLng;

public class BMFClusterItem implements ClusterItem {

    private LatLng mPosition;
    private BitmapDescriptor mIcon;

    private Bundle mExtraInfo;

    public BMFClusterItem(LatLng latLng, BitmapDescriptor bitmapDescriptor, Bundle extraInfo) {
        mPosition = latLng;
        mIcon = bitmapDescriptor;
        mExtraInfo = extraInfo;
    }

    @Override
    public LatLng getPosition() {
        return mPosition;
    }

    @Override
    public BitmapDescriptor getBitmapDescriptor() {
        return mIcon;
    }

    @Override
    public Bundle getExtras() {
        return mExtraInfo;
    }
}
