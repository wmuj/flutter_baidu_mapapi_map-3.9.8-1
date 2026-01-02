import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, BMFPoint, BMFLog;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFProjectionMethodId;

/// 接口用于屏幕像素点坐标系统和地球表面经纬度点坐标系统之间的变换。
class BMFProjectionDispatcher {
  /// 将屏幕坐标转换成地理坐标 since 3.1.0
  ///
  /// [BMFPoint] point 屏幕坐标 如果传入null 则返回null
  ///
  /// [BMFCoordinate] 地理坐标
  Future<BMFCoordinate?> convertScreenPointToCoordinate(
      MethodChannel _mapChannel, BMFPoint point) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(point, "point");

    BMFCoordinate? result;
    try {
      Map map = (await _mapChannel.invokeMethod(
          BMFProjectionMethodId.kCoordinateFromScreenPointMethod,
          {'point': point.toMap()} as dynamic)) as Map;
      if (map['coordinate'] != null) {
        result = BMFCoordinate.fromMap(map['coordinate']);
      }
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return result;
  }

  /// 将地理坐标转换成屏幕坐标 since 3.1.0
  ///
  /// [BMFCoordinate] location 地理坐标 如果传入 null 则返回null
  ///
  /// [BMFPoint] 屏幕坐标
  Future<BMFPoint?> convertCoordinateToScreenPoint(
      MethodChannel _mapChannel, BMFCoordinate location) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(location, "location");

    BMFPoint? point;
    try {
      Map map = ((await _mapChannel.invokeMethod(
          BMFProjectionMethodId.kScreenPointFromCoordinateMethod,
          {'coordinate': location.toMap()} as dynamic))) as Map;
      if (map['point'] != null) {
        point = BMFPoint.fromMap(map['point']);
      }
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return point;
  }

  /// 将三维坐标转化为屏幕坐标 since 3.3.0
  ///
  /// [BMFCoordinate] location 地理坐标
  ///
  /// [double] height 高度
  ///
  /// [BMFPoint] 屏幕坐标
  Future<BMFPoint?> convertScreenPointFromMapPoint3(
      MethodChannel _mapChannel, BMFCoordinate location, double height) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(location, "location");
    ArgumentError.checkNotNull(height, "height");

    BMFPoint? point;
    try {
      Map map = ((await _mapChannel.invokeMethod(
              BMFProjectionMethodId.kScreenPointFromMapPoint3Method,
              {'coordinate': location.toMap(), 'height': height} as dynamic)))
          as Map;
      if (map['point'] != null) {
        point = BMFPoint.fromMap(map['point']);
      }
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return point;
  }
}
