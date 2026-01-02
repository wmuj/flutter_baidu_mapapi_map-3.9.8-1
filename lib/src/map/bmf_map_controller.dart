import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/bmf_method_channel_handler.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

/// 地图通信中心
class BMFMapController {
  // static const _tag = "BMFMapController";

  /// 通信
  late MethodChannel _mapChannel;

  late BMFMethodChannelHandler _methodChannelHandler;

  BMFMapController.withId(int id) {
    _init(id);
  }

  void _init(int id) {
    _mapChannel = MethodChannel('flutter_bmfmap/map_$id');
    _methodChannelHandler = BMFMethodChannelHandler(_mapChannel);
    _mapChannel.setMethodCallHandler(_handlerMethod);
  }

  /// 地图代理回调
  ///
  /// native -> flutter
  Future<dynamic> _handlerMethod(MethodCall call) async {
    return await _methodChannelHandler.handlerMethod(call);
  }
}

/// 地图相关操作
extension MapExtension on BMFMapController {
  /// flutter -> native
  ///
  /// 更新地图属性
  ///
  /// [BMFMapOptions] change 地图参数集合
  ///
  /// bool 更新成功返回true 失败false
  Future<bool> updateMapOptions(BMFMapOptions change) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .updateMapOptions(_mapChannel, change);
  }

  /// 获取地图状态
  ///
  /// [BMFMapStatus] mapStatus 地图状态
  Future<BMFMapStatus?> getMapStatus() async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .getMapStatus(_mapChannel);
  }

  /// 获取map的展示类型
  ///
  /// [BMFMapType] mapType 地图的展示类型
  Future<BMFMapType?> getMapType() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMapType(_mapChannel);
  }

  /// 获取map的语言类型 since 3.1.0
  ///
  /// [BMFMapLanguageType] mapLanguageTypeType 地图的展示类型
  Future<BMFMapLanguageType?> getMapLanguageType() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMapLanguageType(_mapChannel);
  }

  /// 获取空白map的背景颜色 since 3.4.0
  ///
  /// [Color] backgroundColor 空白map的背景颜色
  Future<Color?> getMapBackgroundColor() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMapBackgroundColor(_mapChannel);
  }

  /// 获取map的字体大小 since 3.1.0
  ///
  /// [BMFMapFontSizeLevel] mapfontSizeLevel 地图的展示类型
  Future<BMFMapFontSizeLevel?> getMapFontSizeLevel() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMapFontSizeLevel(_mapChannel);
  }

  /// 获取map的比例尺级别
  ///
  /// zoomLevel 比例尺级别
  Future<int?> getZoomLevel() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getZoomLevel(_mapChannel);
  }

  /// 获取map的自定义最小比例尺级别
  ///
  /// minZoomLevel 自定义最小比例尺级别
  Future<int?> getMinZoomLevel() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMinZoomLevel(_mapChannel);
  }

  /// 获取map的自定义最大比例尺级别
  ///
  /// maxZoomLevel  自定义最大比例尺级别
  Future<int?> getMaxZoomLevel() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMaxZoomLevel(_mapChannel);
  }

  /// 获取map的旋转角度
  ///
  /// rotation  旋转角度
  Future<double?> getRotation() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getRotation(_mapChannel);
  }

  /// 获取map的地图俯视角度
  ///
  /// overlooking 地图俯视角度
  Future<double?> getOverlooking() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getOverlooking(_mapChannel);
  }

  /// 获取map的俯视角度最小值
  ///
  /// minOverlooking 俯视角度最小值
  ///
  /// iOS 独有
  Future<int?> getMinOverlooking() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMinOverlooking(_mapChannel);
  }

  /// 获取map是否现显示3D楼块效果
  ///
  /// buildingsEnabled 是否现显示3D楼块效果
  Future<bool?> getBuildingsEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getBuildingsEnabled(_mapChannel);
  }

  /// 获取map是否显示底图poi标注
  ///
  /// showMapPoi  是否显示底图poi标注
  ///
  /// iOS 独有
  Future<bool?> getShowMapPoi() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getShowMapPoi(_mapChannel);
  }

  /// 获取map是否打开路况图层(在某些Android机型上，路况图无法正常展示)
  ///
  /// trafficEnabled 是否打开路况图层
  Future<bool?> getTrafficEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getTrafficEnabled(_mapChannel);
  }

  /// 获取map是否打开百度城市热力图图层
  ///
  /// baiduHeatMapEnabled  是否打开百度城市热力图图层
  Future<bool?> getBaiduHeatMapEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getBaiduHeatMapEnabled(_mapChannel);
  }

  /// 获取map是否支持所有手势操作
  ///
  /// gesturesEnabled  是否支持所有手势操作
  Future<bool?> getGesturesEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getGesturesEnabled(_mapChannel);
  }

  /// 获取map是否支持用户多点缩放(双指)
  ///
  /// zoomEnabled  是否支持用户多点缩放(双指)
  ///
  /// android 中效果是否允许缩放手势包括（双击,双指单击,双指缩放）
  Future<bool?> getZoomEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getZoomEnabled(_mapChannel);
  }

  /// 获取map是否支持用户缩放(双击或双指单击)
  ///
  /// zoomEnabledWithTap  是否支持用户缩放(双击或双指单击)
  ///
  /// ios 独有
  Future<bool?> getZoomEnabledWithTap() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getZoomEnabledWithTap(_mapChannel);
  }

  /// 获取map是否支持用户移动地图
  ///
  /// scrollEnabled  是否支持用户移动地图
  Future<bool?> getScrollEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getScrollEnabled(_mapChannel);
  }

  /// 获取map是否支持俯仰角
  ///
  /// overlookEnabled  是否支持俯仰角
  Future<bool?> getOverlookEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getOverlookEnabled(_mapChannel);
  }

  /// 获取map是否支持旋转
  ///
  /// rotateEnabled  是否支持旋转
  Future<bool?> getRotateEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getRotateEnabled(_mapChannel);
  }

  /// 获取map是否支持3Dtouch
  ///
  /// forceTouchEnabled  是否支持3Dtouch
  ///
  /// iOS 独有
  Future<bool?> getForceTouchEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getForceTouchEnabled(_mapChannel);
  }

  /// 获取map是否显式比例尺
  ///
  /// showMapScaleBar  是否显式比例尺
  ///
  /// iOS 独有
  Future<bool?> getShowMapScaleBar() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getShowMapScaleBar(_mapChannel);
  }

  /// 获取map的比例尺的位置
  ///
  /// mapScaleBarPosition  比例尺的位置
  Future<BMFPoint?> getMapScaleBarPosition() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getMapScaleBarPosition(_mapChannel);
  }

  /// 获取地图是否展示运营图层 since 3.2.0
  Future<bool?> getMapShowOperateLayer() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getShowwOperateLayer(_mapChannel);
  }

  /// 获取map的logo位置
  ///
  /// logoPosition  地图logo的位置
  Future<BMFLogoPosition?> getLogoPosition() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getLogoPosition(_mapChannel);
  }

  /// 获取map的可视范围
  ///
  /// visibleMapBounds  地图的可视范围
  Future<BMFCoordinateBounds?> getVisibleMapBounds() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getVisibleMapBounds(_mapChannel);
  }

  /// map放大一级比例尺
  ///
  /// bool 成功返回true 失败false
  Future<bool> zoomIn() async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .zoomIn(_mapChannel);
  }

  /// map缩小一级比例尺
  ///
  /// bool 成功返回true 失败false
  Future<bool> zoomOut() async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .zoomOut(_mapChannel);
  }

  /// 自定义路况颜色。
  ///
  /// 注意：如果需要自定义路况颜色，必须4种路况全都设置。4个参数全部合法时，自定义颜色才有效；否则全部使用默认的。
  ///
  /// smooth 路况畅通对应的颜色
  ///
  /// slow 路况缓行对应的颜色
  ///
  /// congestion 路况拥堵对应的颜色
  ///
  /// severeCongestion 路况严重拥堵对应的颜色
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCustomTrafficColor({
    required Color smooth,
    required Color slow,
    required Color congestion,
    required Color severeCongestion,
  }) async {
    return await BMFMapDispatcherFactory()
        .mapStatusDispatcher
        .setCustomTrafficColor(
            _mapChannel, smooth, slow, congestion, severeCongestion);
  }

  /// 更新地图新状态
  ///
  /// [BMFMapStatus] mapStatus 地图新状态
  ///
  /// animateDurationMs 动画更新时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setNewMapStatus(
      {required BMFMapStatus mapStatus, int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setNewMapStatus(_mapChannel,
            mapStatus: mapStatus, animateDurationMs: animateDurationMs);
  }

  /// 按像素移动地图中心点(Android独有)
  ///
  /// xPixel 水平方向移动像素数
  ///
  /// yPixel 垂直方向移动像素数
  ///
  /// animateDurationMs 动画更新时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setScrollBy(int xPixel, int yPixel,
      {int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setScrollBy(_mapChannel, xPixel, yPixel,
            animateDurationMs: animateDurationMs);
  }

  /// 根据给定增量缩放地图级别(Android独有)
  ///
  /// amount 地图缩放级别增量
  ///
  /// animateDurationMs 动画更新时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setZoomBy(double amount, {int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setZoomBy(_mapChannel, amount, animateDurationMs: animateDurationMs);
  }

  /// 根据给定增量以及给定的屏幕坐标缩放地图级别(Android独有)
  ///
  /// amount 地图缩放级别增量
  ///
  /// [BMFPoint] focus  地图缩放中心点屏幕坐标, 若为 null 则返回 null
  ///
  /// animateDurationMs 动画更新时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setZoomPointBy(double amount, BMFPoint focus,
      {int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setZoomPointBy(_mapChannel, amount, focus,
            animateDurationMs: animateDurationMs);
  }

  /// 设置地图缩放级别(Android独有)
  ///
  /// zoom 设置地图缩放级别
  ///
  /// animateDurationMs 动画更新时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setZoomTo(double zoom, {int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setZoomTo(_mapChannel, zoom, animateDurationMs: animateDurationMs);
  }

  /// 设定地图中心点坐标
  ///
  /// [BMFCoordinate] coordinate 要设定的地图中心点坐标，用经纬度表示
  ///
  /// animated 是否采用动画效果(ios 独有)
  ///
  /// animateDurationMs 动画更新时间(android 独有)
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCenterCoordinate(BMFCoordinate coordinate, bool animated,
      {int? animateDurationMs}) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setCenterCoordinate(_mapChannel, coordinate, animated,
            animateDurationMs: animateDurationMs);
  }

  /// 设置地图中心点以及缩放级别(Android 独有)
  ///
  /// [BMFCoordinate]coordinate 要设定的地图中心点坐标，用经纬度表示
  /// zoom 缩放级别
  ///
  /// animateDurationMs 动画时间
  ///
  /// bool 成功返回true 失败false
  Future<bool> setNewLatLngZoom({
    required BMFCoordinate coordinate,
    required double zoom,
    int? animateDurationMs,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setNewLatLngZoomDispatcher(
      _mapChannel,
      coordinate: coordinate,
      zoom: zoom,
      animateDurationMs: animateDurationMs,
    );
  }

  /// 获得地图当前可视区域截图
  ///
  /// 范围内的截取的Images
  Future<Uint8List?> takeSnapshot() async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .takeSnapshot(_mapChannel);
  }

  /// 获得地图指定区域截图 (ios)
  ///
  /// 指定区域的截取的Image
  Future<Uint8List?> takeSnapshotWithRect(BMFMapRect rect) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .takeSnapshotWithRect(_mapChannel, rect);
  }

  /// 设置罗盘的图片
  ///
  /// imagePath 设置的图片
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCompassImage(String imagePath) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setCompassImage(_mapChannel, imagePath);
  }

  /// 设置显示在屏幕中的地图地理范围
  ///
  /// [BMFCoordinateBounds]visibleMapBounds 要设定的地图范围(东北，西南)角坐标
  ///
  /// animated 是否采用动画效果 (ios 独有)
  ///
  /// bool 成功返回true 失败false
  Future<bool> setVisibleMapBounds(
      BMFCoordinateBounds visibleMapBounds, bool animated) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setVisibleMapBounds(_mapChannel, visibleMapBounds, animated);
  }

  /// 设置显示在指定相对于MapView的padding中的地图地理范围 since 3.1.0
  ///
  /// [BMFCoordinateBounds]visibleMapBounds 要设定的地图范围(东北，西南)角坐标
  ///
  /// [EdgeInsets]insets 指定的四周边界大小
  ///
  /// animated 是否采用动画效果(ios 独有)
  ///
  /// bool 成功返回true 失败false
  Future<bool> setVisibleMapRectWithPadding({
    required BMFCoordinateBounds visibleMapBounds,
    required EdgeInsets insets,
    required bool animated,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setVisibleMapRectWithPadding(
      _mapChannel,
      visibleMapBounds,
      insets,
      animated,
    );
  }

  /// 根据当前mapView的窗口大小，预留insets指定的边界区域后，将mapRect指定的地理范围显示在剩余的区域内，并尽量充满 since 3.9.0
  /// (ios 独有)
  /// [BMFCoordinateBounds]fitVisibleMapBounds 要设定的地图范围(东北，西南)角坐标
  ///
  /// [EdgeInsets]insets 指定的四周边界大小
  ///
  /// animated 是否采用动画效果
  ///
  /// bool 成功返回true 失败false
  Future<bool> fitVisibleMapRectWithPadding({
    required BMFCoordinateBounds fitVisibleMapBounds,
    required EdgeInsets insets,
    required bool animated,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .fitVisibleMapRectWithPadding(
      _mapChannel,
      fitVisibleMapBounds,
      insets,
      animated,
    );
  }

  /// 设置地图中心点在地图中的屏幕坐标位置 since 3.9.0
  ///
  /// point 要设定的地图中心点位置，为屏幕坐标，设置的中心点不能超过屏幕范围，否则无效
  Future<bool> setMapCenterToScreenPt({
    required BMFPoint point,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setMapCenterToScreenPt(_mapChannel, point);
  }

  /// 强制刷新地图 (Android独有) since3.9.2
  /// 增加刷新时间参数，默认300ms
  Future<bool> mapRefresh({int? refreshDelay}) async {
    final delay = refreshDelay ?? 300;
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .mapRefresh(_mapChannel, delay);
  }

  /// 设置显示在指定相对于MapView的padding中的地图地理范围
  ///
  /// [BMFCoordinateBounds]visibleMapBounds 要设定的地图范围(东北，西南)角坐标
  ///
  /// [EdgeInsets]insets 指定的四周边界大小
  ///
  /// animated 是否采用动画效果(ios 独有)
  ///
  /// bool 成功返回true 失败false
  @Deprecated('Use `setVisibleMapRectWithPadding` method instead since 3.1.0')
  Future<bool> setVisibleMapRectWithPaddingHandler({
    required BMFCoordinateBounds visibleMapBounds,
    required EdgeInsets insets,
    required bool animated,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapStatusDispatcher
        .setVisibleMapRectWithPadding(
      _mapChannel,
      visibleMapBounds,
      insets,
      animated,
    );
  }
}

/// 个性化地图相关操作
extension CustomMapExtension on BMFMapController {
  /// 个性化地图样式开关，仅影响前mapView对象，需在地图创建后调用
  ///
  /// enable 当前自定义地图样式是否生效
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCustomMapStyleEnable(bool enable) async {
    return await BMFMapDispatcherFactory.instance.customMapDispatcher
        .setCustomMapStyleEnable(_mapChannel, enable);
  }

  /// 设置个性化地图样式路径，仅影响当前mapView对象，需在对象创建后调用
  ///
  /// path 本地个性化样式文件所在路径，包含文件名
  ///
  /// mode 加载模式，0:加载本地文件 1:加载在线文件或在线缓存文件
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCustomMapStyle(String path, int mode) async {
    return await BMFMapDispatcherFactory.instance.customMapDispatcher
        .setCustomMapStylePath(_mapChannel, path, mode);
  }

  /// 设置个性化地图样式路径，仅影响当前mapView对象，需在对象创建后调用
  ///
  /// 在线个性化样式加载状态回调接口。
  ///
  /// 在线个性化样式创建地址：http://lbsyun.baidu.com/apiconsole/custommap
  ///
  /// 调用该接口加载个性化样式的默认策略为：
  ///
  /// 1、优先通过[BMFCustomMapStyleOption]配置的个性化样式ID，加载在线个性化样式;
  ///
  /// 2、如果配置的个性化样式ID无效或在线个性化样式请求失败,则加载本地缓存的最新一次请求成功的在线个性化样式;
  ///
  /// 3、如果本地缓存中没有最新一次请求成功的在线个性化样式，则通过BMFCustomMapStyleOption中配置的本地离线样式路径加载本地样式;
  ///
  /// 4、如果以上样式加载都失败，则显示普通地图样式。
  ///
  /// [BMFCustomMapStyleOption] customMapStyleOption 在线个性化样式配置选项
  ///
  /// preLoad 当预加载成功时会执行的block对象，path：本地缓存的最新一次请求成功的在线个性化样式路径
  ///
  /// success 当加载成功时会执行的block对象，path：请求成功的在线个性化样式路径
  ///
  /// error 当加载未成功时会执行的block对象，error:失败错误信息，path:失败后根据策略加载的个性化样式路径（路径可能会为nil）
  ///
  /// bool 成功返回true 失败false
  Future<bool> setCustomMapStyleWithOptionPath({
    required BMFCustomMapStyleOption customMapStyleOption,
    required void Function(String? path) preload,
    required void Function(String? path) success,
    required void Function(int? errorCode, String? path) error,
  }) async {
    return await BMFMapDispatcherFactory.instance.customMapDispatcher
        .setCustomMapStyleWithOption(
            _mapChannel, customMapStyleOption, preload, success, error);
  }
}

/// 室内图相关操作
extension IndoorMapExtension on BMFMapController {
  /// 获取map是否显示室内图
  ///
  /// baseIndoorMapEnabled  是否显示室内图
  Future<bool?> getBaseIndoorMapEnabled() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getBaseIndoorMapEnabled(_mapChannel);
  }

  /// 获取map的室内图标注是否显示
  ///
  /// showIndoorMapPoi  室内图标注是否显示
  ///
  /// iOS 独有
  Future<bool?> getShowIndoorMapPoi() async {
    return await BMFMapDispatcherFactory.instance.mapGetPropertyDispatcher
        .getShowIndoorMapPoi(_mapChannel);
  }

  /// 是否展示室内地图
  ///
  /// show 展示true 隐藏false
  ///
  /// bool 成功返回true 失败false
  Future<bool> showBaseIndoorMap(bool show) async {
    return await BMFMapDispatcherFactory.instance.indoorMapDispatcher
        .showBaseIndoorMap(_mapChannel, show);
  }

  /// 室内图标注是否显示
  ///
  /// showPoi 展示true 隐藏false
  ///
  /// bool 成功返回true 失败false
  Future<bool> showBaseIndoorMapPoi(bool showPoi) async {
    return await BMFMapDispatcherFactory.instance.indoorMapDispatcher
        .showBaseIndoorMapPoi(_mapChannel, showPoi);
  }

  /// 设置室内图楼层
  ///
  /// floorId 楼层id
  ///
  /// indoorId 室内图ID
  ///
  /// [BMFSwitchIndoorFloorError] 枚举：室内图切换楼层结果
  Future<BMFSwitchIndoorFloorError> switchBaseIndoorMapFloor(
      String floorId, String indoorId) async {
    return await BMFMapDispatcherFactory.instance.indoorMapDispatcher
        .switchBaseIndoorMapFloor(_mapChannel, floorId, indoorId);
  }

  /// 获取当前聚焦的室内图信息
  ///
  /// [BMFBaseIndoorMapInfo] 当前聚焦的室内图信息。没有聚焦的室内图，返回nil
  Future<BMFBaseIndoorMapInfo?> getFocusedBaseIndoorMapInfo() async {
    return await BMFMapDispatcherFactory.instance.indoorMapDispatcher
        .getFocusedBaseIndoorMapInfo(_mapChannel);
  }
}

/// 热力图相关操作
extension HeatMapExtension on BMFMapController {
  /// 添加热力图
  ///
  /// [BMFHeatMap] heatMap 热力图
  ///
  /// bool 成功返回true 失败false
  Future<bool> addHeatMap(BMFHeatMap heatMap) async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .addHeatMap(_mapChannel, heatMap);
  }

  /// 更新热力图 since 3.5.0
  ///
  /// [BMFHeatMap] heatMap 热力图
  ///
  /// bool 成功返回true 失败false
  Future<bool> updateHeatMap(BMFHeatMap heatMap) async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .updateHeatMap(_mapChannel, heatMap);
  }

  /// 删除热力图
  ///
  /// bool 成功返回true 失败false
  Future<bool> removeHeatMap() async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .removeHeatMap(_mapChannel);
  }

  /// 显示热力图(在某些Android机型上，该方法执行无效)
  ///
  /// show ture展示 false关闭
  ///
  /// bool 成功返回true 失败false
  Future<bool> showHeatMap(bool show) async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .showHeatMap(_mapChannel, show);
  }

  /// 开始热力图动画
  ///
  /// bool 成功返回true 失败false
  Future<bool> startHeatMapFrameAnimation() async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .startFrameAnimation(_mapChannel);
  }

  /// 停止热力图动画
  ///
  /// bool 成功返回true 失败false
  Future<bool> stopHeatMapFrameAnimation() async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .stopFrameAnimation(_mapChannel);
  }

  /// 设置控制渲染帧索引
  ///
  /// index 索引值
  ///
  /// bool 成功返回true 失败false
  Future<bool> setHeatMapFrameAnimatioIndex(int index) async {
    return await BMFMapDispatcherFactory.instance.heatMapDispatcher
        .setFrameAnimatioIndex(_mapChannel, index);
  }
}

