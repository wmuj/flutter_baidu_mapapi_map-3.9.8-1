//
//  BMFParticleEffectModel.h
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2023/8/18.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class BMFCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface BMFParticleEffectModel : BMFModel
/// 自定义粒子图片列表，图片列表需按如下要求顺序传入：
/// 不同类型粒子效果图片定义列表及参考图片尺寸（2倍图）
/// BMKMapParticleEffectSnow：[雪点图片16*16，雪花图片32*32]
/// BMKMapParticleEffectRainStorm：[雨点图片4*32，乌云图片128*64]
/// BMKMapParticleEffectSmog：[雾霾图片32*32]
/// BMKMapParticleEffectSandStorm：[沙尘图片32*32，沙粒图片4*4]
/// BMKMapParticleEffectFireworks：[烟花图片32*32]
/// BMKMapParticleEffectFlower：[花瓣图片32*32]
@property(nonatomic, strong) NSArray <NSString *> *images;

/// 点发射器发射位置，目前仅支持烟花粒子,默认为无效值，发射位置始终为地图中心点
@property(nonatomic, strong) BMFCoordinate *location;

- (BMKParticleEffectOption *)toEffecyOption;

@end

NS_ASSUME_NONNULL_END
