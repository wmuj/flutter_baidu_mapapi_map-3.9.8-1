//
//  BMFOfflineMapManager.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMFOfflineMapManager : NSObject <FlutterPlugin>

@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

NS_ASSUME_NONNULL_END
