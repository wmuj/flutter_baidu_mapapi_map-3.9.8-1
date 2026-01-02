//
//  BMFPolyline.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/12.
//

#ifndef __BMFPolyline__H__
#define __BMFPolyline__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFPolylineModel.h"
#import "BMFOverlay.h"

typedef NS_ENUM(NSUInteger, BMFLineType) {
    kBMFColorLine = 0,   ///< 单色折线
    kBMFColorsLine,      ///< 多色折线
    kBMFTextureLine,     ///< 单纹理折线
    kBMFTexturesLine,    ///< 多纹理折线
    kBMFDashLine,        ///< 虚线
    kBMFMultiDashLine    ///< 多色虚线
};
NS_ASSUME_NONNULL_BEGIN

@interface BMKPolyline (BMFPolyline)<BMFOverlay>

/// 折线类型标记
@property (nonatomic, assign, readonly) NSUInteger lineType;

@end

NS_ASSUME_NONNULL_END
