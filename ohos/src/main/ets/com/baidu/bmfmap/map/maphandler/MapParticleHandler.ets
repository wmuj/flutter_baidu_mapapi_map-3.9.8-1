import { ImageEntity, ParticleOptions } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import FlutterDataConvert, { isNumber, toMap } from '../../util/FlutterDataConvert';
import { ParticleMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';
import image from '@ohos.multimedia.image';
import List from '@ohos.util.List';
import LogUtil from '../../util/LogUtil';

export default class MapParticleHandler extends MapBaseHandler {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    if (this.call && this.mapController) {
      switch (this.method) {
        case ParticleMethod.ShowMapParticleMethod:
          if (isNumber(this.call.argument('effect'))) {
            this.mapController.showParticleEffectByType(Number(this.call.argument('effect')))
            this.success()
            return
          }
          this.fail()
          break
        case ParticleMethod.CloseMapParticleMethod:
          if (isNumber(this.call.argument('effect'))) {
            this.mapController.closeParticleEffectByType(Number(this.call.argument('effect')))
            this.success()
            return
          }
          this.fail()
          break
        case ParticleMethod.CustomMapParticleMethod:
          if (isNumber(this.call.argument('effect'))) {
            let optionMap = toMap(this.call.argument('option'))
            if (optionMap) {
              let option: ParticleOptions = new ParticleOptions()
              let location = FlutterDataConvert.mapToLatLng(toMap(optionMap.get('location')))
              if (location) {
                option.setParticlePos(location)
              }
              let imagesObj = optionMap.get('images')
              if (imagesObj instanceof Array) {
                let imagesArray = imagesObj as Array<string>
                let particleImgArray: Array<image.PixelMap> = []
                let count = 0;
                imagesArray.forEach((itemPath, index) => {
                  if (itemPath) {
                    new ImageEntity('rawfile://flutter_assets/' +
                    String(itemPath), { scaleDpi: true }).getPixesMap((pixelMap: image.PixelMap) => {
                      if (pixelMap) {
                        particleImgArray[index] = pixelMap
                        count++
                        if (count === imagesArray.length) {
                          option.setParticleImgs(particleImgArray)
                          this.mapController?.customParticleEffectByType(Number(this.call?.argument('effect')), option)
                          this.success()
                        }
                      } else {
                        LogUtil.error(`custom particle error,itemPath=${itemPath},getPixesMap exception`)
                        this.fail()
                        return
                      }
                    })
                  } else {
                    LogUtil.error(`custom particle error,itemPath=${itemPath}`)
                    this.fail()
                    return
                  }
                })
              } else {
                this.fail()
              }
            } else {
              this.fail()
            }
          } else {
            this.fail()
          }
          break
        default:
          this.fail()
          break
      }
    } else {
      this.fail()
    }
  }
}