import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, ColorUtil, BMFBuildInfo;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

/// 3D棱柱 since 3.1.0
class BMFPrismOverlay extends BMFOverlay {
  /// 经纬度数组
  List<BMFCoordinate>? coordinates;

  BMFBuildInfo? buildInfo;

  /// 高度
  int? height;

  /// 楼层高度  (仅对建筑物生效)  since 3.5.0
  double? floorHeight;

  /// 3D棱柱顶面颜色
  Color? topFaceColor;

  /// 3D棱柱侧面颜色
  ///
  /// 与sideFacTexture二选一
  Color? sideFaceColor;

  /// 3D棱柱侧面纹理图片路径
  ///
  /// 与sideFaceColor二选一
  String? sideFacTexture;

  /// 是否开启生长动画(仅对建筑物生效)，默认true
  bool? isGrowthAnimation;

  /// 建筑物显示层级(仅对建筑物生效), 默认18
  int? showLevel;

  /// 自定义建筑物的楼层颜色 (仅对建筑物生效) since 3.5.0
  Color? floorColor;

  /// 自定义建筑物的楼层侧面纹理 (仅对建筑物生效) since 3.5.0
  String? floorSideTextureImage;

  /// 是否开启圆角 (仅对建筑物生效) since 3.8.0
  bool? isRoundedCorner;

  /// 开启圆角后，设置圆角半径，建议范围1~10，默认为5.0f (仅对建筑物生效) since 3.8.0
  double? roundedCornerRadius;

