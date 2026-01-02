import { LatLng } from '@bdmap/base';
import { Arc, Circle, Ground, MapStatus, Marker, Overlay, Polygon, Polyline, SysEnum } from '@bdmap/map';
import { List } from '@kit.ArkTS';
import { AnyValue } from './Constants';

/**
 * 将原生层对象转换为Flutter层参数
 */
export default class NativeDataConvert {
  static latLngToMap(position: LatLng | undefined | null, isNeedMapKey?: boolean,
    mapKey: string = 'coord'): Nullable<Map<string, AnyValue>> {
    let resultMap: Map<string, AnyValue> | undefined
    if (position) {
      let map: Map<string, number> = new Map;
      map.set('latitude', position.lat);
      map.set('longitude', position.lng);
      if (isNeedMapKey) {
        resultMap = new Map<string, AnyValue>()
        resultMap.set(mapKey, map);
        return resultMap
      } else {
        return map
      }
    }
    return
  }

  static mapStatusToMap(mapStatus: MapStatus): Map<string, object | number> {

    //屏幕中心点像素位置  TODO 目前鸿蒙不支持
    // let targetScreenMap: Map<string, number> = new Map()
    // targetScreenMap.set('x', 360)
    // targetScreenMap.set('y', 270)
    //屏幕中心点坐标
    let targetGeoMap: Map<string, number> = new Map
    targetGeoMap.set('latitude', mapStatus.centerPoint.lat)
    targetGeoMap.set('longitude', mapStatus.centerPoint.lng)
    //东北、西南角坐标
    let boundsMap: Map<string, object> = new Map
    if (mapStatus.geoRound.ne) {
      let northeastMap: Map<string, number> = new Map
      northeastMap.set('latitude', mapStatus.geoRound.ne.lat)
      northeastMap.set('longitude', mapStatus.geoRound.ne.lng)
      boundsMap.set('northeast', northeastMap)
    }
    if (mapStatus.geoRound.sw) {
      let southwestMap: Map<string, number> = new Map
      southwestMap.set('latitude', mapStatus.geoRound.sw.lat)
      southwestMap.set('longitude', mapStatus.geoRound.sw.lng)
      boundsMap.set('southwest', southwestMap)
    }
    //地图状态
    let statusMap: Map<string, object | number> = new Map
    statusMap.set('fLevel', mapStatus.level)
    if (mapStatus.rotate > 180) {
      statusMap.set('fRotation', mapStatus.rotate - 360)
    } else {
      statusMap.set('fRotation', mapStatus.rotate)
    }
    statusMap.set('fOverlooking', -Math.abs(mapStatus.overlooking))
    let resultMap: Map<string, object | number> = new Map
    // statusMap.set('targetScreenPt', targetScreenMap)
    statusMap.set('targetGeoPt', targetGeoMap)
    statusMap.set('visibleMapBounds', boundsMap)
    resultMap.set('mapStatus', statusMap)
    return resultMap;
  }

  static baseOverlayToMap(overlay: Overlay): Nullable<Map<string, AnyValue>> {
    if (overlay) {
      let overlayMap: Map<string, AnyValue> = new Map
      if (overlay.getExtraInfo()) {
        let keys = Object.keys(overlay.getExtraInfo())
        if (keys) {
          keys.forEach(key => {
            // 将flutter传递的原始数据，回传给flutter
            overlayMap.set(key, overlay.getExtraInfo()[key])
          })
        }
      }
      // overlay基本属性
      overlayMap.set('zIndex', overlay.getZIndex())
      overlayMap.set('visible', overlay.getVisible())
      overlayMap.set('clickable', overlay.getClickable())
      return overlayMap
    }
    return
  }

  static polygonToMap(overlay: Polygon): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      resultMap.set('width', overlay.getStroke().strokeWidth)
      resultMap.set('lineDashType', overlay.getStroke().getStrokeStyle().valueOf())

