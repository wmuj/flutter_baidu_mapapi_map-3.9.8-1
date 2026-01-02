import { MethodCall, MethodResult } from '@ohos/flutter_ohos';
import { BMFMapController } from '../../BMFMapController';
import { common } from '@kit.AbilityKit';
import OverlayBaseHandler from './OverlayBaseHandler';
import PolygonHandler from './PolygonHandler';
import { OverlayHandlerType } from '../HandlerTypeConst';
import {
  ArcLineMethod,
  BM3DModelMethod,
  CircleMethod,
  GroundMethod,
  MarkerMethod,
  MultiPointMethod,
  OverlayMethod,
  PolygonMethod,
  PolylineMethod,
  PrismMethod,
  TextMethod,
  TrackMethod
} from '../MethodConst';
import { Marker, Overlay } from '@bdmap/map';
import CircleHandler from './CircleHandler';
import MarkerHandler from './MarkerHandler';
import TextHandler from './TextHandler';
import GroundHandler from './GroundHandler';
import PolylineHandler from './PolylineHandler';
import BuildingHandler from './BuildingHandler';
import ArcLineHandler from './ArcLineHandler';
import MultiPointHandler from './MultiPointHandler';
import BM3DModelHandler from './BM3DModelHandler';
import TrackHandler from './TrackHandler';

export default class OverlayHandlerFactory {
  private sHandlerMap: Map<number, OverlayBaseHandler<Overlay>>
  private sBmfController: BMFMapController

  constructor(controller: BMFMapController) {
    this.sBmfController = controller
    this.sHandlerMap = new Map


    this.sHandlerMap.set(OverlayHandlerType.CIRCLE_HANDLER, new CircleHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.POLYGON_HANDLER, new PolygonHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.MARKER_HANDLER, new MarkerHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.TEXT_HANDLER, new TextHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.ARC_LINE_HANDLER, new ArcLineHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.GROUND_HANDLER, new GroundHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.POLYLINE_HANDLER, new PolylineHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.PRISM_HANDLER, new BuildingHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.BM3D_MODEL_HANDLER, new BM3DModelHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.MULTIPOINT_HANDLER, new MultiPointHandler(controller))
    this.sHandlerMap.set(OverlayHandlerType.TRACK_HANDLER, new TrackHandler(controller))

  }

  /**
   *  将消息分发给对应的功能handler
   */
  dispatchMethodHandler(context: common.Context, call: MethodCall, result: MethodResult): boolean {
    let method: string = call.method
    let handler: OverlayBaseHandler<Overlay> | null = null
    switch (method) {
      case MarkerMethod.AddMarkerMethod:
      case MarkerMethod.AddMarkersMethod:
      case MarkerMethod.RemoveMarkerMethod:
      case MarkerMethod.RemoveMarkersMethod:
      case MarkerMethod.CleanAllMarkersMethod:
      case MarkerMethod.UpdateMarkerMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.MARKER_HANDLER) as OverlayBaseHandler<Marker>
        break
      case CircleMethod.AddCircleMethod:
      case CircleMethod.ADD_GRADIENT_CIRCLE_METHOD:
      case CircleMethod.UpdateCircleMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.CIRCLE_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case PolygonMethod.AddPolygonMethod:
      case PolygonMethod.UpdatePolygonMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.POLYGON_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case TextMethod.AddTextMethod:
      case TextMethod.UpdateTextMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.TEXT_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case ArcLineMethod.AddArcLineMethod:
      case ArcLineMethod.UpdateArcLineMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.ARC_LINE_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case GroundMethod.AddGroundMethod:
      case GroundMethod.UpdateGroundMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.GROUND_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case PrismMethod.AddPrismMethod:
      case PrismMethod.UpdatePrismMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.PRISM_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case BM3DModelMethod.Add3DModelMethod:
      case BM3DModelMethod.Update3DModelMember:
        handler = this.sHandlerMap.get(OverlayHandlerType.BM3D_MODEL_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case MultiPointMethod.AddMultipointOverlayMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.MULTIPOINT_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case PolylineMethod.AddPolylineMethod:
      case PolylineMethod.UpdatePolylineMemberMethod:
      case PolylineMethod.AddGeodesicLineMethod:
      case PolylineMethod.UpdateGeodesicLineMemberMethod:
      case PolylineMethod.AddGradientLineMethod:
      case PolylineMethod.UpdateGradientLineMemberMethod:
        handler = this.sHandlerMap.get(OverlayHandlerType.POLYLINE_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case TrackMethod.AddTrackMethod:
      case TrackMethod.PauseTrackMethod:
      case TrackMethod.ResumeTrackMethod:
      case TrackMethod.TrackAnimationStartCallback:
      case TrackMethod.TrackAnimationProgressCallback:
      case TrackMethod.TrackAnimationEndCallback:
      case TrackMethod.RemoveTrackMethod:
      case TrackMethod.TrackAnimationUpdatePositionCallback:
        handler = this.sHandlerMap.get(OverlayHandlerType.TRACK_HANDLER) as OverlayBaseHandler<Overlay>
        break
      case OverlayMethod.RemoveOverlayMethod: //删除单个覆盖物
        this.removeOneOverLayById(call, result)
        break
      case OverlayMethod.RemoveAllOverlayMethod: //删除所有覆盖物
        if (this.sBmfController.getMapController()) {
          this.sBmfController.getMapController()?.removeOverlays()
          this.sBmfController.getOverlayMap().clear()
          result?.success(true)
        } else {
          result?.success(false)
        }
        break
      default:
        result?.success(false)
        return false

    }

    if (handler) {
      handler.handlerMethodCallResult(context, call, result)
      return true
    }
    return false
  }

  removeOneOverLayById(call: MethodCall, result: MethodResult) {
    if (call) {
      let overlayId: string = call.argument('id')
      if (overlayId && this.sBmfController && this.sBmfController.getOverlayMap()) {
        let overlay = this.sBmfController.getOverlayMap().get(overlayId)
        if (overlay) {
          overlay.remove()
          this.sBmfController.getOverlayMap().delete(overlayId)
          result?.success(true)
          return
        }
      }
    }
    result?.success(false)
  }

  release() {
    if (this.sHandlerMap) {
      this.sHandlerMap.forEach((handler) => {
        if (handler) {
          handler.clean()
        }
      })
      this.sHandlerMap.clear()
    }
  }
}