/// 定位图层相关操作
extension UserLocationExtension on BMFMapController {
  /// 地图设定是否显示定位图层
  ///
  /// show 展示ture 隐藏false
  ///
  /// bool 成功返回true 失败false
  Future<bool> showUserLocation(bool show) async {
    return await BMFMapDispatcherFactory.instance.mapUserLocationDispatcher
        .setShowUserLocation(_mapChannel, show);
  }

  /// 设定定位模式
  ///
  /// [BMFUserTrackingMode]userTrackingMode 定位模式
  ///
  /// enableDirection  是否允许显示方向信息 (Android 独有）
  ///
  /// customMarker  设置用户自定义定位图标，可以为 null (Android  独有)
  ///
  /// bool 成功返回true 失败false
  Future<bool> setUserTrackingMode(
    BMFUserTrackingMode userTrackingMode, {
    bool enableDirection = true,
    String? customMarker,
  }) async {
    return await BMFMapDispatcherFactory.instance.mapUserLocationDispatcher
        .setUserTrackingMode(
      _mapChannel,
      userTrackingMode,
      enableDirection,
      customMarker: customMarker,
    );
  }

  /// 定位坐标点是否在当前地图可视区域内
  ///
  /// bool true在当前地图可视区域内 false 不在在当前地图可视区域内
  ///
  /// iOS 独有
  Future<bool> isUserLocationVisible() async {
    return await BMFMapDispatcherFactory.instance.mapUserLocationDispatcher
        .setIsUserLocationVisible(_mapChannel);
  }

