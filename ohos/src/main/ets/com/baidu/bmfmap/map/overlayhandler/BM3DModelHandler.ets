import { Bd_3DModel, SysEnum } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { BM3DModelMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';
import fs from '@ohos.file.fs';
import LogUtil from '../../util/LogUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { AnyValue } from '../../util/Constants';


export default class BM3DModelHandler extends OverlayBaseHandler<Bd_3DModel> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Bd_3DModel): void {

  }

  handleMethod(): void {
    switch (this.method) {
      case BM3DModelMethod.Add3DModelMethod:
        this.add3DModel()
        break
      case BM3DModelMethod.Update3DModelMember:
        this.updateOverlay()
        break
      default:
        this.fail()
        break
    }
  }

  async add3DModel() {
    if (this.call && this.mapController) {
      let id = this.call.argument('id') as string
      let optionMap = toMap(this.call.argument('option'))
      let center = FlutterDataConvert.mapToLatLng(toMap(this.call.argument('center')))
      if (isString(id) && !this.overlayMap.has(id) && center && optionMap) {
        let path = optionMap.get('modelPath') as string
        let modelName = optionMap.get('modelName') as string
        if (isString(path) && isString(modelName) && this.context) {

          // 将源目录的model资源拷贝到指定目录下
          let modelPath = `${this.context.tempDir}/model3d`

          try {
            let srcPath = `flutter_assets/${path}`
            await this.copyRawFile(srcPath, '', modelPath)
          } catch (error) {
            this.fail()
            LogUtil.error(`BDMapSDKException：add3DModel failed,error=${error.message},stack=${error.stack}`)
            return
          }
          let model3D = new Bd_3DModel({
            position: center,
            modelPath: modelPath,
            modelName: modelName
          })
          this.setOption(optionMap, model3D)

          let visible = this.call.argument('visible') as boolean
          if (isBoolean(visible)) {
            model3D.setVisible(visible)
          }
          let zIndex = this.call.argument('zIndex') as number
          if (isNumber(zIndex)) {
            model3D.setZIndex(zIndex)
          }

          this.setExtraInfo(model3D, 'id', id)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(model3D, 'customMap', customInfo)
          }
          this.mapController.addOverlay(model3D);
          this.overlayMap.set(id, model3D)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  async handleUpdate(member: string, value: object, overlay: Bd_3DModel): Promise<void> {
    switch (member) {
      case 'center':
        let center = FlutterDataConvert.mapToLatLng(toMap(value))
        if (center) {
          overlay.setPosition(center)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'option':
        let optionMap = toMap(value)
        if (optionMap) {
          let path = optionMap.get('modelPath') as string
          let modelName = optionMap.get('modelName') as string
          if (isString(path) && isString(modelName) && this.context) {
            // 将源目录的model资源拷贝到指定目录下
            let modelPath = `${this.context.tempDir}/model3d`
            try {
              let srcPath = `flutter_assets/${path}`
              await this.copyRawFile(srcPath, '', modelPath)
              overlay.setModelName(modelName)
              overlay.setModelPath(modelPath)
            } catch (error) {
              this.fail()
              LogUtil.error(`BDMapSDKException：update 3DModel path failed,error=${error.message},stack=${error.stack}`)
              return
            }
          }
          this.setOption(optionMap, overlay)
          overlay.update()
          this.success()
          return
        }
        this.fail()
        break
      case 'optionAndcenter':
        let argsMap = toMap(value)
        if (argsMap) {
          let center = FlutterDataConvert.mapToLatLng(toMap(argsMap.get('center')))
          if (center){
            overlay.setPosition(center)
          }
          let optMap = toMap(argsMap.get('option'))
          if (optMap) {
            let path = optMap.get('modelPath') as string
            let modelName = optMap.get('modelName') as string
            if (isString(path) && isString(modelName) && this.context) {
              // 将源目录的model资源拷贝到指定目录下
              let modelPath = `${this.context.tempDir}/model3d`
              try {
                let srcPath = `flutter_assets/${path}`
                await this.copyRawFile(srcPath, '', modelPath)
                overlay.setModelName(modelName)
                overlay.setModelPath(modelPath)
              } catch (error) {
                this.fail()
                LogUtil.error(`BDMapSDKException：update 3DModel path failed,error=${error.message},stack=${error.stack}`)
                return
              }
            }
            this.setOption(optMap, overlay)
            overlay.update()
            this.success()
            return
          }
        }
        this.fail()
        break
      default:
        this.fail()
        break
    }
  }

  setOption(optionMap: Map<string, AnyValue>, model3D: Bd_3DModel) {
    let scale = optionMap.get('scale') as number
    if (isNumber(scale)) {
      model3D.setScale(scale)
    }
    let zoomFixed = optionMap.get('zoomFixed') as boolean
    if (isBoolean(zoomFixed)) {
      model3D.setZoomFixed(zoomFixed)
    }
    let type = optionMap.get('type') as number
    if (isNumber(type)) {
      if (type === 0) {
        model3D.setBM3DModelType(SysEnum.BM3DModelType.BM3DModelTypeObj)
      } else if (type === 1) {
        model3D.setBM3DModelType(SysEnum.BM3DModelType.BM3DModelTypeglTF)
      }
    }
    let animationIsEnable = optionMap.get('animationIsEnable') as boolean
    if (isBoolean(animationIsEnable)) {
      model3D.setSkeletonAnimationEnable(animationIsEnable)
    }
    let animationSpeed = optionMap.get('animationSpeed') as number
    if (isNumber(animationSpeed)) {
      model3D.setAnimationSpeed(animationSpeed)
    }
    let animationRepeatCount = optionMap.get('animationRepeatCount') as number
    if (isNumber(animationRepeatCount)) {
      model3D.setAnimationRepeatCount(animationRepeatCount)
    }
    let animationIndex = optionMap.get('animationIndex') as number
    if (isNumber(animationIndex)) {
      model3D.setAnimationIndex(animationIndex)
    }
    let rotateX = optionMap.get('rotateX') as number
    let rotateY = optionMap.get('rotateY') as number
    let rotateZ = optionMap.get('rotateZ') as number
    model3D.setRotate(isNumber(rotateX) ? rotateX : 0, isNumber(rotateY) ? rotateY : 0,
      isNumber(rotateZ) ? rotateZ : 0)

    let offsetX = optionMap.get('offsetX') as number
    let offsetY = optionMap.get('offsetY') as number
    let offsetZ = optionMap.get('offsetZ') as number
    model3D.setOffset(isNumber(offsetX) ? offsetX : 0, isNumber(offsetY) ? offsetY : 0,
      isNumber(offsetZ) ? offsetZ : 0)
  }

  createDir(path: string) {
    try {
      fs.mkdirSync(path)
      // LogUtil.debug(`create dir success：${path}`)
    } catch (e) {
      let error = e as BusinessError
      // 13900015代表文件已存在
      if (error.code !== 13900015) {
        LogUtil.error(`create ${path} dir failed,error=${error.code + ',' + error.message},stack=${error.stack}`)
        throw new Error('BDMapSDKException: createDir 3DModel dir failed');
      }
    }
  }

  async copyRawFile(srcPath: string, rawFileName: string, targetPath: string) {
    // LogUtil.debug(`srcPath=${srcPath},rawFileName=${rawFileName},targetPath=${targetPath}`)
    if (!this.context) {
      return
    }

    if (this.context.resourceManager.isRawDir(`${srcPath}/${rawFileName}`)) {
      // LogUtil.debug(`${srcPath}/${rawFileName}, is Dir`)
      // 创建对应的目录
      this.createDir(`${targetPath}/${rawFileName}`)
      let newSrcPath = isString(rawFileName) ? `${srcPath}/${rawFileName}` : srcPath
      let newTargetPath = isString(rawFileName) ? `${targetPath}/${rawFileName}` : targetPath
      let fileArray = this.context.resourceManager.getRawFileListSync(newSrcPath)
      if (fileArray) {
        fileArray.forEach(async (fileName) => {
          await this.copyRawFile(newSrcPath, fileName, newTargetPath)
        })
      }
    } else {
      // LogUtil.debug(`${rawFileName} is File`)
      const dstPath = `${targetPath}/${rawFileName}`;
      // LogUtil.debug(`dstPath=${dstPath}`)
      try {
        // 读取 rawfile 内容
        const data = await this.context.resourceManager.getRawFileContent(`${srcPath}/${rawFileName}`);
        // 写入沙盒文件
        const file = fs.openSync(dstPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
        fs.writeSync(file.fd, data.buffer);
        fs.closeSync(file.fd);
        // LogUtil.debug(`[Model3D] 写入文件: ${dstPath}`);
      } catch (e) {
        let error = e as BusinessError
        LogUtil.error(`write ${rawFileName} failed,error=${error.code + ',' + error.message},stack=${error.stack}`)
        throw new Error('BDMapSDKException: copy 3DModel files failed');
      }
    }
  }
}
