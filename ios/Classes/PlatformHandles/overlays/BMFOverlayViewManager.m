//
//  BMFOverlayViewManager.m
//  flutter_baidu_mapapi_map
//
//  Created by Zhang,Baojin on 2020/11/12.
//

#import "BMFOverlayViewManager.h"

#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
//#import <flutter_baidu_mapapi_base/NSObject+BMFThread.h>

#import "BMFMapCallBackConst.h"
#import "BMFFileManager.h"
#import "BMFPolyline.h"
#import "BMFArcline.h"
#import "BMFCircle.h"
#import "BMFPolygon.h"
#import "BMFGeodesicLine.h"
#import "BMFGradientLine.h"
#import "BMFPrismOverlay.h"
#import "BMF3DModelOverlay.h"
#import "BMFMultiPointOverlay.h"
#import "BMFTraceOverlay.h"
#import "BMFText.h"
#import "BMFGroundOverlay.h"
#import "BMFTextMarker.h"
#import "BMFIconMarker.h"

@interface BMFOverlayViewManager ()<BMKMultiPointOverlayViewDelegate, BMKTraceOverlayAnimationDelegate, BMKPrismOverlayViewDelegate>

@end

@implementation BMFOverlayViewManager

static  BMFOverlayViewManager *_instance = nil;
+ (instancetype)defalutCenter {
    return [[BMFOverlayViewManager alloc] init];
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

#pragma mark - model

+ (nullable BMFPolylineModel *)polylineModelWith:(BMKPolylineView *)view {
    return (BMFPolylineModel *)view.polyline.flutterModel;
}

+ (nullable BMFTextModel *)textModelWith:(BMKTextView *)view {
    return (BMFTextModel *)view.text.flutterModel;
}

+ (nullable BMFCircleModel *)circleModelWith:(BMKCircleView *)view {
    return (BMFCircleModel *)view.circle.flutterModel;
}

+ (nullable BMFGradientLineModel *)gradientLineModelWith:(BMKGradientLineView *)view {
    return (BMFGradientLineModel *)view.gradientLine.flutterModel;
}

+ (nullable BMFPolygonModel *)polygonModelWith:(BMKPolygonView *)view {
    return (BMFPolygonModel *)view.polygon.flutterModel;
}

+ (nullable BMFGroundModel *)groundModelWith:(BMKGroundOverlayView *)view {
    return (BMFGroundModel *)view.groundOverlay.flutterModel;
}

+ (nullable BMFMultiPointOverlayModel *)multiPointOverlayModelWith:(BMKMultiPointOverlayView *)view {
    return (BMFMultiPointOverlayModel *)view.multiPointOverlay.flutterModel;
}

+ (nullable BMFTextMarkerModel *)textMarkerModelWith:(BMKTextMarkerView *)view {
    return (BMFTextMarkerModel *)(((BMKTextMarker *)view.marker).flutterModel);
}

+ (nullable BMFIconMarkerModel *)iconMarkerModelWith:(BMKIconMarkerView *)view {
    return (BMFIconMarkerModel *)(((BMKIconMarker *)view.marker).flutterModel);
}

#pragma mark -view
+ (BMKMultiColorPolylineView *)multiColorPolylineViewForMultiPolyline:(BMKMultiPolyline *)multiPolyline {
    BMFPolylineModel *model = (BMFPolylineModel *)multiPolyline.flutterModel;
    BMKMultiColorPolylineView *view = [[BMKMultiColorPolylineView alloc] initWithMultiPolyline:multiPolyline];
    
    view.lineWidth = model.width;
    view.lineDashType = model.lineDashType;
    view.lineCapType = model.lineCapType;
    view.lineJoinType = model.lineJoinType;
    view.isClickable = model.clickable;
    
    if (multiPolyline.lineType == kBMFColorsLine) {
        view.lineBloomMode = model.lineBloomMode;
        view.lineBloomAlpha = model.lineBloomAlpha;
        view.lineBloomWidth = model.lineBloomWidth;
        view.lineBloomGradientASPeed = model.lineBloomGradientASPeed;
        view.lineBloomBlurTimes = model.lineBloomBlurTimes;
    }
    
    if (multiPolyline.lineType == kBMFColorsLine || multiPolyline.lineType == kBMFMultiDashLine) {
        size_t colorsCount = model.colors.count;
        NSMutableArray<UIColor *> *colors = [NSMutableArray array];
        for (size_t i = 0; i < colorsCount; i++) {
            // TODO: colors加入空值判断
            [colors addObject:[UIColor fromColorString:model.colors[i]]];
        }
        view.strokeColors = colors;
    }

    return view;
}

+ (BMKMultiTexturePolylineView *)multiTexturePolylineViewForMultiPolyline:(BMKMultiPolyline *)multiPolyline {
    BMFPolylineModel *model = (BMFPolylineModel *)multiPolyline.flutterModel;
    BMKMultiTexturePolylineView *view = [[BMKMultiTexturePolylineView alloc] initWithMultiPolyline:multiPolyline];
    
    view.lineWidth = model.width;
    view.lineCapType = model.lineCapType;
    view.lineJoinType = model.lineJoinType;
    view.isClickable = model.clickable;
    
    if (multiPolyline.lineType == kBMFTexturesLine) {
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        size_t imagesCount = model.textures.count;
        NSString *imagePath = nil;
        for (size_t i = 0; i < imagesCount; i++) {
            imagePath = model.textures[i];
            UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:imagePath]];
            [images addObject:image];
        }
        view.textureImages = images;
    }

    return view;
}

