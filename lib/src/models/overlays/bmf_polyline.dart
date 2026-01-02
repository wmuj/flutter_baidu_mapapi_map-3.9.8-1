import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil;
import 'package:flutter_baidu_mapapi_base/src/map/bmf_models.dart';
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_linedraw_types.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 折线
///
class BMFPolyline extends BMFOverlay implements BMFOverlayBoundsInterface {
  /// 经纬度数组
  late List<BMFCoordinate> coordinates;

  /// 分段索引(多纹理，多颜色折线请赋值)
  List<int>? indexs;

  /// 线宽
  int? width;

  /// 颜色折线的colors 用于颜色绘制
  ///
  /// 与textures二者必须选择其一进行传参
  List<Color>? colors;

  /// 纹理折线的纹理图片路径 用于纹理绘制
  ///
  /// 注意：纹理图片宽高必须是2的n次幂
  /// 与colors二者必须选择其一进行传参
  List<String>? textures;

  /// 设置折线是否虚线(Android独有)
  ///
  /// 当以纹理形式渲染polyline时，该属性为true，则显示纹理上的元素，为false不显示
  /// 当以颜色形式渲染polyline时，与BMFLineDashType配合使用;为true，则polyline可以渲染成虚线，为false则不能
  bool? dottedLine;

  /// 虚线绘制样式 默认实折线 BMFLineDashTypeNone
  ///
  /// 实折线 LineDashTypeNone,
  /// 方块虚线 LineDashTypeSquare,
  /// 圆点虚线 LineDashTypeDot,
  ///
  /// Android平台要想渲染成虚线，必须设置dottedLine为true
  BMFLineDashType? lineDashType;

  /// line头尾处理方式(不支持虚线) 默认普通头 LineCapButt,
  ///
  /// 普通头 LineCapButt,
  /// 圆形头 LineCapRound
  /// Android平台要想生效，必须设置dottedLine为false
  BMFLineCapType? lineCapType;

  /// line拐角处理方式（不支持虚线）默认平角衔接 LineJoinBevel,
  ///
  /// 平角衔接  BMFLineJoinBevel,
  /// 尖角衔接(尖角过长(大于线宽)按平角处理) LineJoinMiter,
  /// 圆⻆角衔接 LineJoinRound
  ///
  /// Android平台要想生效，必须设置dottedLine为false
  BMFLineJoinType? lineJoinType;

  /// 是否抽稀 默认ture
  bool? isThined;

  /// 是否可点击
  bool? clickable;

  /// 折线经度跨180所需字段 since 3.1.0
  ///
  /// 默认BMFLineDirectionCross180Type.None, 不跨经度180.
  BMFLineDirectionCross180Type? lineDirectionCross180;

  /// 纹理宽、高是否保持原比例渲染,默认为false
  ///
  /// Android独有
  bool? isKeepScale;

  /// 是否可以被选中，获得焦点,默认true
  ///
  /// Android独有
  bool? isFocus;

  /// 发光模式，仅支持颜色实折线；
  BMFLineBloomMode? lineBloomMode;

  /// 发光处宽度，默认 0.0f；
  double? lineBloomWidth;

  /// 发光处透明度，取值范围 [0 ~ 255]，默认 255.0f；
  double? lineBloomAlpha;

  /// 透明度渐变速度
  /// 取值范围 [1.0f ~ 10.0f]，默认值为 5.0f
  /// 注意：渐变发光模式下该属性生效
  double? lineBloomGradientASPeed;

  /// 设置模糊发光效果的模糊次数(1~10) 默认1次
  ///
  /// Android独有
  int? lineBloomBlurTimes;

