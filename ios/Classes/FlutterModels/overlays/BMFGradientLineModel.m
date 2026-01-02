//
//  BMFGradientLineModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFGradientLineModel.h"

@implementation BMFGradientLineModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate",
             @"indexs" : @"NSNumber",
             @"colors" : @"NSString"
    };
}
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end
