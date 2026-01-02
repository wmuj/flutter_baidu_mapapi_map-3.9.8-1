import { ImageEntity, OverlayEvent, Polyline, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { OverlayMethod, PolylineMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import { OverlayType } from './OverlayType';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString } from '../../util/FlutterDataConvert';
import { List } from '@kit.ArkTS';
import NativeDataConvert from '../../util/NativeDataConvert';


export default class PolylineHandler extends OverlayBaseHandler<Polyline> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Polyline): void {
    let resultMap: Map<string, object | number> = new Map
    resultMap.set('overlayType', OverlayType.Polyline.valueOf())
    let map = NativeDataConvert.polylineToMap(overlay)
    if (map) {
      resultMap.set('overlay', map)
    }
    this.invoke(OverlayMethod.OverlayClickedCallback, resultMap)
  }

  handleMethod(): void {
    switch (this.method) {
      case PolylineMethod.AddPolylineMethod:
        this.addPolyline(0)
        break
      case PolylineMethod.AddGeodesicLineMethod:
        this.addPolyline(1)
        break
      case PolylineMethod.AddGradientLineMethod:
        this.addPolyline(2)
        break
      case PolylineMethod.UpdateGeodesicLineMemberMethod:
      case PolylineMethod.UpdateGradientLineMemberMethod:
      case PolylineMethod.UpdatePolylineMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  handleUpdate(member: string, value: object, overlay: Polyline): void {
    switch (member) {
      case 'width':
        if (isNumber(value)) {
          overlay.setWidth(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'coordinates':
        let list = value as List<Map<string, object>>
        if (list) {
          let points = FlutterDataConvert.listToLatLng(list)
          if (points) {
            overlay.setPoints(points)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      case 'indexs':
        let newIndex = value as Array<number>
        if (newIndex) {
          overlay.setIndexList(newIndex)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'textures':
        let newTextures = value as Array<string>
        if (newTextures) {
          if (newTextures.length == 1) {
            overlay.setTexture(new ImageEntity('rawfile://flutter_assets/' + newTextures[0]))
          } else {
            let imageArray: Array<ImageEntity> = new Array()
            newTextures.forEach((value, index) => {
              imageArray[index] = new ImageEntity('rawfile://flutter_assets/' + value)
            })
            overlay.setTextures(imageArray)
            if (overlay.getExtraInfo()) {
              overlay.getExtraInfo()['textures'] = newTextures
            }
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'textureImage':
        if (isString(value)) {
          overlay.setTexture(new ImageEntity('rawfile://flutter_assets/' + String(value)))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'strokeColor':
        if (isString(value)) {
          overlay.setColor(checkColor(value))
          overlay.update()
          if (overlay.getExtraInfo()) {
            overlay.getExtraInfo()['color'] = String(value)
          }
          this.success()
          return
        }
        this.fail()
      case 'lineDashType':
        if (isNumber(value)) {
          overlay.setIsDottedline(true)
          if (Number(value) == 1) {
            overlay.setDottedLineType(SysEnum.PolylineDottedLineType.DOTTED_LINE_SQUARE)
          } else if (Number(value) == 2) {
            overlay.setDottedLineType(SysEnum.PolylineDottedLineType.DOTTED_LINE_CIRCLE)
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineJoinType':
        if (isNumber(value)) {
          let lineJoinType = Number(value)
          if (lineJoinType == 0) {
            overlay.setJoinType(SysEnum.LineJoinType.BEVEL)
          } else if (lineJoinType == 1) {
            overlay.setJoinType(SysEnum.LineJoinType.MITER)
          } else if (lineJoinType == 2) {
            overlay.setJoinType(SysEnum.LineJoinType.ROUND)
          } else if (lineJoinType == 3) {
            overlay.setJoinType(SysEnum.LineJoinType.BERZIER)
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineCapType':
        if (isNumber(value)) {
          let lineCapType = Number(value)
          if (lineCapType == 0) {
            overlay.setCapType(SysEnum.LineCapType.BUTT)
          } else if (lineCapType == 1) {
            overlay.setCapType(SysEnum.LineCapType.ROUND)
          }
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'clickable':
        if (isBoolean(value)) {
          overlay.setClickable(Boolean(value))
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
      case 'isThined':
        if (isBoolean(value)) {
          overlay.setIsThined(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'dottedLine':
        if (isBoolean(value)) {
          overlay.setIsDottedline(Boolean(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'isKeepScale':
        if (isBoolean(value)) {
          if (Boolean(value)) {
            overlay.setTextureOption(SysEnum.TextureOption.SCALE_TEXTURE)
          } else {
            overlay.setTextureOption(SysEnum.TextureOption.REPEAT)
          }
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
      case 'lineDirectionCross180':
        if (isNumber(value)) {
          overlay.setDirectionCross180(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineBloomMode':
        if (isNumber(value)) {
          overlay.setLineBloomType(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineBloomWidth':
        if (isNumber(value)) {
          overlay.setLineBloomWidth(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineBloomAlpha':
        if (isNumber(value)) {
          let alpha = Number(value) / 255
          overlay.setLineBloomAlpha(alpha)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineBloomGradientASPeed':
        if (isNumber(value)) {
          overlay.setLineBloomGradientASPeed(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'lineBloomBlurTimes':
        if (isNumber(value)) {
          overlay.setLineBloomBlurTimes(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'colors':
        if (value instanceof Map) {
          let colorsArray = (value as Map<string, object>).get('value')
          let indexArray = (value as Map<string, object>).get('indexs')
          if (colorsArray instanceof Array && indexArray instanceof Array) {
            let correctArray = this.correctColor(indexArray, colorsArray, overlay.getPoints().length)
            if (correctArray.length > 0) {
              overlay.setColorList(correctArray)
              overlay.update()
              if (overlay.getExtraInfo()) {
                overlay.getExtraInfo()['colors'] = colorsArray
              }
              this.success()
              return
            }
          }
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }

  addPolyline(lineType: number) {
    if (this.mapController && this.call) {
      let id: string = this.call.argument('id')
      if (id && !this.overlayMap.has(id)) {

        let coordinatesList = this.call.argument('coordinates') as List<Map<string, object>>
        let points = FlutterDataConvert.listToLatLng(coordinatesList)
        if (points) {
          let polyline: Polyline = new Polyline()
          if (lineType == 1) {
            // 大地曲线
            polyline.setGeodesic(true)
          } else if (lineType == 2) {
            // 渐变线
            polyline.setIsGradient(true)
          }
          polyline.setPoints(points)
          if (isNumber(this.call.argument('width'))) {
            polyline.setWidth(Number(this.call.argument('width')))
          }
          if (isBoolean(this.call.argument('clickable'))) {
            polyline.setClickable(Boolean(this.call.argument('clickable')))
          }
          if (isNumber(this.call.argument('zIndex'))) {
            polyline.setZIndex(Number(this.call.argument('zIndex')))
          }
          if (isBoolean(this.call.argument('visible'))) {
            polyline.setVisible(Boolean(this.call.argument('visible')))
          }
          // 抽稀
          if (isBoolean(this.call.argument('isThined'))) {
            polyline.setIsThined(Boolean(this.call.argument('isThined')))
          }
          if (isBoolean(this.call.argument('dottedLine'))) {
            polyline.setIsDottedline(Boolean(this.call.argument('dottedLine')))
          }
          // 虚线样式
          if (isNumber(this.call.argument('lineDashType'))) {
            let dottedLineType = Number(this.call.argument('lineDashType'))
            if (dottedLineType == 1) {
              polyline.setDottedLineType(SysEnum.PolylineDottedLineType.DOTTED_LINE_SQUARE)
            } else if (dottedLineType == 2) {
              polyline.setDottedLineType(SysEnum.PolylineDottedLineType.DOTTED_LINE_CIRCLE)
            }
          }
          // 首尾样式
          if (isNumber(this.call.argument('lineCapType'))) {
            let lineCapType = Number(this.call.argument('lineCapType'))
            if (lineCapType == 0) {
              polyline.setCapType(SysEnum.LineCapType.BUTT)
            } else if (lineCapType == 1) {
              polyline.setCapType(SysEnum.LineCapType.ROUND)
            }
          }
          // 连接处样式
          if (isNumber(this.call.argument('lineJoinType'))) {
            let lineJoinType = Number(this.call.argument('lineJoinType'))
            if (lineJoinType == 0) {
              polyline.setJoinType(SysEnum.LineJoinType.BEVEL)
            } else if (lineJoinType == 1) {
              polyline.setJoinType(SysEnum.LineJoinType.MITER)
            } else if (lineJoinType == 2) {
              polyline.setJoinType(SysEnum.LineJoinType.ROUND)
            } else if (lineJoinType == 3) {
              polyline.setJoinType(SysEnum.LineJoinType.BERZIER)
            }
          }
          if (isNumber(this.call.argument('lineDirectionCross180'))) {
            polyline.setDirectionCross180(Number(this.call.argument('lineDirectionCross180')))
          }

          // 发光
          if (isNumber(this.call.argument('lineBloomMode'))) {
            polyline.setLineBloomType(Number(this.call.argument('lineBloomMode')))
          }
          let lineBloomWidth: number = this.call.argument('lineBloomWidth')
          if (lineBloomWidth > 0) {
            polyline.setLineBloomWidth(Number(this.call.argument('lineBloomWidth')))
          }
          let lineBloomAlphaObj: object = this.call.argument('lineBloomAlpha');
          if (isNumber(lineBloomAlphaObj)) {
            let alpha = Number(lineBloomAlphaObj) / 255
            polyline.setLineBloomAlpha(alpha)
          }
          if (isNumber(this.call.argument('lineBloomGradientASPeed'))) {
            polyline.setLineBloomGradientASPeed(Number(this.call.argument('lineBloomGradientASPeed')))
          }
          if (isNumber(this.call.argument('lineBloomBlurTimes'))) {
            polyline.setLineBloomBlurTimes(Number(this.call.argument('lineBloomBlurTimes')))
          }
          let fillColor: object = this.call.argument('strokeColor');
          if (isString(fillColor)) {
            this.setExtraInfo(polyline, 'color', fillColor)
            polyline.setColor(checkColor(fillColor))
          }
          if (isString(this.call.argument('textureImage'))) {
            polyline.setTexture(new ImageEntity('rawfile://flutter_assets/' +
            String(this.call.argument('textureImage'))))
          }
          // 纹理索引(正常搭配纹理使用，若非纹理，需要搭配渐变、多段颜色使用)
          let indexArray: Array<number> = this.call.argument('indexs')
          // 颜色 (flutter层的使用方式是按照ios标准制定的，index搭配colors和textures使用，所以需要根据索引重新生成colors)
          let colorArray: Array<string> = this.call.argument('colors')
          if (colorArray instanceof Array && colorArray.length > 0) {
            let correctArray = this.correctColor(indexArray, colorArray, points.length)
            if (correctArray.length > 0) {
              polyline.setColorList(correctArray)
              this.setExtraInfo(polyline, 'colors', colorArray)
            }
          }
          // 纹理
          let texturesArray: Array<string> = this.call.argument('textures')
          if (texturesArray instanceof Array) {
            this.setExtraInfo(polyline, 'textures', texturesArray)
            let imageArray: Array<ImageEntity> = new Array()
            texturesArray.forEach((value, index) => {
              imageArray[index] = new ImageEntity('rawfile://flutter_assets/' + value)
            })
            polyline.setTextures(imageArray)
            if (indexArray instanceof Array) {
              polyline.setIndexList(indexArray)
            }
          }
          // 纹理展示样式
          if (isBoolean(this.call.argument('isKeepScale'))) {
            let isKeepScale = Boolean(this.call.argument('isKeepScale'))
            if (isKeepScale) {
              polyline.setTextureOption(SysEnum.TextureOption.SCALE_TEXTURE)
            } else {
              polyline.setTextureOption(SysEnum.TextureOption.REPEAT)
            }
          }

          polyline.addEventListener(OverlayEvent.CLICK, this.clickCallback)
          this.setExtraInfo(polyline, 'id', id)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(polyline, 'customMap', customInfo)
          }
          this.mapController.addOverlay(polyline);
          this.overlayMap.set(id, polyline)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  correctColor(index: number[], colors: string[], pointNum: number): Array<string> {
    let result = new Array<string>()
    if (index && colors && pointNum > 0) {
      for (let i = 0; i < pointNum; i++) {
        if (index[i] < 0 || index[i] >= colors.length) {
          result[i] = '#' + colors[colors.length-1]
        } else {
          result[i] = '#' + colors[i]
        }
      }
    }
    return result
  }
}
