import { BuildingInfo, LatLng } from '@bdmap/base';
import { Building, FloorAnimateType, ImageEntity, Prism } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { PrismMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import { List } from '@kit.ArkTS';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';


export default class BuildingHandler extends OverlayBaseHandler<Prism> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Prism): void {
  }

  handleMethod(): void {
    switch (this.method) {
      case PrismMethod.AddPrismMethod:
        this.addBuilding()
        break
      case PrismMethod.UpdatePrismMemberMethod:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  addBuilding() {
    if (this.mapController && this.call) {

      let id: string = this.call.argument('id')
      if (id && !this.overlayMap.has(id)) {
        let buildingMap = toMap(this.call.argument('buildInfo'))
        let coordinatesArray: Array<Map<string, object>> = this.call.argument('coordinates')
        let topFaceColor: object = this.call.argument('topFaceColor')
        let sideFaceColor: object = this.call.argument('sideFaceColor')
        let sideFacTexture: object = this.call.argument('sideFacTexture')
        let floorColor: object = this.call.argument('floorColor')
        let height: number | undefined = this.call.argument('height')
        let floorHeight: number | undefined = this.call.argument('floorHeight')
        let visible: object = this.call.argument('visible')
        // let isGrowthAnimation: object = this.call.argument('isGrowthAnimation')
        let isRoundedCorner: object = this.call.argument('isRoundedCorner')
        let roundedCornerRadius: number | undefined = this.call.argument('roundedCornerRadius')

        if (buildingMap) {
          // 添加Building
          let building = new Building({
            height: height,
            floorHeight: floorHeight,
            topFaceColor: isString(topFaceColor) ? checkColor(topFaceColor) : undefined,
            sideFaceColor: isString(sideFaceColor) ? checkColor(sideFaceColor) : undefined,
            floorColor: isString(floorColor) ? checkColor(floorColor) : undefined,
            isRoundedCorner: isBoolean(isRoundedCorner) ? Boolean(isRoundedCorner) : false,
            roundedCornerRadius: roundedCornerRadius,
            visible: isBoolean(visible) ? Boolean(visible) : true,
            buildingFloorAnimateType: FloorAnimateType.AnimateNormal
          })

          let buildingInfo: BuildingInfo = {}
          if (isNumber(buildingMap.get('height'))) {
            buildingInfo.height = Number(buildingMap.get('height'))
          }
          if (isNumber(buildingMap.get('accuracy'))) {
            buildingInfo.accuracy = Number(buildingMap.get('accuracy'))
          }
          if (isString(buildingMap.get('paths'))) {
            buildingInfo.geom = String(buildingMap.get('paths'))
          }
          if (isNumber(buildingMap.get('structId'))) {
            buildingInfo.structId = String(buildingMap.get('structId'))
          }
          if (isNumber(buildingMap.get('label'))) {
            buildingInfo.label = Number(buildingMap.get('label'))
          }
          let centerMap = toMap(buildingMap.get('center'))
          if (centerMap) {
            let longitude = centerMap.get('longitude')
            let latitude = centerMap.get('latitude')
            buildingInfo.center = String(longitude) + ',' + String(latitude)
          }
          building.setBuildingInfo(buildingInfo)

          if (isString(sideFacTexture)) {
            building.setCustomSideImage(new ImageEntity('rawfile://flutter_assets/' +
            String(sideFacTexture)))
          }

          if (isNumber(this.call.argument('showLevel'))) {
            building.startLevel(Number(this.call.argument('showLevel')))
          }
          let floorSideTextureImage: object = this.call.argument('floorSideTextureImage')
          if (isString(floorSideTextureImage)) {
            building.setFloorSideTextureImage(new ImageEntity('rawfile://flutter_assets/' +
            String(floorSideTextureImage)))
          }

          this.setExtraInfo(building, 'id', id)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(building, 'customMap', customInfo)
          }
          this.setExtraInfo(building, 'topFaceColor', String(topFaceColor))
          this.setExtraInfo(building, 'sideFaceColor', String(sideFaceColor))
          this.setExtraInfo(building, 'sideFacTexture', String(sideFacTexture))
          this.setExtraInfo(building, 'floorColor', String(floorColor))
          this.setExtraInfo(building, 'floorSideTextureImage', String(floorSideTextureImage))
          this.mapController.addOverlay(building);
          this.overlayMap.set(id, building)
          this.success()
          return
        } else if (coordinatesArray instanceof Array) {
          let points: Array<LatLng> = new Array
          // 添加Prism
          coordinatesArray.forEach(itemMap => {
            let point = FlutterDataConvert.mapToLatLng(itemMap)
            if (point) {
              points.push(point)
            }
          })

          if (points.length > 0) {
            let prism = new Prism({
              points: points,
              topFaceColor: isString(topFaceColor) ? checkColor(topFaceColor) : undefined,
              sideFaceColor: isString(sideFaceColor) ? checkColor(sideFaceColor) : undefined,
            })
            if (isString(topFaceColor)) {
              prism.setTopFaceColor(checkColor(topFaceColor))
            }
            if (isNumber(height)) {
              prism.setHeight(Number(height))
            }
            if (isBoolean(visible)) {
              prism.setVisible(Boolean(visible))
            }
            if (isString(sideFacTexture)) {
              prism.setCustomSideImage(new ImageEntity('rawfile://flutter_assets/' +
              String(sideFacTexture)))
            } else {
              if (isString(sideFaceColor)) {
                prism.setSideFaceColor(checkColor(sideFaceColor))
              }
            }
            this.mapController.addOverlay(prism);
            this.overlayMap.set(id, prism)
            this.setExtraInfo(prism, 'id', id)
            let customInfo: object = this.call.argument('customMap')
            if (customInfo) {
              this.setExtraInfo(prism, 'customMap', customInfo)
            }
            this.setExtraInfo(prism, 'topFaceColor', String(topFaceColor))
            this.setExtraInfo(prism, 'sideFaceColor', String(sideFaceColor))
            this.setExtraInfo(prism, 'sideFacTexture', String(sideFacTexture))
            this.success()
            return
          }
        } else {
          this.fail()
          return
        }
      }
    }
    this.fail()
  }

  handleUpdate(member: string, value: object, overlay: Prism): void {
    switch (member) {
      case 'floorHeight':
        if (isNumber(value) && overlay instanceof Building) {
          overlay.setFloorHeight(Number(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'topFaceColor':
        if (isString(value)) {
          overlay.setTopFaceColor(checkColor(value))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'sideFaceColor':
        if (isString(value)) {
          overlay.setSideFaceColor(checkColor(value))
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
      case 'sideFacTexture':
        let newIcon = value as String
        if (newIcon) {
          overlay.setCustomSideImage(new ImageEntity('rawfile://flutter_assets/' + String(newIcon)))
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'buildInfo':
        let buildingMap = value as Map<string, object>
        if (buildingMap && overlay instanceof Building) {
          let buildingInfo: BuildingInfo = {}
          if (isNumber(buildingMap.get('height'))) {
            buildingInfo.height = Number(buildingMap.get('height'))
          }
          if (isNumber(buildingMap.get('accuracy'))) {
            buildingInfo.accuracy = Number(buildingMap.get('accuracy'))
          }
          if (isString(buildingMap.get('paths'))) {
            buildingInfo.geom = String(buildingMap.get('paths'))
          }
          if (isNumber(buildingMap.get('structId'))) {
            buildingInfo.structId = String(buildingMap.get('structId'))
          }
          if (isNumber(buildingMap.get('label'))) {
            buildingInfo.label = Number(buildingMap.get('label'))
          }
          let centerMap = toMap(buildingMap.get('center'))
          if (centerMap) {
            let longitude = centerMap.get('longitude')
            let latitude = centerMap.get('latitude')
            buildingInfo.center = String(longitude) + ',' + String(latitude)
          }
          overlay.setBuildingInfo(buildingInfo)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }
}
