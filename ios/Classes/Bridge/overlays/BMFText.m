//
//  BMFText.m
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2022/9/13.
//

#import "BMFText.h"
#import <objc/runtime.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

static const void *textModelKey = &textModelKey;

@implementation BMKText (BMFText)

+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic {
    if (!dic) return nil;

    BMFTextModel *model = [BMFTextModel bmf_modelWith:dic];
    if (!model.position)  return nil;
    
    BMKText *text = [BMKText textWithCenterCoordinate:[model.position toCLLocationCoordinate2D] text:model.text];
    text.flutterModel = model;

    return text;
}

- (BMFModel *)flutterModel {
    return objc_getAssociatedObject(self, textModelKey);
}

- (void)setFlutterModel:(BMFModel * _Nonnull)flutterModel {
    objc_setAssociatedObject(self, textModelKey, flutterModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
