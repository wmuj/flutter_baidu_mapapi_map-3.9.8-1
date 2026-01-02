//
//  BMFCircleModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/15.
//

#import "BMFCircleModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import "BMFHollowShapeModel.h"
@implementation BMFCircleModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"hollowShapes" : @"BMFHollowShapeModel"};
}
@end

