import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import PlatformViewFactory from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformViewFactory';
import common from '@ohos.app.ability.common';
import PlatformView from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { BMFMapController } from './BMFMapController';
import FlutterDataConvert from './util/FlutterDataConvert';
import { MapOptions } from '@bdmap/map';

export class MapViewFactory extends PlatformViewFactory {
  message: BinaryMessenger;

  constructor(message: BinaryMessenger, createArgsCodes: MessageCodec<Object>) {
    super(createArgsCodes);
    this.message = message;
  }

  public create(context: common.Context, viewId: number, args: Object): PlatformView {
    let mapOption: MapOptions = FlutterDataConvert.toMapOptions(args);
    let controller: BMFMapController = new BMFMapController(context, viewId, this.message, mapOption, args)
    return controller.getMapView()
  }
}