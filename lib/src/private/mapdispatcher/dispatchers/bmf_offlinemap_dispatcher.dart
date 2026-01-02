import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_offline_models.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFOfflineMethodId;

/// 离线地图处理类
class BMFOfflineMapDispatcher {
  /// 初始化
  ///
  /// 调用离线接口之前必须先初始化
  Future<bool> initOfflineMap(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFOfflineMethodId.kMapInitOfflineMethod)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 启动下载指定城市ID的离线地图，或在暂停更新某城市后继续更新下载某城市离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> startOfflineMap(MethodChannel _mapChannel, int cityID) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(cityID, "cityID");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFOfflineMethodId.kMapStartOfflineMethod, {"cityID": cityID}))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 启动更新指定城市ID的离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> updateOfflineMap(MethodChannel _mapChannel, int cityID) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(cityID, "cityID");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFOfflineMethodId.kMapUpdateOfflineMethod, {"cityID": cityID}))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 暂停下载或更新指定城市ID的离线地图
  ///
  /// cityID 指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> pauseOfflineMap(MethodChannel _mapChannel, int cityID) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(cityID, "cityID");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFOfflineMethodId.kMapPauseOfflineMethod, {"cityID": cityID}))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 删除指定城市ID的离线地图
  ///
  /// cityID 指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> removeOfflineMap(MethodChannel _mapChannel, int cityID) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(cityID, "cityID");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFOfflineMethodId.kMapRemoveOfflineMethod, {"cityID": cityID}))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 返回热门城市列表
  Future<List<BMFOfflineCityRecord>?> getHotCityList(
      MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    List<BMFOfflineCityRecord>? result;
    try {
      Map? map = (await _mapChannel
          .invokeMethod(BMFOfflineMethodId.kMapGetHotCityListMethod) as Map?);
      if (null == map) {
        return null;
      }
      List? list = map["searchCityRecord"] as List?;
      result = list?.map((city) => BMFOfflineCityRecord.fromMap(city)).toList();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 返回支持离线地图城市列表
  Future<List<BMFOfflineCityRecord>?> getOfflineCityList(
      MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    List<BMFOfflineCityRecord>? result;
    try {
      Map? map = (await _mapChannel.invokeMethod(
          BMFOfflineMethodId.kMapGetOfflineCityListMethod) as Map?);
      if (null == map) {
        return null;
      }
      List? list = map["searchCityRecord"] as List?;
      result = list?.map((city) => BMFOfflineCityRecord.fromMap(city)).toList();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 根据城市名搜索该城市离线地图记录
  ///
  /// cityName 城市名
  Future<List<BMFOfflineCityRecord>?> searchCity(
      MethodChannel _mapChannel, String cityName) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(cityName, "cityName");

    List<BMFOfflineCityRecord>? result;
    try {
      Map? map = (await _mapChannel.invokeMethod(
              BMFOfflineMethodId.kMapSearchCityMethod, {'cityName': cityName})
          as Map?);
      if (null == map) {
        return null;
      }
      List? list = map["searchCityRecord"] as List?;
      result = list?.map((city) => BMFOfflineCityRecord.fromMap(city)).toList();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 返回各城市离线地图更新信息
  Future<List<BMFUpdateElement>?> getAllUpdateInfo(
      MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    List<BMFUpdateElement>? result;
    try {
      Map? map = (await _mapChannel
          .invokeMethod(BMFOfflineMethodId.kMapGetAllUpdateInfoMethod) as Map?);
      if (null == map) {
        return null;
      }
      List? list = map["updateElements"] as List?;
      result =
          list?.map((element) => BMFUpdateElement.fromMap(element)).toList();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 返回指定城市ID离线地图更新信息
  ///
  /// id 城市id
  Future<BMFUpdateElement?> getUpdateInfo(
      MethodChannel _mapChannel, int id) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFUpdateElement? result;
    try {
      Map? map = (await _mapChannel.invokeMethod(
          BMFOfflineMethodId.kMapGetUpdateInfoMethod, {"cityID": id}) as Map?);
      if (null == map) {
        return null;
      }
      result = BMFUpdateElement.fromMap(map);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 销毁离线地图管理模块，不用时调用
  Future<bool> destroyOfflineMap(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFOfflineMethodId.kMapDestroyOfflineMethod)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
