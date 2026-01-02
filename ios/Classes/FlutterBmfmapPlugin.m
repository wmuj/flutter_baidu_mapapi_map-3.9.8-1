#import "FlutterBmfmapPlugin.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BMFMapViewController.h"
#import "BMFFileManager.h"
#import "BMFOfflineMapManager.h"



//static NSString *kBMFMapIdentifier = @"flutter_bmfmap/map/BMKMapView";
@interface FlutterBmfmapPlugin ()


@end

@implementation FlutterBmfmapPlugin
/// 注册
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // 初始化BMFFileManagerCenter
    [BMFFileManager defaultCenter].registar = registrar;
    
    // mapView
    [registrar registerViewFactory:[[FlutterMapViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"flutter_bmfmap/map/BMKMapView"];
    
    // 离线地图
    [BMFOfflineMapManager registerWithRegistrar:registrar];

    FlutterMethodChannel *versionChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_bmfmap"
                                                                binaryMessenger:[registrar messenger]];
    FlutterBmfmapPlugin *instance = [[FlutterBmfmapPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:versionChannel];
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"flutter_bmfmap/map/getNativeMapVersion"]) {
        
        result(@{@"platform" : @"ios", @"component" : @"map", @"version" : BMKGetMapApiMapComponentVersion()});
    } else {
        
        result(FlutterMethodNotImplemented);
    }
}
@end
