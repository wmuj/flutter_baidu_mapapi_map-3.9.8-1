//
//  BMFOverlayHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/2/12.
//

#import "BMFOverlayHandles.h"
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/BMFDefine.h>

#import "BMFMapView.h"
#import "BMFOverlayMethodConst.h"
#import "BMFFileManager.h"
#import "BMFPolyline.h"
#import "BMFArcline.h"
#import "BMFPolygon.h"
#import "BMFCircle.h"
#import "BMFTileModel.h"
#import "BMFURLTileLayer.h"
#import "BMFAsyncTileLayer.h"
#import "BMFSyncTileLayer.h"
#import "BMFGroundOverlay.h"
#import "BMFHollowShapeModel.h"
#import "BMFGeodesicLine.h"
#import "BMFGradientLine.h"
#import "BMFPrismOverlay.h"
#import "BMF3DModelOverlay.h"
#import "BMFMultiPointOverlay.h"
#import "BMFTraceOverlay.h"
#import "BMFText.h"
#import "BMFTextMarker.h"
#import "BMFIconMarker.h"

@interface BMFOverlayHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
}
@end

@implementation BMFOverlayHandles

static  BMFOverlayHandles *_instance = nil;
+ (instancetype)defalutCenter {
    return [[BMFOverlayHandles alloc] init];
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


- (NSDictionary<NSString *, NSString *> *)overlayHandles {
    if (!_handles) {
        _handles = @{
            kBMFMapAddOverlaysMethod: NSStringFromClass([BMFAddOverlays class]),
            kBMFMapAddPolylineMethod: NSStringFromClass([BMFAddPolyline class]),
            kBMFMapAddTextMarkerMethod: NSStringFromClass([BMFAddTextMarker class]),
            kBMFMapAddIconMarkerMethod: NSStringFromClass([BMFAddIconMarker class]),
            kBMFMapAddArcineMethod: NSStringFromClass([BMFAddArcline class]),
            kBMFMapAddPolygonMethod: NSStringFromClass([BMFAddPolygon class]),
            kBMFMapAddCircleMethod: NSStringFromClass([BMFAddCircle class]),
            kBMFMapAddTileMethod: NSStringFromClass([BMFAddTile class]),
            kBMFMapAddGroundMethod: NSStringFromClass([BMFAddGround class]),
            kBMFMapAddGeodesicLineMethod: NSStringFromClass([BMFAddGeodesicLine class]),
            kBMFMapAddGradientLineMethod: NSStringFromClass([BMFAddGradientLine class]),
            kBMFMapAddPrismOverlayMethod: NSStringFromClass([BMFAddPrismOverlay class]),
            kBMFMapAdd3DModelOverlayMethod: NSStringFromClass([BMFAdd3DModelOverlay class]),
            kBMFMapAddMultiPointOverlayMethod: NSStringFromClass([BMFAddMultiPointOverlay class]),
            kBMFMapAddTraceOverlayMethod: NSStringFromClass([BMFAddTraceOverlay class]),
            kBMFMapAddTextMethod: NSStringFromClass([BMFAddText class]),
            kBMFMapAddGradientCircleMethod: NSStringFromClass([BMFAddCircle class]),
            kBMFMapGetOverlayBoundsMethod: NSStringFromClass([BMFGetOverlayBounds class]),
            kBMFMapRemoveOverlayMethod: NSStringFromClass([BMFRemoveOverlay class]),
            kBMFMapClearOverlayMethod: NSStringFromClass([BMFClearOverlay class]),
            kBMFMapRemoveTraceOverlayMethod: NSStringFromClass([BMFRemoveTraceOverlay class]),
            kBMFMapRemoveTileMethod: NSStringFromClass([BMFRemoveTileOverlay class]),
            kBMFMapUpdatePolylineMemberMethod: NSStringFromClass([BMFUpdatePolyline class]),
            kBMFMapUpdateArclineMemberMethod: NSStringFromClass([BMFUpdateArcline class]),
            kBMFMapUpdateCircleMemberMethod: NSStringFromClass([BMFUpdateCircle class]),
            kBMFMapUpdatePolygonMemberMethod: NSStringFromClass([BMFUpdatePolygon class]),
            kBMFMapUpdate3DModelOverlayMemberMethod: NSStringFromClass([BMFUpdate3DModelOverlay class]),
            kBMFMapUpdateGeodesicLineMemberMethod: NSStringFromClass([BMFUpdateGeodesicLine class]),
            kBMFMapUpdateGradientLineMemberMethod: NSStringFromClass([BMFUpdateGradientLine class]),
            kBMFMapUpdateTextMemberMethod: NSStringFromClass([BMFUpdateText class]),
            kBMFMapUpdatePrismOverlayMemberMethod: NSStringFromClass([BMFUpdatePrismOverlay class]),
            kBMFMapResumeTraceOverlayMethod: NSStringFromClass([BMFResumeTraceOverlayDraw class]),
            kBMFMapPauseTraceOverlayMethod: NSStringFromClass([BMFPauseTraceOverlayDraw class])
            
        };
    }
    return _handles;
}

@end

#pragma mark - overlay

@implementation BMFAddOverlays

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments) {
        result(@NO);
        return;
    }
    NSArray *arguments = [call.arguments copy];
    if (arguments.count <= 0) {
        result(@NO);
        return;
    }
    
    id<BMKOverlay> overlay;
    NSMutableArray<id <BMKOverlay>> *overlays = [NSMutableArray array];

    for (NSDictionary *dic in arguments) {
        NSString *className = [dic safeObjectForKey:@"className"];
        if ([className isEqualToString:@"BMF3DModelOverlay"]) {
            overlay = [BMK3DModelOverlay overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFArcLine"]) {
            overlay = [BMKArcline overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFCircle"] ||
                 [className isEqualToString:@"BMFGradientCircle"]) {
            overlay = [BMKCircle overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFGeodesicLine"]) {
            overlay = [BMKGeodesicLine overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFGradientLine"]) {
            overlay = [BMKGradientLine overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFMultiPointOverlay"]) {
            overlay = [BMKMultiPointOverlay overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFPolygon"]) {
            overlay = [BMKPolygon overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFPolyline"]) {
            overlay = [BMKPolyline overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFPrismOverlay"]) {
            overlay = [BMKPrismOverlay overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFText"]) {
            overlay = [BMKText overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFTraceOverlay"]) {
            overlay = [BMKTraceOverlay overlayWithDictionary:dic];
        }
        else if ([className isEqualToString:@"BMFGround"]) {
            overlay = [BMKGroundOverlay overlayWithDictionary:dic];
        }
        else {
            NSLog(@"%@暂不支持addoverlays方式添加", className);
        }
        
        if (overlay) {
            [overlays addObject:overlay];
        }
    }
        
    if (overlays.count) {
        [_mapView addOverlays:overlays];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddPolyline

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKPolyline *polyline = [BMKPolyline overlayWithDictionary:call.arguments];
    if (polyline) {
        [_mapView addOverlay:polyline];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddTextMarker

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKTextMarker *marker = [BMKTextMarker overlayWithDictionary:call.arguments];
    if (marker) {
        [_mapView addOverlay:marker];
        if (marker.animation) {
            [marker.animation start];
        }
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddIconMarker

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKIconMarker *marker = [BMKIconMarker overlayWithDictionary:call.arguments];
    if (marker) {
        [_mapView addOverlay:marker];
        if (marker.animation) {
            [marker.animation start];
        }
        result(@YES);
    } else {
        result(@NO);
    }
}

@end


@implementation BMFAddArcline

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKArcline *arcline = [BMKArcline overlayWithDictionary:call.arguments];
    if (arcline) {
        [_mapView addOverlay:arcline];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end


@implementation BMFAddPolygon

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKPolygon *polygon = [BMKPolygon overlayWithDictionary:call.arguments];
    if (polygon) {
        [_mapView addOverlay:polygon];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end


@implementation BMFAddCircle

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKCircle *circle = [BMKCircle overlayWithDictionary:call.arguments];
    if (circle) {
        [_mapView addOverlay:circle];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddTile

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments) {
        result(@NO);
        return;
    }
    BMFTileModel *model = [BMFTileModel bmf_modelWith:call.arguments];
    model.tileOptions = [BMFTileModelOptions bmf_modelWith:call.arguments];
    //    NSLog(@"%@", [model bmf_toDictionary]);
    if (!model) {
        result(@NO);
        return;
    }
    if (model.tileOptions.tileLoadType == kBMFTileLoadUrl && model.tileOptions.url) {
        BMFURLTileLayer *urlTileLayer = [BMFURLTileLayer urlTileLayerWith:model];
        [_mapView addOverlay:urlTileLayer];
        result(@YES);
    }
    else if (model.tileOptions.tileLoadType == kBMFTileLoadLocalAsync) {
        BMFAsyncTileLayer *asyncTileLayer = [BMFAsyncTileLayer asyncTileLayerWith:model];
        [_mapView addOverlay:asyncTileLayer];
        result(@YES);
    }
    else if (model.tileOptions.tileLoadType == kBMFTileLoadLocalSync) {
        BMFSyncTileLayer *syncTileLayer = [BMFSyncTileLayer syncTileLayerWith:model];
        [_mapView addOverlay:syncTileLayer];
        result(@YES);
    }
    else {
        result(@NO);
    }
}

@end

@implementation BMFAddGround

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKGroundOverlay *ground = [BMKGroundOverlay overlayWithDictionary:call.arguments];
    if (ground) {
        [_mapView addOverlay:ground];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddGeodesicLine

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKGeodesicLine *geodesicline = [BMKGeodesicLine overlayWithDictionary:call.arguments];
    if (geodesicline) {
        [_mapView addOverlay:geodesicline];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddGradientLine

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKGradientLine *gradientLine = [BMKGradientLine overlayWithDictionary:call.arguments];
    if (gradientLine) {
        [_mapView addOverlay:gradientLine];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddPrismOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKPrismOverlay *prismOverlay = [BMKPrismOverlay overlayWithDictionary:call.arguments];
    if (prismOverlay) {
        [_mapView addOverlay:prismOverlay];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAdd3DModelOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMK3DModelOverlay *modelOverlay = [BMK3DModelOverlay overlayWithDictionary:call.arguments];
    if (modelOverlay) {
        [_mapView addOverlay:modelOverlay];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddMultiPointOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKMultiPointOverlay *multiPointOverlay = [BMKMultiPointOverlay overlayWithDictionary:call.arguments];
    if (multiPointOverlay) {
        [_mapView addOverlay:multiPointOverlay];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddTraceOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKTraceOverlay *traceOverlay = [BMKTraceOverlay overlayWithDictionary:call.arguments];
    if (traceOverlay) {
        [_mapView addOverlay:traceOverlay];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFAddText

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKText *text = [BMKText overlayWithDictionary:call.arguments];
    if (text) {
        [_mapView addOverlay:text];
        result(@YES);
    } else {
        result(@NO);
    }
}
@end

#pragma mark - Getter

@implementation BMFGetOverlayBounds

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"overlayType"] || !call.arguments[@"overlay"]) {
        result(@{});
        return;
    }
    NSString *overlayType = [call.arguments safeValueForKey:@"overlayType"];
    NSDictionary *overlayDic = [call.arguments safeValueForKey:@"overlay"];
    id <BMKOverlay> overlay;
    if ([overlayType isEqualToString:@"BMFPolyline"]) {
        overlay = [BMKPolyline overlayWithDictionary:overlayDic];
    }
    else if ([overlayType isEqualToString:@"BMFGradientLine"]) {
        overlay = [BMKGradientLine overlayWithDictionary:overlayDic];
    }
    else if ([overlayType isEqualToString:@"BMFPolygon"]) {
        overlay = [BMKPolygon overlayWithDictionary:overlayDic];
    }
    else if ([overlayType isEqualToString:@"BMFTraceOverlay"]) {
        overlay = [BMKTraceOverlay overlayWithDictionary:overlayDic];
    }
    else if ([overlayType isEqualToString:@"BMFArcLine"]) {
        overlay = [BMKArcline overlayWithDictionary:overlayDic];
    }
    else if ([overlayType isEqualToString:@"BMFCircle"]) {
        overlay = [BMKCircle overlayWithDictionary:overlayDic];
    }
 
    if (overlay) {
        BMFMapRect *rect = [BMFMapRect fromBMKMapRect:overlay.boundingMapRect];
        BMFCoordinateBounds *bounds = [rect toBMFCoordinateBounds];
        result([bounds bmf_toDictionary]);
    } else {
        result(@{});
    }
}

@end

#pragma mark - Remove

@implementation BMFRemoveOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block NSString *overlayID;
    __weak __typeof__(_mapView) weakMapView = _mapView;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[BMKPolyline class]]) { // polyline
            overlayID = ((BMFPolylineModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKPolygon class]]) { // polygon
            overlayID = ((BMFPolygonModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKArcline class]]) { // arcline
            overlayID = ((BMFArclineModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKCircle class]]) { // circle
            overlayID = ((BMFCircleModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKGroundOverlay class]]) { // ground
            overlayID = ((BMFGroundModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKGeodesicLine class]]) { // geodesicline
            overlayID = ((BMFGeodesicLineModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKGradientLine class]]) { // gradientline
            overlayID = ((BMFGradientLineModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKPrismOverlay class]]) { // prism
            overlayID = ((BMFPrismOverlayModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMK3DModelOverlay class]]) { // 3dmodel
            overlayID = ((BMF3DModelOverlayModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKMultiPointOverlay class]]) { // multipoint
            overlayID = ((BMFMultiPointOverlayModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKTraceOverlay class]]) { // trace
            overlayID = ((BMFTraceOverlayModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKText class]]) { // text
            overlayID = ((BMFTextModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKTextMarker class]]) { // text
            overlayID = ((BMFTextMarkerModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        else if ([obj isKindOfClass:[BMKIconMarker class]]) { // text
            overlayID = ((BMFIconMarkerModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        if (overlayID) {
            if ([ID isEqualToString:overlayID]) {
                [weakMapView removeOverlay:obj];
                result(@YES);
                *stop = YES;
                return;
            }
        }
    }];
}

@end

@implementation BMFClearOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {

    [_mapView removeOverlays:_mapView.overlays];
    result(@YES);
}

@end

// 兼容android的删除方法
@implementation BMFRemoveTraceOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block NSString *overlayID;
    __weak __typeof__(_mapView) weakMapView = _mapView;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKTraceOverlay class]]) { // trace
            overlayID = ((BMFTraceOverlayModel *)((id<BMFOverlay> )obj).flutterModel).Id;
        }
        
        if (overlayID) {
            if ([ID isEqualToString:overlayID]) {
                [weakMapView removeOverlay:obj];
                result(@YES);
                *stop = YES;
                return;
            }
        }
    }];
}

@end


@implementation BMFRemoveTileOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block NSString *overlayID;
    __weak __typeof__(_mapView) weakMapView = _mapView;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 瓦片图
        if ([obj isKindOfClass:[BMFURLTileLayer class]]) {
            overlayID = ((BMFURLTileLayer *)obj).Id;
        }
        else if ([obj isKindOfClass:[BMFAsyncTileLayer class]]) {
            overlayID = ((BMFAsyncTileLayer *)obj).Id;
        }
        else if ([obj isKindOfClass:[BMFSyncTileLayer class]]) {
            overlayID = ((BMFSyncTileLayer *)obj).Id;
        }
        
        if ([ID isEqualToString:overlayID]) {
            [weakMapView removeOverlay:obj];
            result(@YES);
            *stop = YES;
            return;
        }
        
    }];
}

@end

#pragma mark - Update
@implementation BMFUpdatePolyline

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block  BMKPolyline *polyline;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKPolyline class]]) {
            BMKPolyline *line = (BMKPolyline *)obj;
            if ([ID isEqualToString:((BMFPolylineModel *)line.flutterModel).Id]) {
                polyline = line;
                *stop = YES;
            }
        }
    }];
    if (!polyline) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    
    //        kBMFColorLine = 0,   ///< 单色折线
    //        kBMFColorsLine,      ///< 多色折线
    //        kBMFTextureLine,     ///< 单纹理折线
    //        kBMFTexturesLine,    ///< 多纹理折线
    //        kBMFDashLine,        ///< 虚线
    //        kBMFMultiDashLine    ///< 多色虚线
    
    if ([member isEqualToString:@"coordinates"]) {
        
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 1) {
            result(@NO);
            return;
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        switch (polyline.lineType) {
            case kBMFColorLine:
            case kBMFTextureLine:
            case kBMFDashLine: {
                BOOL flag = [polyline setPolylineWithCoordinates:coords count:coordinates.count];
                result([NSNumber numberWithBool:flag]);
                break;
            }
            case kBMFColorsLine:
            case kBMFTexturesLine:
            case kBMFMultiDashLine: {
                if (![call.arguments safeObjectForKey:@"indexs"]) {
                    result(@NO);
                    return;
                }
                NSMutableArray<NSNumber *> *indexs = [NSMutableArray array];
                for (NSNumber *value in call.arguments[@"indexs"]) {
                    [indexs addObject:value];
                }
                
                BOOL flag = [(BMKMultiPolyline *)polyline setMultiPolylineWithCoordinates:coords count:coordinates.count drawIndexs:indexs];
                result([NSNumber numberWithBool:flag]);
                break;
            }
            default:
                break;
        }
        
    }
    else if ([member isEqualToString:@"width"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"colors"]) {
        NSArray *colorsData = [call.arguments safeObjectForKey:@"value"];
        if (!colorsData || colorsData.count <= 0) {
            result(@NO);
            return;
        }
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        NSMutableArray<UIColor *> *colors = [NSMutableArray array];
        for (NSString *color in colorsData) {
            [colors addObject:[UIColor fromColorString:color]];
        }
        if (polyline.lineType == kBMFColorsLine || polyline.lineType == kBMFMultiDashLine) {
            ((BMKMultiColorPolylineView *)view).strokeColors = [colors copy];
            result(@YES);
            
        }
        else if (polyline.lineType ==kBMFColorLine || polyline.lineType == kBMFDashLine) {
            view.strokeColor = [colors firstObject];
            result(@YES);
        }
        else {
            NSLog(@"ios - 纹理折线不支持更新colors");
            result(@NO);
        }
    }
    else if ([member isEqualToString:@"lineDashType"]) {
        if (polyline.lineType == kBMFTextureLine || polyline.lineType == kBMFTexturesLine) {
            NSLog(@"ios - 纹理折线不支持虚线类型");
            result(@NO);
            return;
        }
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineDashType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineCapType"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        if (view.lineDashType != kBMKLineDashTypeNone) {
            NSLog(@"ios - lineCapType不支持虚线");
            result(@NO);
            return;
        }
        view.lineCapType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineJoinType"]) {
        if (polyline.lineType == kBMFDashLine || polyline.lineType == kBMFMultiDashLine) {
            NSLog(@"ios - lineJoinType不支持虚线");
            result(@NO);
            return;
        }
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineJoinType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"isThined"]) {
        polyline.isThined = [[call.arguments safeObjectForKey:@"value"] boolValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineDirectionCross180"]) {
        polyline.lineDirectionCross180 = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    } else if ([member isEqualToString:@"clickable"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.isClickable = [[call.arguments safeObjectForKey:@"value"] boolValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineBloomGradientASPeed"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineBloomGradientASPeed = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineBloomMode"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineBloomMode = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineBloomWidth"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineBloomWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineBloomAlpha"]) {
        BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
        view.lineBloomAlpha = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    } else if ([member isEqualToString:@"textures"]) {
        if (polyline.lineType == kBMFTexturesLine) {
            
            BMKMultiTexturePolylineView *view = (BMKMultiTexturePolylineView *)[_mapView viewForOverlay:polyline];
            NSArray *textures = (NSArray *)[call.arguments safeObjectForKey:@"value"];
            if (textures.count <= 0) {
                result(@NO);
                return;
            }
            NSMutableArray<UIImage *> *images = [NSMutableArray array];
            size_t imagesCount = textures.count;
            NSString *imagePath = nil;
            for (size_t i = 0; i < imagesCount; i++) {
                imagePath = textures[i];
                UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:imagePath]];
                [images addObject:image];
            }
            view.textureImages = images;
            result(@YES);
        } else {
            BMKPolylineView *view = (BMKPolylineView *)[_mapView viewForOverlay:polyline];
            NSArray *textures = (NSArray *)[call.arguments safeObjectForKey:@"value"];
            if (textures.count <= 0) {
                result(@NO);
                return;
            }
            NSString *imagePath = [NSString stringWithString:textures[0]];
            UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:imagePath]];
            view.textureImage = image;
            result(@YES);
        }
    } else {
        NSLog(@"ios -polyline- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation  BMFUpdateArcline

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKArcline *arcline;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKArcline class]]) {
            BMKArcline *aline = (BMKArcline *)obj;
            if ([ID isEqualToString:((BMFArclineModel *)aline.flutterModel).Id]) {
                arcline = aline;
                *stop = YES;
            }
        }
    }];
    if (!arcline) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    
    if ([member isEqualToString:@"coordinates"]) {
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 2) {
            result(@NO);
            return;
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        BOOL flag = [arcline setArclineWithCoordinates:coords];
        result([NSNumber numberWithBool:flag]);
    }
    else if ([member isEqualToString:@"width"]) {
        BMKArclineView *view = (BMKArclineView *)[_mapView viewForOverlay:arcline];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"color"]) {
        BMKArclineView *view = (BMKArclineView *)[_mapView viewForOverlay:arcline];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.strokeColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineDashType"]) {
        BMKArclineView *view = (BMKArclineView *)[_mapView viewForOverlay:arcline];
        view.lineDashType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else {
        NSLog(@"ios -arcline- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation BMFUpdateCircle

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKCircle *circle;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKCircle class]]) {
            BMKCircle *aCircle = (BMKCircle *)obj;
            if ([ID isEqualToString:((BMFCircleModel *)aCircle.flutterModel).Id]) {
                circle = aCircle;
                *stop = YES;
            }
        }
    }];
    if (!circle) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    
    if ([member isEqualToString:@"center"]) {
        BMFCoordinate *center = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        [circle setCoordinate:[center toCLLocationCoordinate2D]];
        result(@YES);
    }
    else if ([member isEqualToString:@"radius"]) {
        double radius = [[call.arguments safeObjectForKey:@"value"] doubleValue];
        [circle setRadius:radius];
        result(@YES);
    }
    else if ([member isEqualToString:@"width"]) {
        BMKCircleView *view = (BMKCircleView *)[_mapView viewForOverlay:circle];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"strokeColor"]) {
        BMKCircleView *view = (BMKCircleView *)[_mapView viewForOverlay:circle];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.strokeColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"fillColor"]) {
        BMKCircleView *view = (BMKCircleView *)[_mapView viewForOverlay:circle];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.fillColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineDashType"]) {
        BMKCircleView *view = (BMKCircleView *)[_mapView viewForOverlay:circle];
        view.lineDashType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"hollowShapes"]) {
        NSArray<id<BMKOverlay>> *hollowShapes = [BMFHollowShapeModel fromDictionaryArray:(NSArray<NSDictionary *> *)[call.arguments safeObjectForKey:@"value"]];
        circle.hollowShapes = hollowShapes;
        result(@YES);
    }
    else {
        NSLog(@"ios -circle- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation BMFUpdatePolygon

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKPolygon *polygon;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKPolygon class]]) {
            BMKPolygon *aPolygon = (BMKPolygon *)obj;
            if ([ID isEqualToString:((BMFPolygonModel *)aPolygon.flutterModel).Id]) {
                polygon = aPolygon;
                *stop = YES;
            }
        }
    }];
    if (!polygon) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    
    if ([member isEqualToString:@"coordinates"]) {
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 1) {
            result(@NO);
            return;
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        BOOL flag = [polygon setPolygonWithCoordinates:coords count:coordinates.count];
        result([NSNumber numberWithBool:flag]);
    }
    else if ([member isEqualToString:@"width"]) {
        BMKPolygonView *view = (BMKPolygonView *)[_mapView viewForOverlay:polygon];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"strokeColor"]) {
        BMKPolygonView *view = (BMKPolygonView *)[_mapView viewForOverlay:polygon];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.strokeColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"fillColor"]) {
        BMKPolygonView *view = (BMKPolygonView *)[_mapView viewForOverlay:polygon];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.fillColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineDashType"]) {
        BMKPolygonView *view = (BMKPolygonView *)[_mapView viewForOverlay:polygon];
        view.lineDashType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"hollowShapes"]) {
        NSArray<id<BMKOverlay>> *hollowShapes = [BMFHollowShapeModel fromDictionaryArray:(NSArray<NSDictionary *> *)[call.arguments safeObjectForKey:@"value"]];
        polygon.hollowShapes = hollowShapes;
        result(@YES);
    }
    else {
        NSLog(@"ios -polygon- 暂不支持设置%@", member);
        result(@YES);
    }
    
}

