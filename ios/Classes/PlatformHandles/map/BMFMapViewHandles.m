//
//  BMFMapViewHandles.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import "BMFMapViewHandles.h"
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/BMFDefine.h>

#import "BMFMapView.h"
#import "BMFMapMethodConst.h"
#import "BMFAnnotationMethodConst.h"
#import "BMFFileManager.h"
#import "BMFEdgeInsets.h"
#import "BMFIndoorMapInfoModel.h"
#import "BMFMapStatusModel.h"
#import "BMFAnnotation.h"
#import "BMFParticleEffectModel.h"

@interface BMFMapViewHandles ()
{
    NSDictionary<NSString *, NSString *> *_handles;
}
@end

@implementation BMFMapViewHandles

static  BMFMapViewHandles *_instance = nil;
+ (instancetype)defalutCenter {
    return  [[BMFMapViewHandles alloc] init];
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

- (NSDictionary<NSString *, NSString *> *)mapViewHandles {
    if (!_handles) {
        _handles = @{
            kBMFMapUpdateMethod: NSStringFromClass([BMFUpdateMap class]),
            kBMFMapShowBaseIndoorMapMethod: NSStringFromClass([BMFShowBaseIndoorMap class]),
            kBMFMapShowBaseIndoorMapPoiMethod: NSStringFromClass([BMFShowBaseIndoorMapPoi class]),
            kBMFMapSwitchBaseIndoorMapFloorMethod: NSStringFromClass([BMFSwitchBaseIndoorMapFloor class]),
            kBMFMapGetFocusedBaseIndoorMapInfoMethod: NSStringFromClass([BMFGetFocusedBaseIndoorMapInfo class]),
            kBMFMapSetCustomMapStyleEnableMethod: NSStringFromClass([BMFSetCustomMapStyleEnable class]),
            kBMFMapSetCustomMapStylePathMethod: NSStringFromClass([BMFSetCustomMapStylePath class]),
            kBMFMapSetCustomMapStyleWithOptionMethod: NSStringFromClass([BMFSetCustomMapStyleWithOption class]),
            kBMFMapZoomInMethod: NSStringFromClass([BMFZoomIn class]),
            kBMFMapZoomOutMethod: NSStringFromClass([BMFZoomOut class]),
            kBMFMapSetCustomTrafficColorMethod: NSStringFromClass([BMFSetCustomTrafficColor class]),
            kBMFMapSetCenterCoordinateMethod: NSStringFromClass([BMFSetCenterCoordinate class]),
            kBMFMapTakeSnapshotMethod: NSStringFromClass([BMFTakeSnapshot class]),
            kBMFMapTakeSnapshotWithRectMethod: NSStringFromClass([BMFTakeSnapshotWithRect class]),
            kBMFMapSetCompassImageMethod: NSStringFromClass([BMFSetCompassImage class]),
            kBMFMapSetVisibleMapBoundsMethod: NSStringFromClass([BMFSetVisibleMapBounds class]),
            kBMFMapSetVisibleMapBoundsWithPaddingMethod: NSStringFromClass([BMFSetVisibleMapBoundsWithPadding class]),
            kBMFMapSetMapStatusMethod: NSStringFromClass([BMFSetMapStatus class]),
            kBMFMapSwitchOverlayLayerAndPOILayerMethod: NSStringFromClass([BMFSwitchOverlayLayerAndPOILayer class]),
            kBMFMapPoiTagEnableAndPoiTagTypeMethod: NSStringFromClass([BMFMapPoiTagEnableAndPoiTagType class]),
            kBMFMapSwitchLayerOrderMethod: NSStringFromClass([BMFSwitchLayerOrder class]),
            kBMFMapGetMapStatusMethod: NSStringFromClass([BMFGetMapStatus class]),
            kBMFMapGetMapTypeMethod: NSStringFromClass([BMFGetMapType class]),
            kBMFMapGetMapLanguageTypeMethod: NSStringFromClass([BMFGetLanguageType class]),
            kBMFMapGetMapBackgroundColorMethod: NSStringFromClass([BMFGetBackgroundColor class]),
            kBMFMapGetFontSizeLevelMethod: NSStringFromClass([BMFGetFointSizeLevel class]),
            kBMFMapGetZoomLevelMethod: NSStringFromClass([BMFGetZoomLevel class]),
            kBMFMapGetMinZoomLevelMethod: NSStringFromClass([BMFGetMinZoomLevel class]),
            kBMFMapGetMaxZoomLevelMethod: NSStringFromClass([BMFGetMaxZoomLevel class]),
            kBMFMapGetRotationMethod: NSStringFromClass([BMFGetRotation class]),
            kBMFMapGetOverlookingMethod: NSStringFromClass([BMFGetOverlooking class]),
            kBMFMapGetMinOverlookingMethod: NSStringFromClass([BMFGetMinOverlooking class]),
            kBMFMapGetBuildingsEnabledMethod: NSStringFromClass([BMFGetBuildingsEnabled class]),
            kBMFMapGetShowMapPoiMethod: NSStringFromClass([BMFGetShowMapPoi class]),
            kBMFMapGetTrafficEnabledMethod: NSStringFromClass([BMFGetTrafficEnabled class]),
            kBMFMapGetBaiduHeatMapEnabledMethod: NSStringFromClass([BMFGetBaiduHeatMapEnabled class]),
            kBMFMapGetGesturesEnabledMethod: NSStringFromClass([BMFGetGesturesEnabled class]),
            kBMFMapGetZoomEnabledMethod: NSStringFromClass([BMFGetZoomEnabled class]),
            kBMFMapGetZoomEnabledWithTapMethod: NSStringFromClass([BMFGetZoomEnabledWithTap class]),
            kBMFMapGetScrollEnabledMethod: NSStringFromClass([BMFGetScrollEnabled class]),
            kBMFMapGetOverlookEnabledMethod: NSStringFromClass([BMFGetOverlookEnabled class]),
            kBMFMapGetRotateEnabledMethod: NSStringFromClass([BMFGetRotateEnabled class]),
            kBMFMapGetForceTouchEnabledMethod: NSStringFromClass([BMFGetForceTouchEnabled class]),
            kBMFMapGetShowMapScaleBarMethod: NSStringFromClass([BMFGetShowMapScaleBar class]),
            kBMFMapGetMapScaleBarPositionMethod: NSStringFromClass([BMFGetMapScaleBarPosition class]),
            kBMFMapGetLogoPositionMethod: NSStringFromClass([BMFGetLogoPosition class]),
            kBMFMapGetVisibleMapBoundsMethod: NSStringFromClass([BMFGetVisibleMapBounds class]),
            kBMFMapGetBaseIndoorMapEnabledMethod: NSStringFromClass([BMFGetBaseIndoorMapEnabled class]),
            kBMFMapGetShowIndoorMapPoiMethod: NSStringFromClass([BMFGetShowIndoorMapPoi class]),
            kBMFMapGetShowOperateLayerMethod: NSStringFromClass([BMFGetShowOperateLayer class]),
            kBMFMapGetMapCopyrightInformationMethod: NSStringFromClass([BMFMapCopyrightInformation class]),
            kBMFMapGetMapMappingQualificationMethod: NSStringFromClass([BMFMapCopyrightInformation class]),
            kBMFMapGetMapApprovalNumberMethod: NSStringFromClass([BMFMapCopyrightInformation class]),
            kBMFMapShowMapParticleEffectMethod: NSStringFromClass([BMFMapShowParticleEffect class]),
            kBMFMapCloseMapParticleEffectMethod: NSStringFromClass([BMFMapCloseParticleEffect class]),
            kBMFMapCustomMapParticleEffectMethod: NSStringFromClass([BMFMapCustomParticleEffect class]),
            kBMFMapFitVisibleMapRectWithPaddingMethod: NSStringFromClass([BMFFitVisibleMapRectWithPadding class]),
            kBMFMapSetMapCenterToScreenPtMethod: NSStringFromClass([BMFSetMapCenterToScreenPt class]),
        };
    }
    return _handles;
}

@end

#pragma mark - map

@implementation BMFUpdateMap

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
    BOOL success = [_mapView updateMapViewWith:call.arguments];
    result(@(success));
}

