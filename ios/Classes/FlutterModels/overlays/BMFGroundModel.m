//
//  BMFGroundModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/22.
//

#import "BMFGroundModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFGroundModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end
