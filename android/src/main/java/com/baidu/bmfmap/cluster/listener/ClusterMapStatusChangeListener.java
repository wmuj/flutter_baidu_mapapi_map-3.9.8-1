package com.baidu.bmfmap.cluster.listener;

import com.baidu.mapapi.map.MapStatus;

public interface ClusterMapStatusChangeListener {

    void onMapStatusChangeStart(MapStatus status);

    void onMapStatusChangeStart(MapStatus status, int reason);

    void onMapStatusChange(MapStatus status);

    void onMapStatusChangeFinish(MapStatus status);
}
