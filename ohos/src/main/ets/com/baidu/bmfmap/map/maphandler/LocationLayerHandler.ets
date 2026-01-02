import { ILocation, ILocationConfig, ImageEntity, LocationLayer, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';
import LogUtil from '../../util/LogUtil';
import { LocationLayerMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';
import { image } from '@kit.ImageKit';
import { AnyValue } from '../../util/Constants';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';

export default class LocationLayerHandler extends MapBaseHandler {
  private sLocationLayer: LocationLayer | undefined

  constructor(controller: BMFMapController) {
    super(controller)
  }

  async handleMethod(): Promise<void> {
    if (!this.sLocationLayer) {
      this.initLocationLayer()
    }
    if (!this.sLocationLayer || !this.call || !this.mapController) {
      this.fail()
      return
    }
    switch (this.method) {
      case LocationLayerMethod.ShowUserLocationMethod:
        if (isBoolean(this.call.argument('show'))) {
          this.sLocationLayer.visible = Boolean(this.call.argument('show'))
          this.success()
          return
        }
        this.fail()
        break
      case LocationLayerMethod.UpdateLocationDataMethod:
        let userLocationMap = this.call.argument('userLocation') as Map<string, object>
        if (userLocationMap && this.mapController) {
          let locationMap = userLocationMap.get('location') as Map<string, object | number>
          if (locationMap) {
            let latLngMap = locationMap.get('coordinate') as Map<string, object>
            let location = FlutterDataConvert.mapToLatLng(latLngMap)
            if (location) {

              let direction = locationMap.get('course')
              if (isNumber(direction)) {
                if (direction === 0) {
                  direction = 0.1
                }
              } else {
                direction = 0.1
              }
              let myLocation: ILocation = {
                latlng: location,
                direction: direction as number
              }

              let radius = locationMap.get('accuracy')
              if (isNumber(radius)) {
                myLocation.radius = Number(radius)
              }

              let speed = locationMap.get('speed')
              if (isNumber(speed)) {
                myLocation.speed = Number(speed)
              }

              let satellitesNum = locationMap.get('satellitesNum')
              if (isNumber(satellitesNum)) {
                myLocation.satellitesNum = Number(satellitesNum)
              }
              this.mapController.setLocation(myLocation)
              this.success()
              return
            }
          }
        }
        this.fail()
        break
      case LocationLayerMethod.UpdateLocationDisplayParamMethod:
        let displayParamMap = this.call.argument('userlocationDisplayParam') as Map<string, AnyValue>
        if (displayParamMap) {
          let locationConfig: ILocationConfig = {}

          let fillColor = displayParamMap.get('accuracyCircleFillColor')
          if (isString(fillColor)) {
            locationConfig.accuracyCircleFillColor = checkColor(fillColor)
          }

          let mode: number = this.call.argument('userTrackingMode')
          if (isNumber(mode)) {
            if (mode === 0 || mode === 1) {
              locationConfig.locationMode = SysEnum.LocationMode.NORMAL
            } else if (mode === 2) {
              locationConfig.locationMode = SysEnum.LocationMode.FOLLOWING
            } else if (mode === 3) {
              locationConfig.locationMode = SysEnum.LocationMode.COMPASS
            }
          }

          let enableDirection = displayParamMap.get('enableDirection')
          if (isBoolean(enableDirection)) {
            locationConfig.enableDirection = Boolean(enableDirection)
          }

          let enableRotation = displayParamMap.get('isRotateAngleValid')
          if (isBoolean(enableRotation)) {
            locationConfig.enableRotation = Boolean(enableRotation)
          }

          let isLocationArrowStyleCustom = displayParamMap.get('isLocationArrowStyleCustom') as boolean
          if (isBoolean(isLocationArrowStyleCustom)) {
            if (isLocationArrowStyleCustom) {
              locationConfig.isEnableCustom = true
              // 箭头样式自定义
              let breatheEffectOpenForArrowsStyle = displayParamMap.get('breatheEffectOpenForArrowsStyle')
              if (isBoolean(breatheEffectOpenForArrowsStyle)) {
                locationConfig.isNeedAnimation = Boolean(breatheEffectOpenForArrowsStyle)
              }
              // 箭头样式-中心点图片
              let locationViewCenterGifImageFilePath =
                displayParamMap.get('locationViewCenterGifImageFilePath') as string
              if (isString(locationViewCenterGifImageFilePath)) {
                // 中心点gif
                let fileName = ''
                let paths = locationViewCenterGifImageFilePath.split('/')
                if (paths && paths.length > 0) {
                  fileName = paths[paths.length-1]
                }
                if (isString(fileName) && this.context) {
                  let desPath =
                    await this.copyRawFileToAppFiles(this.context,
                      `flutter_assets/${locationViewCenterGifImageFilePath}`,
                      `${this.context.tempDir}/${fileName}`);
                  if (isString(desPath)) {
                    let locationViewCenterImageSizeScale =
                      displayParamMap.get('locationViewCenterImageSizeScale') as number
                    if (isNumber(locationViewCenterImageSizeScale)) {
                      locationConfig.markerSize = locationViewCenterImageSizeScale
                    }
                    locationConfig.gifMarker = desPath
                  }
                }
              } else {
                // 普通图片
                let locationViewCenterImage = displayParamMap.get('locationViewCenterImage') as string
                if (isString(locationViewCenterImage)) {
                  let locationViewCenterImagePixel =
                    await this.createBitmapDescriptor(`flutter_assets/${locationViewCenterImage}`)
                  if (locationViewCenterImagePixel) {
                    let locationViewCenterImageSizeScale =
                      displayParamMap.get('locationViewCenterImageSizeScale') as number
                    if (isNumber(locationViewCenterImageSizeScale)) {
                      locationConfig.markerSize = locationViewCenterImageSizeScale
                    }
                    locationConfig.customMarker = locationViewCenterImagePixel
                  }
                }
              }
              // 箭头样式-箭头图片
              let locationViewAroundArrowsImage = displayParamMap.get('locationViewAroundArrowsImage') as string
              if (isString(locationViewAroundArrowsImage)) {
                let locationViewAroundArrowsImagePixel =
                  await this.createBitmapDescriptor(`flutter_assets/${locationViewAroundArrowsImage}`)
                if (locationViewAroundArrowsImagePixel) {
                  let arrowSize = displayParamMap.get('locationViewAroundArrowsImageSizeScale')
                  if (isNumber(arrowSize)) {
                    locationConfig.arrowSize = Number(arrowSize)
                  }
                  locationConfig.arrow = locationViewAroundArrowsImagePixel
                }
              }
              this.mapController.setLocationConfig(locationConfig)
              this.success()
            } else {
              // 整体样式自定义
              let customGifMarker = displayParamMap.get('locationViewGifImageFilePath') as string
              if (isString(customGifMarker) && this.context) {
                let fileName = ''
                let paths = customGifMarker.split('/')
                if (paths && paths.length > 0) {
                  fileName = paths[paths.length-1]
                }
                if (isString(fileName)) {
                  let desPath =
                    await this.copyRawFileToAppFiles(this.context, `flutter_assets/${customGifMarker}`,
                      `${this.context.tempDir}/${fileName}`);
                  if (isString(desPath)) {
                    let locationViewImageSizeScale = displayParamMap.get('locationViewImageSizeScale') as number
                    if (isNumber(locationViewImageSizeScale)) {
                      locationConfig.markerSize = locationViewImageSizeScale
                    }
                    locationConfig.isEnableCustom = true
                    locationConfig.gifMarker = desPath
                    this.mapController.setLocationConfig(locationConfig)
                    this.success()
                  } else {
                    this.fail()
                  }
                } else {
                  this.fail()
                }
              } else {
                let customMarker = displayParamMap.get('locationViewImageNew')
                if (isString(customMarker)) {
                  new ImageEntity('rawfile://flutter_assets/' +
                  String(customMarker), { scaleDpi: true }).getPixesMap((pixelMap: image.PixelMap) => {
                    if (pixelMap) {
                      locationConfig.isEnableCustom = true
                      locationConfig.customMarker = pixelMap
                      let breatheEffectOpenForWholeStyle =
                        displayParamMap.get('breatheEffectOpenForWholeStyle') as boolean
                      if (isBoolean(breatheEffectOpenForWholeStyle)) {
                        locationConfig.isNeedAnimation = breatheEffectOpenForWholeStyle
                      }
                      let locationViewImageSizeScale = displayParamMap.get('locationViewImageSizeScale') as number
                      if (isNumber(locationViewImageSizeScale)) {
                        locationConfig.markerSize = locationViewImageSizeScale
                      }
                      if (this.mapController) {
                        this.mapController.setLocationConfig(locationConfig)
                        this.success()
                      } else {
                        this.fail()
                      }
                    } else {
                      LogUtil.error(`customLocationMarker error,customMarker=${String(customMarker)},getPixesMap exception`)
                      this.fail()
                    }
                  })
                } else {
                  this.mapController.setLocationConfig(locationConfig)
                  this.success()
                }
              }
            }
          } else {
            this.mapController.setLocationConfig(locationConfig)
            this.success()
          }
        } else {
          this.fail()
        }
        break
      case LocationLayerMethod.UserTrackingModeMethod:
        this.setLayerMode()
        break
      default:
        this.fail()
        break
    }

  }

  setLayerMode() {
    if (this.call && this.mapController) {
      let locationConfig: ILocationConfig = {}
      if (isBoolean(this.call.argument('enableDirection'))) {
        locationConfig.enableDirection = Boolean(this.call.argument('enableDirection'))
      }
      let mode: number = this.call.argument('userTrackingMode')
      if (isNumber(mode)) {
        if (mode === 0 || mode === 1) {
          locationConfig.locationMode = SysEnum.LocationMode.NORMAL
        } else if (mode === 2) {
          locationConfig.locationMode = SysEnum.LocationMode.FOLLOWING
        } else if (mode === 3) {
          locationConfig.locationMode = SysEnum.LocationMode.COMPASS
        }
      }
      let customMarker: object = this.call.argument('customMarker')
      if (isString(customMarker)) {
        new ImageEntity('rawfile://flutter_assets/' + String(customMarker),
          { scaleDpi: true }).getPixesMap((pixelMap: image.PixelMap) => {
          if (pixelMap) {
            locationConfig.isEnableCustom = true
            locationConfig.customMarker = pixelMap
            if (this.mapController) {
              this.mapController.setLocationConfig(locationConfig)
              this.success()
            } else {
              this.fail()
            }
          } else {
            LogUtil.error(`customLocationMarker error,customMarker=${String(customMarker)},getPixesMap exception`)
            this.fail()
          }
        })
      } else {
        this.mapController.setLocationConfig(locationConfig)
        this.success()
      }
    } else {
      this.fail()
    }
  }

  initLocationLayer() {
    if (this.mapController) {
      let locationLayer = this.mapController.getLayerByTag(SysEnum.LayerTag.LOCATION)
      if (locationLayer instanceof LocationLayer) {
        this.sLocationLayer = locationLayer as LocationLayer
      }
    }
  }

  async copyRawFileToAppFiles(context: Context, srcPath: string, targetPath: string): Promise<string> {
    const rawData = await context.resourceManager.getRawFileContent(srcPath);
    if (!rawData || rawData.length === 0) {
      LogUtil.error(`getRawFileContent 返回空数据，请确认 rawfile 路径正确: ${srcPath}`);
      return '';
    }
    try {
      // 判断文件是否已经存在
      let isExit = fs.accessSync(targetPath);
      LogUtil.debug('文件存在情况：' + isExit)
      if (isExit) {
        return targetPath; // 已存在直接返回路径
      }
    } catch (err) {
      LogUtil.debug(`文件不存在，准备复制: ${targetPath}`);
    }
    try {
      const file = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(file.fd, rawData.buffer);
      fs.closeSync(file.fd);
    } catch (err) {
      LogUtil.error(`复制失败: ${err}`);
    }
    return targetPath;
  }

  async createBitmapDescriptor(path: string): Promise<PixelMap | null> {
    if (this.context && isString(path)) {
      try {
        const uint8 = await this.context.resourceManager.getRawFileContent(path);
        const arrayBuffer = uint8.buffer.slice(uint8.byteOffset, uint8.byteOffset + uint8.byteLength);
        const imageSource = image.createImageSource(arrayBuffer);
        const pixelMap = imageSource.createPixelMapSync()
        return pixelMap;
      } catch (e) {
        LogUtil.error(`createBitmapDescriptor error:${(e as BusinessError).message}`)
      }
    }
    return null
  }
}