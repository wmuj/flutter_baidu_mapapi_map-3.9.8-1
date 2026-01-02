//
//  BMFTileModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#import "BMFTileModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFTileModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

@implementation BMFTileModelOptions

@end

