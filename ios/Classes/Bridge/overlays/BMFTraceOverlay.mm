//
//  BMFTraceOverlay.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFTraceOverlay.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *traceOverlayModelKey = &traceOverlayModelKey;

@implementation BMKTraceOverlay (BMFTraceOverlay)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
    
    BMFTraceOverlayModel *model = [BMFTraceOverlayModel bmf_modelWith:dic];
    if (model.coordinates.count <= 1) return nil;
    
    size_t _coordsCount = model.coordinates.count;
    CLLocationCoordinate2D *coords = new CLLocationCoordinate2D[_coordsCount];
    for (size_t i = 0; i < _coordsCount; i++) {
        coords[i] = [model.coordinates[i] toCLLocationCoordinate2D];
    }
    
    BMKTraceOverlay *traceOverlay = [BMKTraceOverlay traceOverlayWithCoordinates:coords count:_coordsCount option:[model.traceOverlayAnimateOption toBMKTraceOverlayOption]];
    delete[] coords;
    traceOverlay.isTrackBloom = model.isTrackBloom;
    traceOverlay.isGradientColor = model.isGradientColor;
    traceOverlay.isThined = model.isThined;
    traceOverlay.isCornerSmooth = model.isCornerSmooth;
    traceOverlay.bloomSpeed = model.bloomSpeed;
    traceOverlay.flutterModel = model;
    return traceOverlay;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, traceOverlayModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, traceOverlayModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
