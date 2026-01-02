#ifndef __BMFHeatMapConst__H__
#define __BMFHeatMapConst__H__
#import <Foundation/Foundation.h>
// 热力图
/// 设定是否展示热力图
FOUNDATION_EXPORT NSString *const kBMFMapShowHeatMapMethod;
/// 添加热力图
FOUNDATION_EXPORT NSString *const kBMFMapAddHeatMapMethod;
/// 添加热力图
FOUNDATION_EXPORT NSString *const kBMFMapUpdateHeatMapMethod;
/// 删除热力图
FOUNDATION_EXPORT NSString *const kBMFMapRemoveHeatMapMethod;
/// 开始热力图动画
FOUNDATION_EXPORT NSString *const kBMFMapStartHeatFrameAnimationMethod;
/// 停止热力图动画
FOUNDATION_EXPORT NSString *const kBMFMapStopHeatFrameAnimationMethod;
/// 控制渲染帧索引
FOUNDATION_EXPORT NSString *const kBMFMapSetHeatFrameAnimationIndexMethod;
/// 渲染帧索引回调
FOUNDATION_EXPORT NSString *const kBMFHeatMapFrameAnimationIndexCallbackMethod;

#endif
