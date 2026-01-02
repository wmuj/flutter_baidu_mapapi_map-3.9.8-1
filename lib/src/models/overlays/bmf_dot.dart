import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 点
///
/// Android独有
class BMFDot extends BMFOverlay {
  /// 圆心点经纬度
  late BMFCoordinate center;

  /// 圆的半径(单位米)
  late double radius;

  /// 圆的颜色
  late Color color;

  /// BMFDot构造方法
  BMFDot({
    required this.center,
    required this.radius,
    required this.color,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFDot
  BMFDot.fromMap(Map map)
      : assert(map['center'] != null),
        assert(map['radius'] != null),
        assert(map['color'] != null),
        super.fromMap(map) {
    center = BMFCoordinate.fromMap(map['center']);
    radius = map['radius'];
    color = ColorUtil.hexToColor(map['color']);
  }

  @override
  fromMap(Map map) {
    return BMFDot.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'center': this.center.toMap(),
        'radius': this.radius,
        'color': this.color.value.toRadixString(16),
      });
  }
}

/// dot更新
extension BMFDotUpdateExtension on BMFDot {
  /// 更新中心点center
  ///
  /// [BMFCoordinate] center Dot经纬度数组
  Future<bool> updateCenter(BMFCoordinate center) async {
    ArgumentError.checkNotNull(center, "center");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateDotMember(this.methodChannel,
            {'id': this.id, 'member': 'center', 'value': center.toMap()});

    if (ret) {
      this.center = center;
    }

    return ret;
  }

  /// 更新半径
  ///
  /// radius Dot半径
  Future<bool> updateRadius(double radius) async {
    if (radius < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateDotMember(this.methodChannel,
            {'id': this.id, 'member': 'radius', 'value': radius});

    if (ret) {
      this.radius = radius;
    }

    return ret;
  }

  /// 更新颜色
  ///
  /// [Color]color 颜色
  Future<bool> updateColor(Color color) async {
    ArgumentError.checkNotNull(color, "color");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateDotMember(this.methodChannel, {
      'id': this.id,
      'member': 'color',
      'value': color.value.toRadixString(16)
    });

    if (ret) {
      this.color = color;
    }

    return ret;
  }

  /// 更新Dot是否显示
  /// Android独有
  /// [bool] visible 显示状态
  Future<bool> updateVisible(bool visible) async {
    ArgumentError.checkNotNull(visible, "visible");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateDotMember(this.methodChannel,
            {'id': this.id, 'member': 'visible', 'value': visible});

    if (ret) {
      this.visible = visible;
    }

    return ret;
  }
}
