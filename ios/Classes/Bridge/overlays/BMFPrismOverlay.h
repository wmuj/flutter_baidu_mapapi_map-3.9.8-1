//
//  BMFPrismOverlay.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#ifndef __BMFPrismOverlay__H__
#define __BMFPrismOverlay__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFPrismOverlayModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN
/// since 6.4.0
@interface BMKPrismOverlay (BMFPrismOverlay)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