@end

@implementation BMFShowBaseIndoorMap

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
    _mapView.baseIndoorMapEnabled = [[call.arguments safeObjectForKey:@"show"] boolValue];
    [_mapView setMapStatus:[_mapView getMapStatus]];
    result(@YES);
}

@end

@implementation BMFShowBaseIndoorMapPoi

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !_mapView.baseIndoorMapEnabled) {
        result(@NO);
        return;
    }
    _mapView.showIndoorMapPoi = [[call.arguments safeValueForKey:@"showIndoorPoi"] boolValue];
    result(@YES);
}

@end

@implementation BMFSwitchBaseIndoorMapFloor

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMKSwitchIndoorFloorError error;
    if (!call.arguments || !call.arguments[@"floorId"] || !call.arguments[@"indoorId"] || !_mapView.baseIndoorMapEnabled) {
        error = BMKSwitchIndoorFloorFailed;
        result(@{@"result":@(error)});
        return;
    }
    
    error = [_mapView switchBaseIndoorMapFloor:[call.arguments safeValueForKey:@"floorId"] withID:[call.arguments safeValueForKey:@"indoorId"]];
    result(@{@"result":@(error)});
}

@end

@implementation BMFGetFocusedBaseIndoorMapInfo

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!_mapView.baseIndoorMapEnabled) {
        result(@{@"result": [NSNull null]});
        return;
    }
    BMKBaseIndoorMapInfo *info = [_mapView getFocusedBaseIndoorMapInfo];
    BMFIndoorMapInfoModel *model = [BMFIndoorMapInfoModel new];
    model.strID = info.strID;
    model.strFloor = info.strFloor;
    model.listStrFloors = [info.arrStrFloors copy];
    result([model bmf_toDictionary]);
}

