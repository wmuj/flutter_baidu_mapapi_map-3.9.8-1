//
//  BMFGroundModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/22.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFGroundModelOptions;
@class BMFCoordinate;
@class BMFCoordinateBounds;

NS_ASSUME_NONNULL_BEGIN

@interface BMFGroundModel : BMFModel

/// groundOverlay 唯一id
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 是否可点击，默认NO
@property (assign, nonatomic) BOOL clickable;

/// 图片
@property (nonatomic, copy) NSString *image;

/// 宽
@property (nonatomic, assign) double width;

/// 高
@property (nonatomic, assign) double height;

/// 锚点x
@property (nonatomic, assign) double anchorX;

/// 锚点y
@property (nonatomic, assign) double anchorY;

/// 缩放级别
@property (nonatomic, assign) int zoomLevel;

/// 两种绘制GroundOverlay的方式之一：绘制的位置地理坐标，与anchor配对使用
@property (nonatomic, strong) BMFCoordinate *position;

/// 两种绘制GroundOverlay的方式之二：绘制的地理区域范围，图片在此区域内合理缩放
@property (nonatomic, strong) BMFCoordinateBounds *bounds;

/// 图片纹理透明度,最终透明度 = 纹理透明度 * alpha,取值范围为[0.0f, 1.0f]，默认为1.0f
@property (nonatomic, assign) double transparency;

@end

NS_ASSUME_NONNULL_END
