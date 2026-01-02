//
//  BMFHollowShapeModel.h
//  flutter_baidu_mapapi_map
//
//  Created by Zhang,Baojin on 2020/11/17.
//

#ifndef __BMFHollowShapeModel__H__
#define __BMFHollowShapeModel__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKOverlay.h>
#endif
#endif

#import <flutter_baidu_mapapi_base/BMFModel.h>


@class BMFCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface BMFHollowShapeModel : BMFModel

/// 镂空类型
/// 0 circle
/// 1 polygon
@property (nonatomic, assign) int hollowShapeType;

/// 多边形镂空区域 赋值coordinates
/// 多边形镂空与圆形镂空 二选一
/// 经纬度数组
@property (nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// 圆形镂空区域 赋值center radius
/// 多边形镂空与圆形镂空 二选一
/// 圆心点经纬度
@property (nonatomic, strong) BMFCoordinate *center;

/// 圆的半径(单位米)
@property (nonatomic, assign) double radius;

/// dic => 镂空overlay数组
+ (NSArray<id<BMKOverlay>> *)fromDictionaryArray:(NSArray<NSDictionary *> *)dicArray;

/// BMFHollowShapeModel数组 => 镂空overlay数组
+ (NSArray<id<BMKOverlay>> *)fromHollowShapes:(NSArray<BMFHollowShapeModel *> *)hollowShapes;

@end

NS_ASSUME_NONNULL_END
