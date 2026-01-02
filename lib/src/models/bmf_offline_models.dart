import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate;

/// 离线地图搜索城市记录结构
class BMFOfflineCityRecord implements BMFModel {
  /// 城市ID
  int? cityID;

  /// 数据包总大小
  int? dataSize;

  /// 城市名称
  String? cityName;

  /// 城市类型0:全国；1：省份；2：城市,如果是省份，可以通过childCities得到子城市列表
  int? cityType;

  /// 子城市列表
  List<BMFOfflineCityRecord>? childCities;

  /// BMFOfflineCityRecord构造方法
  BMFOfflineCityRecord({
    this.cityID,
    this.dataSize,
    this.cityName,
    this.cityType,
    this.childCities,
  });

  /// map => BMFOfflineCityRecord
  BMFOfflineCityRecord.fromMap(Map map) {
    cityID = map['cityID'];
    dataSize = map['dataSize'];
    cityName = map['cityName'];
    cityType = map['cityType'];
    if (map['childCities'] != null) {
      List<BMFOfflineCityRecord> tmpChildCities = [];
      map['childCities'].forEach((v) {
        tmpChildCities.add(BMFOfflineCityRecord.fromMap(v as Map));
      });
      childCities = tmpChildCities;
    }
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'cityID': this.cityID,
      'dataSize': this.dataSize,
      'cityName': this.cityName,
      'cityType': this.cityType,
      'childCities': this.childCities?.map((city) => city.toMap()).toList()
    };
  }

  @override
  fromMap(Map map) {
    return BMFOfflineCityRecord.fromMap(map);
  }
}

///  离线地图更新信息
class BMFUpdateElement extends BMFModel {
  /// 未定义
  static const int UNDEFINED = 0;

  /// 正在下载
  static const int DOWNLOADING = 1;

  /// 等待下载
  static const int WAITING = 2;

  /// 已暂停
  static const int SUSPENDED = 3;

  /// 完成
  static const int FINISHED = 4;

  /// 校验失败
  static const int eOLDSMd5Error = 5;

  /// 网络异常
  static const int eOLDSNetError = 6;

  /// 读写异常
  static const int eOLDSIOError = 7;

  /// wifi网络异常
  static const int eOLDSWifiError = 8;

  /// 数据错误，需重新下载
  static const int eOLDSFormatError = 9;

  /// 城市ID
  int? cityID;

  /// 城市名称
  String? cityName;

  /// 下载比率，100为下载完成
  int? ratio;

  /// 下载状态
  int? status;

  /// 城市中心点坐标
  BMFCoordinate? geoPt;

  /// 已下载数据大小
  int? size;

  /// 服务端数据大小
  int? serversize;

  /// 离线包地图层级(ios没有)
  int? level;

  /// 是否为更新
  bool? update;

  /// BMFUpdateElement构造方法
  BMFUpdateElement({
    this.cityID,
    this.cityName,
    this.ratio,
    this.status,
    this.geoPt,
    this.size,
    this.serversize,
    this.level,
    this.update,
  });

  /// map => BMFUpdateElement
  BMFUpdateElement.fromMap(Map map) {
    cityID = map["cityID"];
    cityName = map["cityName"];
    ratio = map["ratio"];
    status = map["status"];
    geoPt = map['geoPt'] == null ? null : BMFCoordinate.fromMap(map['geoPt']);
    size = map["size"];
    serversize = map["serversize"];
    level = map["level"];
    update = map["update"];
  }

  @override
  fromMap(Map map) {
    return BMFUpdateElement.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "cityID": this.cityID,
      "cityName": this.cityName,
      "ratio": this.ratio,
      "status": this.status,
      "geoPt": this.geoPt?.toMap(),
      "size": this.size,
      "serversize": this.serversize,
      "level": this.level,
      "update": this.update
    };
  }
}
