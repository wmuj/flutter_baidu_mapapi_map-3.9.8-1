//
//  BMFIconMarker.m
//  flutter_baidu_mapapi_map
//
//  Created by 王大川 on 2024/12/30.
//

#import "BMFIconMarker.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
#import "BMFMapAnimation.h"
#import "BMFFileManager.h"

static const void *iconMarkerModelKey = &iconMarkerModelKey;

@implementation BMKIconMarker (BMFIconMarker)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;

    BMFIconMarkerModel *model = [BMFIconMarkerModel bmf_modelWith:dic];
    if (!model.position || (!model.icon && !model.icons))  return nil;
    
    BMKIconMarker *icon = [[BMKIconMarker alloc] init];
    icon.coordinate = [model.position toCLLocationCoordinate2D];
    if (model.icon) {
        NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:model.icon];
        icon.icon = [UIImage imageWithContentsOfFile:imagePath];
    }

    if (model.icons && model.icons.count > 0) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSString *path in model.icons) {
            NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterImageName:path];
            UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
            [images addObject:img];
        }
        icon.icons = [images copy];
        
        [icon setIcons:icon.icons interval:model.interval repeatCnt:model.repeatCnt];
    }
    
    icon.color = [UIColor fromColorString:model.color];
    icon.animationType = (BMKMarkerAnimateType)model.animationType;
    icon.anchorX = model.anchorX;
    icon.anchorY = model.anchorY;
    icon.offsetX = model.offsetX;
    icon.offsetY = model.offsetY;
    icon.rotate = model.rotation;
    icon.scaleX = model.scaleX;
    icon.scaleY = model.anchorY;
    icon.perspective = model.isPerspective;
    if (model.fixXY) {
        icon.fixXY = [model.fixXY toCGPoint];
    }
    switch (model.collisionBehavior) {
        case 0:
            icon.collisionBehavior = BMKCollisionNotCollide;
            break;
        case 1:
            icon.collisionBehavior = BMKCollisionAlwaysShow;
            break;
        case 2:
            icon.collisionBehavior = BMKCollisionHideByPriority;
            break;
        case 3:
            icon.collisionBehavior = BMKCollisionWithInner;
            break;
        case 4:
            icon.collisionBehavior = BMKCollisionWithBasePoi;
            break;
        case 5:
            icon.collisionBehavior = BMKCollisionInnerAndBasePoi;
            break;
        case 6:
            icon.collisionBehavior = BMKDodgeWithInner;
            break;
        case 7:
            icon.collisionBehavior = BMKCollisionExceptSelf;
            break;
        case 8:
            icon.collisionBehavior = BMKCollisionWithAllLayersByPriority;
            break;
        default:
            break;
    }
    icon.collisionPriority = model.collisionPriority;
    icon.trackBy = model.trackMode;
    icon.opacity = model.opacity;
    icon.zIndex = model.zIndex;
    icon.visibility = BMKVisibilityVisible;
    
    if (model.animation) {
        
        BMFMapAnimation *animation = model.animation;
        BMKMapAnimation *mapAnimation;
        if ([animation.animationType isEqualToString:@"BMFMapRotateAnimation"]) {
            
            mapAnimation = [[BMKMapRotateAnimation alloc] initWithFromDegrees:animation.fromDegrees to:animation.toDegrees];
        } else if ([animation.animationType isEqualToString:@"BMFMapAlphaAnimation"]) {
            
            mapAnimation = [[BMKMapAlphaAnimation alloc] initWithFromAlpha:animation.fromAlpha to:animation.toAlpha];
        } else if ([animation.animationType isEqualToString:@"BMFMapScaleAnimation"]) {
            
            mapAnimation = [[BMKMapScaleAnimation alloc] initWithFromSizeScale:CGSizeMake(animation.fromScale.width, animation.fromScale.height) to:CGSizeMake(animation.toScale.width, animation.toScale.height)];
        } else if ([animation.animationType isEqualToString:@"BMFMapTranslateAnimation"]) {
            
            mapAnimation = [[BMKMapTranslateAnimation alloc] initWithFromPoint:[animation.fromTranslate toCLLocationCoordinate2D] to:[animation.toTranslate toCLLocationCoordinate2D]];
        } else if ([animation.animationType isEqualToString:@"BMFMapTrackAnimation"]) {
            NSLog(@"暂时还不支持TrackAnimation动画！");
        }
        mapAnimation.fillMode = animation.fillMode;
        mapAnimation.repeatMode = animation.repeatMode + 1;// flutter枚举类型默认是从0开始
        mapAnimation.extParam = animation.extParam;
        mapAnimation.startDelay = animation.startDelay;
        mapAnimation.startTime = animation.startTime;
        mapAnimation.duration = animation.duration;
        mapAnimation.repeatCount = animation.repeatCount;
        mapAnimation.interpolator = [BMKInterpolator interpolatorWithType:(BMKInterpolatorType)(animation.interpolator.interpolatorMode + 1)];

        icon.animation = mapAnimation;
    }
    
    if (model.animationSet) {
        
        BMKMapAnimationSet *mapAnimationSet = [[BMKMapAnimationSet alloc] init];

        BMFMapAnimationSet *animationSet = model.animationSet;
        for (int i = 0 ; i < animationSet.animationList.count; i++) {
            
            BMFMapAnimation *subAnimation = [animationSet.animationList objectAtIndex:i];
            BMKAnimationSetOrderType type = [[animationSet.animationOrderTypeList objectAtIndex:i] integerValue];
            
            if ([subAnimation.animationType isEqualToString:@"BMFMapRotateAnimation"]) {
                
                BMKMapRotateAnimation *rotateAnimation = [[BMKMapRotateAnimation alloc] initWithFromDegrees:subAnimation.fromDegrees to:subAnimation.toDegrees];
                rotateAnimation.fillMode = subAnimation.fillMode;
                rotateAnimation.repeatMode = subAnimation.repeatMode + 1;// flutter枚举类型默认是从0开始
                rotateAnimation.extParam = subAnimation.extParam;
                rotateAnimation.startDelay = subAnimation.startDelay;
                rotateAnimation.startTime = subAnimation.startTime;
                rotateAnimation.duration = subAnimation.duration;
                rotateAnimation.repeatCount = subAnimation.repeatCount;
                rotateAnimation.interpolator = [BMKInterpolator interpolatorWithType:(BMKInterpolatorType)(subAnimation.interpolator.interpolatorMode + 1)];
                [mapAnimationSet addAnimation:rotateAnimation addAnimationSetOrderType:type];
            } else if ([subAnimation.animationType isEqualToString:@"BMFMapAlphaAnimation"]) {
                
                BMKMapAlphaAnimation *alphaAnimation = [[BMKMapAlphaAnimation alloc] initWithFromAlpha:subAnimation.fromAlpha to:subAnimation.toAlpha];
                alphaAnimation.fillMode = subAnimation.fillMode;
                alphaAnimation.repeatMode = subAnimation.repeatMode + 1;// flutter枚举类型默认是从0开始
                alphaAnimation.extParam = subAnimation.extParam;
                alphaAnimation.startDelay = subAnimation.startDelay;
                alphaAnimation.startTime = subAnimation.startTime;
                alphaAnimation.duration = subAnimation.duration;
                alphaAnimation.repeatCount = subAnimation.repeatCount;
                alphaAnimation.interpolator = [BMKInterpolator interpolatorWithType:(BMKInterpolatorType)(subAnimation.interpolator.interpolatorMode + 1)];
                [mapAnimationSet addAnimation:alphaAnimation addAnimationSetOrderType:type];
            } else if ([subAnimation.animationType isEqualToString:@"BMFMapScaleAnimation"]) {
                
                BMKMapScaleAnimation *scaleAnimation = [[BMKMapScaleAnimation alloc] initWithFromSizeScale:CGSizeMake(subAnimation.fromScale.width, subAnimation.fromScale.height) to:CGSizeMake(subAnimation.toScale.width, subAnimation.toScale.height)];
                scaleAnimation.fillMode = subAnimation.fillMode;
                scaleAnimation.repeatMode = subAnimation.repeatMode + 1;// flutter枚举类型默认是从0开始
                scaleAnimation.extParam = subAnimation.extParam;
                scaleAnimation.startDelay = subAnimation.startDelay;
                scaleAnimation.startTime = subAnimation.startTime;
                scaleAnimation.duration = subAnimation.duration;
                scaleAnimation.repeatCount = subAnimation.repeatCount;
                scaleAnimation.interpolator = [BMKInterpolator interpolatorWithType:(BMKInterpolatorType)(subAnimation.interpolator.interpolatorMode + 1)];
                [mapAnimationSet addAnimation:scaleAnimation addAnimationSetOrderType:type];
            } else if ([subAnimation.animationType isEqualToString:@"BMFMapTranslateAnimation"]) {
                
                BMKMapTranslateAnimation *translateAnimation = [[BMKMapTranslateAnimation alloc] initWithFromPoint:[subAnimation.fromTranslate toCLLocationCoordinate2D] to:[subAnimation.toTranslate toCLLocationCoordinate2D]];
                translateAnimation.fillMode = subAnimation.fillMode;
                translateAnimation.repeatMode = subAnimation.repeatMode + 1;// flutter枚举类型默认是从0开始
                translateAnimation.extParam = subAnimation.extParam;
                translateAnimation.startDelay = subAnimation.startDelay;
                translateAnimation.startTime = subAnimation.startTime;
                translateAnimation.duration = subAnimation.duration;
                translateAnimation.repeatCount = subAnimation.repeatCount;
                translateAnimation.interpolator = [BMKInterpolator interpolatorWithType:(BMKInterpolatorType)(subAnimation.interpolator.interpolatorMode + 1)];
                [mapAnimationSet addAnimation:translateAnimation addAnimationSetOrderType:type];

            } else if ([subAnimation.animationType isEqualToString:@"BMFMapTrackAnimation"]) {
                NSLog(@"暂时还不支持TrackAnimation动画！");
            }
        }
        icon.animation = mapAnimationSet;
    }
    
    icon.flutterModel = model;
    return icon;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, iconMarkerModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, iconMarkerModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
