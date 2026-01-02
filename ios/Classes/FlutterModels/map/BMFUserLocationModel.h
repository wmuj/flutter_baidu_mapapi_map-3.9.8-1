//
//  BMFUserLocationModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/01.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFLocationModel;
@class BMFHeadingModel;
@class BMKUserLocation;
@class CLHeading;
@class CLLocation;
@class BMKLocationViewDisplayParam;

NS_ASSUME_NONNULL_BEGIN

@interface BMFUserLocationModel : BMFModel

/// 位置更新状态，如果正在更新位置信息，则该值为YES
@property (nonatomic, assign) BOOL updating;

/// 位置信息，尚未定位成功，则该值为nil
@property (nonatomic, strong) BMFLocationModel *location;

/// heading信息，尚未定位成功，则该值为nil
@property (nonatomic, strong) BMFHeadingModel *heading;

/// 定位标注点要显示的标题信息
@property (nonatomic, copy) NSString *title;

/// 定位标注点要显示的子标题信息
@property (nonatomic, copy) NSString *subtitle;

- (BMKUserLocation *)toBMKUserLocation;

@end

@interface BMFLocationModel : BMFModel

/// 经纬度
@property(nonatomic, strong) BMFCoordinate *coordinate;

/// 海拔
@property(nonatomic, assign) double altitude;

/// 水平精确度
@property(nonatomic, assign) double horizontalAccuracy;

/// 垂直精确度
@property(nonatomic, assign) double verticalAccuracy;

/// 航向
@property(nonatomic, assign) double course;

/// 速度
@property(nonatomic, assign) double speed;

/// 时间
@property (nonatomic, copy) NSString *timestamp;

- (CLLocation *)toCLLocation;

@end

@interface BMFHeadingModel : BMFModel

/// 磁头
/// 表示度方向，其中0度为磁北。无论设备的方向以及用户界面的方向如何，方向都是从设备的顶部引用的。
/// 范围: 0.0 - 359.9度，0度为地磁北极
@property (nonatomic, assign) double magneticHeading;

/// 表示角度方向，其中0度为真北。参考方向
/// 不考虑设备的方向以及设备的方向
/// 范围: 0.0 - 359.9度，0为正北
@property (nonatomic, assign) double trueHeading;

/// 航向精度
/// 表示磁头可能与实际地磁头偏差的最大度数。负值表示无效的标题。
@property (nonatomic, assign) double headingAccuracy;

/// x轴测量的地磁的原始值
@property (nonatomic, assign) double x;

/// y轴测量的地磁的原始值
@property (nonatomic, assign) double y;

/// z轴测量的地磁的原始值
@property (nonatomic, assign) double z;

/// 时间戳
@property (nonatomic, copy) NSString *timestamp;

- (CLHeading *)toCLHeading;

@end


@interface BMFLocationViewDisplayParam : BMFModel

/// 定位图标X轴偏移量(屏幕坐标)
@property (nonatomic, assign) CGFloat locationViewOffsetX;

/// 定位图标Y轴偏移量(屏幕坐标)
@property (nonatomic, assign) CGFloat locationViewOffsetY;

/// 精度圈是否显示，默认YES
@property (nonatomic, assign) BOOL isAccuracyCircleShow;

/// 精度圈 填充颜色
@property (nonatomic, copy) NSString *accuracyCircleFillColor;

/// 精度圈 边框颜色
@property (nonatomic, copy) NSString *accuracyCircleStrokeColor;

/// 精度圈 边框宽度，默认1.6point
@property (nonatomic, assign) CGFloat accuracyCircleBorderWidth;

/// 跟随态旋转角度是否生效，默认YES
@property (nonatomic, assign) BOOL isRotateAngleValid;

///// 定位图标名称，需要将该图片放到 mapapi.bundle/images 目录下
//@property (nonatomic, strong) NSString *locationViewImgName;

/// 用户自定义定位图标，V4.2.1以后支持
@property (nonatomic, copy) NSString *locationViewImage;

/// 是否显示气泡，默认YES
@property (nonatomic, assign) BOOL canShowCallOut;

/// locationView在mapview上的层级 默认值为LOCATION_VIEW_HIERARCHY_BOTTOM
@property (nonatomic, assign) int locationViewHierarchy;

/// 是否是定位图标箭头样式自定义，YES：箭头样式自定义， NO：整体样式自定义，默认NO
@property (nonatomic, assign) BOOL isLocationArrowStyleCustom;

/* 以下为定位图标整体样式自定义，自定义图片和gif图二选一，Gif图优先级大于图片*/
/// 新版用户自定义定位图标
@property (nonatomic, strong) NSString *locationViewImageNew;
/// 定位图标整体样式自定义gif图文件路径
@property (nonatomic, copy) NSString *locationViewGifImageFilePath;
/// 定位图标整体样式自定义大小缩放系数，默认为1，可设置范围0.5～2.0，基于固定尺寸CGSizeMake(30, 30)缩放
@property (nonatomic, assign) CGFloat locationViewImageSizeScale;
/// 定位图标整体样式自定义呼吸效果，默认为NO
@property (nonatomic, assign) BOOL breatheEffectOpenForWholeStyle;
/* 以下为箭头样式定位图标自定义，可分别自定义中心圆点图片和箭头图片，中心图标自定义图片和gif图二选一，Gif图优先级大于图片*/
/// 箭头样式定位图标中心图片，无方向
@property (nonatomic, strong) NSString *locationViewCenterImage;
/// 箭头样式定位图标中心圆点gif图文件路径，无方向
@property (nonatomic, copy) NSString *locationViewCenterGifImageFilePath;
/// 箭头样式定位图标中心圆点图片大小缩放系数，默认为1，可设置范围0.5～2.0，基于固定尺寸CGSizeMake(30, 30)缩放
@property (nonatomic, assign) CGFloat locationViewCenterImageSizeScale;
/// 箭头样式定位图标周边箭头轮廓图片，箭头向上为正
@property (nonatomic, strong) NSString *locationViewAroundArrowsImage;
/// 箭头样式定位图标周边箭头轮廓图片大小缩放系数，默认为1，可设置范围0.2～3.0，基于图片大小缩放
@property (nonatomic, assign) CGFloat locationViewAroundArrowsImageSizeScale;
/// 箭头样式定位图标呼吸效果，默认为YES
@property (nonatomic, assign) BOOL breatheEffectOpenForArrowsStyle;

- (BMKLocationViewDisplayParam *)toBMKLocationViewDisplayParam;

@end

NS_ASSUME_NONNULL_END
