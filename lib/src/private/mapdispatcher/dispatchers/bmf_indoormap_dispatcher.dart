import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_baseindoormap_info.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFBaseIndoorMapMethodId;

/// 室内图相关操作
class BMFIndoorMapDispatcher {
  /// 是否展示室内地图
  Future<bool> showBaseIndoorMap(MethodChannel _mapChannel, bool show) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(show, "show");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFBaseIndoorMapMethodId.kShowBaseIndoorMapMethod,
          {'show': show} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 室内图标注是否显示
  Future<bool> showBaseIndoorMapPoi(
      MethodChannel _mapChannel, bool showPoi) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(showPoi, "showPoi");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFBaseIndoorMapMethodId.kShowBaseIndoorMapPoiMethod,
          {'showIndoorPoi': showPoi} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置室内图楼层
  ///
  /// floorId 楼层id
  /// indoorId 室内图ID
  Future<BMFSwitchIndoorFloorError> switchBaseIndoorMapFloor(
      MethodChannel _mapChannel, String floorId, String indoorId) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(floorId, "floorId");
    ArgumentError.checkNotNull(indoorId, "indoorId");

    BMFSwitchIndoorFloorError result = BMFSwitchIndoorFloorError.Failed;

    try {
      Map map = (await _mapChannel.invokeMethod(
          BMFBaseIndoorMapMethodId.kSwitchBaseIndoorMapFloorMethod,
          {'floorId': floorId, 'indoorId': indoorId} as dynamic)) as Map;
      result = BMFSwitchIndoorFloorError.values[map['result'] as int];
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 获取当前聚焦的室内图信息
  ///
  /// 当前聚焦的室内图信息。没有聚焦的室内图，返回nil
  Future<BMFBaseIndoorMapInfo?> getFocusedBaseIndoorMapInfo(
      MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFBaseIndoorMapInfo? result;
    try {
      Map map = (await _mapChannel.invokeMethod(
          BMFBaseIndoorMapMethodId.kGetFocusedBaseIndoorMapInfo)) as Map;
      result = BMFBaseIndoorMapInfo.fromMap(map);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return result;
  }
}
