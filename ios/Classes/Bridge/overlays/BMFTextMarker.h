//
//  BMFTextMarker.h
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/19.
//

#ifndef __BMFText__H__
#define __BMFText__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif
#import "BMFOverlay.h"
#import "BMFTextMarkerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BMKTextMarker (BMFTextMarker)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
