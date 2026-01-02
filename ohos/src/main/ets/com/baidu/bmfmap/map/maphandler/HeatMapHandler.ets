import { Nullable, WeightedLatLng } from '@bdmap/base';
import { Gradient, HeatMap, HeatMapAnimation, HeatMapBuilder } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import FlutterDataConvert, { isBoolean, isNumber, toMap } from '../../util/FlutterDataConvert';
import { HeatMapMethod } from '../MethodConst';
import MapBaseHandler from './MapBaseHandler';
import { systemDateTime } from '@kit.BasicServicesKit';
import { AnyValue } from '../../util/Constants';

export default class HeatMapHandler extends MapBaseHandler {
  sHeatMap: HeatMap | null = null

  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleMethod(): void {
    if (!this.mapController || !this.call) {
      this.fail()
      return
    }
    switch (this.method) {
      case HeatMapMethod.AddHeatMapMethod:
        this.addAndUpdateHeatMap(true)
        break
      case HeatMapMethod.UpdateHeatmapMethod:
        this.addAndUpdateHeatMap(false)
        break
      case HeatMapMethod.RemoveHeatMapMethod:
        if (this.sHeatMap) {
          this.sHeatMap.removeHeatMap()
          this.sHeatMap = null
          this.success()
        } else {
          this.fail()
        }
        break
      case HeatMapMethod.ShowHeatMapMethod:
        if (isBoolean(this.call.argument('show'))) {
          this.mapController.setBaiduHeatMapEnabled(Boolean(this.call.argument('show')))
          this.success()
        } else {
          this.fail()
        }
        break
      case HeatMapMethod.StartHeatFrameAnimationMethod:
        this.mapController.startHeatMapFrameAnimation()
        this.success()
        break
      case HeatMapMethod.StopHeatFrameAnimationMethod:
        this.mapController.stopHeatMapFrameAnimation()
        this.success()
        break
      case HeatMapMethod.SetHeatFrameAnimationIndexMethod:
        if (isNumber(this.call.argument('index'))) {
          this.mapController.setHeatMapFrameAnimationIndex(Number(this.call.argument('index')))
          this.success()
        } else {
          this.fail()
        }
        break
      case HeatMapMethod.HeatMapFrameAnimationIndexCallbackMethod:
        this.fail() // 鸿蒙暂不支持
        break
      default:
        this.fail()
        break
    }
  }

  addAndUpdateHeatMap(isAdd: boolean) {
    if (this.call && this.mapController) {
      let startTime = systemDateTime.getTime()
      let optionMap = toMap(this.call.argument('heatMap'))
      if (optionMap) {
        let builder = new HeatMapBuilder()

        let weightedLatLng = this.getData(optionMap)
        if (weightedLatLng) {
          if (isAdd) {
            builder.setData(weightedLatLng)
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.setWeightedData(weightedLatLng)
            }
          }
        }

        let weightedLatLngS = this.getDataS(optionMap)
        if (weightedLatLngS) {
          if (isAdd) {
            builder.setDatas(weightedLatLngS)
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.setWeightedDatas(weightedLatLngS)
            }
          }
        }

        let heatMapGradient = this.getHeatMapGradient(toMap(optionMap.get('gradient')))
        if (heatMapGradient) {
          if (isAdd) {
            builder.gradientValue(heatMapGradient)
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateGradient(heatMapGradient)
            }
          }
        }

