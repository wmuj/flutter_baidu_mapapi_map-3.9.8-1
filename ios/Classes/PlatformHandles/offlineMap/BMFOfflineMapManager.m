//
//  BMFOfflineMapManager.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import "BMFOfflineMapManager.h"
#import <flutter_baidu_mapapi_base/BMFDefine.h>
#import "BMFOfflineMapMethodConst.h"
#import "BMFOfflineMap.h"
#import "BMFOfflineMapHandles.h"

@interface BMFOfflineMapManager ()<BMKOfflineMapDelegate>

/// 离线地图类的实例
@property (nonatomic, strong) BMFOfflineMap *offlineMap;

@end
@implementation BMFOfflineMapManager

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *offlineChannel = [FlutterMethodChannel methodChannelWithName:kBMFOfflineMapChannelName binaryMessenger:[registrar messenger]];
    BMFOfflineMapManager *manager = [[BMFOfflineMapManager alloc] init];
    manager.channel = offlineChannel;
    [registrar addMethodCallDelegate:manager channel:offlineChannel];
}

// 通信回调
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    NSLog(@"ios-离线地图-method = %@ \n arguments = %@", call.method, call.arguments);
    if ([call.method isEqualToString:kBMFInitOfflineMapMethod]) {
        [self offlineMap];
        return;
    }
    BMFOfflineMapHandles *handleCenter = [BMFOfflineMapHandles defalutCenter];
    NSArray *methods = [[handleCenter offlineMapHandles] allKeys];
    
    if ([methods containsObject:call.method]) {
        __weak __typeof__(_offlineMap) weakOfflineMap = _offlineMap;
        NSObject<BMFOfflineMapHandle> *handler = [[NSClassFromString(handleCenter.offlineMapHandles[call.method]) new] initWith:weakOfflineMap];
        [handler handleMethodCall:call result:result];
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (BMFOfflineMap *)offlineMap {
    _offlineMap = [[BMFOfflineMap alloc] init];
    _offlineMap.delegate = self;
    return _offlineMap;
}
#pragma mark - BMKOfflineMapDelegate

- (void)onGetOfflineMapState:(int)type withState:(int)state {
//    NSLog(@"-ios-离线地图下载回调type = %d state = %d", type, state);
    if (!_channel) {
        return;
    }
    [_channel invokeMethod:kBMFOfflineMapCallBackMethod arguments:@{@"type": @(type),
                                                                    @"state": @(state)}];
}

@end
