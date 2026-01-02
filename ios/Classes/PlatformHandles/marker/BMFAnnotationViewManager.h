//
//  BMFAnnotationViewManager.h
//  flutter_baidu_mapapi_map
//
//  Created by Zhang,Baojin on 2020/11/12.
//

// annotationView处理中心

#ifndef __BMFAnnotationViewManager__H__
#define __BMFAnnotationViewManager__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

@class BMFAnnotationModel;

NS_ASSUME_NONNULL_BEGIN

@interface BMFAnnotationViewManager : NSObject

/// 根据anntation生成对应的View
+ (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation;

+ (BMFAnnotationModel *)annotationModelfromAnnotionView:(BMKAnnotationView *)view;
@end

NS_ASSUME_NONNULL_END
