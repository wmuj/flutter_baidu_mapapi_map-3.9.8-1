//
//  BMFHollowShapeModel.m
//  flutter_baidu_mapapi_map
//
//  Created by Zhang,Baojin on 2020/11/17.
//

#import "BMFHollowShapeModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@implementation BMFHollowShapeModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate"};
}

+ (NSArray<id<BMKOverlay>> *)fromDictionaryArray:(NSArray<NSDictionary *> *)dicArray {
    if (!dicArray || dicArray.count <= 0) {
        return [NSArray array];
    }
    NSMutableArray<BMFHollowShapeModel *> *hollows = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        BMFHollowShapeModel *hollowModel = [BMFHollowShapeModel bmf_modelWith:dic];
        [hollows addObject:hollowModel];
    }
    return [BMFHollowShapeModel fromHollowShapes:hollows];
}

+ (NSArray<id<BMKOverlay>> *)fromHollowShapes:(NSArray<BMFHollowShapeModel *> *)hollowShapes {
    if (!hollowShapes || hollowShapes.count <= 0) {
        return [NSArray array];
    }
    NSMutableArray<id<BMKOverlay>> *hollows = [NSMutableArray array];
    for (BMFHollowShapeModel *hollowModel in hollowShapes) {
        if (hollowModel.hollowShapeType < 0 || hollowModel.hollowShapeType > 1) continue;
        if (hollowModel.center && hollowModel.coordinates) continue;
        
        if (hollowModel.hollowShapeType == 0) { // 圆形镂空
            BMKCircle *_hollowCircle = [BMKCircle circleWithCenterCoordinate:[hollowModel.center toCLLocationCoordinate2D] radius:hollowModel.radius];
            [hollows addObject:_hollowCircle];
            continue;
        }
        if (hollowModel.hollowShapeType == 1) { // 多边形镂空
            size_t _hollowCoordsCount = hollowModel.coordinates.count;
            CLLocationCoordinate2D *_hollowCoords = new CLLocationCoordinate2D[_hollowCoordsCount];
            for (size_t i = 0; i < _hollowCoordsCount; i++) {
                _hollowCoords[i] = [hollowModel.coordinates[i] toCLLocationCoordinate2D];
            }
            BMKPolygon *_hollowPolygon = [BMKPolygon polygonWithCoordinates:_hollowCoords count:_hollowCoordsCount];
            delete [] _hollowCoords;
            [hollows addObject:_hollowPolygon];
        }
        
    }
    return hollows.copy;
}

@end
