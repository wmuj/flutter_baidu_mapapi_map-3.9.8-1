//
//  BMF3DModelOverlay.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMF3DModelOverlay.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *flutterModelKey = &flutterModelKey;

@implementation BMK3DModelOverlay (BMF3DModelOverlay)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
    
    BMF3DModelOverlayModel *model = [BMF3DModelOverlayModel bmf_modelWith:dic];
    if (!model.center) return nil;
    
    BMK3DModelOverlay *overlay = [BMK3DModelOverlay modelOverlayWithCenterCoordinate:[model.center toCLLocationCoordinate2D] option:[model.option toBMK3DModelOption]];
    overlay.flutterModel = model;
    return overlay;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, flutterModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, flutterModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
