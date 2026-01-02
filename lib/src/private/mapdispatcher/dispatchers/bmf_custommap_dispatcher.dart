import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_custommap_option.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFCustomMapStyleMethodId;

/// 个性化地图相关操作
class BMFCustomMapDispatcher {
  /// 个性化地图样式开关，仅影响当前mapView对象，需���对象创建后调用
  ///
  /// enable 当前自定义地图样式是否生效
  Future<bool> setCustomMapStyleEnable(
      MethodChannel _mapChannel, bool enable) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFCustomMapStyleMethodId.kSetCustomMapStyleEnableMethod,
          {'enable': enable} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置个性化地图样式路径，仅影响当前mapView对象，需在���象创建后调用
  /// customMapStyleJsonFilePath 本地个性化样式文件所在路径，包含文件名
  /// mode 加载模式，0:加载本地文件 1:加载在线文件或在线缓存文件
  Future<bool> setCustomMapStylePath(
      MethodChannel _mapChannel, String path, int mode) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFCustomMapStyleMethodId.kSetCustomMapStylePathMethod,
          {'path': path, 'mode': mode} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  ///  在线个性化样式加载接口。
  /// option 在线个性化样式配置选项
  Future<bool> setCustomMapStyleWithOption(
      MethodChannel _mapChannel,
      BMFCustomMapStyleOption customMapStyleOption,
      void Function(String? path) preload,
      void Function(String? path) success,
      void Function(int? errorCode, String? path) error) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(customMapStyleOption, "customMapStyleOption");

    bool result = false;
    try {
      Map? map = (await _mapChannel.invokeMethod(
          BMFCustomMapStyleMethodId.kSetCustomMapStyleWithOptionMethod,
          {'customMapStyleOption': customMapStyleOption.toMap()}
              as dynamic)) as Map?;
      result = map != null;
      if (map != null) {
        // ignore: unnecessary_null_comparison
        if (preload != null && map['preloadPath'] != null) {
          preload(map['preloadPath']);
        }
        // ignore: unnecessary_null_comparison
        if (success != null && map['successPath'] != null) {
          success(map['successPath']);
        }
        // ignore: unnecessary_null_comparison
        if (error != null && map['errorCode'] != null) {
          error(map['errorCode'] as int?, map['errorPath']);
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
