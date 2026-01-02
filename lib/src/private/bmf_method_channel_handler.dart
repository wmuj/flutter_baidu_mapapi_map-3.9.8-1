import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/src/private/mapdispatcher/bmf_map_method_id.dart'
    show
        BMFMapCallbackMethodId,
        BMFOverlayCallbackMethodId,
        BMFMarkerCallbackMethodId,
        BMFInfoWindowMethodId,
        BMFHeatMapMethodId,
        BMFUserlocationMethodId,
        BMFClusterMethodID;

/// 地图无参数回调
typedef BMFMapCallback = void Function();

/// 地图成功回调
typedef BMFMapSuccessCallback = void Function(bool success);

/// 地图区域改变回调
typedef BMFMapRegionChangeCallback = void Function(BMFMapStatus mapStatus);

/// 地图区域改变原因回调
typedef BMFMapRegionChangeReasonCallback = void Function(
    BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason);

/// 点中底图标注后会回调此接口
typedef BMFMapOnClickedMapPoiCallback = void Function(BMFMapPoi mapPoi);

/// 地图marker事件回调
typedef BMFMapMarkerCallback = void Function(BMFMarker marker);

/// Cluster点击事件回调
typedef BMFMapClusterCallback = void Function(
    List<BMFClusterInfo> clusterInfoList, int size);

/// Cluster点击item事件回调
typedef BMFMapClusterClickItemCallback = void Function(
    BMFClusterInfo clusterInfo);

/// 地图拖拽marker回调
typedef BMFMapDragMarkerCallback = void Function(
    BMFMarker marker, BMFMarkerDragState newState, BMFMarkerDragState oldState);

/// 地图点击覆盖物回调，目前只支持点中Polyline,Text时回调
typedef BMFMapOnClickedOverlayCallback = void Function(BMFOverlay overlay);

/// 地图点击海量点回调
///
/// Android 端回调时不处理BMFMultiPointOverlay中items，如开发者需要根据id在flutter层处理。
typedef BMFMapOnClickedMultiPointOverlayItemCallback = void Function(
    BMFMultiPointOverlay multiPointOverlay, BMFMultiPointItem item);

/// traceOverlay动画开始
typedef BMFTraceOverlayAnimationDidStartCallback = void Function(
    BMFTraceOverlay traceOverlay);

/// traceOverlay动动画进度
///
/// progress 进度 0.0 ~ 100.0
typedef BMFTraceOverlayAnimationRunningProgressCallback = void Function(
    BMFTraceOverlay traceOverlay, double progress);

/// traceOverlay动画结束
///
/// flag 动画是否完成
typedef BMFTraceOverlayAnimationDidEndCallback = void Function(
    BMFTraceOverlay traceOverlay, bool flag);

/// 楼层动画结束
typedef BMFPrismOverlayViewFloorAnimationDidEndCallback = void Function(
    BMFPrismOverlay prismOverlay);

/// traceOverlay动画更新的当前位置点回调
///
/// coordinate 轨迹动画更新的当前位置点 Android独有
typedef BMFTraceOverlayAnimationUpdatePositionCallback = void Function(
    BMFCoordinate coordinate);

/// 地图经纬度回调
typedef BMFMapCoordinateCallback = void Function(BMFCoordinate coordinate);

/// 地图3DTouch回调
///
/// coordinate 触摸点的经纬度
///
/// force 触摸该点的力度(参考UITouch的force属性)
///
/// maximumPossibleForce 当前输入机制下的最大可能力度(参考UITouch的maximumPossibleForce属性)
typedef BMFMapOnForceTouchCallback = void Function(
    BMFCoordinate coordinate, double force, double maximumPossibleForce);

/// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
typedef BMFMapOnDrawMapFrameCallback = void Function(BMFMapStatus mapStatus);

/// 地图View进入/移出室内图会调用此方法
///
/// flag true:进入室内图，false：移出室内图
///
/// baseIndoorMapInfo 室内图信息
typedef BMFMapInOrOutBaseIndoorMapCallback = void Function(
    bool flag, BMFBaseIndoorMapInfo baseIndoorMapInfo);

