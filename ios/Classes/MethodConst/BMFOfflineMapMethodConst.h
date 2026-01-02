#ifndef __BMFOfflineMapMethodConst__H__
#define __BMFOfflineMapMethodConst__H__

#import <Foundation/Foundation.h>

/// offlineMapChannel
FOUNDATION_EXPORT NSString *const kBMFOfflineMapChannelName;

/// 状态回调
FOUNDATION_EXPORT NSString *const kBMFOfflineMapCallBackMethod;

/// 初始化
FOUNDATION_EXPORT NSString *const kBMFInitOfflineMapMethod;
/// 启动下载指定城市ID的离线地图，或在暂停更新某城市后继续更新下载某城市离线地图
FOUNDATION_EXPORT NSString *const kBMFStartOfflineMapMethod;
/// 启动更新指定城市ID的离线地图
FOUNDATION_EXPORT NSString *const kBMFUpdateOfflineMapMethod;
/// 暂停下载或更新指定城市ID的离线地图
FOUNDATION_EXPORT NSString *const kBMFPauseOfflineMapMethod;
/// 删除指定城市ID的离线地图
FOUNDATION_EXPORT NSString *const kBMFRemoveOfflineMapMethod;
/// 销毁离线地图管理模块，不用时调用
FOUNDATION_EXPORT NSString *const kBMFDestroyOfflinMapMethod;
/// 返回热门城市列表
FOUNDATION_EXPORT NSString *const kBMFGetHotCityListMapMethod;
/// 返回支持离线地图城市列表
FOUNDATION_EXPORT NSString *const kBMFGetOfflineCityListMapMethod;
/// 根据城市名搜索该城市离线地图记录
FOUNDATION_EXPORT NSString *const kBMFSearchCityMapMethod;
/// 返回各城市离线地图更新信息
FOUNDATION_EXPORT NSString *const kBMFGetAllUpdateInfoMapMethod;
/// 返回指定城市ID离线地图更新信息
FOUNDATION_EXPORT NSString *const kBMFGetUpdateInfoMapMethod;

#endif
