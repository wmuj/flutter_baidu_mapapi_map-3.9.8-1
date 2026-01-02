import 'dart:ui';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

class BMFTitleOptions implements BMFModel {
  /// 背景颜色 since 3.5.0
  ///
  /// Android独有
  Color? bgColor;

  /// 文字颜色 since 3.5.0
  ///
  /// Android独有
  Color? fontColor;

  /// 文字大小 since 3.5.0
  ///
  /// Android独有
  int? fontSize;

  /// title旋转角度 since 3.5.0
  ///
  /// Android独有
  double? titleRotate;

  /// 标题文字 since 3.5.0
  ///
  /// Android独有
  String? text;

  /// 标题垂直偏移 since 3.5.0
  ///
  /// Android独有
  int? titleYOffset;

  /// 标题水平偏移 since 3.5.0
  ///
  /// Android独有
  int? titleXOffset;

  /// 水平锚点比例 since 3.5.0
  ///
  /// Android独有
  double? titleAnchorX;

  /// 垂直锚点比例 since 3.5.0
  ///
  /// Android独有
  double? titleAnchorY;

  BMFTitleOptions({
    this.bgColor,
    this.fontColor,
    this.text,
    this.fontSize = 48,
    this.titleAnchorX = 0.5,
    this.titleAnchorY = 1.0,
    this.titleRotate,
    this.titleXOffset,
    this.titleYOffset,
  });

  @override
  fromMap(Map map) {
    return BMFTitleOptions.fromMap(map);
  }

  /// map => BMFTitleOptions
  BMFTitleOptions.fromMap(Map map) {
    bgColor = ColorUtil.hexToColor(map['bgColor']);
    fontColor = ColorUtil.hexToColor(map['fontColor']);
    fontSize = map['fontSize'];
    text = map['text'];
    titleYOffset = map['titleYOffset'];
    titleXOffset = map['titleXOffset'];
    titleRotate = map['titleRotate'];
    titleAnchorX = map['titleAnchorX'];
    titleAnchorY = map['titleAnchorY'];
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'bgColor': this.bgColor?.value.toRadixString(16),
      'fontColor': this.fontColor?.value.toRadixString(16),
      'fontSize': this.fontSize,
      'text': this.text,
      'titleYOffset': this.titleYOffset,
      'titleXOffset': this.titleXOffset,
      'titleRotate': this.titleRotate,
      'titleAnchorX': this.titleAnchorX,
      'titleAnchorY': this.titleAnchorY,
    };
  }
}
