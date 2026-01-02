//
//  BMFPolygon.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/2/27.
//

#ifndef __BMFPolygon__H__
#define __BMFPolygon__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFPolygonModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMKPolygon (BMFPolygon)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
