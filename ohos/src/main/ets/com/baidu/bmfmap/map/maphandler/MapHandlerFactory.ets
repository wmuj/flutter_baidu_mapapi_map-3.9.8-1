import { MethodCall, MethodResult } from '@ohos/flutter_ohos';
import { BMFMapController } from '../../BMFMapController';
import { MapHandlerType } from '../HandlerTypeConst';
import MapBaseHandler from './MapBaseHandler';
import MapCustomHandler from './MapCustomHandler';
import { common } from '@kit.AbilityKit';
import {
  CustomMapMethod,
  HeatMapMethod,
  IndoorMapMethod,
  LocationLayerMethod,
  MapGetPropertyMethod,
  MapStateMethod,
  ParticleMethod,
  ProjectionMethod,
  TileMapMethod
} from '../MethodConst';
import MapUpdateHandler from './MapUpdateHandler';
import ProjectionHandler from './ProjectionHandler';
import MapStateHandler from './MapStateHandler';
import LocationLayerHandler from './LocationLayerHandler';
import MapParticleHandler from './MapParticleHandler';
import IndoorMapHandler from './IndoorMapHandler';
import HeatMapHandler from './HeatMapHandler';
import TileMapHandler from './TileMapHandler';


export class MapHandlerFactory {
  private sHandlerMap: Map<number, MapBaseHandler>

  constructor(controller: BMFMapController) {
    this.sHandlerMap = new Map

    this.sHandlerMap.set(MapHandlerType.CUSTOM_MAP, new MapCustomHandler(controller))
    this.sHandlerMap.set(MapHandlerType.MAP_STATE, new MapStateHandler(controller))
    this.sHandlerMap.set(MapHandlerType.INDOOR_MAP, new IndoorMapHandler(controller))
    this.sHandlerMap.set(MapHandlerType.PROJECTION, new ProjectionHandler(controller))
    this.sHandlerMap.set(MapHandlerType.MAP_UPDATE, new MapUpdateHandler(controller))
    this.sHandlerMap.set(MapHandlerType.HEAT_MAP, new HeatMapHandler(controller))
    this.sHandlerMap.set(MapHandlerType.TILE_MAP, new TileMapHandler(controller))
    this.sHandlerMap.set(MapHandlerType.LOCATION_LAYER, new LocationLayerHandler(controller))
    this.sHandlerMap.set(MapHandlerType.PARTICLE, new MapParticleHandler(controller))

  }

