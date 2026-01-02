//
//  BMFText.h
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2022/9/13.
//

#ifndef __BMFText__H__
#define __BMFText__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFOverlay.h"
#import "BMFTextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMKText (BMFText)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
