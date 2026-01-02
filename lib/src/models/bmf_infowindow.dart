import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate;

/// infoWindow
class BMFInfoWindow extends BMFModel {
  /// infoWindow唯一id
  late String _id;

  /// infowWindow图片名
  late String image;

  /// infoWindow显示位置
  late BMFCoordinate coordinate;

  /// infoWindow y轴方向偏移
  double? yOffset;

  /// 是否以bitmap形式添加
  bool? isAddWithBitmap;

  /// BMFInfoWindow构造方法
  BMFInfoWindow({
    required this.image,
    required this.coordinate,
    this.yOffset,
    this.isAddWithBitmap,
  }) {
    this._id = this.hashCode.toString();
  }

  /// map => BMFInfoWindow
  BMFInfoWindow.fromMap(Map map) {
    _id = map['id'];
    image = map['image'];
    coordinate = BMFCoordinate.fromMap(map['coordinate']);
    yOffset = map['yOffset'];
    isAddWithBitmap = map['isAddWithBitmapDescriptor'];
  }

  /// infoWindow唯一id
  @Deprecated('Use `id` method instead since 3.2.0')
  String get Id => _id;

  /// infoWindow唯一id since 3.2.0
  String get id => _id;
  @override
  fromMap(Map map) {
    return BMFInfoWindow.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "id": this.id,
      'image': this.image,
      'coordinate': this.coordinate.toMap(),
      'yOffset': this.yOffset,
      'isAddWithBitmapDescriptor': this.isAddWithBitmap
    };
  }
}
