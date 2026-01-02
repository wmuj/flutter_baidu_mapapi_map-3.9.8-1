import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';

/// 渐变圆不支持镂空及fillColor
/// 设置渐变圆，镂空及fillColor就会失效
class BMFGradientCircle extends BMFCircle {
  /// 中心颜色
  Color? centerColor;

  /// 边缘颜色
  Color? sideColor;

  /// 半径权重
  /// 取值范围（0.0, 1.0），默认 s0.5
  double? radiusWeight;

  /// 颜色权重
  /// 取值范围（0.0, 1.0），默认 0.2
  double? colorWeight;

  BMFGradientCircle({
    this.centerColor,
    this.sideColor,
    this.radiusWeight,
    this.colorWeight,
    required BMFCoordinate center,
    required double radius,
    int? width,
    Color? strokeColor,
    BMFLineDashType? lineDashType,
    bool? dottedLine,
  }) : super(
          center: center,
          radius: radius,
          width: width,
          strokeColor: strokeColor,
          lineDashType: lineDashType,
          dottedLine: dottedLine,
        );

  /// map => BMFGradientCircle
  BMFGradientCircle.fromMap(Map map)
      : assert(map['center'] != null),
        assert(map['radius'] != null),
        super.fromMap(map) {
    radius = map['radius'];
    center = BMFCoordinate.fromMap(map['center']);
    radiusWeight = map['radiusWeight'];
    colorWeight = map['colorWeight'];
    width = (map['width'] as num?)?.toInt();
    strokeColor = ColorUtil.hexToColor(map['strokeColor']);
    centerColor = ColorUtil.hexToColor(map['centerColor']);
    sideColor = ColorUtil.hexToColor(map['sideColor']);
    lineDashType = BMFLineDashType.values[map['lineDashType'] as int];
    dottedLine = map['dottedLine'];
  }

  @override
  fromMap(Map map) {
    return BMFGradientCircle.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'colorWeight': this.colorWeight,
        'radiusWeight': this.radiusWeight,
        'centerColor': this.centerColor?.value.toRadixString(16),
        'sideColor': this.sideColor?.value.toRadixString(16),
      });
  }
}
