//
//  BMFHeatMapHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/4/3.
//

#import <flutter_baidu_mapapi_base/NSObject+BMFVerify.h>
#import "BMFHeatMapHandles.h"
#import "BMFMapView.h"
#import "BMFHeatMapConst.h"
#import "BMFHeatMapModel.h"
@interface BMFHeatMapHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
    NSMutableArray<NSObject<BMFMapViewHandler> *> *_handlerArray;
}
@end

@implementation BMFHeatMapHandles
static BMFHeatMapHandles *_instance = nil;
+ (instancetype)defalutCenter {
    return [[BMFHeatMapHandles alloc] init];
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

- (NSDictionary<NSString *, NSString *> *)heatMapHandles {
    if (!_handles) {
        _handles = @{
            kBMFMapShowHeatMapMethod: NSStringFromClass([BMFShowHeatMap class]),
            kBMFMapAddHeatMapMethod: NSStringFromClass([BMFAddHeatMap class]),
            kBMFMapUpdateHeatMapMethod: NSStringFromClass([BMFUpdateHeatMap class]),
            kBMFMapRemoveHeatMapMethod: NSStringFromClass([BMFRemoveHeatMap class]),
            kBMFMapStartHeatFrameAnimationMethod: NSStringFromClass([BMFStartHeatMapFrameAnimation class]),
            kBMFMapStopHeatFrameAnimationMethod: NSStringFromClass([BMFStopHeatMapFrameAnimation class]),
            kBMFMapSetHeatFrameAnimationIndexMethod: NSStringFromClass([BMFHeatMapSetFrameAnimationIndex class]),
            kBMFHeatMapFrameAnimationIndexCallbackMethod: NSStringFromClass([BMFAddHeatMap class]),
        };
    }
    return _handles;
}

- (NSMutableArray<NSObject<BMFMapViewHandler> *> *)handlerArray {
    if (!_handlerArray) {
        _handlerArray = [NSMutableArray array];
    }
    return _handlerArray;
}

@end

#pragma mark - heatMap

@implementation BMFShowHeatMap

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"show"]) {
        result(@NO);
        return;
    }
    _mapView.baiduHeatMapEnabled = [[call.arguments safeObjectForKey:@"show"] boolValue];
    result(@YES);
}

@end

@interface BMFAddHeatMap ()<BMKHeatMapDelegate>

@end

@implementation BMFAddHeatMap

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}


- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView channel:(nonnull FlutterMethodChannel *)channel {
    _channel = channel;
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"heatMap"]) {
        result(@NO);
        return;
    }
    NSDictionary *heatDictionary = [call.arguments safeObjectForKey:@"heatMap"];
    BMFHeatMapModel *heatMapModel = [BMFHeatMapModel bmf_modelWith:heatDictionary];
    
    NSArray *datas = [heatDictionary safeObjectForKey:@"datas"];
    if (datas && datas.count > 0) {
        heatMapModel.datas = [datas copy];
    }
    BMKHeatMap *heatMap = [heatMapModel toBMKHeatMap];
    heatMap.delegate = self;
    [_mapView addHeatMap:heatMap];
    result(@YES);
}

- (void)onHandleCurrentHeatMapFrameAnimationIndex:(NSInteger)index {
    if (_channel) {
        [_channel invokeMethod:kBMFHeatMapFrameAnimationIndexCallbackMethod arguments:@{@"index": @(index)}];
    }
}

@end

@implementation BMFUpdateHeatMap
@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}


- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView channel:(nonnull FlutterMethodChannel *)channel {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"heatMap"]) {
        result(@NO);
        return;
    }
    NSDictionary *heatDictionary = [call.arguments safeObjectForKey:@"heatMap"];
    BMFHeatMapModel *heatMapModel = [BMFHeatMapModel bmf_modelWith:heatDictionary];
    
    NSArray *datas = [heatDictionary safeObjectForKey:@"datas"];
    if (datas && datas.count > 0) {
        heatMapModel.datas = [datas copy];
    }
    BMKHeatMap *heatMap = [heatMapModel toBMKHeatMap];
    [_mapView updateHeatMap:heatMap];
    result(@YES);
}

@end

@implementation BMFRemoveHeatMap

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    [_mapView removeHeatMap];
    result(@YES);
}

@end

@implementation BMFStartHeatMapFrameAnimation

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    [_mapView startHeatMapFrameAnimation];
    result(@YES);
}

@end


@implementation BMFStopHeatMapFrameAnimation

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    [_mapView stopHeatMapFrameAnimation];
    result(@YES);
}

@end

@implementation BMFHeatMapSetFrameAnimationIndex

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"index"]) {
        result(@NO);
        return;
    }
    
    NSInteger index = [[call.arguments safeObjectForKey:@"index"] integerValue];
    if (index < 0) {
        result(@NO);
        return;
    }
    
    [_mapView setHeatMapFrameAnimationIndex:index];
    result(@YES);
}

@end
