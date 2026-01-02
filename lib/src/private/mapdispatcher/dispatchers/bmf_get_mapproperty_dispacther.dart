import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFMapGetPropertyMethodId;

/// 获取地图属性相关操作
class BMFMapGetPropertyDispatcher {
  /// 获取map的展示类型
  Future<BMFMapType?> getMapType(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFMapType? mapType;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetMapTypeMethod);
      if (result['mapType'] != null) {
        mapType = BMFMapType.values[result['mapType'] as int];
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return mapType;
  }

  /// 获取map的语言类型 since 3.1.0
  ///
  /// [BMFMapLanguageType] mapLanguageTypeType 地图的展示类型
  Future<BMFMapLanguageType?> getMapLanguageType(
      MethodChannel _mapChannel) async {
    BMFMapLanguageType? mapLanguageType;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetMapLanguageTypeMethod);
      if (result['languageType'] != null) {
        mapLanguageType =
            BMFMapLanguageType.values[result['languageType'] as int];
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return mapLanguageType;
  }

  /// 获取空白map的背景颜色 since 3.4.0
  /// IOS独有
  /// [Color] backgroundColor 空白map的背景颜色
  Future<Color?> getMapBackgroundColor(MethodChannel _mapChannel) async {
    Color? bgColor;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetMapBackgroundColorTypeMethod);
      if (result['backgroundColor'] != null) {
        bgColor = ColorUtil.hexToColor(result['backgroundColor']);
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return bgColor;
  }

  /// 获取map的字体大小 since 3.1.0
  ///
  /// [BMFMapFontSizeLevel] mapfontSizeLevel 地图的展示类型
  Future<BMFMapFontSizeLevel?> getMapFontSizeLevel(
      MethodChannel _mapChannel) async {
    BMFMapFontSizeLevel? mapFontSizeLevel;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetMapFontSizeLevelMethod);
      if (result['fontSizeLevel'] != null) {
        mapFontSizeLevel =
            BMFMapFontSizeLevel.values[result['fontSizeLevel'] as int];
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return mapFontSizeLevel;
  }

