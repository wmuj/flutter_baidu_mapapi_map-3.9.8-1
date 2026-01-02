import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFModel, BMFCoordinate;
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_dispatcher_factory.dart';

import 'bmf_overlay.dart';

/// 3D模型文件格式枚举
enum BMF3DModelType {
  /// .obj
  BMF3DModelTypeObj,

  /// .glTF
  BMF3DModelTypeGLTF,
}

/// 3d模型 since 3.1.0
class BMF3DModelOverlay extends BMFOverlay {
  /// 模型中心经纬度坐标
  late BMFCoordinate center;

  /// 3d模型option
  late BMF3DModelOption option;

  /// 3d模型构造方法
  BMF3DModelOverlay({
    required this.center,
    required this.option,
    int zIndex = 0,
    bool visible = true,
    Map? customMap,
  }) : super(zIndex: zIndex, visible: visible, customMap: customMap);

  /// map => BMF3DModelOverlay
  BMF3DModelOverlay.fromMap(Map map)
      : assert(map['center'] != null),
        assert(map['option'] != null),
        super.fromMap(map) {
    center = BMFCoordinate.fromMap(map['center']);
    option = BMF3DModelOption.fromMap(map['option']);
  }

  @override
  fromMap(Map map) {
    return BMF3DModelOverlay.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return Map.from(super.toMap())
      ..addAll({
        'center': this.center.toMap(),
        'option': this.option.toMap(),
      });
  }
}

/// 3d模型option
class BMF3DModelOption implements BMFModel {
  /// 模型文件路径
  late String modelPath;

  /// 模型名
  late String modelName;

  /// 缩放比例，默认1.0
  double? scale;

  /// scale不随地图缩放而变化，默认为false
  bool? zoomFixed;

  /// 旋转角度，取值范围为【0.0f, 360.0f】，默认为0.0
  double? rotateX;

  double? rotateY;

  double? rotateZ;

  /// 偏移像素，默认为0.0
  double? offsetX;

  double? offsetY;

  double? offsetZ;

  /// 3D模型文件格式，默认BMF3DModelTypeObj
  BMF3DModelType? type;

  /// 以下只支持带有animations标签的GLTF模型
  /// 模型动画是否可用，默认为false：添加后不执行动画，值为true时添加后立即按照配置参数执行动画，since 3.5.0
  bool? animationIsEnable;

  /// 模型动画重复执行次数，默认0：动画将一直执行动画，since 3.5.0
  int? animationRepeatCount;

  /// 当前模型动画索引值，since 3.5.0
  int? animationIndex;

  /// 模型动画倍速，默认：1.0，since 3.5.0
  double? animationSpeed;

  /// 3d模型option构造方法
  BMF3DModelOption(
      {required this.modelPath,
      required this.modelName,
      this.scale = 1,
      this.zoomFixed = false,
      this.rotateX = 0,
      this.rotateY = 0,
      this.rotateZ = 0,
      this.offsetX = 0,
      this.offsetY = 0,
      this.offsetZ = 0,
      this.type = BMF3DModelType.BMF3DModelTypeObj,
      this.animationIsEnable = false,
      this.animationIndex = 0,
      this.animationRepeatCount = 0,
      this.animationSpeed = 1});

  /// map =>> BMF3DModelOption
  BMF3DModelOption.fromMap(Map map)
      : assert(map['modelPath'] != null),
        assert(map['modelName'] != null) {
    modelPath = map['modelPath'];
    modelName = map['modelName'];
    scale = (map['scale'] as num?)?.toDouble();
    zoomFixed = map['zoomFixed'] as bool;
    rotateX = (map['rotateX'] as num?)?.toDouble();
    rotateY = (map['rotateY'] as num?)?.toDouble();
    rotateZ = (map['rotateZ'] as num?)?.toDouble();
    offsetX = (map['offsetX'] as num?)?.toDouble();
    offsetY = (map['offsetY'] as num?)?.toDouble();
    offsetZ = (map['offsetZ'] as num?)?.toDouble();
    type = BMF3DModelType.values[map['type'] as int];
    animationIsEnable = map['animationIsEnable'] as bool;
    animationIndex = (map['animationIndex'] as num?)?.toInt();
    animationRepeatCount = (map['animationRepeatCount'] as num?)?.toInt();
    animationSpeed = (map['animationSpeed'] as num?)?.toDouble();
  }

  @override
  fromMap(Map map) {
    return BMF3DModelOption.fromMap(map);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'modelPath': this.modelPath,
      'modelName': this.modelName,
      'scale': this.scale,
      'zoomFixed': this.zoomFixed,
      'rotateX': this.rotateX,
      'rotateY': this.rotateY,
      'rotateZ': this.rotateZ,
      'offsetX': this.offsetX,
      'offsetY': this.offsetY,
      'type': this.type?.index,
      'animationSpeed': this.animationSpeed,
      'animationIsEnable': this.animationIsEnable,
      'animationRepeatCount': this.animationRepeatCount,
      'animationIndex': this.animationIndex,
    };
  }
}

/// 3d模型更新相关拓展 since 3.2.0
extension BMF3DModelOverlayUpdateExtension on BMF3DModelOverlay {
  /// 更新3d模型的option
  ///
  /// [BMF3DModelOption] option 3d模型option
  Future<bool> updateOption(BMF3DModelOption option) async {
    ArgumentError.checkNotNull(option, "option");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .update3DModelOverlayMember(this.methodChannel,
            {'id': this.id, 'member': 'option', 'value': option.toMap()});

    if (ret) {
      this.option = option;
    }

    return ret;
  }

  /// 更新3d模型的中心点
  ///
  /// [BMFCoordinate] center 中心点
  Future<bool> updateCenter(BMFCoordinate center) async {
    ArgumentError.checkNotNull(center, "center");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .update3DModelOverlayMember(this.methodChannel,
            {'id': this.id, 'member': 'center', 'value': center.toMap()});

    if (ret) {
      this.center = center;
    }

    return ret;
  }

  /// 更新3d模型的option 和 中心点
  ///
  /// [BMF3DModelOption] option 3d模型option
  ///
  /// [BMFCoordinate] center 中心点
  Future<bool> updateOptionAndCenter(
      {required BMF3DModelOption option, required BMFCoordinate center}) async {
    ArgumentError.checkNotNull(option, "option");
    ArgumentError.checkNotNull(center, "center");

    bool ret = await BMFMapDispatcherFactory.instance.overlayDispatcher
        .update3DModelOverlayMember(this.methodChannel, {
      'id': this.id,
      'member': 'optionAndcenter',
      'value': {'option': option.toMap(), 'center': center.toMap()}
    });

    if (ret) {
      this.option = option;
      this.center = center;
    }

    return ret;
  }
}
