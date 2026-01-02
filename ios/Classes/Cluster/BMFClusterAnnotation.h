//
//  BMFClusterAnnotation.h
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2024/4/12.
//
#ifndef __BMFClusterAnnotation__H__
#define __BMFClusterAnnotation__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMFClusterAnnotation : BMKPointAnnotation

@property (nonatomic, assign) int size;

@end

NS_ASSUME_NONNULL_END
