//
//  BMFArcline.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/15.
//

#import "BMFArcline.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *arclineModelKey = &arclineModelKey;

@implementation BMKArcline (BMFArcline)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;

    BMFArclineModel *model = [BMFArclineModel bmf_modelWith:dic];
    if (model.coordinates.count < 3) return nil;
    
    int _coordsCount = (int)model.coordinates.count;
    CLLocationCoordinate2D *coords = new CLLocationCoordinate2D[_coordsCount];
    for (int i = 0; i < _coordsCount; i++) {
        coords[i] = [model.coordinates[i] toCLLocationCoordinate2D];
    }
    
    BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coords];
    delete [] coords;
    arcline.flutterModel = model;
    return arcline;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, arclineModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, arclineModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