+ (BMKPolylineView *)viewForPolyline:(BMKPolyline *)polyline {
    if ([polyline isKindOfClass:[BMKMultiPolyline class]]) {
        if (polyline.lineType == kBMFColorsLine || polyline.lineType == kBMFMultiDashLine) {
            return [BMFOverlayViewManager multiColorPolylineViewForMultiPolyline:(BMKMultiPolyline *)polyline];
        } else if (polyline.lineType == kBMFTexturesLine) {
            return [BMFOverlayViewManager multiTexturePolylineViewForMultiPolyline:(BMKMultiPolyline *)polyline];
        }
    }

    BMFPolylineModel *model = (BMFPolylineModel *)polyline.flutterModel;
    BMKPolylineView *view = [[BMKPolylineView alloc] initWithPolyline:polyline];
    view.lineWidth = model.width;
    view.lineDashType = model.lineDashType;
    view.lineCapType = model.lineCapType;
    view.lineJoinType = model.lineJoinType;
    view.isClickable = model.clickable;
    view.lineBloomMode = model.lineBloomMode;
    view.lineBloomAlpha = model.lineBloomAlpha;
    view.lineBloomWidth = model.lineBloomWidth;
    view.lineBloomGradientASPeed = model.lineBloomGradientASPeed;
    view.lineBloomBlurTimes = model.lineBloomBlurTimes;
    
    if (polyline.lineType == kBMFDashLine || polyline.lineType == kBMFColorLine) {
        if ([model.colors firstObject]) {
            view.strokeColor = [UIColor fromColorString:[model.colors firstObject]];
        } else {
            // TODO: strokeColor 默认值
//            view.strokeColor =  [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
        }
    } else if (polyline.lineType == kBMFTextureLine) {
        NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:[model.textures firstObject]];
        view.textureImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return view;
}

+ (BMKArclineView *)viewForArcline:(BMKArcline *)arcline {
    BMFArclineModel *model = (BMFArclineModel *)arcline.flutterModel;
    BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:arcline];
    if (model.color) {
        arclineView.strokeColor = [UIColor fromColorString:model.color];
    } else {
        arclineView.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    arclineView.lineWidth = model.width;
    arclineView.lineDashType = model.lineDashType;
    return arclineView;
}

+ (BMKPolygonView *)viewForPolygon:(BMKPolygon *)polygon {
    BMFPolygonModel *model = (BMFPolygonModel *)polygon.flutterModel;
    BMKPolygonView *view = [[BMKPolygonView alloc] initWithPolygon:polygon];
    if (model.strokeColor) {
        view.strokeColor = [UIColor fromColorString:model.strokeColor];
    } else {
        view.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.fillColor) {
        view.fillColor = [UIColor fromColorString:model.fillColor];
    }
    view.lineWidth = model.width;
    view.lineDashType = model.lineDashType;
    view.isClickable = model.clickable;
    return view;
}

+ (BMKCircleView *)viewForCircleline:(BMKCircle *)circle {
    BMFCircleModel *model = (BMFCircleModel *)circle.flutterModel;
    
    BMKCircleView *view = [[BMKCircleView alloc] initWithCircle:circle];
    if (model.strokeColor) {
        view.strokeColor = [UIColor fromColorString:model.strokeColor];
    } else {
        view.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.fillColor) {
        view.fillColor = [UIColor fromColorString:model.fillColor];
    }
    view.lineWidth    = model.width;
    view.lineDashType = model.lineDashType;
    view.isClickable  = model.clickable;
    return view;
}

