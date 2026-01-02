//
//  BMFProjectionHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/4/1.
//

#import "BMFProjectionHandles.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "BMFProjectionConst.h"
#import "BMFMapView.h"

@interface BMFProjectionHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
}
@end

@implementation BMFProjectionHandles

static BMFProjectionHandles *_instance = nil;
+ (instancetype)defalutCenter {
    return [[BMFProjectionHandles alloc] init];
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

- (NSDictionary<NSString *, NSString *> *)projectionHandles {
    if (!_handles) {
        _handles = @{
            kBMFCoordinateFromScreenPointMethod: NSStringFromClass([BMFCoordinateFromBMFPoint class]),
            kBMFScreenPointFromCoordinateMethod: NSStringFromClass([BMFPointFromBMFCoordinate class]),
            kBMFScreenPointFromMapPoint3Method: NSStringFromClass([BMFScreenPointFromMapPoint3 class])
        };
    }
    return _handles;
}

@end


#pragma mark - convert
@implementation BMFCoordinateFromBMFPoint

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"point"]) {
        result([NSNull null]);
        return;
    }
    BMFMapPoint *point = [BMFMapPoint bmf_modelWith:[call.arguments safeObjectForKey:@"point"]];
    CLLocationCoordinate2D coord = [_mapView convertPoint:[point toCGPoint] toCoordinateFromView:_mapView];
    BMFCoordinate *coordinate = [BMFCoordinate fromCLLocationCoordinate2D:coord];
    result(@{@"coordinate" : [coordinate bmf_toDictionary]});
}

@end

@implementation BMFPointFromBMFCoordinate

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"coordinate"]) {
        result([NSNull null]);
        return;
    }
    BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"coordinate"]];
    CGPoint p = [_mapView convertCoordinate:[coord toCLLocationCoordinate2D] toPointToView:_mapView];
    BMFMapPoint *point = [BMFMapPoint fromCGPoint:p];
    result(@{@"point" : [point bmf_toDictionary]});
}

@end

@implementation BMFScreenPointFromMapPoint3

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"coordinate"]) {
        result([NSNull null]);
        return;
    }
    BMFCoordinate *coordinate = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"coordinate"]];
    CGFloat h = [[call.arguments safeObjectForKey:@"height"] floatValue];

    BMKMapPoint kPoint = BMKMapPointForCoordinate([coordinate toCLLocationCoordinate2D]);

    CGPoint p = [_mapView screenPointFromMapPoint3:BMKMapPoint3Make(kPoint.x, kPoint.y, h)];
    
    BMFMapPoint *fPoint = [BMFMapPoint fromCGPoint:p];
    result(@{@"point" : [fPoint bmf_toDictionary]});
}

@end
