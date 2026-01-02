//
//  BMFOverlayViewManager.h
//  flutter_baidu_mapapi_map
//
//  Created by Zhang,Baojin on 2020/11/12.
//

// overlayView处理中心

#ifndef __BMFOverlayViewManager__H__
#define __BMFOverlayViewManager__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

@class BMFPolylineModel;
@class BMFTextModel;
@class BMFCircleModel;
@class BMFGradientLineModel;
@class BMFPolygonModel;
@class BMFGroundModel;
@class FlutterMethodChannel;
@class BMFTextMarkerModel;
@class BMFIconMarkerModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, BMFOverlayType) {
    kBMFOverlayTypeNone = 0,
    kBMFOverlayTypeText,         ///< text
    kBMFOverlayTypeGround,        ///< ground
    kBMOverlayArcline,            ///<  arc
    kBMFOverlayCircle,            ///< circle
    kBMFOverlayPolyline,          ///< Polyline
    kBMFOverlayPolygon,           ///< polygon
    kBMFOverlayMultiPoint,        ///< MultiPoint
    kBMFOverlayPrism,             ///<3d棱柱
    kBMFOverlay3Dmodel,           ///< 3DModel
    kBMFOverlayGradientLine,      ///<渐变线
    kBMFOverlayTextMarker,         ///<textMarker
    kBMFOverlayIconMarker         ///<iconMarker
};

@interface BMFOverlayViewManager : NSObject

@property (nonatomic, weak) FlutterMethodChannel *channel;

+ (instancetype)defalutCenter;

+ (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay;

+ (nullable BMFPolylineModel *)polylineModelWith:(BMKPolylineView *)view;

+ (nullable BMFTextModel *)textModelWith:(BMKTextView *)view;

+ (nullable BMFCircleModel *)circleModelWith:(BMKCircleView *)view;

+ (nullable BMFGradientLineModel *)gradientLineModelWith:(BMKGradientLineView *)view;

+ (nullable BMFPolygonModel *)polygonModelWith:(BMKPolygonView *)view;

+ (nullable BMFGroundModel *)groundModelWith:(BMKGroundOverlayView *)view;

+ (nullable BMFTextMarkerModel *)textMarkerModelWith:(BMKTextMarkerView *)view;

+ (nullable BMFIconMarkerModel *)iconMarkerModelWith:(BMKIconMarkerView *)view;

@end

NS_ASSUME_NONNULL_END
