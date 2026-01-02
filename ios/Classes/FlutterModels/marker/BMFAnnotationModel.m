//
//  BMFAnnotationModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import "BMFAnnotationModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFAnnotationModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