        if (isNumber(optionMap.get('opacity'))) {
          if (isAdd) {
            builder.opacityValue(Number(optionMap.get('opacity')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateOpacity(Number(optionMap.get('opacity')))
            }
          }
        }

        if (isNumber(optionMap.get('mMaxHight'))) {
          if (isAdd) {
            builder.maxHighValue(Number(optionMap.get('mMaxHight')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateMaxHigh(Number(optionMap.get('mMaxHight')))
            }
          }
        }

        if (isNumber(optionMap.get('mMaxIntensity'))) {
          if (isAdd) {
            builder.maxIntensityValue(Number(optionMap.get('mMaxIntensity')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateMaxIntensity(Number(optionMap.get('mMaxIntensity')))
            }
          }
        }

        if (isNumber(optionMap.get('mMinIntensity'))) {
          if (isAdd) {
            builder.minIntensityValue(Number(optionMap.get('mMinIntensity')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateMinIntensity(Number(optionMap.get('mMinIntensity')))
            }
          }
        }

        let initAnimation = this.getHeatMapAnimation(toMap(optionMap.get('animation')))
        if (initAnimation && isAdd) {
          builder.initAnimationValue(initAnimation)
        }

        let frameAnimation = this.getHeatMapAnimation(toMap(optionMap.get('frameAnimation')))
        if (frameAnimation) {
          if (isAdd) {
            builder.frameAnimationValue(frameAnimation)
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateFrameAnimation(frameAnimation)
            }
          }
        }

        if (isNumber(optionMap.get('radius'))) {
          if (isAdd) {
            builder.radiusValue(Number(optionMap.get('radius')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateRadius(Number(optionMap.get('radius')))
            }
          }
        }

        if (isNumber(optionMap.get('radiusMeter'))) {
          if (isAdd) {
            builder.radiusMeterValue(Number(optionMap.get('radiusMeter')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateRadiusMeter(Number(optionMap.get('radiusMeter')))
            }
          }
        }

        if (isBoolean(optionMap.get('radiusIsMeter'))) {
          if (isAdd) {
            builder.isRadiusMeterValue(Boolean(optionMap.get('radiusIsMeter')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateIsRadiusMeter(Boolean(optionMap.get('radiusIsMeter')))
            }
          }
        }

        if (isNumber(optionMap.get('maxShowLevel'))) {
          if (isAdd) {
            builder.maxShowLevelValue(Number(optionMap.get('maxShowLevel')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateMaxShowLevel(Number(optionMap.get('maxShowLevel')))
            }
          }
        }

        if (isNumber(optionMap.get('minShowLevel'))) {
          if (isAdd) {
            builder.minShowLevelValue(Number(optionMap.get('minShowLevel')))
          } else {
            if (this.sHeatMap) {
              this.sHeatMap.updateMinShowLevel(Number(optionMap.get('minShowLevel')))
            }
          }
        }

        if (isAdd) {
          this.sHeatMap = builder.build()
          this.mapController.addHeatMap(this.sHeatMap)
        } else {
          if (this.sHeatMap) {
            this.mapController.updateHeatMap(this.sHeatMap)
          }
        }
      }
    }
    this.fail()
  }

  getData(argsMap: Map<string, AnyValue> | undefined): Nullable<WeightedLatLng[]> {
    if (argsMap && argsMap.get('data') instanceof Array) {
      let dataArray = argsMap.get('data') as Array<Map<string, object>>
      if (dataArray) {
        let data = FlutterDataConvert.arrayToWeightedLatLng(dataArray)
        if (data) {
          return data
        }
      }
    }
    return null
  }

  getDataS(argsMap: Map<string, AnyValue> | undefined): Nullable<Array<WeightedLatLng[]>> {
    if (argsMap && argsMap.get('datas') instanceof Array) {
      const resultArray: WeightedLatLng[][] = [];
      let dataSArray = argsMap.get('datas') as Array<Array<Map<string, object>>>
      if (dataSArray && dataSArray.length > 0) {
        dataSArray.forEach(itemArray => {
          if (itemArray) {
            let data = FlutterDataConvert.arrayToWeightedLatLng(itemArray)
            if (data) {
              resultArray.push(data)
            }
          }
        })
      }
      return resultArray
    }
    return null
  }

  getHeatMapAnimation(argsMap: Map<string, AnyValue> | undefined): Nullable<HeatMapAnimation> {
    if (argsMap && argsMap.has('duration') && argsMap.has('type')) {
      let durationObj = argsMap.get('duration')
      let typeObj = argsMap.get('type')
      if (isNumber(durationObj) && isNumber(typeObj)) {
        return new HeatMapAnimation(true, Number(durationObj), Number(typeObj))
      }
    }
    return null
  }

  getHeatMapGradient(argsMap: Map<string, AnyValue> | undefined): Nullable<Gradient> {
    if (argsMap && argsMap.has('colors') && argsMap.has('startPoints')) {
      let colorsObj = argsMap.get('colors')
      let startPointsObj = argsMap.get('startPoints')
      if (colorsObj instanceof Array && startPointsObj instanceof Array) {
        let colorsArray = colorsObj as Array<string>
        let startPointsArray = startPointsObj as Array<number>
        colorsArray.forEach((item, index) => {
          colorsArray[index] = '#' + item
        })
        if (colorsArray.length > 0 && startPointsArray.length > 0) {
          return new Gradient(colorsArray, startPointsArray)
        }
      }
    }
    return null
  }
}