//
//  BMFTraceOverlayModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>
@class BMFCoordinate;
@class BMFTraceOverlayOption;
@class BMKTraceOverlayOption;
@class BMFTrace3DModelOption;
@class BMKTrace3DModelOption;

NS_ASSUME_NONNULL_BEGIN

@interface BMFTraceOverlayModel : BMFModel

/// flutter层traceOverlay的唯一id(用于区别哪个traceOverlay)
@property(nonatomic, copy) NSString *Id;

/// 经纬度数组
@property(nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// traceOverlay动画参数
@property(nonatomic, strong) BMFTraceOverlayOption *traceOverlayAnimateOption;

/// 线宽
@property(nonatomic, assign) int width;

/// 画笔颜色
@property(nonatomic, copy) NSString *strokeColor;

/// 填充颜色
@property(nonatomic, copy) NSString *fillColor;

/// 是否使用渐变色 默认为NO since 6.5.7
@property(nonatomic, assign) BOOL isGradientColor;

/// 是否使用发光效果 默认为NO since 6.5.7
@property(nonatomic, assign) BOOL isTrackBloom;

/// 轨迹发光参数 since 6.5.7
/// 取值范围 [1.0f ~ 10.0f]，默认值为 5.0f
/// 注意：渐变发光模式下该属性生效
@property(nonatomic, assign) CGFloat bloomSpeed;

/// 使用分段颜色绘制时，必须设置（内容必须为UIColor）since 6.5.7
/// 注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
/// alpha:(CGFloat)alpha; 初始化UIColor。 使用[UIColor
/// ***Color]初始化时，个别case转换成RGB后会有问题 注意：strokeColors 长度与轨迹点的个数必须保持一致
@property(nonatomic, copy) NSArray<NSString *> *strokeColors;

/// 是否需要对TraceOverlay坐标数据进行抽稀，默认为YES
@property(nonatomic, assign) BOOL isThined;

/// 是否需要对TraceOverlay坐标数据进拐角平滑，默认为YES
@property(nonatomic, assign) BOOL isCornerSmooth;

@end

@interface BMFTraceOverlayOption : BMFModel

/// traceOverlay是否做动画, 默认YES
@property(nonatomic, assign) BOOL animate;

/// 动画延时开始，单位s
@property(nonatomic, assign) double delay;

/// 动画时间，单位s
@property(nonatomic, assign) double duration;

/// 0~1， 默认0
@property(nonatomic, assign) float fromValue;

/// 0~1，默认1
@property(nonatomic, assign) float toValue;

/// 动画类型
@property(nonatomic, assign) int easingCurve;

/// 是否跟踪轨迹, 默认YES
@property(nonatomic, assign) BOOL trackMove;

/// 轨迹跟踪时地图是否跟着旋转, 默认YES
@property(nonatomic, assign) BOOL isRotateWhenTrack;

/// 点平滑移动,
/// 默认NO，设置为YES时可配合pointImage设置点图片或可根据animationTraceMovePosition动画代理回调实时位置自定义添加AnnotationView或3D模型
@property(nonatomic, assign) BOOL isPointMove;

/// 自定义Point图片，无默认图片，小车等带方向的图片车头向右为正方向
@property(nonatomic, copy) NSString *pointImage;

/// 3d模型
@property(nonatomic, strong) BMFTrace3DModelOption *modelOption;

- (nullable BMKTraceOverlayOption *)toBMKTraceOverlayOption;

@end

@interface BMFTrace3DModelOption : BMFModel
/// 缩放比例，默认1.0
@property(nonatomic, assign) float scale;

/// scale不随地图缩放而变化，默认为NO
@property(nonatomic, assign) BOOL zoomFixed;

/// 旋转角度，取值范围为[0.0f, 360.0f]，默认为0.0
@property(nonatomic, assign) float rotateX;

@property(nonatomic, assign) float rotateY;

@property(nonatomic, assign) float rotateZ;
/// 偏移像素，默认为0.0
@property(nonatomic, assign) float offsetX;

@property(nonatomic, assign) float offsetY;

@property(nonatomic, assign) float offsetZ;

/// 3D模型文件格式，默认BMK3DModelTypeObj
@property(nonatomic, assign) int type;

/// 模型文件路径
@property(nonatomic, copy) NSString *modelPath;

/// 模型名
@property(nonatomic, copy) NSString *modelName;

/// 以下只支持带有animations标签的GLTF模型
/// 模型动画是否可用，默认为NO：添加后不执行动画，值为YES时添加后立即按照配置参数执行动画
@property(nonatomic, assign) BOOL animationIsEnable;
/// 模型动画重复执行次数，默认0：动画将一直执行动画
@property(nonatomic, assign) NSInteger animationRepeatCount;
/// 当前模型动画索引值，
@property(nonatomic, assign) NSInteger animationIndex;
/// 模型动画倍速，默认：1.0
@property(nonatomic, assign) CGFloat animationSpeed;
/// 轨迹动画中模型的偏航轴，即模型与右手坐标系Z轴重合的轴
@property(nonatomic, assign) int modelYawAxis;

- (nullable BMKTrace3DModelOption *)toBMKTrace3dModelOption;
@end

NS_ASSUME_NONNULL_END
