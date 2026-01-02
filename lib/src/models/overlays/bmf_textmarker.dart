import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, BMFPoint;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/models/overlays/bmf_basemarker_overlay.dart';

class BMFTextMarker extends BMFBaseMarker {
  late String text;

  BMFTextMarkerStyle? textStyle;

  BMFTextMarker({
    required BMFCoordinate position,
    required this.text,
    this.textStyle,
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

  BMFTextMarker.fromMap(Map map)
      : assert(map['position'] != null),
        assert(map['text'] != null),
        super.fromMap(map) {
    text = map['text'];
    textStyle = BMFTextMarkerStyle.fromMap(map['textStyle']);
  }

  @override
  fromMap(Map map) {
    return BMFTextMarker.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        "text": this.text,
        'textStyle': this.textStyle?.toMap(),
      });
  }
}
