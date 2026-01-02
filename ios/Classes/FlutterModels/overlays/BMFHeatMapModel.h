//
//  BMFHeatMapModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/26.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFGradient;
@class BMFHeatMapModelNode;
@class BMFCoordinate;
@class BMKHeatMap;
@class BMKGradient;
@class BMKHeatMapNode;
@class BMFAnimation;
NS_ASSUME_NONNULL_BEGIN

@interface BMFHeatMapModel : BMFModel

///设置热力图点半径，默认为12ps，当mRadiusIsMeter为NO时生效，范围[10~50]
@property (nonatomic, assign) int radius;

/// 设置热力图点半径单位是否是米，默认为NO，范围[10~50]
@property (nonatomic, assign) BOOL radiusIsMeter;

/// 设置热力图点半径（米），默认为12米，当mRadiusIsMeter为YES时生效，范围[10~50]
@property (nonatomic, assign) int radiusMeter;

/// 设置热力图最大显示等级，默认为22，范围[4~22]
@property (nonatomic, assign) int maxShowLevel;

/// 设置热力图最小显示等级，默认为4，范围[4~22]
@property (nonatomic, assign) int minShowLevel;

///设置热力图渐变，有默认值 DEFAULT_GRADIENT
@property (nonatomic, strong) BMFGradient *gradient;

///设置热力图层透明度，默认 0.6
@property (nonatomic, assign) double opacity;

///用户传入的热力图数据,数组,成员类型为BMFHeatMapModelNode
@property (nonatomic, strong) NSMutableArray<BMFHeatMapModelNode *> *data;

/// 设置3D热力图最大高度，默认为0ps，范围[0~200]，since 3.3.0
@property (nonatomic, assign) int mMaxHight;

/// 设置热力图最大权重值，默认为1.0，since 3.3.0
@property (nonatomic, assign) double mMaxIntensity;

/// 设置热力图最小权重值，默认为0.0，since 3.3.0
@property (nonatomic, assign) double mMinIntensity;

/// 用户传入的热力图数据data和datas ，二选一，优先datas
@property (nonatomic, strong) NSArray <NSArray *> *datas;

/// 设置第一次显示时的动画属性，默认为nil
@property (nonatomic, strong) BMFAnimation *animation;

/// 设置帧动画属性，默认为nil
@property (nonatomic, strong) BMFAnimation *frameAnimation;

- (BMKHeatMap *)toBMKHeatMap;

@end

typedef enum : NSUInteger  {
    BMFLinear, /// 线性
    BMFInQuad, BMFOutQuad, BMFInOutQuad, BMFOutInQuad,
    BMFInCubic, BMFOutCubic, BMFInOutCubic, BMFOutInCubic,
    BMFInQuart, BMFOutQuart, BMFInOutQuart, BMFOutInQuart,
    BMFInQuint, BMFOutQuint, BMFInOutQuint, BMFOutInQuint,
    BMFInSine, BMFOutSine, BMFInOutSine, BMFOutInSine,
    BMFInExpo, BMFOutExpo, BMFInOutExpo, BMFOutInExpo,
    BMFInCirc, BMFOutCirc, BMFInOutCirc, BMFOutInCirc,
    BMFInElastic, BMFOutElastic, BMFInOutElastic, BMFOutInElastic,
    BMFInBack, BMFOutBack, BMFInOutBack, BMFOutInBack,
    BMFInBounce, BMFOutBounce, BMFInOutBounce, BMFOutInBounce,
    BMFInCurve, BMFOutCurve, BMFSineCurve, BMFCosineCurve
} BMFAnimationType;

@interface BMFAnimation : BMFModel

/// 设置动画总时长，默认为0ms，
@property (nonatomic, assign) int duration;
/// 动画缓动函数类型，默认0：线性
@property (nonatomic, assign) BMFAnimationType type;


@end

@interface BMFGradient : BMFModel

///渐变色用到的所有颜色数组,数组成员类型为UIColor
@property (nonatomic, copy) NSArray<NSString *> *colors;

///每一个颜色的起始点数组,,数组成员类型为 [0,1]的double值, given as a percentage of the maximum intensity,个数和mColors的个数必须相同，数组内元素必须时递增的
@property (nonatomic, copy) NSArray <NSNumber *> *startPoints;

- (BMKGradient *)toBMKGradient;

@end

@interface BMFHeatMapModelNode : BMFModel

/// 点的强度权值
@property (nonatomic, assign) double intensity;

/// 点的位置坐标
@property (nonatomic, strong) BMFCoordinate *pt;

- (BMKHeatMapNode *)toBMKHeatMapNode;

@end

NS_ASSUME_NONNULL_END
