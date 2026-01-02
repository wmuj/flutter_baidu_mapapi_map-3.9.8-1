import { Bounds, LatLng, WeightedLatLng } from '@bdmap/base';
import { MapOptions, MapStatus } from '@bdmap/map';
import { List } from '@kit.ArkTS';
import LogUtil from './LogUtil';
import {AnyValue} from './Constants'


export function isBoolean(key: AnyValue): boolean {
  return typeof (key) === 'boolean'
}

export function isNumber(value: AnyValue): boolean {
  return typeof (value) === 'number' && !Number.isNaN(Number(value))
}

export function isString(value: AnyValue): boolean {
  return typeof (value) === 'string' && String(value).length > 0
}

export function toMap(o: AnyValue | undefined): Map<string, AnyValue> | undefined {
  if (o instanceof Map) {
    return o as Map<string, AnyValue>
  }
  return
}

export function checkColor(colorObj: AnyValue | undefined): string {
  if (isString(colorObj)) {
    let colorStr = String(colorObj)
    if (colorStr.length == 8) {
      return '#' + colorStr
    }
  }
  return '#00000000'
}

export function printMap(paramsMap: Map<string, Object | AnyValue> | undefined) {
  if (!paramsMap) {
    LogUtil.debug('paramsMap is undefined')
    return
  }
  let mapString = '';
  paramsMap.forEach((value, key) => {
    if (Object(value) instanceof Map) {
      LogUtil.debug('key=' + key + ' 的map数据为：')
      printMap(value as Map<string, object>)
    } else {
      mapString = mapString + 'key=' + key + ', value=' + value + '\n'
    }
  })
  if (mapString) {
    LogUtil.debug(mapString)
  }
}

/**
 *  将flutter层参数转化为原生层参数对象
 */
export default class FlutterDataConvert {
  static mapToLatLng(argsMap: Map<string, AnyValue> | undefined): Nullable<LatLng> {
    if (argsMap && isNumber(argsMap.get('latitude')) && isNumber(argsMap.get('longitude'))) {
      return new LatLng(Number(argsMap.get('latitude')), Number(argsMap.get('longitude')))
    }
    return
  }

  static toMapOptions(args: Object): MapOptions {
    // LogUtil.debug('convertToMapOptions')
    let option: MapOptions = new MapOptions();
    if (args instanceof Map) {
      let map = args as Map<string, AnyValue>
      // printMap(map)
      // 设置是否允许通过手势旋转地图
      if (isBoolean(map.get('rotateEnabled'))) {
        option.rotateGesturesEnabled = Boolean(map.get('rotateEnabled'))
      }
      // 设置是否允许通过手势缩放地图
      if (isBoolean(map.get('zoomEnabled'))) {
        option.zoomGesturesEnabled = Boolean(map.get('zoomEnabled'))
      }
      // 设置是否允许通过手势移动地图
      if (isBoolean(map.get('scrollEnabled'))) {
        option.moveGesturesEnabled = Boolean(map.get('scrollEnabled'))
      }
      // 设置是否允许通过手势俯仰地图
      if (isBoolean(map.get('overlookEnabled'))) {
        option.overlookingGesturesEnabled = Boolean(map.get('overlookEnabled'))
      }


      // 是个BMFPoint对象，包含横坐标 double x;纵坐标 double y;（暂不考虑实现，鸿蒙端采用对齐+偏移量的方式，待后续有客户提出再做）
      if (map.has('mapScaleBarPosition')) {

      }
      // 设置缩放控件的位置，设定坐标以BMFMapWidget左上角为原点，向右向下增长（暂不考虑实现，鸿蒙端采用对齐+偏移量的方式，待后续有客户提出再做）
      if (map.has('mapZoomControlPosition')) {

      }

      // 设置地图中心点
      if (map.get('center') instanceof Map) {
        let latLng: LatLng | undefined = FlutterDataConvert.mapToLatLng(map.get('center') as Map<string, object>)
        if (latLng) {
          option.mapStatus.centerPoint = latLng
        }
      }
      // 设置地图俯视角度
      if (isNumber(map.get('overlooking'))) {
        option.mapStatus.overlooking = (Number(map.get('overlooking')))
      }
      // 设置地图旋转角度
      if (isNumber(map.get('rotation'))) {
        option.mapStatus.rotate = (Number(map.get('rotation')))
      }
      // 设置地图比例
      if (isNumber(map.get('zoomLevel'))) {
        option.mapStatus.level = (Number(map.get('zoomLevel')))
      }
      // 手势是否采用指定缩放中心点
      if (isBoolean(map.get('doubleClickGesturesEnable'))) {
        option.useMapCenterWhenPinch = Boolean(map.get('doubleClickGesturesEnable'))
      }
      // 设置双击放大地图是否开启
      if (isBoolean(map.get('zoomEnabledWithDoubleClick'))) {
        option.enableDBClickZoom = Boolean(map.get('zoomEnabledWithDoubleClick'))
      }
      //指定缩放中心点
      if (map.get('latLngGestures') instanceof Map) {
        let gesturesMap = map.get('latLngGestures') as Map<string, object>
        if (gesturesMap) {
          let latLng: LatLng | undefined = FlutterDataConvert.mapToLatLng(gesturesMap)
          if (latLng) {
            option.zoomCenter = latLng
          }
        }
      }
      // 设置是否显示poi
      if (isBoolean(map.get('showMapPoi'))) {
        option.showMapPoi = Boolean(map.get('showMapPoi'))
      }
      // 设置是否显示交通图
      if (isBoolean(map.get('trafficEnabled'))) {
        option.showTrafficMap = Boolean(map.get('trafficEnabled'))
      }
      // 设置是否显示室内图
      if (isBoolean(map.get('baseIndoorMapEnabled'))) {
        option.showBaseIndoorMap = Boolean(map.get('baseIndoorMapEnabled'))
      }
      // 设置是否显示室内poi
      if (isBoolean(map.get('showIndoorMapPoi'))) {
        option.showMapIndoorPoi = Boolean(map.get('showIndoorMapPoi'))
      }

    }
    return option;
  }

