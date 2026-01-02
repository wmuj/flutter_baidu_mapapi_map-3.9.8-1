//
//  BMFOfflineMapHandle.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import <Flutter/Flutter.h>

@class BMFOfflineMap;

NS_ASSUME_NONNULL_BEGIN

@protocol BMFOfflineMapHandle <NSObject>

@required

/// offlineMap(弱引用)
@property(nonatomic, weak) BMFOfflineMap *_offlineMap;

/// 创建协议实例
- (NSObject <BMFOfflineMapHandle> *)initWith:(BMFOfflineMap *)offlineMap;

/// flutter --> ios
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

@end


NS_ASSUME_NONNULL_END
