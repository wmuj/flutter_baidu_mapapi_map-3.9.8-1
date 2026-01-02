import { BMFMapController } from '../../BMFMapController';
import MapBaseHandler from './MapBaseHandler';
import { CompassLayer, Event, LocationLayer, OverlayLayer, SysEnum, WinRound } from '@bdmap/map';
import { MapStateMethod } from '../MethodConst';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';
import { Bounds, LatLng } from '@bdmap/base';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import LogUtil from '../../util/LogUtil';
import { buffer, util } from '@kit.ArkTS';

export default class MapStateHandler extends MapBaseHandler {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    switch (this.method) {
      case MapStateMethod.MAP_COPYRIGHT_INFO:
        this.getCopyRightInfo()
        break
      case MapStateMethod.MAP_MAPPING_QUALIFICATION:
        this.getMapQualification()
        break
      case MapStateMethod.MAP_APPROVAL_NUMBER:
        this.getApprovalNumber()
        break
      case MapStateMethod.WITCH_LAYER_ORDER:
        this.switchLayer()
        break
      case MapStateMethod.MapOptionUpdateMethod:
        this.updateMapState()
        break
      case MapStateMethod.MapTakeSnapshotMethod:
        this.snapShot()
        break
      case MapStateMethod.MapTakeSnapshotWithRectMethod:
        this.snapShotWithRange()
        break
      default:
        break
    }
  }

  private snapShotWithRange() {
    if (this.call && this.mapController) {
      let rectMap = toMap(this.call.argument('rect'))
      if (rectMap) {
        let pointMap = toMap(rectMap.get('origin'))
        let sizeMap = toMap(rectMap.get('size'))
        if (pointMap && sizeMap) {
          let x = pointMap.get('x')
          let y = pointMap.get('y')
          let width = sizeMap.get('width')
          let height = sizeMap.get('height')
          if (isNumber(x) && isNumber(y) && isNumber(width) && isNumber(height) &&
            (Number(x)) >= 0 && (Number(y)) >= 0 && (Number(width)) >= 0 && (Number(height)) >= 0) {
            let region: image.Region = {
              x: Number(x),
              y: Number(y),
              size: {
                width: Number(width),
                height: Number(height)
              }
            }
            this.mapController.snapshot(region).then(async (pixelMap: image.PixelMap) => {
              if (pixelMap) {
                // 转换成base64
                const imagePackerApi: image.ImagePacker = image.createImagePacker();
                let packOpts: image.PackingOption = { format: 'image/png', quality: 100 };
                imagePackerApi.packToData(pixelMap, packOpts).then((data: ArrayBuffer) => {
                  let buf: buffer.Buffer = buffer.from(data);
                  let base64Helper = new util.Base64Helper();
                  let result = base64Helper.decodeSync(buf.toString('base64', 0, buf.length), util.Type.MIME);
                  this.result?.success(result)
                }).catch((error: BusinessError) => {
                  this.result?.success(null)
                  LogUtil.error(`snapShot error:code=${error.code},message=${error.message},stack=${error.stack}`)
                })
              } else {
                this.result?.success(null)
                LogUtil.error(`snapShot error:pixelMap==null`)
              }
            })
          } else {
            this.result?.success(null)
          }
        } else {
          this.result?.success(null)
        }
      } else {
        this.result?.success(null)
      }
    }
  }

  private snapShot() {
    if (this.mapController) {
      this.mapController.snapshot().then(async (pixelMap: image.PixelMap) => {
        if (pixelMap) {
          // 转换成base64
          const imagePackerApi: image.ImagePacker = image.createImagePacker();
          let packOpts: image.PackingOption = { format: 'image/png', quality: 100 };
          imagePackerApi.packToData(pixelMap, packOpts).then((data: ArrayBuffer) => {
            let buf: buffer.Buffer = buffer.from(data);
            let base64Helper = new util.Base64Helper();
            let result = base64Helper.decodeSync(buf.toString('base64', 0, buf.length), util.Type.MIME);
            this.result?.success(result)
          }).catch((error: BusinessError) => {
            this.result?.success(null)
            LogUtil.error(`snapShot error:code=${error.code},message=${error.message},stack=${error.stack}`)
          })
        } else {
          this.result?.success(null)
          LogUtil.error(`snapShot error:pixelMap==null`)
        }
      })
    }
  }

  private switchLayer() {
    if (this.mapController && this.call) {
      let layer: object = this.call.argument('layer')
      let otherLayer: object = this.call.argument('otherLayer')
      if (isNumber(layer) && isNumber(otherLayer)) {
        if (Number(layer) == 2 && Number(otherLayer) == 4) {
          this.mapController.switchLayer(this.mapController.getLayerByTag(SysEnum.LayerTag.OVERLAY) as OverlayLayer,
            this.mapController.getLayerByTag(SysEnum.LayerTag.LOCATION) as LocationLayer)
        } else if (Number(layer) == 4 && Number(otherLayer) == 2) {
          this.mapController.switchLayer(this.mapController.getLayerByTag(SysEnum.LayerTag.LOCATION) as LocationLayer,
            this.mapController.getLayerByTag(SysEnum.LayerTag.OVERLAY) as OverlayLayer)
        }
      }
    }
  }

  private getCopyRightInfo() {
    this.result?.success(new Map().set('copyrightInformation', SysEnum.Copyright.CORPORATE))
  }

  private getMapQualification() {
    let mapLicense = SysEnum.Copyright.LICENSE
    if (mapLicense.search('-') != -1) {
      let strArray = mapLicense.split('-')
      this.result?.success(new Map().set('mappingQualification', strArray[1]))
    } else {
      this.result?.success(new Map().set('mappingQualification', mapLicense))
    }
  }

  private getApprovalNumber() {
    let mapLicense = SysEnum.Copyright.LICENSE
    if (mapLicense.search('-') != -1) {
      let strArray = mapLicense.split('-')
      this.result?.success(new Map().set('approvalNumber', strArray[0]))
    } else {
      this.result?.success(new Map().set('approvalNumber', mapLicense))
    }
  }

  private updateMapState() {
    if (this.mapController && this.call) {
      // 中心点坐标
      let latLngMap: Map<string, object> = this.call.argument('center')
      let center = FlutterDataConvert.mapToLatLng(latLngMap)
      if (center) {
        this.mapController.mapStatus.centerPoint = center
      }
      if (isNumber(this.call.argument('zoomLevel'))) {
        this.mapController.mapStatus.level = Number(this.call.argument('zoomLevel'))
      }
      if (isNumber(this.call.argument('rotation'))) {
        this.mapController.mapStatus.rotate = Number(this.call.argument('rotation'))
      }
      if (isNumber(this.call.argument('overlooking'))) {
        this.mapController.mapStatus.overlooking = Number(this.call.argument('overlooking'))
      }

      // 设置地图最佳视野
      if (this.call.argument('visibleMapBounds') instanceof Map) {
        let visibleBound: Bounds | undefined =
          FlutterDataConvert.mapToBounds(this.call.argument('visibleMapBounds') as Map<string, object>)
        if (visibleBound) {
          this.mapController.fitVisibleMapRect(visibleBound, new WinRound(0, 0, 0, 0), false)
        }
      }
      // 最小比例
      if (isNumber(this.call.argument('minZoomLevel'))) {
        this.mapController.minZoom = Number(this.call.argument('minZoomLevel'))
      }
      // 最大比例
      if (isNumber(this.call.argument('maxZoomLevel'))) {
        this.mapController.maxZoom = Number(this.call.argument('maxZoomLevel'))
      }
      // 指北针
      if (isBoolean(this.call.argument('compassEnabled'))) {
        let compassLayer = this.mapController.getLayerByTag(SysEnum.LayerTag.COMPASS)
        if (compassLayer instanceof CompassLayer) {
          compassLayer.x = 64
          compassLayer.y = 64
          compassLayer.setVisible(Boolean(this.call.argument('compassEnabled')))
        }
      }
      // 缩放控件
      if (isBoolean(this.call.argument('showZoomControl'))) {
        emitter.emit({ eventId: Event.ZoomCom }, {
          data: {
            show: Boolean(this.call.argument('showZoomControl')),
            mapViewId: this.mapController.mapViewId
          }
        })
      }
      // 比例尺
      if (isBoolean(this.call.argument('showMapScaleBar'))) {
        emitter.emit({ eventId: Event.ScaleCom }, {
          data: {
            show: Boolean(this.call.argument('showMapScaleBar')),
            mapViewId: this.mapController.mapViewId
          }
        })
      }
      // 设置是否显示poi
      if (isBoolean(this.call.argument('showMapPoi'))) {
        this.mapController.mapOptions.showMapPoi = Boolean(this.call.argument('showMapPoi'))
      }
      // 设置是否显示交通图
      if (isBoolean(this.call.argument('trafficEnabled'))) {
        this.mapController.mapOptions.showTrafficMap = Boolean(this.call.argument('trafficEnabled'))
      }
      // 设置是否显示室内图
      if (isBoolean(this.call.argument('baseIndoorMapEnabled'))) {
        this.mapController.mapOptions.showBaseIndoorMap = Boolean(this.call.argument('baseIndoorMapEnabled'))
      }
      // 设置是否显示室内poi
      if (isBoolean(this.call.argument('showIndoorMapPoi'))) {
        this.mapController.mapOptions.showMapIndoorPoi = Boolean(this.call.argument('showIndoorMapPoi'))
      }
      // 是否展示地形图
      if (isBoolean(this.call.argument('showDEMLayer'))) {
        this.mapController.setDEMEnable(Boolean(this.call.argument('showDEMLayer')))
      }
      // 是否展示3D建筑物
      let buildingsEnabledObj: object = this.call.argument('buildingsEnabled')
      if (isBoolean(buildingsEnabledObj)) {
        let buildingsEnabled = Boolean(buildingsEnabledObj)
        this.mapController.set3DModelEnable(buildingsEnabled)
        this.mapController.setHouseHeightEnable(buildingsEnabled)
      }
      // 地图固定显示区域
      if (this.call.argument('limitMapBounds') instanceof Map) {
        let limitBounds = FlutterDataConvert.mapToBounds(this.call.argument('limitMapBounds') as Map<string, object>)
        if (limitBounds) {
          this.mapController.setGeoRoundLimit(limitBounds)
        }
      }
      // 手势是否采用指定缩放中心点
      if (isBoolean(this.call.argument('doubleClickGesturesEnable'))) {
        this.mapController.mapOptions.useMapCenterWhenPinch = Boolean(this.call.argument('doubleClickGesturesEnable'))
      }
      //指定缩放中心点
      if (this.call.argument('latLngGestures') instanceof Map) {
        let gesturesMap = this.call.argument('latLngGestures') as Map<string, object>
        if (gesturesMap) {
          let latLng: LatLng | undefined = FlutterDataConvert.mapToLatLng(gesturesMap)
          if (latLng) {
            this.mapController.mapOptions.zoomCenter = latLng
          }
        }
      }
      // 设置是否允许通过手势旋转地图
      if (isBoolean(this.call.argument('rotateEnabled'))) {
        this.mapController.mapOptions.rotateGesturesEnabled = Boolean(this.call.argument('rotateEnabled'))
      }
      // 设置是否允许通过手势缩放地图
      if (isBoolean(this.call.argument('zoomEnabled'))) {
        this.mapController.mapOptions.zoomGesturesEnabled = Boolean(this.call.argument('zoomEnabled'))
      }
      // 设置是否允许通过手势移动地图
      if (isBoolean(this.call.argument('scrollEnabled'))) {
        this.mapController.mapOptions.moveGesturesEnabled = Boolean(this.call.argument('scrollEnabled'))
      }
      // 设置是否允许通过手势俯仰地图
      if (isBoolean(this.call.argument('overlookEnabled'))) {
        this.mapController.mapOptions.overlookingGesturesEnabled = Boolean(this.call.argument('overlookEnabled'))
      }
      // 设置地图操作区距控件的距离
      if (this.call.argument('mapPadding') instanceof Map) {
        let paddingMap = this.call.argument('mapPadding') as Map<string, object>
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
          this.mapController.setViewPadding(left, right, top, bottom)
        }
      }
      // 地图类型
      if (isNumber(this.call.argument('mapType'))) {
        let mapType = Number(this.call.argument('mapType'))
        if (mapType == 0) {
          this.mapController.setMapType(SysEnum.MapType.MAP_TYPE_NONE)
        } else if (mapType == 1) {
          this.mapController.setMapType(SysEnum.MapType.MAP_TYPE_NORMAL)
        } else if (mapType == 2) {
          this.mapController.setMapType(SysEnum.MapType.MAP_TYPE_SATELLITE)
        }
      }
      if (isString(this.call.argument('backgroundColor'))) {
        this.mapController.setBgkColor(checkColor(this.call.argument('backgroundColor')))
      }
      // 地图语言 TODO 先暂时屏蔽，待后续原生功能完善后再打开
      if (isNumber(this.call.argument('languageType'))) {
        // this.mapController.setMapLanguage(Number(this.call.argument('languageType')))
      }
      // 设置Logo位置
      let logoPos = this.call.argument('logoPosition') as number
      if (isNumber(logoPos) && this.bmfMapController) {
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
        this.bmfMapController.getMapUIOperateModel().getLogo().setX(x)
        this.bmfMapController.getMapUIOperateModel().getLogo().setY(y)
        this.bmfMapController.getMapUIOperateModel().getLogo().setAlignment(position)
      }

      this.mapController.refresh()
      this.success()
    } else {
      this.fail()
    }
  }
}