import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show BMFMapLayerMethId;

/// 地图图层
class BMFMapLayerDispatcher {
  /// 地图overlay图层与POI图层交换位置
  Future<bool> switchOverlayLayerAndPOILayer(
      MethodChannel _mapChannel, bool isSwitch) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(isSwitch, "isSwitch");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kSwitchOverlayLayerAndPOILayerMethod,
          {'isSwitch': isSwitch} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<bool> setPoiTagEnableAndPoiTagType(
      MethodChannel _mapChannel, bool enable, BMFPoiTagType type) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(enable, "enable");
    ArgumentError.checkNotNull(type, "type");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kMapPoiTagEnableAndPoiTagTypeMethod,
          {'method': 'set', 'poiTagEnable': enable, 'poiTagType': type.index}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<void> setOverlayUpgrade(
      MethodChannel _mapChannel, bool isUpgrade) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(isUpgrade, "isUpgrade");

    try {
      await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kMapOverlayUpgradeMethod,
          {'method': 'set', 'isUpgrade': isUpgrade}
          as dynamic);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<bool> getOverlayUpgrade(MethodChannel _mapChannel) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kMapGetOverlayUpgradeMethod,
          {'method': 'get'}
          as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<bool> getPoiTagEnable(
      MethodChannel _mapChannel, BMFPoiTagType type) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(type, "type");
    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kMapPoiTagEnableAndPoiTagTypeMethod,
          {'method': 'get', 'poiTagType': type.index} as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<bool> switchLayerOrder(MethodChannel _mapChannel, BMFLayerType layer,
      BMFLayerType otherLayer) async {
    ArgumentError.checkNotNull(_mapChannel, "_mapChannel");
    ArgumentError.checkNotNull(layer, "layer");
    ArgumentError.checkNotNull(otherLayer, "otherLayer");

    bool result = false;
    try {
      result = (await _mapChannel.invokeMethod(
          BMFMapLayerMethId.kSwitchLayerOrderMethod,
          {'layer': layer.index, 'otherLayer': otherLayer.index}
              as dynamic)) as bool;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }
}
