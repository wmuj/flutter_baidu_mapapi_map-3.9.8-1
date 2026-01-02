import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate, ColorUtil, BMFCoordinateBounds;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

/// 动态轨迹 since 3.1.0
class BMFTraceOverlay extends BMFOverlay implements BMFOverlayBoundsInterface {
  /// 经纬度数组三个点确定一条弧线
  late List<BMFCoordinate> coordinates;

  /// 设置arclineView的线宽度
  int? width;

  /// 边框颜色
  /// IOS 独有参数
  Color? strokeColor;

  /// 填充色
  Color? fillColor;

  /// 轨迹的strokeColors 用于颜色绘制 since 3.5.0
  /// 注意：strokeColors 长度与轨迹点的个数必须保持一致
  List<Color>? strokeColors;

  /// 是否使用渐变色 默认为false since 3.5.0
  /// 注意：要配合strokeColors使用，否则无效
  bool? isGradientColor;

  /// 是否使用发光效果 默认为false since 3.5.0
  bool? isTrackBloom;

  /// 轨迹发光参数 since 3.5.0
  /// 取值范围 [1.0f ~ 10.0f]，默认值为 5.0f
  /// 注意：渐变发光模式下该属性生效
  double? bloomSpeed;

  /// 是否需要对TraceOverlay坐标数据进行抽稀，默认为true since 3.5.0
  bool? isThined;

  /// 是否需要对TraceOverlay坐标数据进拐角平滑，默认为true since 3.5.0
  bool? isCornerSmooth;

  /// traceOverlay动画参数
  late BMFTraceOverlayAnimateOption traceOverlayAnimateOption;

  /// 动态轨迹构造方法
  BMFTraceOverlay({
    required this.coordinates,
    required this.traceOverlayAnimateOption,
    this.width = 5,
    this.strokeColor = Colors.blue,
    this.fillColor = Colors.green,
    this.isTrackBloom = false,
    this.isGradientColor = false,
    this.bloomSpeed = 5.0,
    this.isThined = true,
    this.isCornerSmooth = true,
    this.strokeColors = const [],
    int zIndex = 0,
    bool visible = true,
  })  : assert(coordinates.length > 1),
        super(zIndex: zIndex, visible: visible);

  /// map => BMFTraceOverlay
  BMFTraceOverlay.fromMap(Map map)
      : assert(map['coordinates'] != null),
        assert(map['traceOverlayAnimateOption'] != null),
        super.fromMap(map) {
    if (map['coordinates'] != null) {
      coordinates = <BMFCoordinate>[];
      map['coordinates'].forEach((v) {
        coordinates.add(BMFCoordinate.fromMap(v as Map));
      });
    }
    traceOverlayAnimateOption =
        BMFTraceOverlayAnimateOption.formMap(map['traceOverlayAnimateOption']);
    width = (map['width'] as num?)?.toInt();
    strokeColor = ColorUtil.hexToColor(map['strokeColor']);
    fillColor = ColorUtil.hexToColor(map['fillColor']);
    if (map['isGradientColor'] != null) {
      isGradientColor = map['isGradientColor'] as bool;
    }
    if (map['isTrackBloom'] != null) {
      isTrackBloom = map['isTrackBloom'] as bool;
    }
    bloomSpeed = (map['bloomSpeed'] as num?)?.toDouble();
    if (map['isThined'] != null) {
      isThined = map['isThined'] as bool;
    }
    if (map['isCornerSmooth'] != null) {
      isCornerSmooth = map['isCornerSmooth'] as bool;
    }
    if (map['strokeColors'] != null) {
      strokeColors = <Color>[];
      map['strokeColors'].forEach((v) {
        strokeColors!.add(ColorUtil.hexToColor(v as String));
      });
    }
  }

  @override
  fromMap(Map map) {
    return BMFTraceOverlay.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates.map((coord) => coord.toMap()).toList(),
        'traceOverlayAnimateOption': this.traceOverlayAnimateOption.toMap(),
        'width': this.width,
        'strokeColor': this.strokeColor?.value.toRadixString(16),
        'fillColor': this.fillColor?.value.toRadixString(16),
        'isGradientColor': this.isGradientColor,
        'isTrackBloom': this.isTrackBloom,
        'bloomSpeed': this.bloomSpeed,
        'isThined': this.isThined,
        'isCornerSmooth': this.isCornerSmooth,
        'strokeColors': this
            .strokeColors
            ?.map((color) => color.value.toRadixString(16))
            .toList(),
      });
  }

  @override
  Future<BMFCoordinateBounds?> get bounds async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .getBounds(this);
  }
}

extension BMFTraceOverlayUpdateExtension on BMFTraceOverlay {
  /// 暂停动态轨迹绘制 since 3.6.0
  Future<bool> pauseTraceOverlayDraw() async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .pauseTraceOverlayDraw(this.methodChannel, this);
  }

  /// 继续动态轨迹绘制 since 3.6.0
  Future<bool> resumeTraceOverlayDraw() async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .resumeTraceOverlayDraw(this.methodChannel, this);
  }
}

