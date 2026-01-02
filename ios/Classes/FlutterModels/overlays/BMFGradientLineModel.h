//
//  BMFGradientLineModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface BMFGradientLineModel : BMFModel

/// flutter层gradientLine的唯一id(用于区别哪个gradientLine)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 经纬度数组
@property (nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// indexs
@property (nonatomic, copy) NSArray<NSNumber *> *indexs;

/// 颜色数组16进制
@property (nonatomic, copy) NSArray<NSString *> *colors;

/// 是否抽希
@property (nonatomic, assign) BOOL isThined;

/// 是否可点击
@property (nonatomic, assign) BOOL clickable;

/// 线宽
@property (nonatomic, assign) int width;

/// 折线经度跨180所需字段
@property (nonatomic, assign) int lineDirectionCross180;

@end

NS_ASSUME_NONNULL_END
