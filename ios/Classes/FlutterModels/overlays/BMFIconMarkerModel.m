//
//  BMFIconMarkerModel.m
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/30.
//

#import "BMFIconMarkerModel.h"

@implementation BMFIconMarkerModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"icons" : @"NSString"};
}

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}
@end
