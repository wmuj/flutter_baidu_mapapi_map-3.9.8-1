import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate, ColorUtil;

/// 热力图瓦片提供者
class BMFHeatMap implements BMFModel {
  /// 用户传入的热力图数据,数组,成员类型为BMFHeatMapNode
  List<BMFHeatMapNode>? data;

  /// 用户传入的热力图数据data和datas ，二选一，优先datas
  /// 用户传入的热力图数据，数组，成员类型为List<BMKHeatMapNode>，用于帧动画，since 3.3.0
  List<List<BMFHeatMapNode>>? datas;

  /// 设置热力图点半径，默认为12ps 当radiusIsMeter为false时生效，范围[10~50]
  int? radius;

  /// 设置热力图点半径单位是否是米，默认为false，范围[10~50]，since 3.5.0
  bool? radiusIsMeter;

  /// 设置热力图点半径（米），默认为12米，当mRadiusIsMeter为true时生效，范围[10~50]，since 3.5.0
  int? radiusMeter;

  /// 设置热力图最大显示等级，默认为22，范围[4~22]，since 3.5.0
  int? maxShowLevel;

  /// 设置热力图最小显示等级，默认为4，范围[4~22]，since 3.5.0
  int? minShowLevel;

  /// 设置热力图层透明度，默认 0.6
  double? opacity;

  /// 设置热力图渐变
  BMFGradient? gradient;

  /// 设置3D热力图最大高度，默认为0ps，范围[0~200]，since 3.3.0
  int? mMaxHight;

  /// 设置热力图最大权重值，默认为1.0，since 3.3.0
  double? mMaxIntensity;

  /// 设置热力图最小权重值，默认为0.0，since 3.3.0
  double? mMinIntensity;

  /// 设置第一次显示时的动画属性，默认为无动画 since 3.3.0
  BMFAnimation? animation;

  /// 设置帧动画属性，默认为无动画 since 3.3.0
  BMFAnimation? frameAnimation;

  /// BMFHeatMap构造方法
  BMFHeatMap({
    this.data,
    this.radius = 12,
    this.radiusIsMeter = false,
    this.radiusMeter = 12,
    this.maxShowLevel = 22,
    this.minShowLevel = 4,
    this.opacity = 0.6,
    this.gradient,
    this.datas,
    this.mMaxHight = 0,
    this.mMaxIntensity = 1,
    this.mMinIntensity = 0,
    this.animation,
    this.frameAnimation,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'data': this
          .data
          ?.map((weightedCoordinate) => weightedCoordinate.toMap())
          .toList(),
      'radius': this.radius,
      'radiusIsMeter': this.radiusIsMeter,
      'radiusMeter': this.radiusMeter,
      'maxShowLevel': this.maxShowLevel,
      'minShowLevel': this.minShowLevel,
      'opacity': this.opacity,
      'gradient': this.gradient?.toMap(),
      'datas': this
          .datas
          ?.map((list) => list.map((node) => node.toMap()).toList())
          .toList(),
      'mMaxHight': this.mMaxHight,
      'mMaxIntensity': this.mMaxIntensity,
      'mMinIntensity': this.mMinIntensity,
      'animation': this.animation?.toMap(),
      'frameAnimation': this.frameAnimation?.toMap(),
    };
  }

  /// map => BMFHeatMap
  BMFHeatMap.fromMap(Map map) {
    if (map['data'] != null) {
      List<BMFHeatMapNode> tmpData = [];
      map['data'].forEach((v) {
        tmpData.add(BMFHeatMapNode.fromMap(v as Map));
      });
      data = tmpData;
    }
    if (map['datas'] != null) {
      List<List<BMFHeatMapNode>> datas = [];
      map['datas'].forEach((list) {
        List<BMFHeatMapNode> tempList = [];
        list.forEach((v) {
          tempList.add(BMFHeatMapNode.fromMap(v as Map));
        });
        datas.add(tempList);
      });
    }
    radius = map['radius'];
    radiusIsMeter = map['radiusIsMeter'] as bool;
    radiusMeter = map['radiusMeter'];
    maxShowLevel = map['maxShowLevel'];
    minShowLevel = map['minShowLevel'];
    opacity = map['opacity'];
    gradient =
        map['gradient'] == null ? null : BMFGradient.fromMap(map['gradient']);
    mMaxHight = map['mMaxHight'];
    mMaxIntensity = map['mMaxIntensity'];
    mMinIntensity = map['mMinIntensity'];
    animation = map['animation'] == null
        ? null
        : BMFAnimation.fromMap(map['animation']);
    frameAnimation = map['frameAnimation'] == null
        ? null
        : BMFAnimation.fromMap(map['frameAnimation']);
  }

