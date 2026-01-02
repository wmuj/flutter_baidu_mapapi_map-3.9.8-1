//
//  BMFAnnotation.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#ifndef __BMFAnnotation__H__
#define __BMFAnnotation__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import "BMFAnnotationModel.h"
#import "BMFOverlay.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMKPointAnnotation (BMFAnnotation)<BMFOverlay>

@end

NS_ASSUME_NONNULL_END