/// 地图绘制出有效数据的监听
typedef BMFMapRenderValidDataCallback = void Function(
    bool isValid, int errorCode, String errorMessage);

/// 热力图渲染索引事件回调
typedef BMFHeatMapFrameAnimationCallback = void Function(int index);

/// 切换定位模式回调
typedef BMFUserTrackingModeChangedCallback = void Function(
    BMFUserTrackingMode mode);

///处理native发送过来的消息
class BMFMethodChannelHandler {
  static const sTag = 'BMFMethodChannelHandler';
  late MethodChannel _methodChannel;
  BMFMethodChannelHandler(MethodChannel methodChannel) {
    _methodChannel = methodChannel;
  }

  /// 加载完成回调
  BMFMapCallback? _mapDidLoadCallback;

  /// 渲染完成回调
  BMFMapSuccessCallback? _mapDidFinishRenderCallback;

  /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
  BMFMapOnDrawMapFrameCallback? _mapOnDrawMapFrameCallback;

  /// 两端类型不一致，Android返回的是MapStatus状态，ios没有返回参数
  ///
  /// 地图区域即将改变时会调用此接口
  BMFMapRegionChangeCallback? _mapRegionWillChangeCallback;

  /// 两端类型不一致，Android返回的是MapStatus状态，ios没有返回参数
  ///
  /// 地图区域改变完成后会调用此接口
  BMFMapRegionChangeCallback? _mapRegionDidChangeCallback;

  /// 两端类型不一致，Android返回的是MapStatus状态，ios没有返回参数
  ///
  /// 地图区域即将改变时会调用此接口reason
  BMFMapRegionChangeReasonCallback? _mapRegionWillChangeWithReasonCallback;

  /// 两端类型不一致，Android返回的是MapStatus状态，ios没有返回参数
  ///
  /// 地图区域改变完成后会调用此接口reason
  BMFMapRegionChangeReasonCallback? _mapRegionDidChangeWithReasonCallback;

  /// 地图点击覆盖物回调，目前只支持点中Polyline,Text时回调
  BMFMapOnClickedOverlayCallback? _mapOnClickedOverlayCallback;

  /// 点击海量点回调
  BMFMapOnClickedMultiPointOverlayItemCallback?
      _mapOnClickedMultiPointOverlayItemCallback;

  /// 动态轨迹动画开始回调
  BMFTraceOverlayAnimationDidStartCallback?
      _traceOverlayAnimationDidStartCallback;

  /// 动态轨迹动画进度回调
  BMFTraceOverlayAnimationRunningProgressCallback?
      _traceOverlayAnimationRunningProgressCallback;

  /// 动态轨迹动画结束回调
  BMFTraceOverlayAnimationDidEndCallback? _traceOverlayAnimationDidEndCallback;

  /// 动画轨迹当前位置回调
  BMFTraceOverlayAnimationUpdatePositionCallback?
      _traceOverlayAnimationUpdatePositionCallback;

  /// 楼层动画结束
  BMFPrismOverlayViewFloorAnimationDidEndCallback?
      _prismOverlayViewFloorAnimationDidEndCallback;

  /// 点中底图标注后会回调此接口
  BMFMapOnClickedMapPoiCallback? _mapOnClickedMapPoiCallback;

  /// 点中底图空白处会回调此接口
  BMFMapCoordinateCallback? _mapOnClickedMapBlankCallback;

  /// 双击地图时会回调此接口
  BMFMapCoordinateCallback? _mapOnDoubleClickCallback;

  /// 长按地图时会回调此接口
  BMFMapCoordinateCallback? _mapOnLongClickCallback;

  /// (ios) 独有
  ///
  /// 3DTouch 按地图时会回调此接口
  ///
  ///（仅在支持3D Touch，且fouchTouchEnabled属性为true时，会回调此接口）
  BMFMapOnForceTouchCallback? _mapOnForceTouchCallback;

  /// 地图状态改变完成后会调用此接口
  BMFMapCallback? _mapStatusDidChangedCallback;

  /// 地图View进入/移出室内图会调用此方法
  BMFMapInOrOutBaseIndoorMapCallback? _mapInOrOutBaseIndoorMapCallback;

