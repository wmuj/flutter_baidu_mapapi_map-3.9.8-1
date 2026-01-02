import { LatLng } from '@bdmap/base';
import { BMFMapController } from '../../BMFMapController';
import FlutterDataConvert, { isNumber } from '../../util/FlutterDataConvert';
import NativeDataConvert from '../../util/NativeDataConvert';
import { ProjectionMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';

export default class ProjectionHandler extends MapBaseHandler {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    switch (this.method) {
      case ProjectionMethod.FromScreenLocation:
        this.fromScreenLocation()
        break
      case ProjectionMethod.ToScreenLocation:
        this.toScreenLocation()
        break
      case ProjectionMethod.ScreenPointFromMapPoint3Dimensional:
        this.toScreenLocationFromMapPoint3Dimensional()
        break
      default:
        break
    }
  }

  private fromScreenLocation() {
    if (this.call && this.mapController && this.result) {
      if (this.call.argument('point')) {
        let pointMap: Map<string, object> = this.call.argument('point')
        if (isNumber(pointMap.get('x')) && isNumber(pointMap.get('y'))) {
          let latLng = this.mapController.pixel2bdll(Number(pointMap.get('x')), Number(pointMap.get('y')))
          let map= NativeDataConvert.latLngToMap(latLng, true, 'coordinate')
          if (map) {
            this.result.success(map)
            return
          }
        }
      }
    }
    this.fail()
  }

  private toScreenLocation() {
    if (this.call && this.mapController && this.result) {
      if (this.call.argument('coordinate')) {
        let latLng: Nullable<LatLng> = FlutterDataConvert.mapToLatLng(this.call.argument('coordinate'))
        if (latLng) {
          let pointArray: Nullable<[number, number]> | null = this.mapController.bdll2pixel(latLng as LatLng)
          if (pointArray) {
            let pointMap: Map<string, number> = new Map
            pointMap.set('x', pointArray[0])
            pointMap.set('y', pointArray[1])
            this.result.success(new Map().set('point', pointMap))
            return
          }
        }
      }
    }
    this.fail()
  }

  private toScreenLocationFromMapPoint3Dimensional() {
    if (this.call && this.mapController && this.result) {
      if (this.call.argument('coordinate')) {
        let latLng: Nullable<LatLng> = FlutterDataConvert.mapToLatLng(this.call.argument('coordinate'))
        if (latLng && isNumber(this.call.argument('height'))) {
          let pointArray: Nullable<[number, number]> | null =
            this.mapController.bdll2pixel(latLng as LatLng, Number(this.call.argument('height')))
          if (pointArray) {
            let pointMap: Map<string, number> = new Map
            pointMap.set('x', pointArray[0])
            pointMap.set('y', pointArray[1])
            this.result.success(new Map().set('point', pointMap))
            return
          }
        }
      }
    }
    this.fail()
  }
}