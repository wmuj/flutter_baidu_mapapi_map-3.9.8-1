import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

/// mapView属性集合
class BMFMapOptions {
  /// 当前地图类型，默认标准地图
  ///
  /// 空白地图 = BMFMapType.None
  ///
  /// 标准地图 = BMFMapType.Standard
  ///
  /// 卫星地图 = BMFMapType.Satellite
  BMFMapType mapType;

  /// 地图底图语言类型 （暂不支持多地图） since 3.1.0
  ///
  /// Chinese: 中文地图
  ///
  /// English: 英文地图
  ///
  /// 默认BMFMapLanguageType.Chinese中文地图；
  BMFMapLanguageType languageType;

  /// 设置地图字体大小 since 3.1.0
  ///
  /// 共4个级别(Small: 小, Standard: 标准, Large: 大, Larger: 特大)
  ///
  /// 默认标准字体BMFMapFontSizeLevel.Standard
  BMFMapFontSizeLevel fontSizeLevel;

  /// 空白地图的背景色 since 3.4.0
  /// 默认白色
  Color? backgroundColor;

  /// 自定义底图加载时的背景网格图片，仅支持png格式 since 3.6.0
  /// 默认为背景网格图片
  /// 注：图片不得大于500KB，像素过大时，务必压缩图片后再设置，避免渲染损耗过多性能导致地图卡顿。
  String? backgroundImage;

  /// 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
  BMFCoordinateBounds? limitMapBounds;

  /// 指南针的位置，设定坐标以BMFMapView左上角为原点，向右向下增长
  BMFPoint? compassPosition;

  /// 是否显示指南针
  bool compassEnabled;

  /// 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
  BMFCoordinate? center;

  /// 地图比例尺级别，在手机上当前可使用的级别为4-21级
  int? zoomLevel;

  /// 地图的自定义最小比例尺级别
  int? minZoomLevel;

  /// 地图的自定义最大比例尺级别
  int? maxZoomLevel;

  /// 地图旋转角度，在手机上当前可使用的范围为－180～180度 (ios取int值)
  double? rotation;

  /// 地图俯视角度，在手机上当前可使用的范围为－45～0度 (ios取int值)
  double? overlooking;

  /// 地图俯视角度最小值（即角度最大值），在手机上当前可设置的范围为-79～0度
  ///
  /// iOS独有
  int? minOverlooking;

  /// 设定地图是否现显示3D楼块效果
  bool buildingsEnabled;

  /// 设定地图是否显示底图poi标注(不包含室内图标注)，默认true
  bool showMapPoi;

  /// 设定地图是否打开路况图层
  bool trafficEnabled;

  /// 设定地图是否打开百度城市热力图图层（百度自有数据）,
  ///
  /// 注：地图层级大于11时，可显示热力图
  bool baiduHeatMapEnabled;

  /// 设定地图View能否支持所有手势操作
  bool gesturesEnabled;

  /// 设置是否允许抛出手势
  ///
  /// Android 独有
  bool flingEnable;

  /// 设置双击放大是否按照设置的屏幕或地理坐标为放大中心点
  /// 默认：false 即按照手势中心点放大，true：按照设置的屏幕或地理坐标为放大中心点
  /// Android 独有
  bool doubleClickGesturesEnable;

  /// 设置屏幕坐标为手势中心点
  /// 手势中心点地理和屏幕坐标只能设置一个生效，默认屏幕坐标优先级更高
  /// Android 独有
  BMFPoint? pointGestures;

  /// 设置地理坐标为手势中心点
  /// 手势中心点地理和屏幕坐标只能设置一个生效，默认屏幕坐标优先级更高
  /// Android 独有
  BMFCoordinate? latLngGestures;

  /// 设定地图View能否支持用户多点缩放(双指)
  bool zoomEnabled;

  /// 设定地图View能否支持用户缩放(双指单击)
  bool zoomEnabledWithTap;

  /// 设定地图View能否支持用户缩放(单指双击)
  bool zoomEnabledWithDoubleClick;

  /// 设定地图View能否支持用户移动地图
  bool scrollEnabled;

