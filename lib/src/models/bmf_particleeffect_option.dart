import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

class BMFParticleEffectOption implements BMFModel {
  /// 点发射器发射位置，目前仅支持烟花粒子,默认为无效值，发射位置始终为地图中心点
  BMFCoordinate? location;

  /// 自定义粒子图片列表，图片列表需按如下要求顺序传入：
  /// 不同类型粒子效果图片定义列表及参考图片尺寸（2倍图）
  /// Snow：[雪点图片16*16，雪花图片32*32]
  /// RainStorm：[雨点图片4*32，乌云图片128*64]
  /// Smog：[雾霾图片32*32]
  /// Storm：[沙尘图片32*32，沙粒图片4*4]
  /// Fireworks：[烟花图片32*32]
  /// Flower：[花瓣图片32*32]
  List<String>? images;

  BMFParticleEffectOption({
    this.location,
    this.images = const [],
  });

  BMFParticleEffectOption.fromMap(Map map)
      : assert(map['location'] != null),
        assert(map['images'] != null) {
    location =
        map['location'] == null ? null : BMFCoordinate.fromMap(map['location']);
    if (map['images'] != null) {
      images = <String>[];
      map['images'].forEach((v) {
        images!.add(v as String);
      });
    }
  }

  @override
  fromMap(Map map) {
    return BMFParticleEffectOption.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {'location': this.location?.toMap(), 'images': this.images};
  }
}
