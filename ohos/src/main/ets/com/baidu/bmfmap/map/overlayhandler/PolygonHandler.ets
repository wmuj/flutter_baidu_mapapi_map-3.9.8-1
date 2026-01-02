import { LatLng } from '@bdmap/base';
import { OverlayEvent, Polygon, Stroke, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import NativeDataConvert from '../../util/NativeDataConvert';
import { OverlayMethod, PolygonMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import { OverlayType } from './OverlayType';
import { List } from '@kit.ArkTS';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';


export default class PolygonHandler extends OverlayBaseHandler<Polygon> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Polygon): void {
    let resultMap: Map<string, object | number> = new Map
    resultMap.set('overlayType', OverlayType.Polygon.valueOf())
    let map = NativeDataConvert.polygonToMap(overlay)
    if (map) {
      resultMap.set('overlay', map)
    }
    this.invoke(OverlayMethod.OverlayClickedCallback, resultMap)
  }

  handleMethod(): void {
    switch (this.method) {
      case PolygonMethod.AddPolygonMethod:
        this.addPolygon()
        break
      case PolygonMethod.UpdatePolygonMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  addPolygon() {
    if (this.mapController && this.call) {
      let points: Array<LatLng> = new Array
      let id: string = this.call.argument('id')
      let coordinatesArray: Array<Map<string, number>> = this.call.argument('coordinates')
      let encodedGeoPoints: object = this.call.argument('encodedGeoPoints')
      if (id && !this.overlayMap.has(id)) {
        let width: number = this.call.argument('width')
        let strokeColor: object = this.call.argument('strokeColor')
        let fillColor: object = this.call.argument('fillColor')
        let lineDashType: number = this.call.argument('lineDashType')
        let polygon: Polygon = new Polygon({
          points: '',
          fillcolor: checkColor(fillColor),
          stroke: new Stroke({
            strokeWidth: width,
            color: checkColor(strokeColor),
            strokeStyle: this.getLineDashType(lineDashType)
          })
        })
        if (coordinatesArray instanceof Array) {
          for (let index = 0; index < coordinatesArray.length; index++) {
            const mapItem: Map<string, number> = coordinatesArray[index];
            mapItem.forEach(() => {
              if (mapItem.get('latitude') && mapItem.get('longitude')) {
                points[index] = new LatLng(Number(mapItem.get('latitude')), Number(mapItem.get('longitude')))
              }
            })
          }
          polygon.points(points)
        } else if (isString(encodedGeoPoints)) {
          polygon.points(String(encodedGeoPoints))
        } else {
          this.fail()
          return
        }
        let hollowArray = this.call.argument('hollowShapes') as Array<Map<string, object>>
        if (hollowArray instanceof Array) {
          hollowArray.forEach((hollowMap) => {
            if (hollowMap) {
              let coordinatesObj = hollowMap.get('coordinates')
              if (coordinatesObj instanceof Array) {
                let coordinatesArray = coordinatesObj as Array<Map<string, object>>
                let points = FlutterDataConvert.listToLatLng(coordinatesArray)
                if (points) {
                  polygon.setHolePoints(points)
                }
              }
            }
          })
        }
        if (isBoolean(this.call.argument('clickable'))) {
          polygon.setClickable(Boolean(this.call.argument('clickable')))
        }
        if (isBoolean(this.call.argument('visible'))) {
          polygon.setVisible(Boolean(this.call.argument('visible')))
        }
        if (isNumber(this.call.argument('zIndex'))) {
          polygon.setZIndex(Number(this.call.argument('zIndex')))
        }
        polygon.addEventListener(OverlayEvent.CLICK, this.clickCallback)

        this.setExtraInfo(polygon, 'id', id)
        this.setExtraInfo(polygon, 'strokeColor', strokeColor)
        this.setExtraInfo(polygon, 'fillColor', fillColor)
        let customInfo: object = this.call.argument('customMap')
        if (customInfo) {
          this.setExtraInfo(polygon, 'customMap', customInfo)
        }
        this.mapController.addOverlay(polygon);
        this.overlayMap.set(id, polygon)
        this.success()
        return
      }
    }
    this.fail()
  }

  handleUpdate(member: string, value: object, overlay: Polygon): void {
    switch (member) {
      case 'width':
        if (isNumber(value)) {
          overlay.getStroke().setStrokeWidth(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineDashType':
        if (isNumber(value)) {
          overlay.getStroke().setStrokeStyle(this.getLineDashType(Number(value)))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'strokeColor':
        if (isString(value)) {
          overlay.getStroke().setColor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'fillColor':
        if (isString(value)) {
          overlay.setFillcolor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'coordinates':
        let list = value as List<Map<string, object>>
        if (list) {
          let points = FlutterDataConvert.listToLatLng(list)
          if (points) {
            overlay.setPoints(points)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'hollowShapes':
        let hollowArray = value as Array<Map<string, object>>
        if (hollowArray instanceof Array) {
          hollowArray.forEach((hollowMap) => {
            if (hollowMap) {
              let coordinatesObj = hollowMap.get('coordinates')
              if (coordinatesObj instanceof Array) {
                let coordinatesArray = coordinatesObj as Array<Map<string, object>>
                let points = FlutterDataConvert.listToLatLng(coordinatesArray)
                if (points) {
                  overlay.setHolePoints(points)
                  overlay.update()
                  this.success()
                  return
                }
              }
            }
          })
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }

  getLineDashType(lineDashType: number | undefined): SysEnum.StrokeStyle {
    if (lineDashType) {
      if (lineDashType == 1) {
        return SysEnum.StrokeStyle.SQUARE
      } else {
        return SysEnum.StrokeStyle.CIRCLE
      }
    } else {
      return SysEnum.StrokeStyle.REAL
    }
  }
}