  /// 设定地图View能否支持俯仰角
  bool overlookEnabled;

  /// 设定地图View能否支持旋转
  bool rotateEnabled;

  /// 设定地图是否回调force touch事件，默认为false，仅适用于支持3D Touch的情况，
  ///
  /// 开启后会回调 - mapview:onForceTouch:force:maximumPossibleForce:
  ///
  /// iOS独有
  bool? forceTouchEnabled;

  /// 设定是否显示比例尺
  bool showMapScaleBar;

  /// 比例尺的位置，设定坐标以BMFMapWidget左上角为原点，向右向下增长
  BMFPoint? mapScaleBarPosition;

  /// 设置是否显示缩放控件
  ///
  /// Android独有
  bool? showZoomControl;

  /// 缩放控件的位置，设定坐标以BMFMapWidget左上角为原点，向右向下增长
  ///
  /// Android独有
  BMFPoint? mapZoomControlPosition;

  /// logo位置 默认BMFLogoPositionLeftBottom
  BMFLogoPosition? logoPosition;

  /// 当前地图可显示范围(东北，西南)角坐标
  BMFCoordinateBounds? visibleMapBounds;

  /// 地图预留边界，默认：(top:0, left:0, bottom:0, right:0)。
  ///
  /// 注：设置后，会根据mapPadding调整logo、比例尺、指南针的位置。
  ///
  /// 当updateTargetScreenPtWhenMapPaddingChanged==true时，地图中心(屏幕坐标：BMFMapStatus.targetScreenPt)跟着改变
  BMFEdgeInsets? mapPadding;

  /// 设置mapPadding时，地图中心(屏幕坐标：BMFMapStatus.targetScreenPt)是否跟着改变，默认true
  ///
  /// iOS独有
  bool? updateTargetScreenPtWhenMapPaddingChanged;

  /// 设定双指手势操作时，BMFMapView的旋转和缩放效果的中心点。
  ///
  /// 设置为true时，以手势的中心点（二个指头的中心点）为中心进行旋转和缩放，地图中心点会改变；
  ///
  /// 设置为false时，以当前地图的中心点为中心进行旋转和缩放，地图中心点不变；
  ///
  /// 默认值为false。
  ///
  /// (iOS独有)
  bool? changeWithTouchPointCenterEnabled;

  /// 设定双击手势放大地图时，BMFMapView的放大效果的中心点。
  ///
  /// 设置为true时，以双击的位置为中心点进行放大，地图中心点会改变；
  ///
  /// 设置为false时，以当前地图的中心点为中心进行放大，地图中心点不变；
  ///
  /// 默认值为true。
  bool changeCenterWithDoubleTouchPointEnabled;

  /// 设定地图是否显示室内图（包含室内图标注），默认不显示
  bool baseIndoorMapEnabled;

  /// 设定室内图标注是否显示，默认true，仅当显示室内图（baseIndoorMapEnabled为true）时生效
  bool showIndoorMapPoi;

  /// 地图是否展示运营图层 默认true since 3.2.0
  bool showOperateLayer;

  /// 地图是否展示地形图层默认false，since 3.6.0
  bool showDEMLayer;

  /// BMFMapOptions构造方法
  BMFMapOptions({
    this.mapType = BMFMapType.Standard,
    this.languageType = BMFMapLanguageType.Chinese,
    this.backgroundColor,
    this.backgroundImage,
    this.fontSizeLevel = BMFMapFontSizeLevel.Standard,
    this.limitMapBounds,
    this.compassPosition,
    this.compassEnabled = false,
    this.center,
    this.zoomLevel,
    this.minZoomLevel,
    this.maxZoomLevel,
    this.showZoomControl = true,
    this.rotation,
    this.overlooking,
    this.minOverlooking,
    this.buildingsEnabled = true,
    this.showMapPoi = true,
    this.trafficEnabled = false,
    this.baiduHeatMapEnabled = false,
    this.gesturesEnabled = true,
    this.flingEnable = true,
    this.doubleClickGesturesEnable = false,
    this.pointGestures,
    this.latLngGestures,
    this.zoomEnabled = true,
    this.zoomEnabledWithTap = true,
    this.zoomEnabledWithDoubleClick = true,
    this.scrollEnabled = true,
    this.overlookEnabled = true,
    this.rotateEnabled = true,
    this.forceTouchEnabled = false,
    this.showMapScaleBar = true,
    this.mapScaleBarPosition,
    this.mapZoomControlPosition,
    this.logoPosition = BMFLogoPosition.LeftBottom,
    this.visibleMapBounds,
    this.mapPadding,
    this.updateTargetScreenPtWhenMapPaddingChanged = true,
    this.changeWithTouchPointCenterEnabled = false,
    this.changeCenterWithDoubleTouchPointEnabled = true,
    this.baseIndoorMapEnabled = false,
    this.showIndoorMapPoi = true,
    this.showOperateLayer = true,
    this.showDEMLayer = false,
  });

