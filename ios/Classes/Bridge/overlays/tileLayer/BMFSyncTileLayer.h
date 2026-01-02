//
//  BMFSyncTileLayer.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/20.
//

#ifndef __BMFSyncTileLayer__H__
#define __BMFSyncTileLayer__H__
#ifdef __OBJC__
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#endif
#endif

@class BMFTileModel;

NS_ASSUME_NONNULL_BEGIN

@interface BMFSyncTileLayer : BMKSyncTileLayer

/// 唯一id
@property (nonatomic, copy, readonly) NSString *Id;

+ (nullable instancetype)syncTileLayerWith:(BMFTileModel *)model;

@end

NS_ASSUME_NONNULL_END
