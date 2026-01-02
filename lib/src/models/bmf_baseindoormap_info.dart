import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel;

/// 此类表示室内图基础信息
class BMFBaseIndoorMapInfo implements BMFModel {
  /// 室内ID
  String? strID;

  /// 当前楼层
  String? strFloor;

  /// 所有楼层信息
  List<String>? listStrFloors;

  /// BMFBaseIndoorMapInfo构造方法
  BMFBaseIndoorMapInfo({this.strID, this.strFloor, this.listStrFloors});

  /// map => BMFBaseIndoorMapInfo
  BMFBaseIndoorMapInfo.fromMap(Map map) {
    strID = map['strID'];
    strFloor = map['strFloor'];
    if (map['listStrFloors'] != null) {
      listStrFloors = [];
      map['listStrFloors'].forEach((v) {
        listStrFloors!.add(v as String);
      });
    }
  }

  @override
  fromMap(Map map) {
    return BMFBaseIndoorMapInfo.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'strID': this.strID,
      'strFloor': this.strFloor,
      'listStrFloors': this.listStrFloors?.map((s) => s.toString()).toList()
    };
  }
}