  /// BMFMapOptions -> map
  Map<String, Object?> toMap() {
    return {
      'mapType': this.mapType.index,
      'languageType': this.languageType.index,
      'backgroundColor': this.backgroundColor?.value.toRadixString(16),
      'backgroundImage': this.backgroundImage,
      'fontSizeLevel': this.fontSizeLevel.index,
      'limitMapBounds': this.limitMapBounds?.toMap(),
      'compassPosition': this.compassPosition?.toMap(),
      'compassEnabled': this.compassEnabled,
      'center': this.center?.toMap(),
      'zoomLevel': this.zoomLevel,
      'minZoomLevel': this.minZoomLevel,
      'maxZoomLevel': this.maxZoomLevel,
      'showZoomControl': this.showZoomControl,
      'rotation': this.rotation,
      'overlooking': this.overlooking,
      'minOverlooking': this.minOverlooking,
      'buildingsEnabled': this.buildingsEnabled,
      'showMapPoi': this.showMapPoi,
      'trafficEnabled': this.trafficEnabled,
      'baiduHeatMapEnabled': this.baiduHeatMapEnabled,
      'gesturesEnabled': this.gesturesEnabled,
      'flingEnable': this.flingEnable,
      'doubleClickGesturesEnable': this.doubleClickGesturesEnable,
      'pointGestures': this.pointGestures?.toMap(),
      'latLngGestures': this.latLngGestures?.toMap(),
      'zoomEnabled': this.zoomEnabled,
      'zoomEnabledWithTap': this.zoomEnabledWithTap,
      'zoomEnabledWithDoubleClick': this.zoomEnabledWithDoubleClick,
      'scrollEnabled': this.scrollEnabled,
      'overlookEnabled': this.overlookEnabled,
      'rotateEnabled': this.rotateEnabled,
      'forceTouchEnabled': this.forceTouchEnabled,
      'showMapScaleBar': this.showMapScaleBar,
      'mapScaleBarPosition': this.mapScaleBarPosition?.toMap(),
      'mapZoomControlPosition': this.mapZoomControlPosition?.toMap(),
      'logoPosition': this.logoPosition?.index,
      'visibleMapBounds': this.visibleMapBounds?.toMap(),
      'mapPadding': this.mapPadding?.toMap(),
      'updateTargetScreenPtWhenMapPaddingChanged':
          this.updateTargetScreenPtWhenMapPaddingChanged,
      'changeWithTouchPointCenterEnabled':
          this.changeWithTouchPointCenterEnabled,
      'changeCenterWithDoubleTouchPointEnabled':
          this.changeCenterWithDoubleTouchPointEnabled,
      'baseIndoorMapEnabled': this.baseIndoorMapEnabled,
      'showIndoorMapPoi': this.showIndoorMapPoi,
      'showOperateLayer': this.showOperateLayer,
      'showDEMLayer': this.showDEMLayer,
    };
  }
}

/// 地图语言类型
enum BMFMapLanguageType {
  /// 中文地图
  Chinese,

  /// 英文地图
  English
}

/// 地图字体大小
enum BMFMapFontSizeLevel {
  /// 小
  Small,

  /// 标准
  Standard,

  /// 大
  Large,

  /// 特大
  Larger
}
