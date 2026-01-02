//
//  BMFFileManager.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/12.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMFFileManager : NSObject

/// registar
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registar;

/// BMFFileManagerCenter
+ (instancetype)defaultCenter;

/// 获取flutter端图片资源路径
- (nullable NSString *)pathForFlutterImageName:(nullable NSString *)imageName;

/// 获取flutter端文件资源路径
- (nullable NSString *)pathForFlutterFileName:(nullable NSString *)fileName;

/// 获取flutter端瓦片图路径
- (nullable NSString *)pathForFlutterTileResources:(nullable NSString *)tileName;

@end

NS_ASSUME_NONNULL_END
