import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, BMFPoint;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';

/// 新版marker 当前仅支持iOS
class BMFBaseMarker extends BMFOverlay {
  /// marker位置经纬度
  late BMFCoordinate position;

  /// 设置 Marker 覆盖物的锚点比例，默认（0.5, 1.0）水平居中，垂直下对齐
  /// 范围[0.0f , 1.0f]， 否则不生效
  double? anchorX;
  double? anchorY;

  /// 偏离anchor多少point（屏幕坐标系，向左「-」、向右「+」),默认0
  int? offsetX;

  /// 偏离anchor多少point（屏幕坐标系，向上「-」、向下「+」),默认0
  int? offsetY;

  /// 绕Z轴旋转角度,默认0
  double? rotation;

  /// x方向缩放倍数，默认1
  double? scaleX;

  /// y方向缩放倍数，默认1
  double? scaleY;

  /// 在有俯仰角的情况下，是否近大远小,默认flase
  bool? isPerspective;

  /// 固定到屏幕XY坐标，单位point,默认（0，0）
  /// 注：设置后BMFMapTranslateAnimation动画会失效
  BMFPoint? fixXY;

  /// 碰撞检测类型，默认NotCollide；不参与碰撞
  late BMFMarkerCollisionBehavior collisionBehavior;

  /// 碰撞优先级，值越大越不容易被碰掉,默认0
  int? collisionPriority;

  /// 动画，跟随模式,默认是TrackXY
  late BMFAnimationTrackMode trackMode;

  /// 动画,除TrackAnimation，其他动画默认添加后自动start，使用BMFMapAnimation子类实现动画，支持BMFMapAlphaAnimation，BMFMapRotateAnimation，BMFMapScaleAnimation，BMFMapTranslateAnimation，BMFMapTrackAnimation
  BMFMapAnimation? animation;

  BMFMapAnimationSet? animationSet;

  /// 透明度，范围 [0, 1.0]，默认1.0
  double? opacity;

  /// 是否可点击，默认true
  bool? isClickable;

  /// 是否可长按拖拽移动，默认flase。且isClickable为true时生效。
  bool? draggable;

  BMFBaseMarker(
      {required this.position,
      this.anchorX = 0.5,
      this.anchorY = 1.0,
      this.offsetX = 0,
      this.offsetY = 0,
      this.rotation = 0,
      this.scaleX = 1,
      this.scaleY = 1,
      this.isPerspective = false,
      this.fixXY,
      this.collisionBehavior = BMFMarkerCollisionBehavior.NotCollide,
      this.collisionPriority = 0,
      this.trackMode = BMFAnimationTrackMode.TrackXY,
      this.opacity = 1.0,
      this.animation,
      this.isClickable = true,
      this.draggable = false,
      this.animationSet,
      int zIndex = 0,
      bool visible = true,
      Map<String, dynamic>? customMap})
      : super(zIndex: zIndex, visible: visible, customMap: customMap);

  BMFBaseMarker.fromMap(Map map)
      : assert(map['position'] != null),
        super.fromMap(map) {
    position = BMFCoordinate.fromMap(map['position']);
    anchorX = map['anchorX'] as double?;
    anchorY = map['anchorY'] as double?;
    offsetX = map['offsetX'] as int?;
    offsetY = map['offsetY'] as int?;
    rotation = map['rotation'] as double?;
    scaleX = map['scaleX'] as double?;
    scaleY = map['scaleY'] as double?;
    isPerspective = map['isPerspective'];
    isClickable = map['isClickable'];
    draggable = map['draggable'];
    fixXY = map['fixXY'] == null ? null : BMFPoint.fromMap(map['fixXY']);
    collisionBehavior =
        BMFMarkerCollisionBehavior.values[map['collisionBehavior'] as int];
    collisionPriority = map['collisionPriority'] as int?;
    trackMode = BMFAnimationTrackMode.values[map['trackMode'] as int];
    animation = map['animation'] == null
        ? null
        : BMFMapAnimation.fromMap(map['animation']);
    opacity = map['opacity'] as double?;
  }

  @override
  fromMap(Map map) {
    return BMFBaseMarker.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'position': this.position.toMap(),
        'anchorX': this.anchorX,
        'anchorY': this.anchorY,
        'offsetX': this.offsetX,
        'offsetY': this.offsetY,
        'rotation': this.rotation,
        'scaleX': this.scaleX,
        'scaleY': this.scaleY,
        'isPerspective': this.isPerspective,
        'fixXY': this.fixXY?.toMap(),
        'collisionBehavior': this.collisionBehavior.index,
        'trackMode': this.trackMode.index,
        'animationSet': this.animationSet?.toMap(),
        'animation':
            BMFMapAnimation.convertAnimationType(this.animation) != null
                ? BMFMapAnimation.convertAnimationType(this.animation)
                : null,
        'opacity': this.opacity,
        'draggable': this.draggable,
        'isClickable': this.isClickable,
      });
  }
}