  /// 动态更新我的位置数据
  ///
  /// [BMFUserLocation]userLocation	定位数据
  ///
  /// bool 成功返回true 失败false
  Future<bool> updateLocationData(BMFUserLocation userLocation) async {
    return await BMFMapDispatcherFactory.instance.mapUserLocationDispatcher
        .setUpdateLocationData(_mapChannel, userLocation);
  }

  /// 动态定制我的位置样式
  ///
  /// [BMFUserLocationDisplayParam]userlocationDisplayParam	样式参数
  ///
  /// bool 成功返回true 失败false
  Future<bool> updateLocationViewWithParam(
      BMFUserLocationDisplayParam userlocationDisplayParam) async {
    return await BMFMapDispatcherFactory.instance.mapUserLocationDispatcher
        .setUpdateLocationViewWithParam(_mapChannel, userlocationDisplayParam);
  }
}

/// marker相关操作
extension MarkerExtension on BMFMapController {
  /// 地图添加Marker
  ///
  /// [BMFMarker] marker 大头针
  ///
  /// bool 成功返回true 失败false
  Future<bool> addMarker(BMFMarker marker) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .addMarker(_mapChannel, marker);
  }

  /// 地图添加Markers
  ///
  /// [BMFMarker]集合 markers 大头针list,
  ///
  /// bool 成功返回true 失败false
  Future<bool> addMarkers(List<BMFMarker> markers) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .addMarkers(_mapChannel, markers);
  }

  /// 地图添加[BMFInfoWindow] infoWindow
  Future<bool> addInfoWindow(BMFInfoWindow infoWindow) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .addInfoWindow(_mapChannel, infoWindow);
  }

  /// 地图批量添加[BMFInfoWindow] infoWindow
  Future<bool> addInfoWindows(List<BMFInfoWindow> infoWindows) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .addInfoWindows(_mapChannel, infoWindows);
  }

  /// 地图移除[BMFInfoWindow] infoWindow
  Future<bool> removeInfoWindow(BMFInfoWindow infoWindow) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .removeInfoWindow(_mapChannel, infoWindow);
  }

  /// 地图指定删除Marker
  ///
  /// [BMFMarker] marker 要移除的大头针
  ///
  /// bool 成功返回true 失败false
  Future<bool> removeMarker(BMFMarker marker) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .removeMarker(_mapChannel, marker);
  }

  /// 地图批量删除Markers
  ///
  /// [BMFMarker]集合 markers 要移除的大头针list
  ///
  /// bool 成功返回true 失败false
  Future<bool> removeMarkers(List<BMFMarker> markers) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .removeMarkers(_mapChannel, markers);
  }

  /// 地图清除所有Markers
  ///
  /// bool 成功返回true 失败false
  Future<bool> cleanAllMarkers() async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .cleanAllMarkers(_mapChannel);
  }

  /// 选中marker
  ///
  /// bool 成功返回true 失败false
  Future<bool> selectMarker(BMFMarker marker) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .selectMarker(_mapChannel, marker);
  }

  /// 取消指定的marker的选中状态
  ///
  /// bool 成功返回true 失败false
  Future<bool> deselectMarker(BMFMarker marker) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .deselectMarker(_mapChannel, marker);
  }

  /// 设置地图使显示区域显示所有markers （iOS）since 3.1.0
  ///
  /// 如果数组中只有一个则直接设置地图中心为marker的位置
  /// markers 指定的marker数组
  /// animated 是否启动动画
  Future<bool> showmarkers(
      {required List<BMFMarker> markers,
      required bool animated,
      EdgeInsets? insets}) async {
    return await BMFMapDispatcherFactory.instance.markerDispatcher
        .showmarkers(_mapChannel, markers, animated, insets);
  }
}