  /**
   *  将消息分发给对应的功能handler
   */
  dispatchMethodHandler(context: common.Context, call: MethodCall, result: MethodResult): boolean {
    let method: string = call.method
    let handler: MapBaseHandler | null = null
    switch (method) {
      case MapStateMethod.MapZoomInMethod:
      case MapStateMethod.MapZoomOutMethod:
      case MapStateMethod.MapSetZoomToMethod:
      case MapStateMethod.MapSetCenterCoordinateMethod:
      case MapStateMethod.MapSetCenterZoomMethod:
      case MapStateMethod.MapSetMapStatusMethod:
      case MapStateMethod.MapGetMapStatusMethod:
      case MapStateMethod.MapSetVisibleMapBoundsMethod:
      case MapStateMethod.MapSetVisibleMapBoundsWithPaddingMethod:
      case MapStateMethod.MAP_REFRESH:
      case MapGetPropertyMethod.GetMapTypeMethod:
      case MapGetPropertyMethod.GetMapFontSizeLevelMethod:
      case MapGetPropertyMethod.GetMapLanguageTypeMethod:
      case MapGetPropertyMethod.GetZoomLevelMethod:
      case MapGetPropertyMethod.GetMinZoomLevelMethod:
      case MapGetPropertyMethod.GetMaxZoomLevelMethod:
      case MapGetPropertyMethod.GetRotationMethod:
      case MapGetPropertyMethod.GetOverlookingMethod:
      case MapGetPropertyMethod.GetBuildingsEnabledMethod:
      case MapGetPropertyMethod.GetTrafficEnabledMethod:
      case MapGetPropertyMethod.GetBaiduHeatMapEnabledMethod:
      case MapGetPropertyMethod.GetGesturesEnabledMethod:
      case MapGetPropertyMethod.GetZoomEnabledMethod:
      case MapGetPropertyMethod.GetScrollEnabledMethod:
      case MapGetPropertyMethod.GetRotateEnabledMethod:
      case MapGetPropertyMethod.GetOverlookEnabledMethod:
      case MapGetPropertyMethod.GetMapScaleBarPositionMethod:
      case MapGetPropertyMethod.GetLogoPositionMethod:
      case MapGetPropertyMethod.GetVisibleMapBoundsMethod:
      case MapGetPropertyMethod.GetBaseIndoorMapEnabledMethod:
      case MapGetPropertyMethod.GetShowIndoorMapPoiMethod:
      case MapGetPropertyMethod.GetShowOperateLayerMethod:
        handler = this.sHandlerMap.get(MapHandlerType.MAP_UPDATE) as MapBaseHandler
        break
      case MapStateMethod.MAP_COPYRIGHT_INFO:
      case MapStateMethod.MAP_MAPPING_QUALIFICATION:
      case MapStateMethod.MAP_APPROVAL_NUMBER:
      case MapStateMethod.WITCH_LAYER_ORDER:
      case MapStateMethod.MapOptionUpdateMethod:
      case MapStateMethod.MapTakeSnapshotMethod:
      case MapStateMethod.MapTakeSnapshotWithRectMethod:
        handler = this.sHandlerMap.get(MapHandlerType.MAP_STATE) as MapBaseHandler
        break
      case ProjectionMethod.FromScreenLocation:
      case ProjectionMethod.ToScreenLocation:
      case ProjectionMethod.ScreenPointFromMapPoint3Dimensional:
        handler = this.sHandlerMap.get(MapHandlerType.PROJECTION) as MapBaseHandler
        break
      case CustomMapMethod.MapSetCustomMapStyleEnableMethod:
      case CustomMapMethod.MapSetCustomMapStylePathMethod:
      case CustomMapMethod.MapSetCustomMapStyleWithOptionMethod:
        handler = this.sHandlerMap.get(MapHandlerType.CUSTOM_MAP) as MapBaseHandler
        break
      case IndoorMapMethod.ShowBaseIndoorMapMethod:
      case IndoorMapMethod.ShowBaseIndoorMapPoiMethod:
      case IndoorMapMethod.SwitchBaseIndoorMapFloorMethod:
      case IndoorMapMethod.GetFocusedBaseIndoorMapInfoMethod:
        handler = this.sHandlerMap.get(MapHandlerType.INDOOR_MAP) as MapBaseHandler
        break
      case LocationLayerMethod.ShowUserLocationMethod:
      case LocationLayerMethod.UpdateLocationDataMethod:
      case LocationLayerMethod.UpdateLocationDisplayParamMethod:
      case LocationLayerMethod.UserTrackingModeMethod:
        handler = this.sHandlerMap.get(MapHandlerType.LOCATION_LAYER) as MapBaseHandler
        break
      case ParticleMethod.ShowMapParticleMethod:
      case ParticleMethod.CloseMapParticleMethod:
      case ParticleMethod.CustomMapParticleMethod:
        handler = this.sHandlerMap.get(MapHandlerType.PARTICLE) as MapBaseHandler
        break
      case HeatMapMethod.AddHeatMapMethod:
      case HeatMapMethod.UpdateHeatmapMethod:
      case HeatMapMethod.RemoveHeatMapMethod:
      case HeatMapMethod.ShowHeatMapMethod:
      case HeatMapMethod.StartHeatFrameAnimationMethod:
      case HeatMapMethod.StopHeatFrameAnimationMethod:
      case HeatMapMethod.SetHeatFrameAnimationIndexMethod:
      case HeatMapMethod.HeatMapFrameAnimationIndexCallbackMethod:
        handler = this.sHandlerMap.get(MapHandlerType.HEAT_MAP) as MapBaseHandler
        break
      case TileMapMethod.AddTileMapMethod:
      case TileMapMethod.RemoveTileMapMethod:
        handler = this.sHandlerMap.get(MapHandlerType.TILE_MAP) as MapBaseHandler
        break
      default:
        return false

    }

    if (handler) {
      handler.handlerMethodCallResult(context, call, result)
      return true
    }
    return false
  }

  release() {
    if (this.sHandlerMap) {
      this.sHandlerMap.forEach((handler) => {
        if (handler) {
          handler.clean()
        }
      })
      this.sHandlerMap.clear()
    }
  }
}
