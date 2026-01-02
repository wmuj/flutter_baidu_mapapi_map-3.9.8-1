import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel;

/// 在线个性化样式配置选项
class BMFCustomMapStyleOption implements BMFModel {
  /// 个性化地图样式ID，可从百度地图开放平台控制台http://lbsyun.baidu.com/apiconsole/custommap获取个性化样式ID
  ///
  /// 样式ID是和AK绑定的，因此若要两端用同一个id，必须是同一个账号申请的Android和iOS的AK
  late String customMapStyleID;

  ///  个性化地图文件路径，通过id加载失败时，将会从本地加载此路径下的个性化样式
  String? customMapStyleFilePath;

  /// BMFCustomMapStyleOption构造方法
  BMFCustomMapStyleOption({
    required this.customMapStyleID,
    this.customMapStyleFilePath,
  }) : assert(customMapStyleID != null); // ignore: unnecessary_null_comparison

  /// map => BMFCustomMapStyleOption
  BMFCustomMapStyleOption.fromMap(Map map) {
    customMapStyleID = map['customMapStyleID'];
    customMapStyleFilePath = map['customMapStyleFilePath'];
  }
  @override
  fromMap(Map map) {
    return BMFCustomMapStyleOption.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'customMapStyleID': this.customMapStyleID,
      'customMapStyleFilePath': this.customMapStyleFilePath
    };
  }
}