/// 地图overlay相关操作
extension OverlayExtension on BMFMapController {
  /// 地图批量添加overlays since 3.4.0
  ///
  /// [List!<BMFOverlay>] overlays
  ///
  /// bool 成功返回true 失败false
  Future<bool> addOverlays(List<BMFOverlay> overlays) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addOverlays(_mapChannel, overlays);
  }

  /// 地图添加TextMarker
  ///
  /// [BMFTextMarker] marker textMarker
  ///
  /// bool 成功返回true 失败false
  Future<bool> addTextMarker(BMFTextMarker marker) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addTextMarker(_mapChannel, marker);
  }

  /// 地图添加IconMarker
  ///
  /// [BMFIconMarker] marker iconMarker
  ///
  /// bool 成功返回true 失败false
  Future<bool> addIconMarker(BMFIconMarker marker) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addIconMarker(_mapChannel, marker);
  }

  /// 地图添加Polyine
  ///
  /// [BMFPolyline] polyline 折线
  ///
  /// bool 成功返回true 失败false
  Future<bool> addPolyline(BMFPolyline polyline) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addPolyline(_mapChannel, polyline);
  }

  /// 地图添加Arcline
  ///
  /// [BMFArcLine] arcline 弧线
  ///
  /// bool 成功返回true 失败false
  Future<bool> addArcline(BMFArcLine arcline) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addArcline(_mapChannel, arcline);
  }

  /// 地图添加Polygon
  ///
  /// [BMFPolygon] polygon 多边形
  ///
  /// bool 成功返回true 失败false
  Future<bool> addPolygon(BMFPolygon polygon) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addPolygon(_mapChannel, polygon);
  }

  /// 地图添加Circle
  ///
  /// [BMFCircle] circle 圆
  ///
  /// bool 成功返回true 失败false
  Future<bool> addCircle(BMFCircle circle) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addCircle(_mapChannel, circle);
  }

  /// 地图添加gradientCircle since 3.4.0
  ///
  /// [BMFGradientCircle] gradientCircle 渐变圆
  ///
  /// bool 成功返回true 失败false
  /// 渐变圆不支持镂空及fillColor
  Future<bool> addGradientCircle(BMFGradientCircle gradientCircle) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addGradientCircle(_mapChannel, gradientCircle);
  }

  /// 地图添加Dot
  ///
  /// [BMFDot] dot 点
  ///
  /// bool 成功返回true 失败false
  Future<bool> addDot(BMFDot dot) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addDot(_mapChannel, dot);
  }

  /// 地图添加[BMFText] Text
  Future<bool> addText(BMFText text) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addText(_mapChannel, text);
  }

  /// 地图添加Ground
  ///
  /// [BMFGround] ground 图片图层
  ///
  /// bool 成功返回true 失败false
  Future<bool> addGround(BMFGround ground) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addGround(_mapChannel, ground);
  }

  /// 地图添加大地曲线 since 3.1.0
  ///
  /// [BMFGeodesicLine] geodesicLine 大地曲线
  ///
  /// bool 成功返回true 失败false
  Future<bool> addGeodesicLine(BMFGeodesicLine geodesicLine) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addGeodesicLine(_mapChannel, geodesicLine);
  }

  /// 地图添加gradientLine since 3.1.0
  ///
  /// [BMFGradientLine] gradientLine 渐变线
  ///
  /// bool 成功返回true 失败false
  Future<bool> addGradientLine(BMFGradientLine gradientLine) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addGradientLine(_mapChannel, gradientLine);
  }

  /// 地图添加prismOverlay since 3.1.0
  ///
  /// [BMFPrismOverlay] prismOverlay 3D棱柱
  ///
  /// bool 成功返回true 失败false
  Future<bool> addPrismOverlay(BMFPrismOverlay prismOverlay) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addPrismOverlay(_mapChannel, prismOverlay);
  }

  /// 地图添加3dModel since 3.1.0
  ///
  /// [BMF3DModelOverlay] modelOverlay 3D模型
  ///
  /// bool 成功返回true 失败false
  Future<bool> add3dModelOverlay(BMF3DModelOverlay modelOverlay) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .add3dModelOverlay(_mapChannel, modelOverlay);
  }

  /// 地图添加海量点 since 3.1.0
  ///
  /// [BMFMultiPointOverlay] multiPointOverlay 海量点
  ///
  /// bool 成功返回true 失败false
  Future<bool> addMultiPointOverlay(
      BMFMultiPointOverlay multiPointOverlay) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addMultiPointOverlay(_mapChannel, multiPointOverlay);
  }

  /// 地图添加动态轨迹 since 3.1.0
  ///
  /// [BMFTraceOverlay] traceOverlay 海量点
  ///
  /// bool 成功返回true 失败false
  Future<bool> addTraceOverlay(BMFTraceOverlay traceOverlay) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addTraceOverlay(_mapChannel, traceOverlay);
  }

  /// 地图指定删除overlay
  ///
  /// overlayId 要删除overlay的id
  ///
  /// bool 成功返回true 失败false
  Future<bool> removeOverlay(String overlayId) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .removeOverlay(_mapChannel, overlayId);
  }

  /// 地图删除overlay
  ///
  /// bool 成功返回true 失败false
  Future<bool> clearOverlays() async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .clearOverlays(_mapChannel);
  }

  /// 地图指定删除trace overlay
  ///
  /// overlayId 要删除overlay的id
  ///
  /// bool 成功返回true 失败false
  Future<bool> removeTraceOverlay(String overlayId) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .removeTraceOverlay(_mapChannel, overlayId);
  }

  /// 添加瓦片图(在线瓦片图在某些Android机型上暂时不生效，等后续升级解决)
  ///
  /// [BMFTile] tile 瓦片图
  ///
  /// bool 成功返回true 失败false
  Future<bool> addTile(BMFTile tile) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .addTile(_mapChannel, tile);
  }

  /// 移除瓦片图
  ///
  /// [BMFTile] tile 瓦片图
  /// bool 成功返回true 失败false
  Future<bool> removeTile(BMFTile tile) async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .removeTile(_mapChannel, tile);
  }
}

