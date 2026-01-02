//
//  BMFTraceOverlayModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFTraceOverlayModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BMFFileManager.h"

@implementation BMFTraceOverlayModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"coordinates" : @"BMFCoordinate",
             @"strokeColors" : @"NSString"};
}
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

@implementation BMFTraceOverlayOption

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"pointImage" : @"icon"};
}

- (nullable BMKTraceOverlayOption *)toBMKTraceOverlayOption {
    BMKTraceOverlayOption *option = [[BMKTraceOverlayOption alloc] init];
    option.animate = self.animate;
    option.delay = self.delay;
    option.duration = self.duration;
    option.easingCurve = self.easingCurve;
    option.fromValue = self.fromValue;
    option.toValue = self.toValue;
    option.trackMove = self.trackMove;
    option.isRotateWhenTrack = self.isRotateWhenTrack;
    option.pointImage = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:self.pointImage]];
    option.pointMove = self.isPointMove;
    option.modelOption = [self.modelOption toBMKTrace3dModelOption];
    return option;
}

@end


@implementation BMFTrace3DModelOption
+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"modelYawAxis" : @"yawAxis"};
}
- (nullable BMKTrace3DModelOption *)toBMKTrace3dModelOption {
    BMKTrace3DModelOption *option = [BMKTrace3DModelOption new];
    option.scale = self.scale;
    option.zoomFixed = self.zoomFixed;
    option.rotateX = self.rotateX;
    option.rotateY = self.rotateY;
    option.rotateZ = self.rotateZ;
    option.offsetX = self.offsetX;
    option.offsetY = self.offsetY;
    option.offsetZ = self.offsetZ;
    option.type = self.type;
    // 拼接路径
    option.modelPath = [[BMFFileManager defaultCenter] pathForFlutterFileName:self.modelPath];
    option.modelName = self.modelName;
    option.animationIsEnable = self.animationIsEnable;
    option.animationIndex = self.animationIndex;
    option.animationSpeed = self.animationSpeed;
    option.animationRepeatCount = self.animationRepeatCount;
    option.modelYawAxis = self.modelYawAxis;
    return option;
}

@end


