//
//  BMFArclineModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/15.
//

#import "BMFArclineModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFArclineModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate"};
}

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

