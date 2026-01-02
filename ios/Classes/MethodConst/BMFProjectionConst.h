#ifndef __BMFProjectionConst__H__
#define __BMFProjectionConst__H__


#import <Foundation/Foundation.h>
// 数据转换
/// 屏幕坐标转经纬度
FOUNDATION_EXPORT NSString *const kBMFCoordinateFromScreenPointMethod;
/// 经纬度转换屏幕坐标
FOUNDATION_EXPORT NSString *const kBMFScreenPointFromCoordinateMethod;
/// 将三维地理坐标转化为屏幕坐标
FOUNDATION_EXPORT NSString *const kBMFScreenPointFromMapPoint3Method;

#endif