  /// 获取map的比例尺级别
  Future<int?> getZoomLevel(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    int? zoomLevel;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetZoomLevelMethod);
      zoomLevel = result['zoomLevel'] as int?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return zoomLevel;
  }

  /// 获取map的自定义最小比例尺级别
  Future<int?> getMinZoomLevel(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    int? minZoomLevel;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetMinZoomLevelMethod);
      minZoomLevel = result['minZoomLevel'] as int?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return minZoomLevel;
  }

  /// 获取map的自定义最大比例尺级别
  Future<int?> getMaxZoomLevel(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    int? maxZoomLevel;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetMaxZoomLevelMethod);
      maxZoomLevel = result['maxZoomLevel'] as int?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return maxZoomLevel;
  }

  /// 获取map的旋转角度
  Future<double?> getRotation(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    double? rotation;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetRotationMethod);
      rotation = result['rotation'] as double?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return rotation;
  }

  /// 获取map的地图俯视角度
  Future<double?> getOverlooking(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    double? overlooking;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetOverlookingMethod);
      overlooking = result['overlooking'] as double?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return overlooking;
  }

  /// 获取map的俯视角度最小值
  ///
  ///  iOS 独有
  Future<int?> getMinOverlooking(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return 0;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    int? minOverlooking;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetMinOverlookingMethod);
      minOverlooking = result['minOverlooking'] as int?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return minOverlooking;
  }

  /// 获取map的是否现显示3D楼块效果
  Future<bool?> getBuildingsEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? buildingsEnabled;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetBuildingsEnabledMethod);
      buildingsEnabled = result['buildingsEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return buildingsEnabled;
  }

  /// 获取map的是否显示底图poi标注
  ///
  /// iOS 独有
  Future<bool?> getShowMapPoi(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? showMapPoi;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetShowMapPoiMethod);
      showMapPoi = result['showMapPoi'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return showMapPoi;
  }

  /// 获取map的是否打开路况图层
  Future<bool?> getTrafficEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? trafficEnabled;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetTrafficEnabledMethod);
      trafficEnabled = result['trafficEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return trafficEnabled;
  }

  /// 获取map的是否打开百度城市热力图图层
  Future<bool?> getBaiduHeatMapEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? baiduHeatMapEnabled;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetBaiduHeatMapEnabledMethod);
      baiduHeatMapEnabled = result['baiduHeatMapEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return baiduHeatMapEnabled;
  }

  /// 获取map的是否支持所有手势操作
  Future<bool?> getGesturesEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? gesturesEnabled;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetGesturesEnabledMethod);
      gesturesEnabled = result['gesturesEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return gesturesEnabled;
  }

  /// 获取map的是否支持用户多点缩放(双指)
  ///
  /// android 中效果是否允许缩放手势包括（双击,双指单击,双指缩放）
  Future<bool?> getZoomEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? zoomEnabled;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetZoomEnabledMethod);
      zoomEnabled = result['zoomEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return zoomEnabled;
  }

  /// 获取map的是否支持用户缩放(双击或双指单击)
  ///
  /// iOS 独有
  Future<bool?> getZoomEnabledWithTap(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? zoomEnabledWithTap;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetZoomEnabledWithTapMethod);
      zoomEnabledWithTap = result['zoomEnabledWithTap'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return zoomEnabledWithTap;
  }

  /// 获取map的是否支持用户移动地图
  Future<bool?> getScrollEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? scrollEnabled;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetScrollEnabledMethod);
      scrollEnabled = result['scrollEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return scrollEnabled;
  }

  /// 获取map的是否支持俯仰角
  Future<bool?> getOverlookEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? overlookEnabled;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetOverlookEnabledMethod);
      overlookEnabled = result['overlookEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return overlookEnabled;
  }

  /// 获取map的是否支持旋转
  Future<bool?> getRotateEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? rotateEnabled;
    try {
      Map result = await (_mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetRotateEnabledMethod));
      rotateEnabled = result['rotateEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return rotateEnabled;
  }

  /// 获取map的是否支持3Dtouch
  ///
  /// iOS 独有
  Future<bool?> getForceTouchEnabled(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? forceTouchEnabled;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetForceTouchEnabledMethod);
      forceTouchEnabled = result['forceTouchEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return forceTouchEnabled;
  }

  /// 获取map的是否显式比例尺
  ///
  /// iOS 独有
  Future<bool?> getShowMapScaleBar(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? showMapScaleBar;
    try {
      Map result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetShowMapScaleBarMethod);
      showMapScaleBar = result['showMapScaleBar'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return showMapScaleBar;
  }

  /// 获取map的比例尺的位置
  Future<BMFPoint?> getMapScaleBarPosition(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFPoint? mapScaleBarPosition;
    try {
      Map? result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetMapScaleBarPositionMethod);
      if (null == result) {
        return null;
      }
      mapScaleBarPosition = BMFPoint.fromMap(result['mapScaleBarPosition']);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return mapScaleBarPosition;
  }

  /// 获取map的logo位置
  Future<BMFLogoPosition?> getLogoPosition(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFLogoPosition? logoPosition;
    try {
      Map? result = await _mapChannel
          .invokeMethod(BMFMapGetPropertyMethodId.kMapGetLogoPositionMethod);
      if (null == result) {
        return null;
      }
      logoPosition = BMFLogoPosition.values[result['logoPosition'] as int];
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return logoPosition;
  }

  /// 获取map的可视范围
  Future<BMFCoordinateBounds?> getVisibleMapBounds(
      MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    BMFCoordinateBounds? visibleMapBounds;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetVisibleMapBoundsMethod);
      visibleMapBounds =
          BMFCoordinateBounds.fromMap(result['visibleMapBounds']);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return visibleMapBounds;
  }

  /// 获取map的显示室内图
  Future<bool?> getBaseIndoorMapEnabled(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? baseIndoorMapEnabled;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetBaseIndoorMapEnabledMethod);
      baseIndoorMapEnabled = result['baseIndoorMapEnabled'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return baseIndoorMapEnabled;
  }

  /// 获取map的室内图标注是否显示
  ///
  /// iOS 独有
  Future<bool?> getShowIndoorMapPoi(MethodChannel _mapChannel) async {
    if (Platform.isAndroid) {
      return false;
    }
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? showIndoorMapPoi;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetShowIndoorMapPoiMethod);
      showIndoorMapPoi = result['showIndoorMapPoi'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return showIndoorMapPoi;
  }

  /// 获取map的运营图层是否显示
  Future<bool?> getShowwOperateLayer(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool? showIndoorMapPoi;
    try {
      Map result = await _mapChannel.invokeMethod(
          BMFMapGetPropertyMethodId.kMapGetShowOperateLayerMethod);
      showIndoorMapPoi = result['showOperateLayer'] as bool?;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return showIndoorMapPoi;
  }
}
