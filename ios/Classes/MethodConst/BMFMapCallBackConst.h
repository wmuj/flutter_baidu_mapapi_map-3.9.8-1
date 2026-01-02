#ifndef __BMFMapCallBackConst__H__
#define __BMFMapCallBackConst__H__

#import <Foundation/Foundation.h>

// invoke

/// map加载完成
FOUNDATION_EXPORT NSString *const kBMFMapDidLoadCallback;
/// map渲染完成
FOUNDATION_EXPORT NSString *const kBMFMapDidRenderCallback;
/// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapOnDrawMapFrameCallback;
/// 地图绘制出有效数据时调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapDidRenderValidDataCallback;


/// 地图区域即将改变时会调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapRegionWillChangeCallback;
/// 地图区域即将改变时会调用此接口reason
FOUNDATION_EXPORT NSString *const kBMFMapRegionWillChangeWithReasonCallback;
/// 地图区域改变完成后会调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapRegionDidChangeCallback;
/// 地图区域改变完成后会调用此接口reason
FOUNDATION_EXPORT NSString *const kBMFMapRegionDidChangeWithReasonCallback;

/// 点中底图标注后会回调此接口
FOUNDATION_EXPORT NSString *const kBMFMapOnClickedMapPoiCallback;
/// 点中底图空白处会回调此接口
FOUNDATION_EXPORT NSString *const kBMFMapOnClickedMapBlankCallback;
/// 双击地图时会回调此接口
FOUNDATION_EXPORT NSString *const kBMFMapOnDoubleClickCallback;
/// 长按地图时会回调此接口
FOUNDATION_EXPORT NSString *const kBMFMapOnLongClickCallback;
/// 3DTouch 按地图时会回调此接口
///（仅在支持3D Touch，且fouchTouchEnabled属性为YES时，会回调此接口）
FOUNDATION_EXPORT NSString *const kBMFMapOnForceTouchCallback;


/// 地图状态改变完成后会调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapStatusDidChangedCallback;

/// 地图View进入/移出室内图
FOUNDATION_EXPORT NSString *const kBMFMapInOrOutBaseIndoorMapCallback;

/// marker点击
FOUNDATION_EXPORT NSString *const kBMFMapClickedMarkerCallback;
/// marker选中
FOUNDATION_EXPORT NSString *const kBMFMapDidSelectMarkerCallback;
/// marker取消选中
FOUNDATION_EXPORT NSString *const kBMFMapDidDeselectMarkerCallback;
/// marker的泡泡点击
FOUNDATION_EXPORT NSString *const kBMFMapDidClickedPaoPaoCallback;
/// marker的拖拽回调
FOUNDATION_EXPORT NSString *const kBMFMapDidDragMarkerCallback;

/// 点聚合点击item回调
FOUNDATION_EXPORT NSString *const kBMFMapClickClusterItemCallback;


/// 当mapView新添加overlay views时，调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapDidAddOverlayCallback;
/// 点中覆盖物后会回调此接口，目前只支持点中Polyline时回调
FOUNDATION_EXPORT NSString *const kMapOnClickedOverlayCallback;

/// 地图点击海量点
FOUNDATION_EXPORT NSString *const kMapOnClickedMultiPointOverlayItemCallback;
/// 动态轨迹动画开始
FOUNDATION_EXPORT NSString *const kTraceOverlayAnimationDidStartCallback;
/// 动态轨迹动画进度
FOUNDATION_EXPORT NSString *const kTraceOverlayAnimationRunningProgressCallback;
/// 动态轨迹动画结束
FOUNDATION_EXPORT NSString *const kTraceOverlayAnimationDidEndCallback;
/// 楼层动画结束
FOUNDATION_EXPORT NSString *const kPrismOverlayViewFloorAnimationDidEndCallback;

#endif
