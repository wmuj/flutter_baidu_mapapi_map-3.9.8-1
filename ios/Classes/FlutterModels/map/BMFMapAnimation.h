//
//  BMFMapAnimation.h
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/19.
//

#import "BMFModel.h"
#import <flutter_baidu_mapapi_base/BMFModel.h>
@class BMFMapSize;
@class BMFCoordinate;
NS_ASSUME_NONNULL_BEGIN

@interface BMFInterpolator : BMFModel
@property (nonatomic, assign) int interpolatorMode;

@end


@interface BMFMapAnimation : BMFModel
@property (nonatomic, assign) int fillMode;
@property (nonatomic, assign) int repeatMode;
@property (nonatomic, copy) NSString *extParam;
@property (nonatomic, assign) int startDelay;
@property (nonatomic, assign) int startTime;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) int repeatCount;
@property (nonatomic, strong) BMFInterpolator *interpolator;

@property (nonatomic, copy) NSString *animationType;

@property (nonatomic, assign) float fromAlpha;
@property (nonatomic, assign) float toAlpha;

@property (nonatomic, assign) float fromDegrees;
@property (nonatomic, assign) float toDegrees;

@property (nonatomic, strong) BMFMapSize *fromScale;
@property (nonatomic, strong) BMFMapSize *toScale;

@property (nonatomic, strong) BMFCoordinate *fromTranslate;
@property (nonatomic, strong) BMFCoordinate *toTranslate;

@property (nonatomic, assign) float fromTrackPos;
@property (nonatomic, assign) float toTrackPos;
@property (nonatomic, assign) float fromTrackPosRadio;
@property (nonatomic, assign) float toTrackPosRadio;
@end

@interface BMFMapAlphaAnimation : BMFMapAnimation

@end

@interface BMFMapRotateAnimation : BMFMapAnimation

@end

@interface BMFMapScaleAnimation : BMFMapAnimation

@end

@interface BMFMapTranslateAnimation : BMFMapAnimation

@end

@interface BMFMapTrackAnimation : BMFMapAnimation

@end

@interface BMFMapAnimationSet : BMFMapAnimation
@property (nonatomic, copy) NSArray<BMFMapAnimation *> *animationList;
@property (nonatomic, copy) NSArray<NSNumber *> *animationOrderTypeList;
@end

NS_ASSUME_NONNULL_END