/// traceOverlay动画参数
class BMFTraceOverlayAnimateOption implements BMFModel {
  /// traceOverlay是否做动画, 默认true
  bool? animate;

  /// 动画延时开始，单位s
  double? delay;

  /// 动画时间，单位s
  double? duration;

  /// 0~1， 默认0
  /// IOS 独有参数
  double? fromValue;

  /// 0~1，默认1
  /// IOS 独有参数
  double? toValue;

  /// 动画类型
  BMFTraceOverlayAnimationEasingCurve? easingCurve;

  /// 是否跟踪轨迹, 默认true
  bool? trackMove;

  /// 点平滑移动, 默认false
  bool? isPointMove;

  /// 轨迹跟踪时地图是否跟着旋转, 默认true
  bool? isRotateWhenTrack;

  /// 点图标显示路径
  String? icon;

  /// 3d模型
  BMFTrace3DModelOption? modelOption;

  /// traceOverlay动画参数构造方法
  BMFTraceOverlayAnimateOption(
      {this.animate = true,
      this.delay,
      this.duration,
      this.fromValue = 0,
      this.toValue = 1,
      this.easingCurve,
      this.trackMove = true,
      this.isPointMove = false,
      this.isRotateWhenTrack = true,
      this.icon,
      this.modelOption});

  /// map => BMFTraceOverlayAnimateOption
  BMFTraceOverlayAnimateOption.formMap(Map map)
      : assert(map != null) // ignore: unnecessary_null_comparison
  {
    animate = map['animate'] as bool;
    delay = (map['delay'] as num?)?.toDouble();
    duration = (map['duration'] as num?)?.toDouble();
    fromValue = (map['fromValue'] as num?)?.toDouble();
    toValue = (map['toValue'] as num?)?.toDouble();
    easingCurve =
        BMFTraceOverlayAnimationEasingCurve.values[map['easingCurve'] as int];
    trackMove = map['trackMove'] as bool;
    isPointMove = map['isPointMove'] as bool;
    isRotateWhenTrack = map['isRotateWhenTrack'] as bool;
    if (map['icon'] != null) {
      icon = map['icon'];
    }
    if (map['modelOption'] != null) {
      modelOption = BMFTrace3DModelOption.fromMap(map['modelOption']);
    }
  }

  @override
  fromMap(Map map) {
    return BMFTraceOverlayAnimateOption.formMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'animate': this.animate,
      'delay': this.delay,
      'duration': this.duration,
      'fromValue': this.fromValue,
      'toValue': this.toValue,
      'easingCurve': this.easingCurve?.index,
      'trackMove': this.trackMove,
      'isPointMove': this.isPointMove,
      'isRotateWhenTrack': this.isRotateWhenTrack,
      'icon': this.icon,
      'modelOption': this.modelOption?.toMap(),
    };
  }
}

class BMFTrace3DModelOption extends BMF3DModelOption {
  /// 轨迹动画中模型的偏航轴，即模型与右手坐标系Z轴重合的轴
  BMFTraceOverlay3DModelYawAxis? yawAxis;

  BMFTrace3DModelOption(
      {required String modelPath,
      required String modelName,
      this.yawAxis,
      double scale = 1,
      bool zoomFixed = false,
      double rotateX = 0,
      double rotateY = 0,
      double rotateZ = 0,
      double offsetX = 0,
      double offsetY = 0,
      double offsetZ = 0,
      BMF3DModelType type = BMF3DModelType.BMF3DModelTypeObj,
      bool animationIsEnable = false,
      int animationIndex = 0,
      int animationRepeatCount = 0,
      double animationSpeed = 1})
      : super(
            modelPath: modelPath,
            modelName: modelName,
            scale: scale,
            zoomFixed: zoomFixed,
            rotateX: rotateX,
            rotateY: rotateY,
            rotateZ: rotateZ,
            offsetX: offsetX,
            offsetY: offsetY,
            offsetZ: offsetZ,
            type: type,
            animationIsEnable: animationIsEnable,
            animationIndex: animationIndex,
            animationRepeatCount: animationRepeatCount,
            animationSpeed: animationSpeed);

  /// map => BMFText
  BMFTrace3DModelOption.fromMap(Map map)
      : assert(map['modelPath'] != null),
        assert(map['modelName'] != null),
        super.fromMap(map) {
    yawAxis = BMFTraceOverlay3DModelYawAxis.values[map['yawAxis'] as int];
  }

  @override
  fromMap(Map map) {
    return BMFTrace3DModelOption.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'yawAxis': this.yawAxis?.index,
      });
  }
}

/// traceoverlay动画枚举
enum BMFTraceOverlayAnimationEasingCurve {
  /// 线性
  Linear,

  /// 淡入
  EaseIn,

  /// 淡出
  EaseOut,

  /// 淡入淡出
  EaseInOut
}

/// 轨迹动画中模型的偏航轴，即模型与右手坐标系Z轴重合的轴
enum BMFTraceOverlay3DModelYawAxis {
  YawAxisZ,
  YawAxisX,
  YawAxisY,
}
