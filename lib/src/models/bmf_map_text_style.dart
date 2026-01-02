import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

/// 字体样式
enum BMFFontOption {
  ///< 标准
  Normal,

  ///< 加粗
  Bold,
}

/// 文本样式
class BMFTextMarkerStyle extends BMFModel {
  /// 文本颜色，默认黑色
  late Color textColor;

  /// 字体样式，默认Normal
  late BMFFontOption fontOption;

  /// 字体大小，默认24
  late int fontSize;

  /// 描边宽度，默认0
  late int borderWidth;

  /// 描边颜色，默认白色
  late Color borderColor;

  BMFTextMarkerStyle({
    this.textColor = Colors.black,
    this.fontOption = BMFFontOption.Normal,
    this.fontSize = 24,
    this.borderColor = Colors.white,
    this.borderWidth = 0,
  });

  BMFTextMarkerStyle.fromMap(Map map) {
    textColor = ColorUtil.hexToColor(map['textColor']);
    fontOption = BMFFontOption.values[map['fontOption'] as int];
    fontSize = map['fontSize'];
    borderColor = ColorUtil.hexToColor(map['borderColor']);
    borderWidth = map['borderWidth'];
  }

  @override
  fromMap(Map map) {
    return BMFTextMarkerStyle.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "textColor": this.textColor.value.toRadixString(16),
      'fontOption': this.fontOption.index,
      'fontSize': this.fontSize,
      'borderWidth': this.borderWidth,
      'borderColor': this.borderColor.value.toRadixString(16),
    };
  }
}
