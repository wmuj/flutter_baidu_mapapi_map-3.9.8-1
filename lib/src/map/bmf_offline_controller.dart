// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_offline_models.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFOfflineMethodId;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_offlinemap_dispatcher.dart';

/// 通知事件回调方法
///
/// type: 事件类型，
///       取值为MKOfflineMap.TYPE_NEW_OFFLINE, MKOfflineMap.TYPE_DOWNLOAD_UPDATE,
///    MKOfflineMap.TYPE_VER_UPDATE.
///
/// state：事件状态；
///        当type为TYPE_NEW_OFFLINE时，表示新安装的离线地图数目；
///        当type为TYPE_DOWNLOAD_UPDATE时，表示更新的城市ID。
typedef BMFGetOfflineMapStateback = void Function(int? type, int? state);

class OfflineController {
  /// 新安装离线地图事件类型
  static const int TYPE_NEW_OFFLINE = 6;

  /// 离线地图下载更新事件类型
  static const int TYPE_DOWNLOAD_UPDATE = 0;

  /// 离线地图网络问题
  static const int TYPE_NETWORK_ERROR = 2;

  /// 离线地图数据版本更新事件类型
  static const int TYPE_VER_UPDATE = 4;

  late MethodChannel _channel;
  late BMFOfflineMapDispatcher _bmfOfflineMapDispatcher;
  BMFGetOfflineMapStateback? _bmfGetOfflineMapStateback;

  OfflineController() {
    _channel = MethodChannel('flutter_bmfmap/offlineMap');
    _bmfOfflineMapDispatcher = BMFOfflineMapDispatcher();
    _channel.setMethodCallHandler(_handlerMethod);
  }

  /// 初始化
  ///
  /// 调用离线接口之前必须先初始化
  ///
  /// 在某些Android机型上下载有问题
  Future<bool> init() async {
    return await _bmfOfflineMapDispatcher.initOfflineMap(_channel);
  }

  /// 启动下载指定城市ID的离线地图，或在暂停更新某城市后继续更新下载某城市离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> startOfflineMap(int cityID) async {
    return await _bmfOfflineMapDispatcher.startOfflineMap(_channel, cityID);
  }

  /// 启动更新指定城市ID的离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> updateOfflineMap(int cityID) async {
    return await _bmfOfflineMapDispatcher.updateOfflineMap(_channel, cityID);
  }

  /// 暂停下载或更新指定城市ID的离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> pauseOfflineMap(int cityID) async {
    return await _bmfOfflineMapDispatcher.pauseOfflineMap(_channel, cityID);
  }

  /// 删除指定城市ID的离线地图
  ///
  /// cityID  指定的城市ID
  /// 成功返回true，否则返回false
  Future<bool> removeOfflineMap(int cityID) async {
    return await _bmfOfflineMapDispatcher.removeOfflineMap(_channel, cityID);
  }

  /// 销毁离线地图管理模块，不用时调用
  Future<bool> destroyOfflineMap() async {
    return await _bmfOfflineMapDispatcher.destroyOfflineMap(_channel);
  }

  /// 返回热门城市列表
  Future<List<BMFOfflineCityRecord>?> getHotCityList() async {
    return await _bmfOfflineMapDispatcher.getHotCityList(_channel);
  }

  /// 返回支持离线地图城市列表
  Future<List<BMFOfflineCityRecord>?> getOfflineCityList() async {
    return await _bmfOfflineMapDispatcher.getOfflineCityList(_channel);
  }

  /// 根据城市名搜索该城市离线地图记录
  Future<List<BMFOfflineCityRecord>?> searchCity(String cityName) async {
    return await _bmfOfflineMapDispatcher.searchCity(_channel, cityName);
  }

  /// 返回各城市离线地图更新信息
  Future<List<BMFUpdateElement>?> getAllUpdateInfo() async {
    return await _bmfOfflineMapDispatcher.getAllUpdateInfo(_channel);
  }

  /// 返回指定城市ID离线地图更新信息
  ///
  /// id 城市id
  Future<BMFUpdateElement?> getUpdateInfo(int id) async {
    return await _bmfOfflineMapDispatcher.getUpdateInfo(_channel, id);
  }

  /// 返回通知事件
  void onGetOfflineMapStateBack({required BMFGetOfflineMapStateback callback}) {
    if (_bmfGetOfflineMapStateback != null || callback == null) {
      return;
    }
    this._bmfGetOfflineMapStateback = callback;
  }

  Future<dynamic> _handlerMethod(MethodCall call) async {
    String method = call.method;
    if (null == method || null == this._bmfGetOfflineMapStateback) {
      return;
    }
    if (method == BMFOfflineMethodId.kMapOfflineCallBackMethod) {
      int? type = await call.arguments['type'];
      int? state = await call.arguments['state'];
      this._bmfGetOfflineMapStateback!(type, state);
    }
  }
}
