//
//  BMFTileModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFTileModelOptions;
@class BMFTileProvider;
@class BMFCoordinateBounds;

typedef NS_ENUM(NSUInteger, BMFTileLoadType) {
    kBMFTileLoadUrl = 0,       ///< 网络加载
    kBMFTileLoadLocalAsync,   ///< 本地异步加载
    kBMFTileLoadLocalSync,   ///<本地同步加载
};

NS_ASSUME_NONNULL_BEGIN

@interface BMFTileModel : BMFModel

/// 唯一id
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// tileLayer的可见最小Zoom值，默认3
@property (nonatomic, assign) NSInteger minZoom;

/// tileLayer的可见最大Zoom值，默认21，且不能小于minZoom
@property (nonatomic, assign) NSInteger maxZoom;

/// tileOverlay的可渲染区域，默认世界范围
@property (nonatomic, strong) BMFCoordinateBounds *visibleMapBounds;

/// 瓦片图缓存大小,android端需要，ios端暂时不需要
@property (nonatomic, assign) int maxTileTmp;

/// 参数集合
@property (nonatomic, strong) BMFTileModelOptions *tileOptions;

@end

@interface BMFTileModelOptions : BMFModel

/// 瓦片图加载方式
@property (nonatomic, assign) BMFTileLoadType tileLoadType;

/// url
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
