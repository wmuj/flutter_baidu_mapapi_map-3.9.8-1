//
//  BMFCircle.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/15.
//

#ifndef __BMFCircle__H__
#define __BMFCircle__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFCircleModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMKCircle (BMFCircle)<BMFOverlay>

/// 是否为渐变圆
@property (nonatomic, assign, readonly) BOOL isGradientCircle;

@end

NS_ASSUME_NONNULL_END
