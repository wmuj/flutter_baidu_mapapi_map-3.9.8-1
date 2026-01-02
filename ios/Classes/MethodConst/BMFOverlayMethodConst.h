#ifndef __BMFOverlayMethodConst__H__
#define __BMFOverlayMethodConst__H__

#import <Foundation/Foundation.h>

/// map添加overlays
FOUNDATION_EXPORT NSString *const kBMFMapAddOverlaysMethod;
/// map添加TextMarker
FOUNDATION_EXPORT NSString *const kBMFMapAddTextMarkerMethod;
/// map添加IconMarker
FOUNDATION_EXPORT NSString *const kBMFMapAddIconMarkerMethod;
/// map添加polyline
FOUNDATION_EXPORT NSString *const kBMFMapAddPolylineMethod;
/// map添加arcline
FOUNDATION_EXPORT NSString *const kBMFMapAddArcineMethod;
/// map添加polygon
FOUNDATION_EXPORT NSString *const kBMFMapAddPolygonMethod;
/// map添加circle
FOUNDATION_EXPORT NSString *const kBMFMapAddCircleMethod;
/// map添加tile
FOUNDATION_EXPORT NSString *const kBMFMapAddTileMethod;
/// map添加ground
FOUNDATION_EXPORT NSString *const kBMFMapAddGroundMethod;
/// map添加geodesicline
FOUNDATION_EXPORT NSString *const kBMFMapAddGeodesicLineMethod;
/// map添加gradientline
FOUNDATION_EXPORT NSString *const kBMFMapAddGradientLineMethod;
/// map添加prismOverlay
FOUNDATION_EXPORT NSString *const kBMFMapAddPrismOverlayMethod;
/// map添加3DModelOverlay
FOUNDATION_EXPORT NSString *const kBMFMapAdd3DModelOverlayMethod;
/// map添加multiPointOverlay
FOUNDATION_EXPORT NSString *const kBMFMapAddMultiPointOverlayMethod;
/// map添加traceOverlay
FOUNDATION_EXPORT NSString *const kBMFMapAddTraceOverlayMethod;
/// map添加textOverlay
FOUNDATION_EXPORT NSString *const kBMFMapAddTextMethod;
/// map添加gradientCircle
FOUNDATION_EXPORT NSString *const kBMFMapAddGradientCircleMethod;

/// 获取overlay外接矩形
FOUNDATION_EXPORT NSString *const kBMFMapGetOverlayBoundsMethod;

/// map删除指定id的overlay
FOUNDATION_EXPORT NSString *const kBMFMapRemoveOverlayMethod;
/// map删除所有的overlay
FOUNDATION_EXPORT NSString *const kBMFMapClearOverlayMethod;
/// map删除指定id的traceOverlay
FOUNDATION_EXPORT NSString *const kBMFMapRemoveTraceOverlayMethod;
/// map删除指定id的瓦片图(适配android)
FOUNDATION_EXPORT NSString *const kBMFMapRemoveTileMethod;

/// 更新polyline属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdatePolylineMemberMethod;
/// 更新arcline属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateArclineMemberMethod;
/// 更新circle属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateCircleMemberMethod;
/// 更新polygon属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdatePolygonMemberMethod;
/// 更新3d模型属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdate3DModelOverlayMemberMethod;
/// 更新geodesicline属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateGeodesicLineMemberMethod;
/// 更新gradientline属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateGradientLineMemberMethod;
/// 更新prismOverlay属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdatePrismOverlayMemberMethod;
/// 更新textOverlay属性
FOUNDATION_EXPORT NSString *const kBMFMapUpdateTextMemberMethod;
/// 继续轨迹动画
FOUNDATION_EXPORT NSString *const kBMFMapResumeTraceOverlayMethod;
/// 暂停轨迹动画
FOUNDATION_EXPORT NSString *const kBMFMapPauseTraceOverlayMethod;

#endif
