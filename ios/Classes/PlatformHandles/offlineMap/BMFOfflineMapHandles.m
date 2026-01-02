//
//  BMFOfflineMapHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import "BMFOfflineMapHandles.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

#import "BMFOfflineMapMethodConst.h"
#import "BMFOfflineMap.h"
#import "BMFOLSearchRecordModel.h"

@interface BMFOfflineMapHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
}
@end

static BMFOfflineMapHandles *_instance = nil;
@implementation BMFOfflineMapHandles
/// BMFOfflineMapHandler管理中心
+ (instancetype)defalutCenter {
    return [[BMFOfflineMapHandles alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) { // 同步
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
 
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (NSDictionary<NSString *, NSString *> *)offlineMapHandles {
    if (!_handles) {
          _handles = @{
              kBMFStartOfflineMapMethod: NSStringFromClass([BMFStartOfflineMap class]),
              kBMFUpdateOfflineMapMethod: NSStringFromClass([BMFUpdateOfflineMap class]),
              kBMFPauseOfflineMapMethod: NSStringFromClass([BMFPauseOfflineMap class]),
              kBMFRemoveOfflineMapMethod: NSStringFromClass([BMFRemoveOfflineMap class]),
              kBMFDestroyOfflinMapMethod: NSStringFromClass([BMFDestroyOfflinMap class]),
              kBMFGetHotCityListMapMethod: NSStringFromClass([BMFGetHotCityListMap class]),
              kBMFGetOfflineCityListMapMethod: NSStringFromClass([BMFGetOfflineCityListMap class]),
              kBMFSearchCityMapMethod: NSStringFromClass([BMFSearchCityMap class]),
              kBMFGetAllUpdateInfoMapMethod: NSStringFromClass([BMFGetAllUpdateInfoMap class]),
              kBMFGetUpdateInfoMapMethod: NSStringFromClass([BMFGetUpdateInfoMap class])
              };
    }
    return _handles;
}
@end


#pragma mark - offlineMapHandler
@implementation BMFStartOfflineMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityID"]) {
        result(@NO);
    }
    BOOL success = [_offlineMap start:[[call.arguments safeValueForKey:@"cityID"] intValue]];
    result(@(success));
}

@end

@implementation BMFUpdateOfflineMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityID"]) {
        result(@NO);
    }
    BOOL success = [_offlineMap update:[[call.arguments safeValueForKey:@"cityID"] intValue]];
    result(@(success));
}

@end

@implementation BMFPauseOfflineMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityID"]) {
        result(@NO);
    }
    BOOL success = [_offlineMap pause:[[call.arguments safeValueForKey:@"cityID"] intValue]];
    result(@(success));
}

@end

@implementation BMFRemoveOfflineMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityID"]) {
        result(@NO);
    }
    BOOL success = [_offlineMap remove:[[call.arguments safeValueForKey:@"cityID"] intValue]];
    result(@(success));
}

@end

@implementation BMFDestroyOfflinMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    // TODO:ios没有销毁接口
    result(@(YES));
}

@end

@implementation BMFGetHotCityListMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    NSArray<BMFOLSearchRecordModel *> *hotCity = [BMFOLSearchRecordModel fromDataArray:[_offlineMap getHotCityList]];
    NSMutableArray *dicModels = [NSMutableArray array];
    for (BMFOLSearchRecordModel *model in hotCity) {
       
        [dicModels addObject: [model bmf_toDictionary]];
    }
    
    if (dicModels.count > 0) {
        result(@{@"searchCityRecord" : dicModels});
    } else {
        result([NSNull null]);
    }
    
}

@end

@implementation BMFGetOfflineCityListMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    NSArray<BMFOLSearchRecordModel *> *offlineCitys = [BMFOLSearchRecordModel fromDataArray:[_offlineMap getOfflineCityList]];
    NSMutableArray *dicModels = [NSMutableArray array];
    for (BMFOLSearchRecordModel *model in offlineCitys) {
       
        [dicModels addObject: [model bmf_toDictionary]];
    }
    
    if (dicModels.count > 0) {
        result(@{@"searchCityRecord" : dicModels});
    } else {
        result([NSNull null]);
    }
}

@end

@implementation BMFSearchCityMap 

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityName"]) {
        result([NSNull null]);
    }
    NSArray<BMFOLSearchRecordModel *> *citys = [BMFOLSearchRecordModel fromDataArray:[_offlineMap searchCity:[call.arguments safeValueForKey:@"cityName"]]];
      NSMutableArray *dicModels = [NSMutableArray array];
      for (BMFOLSearchRecordModel *model in citys) {
          [dicModels addObject: [model bmf_toDictionary]];
      }
      
      if (dicModels.count > 0) {
          result(@{@"searchCityRecord" : dicModels});
      } else {
          result([NSNull null]);
      }
}

@end

@implementation BMFGetAllUpdateInfoMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    NSArray<BMFOLUpdateElementModel *> *models = [BMFOLUpdateElementModel fromDataArray:[_offlineMap getAllUpdateInfo]];
    NSMutableArray *dicModels = [NSMutableArray array];
    for (BMFOLUpdateElementModel *model in models) {
        [dicModels addObject:[model bmf_toDictionary]];
    }

    if (dicModels.count > 0) {
        result(@{@"updateElements" : dicModels});
    } else {
        result([NSNull null]);
    }
}

@end

@implementation BMFGetUpdateInfoMap

@synthesize _offlineMap;

- (nonnull NSObject<BMFOfflineMapHandle> *)initWith:(nonnull BMFOfflineMap *)offlineMap {
    _offlineMap = offlineMap;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"cityID"]) {
        result([NSNull null]);
    }
    BMKOLUpdateElement *element = [_offlineMap getUpdateInfo:[[call.arguments safeValueForKey:@"cityID"] intValue]];
    if (element) {
        BMFOLUpdateElementModel *model = [BMFOLUpdateElementModel fromBMKOLUpdateElement:element];
        result([model bmf_toDictionary]);
    } else {
        result([NSNull null]);
    }
}

@end
