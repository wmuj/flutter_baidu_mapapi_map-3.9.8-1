import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate, ColorUtil;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 枚举：文本对齐方式
enum BMFTextAlignment {
  /// 左对齐
  left,

  /// 居中对齐
  center,

  /// 右对齐
  right,

  /// 最后一行自然对齐
  justified,

  /// 默认对齐脚本
  natural,
}

/// 枚举：文本剪裁方式
enum BMFTextLineBreakMode {
  /// Wrap at word boundaries, default
  wordWrapping,

  /// Wrap at character boundaries
  charWrapping,

  /// Simply clip
  clipping,

  /// Truncate at head of line: "...wxyz"
  truncatingHead,

  /// Truncate at tail of line: "abcd..."
  truncatingTail,

  /// Truncate middle of line:  "ab...yz"
  truncatingMiddle,
}

/// 文本
class BMFText extends BMFOverlay {
  /// 文本
  late String text;

  /// text经纬度
  late BMFCoordinate position;

  /// 背景色
  Color? bgColor;

  /// 字体颜色
  Color? fontColor;

  /// 字体大小
  int? fontSize;

  /// typeface
  BMFTypeFace? typeFace;

  /// 文字覆盖物水平对齐方式 ALIGN_LEFT | ALIGN_RIGHT | ALIGN_CENTER_HORIZONTAL
  ///
  /// Android独有
  int? alignX;

  /// 文字覆盖物垂直对齐方式  ALIGN_TOP | ALIGN_BOTTOM | ALIGN_CENTER_VERTICAL
  ///
  /// Android独有
  int? alignY;

  /// 旋转角度
  double? rotate;

  /// 字符间距，默认：2.0f
  ///
  /// iOS独有
  double? paragraphSpacing;

  /// 文字的最大行宽
  ///
  /// iOS独有
  int? maxLineWidth;

  /// 文字的行间距，默认：4.0f
  ///
  /// iOS独有
  int? lineSpacing;

  /// 文字对齐方式，默认：center
  ///
  /// iOS独有
  BMFTextAlignment? alignment;

  /// 字符截断类型，默认：charWrapping
  ///
  /// iOS独有
  BMFTextLineBreakMode? lineBreakMode;

  /// 文字最小显示层级， 默认4
  ///
  /// iOS独有
  int? startLevel;

  /// 文字最大显示层级，默认21
  ///
  /// iOS独有
  int? endLevel;