  /// 3d棱柱构造方法
  BMFPrismOverlay({
    required this.coordinates,
    required this.topFaceColor,
    this.sideFaceColor,
    this.sideFacTexture,
    this.height,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates != null),
        assert(coordinates!.length > 3),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 3d棱柱颜色构造方法
  BMFPrismOverlay.colorPrismOverlay({
    required this.coordinates,
    required this.topFaceColor,
    required this.sideFaceColor,
    this.height,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates != null),
        assert(coordinates!.length > 3),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 3d棱柱纹理构造方法
  BMFPrismOverlay.texturePrismOverlay({
    required this.coordinates,
    required this.topFaceColor,
    required this.sideFacTexture,
    this.height,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(coordinates != null),
        assert(coordinates!.length > 3),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 地图建筑物颜色构造方法
  BMFPrismOverlay.buildingForColor({
    required this.buildInfo,
    required this.topFaceColor,
    required this.sideFaceColor,
    this.isGrowthAnimation = true,
    this.showLevel,
    this.height,
    this.floorColor,
    this.floorSideTextureImage,
    this.floorHeight,
    this.isRoundedCorner,
    this.roundedCornerRadius,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(buildInfo != null),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// 地图建筑物纹理构造方法
  BMFPrismOverlay.buildingForTexture({
    required this.buildInfo,
    required this.topFaceColor,
    required this.sideFacTexture,
    this.isGrowthAnimation = true,
    this.showLevel,
    this.height,
    this.floorColor,
    this.floorSideTextureImage,
    this.floorHeight,
    this.isRoundedCorner,
    this.roundedCornerRadius,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  })  : assert(buildInfo != null),
        super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFPrismOverlay
  BMFPrismOverlay.fromMap(Map map)
      : assert(map['topFaceColor'] != null),
        super.fromMap(map) {
    if (map['coordinates'] != null) {
      coordinates = <BMFCoordinate>[];
      map['coordinates'].forEach((v) {
        coordinates?.add(BMFCoordinate.fromMap(v as Map));
      });
    }

    topFaceColor = ColorUtil.hexToColor(map['topFaceColor']);
    sideFaceColor = ColorUtil.hexToColor(map['sideFaceColor']);
    height = map['height'].floor();
    buildInfo = (map['buildInfo'] == null
        ? null
        : BMFBuildInfo.fromMap(map['buildInfo']));
    sideFacTexture = map['sideFacTexture'];
    isGrowthAnimation = map['isGrowthAnimation'];
    showLevel = map['showLevel'];
    floorColor = ColorUtil.hexToColor(map['floorColor']);
    floorSideTextureImage = map['floorSideTextureImage'];
    floorHeight = map['floorHeight'] as double;
    isRoundedCorner = map['isRoundedCorner'];
    roundedCornerRadius = map['roundedCornerRadius'] as double;
  }

  @override
  fromMap(Map map) {
    return BMFPrismOverlay.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'coordinates': this.coordinates?.map((coord) => coord.toMap()).toList(),
        'buildInfo': this.buildInfo?.toMap(),
        'height': this.height,
        'topFaceColor': this.topFaceColor?.value.toRadixString(16),
        'sideFaceColor': this.sideFaceColor?.value.toRadixString(16),
        'sideFacTexture': this.sideFacTexture,
        'isGrowthAnimation': this.isGrowthAnimation,
        'showLevel': this.showLevel,
        'floorSideTextureImage': this.floorSideTextureImage,
        'floorColor': this.floorColor?.value.toRadixString(16),
        'floorHeight': this.floorHeight,
        'isRoundedCorner': this.isRoundedCorner,
        'roundedCornerRadius': this.roundedCornerRadius,
      });
  }
}

/// prismOverlay更新 since 3.2.0
extension BMFPrismOverlayUpdateExtension on BMFPrismOverlay {
  /// 更新经纬度数组
  ///
  /// List<[BMFCoordinate]> coordinates prismOverlay经纬度数组
  Future<bool> updateCoordinates(List<BMFCoordinate> coordinates) async {
    ArgumentError.checkNotNull(coordinates, "coordinates");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel, {
      'id': this.id,
      'member': 'coordinates',
      'value': coordinates.map((coordinate) => coordinate.toMap()).toList()
    });

    if (ret) {
      this.coordinates = coordinates;
    }

    return ret;
  }

  /// 更新建筑物信息
  ///
  /// [BMFBuildInfo] buildInfo  建筑物信息
  Future<bool> updateBuildInfo(BMFBuildInfo buildInfo) async {
    ArgumentError.checkNotNull(buildInfo, "buildInfo");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel,
            {'id': this.id, 'member': 'buildInfo', 'value': buildInfo.toMap()});

    if (ret) {
      this.buildInfo = buildInfo;
    }

    return ret;
  }

  /// 更新顶面颜色
  Future<bool> updateTopFaceColor(Color topFaceColor) async {
    ArgumentError.checkNotNull(topFaceColor, "topFaceColor");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel, {
      'id': this.id,
      'member': 'topFaceColor',
      'value': topFaceColor.value.toRadixString(16)
    });

    if (ret) {
      this.topFaceColor = topFaceColor;
    }

    return ret;
  }

  /// 更新侧面颜色
  Future<bool> updateSideFaceColor(Color sideFaceColor) async {
    ArgumentError.checkNotNull(sideFaceColor, "sideFaceColor");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel, {
      'id': this.id,
      'member': 'sideFaceColor',
      'value': sideFaceColor.value.toRadixString(16)
    });

    if (ret) {
      this.sideFaceColor = sideFaceColor;
    }

    return ret;
  }

  /// 更新侧面纹理
  Future<bool> updateSideFacTexture(String sideFacTexture) async {
    ArgumentError.checkNotNull(sideFacTexture, "sideFacTexture");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel, {
      'id': this.id,
      'member': 'sideFacTexture',
      'value': sideFacTexture
    });

    if (ret) {
      this.sideFacTexture = sideFacTexture;
    }

    return ret;
  }

  /// 更新楼层高度
  Future<bool> updateFloorHeight(double floorHeight) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updatePrismOverlayMember(this.methodChannel,
            {'id': this.id, 'member': 'floorHeight', 'value': floorHeight});

    if (ret) {
      this.floorHeight = floorHeight;
    }

    return ret;
  }
}
