//
//  BMFPolyline.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/12.
//

#import "BMFPolyline.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *lineTypeKey = &lineTypeKey;
static const void *polylineModelKey = &polylineModelKey;

@implementation BMKPolyline (BMFPolyline)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
    
    BMFPolylineModel *model = [BMFPolylineModel bmf_modelWith:dic];
    if (model.coordinates.count <= 1) return nil;
        
    BMKLineDirectionCross180Type cross180Type = kBMKLineDirectionCross180TypeNone;
    if (model.lineDirectionCross180 == 1) {
        cross180Type = kBMKLineDirectionCross180TypeEAST_TO_WEST;
    } else if (model.lineDirectionCross180 == 2)  {
        cross180Type = kBMKLineDirectionCross180TypeWEST_TO_EAST;
    }
        
    size_t _coordsCount = model.coordinates.count;
    CLLocationCoordinate2D *coords = new CLLocationCoordinate2D[_coordsCount];
    for (size_t i = 0; i < _coordsCount; i++) {
        coords[i] = [model.coordinates[i] toCLLocationCoordinate2D];
    }
    
    size_t _indexsCount = model.indexs.count;
    if (_indexsCount > 0) { // 多
        BMKMultiPolyline *polyline = [BMKMultiPolyline multiPolylineWithCoordinates:coords count:_coordsCount drawIndexs:model.indexs];
        delete[] coords;
        if (model.lineDashType == 0) {
            polyline.lineType = [model.textures count] > 0 ? kBMFTexturesLine :  kBMFColorsLine;
        } else {
            polyline.lineType = kBMFMultiDashLine;
        }
        polyline.isThined = model.isThined;
        polyline.lineDirectionCross180 = cross180Type;
        polyline.flutterModel = model;
        return polyline;
    } else { // 单
        BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coords count:_coordsCount];
        delete[] coords;
        if (model.lineDashType == 0) {
            polyline.lineType = [model.textures count] > 0 ? kBMFTextureLine : kBMFColorLine;
        } else {
            polyline.lineType = kBMFDashLine;
        }
        polyline.isThined = model.isThined;
        polyline.lineDirectionCross180 = cross180Type;
        polyline.flutterModel = model;
        return polyline;
    }
    
    return nil;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, polylineModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, polylineModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)lineType {
    NSNumber *value = objc_getAssociatedObject(self, lineTypeKey);
    return [value unsignedIntegerValue];
}

- (void)setLineType:(BMFLineType)lineType {
    objc_setAssociatedObject(self, lineTypeKey, @(lineType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