  static mapToBounds(argsMap: Map<string, AnyValue> | undefined): Nullable<Bounds> {
    if (argsMap) {
      let northeastLatLng: LatLng | undefined
      let southwestLatLng: LatLng | undefined
      let northeastMap = argsMap.get('northeast')
      if (northeastMap instanceof Map) {
        northeastLatLng = FlutterDataConvert.mapToLatLng(northeastMap)
      }
      let southwestMap = argsMap.get('southwest')
      if (southwestMap instanceof Map) {
        southwestLatLng = FlutterDataConvert.mapToLatLng(southwestMap)
      }
      if (northeastLatLng && southwestLatLng) {
        return new Bounds(southwestLatLng, northeastLatLng)
      }
    }
    return
  }

  /**
   *
   * @param statusMap 目标status
   * @param mapStatus 当前地图status
   * @returns 将目标status中的属性覆盖当前属性，组合新的status返回
   */
  static toMapStatus(statusMap: Map<string, object>, mapStatus: MapStatus): MapStatus {
    if (statusMap) {
      if (statusMap.has('fLevel')) {
        mapStatus.setLevel(Number(statusMap.get('fLevel')))
      }
      if (statusMap.has('fRotation')) {
        mapStatus.setRotate(Number(statusMap.get('fRotation')))
      }
      if (statusMap.has('fOverlooking')) {
        mapStatus.setOverlooking(Math.abs(Number(statusMap.get('fOverlooking'))))
      }
      //TODO 目前鸿蒙不支持
      if (statusMap.has('targetScreenPt')) {
      }
      if (statusMap.has('targetGeoPt')) {
        let argsMap = statusMap.get('targetGeoPt') as Map<string, object>
        let latLng: LatLng | undefined = FlutterDataConvert.mapToLatLng(argsMap)
        if (latLng) {
          mapStatus.setCenterPoint(latLng)
        }
      }
    }
    return mapStatus
  }


  static listToLatLng(argsList: List<Map<string, object>> | Array<Map<string, object>>): Nullable<Array<LatLng>> {
    if (argsList && argsList.length > 0) {
      let array = new Array<LatLng>()
      argsList.forEach((mapItem: Map<string, object>, index?: number) => {
        if (mapItem) {
          let latLng: LatLng | undefined = FlutterDataConvert.mapToLatLng(mapItem)
          if (latLng && index != undefined) {
            array[index] = latLng
          }
        }
      })
      return array
    }
    return
  }

  static arrayToWeightedLatLng(argsList: Array<Map<string, object>>): Nullable<Array<WeightedLatLng>> {
    if (argsList && argsList.length > 0) {
      let dataArray = new Array<WeightedLatLng>()
      argsList.forEach(itemMap => {
        if (itemMap) {
          let intensityObj = itemMap.get('intensity')
          let ptMapObj = itemMap.get('pt')
          if (ptMapObj instanceof Map && isNumber(intensityObj)) {
            let pt = FlutterDataConvert.mapToLatLng(ptMapObj as Map<string, object>)
            if (pt) {
              dataArray.push(new WeightedLatLng(pt, Number(intensityObj)))
            }
          }
        }
      })
      return dataArray
    }
    return
  }
}