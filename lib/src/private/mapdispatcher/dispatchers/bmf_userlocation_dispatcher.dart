import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_userlocation.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFUserlocationMethodId;

/// 地图定位图层
class BMFMapUserLocationDispatcher {
  /// 设定是否显示定位图层
  Future<bool> setShowUserLocation(MethodChannel _mapChannel, bool show) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(show, "show");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFUserlocationMethodId.kMapShowUserLocationMethod,
          {'show': show} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设定定位模式，取值为：BMFUserTrackingMode
  ///
  /// enableDirection  是否允许显示方向信息 (Android) 生效
  /// customMarker  设置用户自定义定位图标，可以为 null (Android)生效
  Future<bool> setUserTrackingMode(MethodChannel _mapChannel,
      BMFUserTrackingMode userTrackingMode, bool enableDirection,
      {String? customMarker}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(userTrackingMode, "userTrackingMode");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFUserlocationMethodId.kMapUserTrackingModeMethod,
          {
            'userTrackingMode': userTrackingMode.index,
            'enableDirection': enableDirection,
            'customMarker': customMarker
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 定位坐标点是否在当前地图可视区域内
  Future<bool> setIsUserLocationVisible(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      Map map = (await _mapChannel.invokeMethod(
          BMFUserlocationMethodId.kMapShowUserLocationMethod)) as Map;
      result = map['userLocationVisible'] as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 动态更新我的位置数据
  ///
  /// userLocation	定位数据
  Future<bool> setUpdateLocationData(
      MethodChannel _mapChannel, BMFUserLocation userLocation) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(userLocation, "userLocation");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFUserlocationMethodId.kMapUpdateLocationDataMethod,
          {'userLocation': userLocation.toMap()} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 动态定制我的位置样式
  ///
  /// userlocationDisplayParam	样式参数
  Future<bool> setUpdateLocationViewWithParam(MethodChannel _mapChannel,
      BMFUserLocationDisplayParam userlocationDisplayParam) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(
        userlocationDisplayParam, "userlocationDisplayParam");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFUserlocationMethodId.kMapUpdateLocationDisplayParamMethod,
          {'userlocationDisplayParam': userlocationDisplayParam.toMap()}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