      let pointsArray = overlay.getPoints();
      if (pointsArray instanceof Array && pointsArray.length > 0) {
        let list = new List<object>()
        pointsArray.forEach(((value) => {
          let pointMap = NativeDataConvert.latLngToMap(value)
          if (pointMap) {
            list.add(pointMap)
          }
        }))
        resultMap.set('coordinates', list)
      }
    }
    return resultMap
  }

  static circleToMap(overlay: Circle): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      resultMap.set('width', overlay.getStroke().strokeWidth)
      resultMap.set('lineDashType', overlay.getStroke().getStrokeStyle().valueOf())
      let centerMap = new Map<string, number>()
      centerMap.set("latitude", overlay.getCenter().lat);
      centerMap.set("longitude", overlay.getCenter().lng);
      resultMap.set("center", centerMap);
      resultMap.set("radius", overlay.getRadius());
    }
    return resultMap;
  }

  static markerToMap(overlay: Marker): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      let positionMap = NativeDataConvert.latLngToMap(overlay.getPosition())
      if (positionMap) {
        resultMap.set('position', positionMap)
      }
      resultMap.set('isLockedToScreen', overlay.getFixedScreen())
      let centerOffsetMap: Map<string, number> = new Map
      centerOffsetMap.set('x', overlay.getXOffset())
      centerOffsetMap.set('y', overlay.getYOffset())
      resultMap.set('centerOffset', centerOffsetMap)

      resultMap.set('enabled', overlay.getClickable());
      resultMap.set('draggable', overlay.getDraggable());
      resultMap.set('scaleX', overlay.getScaleX());
      resultMap.set('scaleY', overlay.getScaleY());
      resultMap.set('alpha', overlay.getAlpha());
      resultMap.set('isPerspective', overlay.getPerspective());
      resultMap.set('isOpenCollisionDetection', overlay.getIsJoinCollision() != SysEnum.CollisionBehavior.NOT_COLLIDE);
      resultMap.set('collisionDetectionPriority', overlay.getPriority());
      resultMap.set('isForceDisplay', overlay.getIsJoinCollision() == SysEnum.CollisionBehavior.ALWAYS_SHOW);
    }
    return resultMap;
  }

  static groundToMap(overlay: Ground): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      let boundsMap: Map<string, object> = new Map
      // 西南
      let southwestMap: Map<string, number> = new Map
      southwestMap.set('latitude', overlay.getBound()[0].lat)
      southwestMap.set('longitude', overlay.getBound()[0].lng)
      boundsMap.set('southwest', southwestMap)
      // 东北
      let northeastMap: Map<string, number> = new Map
      northeastMap.set('latitude', overlay.getBound()[1].lat)
      northeastMap.set('longitude', overlay.getBound()[1].lng)
      boundsMap.set('northeast', northeastMap)
      resultMap.set('bounds', boundsMap)
      resultMap.set('anchorX', overlay.getAnchor().anchorx);
      resultMap.set('anchorX', overlay.getAnchor().anchory);
      resultMap.set('transparency', overlay.getTransparency());
    }
    return resultMap;
  }

  static arcLineToMap(overlay: Arc): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      resultMap.set('width', overlay.getWidth());
      if (overlay.getStartPoint() && overlay.getMiddlePoint() && overlay.getEndPoint()) {
        let pointArray = new Array<Map<string, AnyValue>>()
        let startMap = NativeDataConvert.latLngToMap(overlay.getStartPoint())
        if (startMap) {
          pointArray.push(startMap)
        }
        let middleMap = NativeDataConvert.latLngToMap(overlay.getMiddlePoint())
        if (middleMap) {
          pointArray.push(middleMap)
        }
        let endMap = NativeDataConvert.latLngToMap(overlay.getEndPoint())
        if (endMap) {
          pointArray.push(endMap)
        }
        resultMap.set('coordinates', pointArray)
      }
    }
    return resultMap;
  }

  static polylineToMap(overlay: Polyline): Nullable<Map<string, AnyValue>> {
    let resultMap = NativeDataConvert.baseOverlayToMap(overlay)
    if (resultMap) {
      let pointsArray = overlay.getPoints();
      if (pointsArray && pointsArray.length > 0) {
        let list = new List<object>()
        pointsArray.forEach(((value) => {
          let pointMap = NativeDataConvert.latLngToMap(value)
          if (pointMap) {
            list.add(pointMap)
          }
        }))
        resultMap.set('coordinates', list)
      }

      resultMap.set('dottedLine', overlay.getIsDotted())
      resultMap.set('lineDashType', overlay.getDottedLineType().valueOf())
      resultMap.set('lineCapType', overlay.getCapType() == SysEnum.LineCapType.BUTT ? 0 : 1)
      let joinType = overlay.getJoinType()
      if (joinType == SysEnum.LineJoinType.BEVEL) {
        resultMap.set('lineJoinType', 0)
      } else if (joinType == SysEnum.LineJoinType.MITER) {
        resultMap.set('lineJoinType', 1)
      } else if (joinType == SysEnum.LineJoinType.ROUND) {
        resultMap.set('lineJoinType', 2)
      } else if (joinType == SysEnum.LineJoinType.BERZIER) {
        resultMap.set('lineJoinType', 3)
      }
      resultMap.set('width', overlay.getWidth())
      resultMap.set('lineDirectionCross180', overlay.getDirectionCross180().valueOf())
      resultMap.set('isThined', overlay.getIsThined())
      resultMap.set('isKeepScale',
        overlay.getTextureOption().valueOf() == SysEnum.TextureOption.SCALE_TEXTURE ? true : false)
      resultMap.set('lineBloomMode', overlay.getLineBloomType().valueOf())
      resultMap.set('lineBloomWidth', overlay.getLineBloomWidth())
      resultMap.set('lineBloomAlpha', overlay.getLineBloomAlpha())
      resultMap.set('lineBloomGradientASPeed', overlay.getLineBloomGradientASPeed())
      resultMap.set('indexs', overlay.getIndexList())


    }
    return resultMap
  }
}