/// 地图图层
extension LayerExtension on BMFMapController {
  /// 地图overlay图层与POI图层交换位置  since 3.2.0
  ///
  /// 用于将自定义覆盖物绘制在POI图层之下（例如：解决Polyline绘制遮挡道路名称问题）
  /// 注意：addOverlay后调用此方法
  ///
  /// isSwitch true 交换位置， false 复原位置
  Future<bool> switchOverlayLayerAndPOILayer(bool isSwitch) async {
    return await BMFMapDispatcherFactory.instance.mapLayerDispatcher
        .switchOverlayLayerAndPOILayer(_mapChannel, isSwitch);
  }

  /// 设置是否展示底图poi标签  since 3.4.0
  ///
  /// enable true 展示， false 不展示
  /// type 对应的标签类型
  Future<bool> setPoiTagEnableAndPoiTagType(
      bool enable, BMFPoiTagType type) async {
    return await BMFMapDispatcherFactory.instance.mapLayerDispatcher
        .setPoiTagEnableAndPoiTagType(_mapChannel, enable, type);
  }

  /// 获取是否展示底图poi标签  since 3.4.0
  Future<bool> getPoiTagEnable(BMFPoiTagType type) async {
    return await BMFMapDispatcherFactory.instance.mapLayerDispatcher
        .getPoiTagEnable(_mapChannel, type);
  }

