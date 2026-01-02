import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFSize, BMFCoordinate;
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_common_def.dart';

class BMFMapAnimation extends BMFModel {
  /// 默认为FillAfter
  late BMFAnimationFillMode fillMode;

  /// 默认RepeatRestart
  late BMFAnimationRepeatMode repeatMode;

  /// 自定义透传的参数，地图内不做处理
  String? extParam;
  int? startDelay;
  int? startTime;
  int? duration;

  /// 动画重复次数，不包含默认的一次，默认值为0，动画仅开始执行一次后立即结束；设置为1时，动画开始执行1次后会再重复1次，共2次；设置为负数时，动画将一直执行
  int? repeatCount;

  BMFInterpolator? interpolator;

  /// BMFMapAnimation构造方法
  BMFMapAnimation({
    this.fillMode = BMFAnimationFillMode.FillAfter,
    this.repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    this.extParam,
    this.startDelay,
    this.startTime,
    this.duration,
    this.repeatCount,
    this.interpolator,
  });

  /// map => BMFMapAnimation
  BMFMapAnimation.fromMap(Map map) {
    fillMode = BMFAnimationFillMode.values[map['fillMode'] as int];
    repeatMode = BMFAnimationRepeatMode.values[map['repeatMode'] as int];
    extParam = map['extParam'];
    startDelay = map['startDelay'];
    startTime = map['startTime'];
    duration = map['duration'];
    repeatCount = map['repeatCount'];
    interpolator = map['interpolator'] == null
        ? null
        : BMFInterpolator.fromMap(map['interpolator']);
  }

  @override
  fromMap(Map map) {
    return BMFMapAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "fillMode": this.fillMode.index,
      'repeatMode': this.repeatMode.index,
      'extParam': this.extParam,
      'startDelay': this.startDelay,
      'startTime': this.startTime,
      'duration': this.duration,
      'repeatCount': this.repeatCount,
      'interpolator': this.interpolator?.toMap(),
    };
  }

  static Map? convertAnimationType(BMFMapAnimation? animation) {
    if (animation.runtimeType == BMFMapRotateAnimation) {
      BMFMapRotateAnimation an = animation as BMFMapRotateAnimation;
      return an.toMap();
    } else if (animation.runtimeType == BMFMapScaleAnimation) {
      BMFMapScaleAnimation an = animation as BMFMapScaleAnimation;
      return an.toMap();
    } else if (animation.runtimeType == BMFMapAlphaAnimation) {
      BMFMapAlphaAnimation an = animation as BMFMapAlphaAnimation;
      return an.toMap();
    } else if (animation.runtimeType == BMFMapTrackAnimation) {
      BMFMapTrackAnimation an = animation as BMFMapTrackAnimation;
      return an.toMap();
    } else if (animation.runtimeType == BMFMapTranslateAnimation) {
      BMFMapTranslateAnimation an = animation as BMFMapTranslateAnimation;
      return an.toMap();
    }
    return null;
  }
}

class BMFInterpolator extends BMFModel {
  late BMFInterpolatorMode interpolatorMode;

  BMFInterpolator({
    this.interpolatorMode = BMFInterpolatorMode.Linear,
  });

  /// map => BMFInterpolator
  BMFInterpolator.fromMap(Map map) {
    interpolatorMode =
        BMFInterpolatorMode.values[map['interpolatorMode'] as int];
  }

  @override
  fromMap(Map map) {
    return BMFInterpolator.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "interpolatorMode": this.interpolatorMode.index,
    };
  }
}

class BMFMapAlphaAnimation extends BMFMapAnimation {
  late double fromAlpha;
  late double toAlpha;

  BMFMapAlphaAnimation({
    required this.fromAlpha,
    required this.toAlpha,
    int? duration,
    BMFAnimationFillMode fillMode = BMFAnimationFillMode.FillAfter,
    BMFAnimationRepeatMode repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    String? extParam,
    int? startDelay,
    int? startTime,
    int? repeatCount,
    BMFInterpolator? interpolator,
  }) : super(
            duration: duration,
            fillMode: fillMode,
            repeatMode: repeatMode,
            extParam: extParam,
            startDelay: startDelay,
            startTime: startTime,
            repeatCount: repeatCount,
            interpolator: interpolator);

