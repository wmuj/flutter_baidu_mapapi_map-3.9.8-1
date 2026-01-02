//
//  BMFOfflineMapHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import "BMFOfflineMapHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFOfflineMapHandles : NSObject
/// BMFOfflineMapHandler管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)offlineMapHandles;
@end

#pragma mark - offlineMapHandler
/// 启动下载指定城市ID的离线地图，或在暂停更新某城市后继续更新下载某城市离线地图
@interface BMFStartOfflineMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 启动更新指定城市ID的离线地图
@interface BMFUpdateOfflineMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 暂停下载或更新指定城市ID的离线地图
@interface BMFPauseOfflineMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 删除指定城市ID的离线地图
@interface BMFRemoveOfflineMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 销毁离线地图管理模块，不用时调用
@interface BMFDestroyOfflinMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 热门城市列表
@interface BMFGetHotCityListMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 支持离线地图城市列表
@interface BMFGetOfflineCityListMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 根据城市名搜索该城市离线地图记录
@interface BMFSearchCityMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 各城市离线地图更新信息
@interface BMFGetAllUpdateInfoMap : NSObject<BMFOfflineMapHandle>
 
@end

/// 指定城市ID离线地图更新信息
@interface BMFGetUpdateInfoMap : NSObject<BMFOfflineMapHandle>
 
@end
NS_ASSUME_NONNULL_END