@end

@implementation  BMFSetCustomMapStyleEnable

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
    [_mapView setCustomMapStyleEnable:[[call.arguments safeValueForKey:@"enable"] boolValue]];
    result(@YES);
}

@end

@implementation BMFSetCustomMapStylePath

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
    NSString *path = [[BMFFileManager defaultCenter] pathForFlutterFileName:[call.arguments safeValueForKey:@"path"]];
    [_mapView setCustomMapStylePath:path mode:[[call.arguments safeValueForKey:@"mode"] intValue]];
    result(@YES);
}
@end

@implementation BMFSetCustomMapStyleWithOption

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
    BMKCustomMapStyleOption *options = [BMKCustomMapStyleOption new];
    options.customMapStyleID = [[call.arguments safeObjectForKey:@"customMapStyleOption"] safeValueForKey:@"customMapStyleID"];
    NSString *localPath = [[call.arguments safeObjectForKey:@"customMapStyleOption"] safeValueForKey:@"customMapStyleFilePath"];
    if (localPath && localPath.length > 0) {
        options.customMapStyleFilePath = [[BMFFileManager defaultCenter] pathForFlutterFileName:localPath];
    }
    [_mapView setCustomMapStyleWithOption:options preLoad:^(NSString *path) {
        if (path) {
            result(@{@"preloadPath": path});
        }
    } success:^(NSString *path) {
        if (path) {
            result(@{@"successPath": path});
        }
    } failure:^(NSError *error, NSString *path) {
        if (error) {
            result(@{@"errorCode": @(error.code), @"errorPath": path ? path : [NSNull null]});
        }
    }];
    
}

@end

@implementation BMFZoomIn

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BOOL flag = [_mapView zoomIn];
    result(@(flag));
}

@end

@implementation BMFZoomOut

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BOOL flag = [_mapView zoomOut];
    result(@(flag));
}

@end

@implementation  BMFSetCustomTrafficColor

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
    UIColor *smooth = [UIColor fromColorString:[call.arguments safeValueForKey:@"smooth"]];
    UIColor *slow = [UIColor fromColorString:[call.arguments safeValueForKey:@"slow"]];
    UIColor *congestion = [UIColor fromColorString:[call.arguments safeValueForKey:@"congestion"]];
    UIColor *severeCongestion = [UIColor fromColorString:[call.arguments safeValueForKey:@"severeCongestion"]];
    if (smooth && slow && congestion && severeCongestion) {
        BOOL flag = [_mapView setCustomTrafficColorForSmooth:smooth slow:slow congestion:congestion severeCongestion:severeCongestion];
        result(@(flag));
    } else {
        result(@NO);
    }
}
@end