@end


@implementation BMFUpdate3DModelOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMK3DModelOverlay *modelOverlay;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMK3DModelOverlay class]]) {
            BMK3DModelOverlay *overlay = (BMK3DModelOverlay *)obj;
            if ([ID isEqualToString:((BMF3DModelOverlayModel *)overlay.flutterModel).Id]) {
                modelOverlay = overlay;
                *stop = YES;
            }
        }
    }];
    if (!modelOverlay) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    if ([member isEqualToString:@"option"]) {
        BMF3DModelOption *option = [BMF3DModelOption bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        if (!option) {
            result(@NO);
            return;
        }
      
        [modelOverlay setOption:[option toBMK3DModelOption]];
        result(@YES);
    }
    else if ([member isEqualToString:@"center"]) {
        BMFCoordinate *center = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        if (!center) {
            result(@NO);
            return;
        }
        [modelOverlay setCoordinate:[center toCLLocationCoordinate2D]];
        result(@YES);
    }
    else if ([member isEqualToString:@"optionAndcenter"]) {
        NSDictionary *params = [call.arguments safeObjectForKey:@"value"];
        BMF3DModelOption *option = [BMF3DModelOption bmf_modelWith:[params safeObjectForKey:@"option"]];
        BMFCoordinate *center = [BMFCoordinate bmf_modelWith:[params safeObjectForKey:@"center"]];
        if (!option || !center) {
            result(@NO);
            return;
        }
      
        [modelOverlay setOption:[option toBMK3DModelOption]];
        [modelOverlay setCoordinate:[center toCLLocationCoordinate2D]];
        result(@YES);
    }
    else {
        NSLog(@"ios -3DModelOverlay- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation BMFUpdateGeodesicLine

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKGeodesicLine *geodesicLine;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKGeodesicLine class]]) {
            BMKGeodesicLine *overlay = (BMKGeodesicLine *)obj;
            if ([ID isEqualToString:((BMFGeodesicLineModel *)overlay.flutterModel).Id]) {
                geodesicLine = overlay;
                *stop = YES;
            }
        }
    }];
    if (!geodesicLine) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    if ([member isEqualToString:@"coordinates"]) {
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 1) {
            result(@NO);
            return;
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        BOOL flag = [geodesicLine setGeodesicLineWithCoordinates:coords count:coordinates.count];
        result([NSNumber numberWithBool:flag]);
    }
    else if ([member isEqualToString:@"width"]) {
        BMKGeodesicLineView *view = (BMKGeodesicLineView *)[_mapView viewForOverlay:geodesicLine];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"strokeColor"]) {
        BMKGeodesicLineView *view = (BMKGeodesicLineView *)[_mapView viewForOverlay:geodesicLine];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.strokeColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"textureImage"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:[call.arguments safeObjectForKey:@"value"]]];
        if (!image) {
            result(@NO);
            return;
        }
        BMKGeodesicLineView *view = (BMKGeodesicLineView *)[_mapView viewForOverlay:geodesicLine];
        view.textureImage = image;
        result(@YES);
    }
    else if ([member isEqualToString:@"lineDashType"]) {
        BMKGeodesicLineView *view = (BMKGeodesicLineView *)[_mapView viewForOverlay:geodesicLine];
        view.lineDashType = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineDirectionCross180"]) {
        geodesicLine.lineDirectionCross180 = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else {
        NSLog(@"ios -geodesicLine- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation BMFUpdateGradientLine

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKGradientLine *gradientLine;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKGradientLine class]]) {
            BMKGradientLine *overlay = (BMKGradientLine *)obj;
            if ([ID isEqualToString:((BMFGradientLineModel *)overlay.flutterModel).Id]) {
                gradientLine = overlay;
                *stop = YES;
            }
        }
    }];
    if (!gradientLine) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];

    if ([member isEqualToString:@"coordinates"]) {
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 1 || ![call.arguments safeObjectForKey:@"indexs"]) {
            result(@NO);
            return;
        }
  
        NSMutableArray<NSNumber *> *indexs = [NSMutableArray array];
        for (NSNumber *value in call.arguments[@"indexs"]) {
            [indexs addObject:value];
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        
        BOOL flag = [gradientLine setGradientLineWithCoordinates:coords count:coordinates.count drawIndexs:indexs];
        result([NSNumber numberWithBool:flag]);
    }
    else if ([member isEqualToString:@"width"]) {
        BMKGradientLineView *view = (BMKGradientLineView *)[_mapView viewForOverlay:gradientLine];
        view.lineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"colors"]) {
        NSArray *colorsData = [call.arguments safeObjectForKey:@"value"];
        if (!colorsData || colorsData.count <= 0) {
            result(@NO);
            return;
        }
        BMKGradientLineView *view = (BMKGradientLineView *)[_mapView viewForOverlay:gradientLine];
        NSMutableArray<UIColor *> *colors = [NSMutableArray array];
        for (NSString *color in colorsData) {
            [colors addObject:[UIColor fromColorString:color]];
        }
        view.strokeColors = [colors copy];
        result(@YES);
    }
    else if ([member isEqualToString:@"isThined"]) {
        gradientLine.isThined = [[call.arguments safeObjectForKey:@"value"] boolValue];
        result(@YES);
    } else if ([member isEqualToString:@"lineDirectionCross180"]) {
        gradientLine.lineDirectionCross180 = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else {
        NSLog(@"ios -geodesicLine- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end

@implementation BMFUpdateText

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKText *textOverlay;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKText class]]) {
            BMKText *text = (BMKText *)obj;
            if ([ID isEqualToString:((BMFTextModel *)text.flutterModel).Id]) {
                textOverlay = text;
                *stop = YES;
            }
        }
    }];
    if (!textOverlay) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];

    if ([member isEqualToString:@"position"]) {
        BMFCoordinate *position = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        [textOverlay setCoordinate:[position toCLLocationCoordinate2D]];
    }
    else if ([member isEqualToString:@"bgColor"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.backgroundColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"text"]) {
        textOverlay.text = [call.arguments safeObjectForKey:@"value"];
        result(@YES);
    }
    else if ([member isEqualToString:@"fontColor"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.textColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"typeFace"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        BMFTypeFace *typeFace = [BMFTypeFace bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        view.textFontType = typeFace.textStype;
        result(@YES);
    }
    else if ([member isEqualToString:@"fontSize"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.fontSize = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"rotate"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.rotate = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"paragraphSpacing"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.textParagraphSpacing = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"maxLineWidth"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.textMaxLineWidth = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"lineSpacing"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.textLineSpacing = [[call.arguments safeObjectForKey:@"value"] floatValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"alignment"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        NSTextAlignment alignment = [[call.arguments safeObjectForKey:@"value"] intValue];
        view.textAlignment = alignment;
        result(@YES);
    }
    else if ([member isEqualToString:@"lineBreakMode"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        NSLineBreakMode mode = [[call.arguments safeObjectForKey:@"value"] intValue];
        view.textLineBreakMode = mode;
        result(@YES);
    }
    else if ([member isEqualToString:@"startLevel"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.startLevel = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else if ([member isEqualToString:@"endLevel"]) {
        BMKTextView *view = (BMKTextView *)[_mapView viewForOverlay:textOverlay];
        view.endLevel = [[call.arguments safeObjectForKey:@"value"] intValue];
        result(@YES);
    }
    else {
        NSLog(@"ios -BMKText- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end


@implementation BMFUpdatePrismOverlay

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKPrismOverlay *prismOverlay;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKPrismOverlay class]]) {
            BMKPrismOverlay *overlay = (BMKPrismOverlay *)obj;
            if ([ID isEqualToString:((BMFPrismOverlayModel *)overlay.flutterModel).Id]) {
                prismOverlay = overlay;
                *stop = YES;
            }
        }
    }];
    if (!prismOverlay) {
        result(@NO);
        return;
    }
    NSString *member = [call.arguments safeObjectForKey:@"member"];
    if ([member isEqualToString:@"coordinates"]) {
        NSArray<NSDictionary *> *coordinates = [call.arguments safeObjectForKey:@"value"];
        if (!coordinates || coordinates.count <= 1) {
            result(@NO);
            return;
        }
        
        CLLocationCoordinate2D coords[coordinates.count];
        for (size_t i = 0, count = coordinates.count; i < count; i++) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:coordinates[i]];
            coords[i] = [coord toCLLocationCoordinate2D];
        }
        BOOL flag = [prismOverlay setPrismOverlayWithCoordinates:coords count:coordinates.count];
        result([NSNumber numberWithBool:flag]);
    }
    else if ([member isEqualToString:@"buildInfo"]) {
        BMFBuildInfo *buildInfo = [BMFBuildInfo bmf_modelWith:[call.arguments safeObjectForKey:@"value"]];
        if (!buildInfo) {
            result(@NO);
            return;
        }
        prismOverlay.buildInfo = [buildInfo toBMKBuildInfo];
        result(@YES);
    }
    else if ([member isEqualToString:@"topFaceColor"]) {
        BMKPrismOverlayView *view = (BMKPrismOverlayView *)[_mapView viewForOverlay:prismOverlay];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.topFaceColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"sideFaceColor"]) {
        BMKPrismOverlayView *view = (BMKPrismOverlayView *)[_mapView viewForOverlay:prismOverlay];
        NSString *colorStr = [call.arguments safeObjectForKey:@"value"];
        view.sideFaceColor = [UIColor fromColorString:colorStr];
        result(@YES);
    }
    else if ([member isEqualToString:@"sideFacTexture"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:[call.arguments safeObjectForKey:@"value"]]];
        if (!image) {
            result(@NO);
            return;
        }
        BMKPrismOverlayView *view = (BMKPrismOverlayView *)[_mapView viewForOverlay:prismOverlay];
        view.sideTextureImage = image;
        result(@YES);
    } else if ([member isEqualToString:@"floorHeight"]) {
        CGFloat floorHeight = [[call.arguments safeObjectForKey:@"value"] floatValue];
        if (floorHeight < 0) {
            result(@NO);
            return;
        }
        BMKPrismOverlayView *view = (BMKPrismOverlayView *)[_mapView viewForOverlay:prismOverlay];
        view.prismOverlay.floorHeight = floorHeight;
        BMFPrismOverlayModel *model = (BMFPrismOverlayModel *)view.prismOverlay.flutterModel;
        model.floorHeight = floorHeight;
        result(@YES);
    }
    else {
        NSLog(@"ios -prismOverlay- 暂不支持设置%@", member);
        result(@YES);
    }
}

