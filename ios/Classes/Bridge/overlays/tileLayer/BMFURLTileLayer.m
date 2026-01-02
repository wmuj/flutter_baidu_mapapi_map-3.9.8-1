//
//  BMFURLTileLayer.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#import "BMFURLTileLayer.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>

#import "BMFTileModel.h"

@interface BMFURLTileLayer ()

/// 唯一id
@property (nonatomic, copy, readwrite) NSString *Id;

@end

@implementation BMFURLTileLayer

+ (nullable instancetype)urlTileLayerWith:(BMFTileModel *)model {
    if (!model.Id || !model.tileOptions || !model.tileOptions.url) {
        return nil;
    }
    BMFURLTileLayer *urlTileLayer = [[BMFURLTileLayer alloc] initWithURLTemplate:model.tileOptions.url];
    urlTileLayer.Id = model.Id;
    urlTileLayer.maxZoom = model.maxZoom;
    urlTileLayer.minZoom = model.minZoom;
    urlTileLayer.visibleMapRect = [model.visibleMapBounds toBMKMapRect];
    return urlTileLayer;
}
@end