  BMFMapAlphaAnimation.fromMap(Map map)
      : assert(map['fromAlpha'] != null),
        assert(map['toAlpha'] != null),
        super.fromMap(map) {
    fromAlpha = map['fromAlpha'];
    toAlpha = map['toAlpha'];
  }

  @override
  fromMap(Map map) {
    return BMFMapAlphaAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "fromAlpha": this.fromAlpha,
        'toAlpha': this.toAlpha,
        'animationType': this.runtimeType.toString(),
      });
  }
}

class BMFMapRotateAnimation extends BMFMapAnimation {
  late int fromDegrees;
  late int toDegrees;

  BMFMapRotateAnimation({
    required this.fromDegrees,
    required this.toDegrees,
    int? duration,
    BMFAnimationFillMode fillMode = BMFAnimationFillMode.FillAfter,
    BMFAnimationRepeatMode repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    String? extParam,
    int? startDelay,
    int? startTime,
    int? repeatCount,
    BMFInterpolator? interpolator,
  }) : super(
            duration: duration,
            fillMode: fillMode,
            repeatMode: repeatMode,
            extParam: extParam,
            startDelay: startDelay,
            startTime: startTime,
            repeatCount: repeatCount,
            interpolator: interpolator);

  BMFMapRotateAnimation.fromMap(Map map)
      : assert(map['fromDegrees'] != null),
        assert(map['toDegrees'] != null),
        super.fromMap(map) {
    fromDegrees = map['fromDegrees'];
    toDegrees = map['toDegrees'];
  }

  @override
  fromMap(Map map) {
    return BMFMapRotateAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "fromDegrees": this.fromDegrees,
        'toDegrees': this.toDegrees,
        'animationType': this.runtimeType.toString(),
      });
  }
}

class BMFMapScaleAnimation extends BMFMapAnimation {
  /// from缩放比例，相对于原尺寸*比例
  late BMFSize fromScale;
  late BMFSize toScale;

  BMFMapScaleAnimation({
    required this.fromScale,
    required this.toScale,
    int? duration,
    BMFAnimationFillMode fillMode = BMFAnimationFillMode.FillAfter,
    BMFAnimationRepeatMode repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    String? extParam,
    int? startDelay,
    int? startTime,
    int? repeatCount,
    BMFInterpolator? interpolator,
  }) : super(
            duration: duration,
            fillMode: fillMode,
            repeatMode: repeatMode,
            extParam: extParam,
            startDelay: startDelay,
            startTime: startTime,
            repeatCount: repeatCount,
            interpolator: interpolator);

  BMFMapScaleAnimation.fromMap(Map map)
      : assert(map['fromScale'] != null),
        assert(map['toScale'] != null),
        super.fromMap(map) {
    if (map['fromScale'] != null) {
      fromScale = BMFSize.fromMap(map['fromScale']);
    }
    if (map['toScale'] != null) {
      toScale = BMFSize.fromMap(map['toScale']);
    }
  }

  @override
  fromMap(Map map) {
    return BMFMapScaleAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'fromScale': this.fromScale.toMap(),
        'toScale': this.toScale.toMap(),
        'animationType': this.runtimeType.toString(),
      });
  }
}

class BMFMapTranslateAnimation extends BMFMapAnimation {
  late BMFCoordinate fromTranslate;
  late BMFCoordinate toTranslate;

  BMFMapTranslateAnimation({
    required this.fromTranslate,
    required this.toTranslate,
    int? duration,
    BMFAnimationFillMode fillMode = BMFAnimationFillMode.FillAfter,
    BMFAnimationRepeatMode repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    String? extParam,
    int? startDelay,
    int? startTime,
    int? repeatCount,
    BMFInterpolator? interpolator,
  }) : super(
            duration: duration,
            fillMode: fillMode,
            repeatMode: repeatMode,
            extParam: extParam,
            startDelay: startDelay,
            startTime: startTime,
            repeatCount: repeatCount,
            interpolator: interpolator);

