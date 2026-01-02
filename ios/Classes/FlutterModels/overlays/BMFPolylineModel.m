//
//  BMFPolylineModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import "BMFPolylineModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFPolylineModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate",
             @"indexs" : @"NSNumber",
             @"colors" : @"NSString",
             @"textures" : @"NSString"
    };
}
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end


