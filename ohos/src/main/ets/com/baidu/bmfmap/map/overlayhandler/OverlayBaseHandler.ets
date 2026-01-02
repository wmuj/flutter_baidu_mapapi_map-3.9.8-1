import { AnyValue, EventOverlayBundle, MapController, Overlay } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { MethodCall, MethodChannel, MethodResult } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';


export default abstract class OverlayBaseHandler<T> {
  protected context?: common.Context
  protected mapController: MapController | null
  protected overlayMap: Map<string, Overlay>
  protected channel: MethodChannel | null
  protected result?: MethodResult
  protected call?: MethodCall
  protected method: string = ''
  protected clickCallback = (bundle: EventOverlayBundle) => {
    if (bundle.target) {
      this.handleOverlayClick(bundle.target as T)
    }
  }

  constructor(controller: BMFMapController) {
    this.channel = controller.getChannel()
    this.mapController = controller.getMapController()
    this.overlayMap = controller.getOverlayMap()
  }

  handlerMethodCallResult(context: common.Context, call: MethodCall, result: MethodResult) {
    this.context = context
    this.call = call
    this.result = result
    if (this.mapController) {
      this.method = call.method
      this.handleMethod()
    } else {
      this.fail()
    }
  }

  abstract handleMethod()

  abstract handleOverlayClick(overlay: T)

  abstract handleUpdate(member: string, value: object, overlay: T)

  protected invoke(method: string, args: object | undefined) {
    if (this.channel) {
      this.channel.invokeMethod(method, args)
      this.success()
    } else {
      this.fail()
    }
  }

  protected success() {
    this.result?.success(true)
  }

  protected fail() {
    this.result?.success(false)
  }

  protected updateOverlay() {
    if (this.call && this.mapController) {
      let id: string = this.call.argument('id')
      let member: string = this.call.argument('member')
      if (id != null && member != null && this.isOverlayExit(id)) {
        let overlay = this.getOverlay(id) as T
        let value: object = this.call.argument('value')
        if (overlay && value != null) {
          this.handleUpdate(member, value, overlay)
          return
        }
      }
    }
    this.fail()
  }

  isOverlayExit(id: string) {
    return this.overlayMap.has(id)
  }

  getOverlay(id: string) {
    return this.overlayMap.get(id)
  }

  clean() {
    this.mapController = null
    this.channel = null
  }

  protected setExtraInfo(overlay: Overlay, key: string, value: AnyValue) {
    if (overlay && overlay.getExtraInfo()) {
      overlay.getExtraInfo()[key] = value
    }
  }
}