  BMFMapTranslateAnimation.fromMap(Map map)
      : assert(map['fromTranslate'] != null),
        assert(map['toTranslate'] != null),
        super.fromMap(map) {
    if (map['fromTranslate'] != null) {
      fromTranslate = BMFCoordinate.fromMap(map['fromTranslate']);
    }
    if (map['toTranslate'] != null) {
      toTranslate = BMFCoordinate.fromMap(map['toTranslate']);
    }
  }

  @override
  fromMap(Map map) {
    return BMFMapTranslateAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "fromTranslate": this.fromTranslate.toMap(),
        'toTranslate': this.toTranslate.toMap(),
        'animationType': this.runtimeType.toString(),
      });
  }
}

/// 目前暂不支持TrackAnimation
class BMFMapTrackAnimation extends BMFMapAnimation {
  /// 轨迹动画的起始和终止坐标，坐标类型同全局坐标系，内部自动绑路计算动画进度比率
  late double fromTrackPos;
  late double toTrackPos;

  /// 轨迹动画的起始和终止比率，范围0.0~1.0， 默认0.0
  late double fromTrackPosRadio;
  late double toTrackPosRadio;

  BMFMapTrackAnimation({
    required this.fromTrackPos,
    required this.toTrackPos,
    this.fromTrackPosRadio = 0.0,
    this.toTrackPosRadio = 1.0,
    int? duration,
    BMFAnimationFillMode fillMode = BMFAnimationFillMode.FillAfter,
    BMFAnimationRepeatMode repeatMode = BMFAnimationRepeatMode.RepeatRestart,
    String? extParam,
    int? startDelay,
    int? startTime,
    int? repeatCount,
    BMFInterpolator? interpolator,
  }) : super(
            duration: duration,
            fillMode: fillMode,
            repeatMode: repeatMode,
            extParam: extParam,
            startDelay: startDelay,
            startTime: startTime,
            repeatCount: repeatCount,
            interpolator: interpolator);

  BMFMapTrackAnimation.fromMap(Map map)
      : assert(map['fromTrackPos'] != null),
        assert(map['toTrackPos'] != null),
        super.fromMap(map) {
    fromTrackPos = map['fromTrackPos'];
    toTrackPos = map['toTrackPos'];
    fromTrackPosRadio = map['fromTrackPosRadio'];
    toTrackPosRadio = map['toTrackPosRadio'];
  }

  @override
  fromMap(Map map) {
    return BMFMapTrackAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "fromTrackPos": this.fromTrackPos,
        'toTrackPos': this.toTrackPos,
        'fromTrackPosRadio': this.fromTrackPosRadio,
        'toTrackPosRadio': this.toTrackPosRadio,
        'animationType': this.runtimeType.toString(),
      });
  }
}

class BMFMapAnimationSet extends BMFModel {
  late List<BMFMapAnimation> animationList;
  late List<BMFAnimationSetOrderType> animationOrderTypeList;
  BMFMapAnimationSet({
    required this.animationList,
    required this.animationOrderTypeList,
  });

  BMFMapAnimationSet.fromMap(Map map) {
    if (map['animatedList'] != null) {
      animationList = [];
      map['coordinates'].forEach((v) {
        animationList.add(BMFMapAnimation.fromMap(v as Map));
      });
    }

    if (map['animationOrderTypeList'] != null) {
      animationOrderTypeList = [];
      map['animationOrderTypeList'].forEach((v) {
        animationOrderTypeList.add(BMFAnimationSetOrderType.values[v as int]);
      });
    }
  }

  @override
  fromMap(Map map) {
    return BMFMapAnimation.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'animationList':
          this.animationList.map((animation) => animation.toMap()).toList(),
      'animationOrderTypeList':
          this.animationOrderTypeList.map((type) => type.index).toList(),
    };
  }
}
