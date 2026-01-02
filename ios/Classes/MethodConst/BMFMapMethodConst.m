
#ifndef __BMFMapMethodConst__M__
#define __BMFMapMethodConst__M__

#import <Foundation/Foundation.h>

// get
NSString *const kBMFMapGetMapTypeMethod = @"flutter_bmfmap/map/getMapType";
NSString *const kBMFMapGetMapLanguageTypeMethod = @"flutter_bmfmap/map/getMapLanguageType";
NSString *const kBMFMapGetMapBackgroundColorMethod = @"flutter_bmfmap/map/getMapBackgroundColor";
NSString *const kBMFMapGetFontSizeLevelMethod = @"flutter_bmfmap/map/getMapFontSizeLevel";
NSString *const kBMFMapGetZoomLevelMethod = @"flutter_bmfmap/map/getZoomLevel";
NSString *const kBMFMapGetMinZoomLevelMethod = @"flutter_bmfmap/map/getMinZoomLevel";
NSString *const kBMFMapGetMaxZoomLevelMethod = @"flutter_bmfmap/map/getMaxZoomLevel";
NSString *const kBMFMapGetRotationMethod = @"flutter_bmfmap/map/getRotation";
NSString *const kBMFMapGetOverlookingMethod = @"flutter_bmfmap/map/getOverlooking";
NSString *const kBMFMapGetMinOverlookingMethod = @"flutter_bmfmap/map/getMinOverlooking";
NSString *const kBMFMapGetBuildingsEnabledMethod = @"flutter_bmfmap/map/getBuildingsEnabled";
NSString *const kBMFMapGetShowMapPoiMethod = @"flutter_bmfmap/map/getShowMapPoi";
NSString *const kBMFMapGetTrafficEnabledMethod = @"flutter_bmfmap/map/getTrafficEnabled";
NSString *const kBMFMapGetBaiduHeatMapEnabledMethod = @"flutter_bmfmap/map/getBaiduHeatMapEnabled";
NSString *const kBMFMapGetGesturesEnabledMethod = @"flutter_bmfmap/map/getGesturesEnabled";
NSString *const kBMFMapGetZoomEnabledMethod = @"flutter_bmfmap/map/getZoomEnabled";
NSString *const kBMFMapGetZoomEnabledWithTapMethod = @"flutter_bmfmap/map/getZoomEnabledWithTap";
NSString *const kBMFMapGetScrollEnabledMethod = @"flutter_bmfmap/map/getScrollEnabled";
NSString *const kBMFMapGetOverlookEnabledMethod = @"flutter_bmfmap/map/getOverlookEnabled";
NSString *const kBMFMapGetRotateEnabledMethod = @"flutter_bmfmap/map/getRotateEnabled";
NSString *const kBMFMapGetForceTouchEnabledMethod = @"flutter_bmfmap/map/getForceTouchEnabled";
NSString *const kBMFMapGetShowMapScaleBarMethod = @"flutter_bmfmap/map/getShowMapScaleBar";
NSString *const kBMFMapGetMapScaleBarPositionMethod = @"flutter_bmfmap/map/getMapScaleBarPosition";
NSString *const kBMFMapGetLogoPositionMethod = @"flutter_bmfmap/map/getLogoPosition";
NSString *const kBMFMapGetVisibleMapBoundsMethod = @"flutter_bmfmap/map/getVisibleMapBounds";
NSString *const kBMFMapGetBaseIndoorMapEnabledMethod = @"flutter_bmfmap/map/getBaseIndoorMapEnabled";
NSString *const kBMFMapGetShowIndoorMapPoiMethod = @"flutter_bmfmap/map/getShowIndoorMapPoi";
NSString *const kBMFMapGetShowOperateLayerMethod = @"flutter_bmfmap/map/getShowOperateLayer";
NSString *const kBMFMapGetMapCopyrightInformationMethod = @"flutter_bmfmap/map/getMapCopyrightInformation";
NSString *const kBMFMapGetMapMappingQualificationMethod = @"flutter_bmfmap/map/getMapMappingQualification";
NSString *const kBMFMapGetMapApprovalNumberMethod = @"flutter_bmfmap/map/getMapApprovalNumber";