  /// map -> dynamic
  @override
  fromMap(Map map) {
    return new BMFHeatMap.fromMap(map);
  }
}

/// 热力图节点信息
class BMFHeatMapNode implements BMFModel {
  /// 点的强度权值
  late double intensity;

  /// 点的位置坐标
  late BMFCoordinate pt;

  BMFHeatMapNode({required this.intensity, required this.pt}) {
    this.intensity = this.intensity > 1 ? this.intensity : 1.0;
  }

  /// map => BMFHeatMapNode
  BMFHeatMapNode.fromMap(Map map) {
    intensity = map['intensity'];
    pt = BMFCoordinate.fromMap(map['pt']);
  }

  @override
  fromMap(Map map) {
    return BMFHeatMapNode.fromMap(map);
  }

  @override
  Map<String, Object> toMap() {
    return {'intensity': this.intensity, 'pt': this.pt.toMap()};
  }
}

/// 动画缓动函数类型
enum BMFAnimationType {
  /// 线性
  Linear,
  InQuad,
  OutQuad,
  InOutQuad,
  OutInQuad,
  InCubic,
  OutCubic,
  InOutCubic,
  OutInCubic,
  InQuart,
  OutQuart,
  InOutQuart,
  OutInQuart,
  InQuint,
  OutQuint,
  InOutQuint,
  OutInQuint,
  InSine,
  OutSine,
  InOutSine,
  OutInSine,
  InExpo,
  OutExpo,
  InOutExpo,
  OutInExpo,
  InCirc,
  OutCirc,
  InOutCirc,
  OutInCirc,
  InElastic,
  OutElastic,
  InOutElastic,
  OutInElastic,
  InBack,
  OutBack,
  InOutBack,
  OutInBack,
  InBounce,
  OutBounce,
  InOutBounce,
  OutInBounce,
  InCurve,
  OutCurve,
  SineCurve,
  CosineCurve
}

/// 热力图帧动画自定义类 since 3.3.0
class BMFAnimation implements BMFModel {
  /// 设置动画总时长，默认为0ms，
  int? duration;

  /// 动画缓动函数类型，默认0：线性
  BMFAnimationType? type;

  BMFAnimation({this.duration = 0, this.type = BMFAnimationType.Linear});

  BMFAnimation.fromMap(Map map) {
    duration = map['duration'] >= 0 ? map['duration'] : 0;
    type = BMFAnimationType.values[map['type'] as int];
  }

  @override
  fromMap(Map map) {
    return BMFAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'duration': this.duration,
      'type': this.type?.index,
    };
  }
}

/// 热力图渐变色定义类
class BMFGradient implements BMFModel {
  /// 渐变色用到的所有颜色数组 colors与startPoints必须对应
  List<Color>? colors;

  /// 每一个颜色的起始点数组,数组成员类型为 【0,1】的double值,
  /// 个数和mColors的个数必须相同，
  /// 数组内元素必须时递增的 例 【0.1, 0.5, 1】;
  List<double>? startPoints;

  /// 有参构造
  BMFGradient({required this.colors, required this.startPoints});

  /// map => BMFGradient
  BMFGradient.fromMap(Map map) {
    if (map['colors'] != null) {
      List<Color> tmpColors = [];
      map['colors'].forEach((v) {
        tmpColors.add(ColorUtil.hexToColor(v as String));
      });
      colors = tmpColors;
    }

    if (map['startPoints'] != null) {
      List<double> tmpStartPoints = [];
      map['startPoints'].forEach((v) {
        tmpStartPoints.add(v as double);
      });
      startPoints = tmpStartPoints;
    }
  }

  @override
  fromMap(Map map) {
    return BMFGradient.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'colors':
          this.colors?.map((color) => color.value.toRadixString(16)).toList(),
      'startPoints': this.startPoints?.map((p) => p).toList()
    };
  }
}
