import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinateBounds;

import 'bmf_overlay.dart';

/// 枚举：瓦片图加载方式
enum BMFTileLoadType {
  /// 网络加载,取该值时BMFTile必须传url
  LoadUrlTile,

  /// 本地异步加载
  LoadLocalAsyncTile,

  /// 本地同步加载
  ///
  /// Android没有该选项
  LoadLocalSyncTile,
}

/// 瓦片图
class BMFTile extends BMFOverlay {
  /// 瓦片图最大放大级别,android平台默认为20，其它平台默认为21
  int? maxZoom;

  /// 瓦片图最小缩放级别,默认3
  int? minZoom;

  /// tileOverlay的可渲染区域，默认世界范围
  late BMFCoordinateBounds visibleMapBounds;

  /// 瓦片图缓存大小,android端需要，iOS端暂时不需要
  int? maxTileTmp;

  /// 瓦片图加载类型
  late BMFTileLoadType tileLoadType;

  /// 可选的参数，只有tileLoadType为LoadUrlTile时才有效
  String? url;

  /// BMFTile构造方法
  BMFTile({
    required this.visibleMapBounds,
    required this.tileLoadType,
    this.maxZoom,
    this.minZoom,
    this.maxTileTmp,
    this.url,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFTile
  BMFTile.fromMap(Map map)
      : assert(map['visibleMapBounds'] != null),
        assert(map['tileLoadType'] != null),
        super.fromMap(map) {
    maxZoom = map['maxZoom'];
    minZoom = map['minZoom'];
    visibleMapBounds = BMFCoordinateBounds.fromMap(map['visibleMapBounds']);
    maxTileTmp = map['maxTileTmp'];
    tileLoadType = BMFTileLoadType.values[map['tileLoadType'] as int];
    url = map['url'];
  }

  @override
  fromMap(Map map) {
    return BMFTile.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'maxZoom': this.maxZoom,
        'minZoom': this.minZoom,
        'visibleMapBounds': this.visibleMapBounds.toMap(),
        'maxTileTmp': this.maxTileTmp,
        'tileLoadType': this.tileLoadType.index,
        'url': this.url
      });
  }
}