  /// 地图交换图层顺序  since 3.6.0
  /// layer 其中一个图层
  /// otherLayer 另一个图层
  Future<bool> switchLayerOrder(
      BMFLayerType layer, BMFLayerType otherLayer) async {
    return await BMFMapDispatcherFactory.instance.mapLayerDispatcher
        .switchLayerOrder(_mapChannel, layer, otherLayer);
  }

  /// 更改overlay版本
  /// Android独有
  /// 默认overlay2.0
  Future<void> setOverlayUpgrade(bool isUpgrade) async {
    await BMFMapDispatcherFactory.instance.mapLayerDispatcher
    .setOverlayUpgrade(_mapChannel, isUpgrade);
  }

  /// 获取overlay版本
  /// Android独有
  Future<bool> getOverlayUpgrade() async {
    return await BMFMapDispatcherFactory.instance.mapLayerDispatcher
        .getOverlayUpgrade(_mapChannel);
  }
}

/// 粒子效果图层
extension ParticleEffectExtension on BMFMapController {
  ///  显示粒子效果  since 3.5.0
  ///
  /// effect 效果类型
  Future<bool> showParticleEffect(BMFParticleEffectType effect) async {
    return await BMFMapDispatcherFactory.instance.particleEffectDispatcher
        .showParticleEffect(_mapChannel, effect);
  }

  ///  关闭粒子效果  since 3.5.0
  ///
  /// effect 效果类型
  Future<bool> closeParticleEffect(BMFParticleEffectType effect) async {
    return await BMFMapDispatcherFactory.instance.particleEffectDispatcher
        .closeParticleEffect(_mapChannel, effect);
  }

  ///  自定义粒子效果  since 3.5.0
  ///
  /// effect 效果类型
  /// option 自定义参数
  Future<bool> customParticleEffectWithOption(
      BMFParticleEffectType effect, BMFParticleEffectOption option) async {
    return await BMFMapDispatcherFactory.instance.particleEffectDispatcher
        .customParticleEffect(_mapChannel, effect, option);
  }
}

/// 获取原生地图Map组件版权信息 since 3.3.0
extension BMFMapCopyrightInfoExtension on BMFMapController {
  /// 获取原生地图map组件版权信息 since 3.3.0
  Future<Map?> getNativeMapCopyright() async {
    return await BMFMapDispatcherFactory.instance.mapCopyrightInfoDispatcher
        .getNativeMapCopyright(_mapChannel);
  }

  /// 获取原生地图map组件测绘资质 since 3.3.0
  Future<Map?> getNativeMapQualification() async {
    return await BMFMapDispatcherFactory.instance.mapCopyrightInfoDispatcher
        .getNativeMapQualification(_mapChannel);
  }

  /// 获取原生地图map组件审图号 since 3.3.0
  Future<Map?> getNativeMapApprovalNumber() async {
    return await BMFMapDispatcherFactory.instance.mapCopyrightInfoDispatcher
        .getNativeMapApprovalNumber(_mapChannel);
  }
}

/// 屏幕坐标转换相关
extension ProjectionExtension on BMFMapController {
  /// 将屏幕坐标转换成地理坐标 since 3.1.0
  ///
  /// [BMFPoint] point 屏幕坐标
  ///
  /// [BMFCoordinate] 地理坐标
  Future<BMFCoordinate?> convertScreenPointToCoordinate(BMFPoint point) async {
    return await BMFMapDispatcherFactory.instance.projectionDispatcher
        .convertScreenPointToCoordinate(_mapChannel, point);
  }

  /// 将地理坐标转换成屏幕坐标 since 3.1.0
  ///
  /// [BMFCoordinate] location 地理坐标
  ///
  /// [BMFPoint] 屏幕坐标
  Future<BMFPoint?> convertCoordinateToScreenPoint(
      BMFCoordinate location) async {
    return await BMFMapDispatcherFactory.instance.projectionDispatcher
        .convertCoordinateToScreenPoint(_mapChannel, location);
  }

  /// 将三维坐标转化为屏幕坐标 since 3.3.0
  ///
  /// [BMFCoordinate] location 地理坐标
  ///
  /// [double] height 高度
  ///
  /// [BMFPoint] 屏幕坐标
  Future<BMFPoint?> convertScreenPointFromMapPoint3(
      BMFCoordinate location, double height) async {
    return await BMFMapDispatcherFactory.instance.projectionDispatcher
        .convertScreenPointFromMapPoint3(_mapChannel, location, height);
  }
}

