
#ifndef __BMFAnnotationMethodConst__H__
#define __BMFAnnotationMethodConst__H__

#import <Foundation/Foundation.h>

/// map刷新cluster
FOUNDATION_EXPORT NSString *const kBMFMapRefreshClustersMethod;
/// map设置当前层级最大距离聚合
FOUNDATION_EXPORT NSString *const kBMFMapSetMaxDistanceZoomMethod;
/// map清除聚合数据
FOUNDATION_EXPORT NSString *const kBMFMapCleanClusterMethod;
/// map更新cluster
FOUNDATION_EXPORT NSString *const kBMFMapUpdateClustersMethod;
/// map获取聚合后的cluster
FOUNDATION_EXPORT NSString *const kBMFMapGetClusterMethod;
/// map设置聚合经纬度
FOUNDATION_EXPORT NSString *const kBMFMapSetClusterCoordinatesMethod;
/// map添加marker
FOUNDATION_EXPORT NSString *const kBMFMapAddMarkerMethod;
/// map批量添加marker
FOUNDATION_EXPORT NSString *const kBMFMapAddMarkersMethod;
/// map删除marker
FOUNDATION_EXPORT NSString *const kBMFMapRemoveMarkerMethod;
/// map批量删除markers
FOUNDATION_EXPORT NSString *const kBMFMapRemoveMarkersMethod;
/// map清除所有的markers
FOUNDATION_EXPORT NSString *const kBMFMapCleanAllMarkersMethod;

/// map选中marker
FOUNDATION_EXPORT NSString *const kBMFMapSelectMarkerMethod;
/// map取消选中marker
FOUNDATION_EXPORT NSString *const kBMFMapDeselectMarkerMethod;

/// marker添加完成
FOUNDATION_EXPORT NSString *const kBMFMapDidAddMarkerMethod;

/// 设置地图使显示区域显示所有markers
FOUNDATION_EXPORT NSString *const kBMFMapShowMarkersMethod;

/// 更新marker属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateMarkerMemberMethod;
#endif
