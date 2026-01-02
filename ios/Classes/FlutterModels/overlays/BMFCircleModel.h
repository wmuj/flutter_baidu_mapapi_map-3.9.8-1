//
//  BMFCircleModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/15.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>


@class BMFCoordinate;
@class BMFHollowShapeModel;
NS_ASSUME_NONNULL_BEGIN

@interface BMFCircleModel : BMFModel

/// flutter层circle的唯一id(用于区别哪个circle)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 半径，单位：米
@property (nonatomic, assign) double radius;

/// 中心点坐标
@property (nonatomic, strong) BMFCoordinate *center;

/// 镂空数组
@property (nonatomic, copy) NSArray<BMFHollowShapeModel *> *hollowShapes;

/// 线宽
@property (nonatomic, assign) int width;

/// 颜色16进制strokeColor
@property (nonatomic, copy) NSString *strokeColor;

/// 颜色16进制fillColor
@property (nonatomic, copy) NSString *fillColor;

/// 虚线类型
@property (nonatomic, assign) int lineDashType;

/// 是否可点击
@property (nonatomic, assign) BOOL clickable;

/// 渐变圆属性
/// 注意：渐变圆不支持镂空及fillColor
/// 设置渐变圆，镂空及fillColor就会失效

/// 中心颜色
@property (nonatomic, copy) NSString *centerColor;

/// 边缘颜色
@property (nonatomic, copy) NSString *sideColor;

/// 半径权重
/// 取值范围（0.0, 1.0），默认 0.5
@property (nonatomic, assign) float radiusWeight;

/// 颜色权重
/// 取值范围（0.0, 1.0），默认 0.2
@property (nonatomic, assign) float colorWeight;

@end

NS_ASSUME_NONNULL_END
