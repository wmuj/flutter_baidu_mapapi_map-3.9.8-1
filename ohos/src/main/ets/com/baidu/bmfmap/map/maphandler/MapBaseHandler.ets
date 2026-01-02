import { MapController } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { MethodCall, MethodResult, } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { AnyValue } from '../../util/Constants';


export default abstract class MapBaseHandler {
  protected context?: common.Context
  protected mapController: MapController | null;
  protected result?: MethodResult
  protected call?: MethodCall
  protected method: string = ''
  protected bmfMapController: BMFMapController | undefined

  constructor(controller: BMFMapController) {
    this.bmfMapController = controller
    this.mapController = controller.getMapController()
  }

  handlerMethodCallResult(context: common.Context, call: MethodCall, result: MethodResult) {
    this.context = context
    this.call = call
    this.result = result
    if (this.mapController && this.call) {
      this.method = call.method
      this.handleMethod()
    } else {
      this.fail()
    }
  }

  abstract handleMethod()

  protected success() {
    this.result?.success(true)
  }

  protected fail() {
    this.result?.success(false)
  }

  protected sendReturnResult(result: AnyValue) {
    this.result?.success(result)
  }

  clean() {
    this.mapController = null
  }
}