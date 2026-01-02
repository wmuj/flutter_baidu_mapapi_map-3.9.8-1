#ifndef __BMFMapCallBackConst__M__
#define __BMFMapCallBackConst__M__

#import <Foundation/Foundation.h>

// invoke
NSString *const kBMFMapDidLoadCallback = @"flutter_bmfmap/map/mapViewDidFinishLoad";
NSString *const kBMFMapDidRenderCallback = @"flutter_bmfmap/map/mapViewDidFinishRender";
NSString *const kBMFMapOnDrawMapFrameCallback = @"flutter_bmfmap/map/mapViewOnDrawMapFrame";
NSString *const kBMFMapDidRenderValidDataCallback = @"flutter_bmfmap/map/mapRenderValidDataCallback";

NSString *const kBMFMapRegionWillChangeCallback = @"flutter_bmfmap/map/mapViewRegionWillChange";
NSString *const kBMFMapRegionWillChangeWithReasonCallback = @"flutter_bmfmap/map/mapViewRegionWillChangeWithReason";
NSString *const kBMFMapRegionDidChangeCallback = @"flutter_bmfmap/map/mapViewRegionDidChange";
NSString *const kBMFMapRegionDidChangeWithReasonCallback = @"flutter_bmfmap/map/mapViewRegionDidChangeWithReason";

NSString *const kBMFMapOnClickedMapPoiCallback = @"flutter_bmfmap/map/mapViewonClickedMapPoi";
NSString *const kBMFMapOnClickedMapBlankCallback = @"flutter_bmfmap/map/mapViewOnClickedMapBlank";
NSString *const kBMFMapOnDoubleClickCallback = @"flutter_bmfmap/map/mapViewOnDoubleClick";
NSString *const kBMFMapOnLongClickCallback = @"flutter_bmfmap/map/mapViewOnLongClick";
NSString *const kBMFMapOnForceTouchCallback = @"flutter_bmfmap/map/mapViewOnForceTouch";

NSString *const kBMFMapStatusDidChangedCallback = @"flutter_bmfmap/map/mapViewStatusDidChanged";

NSString *const kBMFMapInOrOutBaseIndoorMapCallback = @"flutter_bmfmap/map/mapViewInOrOutBaseIndoorMap";

// marker
NSString *const kBMFMapClickedMarkerCallback = @"flutter_bmfmap/marker/clickedMarker";
NSString *const kBMFMapDidSelectMarkerCallback = @"flutter_bmfmap/marker/didSelectedMarker";
NSString *const kBMFMapDidDeselectMarkerCallback = @"flutter_bmfmap/marker/didDeselectMarker";
NSString *const kBMFMapDidClickedPaoPaoCallback = @"flutter_bmfmap/map/didClickedInfoWindow";
NSString *const kBMFMapDidDragMarkerCallback = @"flutter_bmfmap/marker/dragMarker";

// cluster
NSString *const kBMFMapClickClusterItemCallback = @"flutter_bmfmap/cluster/clickClusterItem";

// overlay
NSString *const kBMFMapDidAddOverlayCallback = @"flutter_bmfmap/overlay/didAddOverlay";
NSString *const kMapOnClickedOverlayCallback = @"flutter_bmfmap/overlay/onClickedOverlay";
NSString *const kMapOnClickedMultiPointOverlayItemCallback = @"flutter_bmfmap/overlay/onClickedMultiPointOverlayItem";
NSString *const kTraceOverlayAnimationDidStartCallback = @"flutter_bmfmap/overlay/traceOverlayAnimationDidStart";
NSString *const kTraceOverlayAnimationRunningProgressCallback = @"flutter_bmfmap/overlay/traceOverlayAnimationRunningProgress";
NSString *const kTraceOverlayAnimationDidEndCallback = @"flutter_bmfmap/overlay/traceOverlayAnimationDidEnd";
NSString *const kPrismOverlayViewFloorAnimationDidEndCallback = @"flutter_bmfmap/overlay/prismOverlayViewFloorAnimationDidEnd";
#endif
