//
//  BMFAnnotationModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/11.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFMapPoint;

NS_ASSUME_NONNULL_BEGIN

@interface BMFAnnotationModel : BMFModel

/// flutter层mark的唯一id(用于区别哪个marker)
@property (nonatomic, copy) NSString *Id;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 子标题
@property (nonatomic, copy) NSString *subtitle;

/// 旋转角度
@property (nonatomic, assign) NSInteger rotation;

/// 旋转锚点
@property (nonatomic, assign) CGFloat anchorX;
@property (nonatomic, assign) CGFloat anchorY;

/// annotation中心坐标.
@property (nonatomic, strong) BMFCoordinate *position;

/// 标注固定在指定屏幕位置,  必须与screenPointToLock一起使用。 注意：拖动Annotation isLockedToScreen会被设置为false。
/// 若isLockedToScreen为true，拖动地图时annotaion不会跟随移动；
/// 若isLockedToScreen为false，拖动地图时annotation会跟随移动。
@property (nonatomic, assign) BOOL isLockedToScreen;

/// 标注锁定在屏幕上的位置，注意：地图初始化后才能设置screenPointToLock。
/// 可以在地图加载完成的回调方法：mapViewDidFinishLoading中使用此属性。
@property (nonatomic, strong) BMFMapPoint *screenPointToLock;

/// annotationView复用标识符
@property (nonatomic, copy) NSString *identifier;

/// 图片路径
@property (nonatomic, copy) NSString *icon;

/// 图片数据流
@property (nonatomic, strong) NSObject *iconData;


/// 默认情况下, annotation
/// view的中心位于annotation的坐标位置，可以设置centerOffset改变view的位置，
/// 正的偏移使view朝右下方移动，负的朝左上方，单位是像素
@property (nonatomic, strong) BMFMapPoint *centerOffset;

/// 默认情况下,标注没有3D效果，可以设置enabled3D改变使用3D效果，使得标注在地图旋转和俯视时跟随旋转、俯视
@property (nonatomic, assign) BOOL enabled3D;

/// 默认为YES,当为NO时view忽略触摸事件
@property (nonatomic, assign) BOOL enabled;

/// 当设为YES并实现了setCoordinate:方法时，支持将view在地图上拖动, iOS 3.2以后支持
@property (nonatomic, assign) BOOL draggable;

/// 默认为NO,当为YES时为会弹出气泡
@property (nonatomic, assign) BOOL selected;

/// 当为YES时，view被选中时会弹出气泡，annotation必须实现了title这个方法
@property (nonatomic, assign) BOOL canShowCallout;


///当发生单击地图事件时，当前的annotation的泡泡是否隐藏，默认值为YES
@property (nonatomic, assign) BOOL hidePaopaoWhenSingleTapOnMap;
///当发生双击地图事件时，当前的annotation的泡泡是否隐藏，默认值为NO
@property (nonatomic, assign) BOOL hidePaopaoWhenDoubleTapOnMap;
///当发生两个手指点击地图（缩小地图）事件时，当前的annotation的泡泡是否隐藏，默认值为NO
@property (nonatomic, assign) BOOL hidePaopaoWhenTwoFingersTapOnMap;
///当选中其他annotation时，当前annotation的泡泡是否隐藏，默认值为YES
@property (nonatomic, assign) BOOL hidePaopaoWhenSelectOthers;
///当拖拽当前的annotation时，当前annotation的泡泡是否隐藏，默认值为NO
@property (nonatomic, assign) BOOL hidePaopaoWhenDrag;
///当拖拽其他annotation时，当前annotation的泡泡是否隐藏，默认值为NO
@property (nonatomic, assign) BOOL hidePaopaoWhenDragOthers;

/// marker展示优先级
@property (nonatomic, assign) int displayPriority;

/// marker自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 开启碰撞检测，默认NO，关闭。V6.5.0以后支持
@property (nonatomic, assign) BOOL isOpenCollisionDetection;

/// 碰撞检测优先级，同一优先级后添加的优先展示。V6.5.0以后支持
/// 默认为0，优先级设置为NSIntegerMax时将会最优先展示
@property (nonatomic, assign) NSInteger collisionDetectionPriority;

/// 开启碰撞检测时，是否强制展示，默认NO。V6.5.0以后支持
@property (nonatomic, assign) BOOL isForceDisplay;

/// 开启气泡碰撞检测，默认NO，关闭；且当isOpenCollisionDetection为YES时生效。
@property (nonatomic, assign) BOOL isOpenCollisionDetectionWithPaoPaoView;

/// 是否开启与底图POI的碰撞检测，默认NO。仅支持大于15地图显示层级。
@property (nonatomic, assign) BOOL isOpenCollisionDetectionWithMapPOI;

@end


NS_ASSUME_NONNULL_END
