import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate;

/// 点击地图标注返回数据结构
class BMFMapPoi implements BMFModel {
  /// 点标注的名称
  String? text;

  /// 点标注的经纬度坐标
  BMFCoordinate? pt;

  /// 点标注的uid，可能为空
  String? uid;

  /// BMFMapPoi构造方法
  BMFMapPoi({this.text, this.pt, this.uid});

  /// map => BMFMapPoi
  BMFMapPoi.fromMap(Map map) {
    text = map['text'];
    pt = map['pt'] == null ? null : BMFCoordinate.fromMap(map['pt']);
    uid = map['uid'];
  }
  @override
  fromMap(Map map) {
    return BMFMapPoi.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {'text': this.text, 'pt': this.pt?.toMap(), 'uid': this.uid};
  }
}