  //marker
  /// marker点击回调
  BMFMapMarkerCallback? _mapClickedMarkerCallback;

  /// marker选中回调
  BMFMapMarkerCallback? _mapDidSelectMarkerCallback;

  /// marker取消选中回调
  BMFMapMarkerCallback? _mapDidDeselectMarkerCallback;

  /// marker拖拽回调
  BMFMapDragMarkerCallback? _mapDragMarkerCallback;

  /// marker的infoWindow（ios paopaoView）点击回调
  BMFMapMarkerCallback? _mapDidClickedInfoWindowCallback;

  /// 点聚合点击回调
  BMFMapClusterCallback? _mapClusterCallback;

  /// 点聚合item点击回调
  BMFMapClusterClickItemCallback? _mapClusterItemCallback;

  /// 地图绘制出有效数据的监听
  BMFMapRenderValidDataCallback? _mapRenderValidDataCallback;

  /// 热力图渲染索引事件回调
  BMFHeatMapFrameAnimationCallback? _heatMapFrameAnimationCallback;

  /// 切换定位模式回调
  BMFUserTrackingModeChangedCallback? _userTrackingModeChangedCallback;

  /// native -> flutter
  dynamic handlerMethod(MethodCall call) async {
    switch (call.method) {
      case BMFMapCallbackMethodId.kMapDidLoadCallback:
        {
          if (this._mapDidLoadCallback != null) {
            this._mapDidLoadCallback!();
          }
          break;
        }

      case BMFMapCallbackMethodId.kMapDidFinishRenderCallback:
        {
          if (this._mapDidFinishRenderCallback != null) {
            this._mapDidFinishRenderCallback!(
                call.arguments['success'] as bool);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnDrawMapFrameCallback:
        {
          if (this._mapOnDrawMapFrameCallback != null) {
            BMFMapStatus mapStatus =
                BMFMapStatus.fromMap(call.arguments['mapStatus']);
            this._mapOnDrawMapFrameCallback!(mapStatus);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapRegionWillChangeCallback:
        {
          if (this._mapRegionWillChangeCallback != null) {
            BMFMapStatus mapStatus =
                BMFMapStatus.fromMap(call.arguments['mapStatus']);
            this._mapRegionWillChangeCallback!(mapStatus);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapRegionDidChangeCallback:
        {
          if (this._mapRegionDidChangeCallback != null) {
            BMFMapStatus mapStatus =
                BMFMapStatus.fromMap(call.arguments['mapStatus']);
            this._mapRegionDidChangeCallback!(mapStatus);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapRegionWillChangeWithReasonCallback:
        {
          if (this._mapRegionWillChangeWithReasonCallback != null) {
            BMFMapStatus mapStatus =
                BMFMapStatus.fromMap(call.arguments['mapStatus']);
            BMFRegionChangeReason reason =
                BMFRegionChangeReason.values[call.arguments['reason'] as int];
            this._mapRegionWillChangeWithReasonCallback!(mapStatus, reason);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapRegionDidChangeWithReasonCallback:
        {
          if (this._mapRegionDidChangeWithReasonCallback != null) {
            BMFMapStatus mapStatus =
                BMFMapStatus.fromMap(call.arguments['mapStatus']);
            BMFRegionChangeReason reason;
            try {
              reason =
                  BMFRegionChangeReason.values[call.arguments['reason'] as int];
            } catch (e) {
              reason = BMFRegionChangeReason.APIs;
            }
            this._mapRegionDidChangeWithReasonCallback!(mapStatus, reason);
          }
          break;
        }
      case BMFOverlayCallbackMethodId.kMapOnClickedOverlayCallback:
        {
          if (this._mapOnClickedOverlayCallback != null) {
            late BMFOverlay overlay;
            BMFOverlayType type =
                BMFOverlayType.values[call.arguments['overlayType'] as int];
            switch (type) {
              case BMFOverlayType.Polyline:
                overlay = BMFPolyline.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.Text:
                overlay = BMFText.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.Ground:
                overlay = BMFGround.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.Circle:
                overlay = BMFCircle.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.Polygon:
                overlay = BMFPolygon.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.GradientLine:
                overlay = BMFGradientLine.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.Arcline:
                overlay = BMFArcLine.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.TextMarker:
                overlay = BMFTextMarker.fromMap(call.arguments['overlay']);
                break;
              case BMFOverlayType.IconMarker:
                overlay = BMFIconMarker.fromMap(call.arguments['overlay']);
                break;
              default:
                print('overlay点击回调无效');
                break;
            }
            overlay.methodChannel = _methodChannel;
            this._mapOnClickedOverlayCallback!(overlay);
          }
          break;
        }
      case BMFOverlayCallbackMethodId
            .kMapOnClickedMultiPointOverlayItemCallback:
        {
          if (this._mapOnClickedMultiPointOverlayItemCallback != null) {
            BMFMultiPointOverlay multiPointOverlay =
                BMFMultiPointOverlay.fromMap(
                    call.arguments['multiPointOverlay']);
            BMFMultiPointItem item =
                BMFMultiPointItem.fromMap(call.arguments['item']);
            multiPointOverlay.methodChannel = _methodChannel;
            this._mapOnClickedMultiPointOverlayItemCallback!(
                multiPointOverlay, item);
          }
          break;
        }
      case BMFOverlayCallbackMethodId.kTraceOverlayAnimationDidStartCallback:
        {
          if (this._traceOverlayAnimationDidStartCallback != null) {
            BMFTraceOverlay traceOverlay =
                BMFTraceOverlay.fromMap(call.arguments['traceOverlay']);
            traceOverlay.methodChannel = _methodChannel;
            this._traceOverlayAnimationDidStartCallback!(traceOverlay);
          }
          break;
        }
      case BMFOverlayCallbackMethodId
            .kTraceOverlayAnimationRunningProgressCallback:
        {
          if (this._traceOverlayAnimationRunningProgressCallback != null) {
            BMFTraceOverlay traceOverlay =
                BMFTraceOverlay.fromMap(call.arguments['traceOverlay']);
            double progress = call.arguments['progress'] as double;
            this._traceOverlayAnimationRunningProgressCallback!(
                traceOverlay, progress);
          }
          break;
        }
      case BMFOverlayCallbackMethodId.kTraceOverlayAnimationDidEndCallback:
        {
          if (this._traceOverlayAnimationDidEndCallback != null) {
            BMFTraceOverlay traceOverlay =
                BMFTraceOverlay.fromMap(call.arguments['traceOverlay']);
            bool flag = call.arguments['flag'] as bool;
            this._traceOverlayAnimationDidEndCallback!(traceOverlay, flag);
          }
          break;
        }
      case BMFOverlayCallbackMethodId
            .kPrismOverlayViewFloorAnimationDidEndCallback:
        {
          if (this._prismOverlayViewFloorAnimationDidEndCallback != null) {
            BMFPrismOverlay prismOverlay =
                BMFPrismOverlay.fromMap(call.arguments['prismOverlay']);
            this._prismOverlayViewFloorAnimationDidEndCallback!(prismOverlay);
          }
          break;
        }
      case BMFOverlayCallbackMethodId
            .kTraceOverlayAnimationUpdatePositionCallback:
        {
          if (this._traceOverlayAnimationUpdatePositionCallback != null) {
            BMFCoordinate coordinate =
                BMFCoordinate.fromMap(call.arguments['coord']);
            this._traceOverlayAnimationUpdatePositionCallback!(coordinate);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnClickedMapPoiCallback:
        {
          if (this._mapOnClickedMapPoiCallback != null) {
            BMFMapPoi poi = BMFMapPoi.fromMap(call.arguments['poi']);
            this._mapOnClickedMapPoiCallback!(poi);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnClickedMapBlankCallback:
        {
          if (this._mapOnClickedMapBlankCallback != null) {
            BMFCoordinate coordinate =
                BMFCoordinate.fromMap(call.arguments['coord']);
            this._mapOnClickedMapBlankCallback!(coordinate);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnDoubleClickCallback:
        {
          if (this._mapOnDoubleClickCallback != null) {
            BMFCoordinate coordinate =
                BMFCoordinate.fromMap(call.arguments['coord']);
            this._mapOnDoubleClickCallback!(coordinate);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnLongClickCallback:
        {
          if (this._mapOnLongClickCallback != null) {
            BMFCoordinate coordinate =
                BMFCoordinate.fromMap(call.arguments['coord']);
            this._mapOnLongClickCallback!(coordinate);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapOnForceTouchCallback:
        {
          if (this._mapOnForceTouchCallback != null) {
            BMFCoordinate coordinate =
                BMFCoordinate.fromMap(call.arguments['coord']);
            double force = call.arguments['force'] as double;
            double maximumPossibleForce =
                call.arguments['maximumPossibleForce'] as double;
            this._mapOnForceTouchCallback!(
                coordinate, force, maximumPossibleForce);
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapStatusDidChangedCallback:
        {
          if (this._mapStatusDidChangedCallback != null) {
            this._mapStatusDidChangedCallback!();
          }
          break;
        }
      case BMFMapCallbackMethodId.kMapInOrOutBaseIndoorMapCallback:
        {
          if (this._mapInOrOutBaseIndoorMapCallback != null) {
            bool flag = call.arguments['flag'];
            BMFBaseIndoorMapInfo info =
                BMFBaseIndoorMapInfo.fromMap(call.arguments['info']);
            this._mapInOrOutBaseIndoorMapCallback!(flag, info);
          }
          break;
        }
      case BMFMarkerCallbackMethodId.kMapClickedMarkerCallback:
        {
          if (this._mapClickedMarkerCallback != null) {
            BMFLog.d(BMFMarkerCallbackMethodId.kMapClickedMarkerCallback);
            BMFMarker marker = BMFMarker.fromMap(call.arguments['marker']);
            marker.methodChannel = _methodChannel;
            this._mapClickedMarkerCallback!(marker);
          }
          break;
        }
      case BMFMarkerCallbackMethodId.kMapDidSelectMarkerCallback:
        {
          if (this._mapDidSelectMarkerCallback != null) {
            BMFMarker marker = BMFMarker.fromMap(call.arguments['marker']);
            marker.methodChannel = _methodChannel;

            this._mapDidSelectMarkerCallback!(marker);
          }
          break;
        }
      case BMFMarkerCallbackMethodId.kMapDidDeselectMarkerCallback:
        {
          if (this._mapDidDeselectMarkerCallback != null) {
            BMFMarker marker = BMFMarker.fromMap(call.arguments['marker']);
            marker.methodChannel = _methodChannel;
            this._mapDidDeselectMarkerCallback!(marker);
          }
          break;
        }
      case BMFMarkerCallbackMethodId.kMapDragMarkerCallback:
        {
          if (this._mapDragMarkerCallback != null) {
            BMFMarker marker = BMFMarker.fromMap(call.arguments['marker']);
            marker.methodChannel = _methodChannel;
            BMFMarkerDragState newState =
                BMFMarkerDragState.values[call.arguments['newState'] as int];
            BMFMarkerDragState oldState =
                BMFMarkerDragState.values[call.arguments['oldState'] as int];
            this._mapDragMarkerCallback!(marker, newState, oldState);
          }
          break;
        }
      case BMFClusterMethodID.kMapClusterClickCallback:
        {
          if (this._mapClusterCallback != null) {
            BMFLog.d("cluster click", tag: 'BMFMethodChannelHandler');
            List<BMFClusterInfo> clusterInfoList = [];
            List tempList = call.arguments['clusterInfoList'] as List;
            if (tempList.length > 0) {
              for (int i = 0; i < tempList.length; i++) {
                BMFClusterInfo clusterInfo =
                    BMFClusterInfo.fromMap(tempList[i] as Map);
                clusterInfoList.add(clusterInfo);
              }
              int size = call.arguments['size'] as int;
              this._mapClusterCallback!(clusterInfoList, size);
            }
          }
          break;
        }
      case BMFClusterMethodID.kMapClusterClickItemCallback:
        {
          if (this._mapClusterItemCallback != null) {
            BMFLog.d("cluster item click", tag: 'BMFMethodChannelHandler');
            BMFClusterInfo clusterInfo =
                BMFClusterInfo.fromMap(call.arguments['clusterInfo']);
            this._mapClusterItemCallback!(clusterInfo);
          }
          break;
        }
      case BMFInfoWindowMethodId.kMapDidClickedInfoWindowMethod:
        {
          if (this._mapDidClickedInfoWindowCallback != null) {
            BMFLog.d("infoWindow click", tag: 'BMFMethodChannelHandler');
            BMFMarker marker = BMFMarker.fromMap(call.arguments['marker']);
            marker.methodChannel = _methodChannel;
            this._mapDidClickedInfoWindowCallback!(marker);
          }
          break;
        }

      case BMFMapCallbackMethodId.kMapRenderValidDataCallback:
        {
          if (this._mapRenderValidDataCallback != null) {
            bool isValid = call.arguments['isValid'];
            int errorCode = call.arguments['errorCode'];
            String errorMessage = call.arguments['errorMessage'];
            this._mapRenderValidDataCallback!(isValid, errorCode, errorMessage);
          }
          break;
        }
      case BMFHeatMapMethodId.kHeatMapFrameAnimationIndexCallbackMethod:
        {
          if (this._heatMapFrameAnimationCallback != null) {
            this._heatMapFrameAnimationCallback!(
                call.arguments['index'] as int);
          }
          break;
        }
      case BMFUserlocationMethodId.kMapUserTrackingModeChangedCallbackMethod:
        {
          if (this._userTrackingModeChangedCallback != null) {
            this._userTrackingModeChangedCallback!(
                BMFUserTrackingMode.values[call.arguments['mode'] as int]);
          }
          break;
        }
      default:
        break;
    }
  }
}

/// 地图相关回调
extension MapHandlerExtension on BMFMethodChannelHandler {
  /// 地图加载完成回调
  void setMapDidLoadCallback(BMFMapCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDidLoadCallback = block;
  }

  /// 地图渲染回调
  void setMapDidFinishedRenderCallback(BMFMapSuccessCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDidFinishRenderCallback = block;
  }

  /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
  void setMapOnDrawMapFrameCallback(BMFMapOnDrawMapFrameCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnDrawMapFrameCallback = block;
  }

  /// 地图区域即将改变时会调用此接口
  void setMapRegionWillChangeCallback(BMFMapRegionChangeCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapRegionWillChangeCallback = block;
  }

  /// 地图区域改变完成后会调用此接口
  void setMapRegionDidChangeCallback(BMFMapRegionChangeCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapRegionDidChangeCallback = block;
  }

  /// 地图区域即将改变时会调用此接口reason
  void setMapRegionWillChangeWithReasonCallback(
      BMFMapRegionChangeReasonCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapRegionWillChangeWithReasonCallback = block;
  }

  /// 地图区域改变完成后会调用此接口reason
  void setMapRegionDidChangeWithReasonCallback(
      BMFMapRegionChangeReasonCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapRegionDidChangeWithReasonCallback = block;
  }

  /// 地图状态改变完成后会调用此接口
  void setMapStatusDidChangedCallback(BMFMapCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapStatusDidChangedCallback = block;
  }

  /// 设置地图绘制出有效数据的监听
  void setMapRenderValidDataCallback(BMFMapRenderValidDataCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapRenderValidDataCallback = block;
  }

  /// 切换定位模式回调 since 3.4.0
  ///
  /// iOS独有
  void setUserTrackingModeChangedCallback(
      BMFUserTrackingModeChangedCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._userTrackingModeChangedCallback = block;
  }
}

/// 热力图动画渲染回调
extension HeatMapFrameAnimationExtension on BMFMethodChannelHandler {
  void setHeatMapFrameAnimationIndexCallback(
      BMFHeatMapFrameAnimationCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._heatMapFrameAnimationCallback = block;
  }
}

/// 地图手势相关回调
extension MapGestureHandlerExtension on BMFMethodChannelHandler {
  /// 点中底图标注后会回调此接口
  void setMapOnClickedMapPoiCallback(BMFMapOnClickedMapPoiCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnClickedMapPoiCallback = block;
  }

  /// 点中底图空白处会回调此接口
  void setMapOnClickedMapBlankCallback(BMFMapCoordinateCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnClickedMapBlankCallback = block;
  }

  /// 双击地图时会回调此接口
  void setMapOnDoubleClickCallback(BMFMapCoordinateCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnDoubleClickCallback = block;
  }

  /// 长按地图时会回调此接口
  void setMapOnLongClickCallback(BMFMapCoordinateCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnLongClickCallback = block;
  }

  /// 3DTouch 按地图时会回调此接口
  ///
  ///（仅在支持3D Touch，且fouchTouchEnabled属性为true时，会回调此接口）
  void setMapOnForceTouchCallback(BMFMapOnForceTouchCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnForceTouchCallback = block;
  }
}

/// overlay相关回调
extension OverlayHandlerExtension on BMFMethodChannelHandler {
  /// 地图点击覆盖物回调，目前只支持点中Polyline,Text时回调
  void setMapOnClickedOverlayCallback(BMFMapOnClickedOverlayCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnClickedOverlayCallback = block;
  }

  /// 设置地图点击海量点回调
  void setMapOnClickedMultiPointOverlaItemCallback(
      BMFMapOnClickedMultiPointOverlayItemCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapOnClickedMultiPointOverlayItemCallback = block;
  }

  /// 设置动态轨迹动画开始回调
  void setTraceOverlayAnimationDidStartCallback(
      BMFTraceOverlayAnimationDidStartCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._traceOverlayAnimationDidStartCallback = block;
  }

  /// 设置动态轨迹动画进度回调
  void setTraceOverlayAnimationRunningProgressCallback(
      BMFTraceOverlayAnimationRunningProgressCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._traceOverlayAnimationRunningProgressCallback = block;
  }

  /// 设置动态轨迹动画结束回调
  void setTraceOverlayAnimationDidEndCallback(
      BMFTraceOverlayAnimationDidEndCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._traceOverlayAnimationDidEndCallback = block;
  }

  /// 设置动画更新的当前位置点回调
  /// ANdroid 独有
  void setTraceOverlayAnimationUpdatePositionCallback(
      BMFTraceOverlayAnimationUpdatePositionCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._traceOverlayAnimationUpdatePositionCallback = block;
  }

  /// 楼层动画结束回调
  void setPrismOverlayViewFloorAnimationDidEndCallback(
      BMFPrismOverlayViewFloorAnimationDidEndCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._prismOverlayViewFloorAnimationDidEndCallback = block;
  }
}

/// marker相关回调
extension MarkerHangdlerExtension on BMFMethodChannelHandler {
  /// 设置marker点击回调
  void setMapClickedMarkerCallback(BMFMapMarkerCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapClickedMarkerCallback = block;
  }

  /// 设置marker选中回调
  void setMaptDidSelectMarkerCallback(BMFMapMarkerCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDidSelectMarkerCallback = block;
  }

  /// 设置marker取消回调
  void setMapDidDeselectMarkerCallback(BMFMapMarkerCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDidDeselectMarkerCallback = block;
  }

  /// 设置marker拖拽回调
  void setMapDragMarkerCallback(BMFMapDragMarkerCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDragMarkerCallback = block;
  }

  /// 设置marker的infoWindow（iOS paopaoView）点击回调
  void setMapDidClickedInfoWindowCallback(BMFMapMarkerCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapDidClickedInfoWindowCallback = block;
  }
}

/// 室内图相关回调
extension IndoorMapHandlerExtension on BMFMethodChannelHandler {
  /// 设置地图View进入/移出室内图回调
  void setMapInOrOutBaseIndoorMapCallback(
      BMFMapInOrOutBaseIndoorMapCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapInOrOutBaseIndoorMapCallback = block;
  }
}

extension ClusterHandlerExtension on BMFMethodChannelHandler {
  /// 设置Cluster聚合点击回调
  void setClusterClickCallback(BMFMapClusterCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapClusterCallback = block;
  }

  /// 设置Cluster聚合点击回调
  void setClusterItemClickCallback(BMFMapClusterClickItemCallback block) {
    ArgumentError.checkNotNull(block, "block");
    this._mapClusterItemCallback = block;
  }
}
