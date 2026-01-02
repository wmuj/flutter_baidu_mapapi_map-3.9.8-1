//
//  BMFMapStatusModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/20.
//

#import "BMFMapStatusModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <BaiduMapAPI_Map/BMKMapStatus.h>

typedef struct CG_BOXABLE BMFlutterMapRect BMFlutterMapRect;

@implementation BMFMapStatusModel

+ (BMFMapStatusModel *)fromMapStatus:(BMKMapStatus *)mapStatus {
    BMFMapStatusModel *model = [BMFMapStatusModel new];
    model.fLevel = mapStatus.fLevel;
    model.fRotation = mapStatus.fRotation;
    model.fOverlooking = mapStatus.fOverlooking;
    model.targetScreenPt = [BMFMapPoint fromCGPoint:mapStatus.targetScreenPt];
    model.targetGeoPt = [BMFCoordinate fromCLLocationCoordinate2D:mapStatus.targetGeoPt];
    BMFMapRect *rect = [BMFMapRect fromBMKMapRect:mapStatus.visibleMapRect];
    model.visibleMapBounds = [rect toBMFCoordinateBounds];
    return model;
}

- (BMKMapStatus *)toMapStatus {
    BMKMapStatus *status = [BMKMapStatus new];
    status.fLevel = self.fLevel;
    status.fRotation = self.fRotation;
    status.fOverlooking = self.fOverlooking;
    status.targetGeoPt = [self.targetGeoPt toCLLocationCoordinate2D];
    status.targetScreenPt = [self.targetScreenPt toCGPoint];
    // 这里需要KVC赋值
    BMKMapRect mapRect = [self.visibleMapBounds toBMKMapRect];
    NSValue *value = [NSValue valueWithBytes:&mapRect objCType:@encode(BMKMapRect)];
    [status setValue:value forKey:@"_visibleMapRect"];
    return status;
}

@end
