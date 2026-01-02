//
//  BMFUserLocationHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/01.
//

#import "BMFMapViewHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFUserLocationHandles : NSObject
/// BMFUserLocationHandler管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)userLocationHandles;
@end
#pragma mark - userLocation

@interface BMFShowUserLocation : NSObject<BMFMapViewHandler>


@end

@interface BMFSetUserTrackingMode : NSObject<BMFMapViewHandler>

@end

@interface BMFIsUserLocationVisible : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateLocationData : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateLocationDisplayParam : NSObject<BMFMapViewHandler>

@end
NS_ASSUME_NONNULL_END
