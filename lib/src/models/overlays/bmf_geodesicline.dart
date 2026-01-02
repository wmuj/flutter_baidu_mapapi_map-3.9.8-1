import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil;
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_linedraw_types.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 大地曲线 since 3.1.0
class BMFGeodesicLine extends BMFOverlay {
  /// 经纬度数组
  late List<BMFCoordinate> coordinates;

  /// 线宽
  int? width;

  /// 大地曲线颜色
  Color? strokeColor;

  /// 大地曲线纹理图片路径
  ///
  /// 注意：纹理图片宽高必须是2的n次幂
  /// 与strokeColor二者必须选择其一进行传参
  String? textureImage;

  /// 大地曲线虚线绘制类型
  BMFLineDashType? lineDashType;

  /// 大地曲线跨经度180方式
  ///
  /// 默认BMFLineDirectionCross180Type.None, 不跨经度180.
  BMFLineDirectionCross180Type? lineDirectionCross180;

  /// 大地曲线构造方法
  BMFGeodesicLine({
    required this.coordinates,
    this.width = 5,
    this.strokeColor,
    this.textureImage,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 颜色大地曲线构造方法
  BMFGeodesicLine.colorGedesicLine({
    required this.coordinates,
    required this.strokeColor,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 纹理大地曲线构造方法
  BMFGeodesicLine.textureGedesicLine({
    required this.coordinates,
    required this.textureImage,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  BMFGeodesicLine.fromMap(Map map) : super.fromMap(map) {
    if (map['coordinates'] != null) {
      List<BMFCoordinate> tmpCoordinates = [];
      map['coordinates'].forEach((v) {
        tmpCoordinates.add(BMFCoordinate.fromMap(v as Map));
      });
      coordinates = tmpCoordinates;
    }

    width = (map['width'] as num?)?.toInt();
    strokeColor = ColorUtil.hexToColor(map['strokeColor'] as String);
    textureImage = map['textureImage'];
    lineDashType = BMFLineDashType.values[map['lineDashType'] as int];
    lineDirectionCross180 = BMFLineDirectionCross180Type
        .values[map['lineDirectionCross180'] as int];
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates.map((coord) => coord.toMap()).toList(),
        'width': this.width,
        'strokeColor': this.strokeColor?.value.toRadixString(16),
        'textureImage': this.textureImage,
        'lineDashType': this.lineDashType?.index,
        'lineDirectionCross180': this.lineDirectionCross180?.index,
      });
  }
}

/// geodesicline更新 since 3.2.0
extension BMFGeodesicLineUpdateExtension on BMFGeodesicLine {
  /// 更新经纬度数组
  ///
  /// List<[BMFCoordinate]> coordinates arcline经纬度数组
  Future<bool> updateCoordinates(List<BMFCoordinate> coordinates) async {
    ArgumentError.checkNotNull(coordinates, "coordinates");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGeodesicLineMember(this.methodChannel, {
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
        .updateGeodesicLineMember(this.methodChannel,
            {'id': this.id, 'member': 'width', 'value': width});

    if (ret) {
      this.width = width;
    }

    return ret;
  }

  /// 更新strokeColor
  Future<bool> updateStrokeColor(Color strokeColor) async {
    ArgumentError.checkNotNull(strokeColor, "strokeColor");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGeodesicLineMember(this.methodChannel, {
      'id': this.id,
      'member': 'strokeColor',
      'value': strokeColor.value.toRadixString(16)
    });

    if (ret) {
      this.strokeColor = strokeColor;
    }

    return ret;
  }

  /// 更新textureImage
  Future<bool> updateTextureImage(String textureImage) async {
    ArgumentError.checkNotNull(textureImage, "textureImage");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGeodesicLineMember(this.methodChannel,
            {'id': this.id, 'member': 'textureImage', 'value': textureImage});

    if (ret) {
      this.textureImage = textureImage;
    }

    return ret;
  }

  /// 更新lineDashType
  Future<bool> updateLineDashType(BMFLineDashType lineDashType) async {
    ArgumentError.checkNotNull(lineDashType, "lineDashType");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGeodesicLineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineDashType',
      'value': lineDashType.index
    });

    if (ret) {
      this.lineDashType = lineDashType;
    }

    return ret;
  }

  /// 更新lineDirectionCross180
  Future<bool> updateLineDirectionCross180(
      BMFLineDirectionCross180Type lineDirectionCross180) async {
    ArgumentError.checkNotNull(lineDirectionCross180, "lineDirectionCross180");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGeodesicLineMember(this.methodChannel, {
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