+ (BMKGradientCircleView *)viewForGradientCircle:(BMKCircle *)circle {
    BMFCircleModel *model = (BMFCircleModel *)circle.flutterModel;
    
    BMKGradientCircleView *view = [[BMKGradientCircleView alloc] initWithCircle:circle];
    if (model.strokeColor) {
        view.strokeColor = [UIColor fromColorString:model.strokeColor];
    } else {
        view.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }

    view.lineWidth    = model.width;
    view.lineDashType = model.lineDashType;
    view.centerColor  = [UIColor fromColorString:model.centerColor];
    view.sideColor    = [UIColor fromColorString:model.sideColor];
    view.radiusWeight = model.radiusWeight;
    view.colorWeight  = model.colorWeight;
    return view;
}

+ (BMKGeodesicLineView *)viewForGeodesicLine:(BMKGeodesicLine *)geodesicline {
    BMFGeodesicLineModel *model = (BMFGeodesicLineModel *)geodesicline.flutterModel;
    BMKGeodesicLineView *view = [[BMKGeodesicLineView alloc] initWithGeodesicLine:geodesicline];
    if (model.strokeColor) {
        view.strokeColor = [UIColor fromColorString:model.strokeColor];
    } else {
        view.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.textureImage) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:model.textureImage]];
        view.textureImage = image;
    }
    view.lineWidth = model.width;
    view.lineDashType = model.lineDashType;

    return view;
}

+ (BMKGradientLineView *)viewForGradientLine:(BMKGradientLine *)gradientLine {
    BMFGradientLineModel *model = (BMFGradientLineModel *)gradientLine.flutterModel;
    BMKGradientLineView *view = [[BMKGradientLineView alloc] initWithGradientLine:gradientLine];
    if (model.colors) {
        size_t colorsCount = model.colors.count;
        NSMutableArray<UIColor *> *colors = [NSMutableArray array];
        for (size_t i = 0; i < colorsCount; i++) {
            [colors addObject:[UIColor fromColorString:model.colors[i]]];
        }
        view.strokeColors = colors;
    }
    view.lineWidth = model.width;
    view.isClickable = model.clickable;
    return view;
}

+ (BMKPrismOverlayView *)viewForPrismOverlay:(BMKPrismOverlay *)prismOverlay {
    BMFPrismOverlayModel *model =(BMFPrismOverlayModel *)prismOverlay.flutterModel;
    BMKPrismOverlayView *view = [[BMKPrismOverlayView alloc] initWithPrismOverlay:prismOverlay];
    view.delegate = [BMFOverlayViewManager defalutCenter];
    if (model.sideFaceColor) {
        view.sideFaceColor = [UIColor fromColorString:model.sideFaceColor];
    } else {
        view.sideFaceColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.topFaceColor) {
        view.topFaceColor = [UIColor fromColorString:model.topFaceColor];
    } else {
        view.topFaceColor= [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.sideFacTexture) {
        NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:model.sideFacTexture];
        view.sideTextureImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    if (model.floorColor) {
        view.floorColor = [UIColor fromColorString:model.floorColor];
    } else {
        view.floorColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.floorSideTextureImage) {
        NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:model.floorSideTextureImage];
        view.floorSideTextureImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    view.isGrowthAnimation = model.isGrowthAnimation;
    if (model.showLevel > 0) {
        view.showLevel = model.showLevel;
    }
    return view;
}

+ (BMKMultiPointOverlayView *)viewForMultiPointOverlay:(BMKMultiPointOverlay *)multiPointOverlay {
    BMFMultiPointOverlayModel *model = (BMFMultiPointOverlayModel *)multiPointOverlay.flutterModel;
    BMKMultiPointOverlayView *view = [[BMKMultiPointOverlayView alloc] initWithMultiPointOverlay:multiPointOverlay];
    if (model.icon) {
        NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:model.icon];
        view.icon = [UIImage imageWithContentsOfFile:imagePath];
    }
    if (model.pointSize) {
        view.pointSize = CGSizeMake(model.pointSize.width, model.pointSize.height);
    }
    if (model.anchor) {
        view.anchor = CGPointMake(model.anchor.x, model.anchor.y);
    }
    return view;
}

