//
//  BMFPolygon.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/2/27.
//

#import "BMFPolygon.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import "BMFHollowShapeModel.h"

static const void *polygonModelKey = &polygonModelKey;
@implementation BMKPolygon (BMFPolygon)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
    
    BMFPolygonModel *model = [BMFPolygonModel bmf_modelWith:dic];
    if (model.encodedGeoPoints) {
            
        BMKPolygon *polygon = [[BMKPolygon alloc] init];
        
        polygon.flutterModel = model;
        polygon.encodePointType = (BMKEncodePointType)model.encodePointType;
        polygon.encodedGeoPoints = model.encodedGeoPoints;
        // 镂空判断
        if (model.hollowShapes && model.hollowShapes.count > 0) { // 有镂空
            polygon.hollowShapes = [BMFHollowShapeModel fromHollowShapes:model.hollowShapes];
        }
        return polygon;
    } else {
        
        if (model.coordinates.count <= 2) {
            return nil;
        }
        
        size_t _coordsCount = model.coordinates.count;
        CLLocationCoordinate2D *coords = new CLLocationCoordinate2D[_coordsCount];
        for (size_t i = 0; i < _coordsCount; i++) {
            coords[i] = [model.coordinates[i] toCLLocationCoordinate2D];
        }
        
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:_coordsCount];
        delete[] coords;
        
        polygon.flutterModel = model;
        // 镂空判断
        if (model.hollowShapes && model.hollowShapes.count > 0) { // 有镂空
            polygon.hollowShapes = [BMFHollowShapeModel fromHollowShapes:model.hollowShapes];
        }
        return polygon;
    }
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, polygonModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, polygonModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
