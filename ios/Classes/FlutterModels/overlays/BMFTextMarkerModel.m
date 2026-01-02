//
//  BMFTextMarkerModel.m
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/19.
//

#import "BMFTextMarkerModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>

@implementation BMFTextMarkerStyle

+ (instancetype)fromBMKTextStyle:(BMKTextStyle *)style {

    BMFTextMarkerStyle *markerStyle = [[BMFTextMarkerStyle alloc] init];
    markerStyle.textColor = [UIColor colorRGBStringFrom:style.textColor];
    markerStyle.borderColor = [UIColor colorRGBStringFrom:style.borderColor];
    markerStyle.fontOption = (int)style.fontOption;
    markerStyle.fontSize = style.fontSize;
    markerStyle.borderWidth = style.borderWidth;
    return markerStyle;
}

- (nullable BMKTextStyle *)toBMKTextStyle {
    BMKTextStyle *style = [[BMKTextStyle alloc] init];
    style.textColor = [UIColor fromColorString:self.textColor];
    style.borderColor = [UIColor fromColorString:self.borderColor];
    style.fontOption = self.fontOption;
    style.fontSize = self.fontSize;
    style.borderWidth = self.borderWidth;
    return style;
}

@end

@implementation BMFTextMarkerModel
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end
