import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart';

/// 获取原生地图Map组件版权信息 since 3.3.0
class BMFMapCopyrightInfoDispatcher {
  /// 获取原生地图map组件版权信息 since 3.3.0
  Future<Map?> getNativeMapCopyright(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    Map? result;
    try {
      result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapCopyrightInformationMethod) as Map?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 获取原生地图map组件测绘资质 since 3.3.0
  Future<Map?> getNativeMapQualification(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    Map? result;
    try {
      result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapMappingQualificationMethod) as Map?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 获取原生地图map组件审图号 since 3.3.0
  Future<Map?> getNativeMapApprovalNumber(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    Map? result;
    try {
      result = await _mapChannel.invokeMethod(
        BMFMapGetPropertyMethodId.kMapApprovalNumberMethod,
      ) as Map?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
