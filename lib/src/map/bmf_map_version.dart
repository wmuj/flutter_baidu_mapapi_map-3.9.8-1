import 'package:flutter/services.dart';

/// 获取原生地图Map组件版本号
@Deprecated('Use `BMFMapVersion` class instead since 3.2.0')
class BMFMapAPI_Map {
  /// 获取原生地图map组件版本号
  ///
  /// return 平台：xx 组件：xx 版本号：xx
  /// eg: {'platform':'ios', 'component': 'map', version':'6.0.0'}
  static Future<Map?> get nativeMapVersion async {
    Map? result;
    try {
      result = await MethodChannel('flutter_bmfmap')
          .invokeMethod('flutter_bmfmap/map/getNativeMapVersion') as Map?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}

/// 获取原生地图Map组件版本号 since 3.2.0
class BMFMapVersion {
  /// 获取原生地图map组件版本号
  ///
  /// return 平台：xx 组件：xx 版本号：xx
  /// eg: {'platform':'ios', 'component': 'map', version':'6.0.0'}
  static Future<Map?> get nativeMapVersion async {
    Map? result;
    try {
      result = await MethodChannel('flutter_bmfmap')
          .invokeMethod('flutter_bmfmap/map/getNativeMapVersion') as Map?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}

/// 获取android系统版本号
class BMFAndroidVersion {
  /// Android 系统版本是否小于10
  /// 默认false小于10，使用textureMapview渲染
  static bool mIsAndroidVersion = false;

  /// 获取Android 系统版本是否小于10
  static bool get getAndroidVersion => mIsAndroidVersion;

  /// 设置系统版本是否小于Android 10
  static set setAndroidVersion(bool isAndroidVersion) =>
      mIsAndroidVersion = isAndroidVersion;

  static const kGetAndroidVersion = 'flutter_bmfbase/sdk/getAndroidSdkVersion';

  /// 初始化时获取系统版本，适配BMFMapWidget在flutter sdk升级3.0之后兼容底版本手机问题。
  /// Andriod 10 以下手机上在使用BMFMapWidget的时，使用textureMapview渲染。
  /// Android 10 及以上机型则使用surfaceMapView渲染。
  /// 默认 mIsAndroidVersion 是false，使用textureMapview渲染
  static Future<void> initAndroidVersion() async {
    try {
      final int? sdkVersion = await MethodChannel('flutter_bmfbase')
          .invokeMethod(kGetAndroidVersion);
      print('Android SDK Version: $sdkVersion');
      if (sdkVersion! >= 29) {
        setAndroidVersion = true;
      } else {
        setAndroidVersion = false;
      }
    } on PlatformException catch (e) {
      print("Failed to get Android SDK version: '${e.message}'.");
    }
  }
}
