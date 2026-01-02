import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil, BMFCoordinateBounds;
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_linedraw_types.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';
import 'bmf_overlay.dart';

/// 渐变线 since 3.1.0
class BMFGradientLine extends BMFOverlay implements BMFOverlayBoundsInterface {
  /// 经纬度数组
  late List<BMFCoordinate> coordinates;

  /// 分段索引
  late List<int> indexs;

  /// 线宽
  int? width;

  /// 渐变线的colors
  late List<Color> colors;

  /// 是否抽稀 默认ture
  bool? isThined;

  /// 是否可点击 默认为true  since 3.5.0
  bool? clickable;

  /// 渐变线经度跨180所需字段
  ///
  /// 默认BMFLineDirectionCross180Type.None, 不跨经度180.
  BMFLineDirectionCross180Type? lineDirectionCross180;

  /// 渐变线构造方法
  BMFGradientLine({
    required this.coordinates,
    required this.indexs,
    required this.colors,
    this.width = 5,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        assert(indexs.length > 0),
        assert(colors.length > 0),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFGradientLine
  BMFGradientLine.fromMap(Map map)
      : assert(map['coordinates'] != null),
        assert(map['indexs'] != null),
        assert(map['colors'] != null),
        super.fromMap(map) {
    if (map['coordinates'] != null) {
      coordinates = <BMFCoordinate>[];
      map['coordinates'].forEach((v) {
        coordinates.add(BMFCoordinate.fromMap(v as Map));
      });
    }

    if (map['indexs'] != null) {
      indexs = <int>[];
      map['indexs'].forEach((v) {
        indexs.add(v as int);
      });
    }

    if (map['colors'] != null) {
      colors = <Color>[];
      map['colors'].forEach((v) {
        colors.add(ColorUtil.hexToColor(v as String));
      });
    }

    width = (map['width'] as num?)?.toInt();
    lineDirectionCross180 = BMFLineDirectionCross180Type
        .values[map['lineDirectionCross180'] as int];
    isThined = map['isThined'] as bool?;
    clickable = map['clickable'] as bool?;
  }

  @override
  fromMap(Map map) {
    return BMFGradientLine.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates.map((coord) => coord.toMap()).toList(),
        'indexs': this.indexs.map((index) => index).toList(),
        'width': this.width,
        'colors':
            this.colors.map((color) => color.value.toRadixString(16)).toList(),
        'lineDirectionCross180': this.lineDirectionCross180?.index,
        'isThined': this.isThined,
        'clickable': this.clickable,
      });
  }

  @override
  Future<BMFCoordinateBounds?> get bounds async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .getBounds(this);
  }
}

/// gradientLine更新 since 3.2.0
extension BMFGradientLineUpdateExtension on BMFGradientLine {
  /// 更新经纬度数组
  ///
  /// List<[BMFCoordinate]> coordinates gradientLine经纬度数组
  ///
  /// iOS 更新经纬度数组的同时，必须更新indexs
  Future<bool> updateCoordinates(List<BMFCoordinate> coordinates,
      {List<int>? indexs}) async {
    ArgumentError.checkNotNull(coordinates, "coordinates");
    if (Platform.isIOS) {
      ArgumentError.checkNotNull(indexs, "indexs");
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGradientLineMember(this.methodChannel, {
      'id': this.id,
      'member': 'coordinates',
      'value': coordinates.map((coordinate) => coordinate.toMap()).toList(),
      'indexs': indexs?.map((index) => index).toList()
    });

    if (ret) {
      this.coordinates = coordinates;
      if (Platform.isIOS) {
        if (null != indexs) {
          this.indexs = indexs;
        }
      }
    }

    return ret;
  }

  /// 更新colors
  ///
  /// android更新colors的时候,必须带上indexs
  Future<bool> updateColors(List<Color> colors, {List<int>? indexs}) async {
    ArgumentError.checkNotNull(colors, "colors");
    if (Platform.isAndroid) {
      ArgumentError.checkNotNull(indexs, "indexs");
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGradientLineMember(this.methodChannel, {
      'id': this.id,
      'member': 'colors',
      'value': colors.map((color) => color.value.toRadixString(16)).toList(),
      'indexs': indexs?.map((index) => index).toList()
    });

    if (ret) {
      this.colors = colors;
      if (Platform.isAndroid) {
        if (null != indexs) {
          this.indexs = indexs;
        }
      }
    }

    return ret;
  }

  /// 更新线宽
  Future<bool> updateWidth(int width) async {
    if (width < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGradientLineMember(this.methodChannel,
            {'id': this.id, 'member': 'width', 'value': width});

    if (ret) {
      this.width = width;
    }

    return ret;
  }

  /// 更新gradientline是否抽稀
  Future<bool> updateThined(bool isThined) async {
    if (this.isThined == isThined) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGradientLineMember(this.methodChannel,
            {'id': this.id, 'member': 'isThined', 'value': isThined});

    if (ret) {
      this.isThined = isThined;
    }

    return ret;
  }

  /// 更新lineDirectionCross180
  Future<bool> updateLineDirectionCross180(
      BMFLineDirectionCross180Type lineDirectionCross180) async {
    ArgumentError.checkNotNull(lineDirectionCross180, "lineDirectionCross180");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGradientLineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineDirectionCross180',
      'value': lineDirectionCross180.index
    });

    if (ret) {
      this.lineDirectionCross180 = lineDirectionCross180;
    }

    return ret;
  }
}
