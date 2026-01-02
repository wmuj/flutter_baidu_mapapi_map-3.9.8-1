import MapBaseHandler from './MapBaseHandler';
import { BMFMapController } from '../../BMFMapController';
import { MapGetPropertyMethod, MapStateMethod } from '../MethodConst';
import { Bounds } from '@bdmap/base';
import FlutterDataConvert, { isBoolean, isNumber } from '../../util/FlutterDataConvert';
import NativeDataConvert from '../../util/NativeDataConvert';
import { MapLanguage, WinRound } from '@bdmap/map';
import { AnyValue } from '../../util/Constants';

export default class MapUpdateHandler extends MapBaseHandler {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    switch (this.method) {
      case MapStateMethod.MapZoomInMethod:
        this.zoomIn()
        break
      case MapStateMethod.MapZoomOutMethod:
        this.zoomOut()
        break
      case MapStateMethod.MapSetZoomToMethod:
        this.zoomTo()
        break
      case MapStateMethod.MapSetCenterCoordinateMethod:
        this.setSetCenterCoordinate()
        break
      case MapStateMethod.MapSetCenterZoomMethod:
        this.setSetCenterCoordinateWithZoom()
        break
      case MapStateMethod.MapSetMapStatusMethod:
        this.setMapStatus()
        break
      case MapStateMethod.MapGetMapStatusMethod:
        this.getMapStatus()
        break
      case MapStateMethod.MapSetVisibleMapBoundsMethod:
      case MapStateMethod.MapSetVisibleMapBoundsWithPaddingMethod:
        this.setVisibleMapBounds()
        break
      case MapStateMethod.MAP_REFRESH:
        this.refresh()
        break
      case MapGetPropertyMethod.GetMapTypeMethod:
        // TODO 鸿蒙暂时不支持
        break
      case MapGetPropertyMethod.GetMapFontSizeLevelMethod:
        // TODO 鸿蒙暂时不支持
        break
      case MapGetPropertyMethod.GetMapLanguageTypeMethod:
        this.getMapLanguage()
        break
      case MapGetPropertyMethod.GetZoomLevelMethod:
        this.getZoomLevel()
        break
      case MapGetPropertyMethod.GetMinZoomLevelMethod:
        this.getMinZoomLevel()
        break
      case MapGetPropertyMethod.GetMaxZoomLevelMethod:
        this.getMaxZoomLevel()
        break
      case MapGetPropertyMethod.GetRotationMethod:
        this.getRotation()
        break
      case MapGetPropertyMethod.GetOverlookingMethod:
        this.getOverlooking()
        break
      case MapGetPropertyMethod.GetBuildingsEnabledMethod:
        // TODO 鸿蒙暂时不支持
        break
      case MapGetPropertyMethod.GetTrafficEnabledMethod:
        this.getTrafficEnabled()
        break
      case MapGetPropertyMethod.GetBaiduHeatMapEnabledMethod:
        // TODO 鸿蒙暂时不支持
        break
      case MapGetPropertyMethod.GetGesturesEnabledMethod:
        this.getGesturesEnabled()
        break
      case MapGetPropertyMethod.GetZoomEnabledMethod:
        this.getZoomEnabled()
        break
      case MapGetPropertyMethod.GetScrollEnabledMethod:
        this.getScrollEnabled()
        break
      case MapGetPropertyMethod.GetRotateEnabledMethod:
        this.getRotateEnabled()
        break
      case MapGetPropertyMethod.GetOverlookEnabledMethod:
        this.getOverlookEnabled()
        break
      case MapGetPropertyMethod.GetMapScaleBarPositionMethod:
        // 鸿蒙因实现方式和其他端不同，暂不实现此接口（待有客户提出后再做）
        break
      case MapGetPropertyMethod.GetLogoPositionMethod:
        this.getLogoPosition()
        break
      case MapGetPropertyMethod.GetVisibleMapBoundsMethod:
        this.getVisibleMapBounds()
        break
      case MapGetPropertyMethod.GetBaseIndoorMapEnabledMethod:
        this.getBaseIndoorMapEnable()
        break
      case MapGetPropertyMethod.GetShowIndoorMapPoiMethod:
        this.getShowIndoorMapPoiEnable()
        break
      case MapGetPropertyMethod.GetShowOperateLayerMethod:
        // TODO 鸿蒙暂时不支持
        break
      default:
        break
    }
  }

  private getLogoPosition() {
    if (this.bmfMapController) {
      let pos = this.bmfMapController.getMapUIOperateModel().getLogo().getAlignment()
      if (pos) {
        let resultMap = new Map<string, AnyValue>()
        if (pos === Alignment.BottomStart) {
          resultMap.set('logoPosition', 0)
        } else if (pos === Alignment.TopStart) {
          resultMap.set('logoPosition', 1)
        } else if (pos === Alignment.Bottom) {
          resultMap.set('logoPosition', 2)
        } else if (pos === Alignment.Top) {
          resultMap.set('logoPosition', 3)
        } else if (pos === Alignment.BottomEnd) {
          resultMap.set('logoPosition', 4)
        } else if (pos === Alignment.TopEnd) {
          resultMap.set('logoPosition', 5)
        }
        this.sendReturnResult(resultMap)
      }
    }
  }

  private getShowIndoorMapPoiEnable() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('showIndoorMapPoi', this.mapController.mapOptions.showMapIndoorPoi)
      this.sendReturnResult(resultMap)
    }
  }

  private getBaseIndoorMapEnable() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('baseIndoorMapEnabled', this.mapController.mapOptions.showBaseIndoorMap)
      this.sendReturnResult(resultMap)
    }
  }

  private getVisibleMapBounds() {
    if (this.mapController && this.mapController.mapStatus) {
      let mapStatus = this.mapController.mapStatus
      //东北、西南角坐标
      let boundsMap: Map<string, object> = new Map
      if (mapStatus.geoRound.ne) {
        let northeastMap: Map<string, number> = new Map
        northeastMap.set('latitude', mapStatus.geoRound.ne.lat)
        northeastMap.set('longitude', mapStatus.geoRound.ne.lng)
        boundsMap.set('northeast', northeastMap)
      }
      if (mapStatus.geoRound.sw) {
        let southwestMap: Map<string, number> = new Map
        southwestMap.set('latitude', mapStatus.geoRound.sw.lat)
        southwestMap.set('longitude', mapStatus.geoRound.sw.lng)
        boundsMap.set('southwest', southwestMap)
      }
      this.sendReturnResult(boundsMap)
    }
  }

  private getOverlookEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('overlookEnabled', this.mapController.mapOptions.overlookingGesturesEnabled)
      this.sendReturnResult(resultMap)
    }
  }

  private getRotateEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('rotateEnabled', this.mapController.mapOptions.rotateGesturesEnabled)
      this.sendReturnResult(resultMap)
    }
  }

  private getScrollEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('scrollEnabled', this.mapController.mapOptions.moveGesturesEnabled)
      this.sendReturnResult(resultMap)
    }
  }

  private getZoomEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('zoomEnabled', this.mapController.mapOptions.zoomGesturesEnabled)
      this.sendReturnResult(resultMap)
    }
  }

  private getGesturesEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      if (this.mapController.mapOptions.rotateGesturesEnabled && this.mapController.mapOptions.moveGesturesEnabled &&
      this.mapController.mapOptions.zoomGesturesEnabled && this.mapController.mapOptions.overlookingGesturesEnabled) {
        resultMap.set('gesturesEnabled', true)
      } else {
        resultMap.set('gesturesEnabled', false)
      }
      this.sendReturnResult(resultMap)
    }
  }

  private getTrafficEnabled() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('trafficEnabled', this.mapController.mapOptions.showTrafficMap)
      this.sendReturnResult(resultMap)
    }
  }

  private getOverlooking() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('overlooking', this.mapController.mapStatus.overlooking)
      this.sendReturnResult(resultMap)
    }
  }

  private getRotation() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      let rotate = this.mapController.mapStatus.rotate
      if (rotate > 180) {
        rotate = rotate - 360
      }
      resultMap.set('rotation', rotate)
      this.sendReturnResult(resultMap)
    }
  }

  private getMaxZoomLevel() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('maxZoomLevel', this.mapController.mapStatus.maxZoom)
      this.sendReturnResult(resultMap)
    }
  }

  private getMinZoomLevel() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('minZoomLevel', this.mapController.mapStatus.minZoom)
      this.sendReturnResult(resultMap)
    }
  }

  private getZoomLevel() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      resultMap.set('zoomLevel', this.mapController.getZoom())
      this.sendReturnResult(resultMap)
    }
  }

  private getMapLanguage() {
    if (this.mapController) {
      let resultMap = new Map<string, AnyValue>()
      let language = this.mapController.getMapLanguage()
      if (language === MapLanguage.CHINESE) {
        resultMap.set('languageType', 0)
      } else if (language === MapLanguage.ENGLISH) {
        resultMap.set('languageType', 1)
      }
      this.sendReturnResult(resultMap)
    }
  }

  private zoomIn() {
    if (this.mapController) {
      this.mapController.zoomInOne()
      this.success()
      return
    }
    this.fail()
  }

  private zoomTo() {
    if (this.mapController && this.call) {
      let zoom: object = this.call.argument('zoom')
      if (isNumber(zoom)) {
        let animateDurationMs: object = this.call.argument('animateDurationMs')
        if (isNumber(animateDurationMs)) {
          this.mapController.mapStatus.setIsAnimate(true)
          this.mapController.mapStatus.setAnimationTime(Number(animateDurationMs))
        } else {
          this.mapController.mapStatus.setIsAnimate(false)
        }
        this.mapController.mapStatus.setLevel(Number(zoom))
        this.mapController.refresh()
        this.success()
        return
      }
    }
    this.fail()
  }

  private zoomOut() {
    if (this.mapController) {
      this.mapController.zoomOutOne()
      this.success()
      return
    }
    this.fail()
  }

  private setVisibleMapBounds() {
    if (this.mapController && this.call) {
      let visibleBoundsMap: object = this.call.argument('visibleMapBounds')
      if (visibleBoundsMap instanceof Map) {
        let visibleBounds: Bounds | undefined = FlutterDataConvert.mapToBounds(visibleBoundsMap as Map<string, object>)
        if (visibleBounds) {
          let animated: boolean | undefined = false
          if (isBoolean(this.call.argument('animated'))) {
            animated = this.call.argument('animated')
          }
          let top: number | undefined
          let bottom: number | undefined
          let left: number | undefined
          let right: number | undefined
          let paddingMap: object = this.call.argument('insets')
          if (paddingMap instanceof Map) {
            if (isNumber(paddingMap.get('top'))) {
              top = paddingMap.get('top')
            }
            if (isNumber(paddingMap.get('bottom'))) {
              bottom = paddingMap.get('bottom')
            }
            if (isNumber(paddingMap.get('left'))) {
              left = paddingMap.get('left')
            }
            if (isNumber(paddingMap.get('right'))) {
              right = paddingMap.get('right')
            }
          }
          this.mapController.fitVisibleMapRect(visibleBounds, new WinRound(left, right, top, bottom), animated)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  private refresh() {
    if (this.mapController) {
      this.mapController.refresh()
      this.success()
      return
    }
    this.fail()
  }

  private getMapStatus() {
    if (this.mapController && this.result) {
      let map = NativeDataConvert.mapStatusToMap(this.mapController.mapStatus)
      if (map) {
        this.result.success(map)
        return
      }
    }
    this.fail()
  }

  private setSetCenterCoordinate() {
    if (this.mapController && this.call) {
      //是否执行动画
      let isAnimated: boolean | undefined
      if (isBoolean(this.call.argument('animated'))) {
        isAnimated = this.call.argument('animated')
      }
      //动画时间
      let animationTime: number | undefined
      if (isNumber(this.call.argument('animateDurationMs'))) {
        animationTime = this.call.argument('animateDurationMs')
      }
      //中心点坐标
      let latLngMap: Map<string, object> = this.call.argument('coordinate')
      let center = FlutterDataConvert.mapToLatLng(latLngMap)
      if (center) {
        this.mapController.setMapCenter(center, this.mapController.getZoom(), isAnimated,
          animationTime)
        this.success()
        return
      }
    }
    this.fail()
  }

  private setSetCenterCoordinateWithZoom() {
    if (this.mapController && this.call) {
      //动画时间
      let animationTime: number | undefined
      if (isNumber(this.call.argument('animateDurationMs'))) {
        animationTime = this.call.argument('animateDurationMs')
      }
      let zoom: number | undefined
      if (isNumber(this.call.argument('zoom'))) {
        zoom = this.call.argument('zoom')
      }
      //中心点坐标
      let latLngMap: Map<string, object> = this.call.argument('coordinate')
      let center = FlutterDataConvert.mapToLatLng(latLngMap)
      if (center) {
        this.mapController.setMapCenter(center, zoom ?? this.mapController.getZoom(), animationTime ? true : false,
          animationTime)
        this.success()
        return
      }
    }
    this.fail()
  }

  private setMapStatus() {
    if (this.mapController && this.call) {
      let mapStatus = FlutterDataConvert.toMapStatus(this.call.argument('mapStatus'), this.mapController.mapStatus)
      //动画时间
      if (this.call.argument('animateDurationMs')) {
        mapStatus.setIsAnimate(true)
        mapStatus.setAnimationTime(this.call.argument('animateDurationMs'))
      }
      //整体赋值完成，更新地图状态
      this.mapController.mapOptions.mapStatus = mapStatus
      this.mapController.refresh()
      this.success()
      return
    }
    this.fail()
  }
}