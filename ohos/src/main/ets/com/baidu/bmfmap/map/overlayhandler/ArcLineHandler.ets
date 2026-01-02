import { Arc, OverlayEvent } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { ArcLineMethod, OverlayMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';
import { LatLng } from '@bdmap/base';
import { OverlayType } from './OverlayType';
import NativeDataConvert from '../../util/NativeDataConvert';


export default class ArcLineHandler extends OverlayBaseHandler<Arc> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Arc): void {
    let resultMap: Map<string, object | number> = new Map
    let map = NativeDataConvert.arcLineToMap(overlay)
    if (map) {
      resultMap.set('overlayType', OverlayType.ArcLine.valueOf())
      resultMap.set('overlay', map)
    }
    this.invoke(OverlayMethod.OverlayClickedCallback, resultMap)
  }

  handleMethod(): void {
    switch (this.method) {
      case ArcLineMethod.AddArcLineMethod:
        this.addArcLine()
        break
      case ArcLineMethod.UpdateArcLineMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  addArcLine() {
    if (this.mapController && this.call) {
      let id: string = this.call.argument('id')
      let posArrayObj: object = this.call.argument('coordinates')
      let startPoint: LatLng | undefined
      let middlePoint: LatLng | undefined
      let endPoint: LatLng | undefined
      if (id != null && !this.overlayMap.has(id) && posArrayObj instanceof Array) {
        let posArray = posArrayObj as Array<Map<string, object>>
        posArray.forEach(((itemMap, index) => {
          if (index == 0) {
            startPoint = FlutterDataConvert.mapToLatLng(itemMap)
          } else if (index == 1) {
            middlePoint = FlutterDataConvert.mapToLatLng(itemMap)
          } else if (index == 2) {
            endPoint = FlutterDataConvert.mapToLatLng(itemMap)
          }
        }))
        if (startPoint && middlePoint && endPoint) {
          let arcLine: Arc = new Arc({
            startPoint: startPoint,
            middlePoint: middlePoint,
            endPoint: endPoint
          })
          if (isNumber(this.call.argument('width'))) {
            arcLine.setWidth(Number(this.call.argument('width')))
          }

          let color: object = this.call.argument('color')
          if (isString(color)) {
            arcLine.setColor(checkColor(color))
          }

          if (isBoolean(this.call.argument('clickable'))) {
            arcLine.setClickable(Boolean(this.call.argument('clickable')))
          }

          if (isNumber(this.call.argument('zIndex'))) {
            arcLine.setZIndex(Number(this.call.argument('zIndex')))
          }

          if (isBoolean(this.call.argument('visible'))) {
            arcLine.setVisible(Boolean(this.call.argument('visible')))
          }

          arcLine.addEventListener(OverlayEvent.CLICK, this.clickCallback)
          this.setExtraInfo(arcLine, 'id', id)
          this.setExtraInfo(arcLine, 'color', color)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(arcLine, 'customMap', customInfo)
          }
          this.mapController.addOverlay(arcLine);
          this.overlayMap.set(id, arcLine)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  handleUpdate(member: string, value: object, overlay: Arc): void {
    switch (member) {
      case 'clickable':
        if (isBoolean(value)) {
          overlay.setVisible(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'color':
        if (isString(value)) {
          this.setExtraInfo(overlay, 'color', value)
          overlay.setColor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'width':
        if (isNumber(value)) {
          overlay.setWidth(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'coordinates':
        if (value instanceof Array) {
          let startPoint: LatLng | undefined
          let middlePoint: LatLng | undefined
          let endPoint: LatLng | undefined
          let posArray = value as Array<Map<string, object>>
          posArray.forEach(((itemMap, index) => {
            if (index == 0) {
              startPoint = FlutterDataConvert.mapToLatLng(itemMap)
            } else if (index == 1) {
              middlePoint = FlutterDataConvert.mapToLatLng(itemMap)
            } else if (index == 2) {
              endPoint = FlutterDataConvert.mapToLatLng(itemMap)
            }
          }))

          if (startPoint && middlePoint && endPoint) {
            overlay.setPoints(startPoint, middlePoint, endPoint)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }
}