+ (BMKTraceOverlayView *)viewForTraceOverlay:(BMKTraceOverlay *)traceOverlay {
    BMFTraceOverlayModel *model = (BMFTraceOverlayModel *)traceOverlay.flutterModel;
    BMKTraceOverlayView *view = [[BMKTraceOverlayView alloc] initWithTraceOverlay:traceOverlay];
    if (model.strokeColor) {
        view.strokeColor = [UIColor fromColorString:model.strokeColor];
    } else {
        view.strokeColor = [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:1.f];
    }
    if (model.fillColor) {
        view.fillColor = [UIColor fromColorString:model.fillColor];
    }
    if (model.strokeColors && model.strokeColors.count > 0) {
        NSMutableArray *tempColors = [NSMutableArray arrayWithCapacity:model.strokeColors.count];
        for (NSString *color in model.strokeColors) {
            [tempColors addObject:[UIColor fromColorString:color]];
        }
        view.strokeColors = [tempColors copy];
    }
    view.lineWidth = model.width;
    return view;
}

+ (BMKGroundOverlayView *)viewForGround:(BMKGroundOverlay *)groundOverlay {
    BMFGroundModel *model = (BMFGroundModel *)groundOverlay.flutterModel;
    BMKGroundOverlayView *view = [[BMKGroundOverlayView alloc] initWithGroundOverlay:groundOverlay];
    view.isClickable = model.clickable;
    return view;
}

+ (BMKTextView *)viewForText:(BMKText *)textOverlay {
    BMFTextModel *model = (BMFTextModel *)textOverlay.flutterModel;
    BMKTextView *view = [[BMKTextView alloc] initWithTextOverlay:textOverlay];
    if (model.bgColor) {
        view.backgroundColor    = [UIColor fromColorString:model.bgColor];
    }
    if (model.fontColor) {
        view.textColor          = [UIColor fromColorString:model.fontColor];
    }
    view.fontSize               = model.fontSize;
    view.textFontType           = model.typeFace.textStype;
    view.textParagraphSpacing   = model.paragraphSpacing;
    view.textMaxLineWidth       = model.maxLineWidth;
    view.textLineSpacing        = model.lineSpacing;
    view.textAlignment          = model.alignment;
    view.textLineBreakMode      = model.lineBreakMode;
    view.startLevel             = model.startLevel;
    view.endLevel               = model.endLevel;
    view.rotate                 = model.rotate;
    return view;
}


+ (BMKTextMarkerView *)viewForTextMarker:(BMKTextMarker *)textMarker {
    BMFTextMarkerModel *model = (BMFTextMarkerModel *)textMarker.flutterModel;
    BMKTextMarkerView *view = [[BMKTextMarkerView alloc] initWithMarker:textMarker];
    view.isClickable = model.isClickable;
    view.draggable = model.draggable;
    return view;
}

+ (BMKIconMarkerView *)viewForIconMarker:(BMKIconMarker *)iconMarker {
    BMFIconMarkerModel *model = (BMFIconMarkerModel *)iconMarker.flutterModel;
    BMKIconMarkerView *view = [[BMKIconMarkerView alloc] initWithMarker:iconMarker];
    view.isClickable = model.isClickable;
    view.draggable = model.draggable;
    return view;
}