@implementation BMFSetCenterCoordinate

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
    BMFCoordinate *coordinate = [BMFCoordinate bmf_modelWith:[call.arguments safeObjectForKey:@"coordinate"]];
    if (coordinate) {
        [_mapView setCenterCoordinate:[coordinate toCLLocationCoordinate2D] animated:[[call.arguments safeValueForKey:@"animated"] boolValue]];
        result(@YES);
    } else {
        result(@NO);
    }
}

@end

@implementation BMFTakeSnapshot

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    UIImage *image = [_mapView takeSnapshot];
    if (!image) {
        result(@[]);
        return;
    }
    NSData *data = UIImageJPEGRepresentation(image, 100);
    FlutterStandardTypedData *fData = [FlutterStandardTypedData typedDataWithBytes:data];
    result(fData);
}

@end

@implementation BMFTakeSnapshotWithRect

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"rect"]) {
        result(@[]);
        return;
    }
    
    CGRect rect = [[BMFMapRect bmf_modelWith:[call.arguments safeObjectForKey:@"rect"]] toCGRect];
    UIImage *image = [_mapView takeSnapshot:rect];
    if (!image) {
        result(@[]);
        return;
    }
    NSData *data = UIImageJPEGRepresentation(image, 100);
    FlutterStandardTypedData *fData = [FlutterStandardTypedData typedDataWithBytes:data];
    result(fData);
}

@end

@implementation BMFSetCompassImage

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"imagePath"]) {
        result(@NO);
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:[call.arguments safeValueForKey:@"imagePath"]]];
    [_mapView setCompassImage:image];
    result(@YES);
}

@end

@implementation BMFSetVisibleMapBounds

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"visibleMapBounds"] || !call.arguments[@"animated"]) {
        result(@NO);
        return;
    }
    BMFCoordinateBounds *bounds = [BMFCoordinateBounds bmf_modelWith:[call.arguments safeObjectForKey:@"visibleMapBounds"]];
    [_mapView setVisibleMapRect:[bounds toBMKMapRect] animated:[[call.arguments safeValueForKey:@"animated"] boolValue]];
    result(@YES);
}

@end

@implementation BMFSetVisibleMapBoundsWithPadding

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"visibleMapBounds"]) {
        result(@NO);
        return;
    }
    BMFCoordinateBounds *bounds = [BMFCoordinateBounds bmf_modelWith:[call.arguments safeObjectForKey:@"visibleMapBounds"]];
    BMFEdgeInsets *insets = [BMFEdgeInsets bmf_modelWith:[call.arguments safeObjectForKey:@"insets"]];
    [_mapView setVisibleMapRect:[bounds toBMKMapRect] edgePadding:[insets toUIEdgeInsets] animated:[[call.arguments safeValueForKey:@"animated"] boolValue]];
    result(@YES);
}

@end

@implementation BMFFitVisibleMapRectWithPadding

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"fitVisibleMapBounds"]) {
        result(@NO);
        return;
    }
    BMFCoordinateBounds *bounds = [BMFCoordinateBounds bmf_modelWith:[call.arguments safeObjectForKey:@"fitVisibleMapBounds"]];
    BMFEdgeInsets *insets = [BMFEdgeInsets bmf_modelWith:[call.arguments safeObjectForKey:@"insets"]];
    [_mapView fitVisibleMapRect:[bounds toBMKMapRect] edgePadding:[insets toUIEdgeInsets] withAnimated:[[call.arguments safeValueForKey:@"animated"] boolValue]];
    result(@YES);
}

@end

@implementation BMFSetMapStatus

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"mapStatus"] || !call.arguments[@"animateDurationMs"] ) {
        result(@NO);
        return;
    }
    BMFMapStatusModel *status = [BMFMapStatusModel bmf_modelWith:[call.arguments safeObjectForKey:@"mapStatus"]];
    int animate = [[call.arguments safeValueForKey:@"animateDurationMs"] intValue];
    [_mapView setMapStatus:[status toMapStatus] withAnimation: animate!=0 ? YES : NO];
    result(@YES);
}

@end