/// 聚合marker相关
extension ClusterMarkerExtension on BMFMapController {
  /// 设置聚合是否展示 since 3.9.8
  /// Android独有
  /// [bool] isClusterVisible 是否展示聚合 默认展示
  /// [bool] shouldRefreshCluster 是否需要主动刷新聚合
  Future<bool> setClusterVisible(bool isClusterVisible, bool shouldRefreshCluster) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .setClusterVisible(_mapChannel, isClusterVisible, shouldRefreshCluster);
  }

  /// 获取聚合是否展示 since 3.9.8
  /// Android独有
  Future<bool> getClusterVisible() async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .getClusterVisible(_mapChannel);
  }

  /// 设置需要聚合的marker经纬度 since 3.7.0
  ///
  /// [BMFCoordinate] coordinates 地理坐标集合
  ///
  Future<bool> setClusterCoordinates(List<BMFClusterInfo> clusterInfos) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .setClusterCoordinates(_mapChannel, clusterInfos);
  }

  /// [maxDistanceInDP] 最大聚合距离 单位dp 默认为50dp since 3.7.0
  ///
  /// Android 建议设置100dp，iOS建议设置100-200dp
  Future<bool> setClusterMaxDistanceInDP(int maxDistanceInDP) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .setClusterMaxDistanceInDP(_mapChannel, maxDistanceInDP);
  }

  /// 更新聚合BMFClusterInfo， since 3.7.0
  ///
  /// [List<BMFClusterInfo>] clusterInfos
  Future<bool> updateClusters(List<BMFClusterInfo> clusterInfos) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .updateClusters(_mapChannel, clusterInfos);
  }

  /// 清除聚合marker since 3.7.0
  ///
  Future<bool> cleanCluster() async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .cleanCluster(_mapChannel);
  }

  /// 获取指定级别下聚合后的BMFCluster对象 since 3.7.0
  /// [int] clusterZoom 地图级别
  Future<List<BMFClusterInfo?>> getClusterOnZoomLevel(int clusterZoom) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .getClusterOnZoomLevel(_mapChannel, clusterZoom);
  }

  /// 在合适的时机更新聚合marker，推荐在setMapRegionDidChangeCallback回调中进行更新 since 3.7.0
  /// 可以根据getClusterOnZoomLevel获取到当前层级下的BMFClusterInfo，然后进行marker样式设置
  /// iOS独有  Android暂不支持
  /// [List<BMFClusterInfo>] clusterInfos clusterInfos的样式
  Future<bool> refreshClusters(List<BMFClusterInfo> clusterInfos) async {
    return await BMFMapDispatcherFactory.instance.mapClusterMarkerDispatcher
        .refreshClusters(_mapChannel, clusterInfos);
  }
}

/// 地图相关回调
extension MapCallbackExtension on BMFMapController {
  /// 设置地图加载完成回调
  ///
  /// [BMFMapCallback] callback 回调接口
  void setMapDidLoadCallback({required BMFMapCallback callback}) {
    _methodChannelHandler.setMapDidLoadCallback(callback);
  }

  /// 设置地图渲染回调
  ///
  /// [BMFMapSuccessCallback] callback 回调接口
  void setMapDidFinishedRenderCallback(
      {required BMFMapSuccessCallback callback}) {
    _methodChannelHandler.setMapDidFinishedRenderCallback(callback);
  }

  /// 设置地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）回调接口
  ///
  /// [BMFMapOnDrawMapFrameCallback] callback 回调接口
  void setMapOnDrawMapFrameCallback(
      {required BMFMapOnDrawMapFrameCallback callback}) {
    _methodChannelHandler.setMapOnDrawMapFrameCallback(callback);
  }

  /// 设置地图区域即将改变时会调用接口
  ///
  /// [BMFMapRegionChangeCallback] callback 回调接口
  void setMapRegionWillChangeCallback(
      {required BMFMapRegionChangeCallback callback}) {
    _methodChannelHandler.setMapRegionWillChangeCallback(callback);
  }

  /// 设置地图区域改变完成后会调用接口
  ///
  /// [BMFMapRegionChangeCallback] callback 回调接口
  void setMapRegionDidChangeCallback(
      {required BMFMapRegionChangeCallback callback}) {
    _methodChannelHandler.setMapRegionDidChangeCallback(callback);
  }

  /// 设置地图区域即将改变时会调用接口
  ///
  /// [BMFMapRegionChangeReasonCallback] callback 回调接口
  void setMapRegionWillChangeWithReasonCallback(
      {required BMFMapRegionChangeReasonCallback callback}) {
    _methodChannelHandler.setMapRegionWillChangeWithReasonCallback(callback);
  }

  /// 设置地图区域改变完成后会调用接口
  ///
  /// [BMFMapRegionChangeReasonCallback] callback
  void setMapRegionDidChangeWithReasonCallback(
      {required BMFMapRegionChangeReasonCallback callback}) {
    _methodChannelHandler.setMapRegionDidChangeWithReasonCallback(callback);
  }

  /// 设置地图状态改变完成后回调接口
  ///
  /// [BMFMapCallback] callback 回调接口
  void setMapStatusDidChangedCallback({required BMFMapCallback callback}) {
    _methodChannelHandler.setMapStatusDidChangedCallback(callback);
  }

  /// 设置地图绘制出有效数据的监听回调接口
  ///
  /// [BMFMapRenderValidDataCallback] callback 回调接口
  void setMapRenderValidDataCallback(
      {required BMFMapRenderValidDataCallback callback}) {
    _methodChannelHandler.setMapRenderValidDataCallback(callback);
  }

  /// 切换定位模式会调用此接口
  ///
  /// [BMFUserTrackingModeChangedCallback] callback 回调接口
  void setUserTrackingModeChangedCallback(
      {required BMFUserTrackingModeChangedCallback callback}) {
    _methodChannelHandler.setUserTrackingModeChangedCallback(callback);
  }
}

/// 室内图相关回调
extension IndoorMapCallbackExtension on BMFMapController {
  /// 设置地图View进入/移出室内地图回调接口
  ///
  /// [BMFMapInOrOutBaseIndoorMapCallback] callback 回调接口
  void setMapInOrOutBaseIndoorMapCallback(
      {required BMFMapInOrOutBaseIndoorMapCallback callback}) {
    _methodChannelHandler.setMapInOrOutBaseIndoorMapCallback(callback);
  }
}

