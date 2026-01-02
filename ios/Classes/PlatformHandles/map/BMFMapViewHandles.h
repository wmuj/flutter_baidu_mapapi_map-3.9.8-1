//
//  BMFMapViewHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import "BMFMapViewHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface BMFMapViewHandles : NSObject

/// BMFMapViewHandler管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)mapViewHandles;

@end

#pragma mark - map

@interface BMFUpdateMap : NSObject<BMFMapViewHandler>

@end

@interface BMFShowBaseIndoorMap : NSObject<BMFMapViewHandler>

@end

@interface BMFShowBaseIndoorMapPoi : NSObject<BMFMapViewHandler>

@end

@interface BMFSwitchBaseIndoorMapFloor : NSObject<BMFMapViewHandler>

@end

@interface BMFGetFocusedBaseIndoorMapInfo : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCustomMapStyleEnable : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCustomMapStylePath : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCustomMapStyleWithOption : NSObject<BMFMapViewHandler>

@end

@interface BMFZoomIn : NSObject<BMFMapViewHandler>

@end

@interface BMFZoomOut : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCustomTrafficColor : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCenterCoordinate : NSObject<BMFMapViewHandler>

@end

@interface BMFTakeSnapshot : NSObject<BMFMapViewHandler>

@end

@interface BMFTakeSnapshotWithRect : NSObject<BMFMapViewHandler>

@end

@interface BMFSetCompassImage : NSObject<BMFMapViewHandler>

@end

@interface BMFSetVisibleMapBounds : NSObject<BMFMapViewHandler>

@end

@interface BMFFitVisibleMapRectWithPadding : NSObject<BMFMapViewHandler>

@end

@interface BMFSetVisibleMapBoundsWithPadding : NSObject<BMFMapViewHandler>

@end

@interface BMFSetMapStatus : NSObject<BMFMapViewHandler>

@end

@interface BMFSetMapCenterToScreenPt : NSObject<BMFMapViewHandler>

@end

#pragma mark - Get

@interface BMFGetMapStatus : NSObject<BMFMapViewHandler>

@end

@interface BMFGetMapType : NSObject<BMFMapViewHandler>

@end

@interface BMFGetLanguageType : NSObject<BMFMapViewHandler>

@end

@interface BMFGetBackgroundColor : NSObject<BMFMapViewHandler>

@end

@interface BMFGetFointSizeLevel : NSObject<BMFMapViewHandler>

@end

@interface BMFGetZoomLevel : NSObject<BMFMapViewHandler>

@end

@interface BMFGetMinZoomLevel : NSObject<BMFMapViewHandler>

@end

@interface BMFGetMaxZoomLevel : NSObject<BMFMapViewHandler>

@end

@interface BMFGetRotation : NSObject<BMFMapViewHandler>

@end

@interface BMFGetOverlooking : NSObject<BMFMapViewHandler>

@end


@interface BMFGetMinOverlooking : NSObject<BMFMapViewHandler>

@end

@interface BMFGetBuildingsEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetShowMapPoi : NSObject<BMFMapViewHandler>

@end

@interface BMFGetTrafficEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetBaiduHeatMapEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetGesturesEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetZoomEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetZoomEnabledWithTap : NSObject<BMFMapViewHandler>

@end

@interface BMFGetScrollEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetOverlookEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetRotateEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetForceTouchEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetShowMapScaleBar : NSObject<BMFMapViewHandler>

@end

@interface BMFGetMapScaleBarPosition : NSObject<BMFMapViewHandler>

@end

@interface BMFGetLogoPosition : NSObject<BMFMapViewHandler>

@end

@interface BMFGetVisibleMapBounds : NSObject<BMFMapViewHandler>

@end

@interface BMFGetBaseIndoorMapEnabled : NSObject<BMFMapViewHandler>

@end

@interface BMFGetShowIndoorMapPoi : NSObject<BMFMapViewHandler>

@end

@interface BMFGetShowOperateLayer : NSObject<BMFMapViewHandler>

@end

#pragma mark - Layer

@interface BMFSwitchOverlayLayerAndPOILayer : NSObject<BMFMapViewHandler>

@end

@interface BMFMapPoiTagEnableAndPoiTagType : NSObject<BMFMapViewHandler>

@end

@interface BMFMapCopyrightInformation : NSObject<BMFMapViewHandler>

@end

@interface BMFSwitchLayerOrder : NSObject<BMFMapViewHandler>

@end

#pragma mark - 粒子效果

@interface BMFMapShowParticleEffect : NSObject<BMFMapViewHandler>

@end

@interface BMFMapCloseParticleEffect : NSObject<BMFMapViewHandler>

@end

@interface BMFMapCustomParticleEffect : NSObject<BMFMapViewHandler>

@end

NS_ASSUME_NONNULL_END
