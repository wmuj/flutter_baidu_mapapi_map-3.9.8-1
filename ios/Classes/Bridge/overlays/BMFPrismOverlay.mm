//
//  BMFPrismOverlay.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFPrismOverlay.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *prismOverlayModelKey = &prismOverlayModelKey;

@implementation BMKPrismOverlay (BMFPrismOverlay)

+ (instancetype)forBuildOverlayWith:(BMFPrismOverlayModel *)model {
    BMKPrismOverlay *buildOverlay = [[BMKPrismOverlay alloc] init];
    buildOverlay.buildInfo = [model.buildInfo toBMKBuildInfo];
    buildOverlay.floorHeight = model.floorHeight;
    buildOverlay.flutterModel = model;
    return buildOverlay;
}

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
 
    BMFPrismOverlayModel *model = [BMFPrismOverlayModel bmf_modelWith:dic];
    if (model.buildInfo) {
        return [[self class] forBuildOverlayWith:model];
    }
    
    if (model.coordinates.count <= 2) return nil;
    
    size_t _coordsCount = model.coordinates.count;
    CLLocationCoordinate2D *coords = new CLLocationCoordinate2D[_coordsCount];
    for (size_t i = 0; i < _coordsCount; i++) {
        coords[i] = [model.coordinates[i] toCLLocationCoordinate2D];
    }
    
    BMKPrismOverlay *prismOverlay = [BMKPrismOverlay prismOverlayWithCoordinates:coords count:_coordsCount];
    delete[] coords;
    
    prismOverlay.height = model.height;
    prismOverlay.flutterModel = model;
    return prismOverlay;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, prismOverlayModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, prismOverlayModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

