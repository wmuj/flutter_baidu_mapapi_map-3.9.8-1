//
//  BMFPolylineModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface BMFPolylineModel : BMFModel

/// flutter层polyline的唯一id(用于区别哪个polyline)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 经纬度数组
@property (nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// indexs
@property (nonatomic, copy) NSArray<NSNumber *> *indexs;

/// 是否抽希
@property (nonatomic, assign) BOOL isThined;

/// 是否可点击，默认YES；
@property (nonatomic, assign) BOOL clickable;

/// 发光模式，仅支持颜色实折线；
@property (nonatomic, assign) int lineBloomMode;

/// 发光处宽度，默认 0.0f；
@property (nonatomic, assign) CGFloat lineBloomWidth;

/// 发光处透明度，取值范围 [0 ~ 255]，默认 255.0f；
@property (nonatomic, assign) CGFloat lineBloomAlpha;

/// 透明度渐变速度
/// 取值范围 [1.0f ~ 10.0f]，默认值为 5.0f
/// 注意：渐变发光模式下该属性生效
@property (nonatomic, assign) CGFloat lineBloomGradientASPeed;

/// 模糊次数
/// 取值范围 [1~10]，默认值为 1
/// 注意：模糊发光模式下该属性生效
@property (nonatomic, assign) int lineBloomBlurTimes;

/// 颜色数组16进制
@property (nonatomic, copy) NSArray<NSString *> *colors;

/// 图片路径数组
@property (nonatomic, copy) NSArray<NSString *> *textures;

/// 线宽
@property (nonatomic, assign) int width;

/// 虚线类型
@property (nonatomic, assign) int lineDashType;

/// line头尾处理方式(不支持虚线)
@property (nonatomic, assign) int lineCapType;

/// line拐角处理方式（不支持虚线）
@property (nonatomic, assign) int lineJoinType;

/// 折线经度跨180所需字段 since 6.3.0
@property (nonatomic, assign) int lineDirectionCross180;

@end

NS_ASSUME_NONNULL_END
