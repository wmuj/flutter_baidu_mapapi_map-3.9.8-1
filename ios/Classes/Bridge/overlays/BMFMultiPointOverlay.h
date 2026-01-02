//
//  BMFMultiPointOverlay.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#ifndef __BMFMultiPointOverlay__H__
#define __BMFMultiPointOverlay__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFMultiPointOverlayModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN
/// since 6.4.0
@interface BMKMultiPointOverlay (BMFMultiPointOverlay)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
