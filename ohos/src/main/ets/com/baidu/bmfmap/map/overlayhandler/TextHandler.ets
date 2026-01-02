import { Label, OverlayEvent } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { TextMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';


export default class TextHandler extends OverlayBaseHandler<Label> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Label): void {

  }

  handleMethod(): void {
    switch (this.method) {
      case TextMethod.AddTextMethod:
        this.addLabel()
        break
      case TextMethod.UpdateTextMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  addLabel() {
    if (this.mapController && this.call) {
      let id: string = this.call.argument('id')
      let text: string = this.call.argument('text')
      let pos = FlutterDataConvert.mapToLatLng(this.call.argument('position'))
      if (id != null && !this.overlayMap.has(id) && pos && text != null) {
        let label: Label = new Label()
        label.setText(text)
        label.setPosition(pos)
        if (isNumber(this.call.argument('fontSize'))) {
          label.setFontSize(Number(this.call.argument('fontSize')))
        }
        if (isString(this.call.argument('bgColor'))) {
          label.bgcolor(checkColor(this.call.argument('bgColor')))
        }
        if (isString(this.call.argument('fontColor'))) {
          label.setFontColor(checkColor(this.call.argument('fontColor')))
        }
        if (isBoolean(this.call.argument('visible'))) {
          label.setVisible(Boolean(this.call.argument('visible')))
        }
        if (isNumber(this.call.argument('zIndex'))) {
          label.setZIndex(Number(this.call.argument('zIndex')))
        }
        if (isNumber(this.call.argument('rotate'))) {
          label.setRotate(Number(this.call.argument('rotate')))
        }
        let fontMap = this.call.argument('typeFace') as Map<string, object>
        if (fontMap && isNumber(fontMap.get('textStype'))) {
          label.setFontType(Number(fontMap.get('textStype')))
        }
        label.addEventListener(OverlayEvent.CLICK, this.clickCallback)
        this.setExtraInfo(label, 'id', id)
        let customInfo: object = this.call.argument('customMap')
        if (customInfo) {
          this.setExtraInfo(label, 'customMap', customInfo)
        }
        this.mapController.addOverlay(label);
        this.overlayMap.set(id, label)
        this.success()
        return
      }
    }
    this.fail()
  }

  handleUpdate(member: string, value: object, overlay: Label): void {
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
      case 'bgColor':
        if (isString(value)) {
          overlay.bgcolor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'fontColor':
        if (isString(value)) {
          overlay.setFontColor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'text':
        if (isString(value)) {
          overlay.setText(String(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'position':
        let pos = value as Map<string, object>
        if (pos) {
          let newPosition = FlutterDataConvert.mapToLatLng(pos)
          if (newPosition) {
            overlay.setPosition(newPosition)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'fontSize':
        if (isNumber(value)) {
          overlay.setFontSize(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'rotate':
        if (isNumber(value)) {
          overlay.setRotate(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'typeFace':
        if (value instanceof Map && isNumber(value.get('textStype'))) {
          overlay.setFontType(Number(value.get('textStype')))
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