// set
NSString *const kBMFMapUpdateMethod = @"flutter_bmfmap/map/updateMapOptions";
NSString *const kBMFMapZoomInMethod = @"flutter_bmfmap/map/zoomIn";
NSString *const kBMFMapZoomOutMethod = @"flutter_bmfmap/map/zoomOut";
NSString *const kBMFMapSetCustomTrafficColorMethod = @"flutter_bmfmap/map/setCustomTrafficColor";
NSString *const kBMFMapSetCenterCoordinateMethod = @"flutter_bmfmap/map/setCenterCoordinate";
NSString *const kBMFMapTakeSnapshotMethod = @"flutter_bmfmap/map/takeSnapshot";
NSString *const kBMFMapTakeSnapshotWithRectMethod = @"flutter_bmfmap/map/takeSnapshotWithRect";
NSString *const kBMFMapSetCompassImageMethod = @"flutter_bmfmap/map/setCompassImage";
NSString *const kBMFMapSetVisibleMapBoundsMethod = @"flutter_bmfmap/map/setVisibleMapBounds";
NSString *const kBMFMapSetVisibleMapBoundsWithPaddingMethod = @"flutter_bmfmap/map/setVisibleMapBoundsWithPadding";
NSString *const kBMFMapFitVisibleMapRectWithPaddingMethod = @"flutter_bmfmap/map/fitVisibleMapRectWithPadding";

NSString *const kBMFMapSetMapStatusMethod = @"flutter_bmfmap/map/setMapStatus";
NSString *const kBMFMapGetMapStatusMethod = @"flutter_bmfmap/map/getMapStatus";
NSString *const kBMFMapSetMapCenterToScreenPtMethod = @"flutter_bmfmap/map/setMapCenterToScreenPt";

// 室内地图
NSString *const kBMFMapShowBaseIndoorMapMethod = @"flutter_bmfmap/map/showBaseIndoorMap";
NSString *const kBMFMapShowBaseIndoorMapPoiMethod = @"flutter_bmfmap/map/showBaseIndoorMapPoi";
NSString *const kBMFMapSwitchBaseIndoorMapFloorMethod = @"flutter_bmfmap/map/switchBaseIndoorMapFloor";
NSString *const kBMFMapGetFocusedBaseIndoorMapInfoMethod = @"flutter_bmfmap/map/getFocusedBaseIndoorMapInfo";

// 个性化地图
NSString *const kBMFMapSetCustomMapStyleEnableMethod = @"flutter_bmfmap/map/setCustomMapStyleEnable";
NSString *const kBMFMapSetCustomMapStylePathMethod = @"flutter_bmfmap/map/setCustomMapStylePath";
NSString *const kBMFMapSetCustomMapStyleWithOptionMethod = @"flutter_bmfmap/map/setCustomMapStyleWithOption";

// layer
NSString *const kBMFMapSwitchOverlayLayerAndPOILayerMethod = @"flutter_bmfmap/map/switchOverlayLayerAndPOILayer";
NSString *const kBMFMapPoiTagEnableAndPoiTagTypeMethod = @"flutter_bmfmap/map/poiTagTypeEnableAndPoiTagType";
NSString *const kBMFMapSwitchLayerOrderMethod = @"flutter_bmfmap/map/switchLayerOrder";

// 粒子效果
NSString *const kBMFMapShowMapParticleEffectMethod = @"flutter_bmfmap/map/showMapParticleEffectMethod";
NSString *const kBMFMapCloseMapParticleEffectMethod = @"flutter_bmfmap/map/closeMapParticleEffectMethod";
NSString *const kBMFMapCustomMapParticleEffectMethod = @"flutter_bmfmap/map/customMapParticleEffectMethod";


#endif
