import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_particleeffect_option.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFParticleEffectMethId;

class BMFParticleEffectDispatcher {
  /// 显示粒子效果
  Future<bool> showParticleEffect(
      MethodChannel _mapChannel, BMFParticleEffectType effect) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFParticleEffectMethId.kShowMapParticleEffectMethod,
          {'effect': effect.value} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 关闭粒子效果
  Future<bool> closeParticleEffect(
      MethodChannel _mapChannel, BMFParticleEffectType effect) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFParticleEffectMethId.kCloseMapParticleEffectMethod,
          {'effect': effect.value} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 自定义粒子效果
  Future<bool> customParticleEffect(MethodChannel _mapChannel,
      BMFParticleEffectType effect, BMFParticleEffectOption option) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFParticleEffectMethId.kCustomMapParticleEffectMethod,
              {'effect': effect.value, 'option': option.toMap()} as dynamic))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