/// 地图手势相关回调
extension MapGestureCallbackExtension on BMFMapController {
  /// 设置点中底图标注后会回调接口
  ///
  /// [BMFMapOnClickedMapPoiCallback] callback 回调接口
  void setMapOnClickedMapPoiCallback(
      {required BMFMapOnClickedMapPoiCallback callback}) {
    _methodChannelHandler.setMapOnClickedMapPoiCallback(callback);
  }

  /// 设置点中底图空白处会回调接口
  ///
  /// [BMFMapCoordinateCallback] callback 回调接口
  void setMapOnClickedMapBlankCallback(
      {required BMFMapCoordinateCallback callback}) {
    _methodChannelHandler.setMapOnClickedMapBlankCallback(callback);
  }

  /// 设置双击地图时会回调接口
  ///
  /// [BMFMapCoordinateCallback] callback 回调接口
  void setMapOnDoubleClickCallback(
      {required BMFMapCoordinateCallback callback}) {
    _methodChannelHandler.setMapOnDoubleClickCallback(callback);
  }

  /// 设置长按地图时会回调接口
  ///
  /// [BMFMapCoordinateCallback] callback 回调接口
  void setMapOnLongClickCallback({required BMFMapCoordinateCallback callback}) {
    _methodChannelHandler.setMapOnLongClickCallback(callback);
  }

  /// 设置3DTouch回调接口
  ///
  /// [BMFMapOnForceTouchCallback] callback 回调接口
  void setMapOnForceTouchCallback(
      {required BMFMapOnForceTouchCallback callback}) {
    _methodChannelHandler.setMapOnForceTouchCallback(callback);
  }
}

/// overlay相关回调
extension OverlayCallbackExtension on BMFMapController {
  /// 地图点击覆盖物回调，目前只支持点中Polyline,Text时回调
  ///
  /// [BMFMapOnClickedOverlayCallback] callback 回调接口
  void setMapOnClickedOverlayCallback(
      {required BMFMapOnClickedOverlayCallback callback}) {
    _methodChannelHandler.setMapOnClickedOverlayCallback(callback);
  }

  /// 设置地图点击海量点回调 since 3.2.0
  void setMapOnClickedMultiPointOverlaItemCallback(
      {required BMFMapOnClickedMultiPointOverlayItemCallback callback}) {
    _methodChannelHandler.setMapOnClickedMultiPointOverlaItemCallback(callback);
  }

  /// 设置动态轨迹动画开始回调 since 3.2.0
  void setTraceOverlayAnimationDidStartCallback(
      BMFTraceOverlayAnimationDidStartCallback callback) {
    _methodChannelHandler.setTraceOverlayAnimationDidStartCallback(callback);
  }

  /// 设置动态轨迹动画进度回调 since 3.2.0
  void setTraceOverlayAnimationRunningProgressCallback(
      BMFTraceOverlayAnimationRunningProgressCallback callback) {
    _methodChannelHandler
        .setTraceOverlayAnimationRunningProgressCallback(callback);
  }

  /// 设置动态轨迹动画结束回调 since 3.2.0
  void setTraceOverlayAnimationDidEndCallback(
      BMFTraceOverlayAnimationDidEndCallback callback) {
    _methodChannelHandler.setTraceOverlayAnimationDidEndCallback(callback);
  }

  /// 设置动态轨迹动画更新的当前位置点回调 since 3.2.0
  ///
  /// Android 独有
  void setTraceOverlayAnimationUpdatePositionCallback(
      BMFTraceOverlayAnimationUpdatePositionCallback callback) {
    _methodChannelHandler
        .setTraceOverlayAnimationUpdatePositionCallback(callback);
  }

  /// 楼层动画结束回调 since 3.5.0
  void setPrismOverlayViewFloorAnimationDidEndCallback(
      BMFPrismOverlayViewFloorAnimationDidEndCallback callback) {
    _methodChannelHandler
        .setPrismOverlayViewFloorAnimationDidEndCallback(callback);
  }
}

/// heatMap相关回调
extension HeatMapCallbackExtension on BMFMapController {
  /// heatMap点击回调
  ///
  /// [HeatMapCallbackExtension] callback 回调接口
  void setHeatMapFrameAnimationIndexCallback(
      {required BMFHeatMapFrameAnimationCallback callback}) {
    _methodChannelHandler.setHeatMapFrameAnimationIndexCallback(callback);
  }
}

/// marker相关回调
extension MarkerCallbackExtension on BMFMapController {
  /// 设置marker点击回调
  ///
  /// [BMFMapMarkerCallback] callback 回调接口
  void setMapClickedMarkerCallback({required BMFMapMarkerCallback callback}) {
    _methodChannelHandler.setMapClickedMarkerCallback(callback);
  }

  /// 设置marker选中回调
  ///
  /// [BMFMapMarkerCallback] callback 回调接口
  ///
  /// iOS 独有
  void setMaptDidSelectMarkerCallback(
      {required BMFMapMarkerCallback callback}) {
    _methodChannelHandler.setMaptDidSelectMarkerCallback(callback);
  }

  /// 设置marker取消回调
  ///
  /// [BMFMapMarkerCallback] callback 回调接口
  ///
  /// Android不支持该接口
  void setMapDidDeselectMarkerCallback(
      {required BMFMapMarkerCallback callback}) {
    _methodChannelHandler.setMapDidDeselectMarkerCallback(callback);
  }

  /// 设置marker拖拽回调
  ///
  /// [BMFMapMarkerCallback] callback 回调接口
  void setMapDragMarkerCallback({required BMFMapDragMarkerCallback callback}) {
    _methodChannelHandler.setMapDragMarkerCallback(callback);
  }

  /// 设置marker的infoWindow（iOS paopaoView）点击回调
  ///
  /// [BMFMapMarkerCallback] callback 回调接口
  void setMapDidClickedInfoWindowCallback(
      {required BMFMapMarkerCallback callback}) {
    _methodChannelHandler.setMapDidClickedInfoWindowCallback(callback);
  }
}

extension ClusterCallbackExtension on BMFMapController {
  /// 设置点聚合的点击回调
  /// android 独有
  /// [BMFMapClusterCallback] callback 回调接口
  void setMapClusterClickCallback({required BMFMapClusterCallback callback}) {
    _methodChannelHandler.setClusterClickCallback(callback);
  }

  /// 设置点聚合的Item点击回调
  ///
  /// [BMFMapClusterClickItemCallback] callback 回调接口
  void setMapClusterItemClickCallback(
      {required BMFMapClusterClickItemCallback callback}) {
    _methodChannelHandler.setClusterItemClickCallback(callback);
  }
}
