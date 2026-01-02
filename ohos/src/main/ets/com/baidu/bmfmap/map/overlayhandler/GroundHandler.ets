import { Ground, ImageEntity, OverlayEvent } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { GroundMethod, OverlayMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';
import { OverlayType } from './OverlayType';
import NativeDataConvert from '../../util/NativeDataConvert';


export default class GroundHandler extends OverlayBaseHandler<Ground> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Ground): void {
    let resultMap: Map<string, object | number> = new Map
    let map = NativeDataConvert.groundToMap(overlay)
    if (map) {
      resultMap.set('overlayType', OverlayType.Ground.valueOf())
      resultMap.set('overlay', map)
    }
    this.invoke(OverlayMethod.OverlayClickedCallback, resultMap)
  }

  handleMethod(): void {
    switch (this.method) {
      case GroundMethod.AddGroundMethod:
        this.addGround()
        break
      case GroundMethod.UpdateGroundMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  addGround() {
    if (this.mapController && this.call) {
      let id: string = this.call.argument('id')
      let image: object = this.call.argument('image')
      let bounds = FlutterDataConvert.mapToBounds(this.call.argument('bounds'))
      if (id != null && !this.overlayMap.has(id) && bounds && isString(image)) {
        let ground: Ground = new Ground({
          image: new ImageEntity('rawfile://flutter_assets/' + String(image)),
          bounds: [bounds.getSouthWest(), bounds.getNorthEast()]
        });
        if (isNumber(this.call.argument('anchorX')) && isNumber(this.call.argument('anchorY'))) {
          ground.setAnchor(Number(this.call.argument('anchorX')), Number(this.call.argument('anchorY')))
        }
        if (isNumber(this.call.argument('transparency'))) {
          ground.setTransparency(Number(this.call.argument('transparency')))
        }
        if (isBoolean(this.call.argument('visible'))) {
          ground.setVisible(Boolean(this.call.argument('visible')))
        }
        if (isNumber(this.call.argument('zIndex'))) {
          ground.setZIndex(Number(this.call.argument('zIndex')))
        }
        if (isNumber(this.call.argument('transparency'))) {
          ground.setTransparency(Number(this.call.argument('transparency')))
        }
        if (isBoolean(this.call.argument('clickable'))) {
          ground.setClickable(Boolean(this.call.argument('clickable')))
        }
        ground.addEventListener(OverlayEvent.CLICK, this.clickCallback)

        this.setExtraInfo(ground, 'id', id)
        this.setExtraInfo(ground, 'image', image)
        let customInfo: object = this.call.argument('customMap')
        if (customInfo) {
          this.setExtraInfo(ground, 'customMap', customInfo)
        }
        this.mapController.addOverlay(ground);
        this.overlayMap.set(id, ground)
        this.success()
        return
      }
    }
    this.fail()
  }

  handleUpdate(member: string, value: object, overlay: Ground): void {
    switch (member) {
      case 'visible':
        if (isBoolean(value)) {
          overlay.setVisible(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'anchorX':
        if (isNumber(value)) {
          overlay.setAnchor(Number(value), overlay.getAnchor().anchory)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'anchorY':
        if (isNumber(value)) {
          overlay.setAnchor(overlay.getAnchor().anchorx, Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'bounds':
        if (value instanceof Map) {
          let bounds = FlutterDataConvert.mapToBounds(value)
          if (bounds) {
            overlay.setBound(bounds.getSouthWest(), bounds.getNorthEast())
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'image':
        if (isString(value)) {
          this.setExtraInfo(overlay, 'image', String(value))
          overlay.setImage(new ImageEntity('rawfile://flutter_assets/' + String(value)))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'transparency':
        if (isNumber(value)) {
          overlay.setTransparency(Number(value))
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
}
