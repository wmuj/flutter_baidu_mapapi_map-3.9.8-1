//
//  BMFMapViewController.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/6.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMFMapViewController : NSObject<FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end


@interface FlutterMapViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager;

@end

NS_ASSUME_NONNULL_END
