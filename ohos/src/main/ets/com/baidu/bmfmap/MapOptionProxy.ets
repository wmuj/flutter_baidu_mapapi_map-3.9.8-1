import { CompassLayer, Event, MapController, MapUIOperateModel, SysEnum, WinRound } from '@bdmap/map';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from './util/FlutterDataConvert';
import emitter from '@ohos.events.emitter';
import { Bounds } from '@bdmap/base';
import { AnyValue } from './util/Constants';

export function initMapOption(controller: MapController, args: Object, mapUIOperateModel: MapUIOperateModel) {
  if (controller && args instanceof Map) {
    let optionMap = args as Map<string, AnyValue>
    // 地图类型
    if (isNumber(optionMap.get('mapType'))) {
      let mapType = Number(optionMap.get('mapType'))
      if (mapType == 0) {
        controller.setMapType(SysEnum.MapType.MAP_TYPE_NONE)
      } else if (mapType == 1) {
        controller.setMapType(SysEnum.MapType.MAP_TYPE_NORMAL)
      } else if (mapType == 2) {
        controller.setMapType(SysEnum.MapType.MAP_TYPE_SATELLITE)
      }
    }
    if (isString(optionMap.get('backgroundColor'))) {
      controller.setBgkColor(checkColor(optionMap.get('backgroundColor')))
    }
    // 地图语言 TODO 先暂时屏蔽，待后续原生功能完善后再打开
    if (isNumber(optionMap.get('languageType'))) {
      // controller.setMapLanguage(Number(optionMap.get('languageType')))
    }
    // 指北针
    if (isBoolean(optionMap.get('compassEnabled'))) {
      let compassLayer = controller.getLayerByTag(SysEnum.LayerTag.COMPASS)
      if (compassLayer instanceof CompassLayer) {
        compassLayer.x = 64
        compassLayer.y = 64
        compassLayer.setVisible(Boolean(optionMap.get('compassEnabled')))
      }
    }
    // 缩放控件
    if (isBoolean(optionMap.get('showZoomControl'))) {
      emitter.emit({ eventId: Event.ZoomCom }, {
        data: {
          show: Boolean(args.get('showZoomControl')),
          mapViewId: controller.mapViewId
        }
      })
    }
    // 比例尺
    if (isBoolean(optionMap.get('showMapScaleBar'))) {
      emitter.emit({ eventId: Event.ScaleCom }, {
        data: {
          show: Boolean(optionMap.get('showMapScaleBar')),
          mapViewId: controller.mapViewId
        }
      })
    }
    // 最小比例
    if (isNumber(optionMap.get('minZoomLevel'))) {
      controller.minZoom = Number(optionMap.get('minZoomLevel'))
    }
    // 最大比例
    if (isNumber(optionMap.get('maxZoomLevel'))) {
      controller.maxZoom = Number(optionMap.get('maxZoomLevel'))
    }
    // 设置地图最佳视野
    if (optionMap.get('visibleMapBounds') instanceof Map) {
      let visibleBound: Bounds | undefined =
        FlutterDataConvert.mapToBounds(optionMap.get('visibleMapBounds') as Map<string, object>)
      if (visibleBound) {
        controller.fitVisibleMapRect(visibleBound, new WinRound(0, 0, 0, 0), false)
      }
    }
    // 设置地图操作区距控件的距离
    if (optionMap.get('mapPadding') instanceof Map) {
      let paddingMap = optionMap.get('mapPadding') as Map<string, object>
      if (paddingMap) {
        let top: number = 0
        if (isNumber(paddingMap.get('top'))) {
          top = Number(paddingMap.get('top'))
        }
        let left: number = 0
        if (isNumber(paddingMap.get('left'))) {
          left = Number(paddingMap.get('left'))
        }
        let bottom: number = 0
        if (isNumber(paddingMap.get('bottom'))) {
          bottom = Number(paddingMap.get('bottom'))
        }
        let right: number = 0
        if (isNumber(paddingMap.get('right'))) {
          right = Number(paddingMap.get('right'))
        }
        controller.setViewPadding(left, right, top, bottom)
      }
    }
    // 地图固定显示区域
    if (optionMap.get('limitMapBounds') instanceof Map) {
      let limitBounds = FlutterDataConvert.mapToBounds(optionMap.get('limitMapBounds') as Map<string, object>)
      if (limitBounds) {
        controller.setGeoRoundLimit(limitBounds)
      }
    }
    // 是否展示地形图
    if (isBoolean(optionMap.get('showDEMLayer'))) {
      controller.setDEMEnable(Boolean(optionMap.get('showDEMLayer')))
    }
    // 是否展示3D建筑物
    let buildingsEnabledObj = optionMap.get('buildingsEnabled')
    if (isBoolean(buildingsEnabledObj)) {
      let buildingsEnabled = Boolean(buildingsEnabledObj)
      controller.set3DModelEnable(buildingsEnabled)
      controller.setHouseHeightEnable(buildingsEnabled)
    }
    // 设置Logo位置
    let logoPos = optionMap.get('logoPosition') as number
    if (isNumber(logoPos)) {
      let position = Alignment.BottomStart
      let x = '42px'
      let y = '-42px'
      if (logoPos === 0) {
        // 左下
        position = Alignment.BottomStart
        x = '42px'
        y = '-42px'
      } else if (logoPos === 1) {
        // 左上
        position = Alignment.TopStart
        x = '0px'
        y = '0px'
      } else if (logoPos === 2) {
        // 中下
        position = Alignment.Bottom
        x = '0px'
        y = '-42px'
      } else if (logoPos === 3) {
        // 中上
        position = Alignment.Top
        x = '0px'
        y = '0px'
      } else if (logoPos === 4) {
        // 右下
        position = Alignment.BottomEnd
        x = '0px'
        y = '-42px'
      } else if (logoPos === 5) {
        // 右上
        position = Alignment.TopEnd
        x = '0px'
        y = '0px'
      }
      mapUIOperateModel.getLogo().setX(x)
      mapUIOperateModel.getLogo().setY(y)
      mapUIOperateModel.getLogo().setAlignment(position)
    }

  }
}