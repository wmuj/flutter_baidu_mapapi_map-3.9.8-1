//
//  BMFProjectionHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/4/1.
//

#import "BMFMapViewHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFProjectionHandles : NSObject
/// BMFProjectionHandles管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)projectionHandles;
@end

#pragma mark - convert

@interface BMFCoordinateFromBMFPoint : NSObject<BMFMapViewHandler>

@end

@interface BMFPointFromBMFCoordinate : NSObject<BMFMapViewHandler>

@end

@interface BMFScreenPointFromMapPoint3 : NSObject<BMFMapViewHandler>

@end

NS_ASSUME_NONNULL_END