  /// BMFText-iOS构造方法
  BMFText.iOS({
    required this.text,
    required this.position,
    this.bgColor,
    this.fontColor = Colors.blue,
    this.fontSize = 12,
    this.typeFace,
    this.rotate = 0,
    this.paragraphSpacing = 2,
    this.maxLineWidth,
    this.lineSpacing = 4,
    this.alignment = BMFTextAlignment.center,
    this.lineBreakMode = BMFTextLineBreakMode.charWrapping,
    this.startLevel = 4,
    this.endLevel = 21,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// BMFText-Android构造方法
  BMFText.Android({
    required this.text,
    required this.position,
    this.bgColor,
    this.fontColor = Colors.blue,
    this.fontSize = 12,
    this.typeFace,
    this.alignY = BMFVerticalAlign.ALIGN_CENTER_VERTICAL,
    this.alignX = BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
    this.rotate = 0,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// BMFText构造方法
  BMFText({
    required this.text,
    required this.position,
    this.bgColor,
    this.fontColor = Colors.blue,
    this.fontSize = 12,
    this.typeFace,
    this.alignY = BMFVerticalAlign.ALIGN_CENTER_VERTICAL,
    this.alignX = BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
    this.rotate = 0,
    this.paragraphSpacing = 2,
    this.maxLineWidth,
    this.lineSpacing = 4,
    this.alignment = BMFTextAlignment.center,
    this.lineBreakMode = BMFTextLineBreakMode.charWrapping,
    this.startLevel = 4,
    this.endLevel = 21,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFText
  BMFText.fromMap(Map map)
      : assert(map['text'] != null),
        assert(map['position'] != null),
        super.fromMap(map) {
    text = map['text'];
    position = BMFCoordinate.fromMap(map['position']);
    bgColor = ColorUtil.hexToColor(map['bgColor']);
    fontColor = ColorUtil.hexToColor(map['fontColor']);
    fontSize = map['fontSize'];
    typeFace =
        map['typeFace'] == null ? null : BMFTypeFace.fromMap(map['typeFace']);
    alignX = map['alignX'];
    alignY = map['alignY'];
    rotate = map['rotate'];
    paragraphSpacing = map['paragraphSpacing'] as double?;
    maxLineWidth = map['maxLineWidth'] as int?;
    lineSpacing = map['lineSpacing'] as int?;
    alignment = BMFTextAlignment.values[map['alignment'] as int];
    lineBreakMode = BMFTextLineBreakMode.values[map['lineBreakMode'] as int];
    startLevel = map['startLevel'] as int?;
    endLevel = map['endLevel'] as int?;
  }

  @override
  fromMap(Map map) {
    return BMFText.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'text': this.text,
        'position': this.position.toMap(),
        "bgColor": this.bgColor?.value.toRadixString(16),
        "fontColor": this.fontColor?.value.toRadixString(16),
        "fontSize": this.fontSize,
        "typeFace": this.typeFace?.toMap(),
        "alignX": this.alignX,
        "alignY": this.alignY,
        "rotate": this.rotate,
        'paragraphSpacing': this.paragraphSpacing,
        'maxLineWidth': this.maxLineWidth,
        'lineSpacing': this.lineSpacing,
        'alignment': this.alignment?.index,
        'lineBreakMode': this.lineBreakMode?.index,
        'startLevel': this.startLevel,
        'endLevel': this.endLevel,
      });
  }
}

/// Text水平方向上围绕position的对齐方式
class BMFHorizontalAlign {
  /// 文字覆盖物水平对齐方式:左对齐
  static const int ALIGN_LEFT = 1;

  /// 文字覆盖物水平对齐方式:右对齐
  static const int ALIGN_RIGHT = 2;

  /// 文字覆盖物水平对齐方式:水平居中对齐
  static const int ALIGN_CENTER_HORIZONTAL = 4;
}

/// Text垂直方向上围绕position的对齐方式
class BMFVerticalAlign {
  /// 文字覆盖物垂直对齐方式:上对齐
  static const int ALIGN_TOP = 8;

  /// 文字覆盖物垂直对齐方式:下对齐
  static const int ALIGN_BOTTOM = 16;

  /// 文字覆盖物垂直对齐方式:居中对齐
  static const int ALIGN_CENTER_VERTICAL = 32;
}

enum BMFTextStyle {
  NORMAL,
  BOLD,
  ITALIC,
  BOLD_ITALIC,
}

class BMFFamilyName {
  static const String sDefault = "";
  static const String sSansSerif = "sans-serif";
  static const String sSerif = "serif";
  static const String sMonospace = "monospace";
}

/// typeFace
class BMFTypeFace implements BMFModel {
  /// familyName:Android独有
  String? familyName;

  /// 字体样式
  late BMFTextStyle textStype;

  BMFTypeFace({
    this.familyName,
    required this.textStype,
  });

  @override
  BMFTypeFace.fromMap(Map map) : assert(map['textStype'] != null) {
    familyName = map['familyName'] == null ? null : map['familyName'];
    textStype = BMFTextStyle.values[map['textStype'] as int];
  }

  @override
  dynamic fromMap(Map map) {
    return BMFTypeFace.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {"familyName": this.familyName, "textStype": this.textStype.index};
  }
}

/// text更新
extension BMFTextUpdateExtension on BMFText {
  /// 更新Text文本
  ///
  /// text 文本
  Future<bool> updateText(String text) async {
    ArgumentError.checkNotNull(text, "text");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'text', 'value': text});

    if (ret) {
      this.text = text;
    }

    return ret;
  }

  /// 更新Text经纬度
  ///
  /// [BMFCoordinate] position 圆心点经纬度
  Future<bool> updatePosition(BMFCoordinate position) async {
    ArgumentError.checkNotNull(position, "position");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'position', 'value': position.toMap()});

    if (ret) {
      this.position = position;
    }

    return ret;
  }

  /// 更新Text背景颜色
  ///
  /// [Color] color 背景颜色
  Future<bool> updateBgColor(Color bgColor) async {
    ArgumentError.checkNotNull(bgColor, "bgColor");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel, {
      'id': this.id,
      'member': 'bgColor',
      'value': bgColor.value.toRadixString(16)
    });

    if (ret) {
      this.bgColor = bgColor;
    }

