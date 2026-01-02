import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_map_options.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_mapstatus.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFMapStateMethodId;

/// 地图相关操作
class BMFMapStatusDispatcher {
  /// 更新地图属性
  Future<bool> updateMapOptions(
      MethodChannel _mapChannel, BMFMapOptions change) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(change, "change");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
              BMFMapStateMethodId.kMapUpdateMethod, change.toMap() as dynamic))
          as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// map放大一级比例尺
  Future<bool> zoomIn(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFMapStateMethodId.kMapZoomInMethod)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// map缩小一级比例尺
  Future<bool> zoomOut(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFMapStateMethodId.kMapZoomOutMethod)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 自定义路况颜色。
  ///
  /// 注意：如果需要自定义路况颜色，必须4种路况全都设置。4个参数全部合法时，自定义颜色才有效；否则全部使用默认的。
  /// smooth 路况畅通对应的颜色
  /// slow 路况缓行对应的颜色
  /// congestion 路况拥堵对应的颜色
  /// severeCongestion 路况严重拥堵对应的颜色
  Future<bool> setCustomTrafficColor(
    MethodChannel _mapChannel,
    Color smooth,
    Color slow,
    Color congestion,
    Color severeCongestion,
  ) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(smooth, "smooth");
    ArgumentError.checkNotNull(slow, "slow");
    ArgumentError.checkNotNull(congestion, "congestion");
    ArgumentError.checkNotNull(severeCongestion, "severeCongestion");

    bool result = false;
    try {
      Map<String, String> colorMap = {
        'smooth': smooth.value.toRadixString(16),
        'slow': slow.value.toRadixString(16),
        'congestion': congestion.value.toRadixString(16),
        'severeCongestion': severeCongestion.value.toRadixString(16)
      };
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetCustomTrafficColorMethod,
          colorMap as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 更新地图新状态
  ///
  /// mapStatus 地图新状态
  /// animateDurationMs 动画更新时间
  ///
  /// （注意：animateDurationMs该字段仅对android生效，若animateDurationMs !=0 ，iOS则启动默认动画设置mapStatus，反之不开启动画设置mapStatus）
  Future<bool> setNewMapStatus(MethodChannel _mapChannel,
      {required BMFMapStatus mapStatus, int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(mapStatus, "mapStatus");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetMapStatusMethod,
          {
            'mapStatus': mapStatus.toMap(),
            'animateDurationMs': animateDurationMs
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 获取地图新状态
  Future<BMFMapStatus?> getMapStatus(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    dynamic result;
    try {
      result = await _mapChannel
          .invokeMethod(BMFMapStateMethodId.kMapGetMapStatusMethod);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    BMFMapStatus? mapStatus;
    if (null != result) {
      mapStatus = BMFMapStatus.fromMap(result['mapStatus']);
    }
    return mapStatus;
  }

  /// 按像素移动地图中心点
  ///
  /// xPixel 水平方向移动像素数
  /// yPixel 垂直方向移动像素数
  /// animateDurationMs 动画更新时间
  Future<bool> setScrollBy(MethodChannel _mapChannel, int xPixel, int yPixel,
      {int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(xPixel, "xPixel");
    ArgumentError.checkNotNull(yPixel, "yPixel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetScrollByMethod,
          {
            'xPixel': xPixel,
            'yPixel': yPixel,
            'animateDurationMs': animateDurationMs
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 根据定增量缩放给地图级别
  ///
  /// amount 地图缩放级别增量
  /// animateDurationMs 动画更新时间
  Future<bool> setZoomBy(MethodChannel _mapChannel, double amount,
      {int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(amount, "amount");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetZoomByMethod,
          {'amount': amount, 'animateDurationMs': animateDurationMs}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 根据给定增量以及给定的屏幕坐标缩放地图级别
  ///
  /// amount 地图缩放级别增量
  /// focus  地图缩放中心点屏幕坐标, 若为 null 则返回 null
  /// animateDurationMs 动画更新时间
  Future<bool> setZoomPointBy(
      MethodChannel _mapChannel, double amount, BMFPoint focus,
      {int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(amount, "amount");
    ArgumentError.checkNotNull(focus, "focus");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetZoomByMethod,
          {
            'amount': amount,
            'focus': focus.toMap(),
            'animateDurationMs': animateDurationMs
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置地图缩放级别
  ///
  /// zoom 设置地图缩放级别
  /// animateDurationMs 动画更新时间
  Future<bool> setZoomTo(MethodChannel _mapChannel, double zoom,
      {int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(zoom, "zoom");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetZoomToMethod,
          {'zoom': zoom, 'animateDurationMs': animateDurationMs}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设定地图中心点坐标
  ///
  /// coordinate 要设定的地图中心点坐标，用经纬度表示
  /// animated 是否采用动画效果
  /// animateDurationMs 动画更新时间[android]支持
  Future<bool> setCenterCoordinate(
      MethodChannel _mapChannel, BMFCoordinate coordinate, bool animated,
      {int? animateDurationMs}) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(coordinate, "coordinate");
    ArgumentError.checkNotNull(animated, "animated");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetCenterCoordinateMethod,
          {
            'coordinate': coordinate.toMap(),
            'animated': animated,
            'animateDurationMs': animateDurationMs
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// [Android]设置地图中心点以及缩放级别
  ///
  /// coordinate 要设定的地图中心点坐标，用经纬度表示
  /// zoom 缩放级别
  /// animateDurationMs 动画时间
  Future<bool> setNewLatLngZoomDispatcher(
    MethodChannel _mapChannel, {
    required BMFCoordinate coordinate,
    required double zoom,
    int? animateDurationMs,
  }) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(coordinate, "coordinate");
    ArgumentError.checkNotNull(zoom, "zoom");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetCenterZoomMethod,
          {
            'coordinate': coordinate.toMap(),
            'zoom': zoom,
            'animateDurationMs': animateDurationMs
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 获得地图当前可视区域截图
  ///
  /// 范围内的截取的Images
  Future<Uint8List?> takeSnapshot(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    List<dynamic>? result;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapTakeSnapshotMethod)) as List<dynamic>?;
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return result != null
        ? Uint8List.fromList(result.map((i) => i as int).toList())
        : null;
  }

  /// 获得地图指定区域截图
  ///
  /// 指定区域的截取的Image
  Future<Uint8List?> takeSnapshotWithRect(
      MethodChannel _mapChannel, BMFMapRect rect) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(rect, "rect");

    List<dynamic>? result;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapTakeSnapshotWithRectMethod,
          {'rect': rect.toMap()})) as List<dynamic>?;
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return result != null
        ? Uint8List.fromList(result.map((i) => i as int).toList())
        : null;
  }

  /// 设置罗盘的图片
  Future<bool> setCompassImage(
      MethodChannel _mapChannel, String imagePath) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(imagePath, "imagePath");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetCompassImageMethod,
          {'imagePath': imagePath} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置显示在屏幕中的地图地理范围
  ///
  /// coordinateBounds 要设定的地图范围(东北，西南)角坐标
  /// animated 是否采用动画效果
  Future<bool> setVisibleMapBounds(MethodChannel _mapChannel,
      BMFCoordinateBounds visibleMapBounds, bool animated) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(visibleMapBounds, "visibleMapBounds");
    ArgumentError.checkNotNull(animated, "animated");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetVisibleMapBoundsMethod,
          {'visibleMapBounds': visibleMapBounds.toMap(), 'animated': animated}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置显示在指定相对于MapView的padding中的地图地理范围
  ///
  /// visibleMapBounds 要设定的地图范围(东北，西南)角坐标
  /// insets 指定的四周边界大小
  /// animated 是否采用动画效果
  Future<bool> setVisibleMapRectWithPadding(
      MethodChannel _mapChannel,
      BMFCoordinateBounds visibleMapBounds,
      EdgeInsets insets,
      bool animated) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(visibleMapBounds, "visibleMapBounds");
    ArgumentError.checkNotNull(insets, "insets");
    ArgumentError.checkNotNull(animated, "animated");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetVisibleMapBoundsWithPaddingMethod,
          {
            'visibleMapBounds': visibleMapBounds.toMap(),
            'insets': BMFEdgeInsets.fromEdgeInsets(insets).toMap(),
            'animated': animated
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 根据当前mapView的窗口大小，预留insets指定的边界区域后，将mapRect指定的地理范围显示在剩余的区域内，并尽量充满
  ///
  /// fitVisibleMapBounds 要设定的地图范围(东北，西南)角坐标
  /// insets 指定的四周边界大小
  /// animated 是否采用动画效果
  Future<bool> fitVisibleMapRectWithPadding(
      MethodChannel _mapChannel,
      BMFCoordinateBounds fitVisibleMapBounds,
      EdgeInsets insets,
      bool animated) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(fitVisibleMapBounds, "fitVisibleMapBounds");
    ArgumentError.checkNotNull(insets, "insets");
    ArgumentError.checkNotNull(animated, "animated");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapFitVisibleMapBoundsWithPaddingMethod,
          {
            'fitVisibleMapBounds': fitVisibleMapBounds.toMap(),
            'insets': BMFEdgeInsets.fromEdgeInsets(insets).toMap(),
            'animated': animated
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// 设置地图中心点在地图中的屏幕坐标位置
  ///
  /// point 要设定的地图中心点位置，为屏幕坐标，设置的中心点不能超过屏幕范围，否则无效
  Future<bool> setMapCenterToScreenPt(
      MethodChannel _mapChannel, BMFPoint point) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(point, "point");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapStateMethodId.kMapSetMapCenterToScreenPtMethod,
          {
            'point': point.toMap(),
          } as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  /// map强制刷新（Android独有）
  Future<bool> mapRefresh(MethodChannel _mapChannel, int? refreshDelay) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(refreshDelay, "refreshDelay");

    bool result = false;
    try {
      result = (await _mapChannel
          .invokeMethod(BMFMapStateMethodId.kMapRefreshMethod,
      {
        'refreshDelay': refreshDelay
      })) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