  /// BMFPolyline构造方法
  BMFPolyline({
    required this.coordinates,
    this.indexs = const [],
    this.width = 5,
    this.colors = const [],
    this.textures = const [],
    this.dottedLine = true,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineCapType = BMFLineCapType.LineCapButt,
    this.lineJoinType = BMFLineJoinType.LineJoinBevel,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    this.isKeepScale = false,
    this.isFocus = true,
    this.lineBloomMode = BMFLineBloomMode.LineBloomModeNone,
    this.lineBloomWidth = 0.0,
    this.lineBloomAlpha = 255.0,
    this.lineBloomGradientASPeed = 5.0,
    this.lineBloomBlurTimes = 0,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        assert(indexs!.length >= 0),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 单色折线构造方法
  BMFPolyline.colorline({
    required this.coordinates,
    required Color strokerColor,
    this.width = 5,
    this.dottedLine = true,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineCapType = BMFLineCapType.LineCapButt,
    this.lineJoinType = BMFLineJoinType.LineJoinBevel,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    this.isKeepScale = false,
    this.isFocus = true,
    this.lineBloomMode = BMFLineBloomMode.LineBloomModeNone,
    this.lineBloomWidth = 0.0,
    this.lineBloomAlpha = 255.0,
    this.lineBloomGradientASPeed = 5.0,
    this.lineBloomBlurTimes = 0,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        super(zIndex: zIndex, visible: visible, customMap: customMap) {
    colors = <Color>[];
    colors!.add(strokerColor);
  }

  /// 多颜色折线构造方法
  BMFPolyline.multiColorline({
    required this.coordinates,
    required this.colors,
    required this.indexs,
    this.width = 5,
    this.dottedLine = true,
    this.lineDashType = BMFLineDashType.LineDashTypeNone,
    this.lineCapType = BMFLineCapType.LineCapButt,
    this.lineJoinType = BMFLineJoinType.LineJoinBevel,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    this.isKeepScale = false,
    this.isFocus = true,
    this.lineBloomMode = BMFLineBloomMode.LineBloomModeNone,
    this.lineBloomWidth = 0.0,
    this.lineBloomAlpha = 255.0,
    this.lineBloomGradientASPeed = 5.0,
    this.lineBloomBlurTimes = 0,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        assert(indexs!.length >= 0),
        assert(colors!.length > 0),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 单纹理折线构造方法
  BMFPolyline.textureline({
    required this.coordinates,
    required String texture,
    this.width = 5,
    this.lineCapType = BMFLineCapType.LineCapButt,
    this.lineJoinType = BMFLineJoinType.LineJoinBevel,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    this.isKeepScale = false,
    this.isFocus = true,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        super(zIndex: zIndex, visible: visible, customMap: customMap) {
    textures = <String>[];
    textures!.add(texture);
    lineDashType = BMFLineDashType.LineDashTypeNone;
  }

  /// 多纹理折线构造方法
  BMFPolyline.multiTextureline({
    required this.coordinates,
    required this.textures,
    required this.indexs,
    this.width = 5,
    this.lineCapType = BMFLineCapType.LineCapButt,
    this.lineJoinType = BMFLineJoinType.LineJoinBevel,
    this.lineDirectionCross180 = BMFLineDirectionCross180Type.None,
    this.isThined = true,
    this.clickable = true,
    this.isKeepScale = false,
    this.isFocus = true,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates.length > 1),
        assert(indexs!.length > 0),
        assert(textures!.length > 0),
        super(zIndex: zIndex, visible: visible, customMap: customMap) {
    lineDashType = BMFLineDashType.LineDashTypeNone;
  }

  /// map => BMFPolyline
  BMFPolyline.fromMap(Map map)
      : assert(map['coordinates'] != null),
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
        indexs!.add(v as int);
      });
    }

    if (map['colors'] != null) {
      colors = <Color>[];
      map['colors'].forEach((v) {
        colors!.add(ColorUtil.hexToColor(v as String));
      });
    }

    if (map['textures'] != null) {
      textures = <String>[];
      map['textures'].forEach((v) {
        textures!.add(v as String);
      });
    }

    width = (map['width'] as num?)?.toInt();
    dottedLine = map['dottedLine'] as bool?;
    lineDashType = BMFLineDashType.values[map['lineDashType'] as int];
    lineCapType = BMFLineCapType.values[map['lineCapType'] as int];
    lineJoinType = BMFLineJoinType.values[map['lineJoinType'] as int];
    lineDirectionCross180 = BMFLineDirectionCross180Type
        .values[map['lineDirectionCross180'] as int];
    isThined = map['isThined'] as bool?;
    clickable = map['clickable'] as bool?;
    isKeepScale = map['isKeepScale'] as bool?;
    isFocus = map['isFocus'] as bool?;
    lineBloomMode = BMFLineBloomMode.values[map['lineBloomMode'] as int];
    if (map['lineBloomWidth'] != null) {
      lineBloomWidth = double.parse(map['lineBloomWidth'].toString());
    }
    if (map['lineBloomAlpha'] != null) {
      lineBloomAlpha = double.parse(map['lineBloomAlpha'].toString());
    }
    if (map['lineBloomGradientASPeed'] != null) {
      lineBloomGradientASPeed =
          double.parse(map['lineBloomGradientASPeed'].toString());
    }
    lineBloomBlurTimes = map['lineBloomBlurTimes'] as int?;
  }

  @override
  fromMap(Map map) {
    return BMFPolyline.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates.map((coord) => coord.toMap()).toList(),
        'indexs': this.indexs?.map((index) => index).toList(),
        'width': this.width,
        'colors':
            this.colors?.map((color) => color.value.toRadixString(16)).toList(),
        'textures': this.textures,
        'dottedLine': this.dottedLine,
        'lineDashType': this.lineDashType?.index,
        'lineCapType': this.lineCapType?.index,
        'lineJoinType': this.lineJoinType?.index,
        'lineDirectionCross180': this.lineDirectionCross180?.index,
        'isThined': this.isThined,
        'clickable': this.clickable,
        'isKeepScale': this.isKeepScale,
        'isFocus': this.isFocus,
        'lineBloomMode': this.lineBloomMode?.index,
        'lineBloomWidth': this.lineBloomWidth,
        'lineBloomAlpha': this.lineBloomAlpha,
        'lineBloomGradientASPeed': this.lineBloomGradientASPeed,
        'lineBloomBlurTimes': this.lineBloomBlurTimes,
      });
  }

  @override
  Future<BMFCoordinateBounds?> get bounds async {
    return await BMFMapDispatcherFactory.instance.overlayDispatcher
        .getBounds(this);
  }
}

/// polyline更新
extension BMFPolylineUpdate on BMFPolyline {
  /// 更新经纬度数组
  ///
  /// List<[BMFCoordinate]> coordinates polyline经纬度数组
  ///
  /// indexs iOS 独有参数，分段索引(多纹理，多颜色折线请赋值),
  ///        iOS 在多颜色或者多纹理渲染的情况下，更新经纬度数组的同时，必须更新indexs
  Future<bool> updateCoordinates(List<BMFCoordinate> coordinates,
      {List<int>? indexs}) async {
    ArgumentError.checkNotNull(coordinates, "coordinates");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
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

  /// 更新线宽
  Future<bool> updateWidth(int width) async {
    if (width < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'width', 'value': width});

    if (ret) {
      this.width = width;
    }

    return ret;
  }

  /// 更新索引 【Android】
  ///
  /// Android在以colors渲染的情况下，单独更新索引是无效的，应该使用updateColors接口
  Future<bool> updateIndexs(List<int> indexs) async {
    ArgumentError.checkNotNull(indexs, "indexs");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'indexs',
      'value': indexs.map((index) => index).toList()
    });

    if (ret) {
      this.indexs = indexs;
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
        .updatePolylineMember(this.methodChannel, {
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

  /// 更新纹理textures
  Future<bool> updateTextures(List<String> textures) async {
    ArgumentError.checkNotNull(textures, "textures");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'textures',
      'value': textures.map((e) => e).toList()
    });

    if (ret) {
      this.textures = textures;
    }

    return ret;
  }

  /// 更新是否设置虚线
  ///
  /// Android独有
  Future<bool> updateDottedLine(bool dottedLine) async {
    if (this.dottedLine == dottedLine) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'dottedLine', 'value': dottedLine});

    if (ret) {
      this.dottedLine = dottedLine;
    }

    return ret;
  }

  /// 更新折线绘制样式
  ///
  /// [BMFLineDashType] lineDashType  折线类型
  Future<bool> updateLineDashType(BMFLineDashType lineDashType) async {
    ArgumentError.checkNotNull(lineDashType, "lineDashType");

    if (this.lineDashType == lineDashType) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineDashType',
      'value': lineDashType.index
    });

