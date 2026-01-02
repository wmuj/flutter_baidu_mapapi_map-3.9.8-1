import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart';
import 'dart:isolate';
import 'dart:async';

class BMFClusterMarkerDispatcher {
  Future<bool> setClusterVisible(MethodChannel _mapChannel,
      bool isClusterVisible, bool shouldRefreshCluster) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(isClusterVisible, "isClusterVisible");
    ArgumentError.checkNotNull(shouldRefreshCluster, "shouldRefreshCluster");

    bool result = false;

    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kSetClusterVisibleMethod,
          {'method': 'set', 'isClusterVisible': isClusterVisible,
          'shouldRefreshCluster': shouldRefreshCluster}
          as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future<bool> getClusterVisible(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kGetClusterVisibleMethod,
          {'method': 'get'}
          as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<bool> setClusterCoordinates(MethodChannel _mapChannel,
      List<BMFClusterInfo> clusterInfos) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(clusterInfos, "clusterInfos");

    /// 1000 个点以内直接处理，超过则使用 isolate 处理
    if (clusterInfos.length <= 1000) {
      return await _setClusterCoordinatesDirect(_mapChannel, clusterInfos);
    } else {
      return await _setClusterCoordinatesWithIsolate(_mapChannel, clusterInfos);
    }
  }

  Future<bool> _setClusterCoordinatesDirect(MethodChannel _mapChannel,
      List<BMFClusterInfo> clusterInfos) async {
    try {

      final convertedData = clusterInfos.map((info) => info.toMap()).toList();

      final result = (await _mapChannel.invokeMethod(
        BMFClusterMarkerMethodId.kSetClusterMarkerCoordinateMethod,
        {'clusterInfos': convertedData} as dynamic,
      )) as bool;

      return result;
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
      return false;
    }
  }

  Future<bool> _setClusterCoordinatesWithIsolate(MethodChannel _mapChannel,
      List<BMFClusterInfo> clusterInfos) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _isolateConvertFunction,
        _IsolateData(
          sendPort: receivePort.sendPort,
          clusterInfos: clusterInfos,
        ),
      );

      final convertedData = await receivePort.first as List<Map<String, dynamic>>;

      final result = (await _mapChannel.invokeMethod(
        BMFClusterMarkerMethodId.kSetClusterMarkerCoordinateMethod,
        {'clusterInfos': convertedData} as dynamic,
      )) as bool;

      return result;
    } catch (e) {
      /// 失败时回退到直接处理
      BMFLog.e('Isolate 处理失败: $e');
      return await _setClusterCoordinatesDirect(_mapChannel, clusterInfos);
    } finally {
      receivePort.close();
    }
  }

  void _isolateConvertFunction(_IsolateData data) {
    try {
      final convertedData = data.clusterInfos
          .map((info) => info.toMap())
          .toList();
      data.sendPort.send(convertedData);
    } catch (e) {
      data.sendPort.send([]);
    }
  }

  Future<bool> setClusterMaxDistanceInDP(MethodChannel _mapChannel,
      int maxDistanceInDP) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kSetMaxDistanceZoomMethod,
          {'maxDistanceInDP': maxDistanceInDP >= 1 ? maxDistanceInDP : 100}
          as dynamic)) as bool;
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return result;
  }

  Future<bool> cleanCluster(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kCleanCluster, {} as dynamic)) as bool;
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return result;
  }

  Future<List<BMFClusterInfo?>> getClusterOnZoomLevel(MethodChannel _mapChannel,
      int zoomLevel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(zoomLevel, "zoomLevel");

    dynamic result;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kGetClusterOnZoomLevelMethod,
          {'zoomLevel': zoomLevel}));
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    List<BMFClusterInfo?> clusters = [];
    if (null != result) {
      for (Map cluster in result) {
        clusters.add(BMFClusterInfo.fromMap(cluster));
      }
    }
    return clusters;
  }

  Future<bool> updateClusters(MethodChannel _mapChannel,
      List<BMFClusterInfo> clusterInfos) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(clusterInfos, "clusterInfos");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kUpdateClustersMethod,
          {
            'clusterInfos':
            clusterInfos.map((clusterInfo) => clusterInfo.toMap()).toList()
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return result;
  }

  Future<bool> refreshClusters(MethodChannel _mapChannel,
      List<BMFClusterInfo> clusterInfos) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(clusterInfos, "clusterInfos");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFClusterMarkerMethodId.kRefreshClustersMethod,
          {
            'clusterInfos':
            clusterInfos.map((clusterInfo) => clusterInfo.toMap()).toList()
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      BMFLog.e(e.toString());
    }
    return result;
  }
}


/// 点聚合数据传递类
class _IsolateData {
  final SendPort sendPort;
  final List<BMFClusterInfo> clusterInfos;

  _IsolateData({
    required this.sendPort,
    required this.clusterInfos,
  });
}