import { CustomMapStyleCallBack } from '@bdmap/map';
import { MethodResult } from '@ohos/flutter_ohos';
import { BMFMapController } from '../../BMFMapController';
import { AnyValue } from '../../util/Constants';
import { isBoolean, isString, toMap } from '../../util/FlutterDataConvert';
import LogUtil from '../../util/LogUtil';
import { CustomMapMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';

export default class MapCustomHandler extends MapBaseHandler {
  private isEnabled = false
  private styleCallBack: CustomMapStyleCallBack | undefined

  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    switch (this.method) {
      case CustomMapMethod.MapSetCustomMapStyleEnableMethod:
        if (this.mapController && this.call && isBoolean(this.call.argument('enable'))) {
          this.isEnabled = Boolean(this.call.argument('enable'))
          this.mapController.setCustomStyleEnable(this.isEnabled)
          this.success()
          return
        }
        this.fail()
        break
      case CustomMapMethod.MapSetCustomMapStylePathMethod:
        if (this.mapController && this.call) {
          let path = this.call.argument('path') as String
          if (isString(path)) {
            this.mapController.initCustomStyle('flutter_assets/' + String(path), () => {
              this.mapController?.setCustomStyleEnable(this.isEnabled)
              this.success()
            }, true)
          } else {
            LogUtil.error(`个性化地图路径错误:${path}`)
            this.fail()
          }
        } else {
          this.fail()
        }
        break
      case CustomMapMethod.MapSetCustomMapStyleWithOptionMethod:
        this.setOnlineCustomMapStyle()
        break
      default:
        this.fail()
        break
    }
  }

  setOnlineCustomMapStyle() {
    if (this.call && this.mapController) {
      let optionMap = toMap(this.call.argument('customMapStyleOption'))
      if (optionMap) {
        let styId = optionMap.get('customMapStyleID')
        if (isString(styId)) {
          if (!this.styleCallBack) {
            this.styleCallBack = new CustomMapStyleCallbackImpl(this.result)
          }
          this.mapController.setCustomStyleById(String(styId), this.styleCallBack)
        }
      }
    }
  }
}

class CustomMapStyleCallbackImpl implements CustomMapStyleCallBack {
  isPreloaded: boolean = false
  preloadPath: string | null = ''
  result?: MethodResult

  constructor(result: MethodResult | undefined) {
    this.result = result
  }

  onPreLoadLastCustomMapStyle(path: string | null) {
    this.isPreloaded = true
    this.preloadPath = path
    return false;
  }

  onCustomMapStyleLoadSuccess(hasUpdate: boolean, path: string | null) {
    let resultMap = new Map<string, AnyValue>()
    resultMap.set('styHasUpdate', String(hasUpdate))
    resultMap.set('successPath', path)
    if (this.isPreloaded) {
      resultMap.set('preloadPath', this.preloadPath)
    }
    this.result?.success(resultMap)
    return false;
  }

  onCustomMapStyleLoadFailed(status: number, message: string, path: string | null) {
    let resultMap = new Map<string, AnyValue>()
    resultMap.set('errorCode', status.toString())
    resultMap.set('errorPath', path)
    if (this.isPreloaded) {
      resultMap.set('preloadPath', this.preloadPath)
    }
    this.result?.success(resultMap)
    return true;
  }
}