@end

@implementation BMFPauseTraceOverlayDraw
@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKTraceOverlay *traceOverlay;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKTraceOverlay class]]) {
            BMKTraceOverlay *overlay = (BMKTraceOverlay *)obj;
            if ([ID isEqualToString:((BMFTraceOverlayModel *)overlay.flutterModel).Id]) {
                traceOverlay = overlay;
                *stop = YES;
            }
        }
    }];
    if (!traceOverlay) {
        result(@NO);
        return;
    }
    [traceOverlay pauseTraceOverlayDraw];
    result(@YES);
}

@end

@implementation BMFResumeTraceOverlayDraw
@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"id"]) {
        result(@NO);
        return;
    }
    NSString *ID = [call.arguments safeObjectForKey:@"id"];
    __block BMKTraceOverlay *traceOverlay;
    [_mapView.overlays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BMKTraceOverlay class]]) {
            BMKTraceOverlay *overlay = (BMKTraceOverlay *)obj;
            if ([ID isEqualToString:((BMFTraceOverlayModel *)overlay.flutterModel).Id]) {
                traceOverlay = overlay;
                *stop = YES;
            }
        }
    }];
    if (!traceOverlay) {
        result(@NO);
        return;
    }
    [traceOverlay resumeTraceOverlayDraw];
    result(@YES);
}
@end

