//
//  BMFAsyncTileLayer.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#import "BMFAsyncTileLayer.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

#import "BMFTileModel.h"
#import "BMFFileManager.h"

@interface BMFAsyncTileLayer ()

/// 唯一id
@property (nonatomic, copy, readwrite) NSString *Id;

@end

@implementation BMFAsyncTileLayer

+ (nullable instancetype)asyncTileLayerWith:(BMFTileModel *)model {
    if (!model.Id || !model.tileOptions) {
        return nil;
    }
    
    BMFAsyncTileLayer *tileLayer = [BMFAsyncTileLayer new];
    tileLayer.Id = model.Id;
    tileLayer.maxZoom = model.maxZoom;
    tileLayer.minZoom = model.minZoom;
    tileLayer.visibleMapRect = [model.visibleMapBounds toBMKMapRect];
    return tileLayer;
}

/// 通过异步方法获取瓦片数据
/// x 瓦片图层x坐标
/// y 瓦片图层y坐标
/// zoom 瓦片图层的比例尺大小
/// result block回调：(x, y, zoom）对应瓦片的UIImage对象和error信息
- (void)loadTileForX:(NSInteger)x y:(NSInteger)y zoom:(NSInteger)zoom result:(void (^)(UIImage *tileImage, NSError *error))result {
    // 拼接图片名称
    NSString *imageName = [NSString stringWithFormat:@"%ld_%ld_%ld.jpg", (long)zoom, (long)x, (long)y];
    // 此处应拼接flutter端瓦片图资源路径
    NSString *path = [NSString stringWithFormat:@"%ld/%@", (long)zoom, imageName];
    // 最终瓦片图路径
    path = [[BMFFileManager defaultCenter] pathForFlutterTileResources:path];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    result(image, nil);
}
@end
