import { BMFMapController } from '../../BMFMapController';
import { AnyValue } from '../../util/Constants';
import { isBoolean, isString } from '../../util/FlutterDataConvert';
import { IndoorMapMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';

export default class IndoorMapHandler extends MapBaseHandler {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    if (!this.mapController || !this.call) {
      this.fail()
      return
    }
    switch (this.method) {
      case IndoorMapMethod.ShowBaseIndoorMapMethod:
        if (isBoolean(this.call.argument('show'))) {
          this.mapController.showBaseIndoorMap(Boolean(this.call.argument('show')))
          this.success()
        } else {
          this.fail()
        }
        break
      case IndoorMapMethod.ShowBaseIndoorMapPoiMethod:
        if (isBoolean(this.call.argument('showIndoorPoi'))) {
          this.mapController.mapOptions.showMapIndoorPoi = (Boolean(this.call.argument('showIndoorPoi')))
          this.success()
        } else {
          this.fail()
        }
        break
      case IndoorMapMethod.SwitchBaseIndoorMapFloorMethod:
        let floorObj: object = this.call.argument('floorId')
        let indoorObj: object = this.call.argument('indoorId')
        let resultMap = new Map<string, AnyValue>()
        if (isString(floorObj) && isString(indoorObj)) {
          this.mapController.switchIndoorFloor(String(floorObj), String(indoorObj))
          this.result?.success(resultMap.set('result', 0))
        } else {
          this.result?.success(resultMap.set('result', 1))
        }
        break
      case IndoorMapMethod.GetFocusedBaseIndoorMapInfoMethod:
        let indoorFloorInfo = this.mapController.getIndoorInfo()
        if (indoorFloorInfo) {
          let indoorMap = new Map<string, AnyValue>()
          indoorMap.set('strFloor', indoorFloorInfo.curfloor)
          indoorMap.set('strID', indoorFloorInfo.uid)
          indoorMap.set('listStrFloors', indoorFloorInfo.floorlist)
          this.result?.success(indoorMap)
        } else {
          this.fail()
        }
        break
      default:
        this.fail()
        break
    }
  }
}