import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, BMFCoordinateBounds;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 该类用于定义一个图片图层
class BMFGround extends BMFOverlay {
  /// 两种绘制GroundOverlay的方式之一：绘制的位置地理坐标，与anchor配对使用
  BMFCoordinate? position;

  /// 用位置绘制时图片的锚点x，图片左上角为(0.0f,0.0f),向右向下为正
  ///
  /// 使用groundOverlayWithPosition初始化时生效
  double? anchorX;

  /// 用位置绘制时图片的锚点y，图片左上角为(0.0f,0.0f),向右向下为正
  ///
  /// 使用groundOverlayWithPosition初始化时生效
  double? anchorY;

  /// 宽
  double? width;

  /// 高
  double? height;

  /// 缩放级别(仅ios支持)
  int? zoomLevel;

  /// 两种绘制GroundOverlay的方式之二：绘制的地理区域范围，图片在此区域内合理缩放
  BMFCoordinateBounds? bounds;

  /// 绘制图片
  late String image;

  /// 图片纹理透明度,最终透明度 = 纹理透明度 * alpha,取值范围为【0.0f, 1.0f】，默认为1.0f
  double? transparency;

  /// 是否可点击，默认为flase since 3.5.0
  bool? clickable;

  /// BMFGround构造方法
  BMFGround({
    required this.image,
    this.width,
    this.height,
    this.anchorX,
    this.anchorY,
    this.zoomLevel,
    this.bounds,
    this.position,
    this.transparency = 1.0,
    this.clickable = false,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMFGround
  BMFGround.fromMap(Map map)
      : assert(map['image'] != null),
        super.fromMap(map) {
    image = map['image'];
    width = map['width'];
    height = map['height'];
    anchorX = map['anchorX'];
    anchorY = map['anchorY'];
    zoomLevel = map['zoomLevel'];
    if (map['position'] != null) {
      position = BMFCoordinate.fromMap(map['position']);
    }
    if (map['bounds'] != null) {
      bounds = BMFCoordinateBounds.fromMap(map['bounds']);
    }
    transparency = map['transparency'];
    clickable = map['clickable'];
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'image': this.image,
        'width': this.width,
        'height': this.height,
        'anchorX': this.anchorX,
        'anchorY': this.anchorY,
        'zoomLevel': this.zoomLevel,
        'position': this.position?.toMap(),
        'bounds': this.bounds?.toMap(),
        'transparency': this.transparency,
        'clickable': this.clickable,
      });
  }

  @override
  fromMap(Map map) {
    return BMFGround.fromMap(map);
  }

  /**
   * Ground属性 iOS暂不支持更新
   */

  /// 更新Ground 位置, Android独有
  ///
  /// [BMFCoordinate] position ground位置
  Future<bool> updatePosition(BMFCoordinate position) async {
    ArgumentError.checkNotNull(position, "position");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'position', 'value': position.toMap()});

    if (ret) {
      this.position = position;
    }

    return ret;
  }

  /// 更新位置绘制时图片的锚点x, Android独有
  ///
  /// anchorX 用位置绘制时图片的锚点x，图片左上角为(0.0f,0.0f),向右向下为正
  Future<bool> updateAnchorX(double anchorX) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'anchorX', 'value': anchorX});

    if (ret) {
      this.anchorX = anchorX;
    }

    return ret;
  }

  /// 更新位置绘制时图片的锚点y, Android独有
  ///
  /// anchorY 用位置绘制时图片的锚点y，图片左上角为(0.0f,0.0f),向右向下为正
  Future<bool> updateAnchorY(double anchorY) async {
    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'anchorY', 'value': anchorY});

    if (ret) {
      this.anchorY = anchorY;
    }

    return ret;
  }

  /// 更新宽、高, Android独有
  ///
  /// width ground宽度
  /// height ground高度
  Future<bool> updateDimensions(double width, double height) async {
    if (width < 0 || height < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel, {
      'id': this.id,
      'member': 'dimensions',
      'width': width,
      'height': height,
    });

    if (ret) {
      this.width = width;
      this.height = height;
    }

    return ret;
  }

  /// 更新绘制的地理区域范围, Android独有
  ///
  /// [BMFCoordinateBounds] bounds 绘制的地理区域范围
  Future<bool> updateBounds(BMFCoordinateBounds bounds) async {
    ArgumentError.checkNotNull(bounds, "bounds");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'bounds', 'value': bounds.toMap()});

    if (ret) {
      this.bounds = bounds;
    }

    return ret;
  }

  /// 更新图片, Android独有
  ///
  /// image 绘制图片
  Future<bool> updateImage(String image) async {
    ArgumentError.checkNotNull(image, "image");

    if (image.isEmpty) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'image', 'value': image});

    if (ret) {
      this.image = image;
    }

    return ret;
  }

  /// 更新透明度, Android独有
  ///
  /// transparency 透明度
  Future<bool> updateTransparency(double transparency) async {
    if (transparency < 0) {
      return false;
    }

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .updateGroundMember(this.methodChannel,
            {'id': this.id, 'member': 'transparency', 'value': transparency});

    if (ret) {
      this.transparency = transparency;
    }

    return ret;
  }
}
