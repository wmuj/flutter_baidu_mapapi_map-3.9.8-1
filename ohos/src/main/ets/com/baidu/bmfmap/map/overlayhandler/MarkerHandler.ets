import { LatLng, Point } from '@bdmap/base';
import { ImageEntity, Marker, OverlayEvent, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import LogUtil from '../../util/LogUtil';
import { MarkerMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';
import List from '@ohos.util.List';
import NativeDataConvert from '../../util/NativeDataConvert';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';


export default class MarkerHandler extends OverlayBaseHandler<Marker> {
  private markerMap: Map<string, Marker> = new Map

  handleOverlayClick(overlay: Marker): void {
    let resultMap: Map<string, object> = new Map
    let map = NativeDataConvert.markerToMap(overlay)
    if (map) {
      resultMap.set('marker', map)
    }
    this.invoke(MarkerMethod.ClickedMarkedMethod, resultMap)
  }


  constructor(controller: BMFMapController) {
    super(controller)
  }


  handleMethod(): void {
    switch (this.method) {
      case MarkerMethod.AddMarkerMethod:
        this.addMarker()
        break
      case MarkerMethod.AddMarkersMethod:
        this.addMarkers()
        break
      case MarkerMethod.RemoveMarkerMethod:
        this.removeMarker()
        break
      case MarkerMethod.RemoveMarkersMethod:
        this.removeMarkers()
        break
      case MarkerMethod.CleanAllMarkersMethod:
        this.removeAllMarkers()
        break
      case MarkerMethod.UpdateMarkerMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  isOverlayExit(id: string) {
    if (this.markerMap) {
      return this.markerMap.has(id)
    }
    return false
  }

  getOverlay(id: string) {
    return this.markerMap.get(id)
  }

  addMarker(argsMap?: Map<string, object>) {
    if (this.mapController && this.call) {
      if (!argsMap) {
        argsMap = this.call.args
      }
      if (argsMap) {
        let id = String(argsMap.get('id'))
        let icon = argsMap.get('icon')
        let iconData = argsMap.get('iconData')
        let positionMap = argsMap.get('position') as Map<string, object>
        if (id && positionMap && !this.markerMap.has(id)) {
          let position: LatLng | undefined = FlutterDataConvert.mapToLatLng(positionMap)
          let imageEntity: ImageEntity | undefined
          if (position) {
            if (isString(icon)) {
              imageEntity = new ImageEntity('rawfile://flutter_assets/' + String(icon), { scaleDpi: true })
            } else if (iconData instanceof Uint8Array) {
              try {
                let iconArray = iconData as Uint8Array
                let imageSource: image.ImageSource = image.createImageSource(iconArray.buffer.slice(0));
                // 创建pixelMap。
                let pixelMap = imageSource.createPixelMapSync()
                if (pixelMap) {
                  imageEntity = new ImageEntity(pixelMap, { scaleDpi: true })
                }
              } catch (e) {
                LogUtil.debug('addMarker error' + e)
              }
            }

            let marker: Marker = new Marker({
              position: position,
              icon: imageEntity,
            })

            //固定像素坐标位置
            let isLockedToScreen = argsMap.get('isLockedToScreen')
            if (isBoolean(isLockedToScreen) && Boolean(isLockedToScreen)) {
              let screenPointMap = argsMap.get('screenPointToLock') as Map<string, object>
              if (screenPointMap) {
                if (isNumber(screenPointMap.get('x')) && isNumber(screenPointMap.get('y'))) {
                  marker.fixedScreenPosition(new Point(Number(screenPointMap.get('x')),
                    Number(screenPointMap.get('y'))))
                }
              }
            }

            let offsetMap = argsMap.get('centerOffset') as Map<string, object>
            if (offsetMap) {
              if (isNumber(offsetMap.get('y'))) {
                marker.setYOffset(Number(offsetMap.get('y')))
              }
              if (isNumber(offsetMap.get('x'))) {
                marker.setXOffset(Number(offsetMap.get('x')))
              }
            }

            let enabled = argsMap.get('enabled')
            if (isBoolean(enabled)) {
              marker.setClickable(Boolean(enabled))
            }
            let draggable = argsMap.get('draggable')
            if (isBoolean(draggable)) {
              marker.setDraggable(Boolean(draggable))
            }
            let visible = argsMap.get('visible')
            if (isBoolean(visible)) {
              marker.setVisible(Boolean(visible))
            }
            let zIndex = argsMap.get('zIndex')
            if (isNumber(zIndex)) {
              marker.setZIndex(Number(zIndex))
            }

            let located = argsMap.get('located')
            if (isNumber(located)) {
              marker.setLocated(this.getLocated(Number(located)))
            }

            let scaleX = argsMap.get('scaleX')
            if (isNumber(scaleX)) {
              marker.setScaleX(Number(scaleX))
            }

            let scaleY = argsMap.get('scaleY')
            if (isNumber(scaleY)) {
              marker.setScaleY(Number(scaleY))
            }

            let alpha = argsMap.get('alpha')
            if (isNumber(alpha)) {
              marker.setAlpha(Number(alpha))
            }

            let rotation = argsMap.get('rotation')
            if (isNumber(rotation)) {
              marker.setRotate(Number(rotation))
            }

            let isPerspective = argsMap.get('isPerspective')
            if (isBoolean(isPerspective)) {
              marker.setPerspective(Boolean(isPerspective))
            }

            let isOpenCollisionDetection = argsMap.get('isOpenCollisionDetection')
            if (isBoolean(isOpenCollisionDetection)) {
              if (Boolean(isOpenCollisionDetection)) {
                marker.setIsJoinCollision(SysEnum.CollisionBehavior.HIDE_BY_PRIORITY)
              } else {
                marker.setIsJoinCollision(SysEnum.CollisionBehavior.NOT_COLLIDE)
              }
            }

            let isForceDisplay = argsMap.get('isForceDisplay')
            if (isBoolean(isForceDisplay)) {
              if (Boolean(isForceDisplay)) {
                marker.setIsJoinCollision(SysEnum.CollisionBehavior.ALWAYS_SHOW)
              }
            }

            let collisionDetectionPriority = argsMap.get('collisionDetectionPriority')
            if (isNumber(collisionDetectionPriority)) {
              marker.setPriority(Number(collisionDetectionPriority))
            }

            let isOpenCollisionDetectionWithMapPOI = argsMap.get('isOpenCollisionDetectionWithMapPOI')
            if (isBoolean(isOpenCollisionDetectionWithMapPOI)) {
              if (Boolean(isOpenCollisionDetectionWithMapPOI)) {
                marker.setIsJoinCollision(SysEnum.CollisionBehavior.COLLIDE_WITH_BASEPOI)
              }
            }

            marker.addEventListener(OverlayEvent.CLICK, this.clickCallback)

            this.setExtraInfo(marker, 'id', id)
            let customInfo = argsMap.get('customMap')
            if (customInfo) {
              this.setExtraInfo(marker, 'customMap', customInfo)
            }
            this.mapController.addOverlay(marker);
            this.markerMap.set(id, marker)
            this.success()
            return
          }
        }
      }
    }
    this.fail()
  }

  addMarkers() {
    if (this.mapController && this.call) {
      let argsList: List<Map<string, object>> = this.call.args
      if (argsList) {
        argsList.forEach((mapItem) => {
          if (mapItem) {
            this.addMarker(mapItem)
          }
        })
        this.success()
        return
      }
    }
    this.fail()
  }

  removeMarkers() {
    if (this.mapController && this.call) {
      let argsList: List<Map<string, object>> = this.call.args
      if (argsList) {
        argsList.forEach((mapItem) => {
          if (mapItem) {
            this.removeMarker(mapItem)
          }
        })
        this.success()
        return
      }
    }
    this.fail()
  }

  removeMarker(argsMap?: Map<string, object>) {
    if (this.mapController && this.call) {
      if (!argsMap) {
        argsMap = this.call.args
      }
      if (argsMap && argsMap.get('id') as String) {
        let id = String(argsMap.get('id'))
        if (id && this.markerMap.has(id)) {
          let marker = this.markerMap.get(id)
          if (marker) {
            this.mapController.removeOverlay(marker)
            this.markerMap.delete(id)
            this.success()
            return
          } else {
            this.markerMap.delete(id)
          }
        }
      }
    }
    this.fail()
  }

  removeAllMarkers() {
    if (this.mapController) {
      this.mapController.removeOverlays(SysEnum.OverlayType.MARKER)
      this.markerMap.clear()
      this.success()
    } else {
      this.fail()
    }
  }

  handleUpdate(member: string, value: object, overlay: Marker): void {
    switch (member) {
      case 'position':
        let positionList = value as Map<string, object>
        if (positionList) {
          let newPosition: LatLng | undefined = FlutterDataConvert.mapToLatLng(positionList)
          if (newPosition) {
            overlay.setPosition(newPosition)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'isLockedToScreen':
        if (isBoolean(value)) {
          let isLockedToScreen = Boolean(value)
          if (this.call && isLockedToScreen) {
            let screenPointMap = this.call.argument('screenPointToLock') as Map<string, object>
            if (screenPointMap) {
              if (isNumber(screenPointMap.get('x')) && isNumber(screenPointMap.get('y'))) {
                overlay.fixedScreenPosition(new Point(Number(screenPointMap.get('x')), Number(screenPointMap.get('y'))))
                overlay.update()
                this.success()
                return
              }
            }
          }
        }
        this.fail()
        break
      case 'centerOffset':
        let newOffsetMap = value as Map<string, object>
        if (newOffsetMap) {
          if (isNumber(newOffsetMap.get('y')) && isNumber(newOffsetMap.get('x'))) {
            overlay.setYOffset(Number(newOffsetMap.get('y')))
            overlay.setXOffset(Number(newOffsetMap.get('x')))
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'enabled':
        if (isBoolean(value)) {
          overlay.setClickable(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'draggable':
        if (isBoolean(value)) {
          overlay.setDraggable(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'visible':
        if (isBoolean(value)) {
          overlay.setVisible(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'isPerspective':
        if (isBoolean(value)) {
          overlay.setPerspective(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'zIndex':
        if (isNumber(value)) {
          overlay.setZIndex(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'scaleX':
        if (isNumber(value)) {
          overlay.setScaleX(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'scaleY':
        if (isNumber(value)) {
          overlay.setScaleY(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'alpha':
        if (isNumber(value)) {
          overlay.setAlpha(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'rotation':
        if (isNumber(value)) {
          overlay.setRotate(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'icon':
        let newIcon = value as String
        if (newIcon) {
          overlay.setIcon(new ImageEntity('rawfile://flutter_assets/' + String(newIcon), { scaleDpi: true }))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'iconData':
        if (value instanceof Uint8Array) {
          let iconArray = value as Uint8Array
          let imageSource: image.ImageSource = image.createImageSource(iconArray.buffer.slice(0));
          // 配置解码选项参数。
          let decodingOptions: image.DecodingOptions = {
            desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
          };
          // 创建pixelMap。
          imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
            let newImage = new ImageEntity(pixelMap, { scaleDpi: true })
            if (newImage && overlay) {
              overlay.setIcon(newImage)
              overlay.update()
              this.success()
            }
          }).catch((err: BusinessError) => {
            LogUtil.error(`图片更新失败:${err.message}}`)
            this.fail()
          });
        } else {
          this.fail()
        }
        break
      default:
        this.fail()
        break
    }
  }

  getLocated(index: number): SysEnum.Located {
    let located = SysEnum.Located.TOP
    if (index == 0) {
      located = SysEnum.Located.CENTER
    } else if (index == 1) {
      located = SysEnum.Located.TOP
    } else if (index == 2) {
      located = SysEnum.Located.BOTTOM
    } else if (index == 3) {
      located = SysEnum.Located.LEFT
    } else if (index == 4) {
      located = SysEnum.Located.RIGHT
    } else if (index == 5) {
      located = SysEnum.Located.LEFT_TOP
    } else if (index == 6) {
      located = SysEnum.Located.LEFT_BOTTOM
    } else if (index == 7) {
      located = SysEnum.Located.RIGHT_TOP
    } else if (index == 8) {
      located = SysEnum.Located.RIGHT_BOTTOM
    } else if (index == 9) {
      located = SysEnum.Located.HALF_TOP
    } else if (index == 10) {
      located = SysEnum.Located.HALF_BOTTOM
    } else if (index == 11) {
      located = SysEnum.Located.HALF_LEFT
    } else if (index == 12) {
      located = SysEnum.Located.HALF_RIGHT
    } else if (index == 13) {
      located = SysEnum.Located.HALF_LEFT_TOP
    } else if (index == 14) {
      located = SysEnum.Located.HALF_LEFT_BOTTOM
    } else if (index == 15) {
      located = SysEnum.Located.HALF_RIGHT_TOP
    } else if (index == 16) {
      located = SysEnum.Located.HALF_RIGHT_BOTTOM
    } else if (index == 17) {
      located = SysEnum.Located.ALIGN_TOP
    } else if (index == 18) {
      located = SysEnum.Located.ALIGN_BOTTOM
    } else if (index == 19) {
      located = SysEnum.Located.ALIGN_LEFT
    } else if (index == 20) {
      located = SysEnum.Located.ALIGN_RIGHT
    } else if (index == 21) {
      located = SysEnum.Located.ALIGN_LEFT_TOP
    } else if (index == 22) {
      located = SysEnum.Located.ALIGN_LEFT_BOTTOM
    } else if (index == 23) {
      located = SysEnum.Located.ALIGN_RIGHT_TOP
    } else if (index == 24) {
      located = SysEnum.Located.ALIGN_RIGHT_BOTTOM
    }
    return located;
  }
}
