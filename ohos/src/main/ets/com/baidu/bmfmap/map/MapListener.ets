import { EventBundle, MapController, MapEvent, SysEnum, TMapViewEvent } from '@bdmap/map';
import { MethodChannel } from '@ohos/flutter_ohos';
import { AnyValue } from '../util/Constants';
import NativeDataConvert from '../util/NativeDataConvert';
import { MapStateMethod } from './MethodConst';

export default class MapListener {
  private sMapController: MapController | null = null
  private sChannel: MethodChannel | null = null
  //默认-1.未知
  private sReason: SysEnum.MapStatusChangeReason = -1
  private mapChangeStartListener = (_event: TMapViewEvent, reason?: SysEnum.MapStatusChangeReason) => {
    if (reason) {
      //一定要减1，鸿蒙侧是从1开始的，flutter侧是从0开始的
      this.sReason = reason - 1
    }
    this.callMapStatusChangeStart()
    this.callMapStatusChangeStartWithReason()
  }
  private mapChangeListener = () => {
    this.callMapStatusChange()
  }

  private callMapStatusChange = () =>{
    if (this.sMapController) {
      let map = NativeDataConvert.mapStatusToMap(this.sMapController.mapStatus)
      if (map) {
        this.sChannel?.invokeMethod(MapStateMethod.MapRegionDidChangeCallback, map)
      }
    }
  }

  private mapChangeFinishListener = () => {
    this.callMapStatusChangeFinish()
    this.callMapStatusChangeFinishWithReason()
  }
  private mapRenderFinishListener = () => {
    this.callMapRenderFinish()
  }
  private mapClickListener = (event: TMapViewEvent) => {
    this.callMapOnClick(event)
  }
  private mapDoubleClickListener = (event: TMapViewEvent) => {
    this.callMapOnDoubleClick(event)
  }
  private mapLongPressListener = (event: TMapViewEvent) => {
    this.callMapOnLongPress(event)
  }
  private indoorStatusChangeListener = (event: TMapViewEvent) => {
    this.callIndoorStatusChange(event)
  }

  constructor(mapController: MapController | null, channel: MethodChannel) {
    this.sMapController = mapController;
    this.sChannel = channel
    this.init()
  }

  private init() {
    this.callMapLoadFinish()
    if (!this.sMapController) {
      return
    }
    // 地图状态监听事件
    this.sMapController.addEventListener(MapEvent.MAPSTATUSCHANGESTART, this.mapChangeStartListener);
    this.sMapController.addEventListener(MapEvent.MAPSTATUSCHANGE, this.mapChangeListener);
    this.sMapController.addEventListener(MapEvent.MAPSTATUSCHANGEFINISH, this.mapChangeFinishListener);
    this.sMapController.addEventListener(MapEvent.MAPRENDERFINISH, this.mapRenderFinishListener)
    this.sMapController.addEventListener(MapEvent.CLICK, this.mapClickListener);
    this.sMapController.addEventListener(MapEvent.DOUBLECLICK, this.mapDoubleClickListener);
    this.sMapController.addEventListener(MapEvent.LONGPRESS, this.mapLongPressListener)
    this.sMapController.addEventListener(MapEvent.INDOORSTATUSCHANGE, this.indoorStatusChangeListener)
  }

  release() {
    if (this.sMapController) {
      this.sMapController.removeEventListener(MapEvent.MAPSTATUSCHANGESTART, this.mapChangeStartListener)
      this.sMapController.removeEventListener(MapEvent.MAPSTATUSCHANGE, this.mapChangeListener);
      this.sMapController.removeEventListener(MapEvent.MAPSTATUSCHANGEFINISH, this.mapChangeFinishListener);
      this.sMapController.removeEventListener(MapEvent.MAPRENDERFINISH, this.mapRenderFinishListener);
      this.sMapController.removeEventListener(MapEvent.CLICK, this.mapClickListener);
      this.sMapController.removeEventListener(MapEvent.DOUBLECLICK, this.mapDoubleClickListener);
      this.sMapController.removeEventListener(MapEvent.LONGPRESS, this.mapLongPressListener)
      this.sMapController.removeEventListener(MapEvent.INDOORSTATUSCHANGE, this.indoorStatusChangeListener)
    }
    this.sMapController = null
    this.sChannel = null
  }

  private callMapLoadFinish() {
    this.sChannel?.invokeMethod(MapStateMethod.MapDidLoadCallback, '');
  }

  private callMapRenderFinish() {
    this.sChannel?.invokeMethod(MapStateMethod.MapDidFinishRenderCallback, new Map().set('success', true));
  }

  private callMapStatusChangeStart() {
    if (this.sMapController) {
      let map = NativeDataConvert.mapStatusToMap(this.sMapController.mapStatus)
      if (map) {
        this.sChannel?.invokeMethod(MapStateMethod.MapRegionWillChangeCallback, map)
      }
    }
  }

  private callMapStatusChangeStartWithReason() {
    if (this.sMapController) {
      let map = NativeDataConvert.mapStatusToMap(this.sMapController.mapStatus)
      if (map) {
        map.set('reason', this.sReason)
        this.sChannel?.invokeMethod(MapStateMethod.MapRegionWillChangeWithReasonCallback, map)
      }
    }
  }

  private callMapStatusChangeFinish() {
    if (this.sMapController) {
      let map = NativeDataConvert.mapStatusToMap(this.sMapController.mapStatus)
      if (map) {
        this.sChannel?.invokeMethod(MapStateMethod.MapStatusDidChangedCallback, map)
      }
    }
  }

  private callMapStatusChangeFinishWithReason() {
    if (this.sMapController) {
      let map = NativeDataConvert.mapStatusToMap(this.sMapController.mapStatus)
      if (map) {
        map.set('reason', this.sReason)
        this.sChannel?.invokeMethod(MapStateMethod.MapRegionDidChangeWithReasonCallback, map)
      }
    }
  }

  private callMapOnClick(event: TMapViewEvent) {
    event = event as EventBundle
    let map = NativeDataConvert.latLngToMap(event.geo, true)
    if (map) {
      this.sChannel?.invokeMethod(MapStateMethod.MapOnClickedMapBlankCallback, map)
    }
  }

  private callMapOnDoubleClick(event: TMapViewEvent) {
    event = event as EventBundle
    let map = NativeDataConvert.latLngToMap(event.geo, true)
    if (map) {
      this.sChannel?.invokeMethod(MapStateMethod.MapOnDoubleClickCallback, map)
    }
  }

  private callMapOnLongPress(event: TMapViewEvent) {
    event = event as EventBundle
    let map = NativeDataConvert.latLngToMap(event.geo, true)
    if (map) {
      this.sChannel?.invokeMethod(MapStateMethod.MapOnLongClickCallback, map)
    }
  }

  private callIndoorStatusChange(event: TMapViewEvent) {
    if (typeof event == 'boolean') {
      let status = event as boolean
      let resultMap = new Map<string, AnyValue>()
      if (status) {
        let indoorFloorInfo = this.sMapController?.getIndoorInfo()
        if (indoorFloorInfo) {
          let indoorMap = new Map<string, AnyValue>()
          indoorMap.set('strFloor', indoorFloorInfo.curfloor)
          indoorMap.set('strID', indoorFloorInfo.uid)
          indoorMap.set('listStrFloors', indoorFloorInfo.floorlist)
          resultMap.set('info', indoorMap)
        }
      }
      resultMap.set('flag', status)
      this.sChannel?.invokeMethod(MapStateMethod.MapInOrOutBaseIndoorMapCallback, resultMap)
    }
  }
}