//
//  BMFTextMarkerModel.h
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/19.
//

#import "BMFModel.h"

@class BMFCoordinate;
@class BMFMapPoint;
@class BMFMapAnimation;
@class BMFMapAnimationSet;
@class BMKTextStyle;
NS_ASSUME_NONNULL_BEGIN

@interface BMFTextMarkerStyle : BMFModel
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, copy) NSString *borderColor;
@property (nonatomic, assign) int fontOption;
@property (nonatomic, assign) int fontSize;
@property (nonatomic, assign) int borderWidth;

+ (instancetype)fromBMKTextStyle:(BMKTextStyle *)style;

- (nullable BMKTextStyle *)toBMKTextStyle;
@end

@interface BMFTextMarkerModel : BMFModel
/// flutter层的唯一id
@property (nonatomic, copy) NSString *Id;

// zindex,默认-1,不起作用
@property (nonatomic, assign) NSInteger zIndex;

/// 坐标
@property (nonatomic, strong) BMFCoordinate *position;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) BMFTextMarkerStyle *textStyle;

@property (nonatomic, assign) float anchorX;
@property (nonatomic, assign) float anchorY;
@property (nonatomic, assign) int offsetX;
@property (nonatomic, assign) int offsetY;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) float scaleX;
@property (nonatomic, assign) float scaleY;
@property (nonatomic, assign) BOOL isPerspective;
@property (nonatomic, strong) BMFMapPoint *fixXY;
@property (nonatomic, assign) int collisionBehavior;
@property (nonatomic, assign) int collisionPriority;
@property (nonatomic, assign) int trackMode;
@property (nonatomic, assign) float opacity;
@property (nonatomic, strong) BMFMapAnimation *animation;
@property (nonatomic, strong) BMFMapAnimationSet *animationSet;

@property (assign, nonatomic) BOOL isClickable;
@property (nonatomic, assign) BOOL draggable;
@end



NS_ASSUME_NONNULL_END
