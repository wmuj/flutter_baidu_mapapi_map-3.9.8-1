import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/models/overlays/bmf_basemarker_overlay.dart';

/// 字体样式
enum BMFMarkerAnimateType {
  ///< 无动画
  None,

  ///< 从天上掉下
  Drop,

  ///< 从地面生长
  Grow,

  ///< 跳动
  Jump,
}

class BMFIconMarker extends BMFBaseMarker {
  // 单张图片资源
  String? icon;

  // 多帧图片资源组,多张图片，依次播放
  List<String>? icons;

  //  轮换图片资源的时间间隔, 最小20ms,默认160ms
  late int interval;

  // 重复次数，最大100，默认:100
  late int repeatCnt;

  // 图片混合颜色
  Color? color;

  // 动画类型，默认None 无动画
  late BMFMarkerAnimateType animationType;

  BMFIconMarker({
    required BMFCoordinate position,
    this.icon,
    this.icons,
    this.interval = 160,
    this.repeatCnt = 100,
    this.color,
    this.animationType = BMFMarkerAnimateType.None,
    double? anchorX = 0.5,
    double? anchorY = 1.0,
    int? offsetX,
    int? offsetY,
    double? rotation,
    double? scaleX = 1,
    double? scaleY = 1,
    bool? isPerspective,
    BMFPoint? fixXY,
    BMFMarkerCollisionBehavior collisionBehavior =
        BMFMarkerCollisionBehavior.NotCollide,
    int? collisionPriority,
    BMFAnimationTrackMode trackMode = BMFAnimationTrackMode.TrackXY,
    double? opacity = 1,
    BMFMapAnimation? animation,
    BMFMapAnimationSet? animationSet,
    bool? isClickable = true,
    bool? draggable,
  }) : super(
            position: position,
            anchorX: anchorX,
            anchorY: anchorY,
            offsetX: offsetX,
            offsetY: offsetY,
            rotation: rotation,
            scaleX: scaleX,
            scaleY: scaleY,
            isPerspective: isPerspective,
            fixXY: fixXY,
            collisionBehavior: collisionBehavior,
            collisionPriority: collisionPriority,
            trackMode: trackMode,
            animation: animation,
            animationSet: animationSet,
            isClickable: isClickable,
            draggable: draggable);

  BMFIconMarker.fromMap(Map map)
      : assert(map['position'] != null),
        super.fromMap(map) {
    icon = map['icon'];
    if (map['icons'] != null) {
      icons = <String>[];
      map['icons'].forEach((v) {
        icons!.add(v as String);
      });
    }
    interval = map['interval'] as int;
    repeatCnt = map['repeatCnt'] as int;
    color = ColorUtil.hexToColor(map['color']);
    animationType = BMFMarkerAnimateType.values[map['animationType' as int]];
  }

  @override
  fromMap(Map map) {
    return BMFIconMarker.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "icon": this.icon,
        'icons': this.icons != null ? this.icons!.map((e) => e).toList() : null,
        'interval': this.interval,
        'repeatCnt': this.repeatCnt,
        'color':
            this.color != null ? this.color!.value.toRadixString(16) : null,
        'animationType': this.animationType.index
      });
  }
}
