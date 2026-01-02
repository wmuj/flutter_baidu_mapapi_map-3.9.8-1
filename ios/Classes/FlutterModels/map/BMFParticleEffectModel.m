//
//  BMFParticleEffectModel.m
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2023/8/18.
//

#import "BMFParticleEffectModel.h"
#import "BMFFileManager.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

@implementation BMFParticleEffectModel
+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"images" : @"NSString"};
}

- (BMKParticleEffectOption *)toEffecyOption {
    BMKParticleEffectOption *op = [BMKParticleEffectOption new];
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *path in self.images) {
        if (path && ![path isEqualToString:@""]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:path]];
            [imgs addObject:image];
        }
    }
    op.images = [imgs copy];
    op.location = [self.location toCLLocationCoordinate2D];

    return op;
}
@end
