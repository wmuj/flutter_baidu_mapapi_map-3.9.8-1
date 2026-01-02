//
//  BMFTraceOverlay.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#ifndef __BMFTraceOverlay__H__
#define __BMFTraceOverlay__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFTraceOverlayModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN
/// since 6.4.0
@interface BMKTraceOverlay (BMFTraceOverlay)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