+ (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKGeodesicLine class]]) {
        return [BMFOverlayViewManager viewForGeodesicLine:(BMKGeodesicLine *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKGradientLine class]]) {
        return [BMFOverlayViewManager viewForGradientLine:(BMKGradientLine *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKPolyline class]]) {
        return [BMFOverlayViewManager viewForPolyline:(BMKPolyline *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKArcline class]]) {
        return [BMFOverlayViewManager viewForArcline:(BMKArcline *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKPolygon class]]) {
        return [BMFOverlayViewManager viewForPolygon:(BMKPolygon *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircle *circle = (BMKCircle *)overlay;
        if (circle.isGradientCircle) {
            return [BMFOverlayViewManager viewForGradientCircle:(BMKCircle *)overlay];
        } else {
            return [BMFOverlayViewManager viewForCircleline:(BMKCircle *)overlay];
        }
    }
    else if ([overlay isKindOfClass:[BMKPrismOverlay class]]) {
        return [BMFOverlayViewManager viewForPrismOverlay:(BMKPrismOverlay *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKMultiPointOverlay class]]) {
        BMKMultiPointOverlayView *view = [BMFOverlayViewManager viewForMultiPointOverlay:(BMKMultiPointOverlay *)overlay];
        view.delegate = [BMFOverlayViewManager defalutCenter];
        return view;
    }
    else if ([overlay isKindOfClass:[BMKTraceOverlay class]]) {
        BMKTraceOverlay *traceOverlay = (BMKTraceOverlay *)overlay;
        traceOverlay.delegate = [BMFOverlayViewManager defalutCenter];
        return [BMFOverlayViewManager viewForTraceOverlay:(BMKTraceOverlay *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKTileLayer class]]) {
        return [[BMKTileLayerView alloc] initWithOverlay:overlay];
    }
    else if ([overlay isKindOfClass:[BMKGroundOverlay class]]) {
        return [BMFOverlayViewManager viewForGround:(BMKGroundOverlay *)overlay];
    }
    else if ([overlay isKindOfClass:[BMK3DModelOverlay class]]) {
        return [[BMK3DModelOverlayView alloc] initWithOverlay:overlay];
    }
    else if ([overlay isKindOfClass:[BMKText class]]) {
        return [BMFOverlayViewManager viewForText:(BMKText *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKTextMarker class]]) {
        return [BMFOverlayViewManager viewForTextMarker:(BMKTextMarker *)overlay];
    }
    else if ([overlay isKindOfClass:[BMKIconMarker class]]) {
        return [BMFOverlayViewManager viewForIconMarker:(BMKIconMarker *)overlay];
    }

    
    return nil;
}


#pragma mark - BMKMultiPointOverlayViewDelegate

- (void)multiPointOverlayView:(BMKMultiPointOverlayView *)multiPointOverlayView didItemTapped:(BMKMultiPointItem *)item {
    if (!_channel) return;
    BMFMultiPointOverlayModel *model = [BMFOverlayViewManager multiPointOverlayModelWith:multiPointOverlayView];
    BMFMultiPointItem *itemModel = [BMFMultiPointItem fromBMKMultiPointItem:item];
    if (!model || !itemModel) {return;}
    [_channel invokeMethod:kMapOnClickedMultiPointOverlayItemCallback
                 arguments:@{
        @"multiPointOverlay": [model bmf_toDictionary],
        @"item":[itemModel bmf_toDictionary]}
                    result:nil];
}


#pragma mark - BMKTraceOverlayAnimationDelegate
- (void)traceOverlayAnimationDidStart:(BMKTraceOverlay *)traceOverlay {
    if (!_channel) return;
    BMFTraceOverlayModel *model = (BMFTraceOverlayModel *)traceOverlay.flutterModel;
    if (!model) {return;}
    [_channel invokeMethod:kTraceOverlayAnimationDidStartCallback
                 arguments:@{@"traceOverlay": [model bmf_toDictionary]}
                    result:nil];
}

- (void)traceOverlay:(BMKTraceOverlay *)traceOverlay animationRunningProgress:(CGFloat)progress {
    if (!_channel) return;
    BMFTraceOverlayModel *model = (BMFTraceOverlayModel *)traceOverlay.flutterModel;
    if (!model) {return;}
    [_channel invokeMethod:kTraceOverlayAnimationRunningProgressCallback
                 arguments:@{
        @"traceOverlay": [model bmf_toDictionary],
        @"progress":@(progress)}
                    result:nil];
}

- (void)traceOverlay:(BMKTraceOverlay *)traceOverlay animationDidEnd:(BOOL)flag {
    if (!_channel) return;
    BMFTraceOverlayModel *model = (BMFTraceOverlayModel *)traceOverlay.flutterModel;
    if (!model) {return;}
    [_channel invokeMethod:kTraceOverlayAnimationDidEndCallback
                 arguments:@{
        @"traceOverlay": [model bmf_toDictionary],
        @"flag": @(flag)}
                    result:nil];
}

#pragma mark - BMKPrismOverlayViewDelegate
- (void)prismOverlayViewFloorAnimationDidEnd:(BMKPrismOverlayView *)prismOverlayView {
    if (!_channel) return;
    BMFPrismOverlayModel *model = (BMFPrismOverlayModel *)prismOverlayView.prismOverlay.flutterModel;
    if (!model) {return;}
    [_channel invokeMethod:kPrismOverlayViewFloorAnimationDidEndCallback
                 arguments:@{@"prismOverlay": [model bmf_toDictionary]}
                    result:nil];
}

@end