    if (ret) {
      this.lineDashType = lineDashType;
    }

    return ret;
  }

  /// 更新折线头尾处理方式
  ///
  /// [BMFLineCapType] lineCapType 折线头尾类型
  ///
  /// Android平台要想生效，必须设置dottedLine属性为false
  Future<bool> updateLineCapType(BMFLineCapType lineCapType) async {
    ArgumentError.checkNotNull(lineCapType, "lineCapType");

    if (this.lineCapType == lineCapType) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineCapType',
      'value': lineCapType.index
    });

    if (ret) {
      this.lineCapType = lineCapType;
    }

    return ret;
  }

  /// 更新折线拐角处理方式
  ///
  /// [BMFLineJoinType] lineJoinType 折线拐角处理方式
  ///
  /// Android平台要想生效，必须设置dottedLine属性为false
  Future<bool> updateLineJoinType(BMFLineJoinType lineJoinType) async {
    ArgumentError.checkNotNull(lineJoinType, "lineJoinType");

    if (this.lineJoinType == lineJoinType) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineJoinType',
      'value': lineJoinType.index
    });

    if (ret) {
      this.lineJoinType = lineJoinType;
    }

    return ret;
  }

  /// 更新polyLine是否可点击
  Future<bool> updateClickable(bool clickable) async {
    if (this.clickable == clickable) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'clickable', 'value': clickable});

    if (ret) {
      this.clickable = clickable;
    }

    return ret;
  }

  /// 更新纹理宽、高是否保持原比例渲染
  ///
  /// Android独有
  Future<bool> updateIsKeepScale(bool isKeepScale) async {
    if (this.isKeepScale == isKeepScale) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'isKeepScale', 'value': isKeepScale});

    if (ret) {
      this.isKeepScale = isKeepScale;
    }

    return ret;
  }

  /// 更新是否可以被选中，获得焦点
  ///
  /// Android独有
  Future<bool> updateIsFocus(bool isFocus) async {
    if (this.isFocus == isFocus) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'isFocus', 'value': isFocus});

    if (ret) {
      this.isFocus = isFocus;
    }

    return ret;
  }

  /// 更新polyline是否显示
  ///
  /// Android独有
  Future<bool> updateVisible(bool visible) async {
    if (this.visible == visible) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'visible', 'value': visible});

    if (ret) {
      this.visible = visible;
    }

    return ret;
  }

  /// 更新z轴方向上的堆叠顺序
  ///
  /// Android独有
  Future<bool> updateZIndex(int zIndex) async {
    if (this.zIndex == zIndex) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
            {'id': this.id, 'member': 'zIndex', 'value': zIndex});

    if (ret) {
      this.zIndex = zIndex;
    }

    return ret;
  }

  /// 更新polyline是否抽稀
  Future<bool> updateThined(bool isThined) async {
    if (this.isThined == isThined) {
      return true;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel,
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
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineDirectionCross180',
      'value': lineDirectionCross180.index
    });

    if (ret) {
      this.lineDirectionCross180 = lineDirectionCross180;
    }

    return ret;
  }

  /// 更新lineBloomGradientASPeed
  Future<bool> updateLineBloomGradientASPeed(
      double lineBloomGradientASPeed) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBloomGradientASPeed',
      'value': lineBloomGradientASPeed
    });

    if (ret) {
      this.lineBloomGradientASPeed = lineBloomGradientASPeed;
    }

    return ret;
  }

  /// 更新lineBloomMode
  Future<bool> updateLineBloomMode(BMFLineBloomMode lineBloomMode) async {
    ArgumentError.checkNotNull(lineBloomMode, "lineBloomMode");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBloomMode',
      'value': lineBloomMode.index
    });

    if (ret) {
      this.lineBloomMode = lineBloomMode;
    }

    return ret;
  }

  /// 更新lineBloomWidth
  Future<bool> updateLineBloomWidth(double lineBloomWidth) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBloomWidth',
      'value': lineBloomWidth
    });

    if (ret) {
      this.lineBloomWidth = lineBloomWidth;
    }

    return ret;
  }

  /// 更新lineBloomAlpha
  Future<bool> updateLineBloomAlpha(double lineBloomAlpha) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBloomAlpha',
      'value': lineBloomAlpha
    });

    if (ret) {
      this.lineBloomAlpha = lineBloomAlpha;
    }

    return ret;
  }

  /// 更新lineBloomBlurTimes
  Future<bool> updateLineBloomBlurTimes(int lineBloomBlurTimes) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePolylineMember(this.methodChannel, {
      'id': this.id,
      'member': 'lineBloomBlurTimes',
      'value': lineBloomBlurTimes
    });

    if (ret) {
      this.lineBloomBlurTimes = lineBloomBlurTimes;
    }

    return ret;
  }
}