@implementation BMFSetMapCenterToScreenPt

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"point"]) {
        result(@NO);
        return;
    }
    BMFMapPoint *point = [BMFMapPoint bmf_modelWith:[call.arguments safeObjectForKey:@"point"]];
    [_mapView setMapCenterToScreenPt:[point toCGPoint]];
    result(@YES);
}

@end

#pragma mark - Getter

@implementation BMFGetMapStatus

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMFMapStatusModel *status = [BMFMapStatusModel fromMapStatus:[_mapView getMapStatus]];
    status ?  result(@{@"mapStatus":[status bmf_toDictionary]}) : result(@{@"mapStatus":[NSNull null]});
}

@end


@implementation BMFGetMapType

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"mapType" : @(_mapView.mapType)});
}

@end

@implementation BMFGetLanguageType

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"languageType" : @(_mapView.languageType)});
}

@end

@implementation BMFGetBackgroundColor

@synthesize _mapView;
- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!result) return;
    result(@{@"backgroundColor": [UIColor colorRGBStringFrom:_mapView.backgroundColor]});
}

@end


@implementation BMFGetFointSizeLevel

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"fontSizeLevel" : @(_mapView.fontSizeLevel)});
}

@end

@implementation BMFGetZoomLevel

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"zoomLevel": @((int)_mapView.zoomLevel)});
}

@end

@implementation BMFGetMinZoomLevel

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"minZoomLevel": @((int)_mapView.minZoomLevel)});
}

@end

@implementation BMFGetMaxZoomLevel

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"maxZoomLevel" : @((int)_mapView.maxZoomLevel)});
}

@end

@implementation BMFGetRotation

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"rotation" : @((float)_mapView.rotation)});
}

@end

@implementation BMFGetOverlooking

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"overlooking": @((float)_mapView.overlooking)});
}

@end

@implementation BMFGetMinOverlooking

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"minOverlooking" : @(_mapView.minOverlooking)});
}

@end

@implementation BMFGetBuildingsEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"buildingsEnabled": @(_mapView.buildingsEnabled)});
}

@end

@implementation BMFGetShowMapPoi

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"showMapPoi" : @(_mapView.showMapPoi)});
}

@end

@implementation BMFGetTrafficEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"trafficEnabled": @(_mapView.trafficEnabled)});
}

@end

@implementation BMFGetBaiduHeatMapEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"baiduHeatMapEnabled": @(_mapView.baiduHeatMapEnabled)});
}

@end

@implementation BMFGetGesturesEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"gesturesEnabled" : @(_mapView.gesturesEnabled)});
}

@end

@implementation BMFGetZoomEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"zoomEnabled": @(_mapView.zoomEnabled)});
}

@end

@implementation BMFGetZoomEnabledWithTap

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"zoomEnabledWithTap" : @(_mapView.zoomEnabledWithTap)});
}

@end

@implementation BMFGetScrollEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"scrollEnabled" : @(_mapView.scrollEnabled)});
}

@end

@implementation BMFGetOverlookEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"overlookEnabled": @(_mapView.overlookEnabled)});
}

@end

@implementation BMFGetRotateEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"rotateEnabled": @(_mapView.rotateEnabled)});
}

@end

@implementation BMFGetForceTouchEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"forceTouchEnabled": @(_mapView.forceTouchEnabled)});
}

@end

@implementation BMFGetShowMapScaleBar

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"showMapScaleBar" : @(_mapView.showMapScaleBar)});
}

@end

@implementation BMFGetMapScaleBarPosition

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMFMapPoint *point = [BMFMapPoint fromCGPoint:_mapView.mapScaleBarPosition];
    result(@{@"mapScaleBarPosition": [point bmf_toDictionary]});
}

@end

@implementation BMFGetLogoPosition

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"logoPosition" : @(_mapView.logoPosition)});
}

@end

@implementation BMFGetVisibleMapBounds

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    BMFMapRect *mapRect = [BMFMapRect fromBMKMapRect:_mapView.visibleMapRect];
    BMFCoordinateBounds *visibleMapBounds = [mapRect toBMFCoordinateBounds];
    result(@{@"visibleMapBounds": [visibleMapBounds bmf_toDictionary]});
}

