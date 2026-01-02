import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFPoint, BMFCoordinate, BMFCoordinateBounds;

/// 此类表示地图状态信息
class BMFMapStatus implements BMFModel {
  /// 缩放级别:(4-21)
  double? fLevel;

  /// 旋转角度
  double? fRotation;

  /// 俯视角度:(-45~0)
  double? fOverlooking;

  /// 屏幕中心点坐标:在屏幕内，超过无效
  BMFPoint? targetScreenPt;

  /// 地理中心点坐标:经纬度
  BMFCoordinate? targetGeoPt;

  /// 当前屏幕显示范围内的地理范围
  BMFCoordinateBounds? coordinateBounds;

  /// BMFMapStatus构造方法
  BMFMapStatus({
    this.fLevel,
    this.fRotation,
    this.fOverlooking,
    this.targetScreenPt,
    this.targetGeoPt,
    this.coordinateBounds,
  });

  /// map => BMFMapStatus
  BMFMapStatus.fromMap(Map map) {
    //适配鸿蒙(鸿蒙中没有double类型，例number类型7.0传到flutter会被转为int)
    if (map['fLevel'] != null) {
      fLevel = double.parse(map['fLevel'].toString());
    }
    if (map['fRotation'] != null) {
      fRotation = double.parse(map['fRotation'].toString());
    }
    if (map['fOverlooking'] != null) {
      fOverlooking = double.parse(map['fOverlooking'].toString());
    }
    targetScreenPt = map['targetScreenPt'] == null
        ? null
        : BMFPoint.fromMap(map['targetScreenPt']);
    targetGeoPt = map['targetGeoPt'] == null
        ? null
        : BMFCoordinate.fromMap(map['targetGeoPt']);
    coordinateBounds = map['visibleMapBounds'] == null
        ? null
        : BMFCoordinateBounds.fromMap(map['visibleMapBounds']);
  }

  @override
  fromMap(Map map) {
    return BMFMapStatus.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'fLevel': this.fLevel,
      'fRotation': this.fRotation,
      'fOverlooking': this.fOverlooking,
      'targetScreenPt': this.targetScreenPt?.toMap(),
      'targetGeoPt': this.targetGeoPt?.toMap(),
      'visibleMapBounds': this.coordinateBounds?.toMap()
    };
  }
}
