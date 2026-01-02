//
//  BMFUserLocationHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/01.
//

#import "BMFUserLocationHandles.h"
#import <flutter_baidu_mapapi_base/NSObject+BMFVerify.h>
#import <flutter_baidu_mapapi_base/BMFDefine.h>

#import "BMFMapView.h"
#import "BMFUserLocationConst.h"
#import "BMFUserLocationModel.h"

@interface BMFUserLocationHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
}
@end

@implementation BMFUserLocationHandles

static BMFUserLocationHandles *_instance = nil;
+ (instancetype)defalutCenter {
    return [[BMFUserLocationHandles alloc] init];
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

- (NSDictionary<NSString *, NSString *> *)userLocationHandles {
    if (!_handles) {
        _handles = @{
            kBMFMapShowUserLocationMethod: NSStringFromClass([BMFShowUserLocation class]),
            kBMFMapUserTrackingModeMethod: NSStringFromClass([BMFSetUserTrackingMode class]),
            kBMFMapIsUserLocationVisibleMethod : NSStringFromClass([BMFIsUserLocationVisible class]),
            kBMFMapUpdateLocationDataMethod: NSStringFromClass([BMFUpdateLocationData class]),
            kBMFMapUpdateLocationDisplayParamMethod : NSStringFromClass([BMFUpdateLocationDisplayParam class])
        };
    }
    return _handles;
}

@end

#pragma mark - userLocation

@implementation BMFShowUserLocation

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
    _mapView.showsUserLocation = [[call.arguments safeObjectForKey:@"show"] boolValue];
    result(@YES);
}

@end

@implementation BMFSetUserTrackingMode

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"userTrackingMode"]) {
        result(@NO);
        return;
    }
    _mapView.userTrackingMode = [[call.arguments safeObjectForKey:@"userTrackingMode"] intValue];
    result(@YES);
}

@end

@implementation BMFIsUserLocationVisible

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!_mapView.showsUserLocation) {
        result(@{@"userLocationVisible": @NO});
        return;
    }
    
    result(@{@"userLocationVisible": @(_mapView.userLocationVisible)});
}

@end

@implementation BMFUpdateLocationData

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"userLocation"]) {
        result(@NO);
        return;
    }
    BMFUserLocationModel *userLocation = [BMFUserLocationModel bmf_modelWith:[call.arguments safeObjectForKey:@"userLocation"]];
    [_mapView updateLocationData:[userLocation toBMKUserLocation]];
    result(@YES);
}

@end

@implementation BMFUpdateLocationDisplayParam

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"userlocationDisplayParam"]) {
        result(@NO);
        return;
    }
    BMFLocationViewDisplayParam *displayParam = [BMFLocationViewDisplayParam bmf_modelWith:[call.arguments safeObjectForKey:@"userlocationDisplayParam"]];
    [_mapView updateLocationViewWithParam:[displayParam toBMKLocationViewDisplayParam]];
    result(@YES);
}

@end
