import { ITrackOption, SysEnum, TraceAnimationListener, Track } from '@bdmap/map';
import { BMFMapController } from '../../BMFMapController';
import { TrackMethod } from '../MethodConst';
import OverlayBaseHandler from './OverlayBaseHandler';
import FlutterDataConvert, { checkColor, isBoolean, isNumber, isString, toMap } from '../../util/FlutterDataConvert';
import { LatLng } from '@bdmap/base';
import { AnyValue } from '../../util/Constants';
import NativeDataConvert from '../../util/NativeDataConvert';


export default class TrackHandler extends OverlayBaseHandler<Track> {
  constructor(controller: BMFMapController) {
    super(controller)
  }

  handleOverlayClick(overlay: Track): void {
  }

  handleUpdate(member: string, value: object, overlay: Track): void {
    throw new Error('Method not implemented.');
  }

  handleMethod(): void {
    switch (this.method) {
      case TrackMethod.AddTrackMethod:
        this.addTrack()
        break
      case TrackMethod.RemoveTrackMethod:
        this.removeTrack()
        break
      case TrackMethod.PauseTrackMethod:
        this.pauseTrack()
        break
      case TrackMethod.ResumeTrackMethod:
        this.resumeTrack()
        break
      default:
        this.fail()
        break
    }
  }

  addTrack() {
    if (this.call && this.mapController) {
      let id: string = this.call.argument('id')
      let coordinatesArray = this.call.argument('coordinates') as Array<Map<string, object>>
      if (isString(id) && !this.overlayMap.has(id) && coordinatesArray instanceof Array) {


        let points = FlutterDataConvert.listToLatLng(coordinatesArray)
        if (points && points.length > 0) {

          let trackOption: ITrackOption = {
            points: points
          }
          // 默认普通轨迹
          trackOption.trackType = SysEnum.TrackType.Track

          let width = this.call.argument('width') as number
          if (isNumber(width)) {
            trackOption.width = width
          }

          trackOption.color = checkColor(this.call.argument('strokeColor'))

          let isGradientColor = this.call.argument('isGradientColor') as boolean
          if (isBoolean(isGradientColor) && isGradientColor) {
            let strokeColors = this.call.argument('strokeColors') as Array<string>
            if (strokeColors instanceof Array && strokeColors.length > 0) {
              let strokeColorsArray: Array<string> = []
              strokeColors.forEach((colorStr) => {
                strokeColorsArray.push(checkColor(colorStr))
              })
              if (strokeColorsArray.length > 0) {
                trackOption.gradientColors = strokeColorsArray
                trackOption.trackType = SysEnum.TrackType.TrackGradient
              }
            }
          }

          let animMap = toMap(this.call.argument('traceOverlayAnimateOption'))
          if (animMap) {
            let duration = animMap.get('duration') as number
            if (isNumber(duration)) {
              trackOption.animationTime = duration * 1000
            }

            let trackMove = animMap.get('trackMove') as boolean
            if (isBoolean(trackMove)) {
              trackOption.trackMove = trackMove
            }
          }

          if (isNumber(this.call.argument('zIndex'))) {
            trackOption.zIndex = Number(this.call.argument('zIndex'))
          }
          if (isBoolean(this.call.argument('visible'))) {
            trackOption.visible = Boolean(this.call.argument('visible'))
          }

          let traceAnimationListener: TraceAnimationListener = {
            /**
             * 轨迹动画更新进度回调
             * @param percent 轨迹动画更新进度，取值范围 [0, 100]（0 表示开始，100 表示结束）
             */
            onTraceAnimationUpdate: (percent: number) => {
              if (this.call) {
                let resultMap = new Map<string, AnyValue>()
                resultMap.set('progress', percent)
                resultMap.set('traceOverlay', this.call.args)
                if (percent === 0) {
                  this.invoke(TrackMethod.TrackAnimationStartCallback, resultMap)
                }
                this.invoke(TrackMethod.TrackAnimationProgressCallback, resultMap)
              }
            },

            /**
             * 轨迹动画当前位置更新回调
             * @param position 轨迹动画当前帧的位置坐标（经纬度信息）
             */
            onTraceUpdatePosition: (position: LatLng) => {
              let resultMap = NativeDataConvert.latLngToMap(position, true)
              if (resultMap) {
                this.invoke(TrackMethod.TrackAnimationUpdatePositionCallback, resultMap)
              }
            },

            /**
             * 轨迹动画结束回调
             * 当动画播放完成（包括正常结束、手动停止）时触发
             */
            onTraceAnimationFinish: () => {
              if (this.call) {
                let resultMap = new Map<string, AnyValue>()
                resultMap.set('flag', true)
                resultMap.set('traceOverlay', this.call.args)
                this.invoke(TrackMethod.TrackAnimationEndCallback, resultMap)
              }
            }
          }
          trackOption.traceAnimationListener = traceAnimationListener


          let track = new Track(trackOption)
          this.setExtraInfo(track, 'id', id)
          let customInfo: object = this.call.argument('customMap')
          if (customInfo) {
            this.setExtraInfo(track, 'customMap', customInfo)
          }
          this.mapController.addOverlay(track);
          this.overlayMap.set(id, track)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  removeTrack() {
    if (this.call) {
      let id = this.call.argument('id') as string
      if (isString(id) && this.overlayMap && this.overlayMap.has(id)) {
        let overlay = this.overlayMap.get(id)
        if (overlay && !overlay.isRemoved() && !overlay.isDestroyed) {
          overlay.remove()
          this.overlayMap.delete(id)
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  pauseTrack() {
    if (this.call) {
      let id = this.call.argument('id') as string
      if (isString(id) && this.overlayMap && this.overlayMap.has(id)) {
        let overlay = this.overlayMap.get(id)
        if (overlay instanceof Track && !overlay.isRemoved() && !overlay.isDestroyed) {
          (overlay as Track).pause()
          this.success()
          return
        }
      }
    }
    this.fail()
  }

  resumeTrack() {
    if (this.call) {
      let id = this.call.argument('id') as string
      if (isString(id) && this.overlayMap && this.overlayMap.has(id)) {
        let overlay = this.overlayMap.get(id)
        if (overlay instanceof Track && !overlay.isRemoved() && !overlay.isDestroyed) {
          (overlay as Track).resume()
          this.success()
          return
        }
      }
    }
    this.fail()
  }
}
