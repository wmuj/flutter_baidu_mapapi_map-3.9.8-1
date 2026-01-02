import { ImageEntity, MultiPoint, MultiPointItem, Overlay } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { MultiPointMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';


export default class MultiPointHandler extends OverlayBaseHandler<Overlay> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Overlay): void {
  }

  handleUpdate(member: string, value: object, overlay: Overlay): void {
    throw new Error('Method not implemented.');
  }

  handleMethod(): void {
    switch (this.method) {
      case MultiPointMethod.AddMultipointOverlayMethod:
        this.addMultiPoint()
        break
      default:
        this.fail()
        break
    }
  }

  addMultiPoint() {
    if (this.call && this.mapController) {
      let id: string = this.call.argument('id')
      let icon: object = this.call.argument('icon')
      let itemsObj: object = this.call.argument('items')
      if (isString(id) && !this.overlayMap.has(id) && isString(icon) && itemsObj instanceof Array) {
        let itemArray = itemsObj as Array<Map<string, object>>

        let pointArray: MultiPointItem[] = []
        itemArray.forEach((itemMap) => {
          if (itemMap) {
            // 解析坐标
            let pointMap = toMap(itemMap.get('coordinate'))
            let point = FlutterDataConvert.mapToLatLng(pointMap)
            if (point) {
              let multiItem = new MultiPointItem(point)
              let title = itemMap.get('title')
              if (isString(title)) {
                multiItem.setTitle(String(title))
              }
              pointArray.push(multiItem)
            }
          }
        })
        if (pointArray.length > 0) {
          const multiPoint = new MultiPoint({
            multiPointItems: pointArray,
            icon: new ImageEntity('rawfile://flutter_assets/' + String(icon), { scaleDpi: true })
          })
          // 解析大小
          let sizeMap = toMap(this.call.argument('pointSize'))
          if (sizeMap) {
            let width = sizeMap.get('width')
            let height = sizeMap.get('height')
            if (isNumber(width) && isNumber(height)) {
              multiPoint.setPointSize(Number(width), Number(height))
            }
          }
          // 解析锚点
          let anchorMap = toMap(this.call.argument('anchor'))
          if (anchorMap) {
            let x = anchorMap.get('x')
            let y = anchorMap.get('y')
            if (isNumber(x) && isNumber(y)) {
              multiPoint.anchor(Number(x), Number(y))
            }
          }

          if (isNumber(this.call.argument('zIndex'))) {
            multiPoint.setZIndex(Number(this.call.argument('zIndex')))
          }
          if (isBoolean(this.call.argument('visible'))) {
            multiPoint.setVisible(Boolean(this.call.argument('visible')))
          }

          this.setExtraInfo(multiPoint, 'id', id)
          this.setExtraInfo(multiPoint, 'icon', icon)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(multiPoint, 'customMap', customInfo)
          }
          // multiPoint.addEventListener(OverlayEvent.CLICK, this.clickCallback)
          this.mapController.addOverlay(multiPoint);
          this.overlayMap.set(id, multiPoint)
          this.success()
          return
        }
      }
    }
    this.fail()
  }
}
