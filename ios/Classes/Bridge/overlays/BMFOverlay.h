//
//  BMFOverlay.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <Foundation/Foundation.h>

@class BMFModel;

NS_ASSUME_NONNULL_BEGIN

/// FlutterOVerlay协议
@protocol BMFOverlay <NSObject>

@required

/// overlay对应的flutterModel
@property (nonatomic, readonly) BMFModel *flutterModel;

/// FlutterOverlay统一构造方法
+ (nullable instancetype)overlayWithDictionary:(nullable NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
