//
//  BMFPolygonModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/2/27.
//

#import "BMFPolygonModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import "BMFHollowShapeModel.h"

@implementation BMFPolygonModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate",
             @"hollowShapes" : @"BMFHollowShapeModel"
    };
}

@end


