import { BinaryMessenger, MethodCall, MethodCallHandler, MethodChannel, MethodResult, } from '@ohos/flutter_ohos';
import { MapController, MapOptions, MapUIOperateModel, Overlay } from '@bdmap/map';
import { common } from '@kit.AbilityKit';
import { MapView } from './MapView';
import { VIEW_METHOD_CHANNEL_PREFIX } from './util/Constants';
import { MapHandlerFactory } from './map/maphandler/MapHandlerFactory';
import OverlayHandlerFactory from './map/overlayhandler/OverlayHandlerFactory';
import MapListener from './map/MapListener';
import { initMapOption } from './MapOptionProxy';


export class BMFMapController implements MethodCallHandler {
  private sContext: common.Context
  private sChannel: MethodChannel | null = null
  private sMapView: MapView;
  private sMapController: MapController | null = null
  private sMapListener: MapListener | null = null
  private sMapHandlerFactory: MapHandlerFactory | null = null;
  private sOverlayHandlerFactory: OverlayHandlerFactory | null = null
  private sOverlayMap: Map<string, Overlay> = new Map
  private sMapUIOperateModel = new MapUIOperateModel()

  constructor(context: common.Context, viewId: number, binaryMessenger: BinaryMessenger, options: MapOptions,
    otherMapOption: Object) {

    this.sContext = context
    this.sMapView =
      new MapView(this, options, async (err, mapController: MapController) => {
        if (!err) {
          // 获取地图的控制器类，用来操作地图
          this.sMapController = mapController
          initMapOption(this.sMapController, otherMapOption, this.sMapUIOperateModel)
          this.init(viewId, binaryMessenger)
        }
      }, this.sMapUIOperateModel);
  }

  private init(viewId: number, binaryMessenger: BinaryMessenger) {
    this.sChannel = new MethodChannel(binaryMessenger, VIEW_METHOD_CHANNEL_PREFIX + viewId);
    this.sChannel.setMethodCallHandler(this)
    // LogUtil.debug('channel=' + VIEW_METHOD_CHANNEL_PREFIX + viewId)

    this.sMapListener = new MapListener(this.sMapController, this.sChannel)

    this.sMapHandlerFactory = new MapHandlerFactory(this)
    this.sOverlayHandlerFactory = new OverlayHandlerFactory(this)
  }

  getMapUIOperateModel(){
    return this.sMapUIOperateModel
  }

  getMapView(): MapView {
    return this.sMapView;
  }

  getMapController(): MapController | null {
    return this.sMapController;
  }

  getChannel(): MethodChannel | null {
    return this.sChannel
  }

  getOverlayMap() {
    return this.sOverlayMap
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (!this.sMapController || !call || !result || !call.method || !this.sMapHandlerFactory ||
      !this.sOverlayHandlerFactory) {
      return
    }

    let isHandled = this.sMapHandlerFactory.dispatchMethodHandler(this.sContext, call, result)
    if (!isHandled) {
      this.sOverlayHandlerFactory.dispatchMethodHandler(this.sContext, call, result)
    }
  }

  release() {
    if (this.sChannel) {
      this.sChannel.setMethodCallHandler(null)
    }
    this.sChannel = null
    if (this.sMapListener) {
      this.sMapListener.release()
      this.sMapListener = null
    }
    if (this.sMapHandlerFactory) {
      this.sMapHandlerFactory.release()
      this.sMapHandlerFactory = null
    }
    if (this.sOverlayHandlerFactory) {
      this.sOverlayHandlerFactory.release()
      this.sOverlayHandlerFactory = null
    }
    if (this.sOverlayMap) {
      this.sOverlayMap.clear()
    }
  }
}