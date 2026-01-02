import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil, BMFCoordinateBounds;
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_linedraw_types.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 弧线
class BMFArcLine extends BMFOverlay implements BMFOverlayBoundsInterface {
  /// 经纬度数组三个点确定一条弧线
  late List<BMFCoordinate> coordinates;

  /// 设置arclineView的线宽度
  int? width;

  /// 设置arclineView的画笔颜色
  Color? color;

  /// 虚线类型,iOS独有
  BMFLineDashType? lineDashType;

  /// 是否可点击，默认为flase since 3.5.0
  bool? clickable;

  /// BMFArcline构造方法
  BMFArcLine({
    required this.coordinates,
    this.width = 5,
    this.color = Colors.blue,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.clickable = false,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 2),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFArcline
  BMFArcLine.fromMap(Map map)
      : assert(map['coordinates'] != null),
        super.fromMap(map) {
    if (map['coordinates'] != null) {
      coordinates = <BMFCoordinate>[];
      map['coordinates'].forEach((v) {
        coordinates.add(BMFCoordinate.fromMap(v as Map));
      });
    }
    width = (map['width'] as num?)?.toInt();
    color = ColorUtil.hexToColor(map['color']);
    if (map['lineDashType'] != null) {
      lineDashType = BMFLineDashType.values[map['lineDashType'] as int];
    }
    clickable = map['clickable'] as bool;
  }

  @override
  fromMap(Map map) {
    return BMFArcLine.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates.map((coord) => coord.toMap()).toList(),
        'width': this.width,
        'color': this.color?.value.toRadixString(16),
        'lineDashType': this.lineDashType?.index,
        'clickable': this.clickable,
      });
  }

  @override
  Future<BMFCoordinateBounds?> get bounds async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .getBounds(this);
  }
}

/// arcline 更新
extension BMFArcLineUpdateExtension on BMFArcLine {
  /// 更新经纬度数组
  ///
  /// List<[BMFCoordinate]> coordinates arcline经纬度数组
  Future<bool> updateCoordinates(List<BMFCoordinate> coordinates) async {
    ArgumentError.checkNotNull(coordinates, "coordinates");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateArclineMember(this.methodChannel, {
      'id': this.id,
      'member': 'coordinates',
      'value': coordinates.map((coordinate) => coordinate.toMap()).toList()
    });

    if (ret) {
      this.coordinates = coordinates;
    }

    return ret;
  }

  /// 更新线宽
  Future<bool> updateWidth(int width) async {
    if (width < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateArclineMember(this.methodChannel,
            {'id': this.id, 'member': 'width', 'value': width});

    if (ret) {
      this.width = width;
    }

    return ret;
  }

  /// 更新color
  Future<bool> updateColor(Color color) async {
    ArgumentError.checkNotNull(color, "color");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateArclineMember(this.methodChannel, {
      'id': this.id,
      'member': 'color',
      'value': color.value.toRadixString(16)
    });

    if (ret) {
      this.color = color;
    }

    return ret;
  }

  /// 虚线类型，iOS独有
  ///
  /// [BMFLineDashType] lineDashType  虚线类型
  Future<bool> updateLineDashType(BMFLineDashType lineDashType) async {
    if (this.lineDashType == lineDashType) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateArclineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineDashType',
      'value': lineDashType.index
    });

    if (ret) {
      this.lineDashType = lineDashType;
    }

    return ret;
  }
}
