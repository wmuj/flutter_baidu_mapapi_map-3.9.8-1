//
//  BMFMultiPointOverlay.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import "BMFMultiPointOverlay.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *multiPointOverlayModelKey = &multiPointOverlayModelKey;

@implementation BMKMultiPointOverlay (BMFMultiPointOverlay)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;
    
    BMFMultiPointOverlayModel *model = [BMFMultiPointOverlayModel bmf_modelWith:dic];
    if (model.items.count <= 0) return nil;
    
    NSMutableArray<BMKMultiPointItem *> *items = [NSMutableArray array];
    for (BMFMultiPointItem *item in model.items) {
        [items addObject:[item toBMKMultiPointItem]];
    }
    BMKMultiPointOverlay *overlay = [BMKMultiPointOverlay multiPointOverlayWithMultiPointItems:items];
    overlay.flutterModel = model;
    return overlay;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, multiPointOverlayModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, multiPointOverlayModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

