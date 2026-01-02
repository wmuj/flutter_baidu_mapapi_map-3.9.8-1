//
//  BMFMapAnimation.m
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/19.
//

#import "BMFMapAnimation.h"
@implementation BMFInterpolator

@end

@implementation BMFMapAnimation

@end

@implementation BMFMapAlphaAnimation

@end

@implementation BMFMapRotateAnimation

@end

@implementation BMFMapScaleAnimation

@end

@implementation BMFMapTranslateAnimation

@end

@implementation BMFMapTrackAnimation

@end

@implementation BMFMapAnimationSet
+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"animationList" : @"BMFMapAnimation",
             @"animationOrderTypeList" : @"NSNumber"};
}
@end
