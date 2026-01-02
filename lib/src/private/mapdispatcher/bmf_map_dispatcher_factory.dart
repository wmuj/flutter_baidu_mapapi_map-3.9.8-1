import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_cluster_marker_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_custommap_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_get_mapproperty_dispacther.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_heatmap_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_indoormap_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_map_copyright_info_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_maplayer_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_mapstatus_dispacther.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_marker_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_offlinemap_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_overlay_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_particleeffect_dispather.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_projection_dispatcher.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/dispatchers/bmf_userlocation_dispatcher.dart';

class BMFMapDispatcherFactory {
  // 工厂模式
  factory BMFMapDispatcherFactory() => _getInstance();
  static BMFMapDispatcherFactory get instance => _getInstance();
  static final BMFMapDispatcherFactory _instance =
      BMFMapDispatcherFactory._internal();

  late BMFMapStatusDispatcher _mapStatusDispatcher;
  late BMFMapGetPropertyDispatcher _mapGetPropertyDispatcher;
  late BMFMapUserLocationDispatcher _mapUserLocationDispatcher;
  late BMFMarkerDispatcher _markerDispatcher;
  late BMFOverlayDispatcher _overlayDispatcher;
  late BMFOfflineMapDispatcher _offlineMapDispatcher;
  late BMFProjectionDispatcher _projectionDispatcher;
  late BMFMapLayerDispatcher _mapLayerDispatcher;
  late BMFParticleEffectDispatcher _particleEffectDispatcher;
  late BMFHeatMapDispatcher _heatMapDispatcher;
  late BMFCustomMapDispatcher _customMapDispatcher;
  late BMFIndoorMapDispatcher _indoorMapDispatcher;
  late BMFMapCopyrightInfoDispatcher _mapCopyrightInfoDispatcher;
  late BMFClusterMarkerDispatcher _mapClusterMarkerDispatcher;

  BMFMapDispatcherFactory._internal() {
    _mapStatusDispatcher = BMFMapStatusDispatcher();
    _mapGetPropertyDispatcher = BMFMapGetPropertyDispatcher();
    _mapUserLocationDispatcher = BMFMapUserLocationDispatcher();
    _markerDispatcher = BMFMarkerDispatcher();
    _overlayDispatcher = BMFOverlayDispatcher();
    _offlineMapDispatcher = BMFOfflineMapDispatcher();
    _projectionDispatcher = BMFProjectionDispatcher();
    _mapLayerDispatcher = BMFMapLayerDispatcher();
    _particleEffectDispatcher = BMFParticleEffectDispatcher();
    _heatMapDispatcher = BMFHeatMapDispatcher();
    _customMapDispatcher = BMFCustomMapDispatcher();
    _indoorMapDispatcher = BMFIndoorMapDispatcher();
    _mapCopyrightInfoDispatcher = BMFMapCopyrightInfoDispatcher();
    _mapClusterMarkerDispatcher = BMFClusterMarkerDispatcher();
  }

  static BMFMapDispatcherFactory _getInstance() {
    return _instance;
  }

  /// mapStateDispatcher
  BMFMapStatusDispatcher get mapStatusDispatcher => _mapStatusDispatcher;

  /// mapGetPropertyDispatcher
  BMFMapGetPropertyDispatcher get mapGetPropertyDispatcher =>
      _mapGetPropertyDispatcher;

  /// mapUserLocationDispatcher
  BMFMapUserLocationDispatcher get mapUserLocationDispatcher =>
      _mapUserLocationDispatcher;

  /// markerDispatcher
  BMFMarkerDispatcher get markerDispatcher => _markerDispatcher;

  /// overlayDispatcher
  BMFOverlayDispatcher get overlayDispatcher => _overlayDispatcher;

  /// offlineMapDispatcher
  BMFOfflineMapDispatcher get OfflineMapDispatcher => _offlineMapDispatcher;

  /// projectionDispatcher
  BMFProjectionDispatcher get projectionDispatcher => _projectionDispatcher;

  /// mapLayerDispatcher
  BMFMapLayerDispatcher get mapLayerDispatcher => _mapLayerDispatcher;

  /// ParticleEffectDispatcher
  BMFParticleEffectDispatcher get particleEffectDispatcher =>
      _particleEffectDispatcher;

  /// heatMapDispatcher
  BMFHeatMapDispatcher get heatMapDispatcher => _heatMapDispatcher;

  /// customMapDispatcher
  BMFCustomMapDispatcher get customMapDispatcher => _customMapDispatcher;

  /// indoorMapDispatcher
  BMFIndoorMapDispatcher get indoorMapDispatcher => _indoorMapDispatcher;

  /// mapCopyrightInfoDispatcher
  BMFMapCopyrightInfoDispatcher get mapCopyrightInfoDispatcher =>
      _mapCopyrightInfoDispatcher;

  /// mapClusterMarkerDispatcher
  BMFClusterMarkerDispatcher get mapClusterMarkerDispatcher =>
      _mapClusterMarkerDispatcher;
}
