//
//  BMFMapView.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/10.
//
#ifndef __BMFMapView__H__
#define __BMFMapView__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BMFMapView : BMKMapView

+ (instancetype)viewWithFrame:(CGRect)frame;
+ (instancetype)viewWithFrame:(CGRect)frame dic:(nullable NSDictionary *)dic;


/// 更新地图属性(初始化时，部分参数会不生效)，在地图加载完成时调用
- (BOOL)updateMapInitOptions;

- (BOOL)updateMapViewWith:(nullable NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
