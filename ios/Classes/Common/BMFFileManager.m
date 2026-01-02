//
//  BMFFileManager.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/12.
//

#import "BMFFileManager.h"

@implementation BMFFileManager

static BMFFileManager *_instance = nil;
+ (instancetype)defaultCenter {
    return [[BMFFileManager alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
     @synchronized(self) { // 同步
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
 
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}

/// 获取flutter端图片资源路径
- (nullable NSString *)pathForFlutterImageName:(nullable NSString *)imageName {
    if (!_registar || !imageName) return nil;
    return [[NSBundle mainBundle] pathForResource:[_registar lookupKeyForAsset:imageName] ofType:nil];
}
/// 获取flutter端文件资源路径
- (nullable NSString *)pathForFlutterFileName:(nullable NSString *)fileName {
    if (!_registar || !fileName) return nil;
    return [[NSBundle mainBundle] pathForResource:[_registar lookupKeyForAsset:fileName] ofType:nil];
}

/// 获取flutter端瓦片图路径
- (nullable NSString *)pathForFlutterTileResources:(nullable NSString *)tileName {
    if (!_registar || !tileName) return nil;
    // 指定resoures/bmflocaltileimage/目录下存放瓦片图资源
    return [[NSBundle mainBundle] pathForResource:[_registar lookupKeyForAsset:[NSString stringWithFormat:@"resoures/bmflocaltileimage/%@", tileName]] ofType:nil];
}

@end
