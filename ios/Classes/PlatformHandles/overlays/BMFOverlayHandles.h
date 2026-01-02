//
//  BMFOverlayHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/2/12.
//

#import "BMFMapViewHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFOverlayHandles : NSObject
/// BMFOverlayHandler管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)overlayHandles;
@end


#pragma mark - overlay

@interface BMFAddOverlays : NSObject<BMFMapViewHandler>

@end

@interface BMFAddPolyline : NSObject<BMFMapViewHandler>

@end

@interface BMFAddTextMarker : NSObject<BMFMapViewHandler>

@end

@interface BMFAddIconMarker : NSObject<BMFMapViewHandler>

@end

@interface BMFAddArcline : NSObject<BMFMapViewHandler>

@end

@interface BMFAddPolygon : NSObject<BMFMapViewHandler>

@end

@interface BMFAddCircle : NSObject<BMFMapViewHandler>

@end

@interface BMFAddTile : NSObject<BMFMapViewHandler>

@end

@interface BMFAddGround : NSObject<BMFMapViewHandler>

@end

@interface BMFAddGeodesicLine : NSObject<BMFMapViewHandler>

@end

@interface BMFAddGradientLine : NSObject<BMFMapViewHandler>

@end

@interface BMFAddPrismOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFAdd3DModelOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFAddMultiPointOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFAddTraceOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFAddText : NSObject<BMFMapViewHandler>

@end

#pragma mark - get
@interface BMFGetOverlayBounds : NSObject<BMFMapViewHandler>

@end

#pragma mark - remove
@interface BMFRemoveOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFClearOverlay : NSObject<BMFMapViewHandler>

@end

// 兼容android的删除方法
@interface BMFRemoveTraceOverlay : NSObject<BMFMapViewHandler>

@end


@interface BMFRemoveTileOverlay : NSObject<BMFMapViewHandler>

@end

#pragma mark - update
@interface BMFUpdatePolyline : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateArcline : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateCircle : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdatePolygon : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdate3DModelOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateGeodesicLine : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateGradientLine : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdatePrismOverlay : NSObject<BMFMapViewHandler>

@end

@interface BMFUpdateText : NSObject<BMFMapViewHandler>

@end

@interface BMFPauseTraceOverlayDraw : NSObject<BMFMapViewHandler>

@end

@interface BMFResumeTraceOverlayDraw : NSObject<BMFMapViewHandler>

@end

NS_ASSUME_NONNULL_END
