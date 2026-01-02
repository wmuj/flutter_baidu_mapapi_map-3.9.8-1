package com.baidu.bmfmap.cluster.listener;

import com.baidu.mapapi.map.Marker;

public interface ClusterMarkerDragListener {
    void onMarkerDrag(Marker marker);

    void onMarkerDragEnd(Marker marker);

    void onMarkerDragStart(Marker marker);
}
