#ifndef __BMFUserLocationConst__H__
#define __BMFUserLocationConst__H__

#import <Foundation/Foundation.h>

// 定位图层
/// 设定是否显示定位图层
FOUNDATION_EXPORT NSString *const kBMFMapShowUserLocationMethod;
/// 设定定位模式，取值为：BMFUserTrackingMode
FOUNDATION_EXPORT NSString *const kBMFMapUserTrackingModeMethod;
/// 返回定位坐标点是否在当前地图可视区域内
FOUNDATION_EXPORT NSString *const kBMFMapIsUserLocationVisibleMethod;
/// 动态定制我的位置样式
FOUNDATION_EXPORT NSString *const kBMFMapUpdateLocationDisplayParamMethod;
/// 动态更新我的位置数据
FOUNDATION_EXPORT NSString *const kBMFMapUpdateLocationDataMethod;
/// 地图切换定位模式后会调用此接口
FOUNDATION_EXPORT NSString *const kBMFMapUserTrackingModeChangedCallback;
#endif
