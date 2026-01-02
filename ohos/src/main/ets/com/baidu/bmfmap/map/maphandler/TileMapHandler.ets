import { ImageTileLayer, UrlTileProvider } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import FlutterDataConvert, { isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';
import { TileMapMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';

export default class TileMapHandler extends MapBaseHandler {
  tileMap: Map<string, ImageTileLayer> | null = new Map

  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    switch (this.method) {
      case TileMapMethod.AddTileMapMethod:
        this.addTitle()
        break
      case TileMapMethod.RemoveTileMapMethod:
        this.removeTile()
        break
      default:
        this.fail()
        break
    }
  }

  addTitle() {
    if (this.call && this.mapController) {
      let tileType: object = this.call.argument('tileLoadType')
      if (isNumber(tileType) && Number(tileType) === 0) {
        // 在线瓦片图
        let idObj: object = this.call.argument('id')
        let maxZoomObj: object = this.call.argument('maxZoom')
        let minZoomObj: object = this.call.argument('minZoom')
        let urlObj: object = this.call.argument('url')
        if (isString(idObj) && isString(urlObj)) {
          let tileProvider = new OnlineTileProvider()
          if (isNumber(maxZoomObj)) {
            tileProvider.setMaxLevel(Number(maxZoomObj))
          }
          if (isNumber(minZoomObj)) {
            tileProvider.setMinLevel(Number(minZoomObj))
          }
          if (isString(urlObj)) {
            tileProvider.setUrl(String(urlObj))
          }
          let imageTileLayer = ImageTileLayer.createWithMapControl(this.mapController, tileProvider)
          if (imageTileLayer) {
            if (isBoolean(this.call.argument('visible'))) {
              imageTileLayer.setVisible(Boolean(this.call.argument('visible')))
            }

            let bounds = FlutterDataConvert.mapToBounds(toMap(this.call.argument('visibleMapBounds')))
            if (bounds) {
              imageTileLayer.setSourceRegion(bounds)
            }
            if (isNumber(this.call.argument('maxTileTmp'))) {
              imageTileLayer.setMaxTileTmp(Number(this.call.argument('maxTileTmp')))
            }
            this.tileMap?.set(String(idObj), imageTileLayer)
            this.success()
            return
          }
        }
      } else {
        // 离线瓦片图 暂不支持
      }
    }
    this.fail()
  }

  removeTile() {
    if (this.call && this.mapController) {
      let idObj: object = this.call.argument('id')
      if (isString(idObj)) {
        let tile = this.tileMap?.get(String(idObj))
        if (tile) {
          this.mapController.removeTileLayer(tile)
          this.tileMap?.delete(String(idObj))
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  clean(): void {
    if (this.tileMap) {
      this.tileMap.clear()
      this.tileMap = null
    }
  }
}

/**
 * 定义瓦片图的在线Provider，并实现相关接口
 * MAX_LEVEL、MIN_LEVEL 表示地图显示瓦片图的最大、最小级别
 * urlString 表示在线瓦片图的URL地址
 */
class OnlineTileProvider extends UrlTileProvider {
  maxLevel: number = 20
  minLevel: number = 3
  url: string = ''

  setMaxLevel(maxLevel: number) {
    this.maxLevel = maxLevel
  }

  setMinLevel(minLevel: number) {
    this.minLevel = minLevel
  }

  setUrl(url: string) {
    this.url = url
  }

  override getMaxDisLevel() {
    return this.maxLevel;
  }

  override getMinDisLevel() {
    return this.minLevel;
  }

  override getTileUrl() {
    return this.url
  }
}