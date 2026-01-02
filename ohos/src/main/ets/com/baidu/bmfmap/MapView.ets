import PlatformView, { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';

import { MapComponent, MapController, MapOptions, MapUIOperateModel } from '@bdmap/map';
import { AsyncCallback } from '@ohos.base';
import { BMFMapController } from './BMFMapController';


@ComponentV2
struct MapViewComponent {
  @Param @Require params: Params
  @Local platformView: MapView = this.params.platformView as MapView

  aboutToAppear() {

  }

  build() {
    Column() {
      MapComponent({
        onReady: this.platformView.callback,
        mapOptions: this.platformView.option,
        mapUIOperate: this.platformView.mapUIOperateModel
      })
        .width('100%')
        .height('100%');
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
  }
}

@Builder
function MapBuilder(params: Params) {
  MapViewComponent({ params: params })
}

@ObservedV2
export class MapView extends PlatformView {
  option: MapOptions;
  mapController: MapController | null = null
  callback: AsyncCallback<MapController>
  controller: BMFMapController | null
  @Trace mapUIOperateModel: MapUIOperateModel

  constructor(controller: BMFMapController, option: MapOptions, callback: AsyncCallback<MapController>,
    mapUIOperateModel: MapUIOperateModel) {
    super();
    this.controller = controller
    this.option = option
    this.callback = callback
    this.mapUIOperateModel = mapUIOperateModel
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(MapBuilder);
  }

  /**
   * Dispose this platform view.
   * The PlatformView object is unusable after this method is called.
   * Plugins implementing PlatformView must clear all references to the View object and the PlatformView after this method is called. Failing to do so will result in a memory leak.
   * References related to the Platform View attached in onFlutterViewAttached(View) must be released in dispose() to avoid memory leaks.
   */
  dispose(): void {
    if (this.controller) {
      this.controller.release()
      this.controller = null
    }
  }
}

