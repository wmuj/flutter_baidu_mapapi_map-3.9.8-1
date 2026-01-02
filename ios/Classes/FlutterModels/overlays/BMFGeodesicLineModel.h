//
//  BMFGeodesicLineModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface BMFGeodesicLineModel : BMFModel

/// flutter层GeodesicLine的唯一id(用于区别哪个geodesicline)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 经纬度数组
@property (nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// 颜色16进制strokeColor
@property (nonatomic, copy) NSString *strokeColor;

/// 纹理图片路径
@property (nonatomic, copy) NSString *textureImage;

/// 线宽
@property (nonatomic, assign) int width;

/// 虚线类型
@property (nonatomic, assign) int lineDashType;

/// 折线经度跨180所需字段
@property (nonatomic, assign) int lineDirectionCross180;

@end

NS_ASSUME_NONNULL_END
