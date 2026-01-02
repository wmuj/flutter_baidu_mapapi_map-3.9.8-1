//
//  BMF3DModelOverlayModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMF3DModelOverlayModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BMFFileManager.h"

@implementation BMF3DModelOverlayModel

+ (NSDictionary *)bmf_setupReplacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

@implementation BMF3DModelOption

- (nullable BMK3DModelOption *)toBMK3DModelOption {
    BMK3DModelOption *option = [[BMK3DModelOption alloc] init];
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
    return option;
}

@end