@end

@implementation BMFGetBaseIndoorMapEnabled

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"baseIndoorMapEnabled" : @(_mapView.baseIndoorMapEnabled)});
}

@end

@implementation BMFGetShowIndoorMapPoi

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"showIndoorMapPoi" : @(_mapView.showIndoorMapPoi)});
}

@end

@implementation BMFGetShowOperateLayer

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    result(@{@"showOperateLayer" : @(_mapView.showOperateLayer)});
}

@end

#pragma mark - Layer

@implementation BMFSwitchOverlayLayerAndPOILayer

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"isSwitch"]) {
        result(@NO);
        return;
    }
    BOOL isSwitch = [[call.arguments safeObjectForKey:@"isSwitch"] boolValue];
    BOOL flag = [_mapView switchOverlayLayerAndPOILayer:isSwitch];
    result([NSNumber numberWithBool:flag]);
}

@end

@implementation BMFMapPoiTagEnableAndPoiTagType

@synthesize _mapView;
- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"method"] || !call.arguments[@"poiTagType"]) {
        result(@NO);
        return;
    }

    NSString *method = [call.arguments safeObjectForKey:@"method"];
    if ([method isEqualToString:@"set"]) {
        
        BOOL poiTagEnable = [[call.arguments safeObjectForKey:@"poiTagEnable"] boolValue];
        BMKPoiTagType tagType = [[call.arguments safeValueForKey:@"poiTagType"] intValue];
        [_mapView setPoiTagEnable:poiTagEnable poiTagType:tagType];
        result(@YES);
        return;
    } else if ([method isEqualToString:@"get"]) {
        BMKPoiTagType tagType = [[call.arguments safeValueForKey:@"poiTagType"] intValue];
        BOOL isShow = [_mapView getPoiTagEnable:tagType];
        result(@(isShow));
        return;
    }
    result(@NO);
}

@end


@implementation BMFSwitchLayerOrder

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    if (!call.arguments || !call.arguments[@"layer"] || !call.arguments[@"otherLayer"]) {
        result(@NO);
        return;
    }
    BOOL flag = [_mapView switchLayerOrder:(BMKLayerType)[call.arguments[@"layer"] integerValue] otherLayer:(BMKLayerType)[call.arguments[@"otherLayer"] integerValue]];
    result([NSNumber numberWithBool:flag]);
}

@end


@implementation BMFMapCopyrightInformation

@synthesize _mapView;

- (nonnull NSObject<BMFMapViewHandler> *)initWith:(nonnull BMFMapView *)mapView {
    _mapView = mapView;
    return self;
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
    
    if ([call.method isEqualToString:kBMFMapGetMapCopyrightInformationMethod]) {
        result(@{@"copyrightInformation": BMKGetMapCopyrightInformation()});
    } else if ([call.method isEqualToString:kBMFMapGetMapMappingQualificationMethod]) {
        result(@{@"mappingQualification": BMKGetMapMappingQualification()});
    } else if ([call.method isEqualToString:kBMFMapGetMapApprovalNumberMethod]) {
        result(@{@"approvalNumber": BMKGetMapApprovalNumber()});
    } else {
        result(@NO);
    }
}
@end
#pragma mark - 粒子效果
@implementation BMFMapShowParticleEffect

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
    BMKMapParticleEffect effect = [[call.arguments safeObjectForKey:@"effect"] intValue];
    BOOL flag = [_mapView showParticleEffect:effect];
    result([NSNumber numberWithBool:flag]);
}

@end

@implementation BMFMapCloseParticleEffect

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
    BMKMapParticleEffect effect = [[call.arguments safeObjectForKey:@"effect"] intValue];
    [_mapView closeParticleEffect:effect];
    result(@YES);
}

@end

@implementation BMFMapCustomParticleEffect

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
    BMKMapParticleEffect effect = [[call.arguments safeObjectForKey:@"effect"] intValue];
    BMFParticleEffectModel *model = [BMFParticleEffectModel bmf_modelWith:[call.arguments safeObjectForKey:@"option"]];

    BOOL flag = [_mapView customParticleEffect:effect option:[model toEffecyOption]];
    result([NSNumber numberWithBool:flag]);
}

@end


