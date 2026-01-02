//
//  BMFAsyncTileLayer.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#ifndef __BMFAsyncTileLayer__H__
#define __BMFAsyncTileLayer__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

@class BMFTileModel;

NS_ASSUME_NONNULL_BEGIN

@interface BMFAsyncTileLayer : BMKAsyncTileLayer

/// 唯一id
@property (nonatomic, copy, readonly) NSString *Id;

+ (nullable instancetype)asyncTileLayerWith:(BMFTileModel *)model;

@end

NS_ASSUME_NONNULL_END