    return ret;
  }

  /// 更新Text字体颜色
  ///
  /// [Color] fontColor 字体颜色
  Future<bool> updateFontColor(Color fontColor) async {
    ArgumentError.checkNotNull(fontColor, "fontColor");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel, {
      'id': this.id,
      'member': 'fontColor',
      'value': fontColor.value.toRadixString(16)
    });

    if (ret) {
      this.fontColor = fontColor;
    }

    return ret;
  }

  /// 更新Text typeFace
  ///
  /// [BMFTypeFace] typeFace
  Future<bool> updateTypeFace(BMFTypeFace typeFace) async {
    ArgumentError.checkNotNull(typeFace, "typeFace");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'typeFace', 'value': typeFace.toMap()});

    if (ret) {
      this.typeFace = typeFace;
    }

    return ret;
  }

  /// 更新Text 字体大小
  ///
  /// fontSize
  Future<bool> updateFontSize(int fontSize) async {
    if (fontSize < -1) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'fontSize', 'value': fontSize});

    if (ret) {
      this.fontSize = fontSize;
    }

    return ret;
  }

  /// 更新Text 文字覆盖对齐方式
  ///
  /// android独有
  /// alignX 文字覆盖物水平对齐方式 ALIGN_LEFT | ALIGN_RIGHT | ALIGN_CENTER_HORIZONTAL
  /// alignY 文字覆盖物水平对齐方式 ALIGN_LEFT | ALIGN_RIGHT | ALIGN_CENTER_HORIZONTAL
  Future<bool> updateAlign(int alignX, int alignY) async {
    if (!Platform.isAndroid) {
      return false;
    }
    if (alignX != BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL &&
        alignX != BMFHorizontalAlign.ALIGN_LEFT &&
        alignX != BMFHorizontalAlign.ALIGN_RIGHT) {
      return false;
    }

    if (alignY != BMFVerticalAlign.ALIGN_BOTTOM &&
        alignY != BMFVerticalAlign.ALIGN_CENTER_VERTICAL &&
        alignY != BMFVerticalAlign.ALIGN_TOP) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel, {
      'id': this.id,
      'member': 'align',
      'alignX': alignX,
      'alignY': alignY
    });
    if (ret) {
      this.alignX = alignX;
      this.alignY = alignY;
    }
    return ret;
  }

  /// 更新Text 旋转角度
  ///
  /// rotate 旋转角度
  Future<bool> updateRotate(double rotate) async {
    if (rotate < -1) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'rotate', 'value': rotate});
    if (ret) {
      this.rotate = rotate;
    }
    return ret;
  }

  /// 更新字符间距 字体大小
  ///
  /// iOS独有
  Future<bool> updateParagraphSpacing(double paragraphSpacing) async {
    if (!Platform.isIOS) {
      return false;
    }
    if (paragraphSpacing < 0) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel, {
      'id': this.id,
      'member': 'paragraphSpacing',
      'value': paragraphSpacing
    });
    if (ret) {
      this.paragraphSpacing = paragraphSpacing;
    }
    return ret;
  }

  /// 更新文字最大行宽
  ///
  /// iOS独有
  Future<bool> updateMaxLineWidth(int maxLineWidth) async {
    if (!Platform.isIOS) {
      return false;
    }
    if (maxLineWidth < 0) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'maxLineWidth', 'value': maxLineWidth});
    if (ret) {
      this.maxLineWidth = maxLineWidth;
    }
    return ret;
  }

  /// 更新文字行间距
  ///
  /// iOS独有
  Future<bool> updateLineSpacing(int lineSpacing) async {
    if (!Platform.isIOS) {
      return false;
    }
    if (lineSpacing < 0) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'lineSpacing', 'value': lineSpacing});
    if (ret) {
      this.lineSpacing = lineSpacing;
    }
    return ret;
  }

  /// 更新文字对齐方式
  ///
  /// iOS独有
  Future<bool> updateAlignment(BMFTextAlignment alignment) async {
    if (!Platform.isIOS) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'alignment', 'value': alignment.index});
    if (ret) {
      this.alignment = alignment;
    }
    return ret;
  }

  /// 更新字符截断类型
  ///
  /// iOS独有
  Future<bool> updateLineBreakMode(BMFTextLineBreakMode lineBreakMode) async {
    if (!Platform.isIOS) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBreakMode',
      'value': lineBreakMode.index
    });
    if (ret) {
      this.lineBreakMode = lineBreakMode;
    }
    return ret;
  }

  /// 更新最小显示层级,
  ///
  /// iOS独有
  Future<bool> updateStartLevel(int startLevel) async {
    if (!Platform.isIOS) {
      return false;
    }
    if (startLevel < 4) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'startLevel', 'value': startLevel});
    if (ret) {
      this.startLevel = startLevel;
    }
    return ret;
  }

  /// 更新最大显示层级,
  ///
  /// iOS独有
  Future<bool> updateEndLevel(int endLevel) async {
    if (!Platform.isIOS) {
      return false;
    }
    if (endLevel > 21) {
      return false;
    }
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'endLevel', 'value': endLevel});
    if (ret) {
      this.endLevel = endLevel;
    }
    return ret;
  }

  /// 更新Text是否显示
  /// Android独有
  /// [bool] visible 显示状态
  Future<bool> updateVisible(bool visible) async {
    ArgumentError.checkNotNull(visible, "visible");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateTextMember(this.methodChannel,
            {'id': this.id, 'member': 'visible', 'value': visible});

    if (ret) {
      this.visible = visible;
    }

    return ret;
  }
}
