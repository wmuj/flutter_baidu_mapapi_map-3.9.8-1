import { LatLng } from '@bdmap/base';
import { Circle, OverlayEvent, Stroke, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import NativeDataConvert from '../../util/NativeDataConvert';
import { CircleMethod, OverlayMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import { OverlayType } from './OverlayType';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';


export default class CircleHandler extends OverlayBaseHandler<Circle> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Circle): void {
    let resultMap: Map<string, object | number> = new Map
    resultMap.set('overlayType', OverlayType.Circle.valueOf())
    let map = NativeDataConvert.circleToMap(overlay)
    if (map) {
      resultMap.set('overlay', map)
    }
    this.invoke(OverlayMethod.OverlayClickedCallback, resultMap)
  }

  handleMethod(): void {
    switch (this.method) {
      case CircleMethod.AddCircleMethod:
        this.addCircle()
        break
      case CircleMethod.ADD_GRADIENT_CIRCLE_METHOD:
        this.addCircle(true)
        break
      case CircleMethod.UpdateCircleMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  handleUpdate(member: string, value: object, overlay: Circle): void {
    switch (member) {
      case 'center':
        let centerMap = value as Map<string, object>
        let newCenter: LatLng | undefined = FlutterDataConvert.mapToLatLng(centerMap)
        if (newCenter) {
          overlay.setCenter(newCenter)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'radius':
        if (isNumber(value)) {
          overlay.setRadius(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'width':
        if (isNumber(value)) {
          overlay.getStroke().setStrokeWidth(Number(value))
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
          overlay.fillcolor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineDashType':
        if (isNumber(value)) {
          let lineDashType = Number(value)
          if (lineDashType == 0) {
            overlay.getStroke().strokeStyle = SysEnum.StrokeStyle.REAL
          } else if (lineDashType == 1) {
            overlay.getStroke().strokeStyle = SysEnum.StrokeStyle.SQUARE
          } else {
            overlay.getStroke().strokeStyle = SysEnum.StrokeStyle.CIRCLE
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'dottedLine':
        if (isBoolean(value)) {
          let newDottedLine = Boolean(value)
          if (newDottedLine) {
            overlay.getStroke().strokeStyle = SysEnum.StrokeStyle.SQUARE
          } else {
            overlay.getStroke().strokeStyle = SysEnum.StrokeStyle.REAL
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'clickable':
        if (isBoolean(value)) {
          overlay.setClickable(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }

  addCircle(isGradient?: boolean) {
    if (this.mapController && this.call) {
      let id: string = this.call.argument('id')
      let center: LatLng | undefined
      let centerMap: Map<string, object> = this.call.argument('center')
      if (centerMap) {
        center = FlutterDataConvert.mapToLatLng(centerMap)
      }
      let radius = this.call.argument('radius') as Number
      if (id && !this.overlayMap.has(id) && center && isNumber(radius)) {
        let width: number = this.call.argument('width')
        let strokeColor: object = this.call.argument('strokeColor')
        let fillColor: object = this.call.argument('fillColor')
        let dottedLine = this.call.argument('dottedLine') as Boolean
        let lineDashType: object = this.call.argument('lineDashType')
        let strokeStyle = SysEnum.StrokeStyle.REAL
        if (isBoolean(dottedLine) && Boolean(dottedLine)) {
          if (isNumber(lineDashType)) {
            strokeStyle = Number(lineDashType) == 1 ? SysEnum.StrokeStyle.SQUARE : SysEnum.StrokeStyle.CIRCLE
          }
        }

        let circle: Circle = new Circle({
          center: center,
          radius: Number(radius),
          fillcolor: checkColor(fillColor),
          stroke: new Stroke({
            strokeWidth: width,
            color: checkColor(strokeColor),
            strokeStyle: strokeStyle
          })
        })

        if (isBoolean(this.call.argument('clickable'))) {
          circle.setClickable(Boolean(this.call.argument('clickable')))
        }
        if (isBoolean(this.call.argument('visible'))) {
          circle.setVisible(Boolean(this.call.argument('visible')))
        }
        if (isNumber(this.call.argument('zIndex'))) {
          circle.setZIndex(Number(this.call.argument('zIndex')))
        }
        circle.addEventListener(OverlayEvent.CLICK, this.clickCallback)
        if (isGradient) {
          let colorWeight = this.call.argument('colorWeight') as Number
          if (isNumber(colorWeight)) {
            circle.setGradientColorWeight(Number(colorWeight))
          }

          let radiusWeight: number = this.call.argument('radiusWeight')
          if (radiusWeight) {
            circle.setGradientRadiusWeight(radiusWeight)
          }

          let centerColor: object = this.call.argument('centerColor')
          let sideColor: object = this.call.argument('sideColor')
          if (centerColor && sideColor) {
            circle.setGradientColors([checkColor(centerColor), checkColor(sideColor)])
            circle.setIsGradientCircle(true)
          }
        }

        this.setExtraInfo(circle, 'id', id)
        this.setExtraInfo(circle, 'strokeColor', strokeColor)
        this.setExtraInfo(circle, 'fillColor', fillColor)
        let customInfo: object = this.call.argument('customMap')
        if (customInfo) {
          this.setExtraInfo(circle, 'customMap', customInfo)
        }
        this.mapController.addOverlay(circle);
        this.overlayMap.set(id, circle)
        this.success()
        return
      }
    }
    this.fail()
  }
}
