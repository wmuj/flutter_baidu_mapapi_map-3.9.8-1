//
//  BMF3DModelOverlay.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#ifndef __BMF3DModelOverlay__H__
#define __BMF3DModelOverlay__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMF3DModelOverlayModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN
/// since 6.4.0
@interface BMK3DModelOverlay (BMF3DModelOverlay)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
