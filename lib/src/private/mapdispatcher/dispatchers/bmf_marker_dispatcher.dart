import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFMarkerMethodId, BMFInfoWindowMethodId;

/// marker处理类
class BMFMarkerDispatcher {
  /// 地图添加Marker
  Future<bool> addMarker(MethodChannel _mapChannel, BMFMarker marker) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(marker, "marker");

    marker.methodChannel = _mapChannel;

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFMarkerMethodId.kMapAddMarkerMethod, marker.toMap() as dynamic))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 批量添加markers
  Future<bool> addMarkers(
      MethodChannel _mapChannel, List<BMFMarker> markers) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(markers, "markers");

    markers.forEach((marker) {
      marker.methodChannel = _mapChannel;
    });

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapAddMarkersMethod,
          markers.map((marker) => marker.toMap()).toList() as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 添加InfoWindow
  Future<bool> addInfoWindow(
      MethodChannel _mapChannel, BMFInfoWindow infoWindow) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(infoWindow, "infoWindow");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFInfoWindowMethodId.kMapAddInfoWindowMethod,
          infoWindow.toMap() as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 批量添加InfoWindow
  Future<bool> addInfoWindows(
      MethodChannel _mapChannel, List<BMFInfoWindow> infoWindows) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(infoWindows, "infoWindows");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFInfoWindowMethodId.kMapAddInfoWindowsMethod,
              infoWindows.map((infoWindow) => infoWindow.toMap()).toList()))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 批量添加markers
  Future<bool> removeInfoWindow(
      MethodChannel _mapChannel, BMFInfoWindow infoWindow) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(infoWindow, "infoWindow");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFInfoWindowMethodId.kMapRemoveInfoWindowMethod,
          infoWindow.toMap() as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// map 指定删除marker
  Future<bool> removeMarker(MethodChannel _mapChannel, BMFMarker marker) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(marker, "marker");

    bool result = false;

    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapRemoveMarkerMethod, marker.toMap())) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 批量删除markers
  Future<bool> removeMarkers(
      MethodChannel _mapChannel, List<BMFMarker> markers) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(markers, "markers");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapRemoveMarkersMethod,
          markers.map((marker) => marker.toMap()).toList() as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// map 清除所有的markers
  Future<bool> cleanAllMarkers(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFMarkerMethodId.kMapCleanAllMarkersMethod)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 选中marker
  ///
  /// bool 成功返回true 失败false
  Future<bool> selectMarker(MethodChannel _mapChannel, BMFMarker marker) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(marker, "marker");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapSelectMarkerMethod, marker.toMap())) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 取消指定的marker的选中状态
  ///
  /// bool 成功返回true 失败false
  Future<bool> deselectMarker(
      MethodChannel _mapChannel, BMFMarker marker) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(marker, "marker");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapDeselectMarkerMethod, marker.toMap())) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 更新marker属性
  Future<bool> updateMarkerMember(MethodChannel _mapChannel, Map map) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(map, "map");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapUpdateMarkerMember, map)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置地图使显示区域显示所有markers （iOS）since 3.1.0
  ///
  /// 如果数组中只有一个则直接设置地图中心为marker的位置
  /// markers 指定的marker数组
  /// animated 是否启动动画
  Future<bool> showmarkers(MethodChannel _mapChannel, List<BMFMarker> markers,
      bool animated, EdgeInsets? insets) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(markers, "markers");
    ArgumentError.checkNotNull(animated, "animated");
    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMarkerMethodId.kMapShowMarkersMethod,
          {
            'markers': markers.map((marker) => marker.toMap()).toList(),
            'animated': animated,
            'insets': insets != null
                ? BMFEdgeInsets.fromEdgeInsets(insets).toMap()
                : null,
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
