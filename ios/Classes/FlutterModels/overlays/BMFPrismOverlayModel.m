//
//  BMFPrismOverlayModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFPrismOverlayModel.h"

@implementation BMFPrismOverlayModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate"};
}
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end
