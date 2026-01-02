export class MapStateMethod {
  // 更新地图参数
  static MapOptionUpdateMethod = 'flutter_bmfmap/map/updateMapOptions'
  // map放大一级比例尺
  static MapZoomInMethod = 'flutter_bmfmap/map/zoomIn'
  // map缩小一级比例尺
  static MapZoomOutMethod = 'flutter_bmfmap/map/zoomOut'
  // 设置地图缩放级别
  static MapSetZoomToMethod = 'flutter_bmfmap/map/setZoomTo'
  // 更新地图状态
  static MapSetMapStatusMethod = 'flutter_bmfmap/map/setMapStatus'
  // 获取地图状态
  static MapGetMapStatusMethod = 'flutter_bmfmap/map/getMapStatus'
  // 设定地图中心点坐标
  static MapSetCenterCoordinateMethod = 'flutter_bmfmap/map/setCenterCoordinate'
  // 设置地图中心点以及缩放级别
  static MapSetCenterZoomMethod = 'flutter_bmfmap/map/setMapCenterZoom'
  // 设置显示在屏幕中的地图地理范围
  static MapSetVisibleMapBoundsMethod = 'flutter_bmfmap/map/setVisibleMapBounds'
  // 设定地图的显示范围,并使mapRect四周保留insets指定的边界区域
  static MapSetVisibleMapBoundsWithPaddingMethod = 'flutter_bmfmap/map/setVisibleMapBoundsWithPadding'
  // map加载完成
  static MapDidLoadCallback = 'flutter_bmfmap/map/mapViewDidFinishLoad'
  // 地图区域即将改变时会调用此接口
  static MapRegionWillChangeCallback = 'flutter_bmfmap/map/mapViewRegionWillChange'
  // 地图区域即将改变时会调用此接口reason
  static MapRegionWillChangeWithReasonCallback = 'flutter_bmfmap/map/mapViewRegionWillChangeWithReason'
  // 地图区域改变会调用此接口
  static MapRegionDidChangeCallback = 'flutter_bmfmap/map/mapViewRegionDidChange'
  // 地图状态改变完成后会调用此接口
  static MapStatusDidChangedCallback = 'flutter_bmfmap/map/mapViewStatusDidChanged'
  // 地图区域改变完成后会调用此接口reason
  static MapRegionDidChangeWithReasonCallback = 'flutter_bmfmap/map/mapViewRegionDidChangeWithReason'
  // 点中底图空白处会回调此接口
  static MapOnClickedMapBlankCallback = 'flutter_bmfmap/map/mapViewOnClickedMapBlank'
  // 双击地图时会回调此接口
  static MapOnDoubleClickCallback = 'flutter_bmfmap/map/mapViewOnDoubleClick'
  // 长按地图时会回调此接口
  static MapOnLongClickCallback = 'flutter_bmfmap/map/mapViewOnLongClick'
  // map渲染完成
  static MapDidFinishRenderCallback = 'flutter_bmfmap/map/mapViewDidFinishRender'
  // 地图刷新，Flutter用于主动刷新地图
  static MAP_REFRESH = 'flutter_bmfmap/map/mapRefresh'
  // 获取地图版权信息
  static MAP_COPYRIGHT_INFO = 'flutter_bmfmap/map/getMapCopyrightInformation'
  // 获取地图测绘资质
  static MAP_MAPPING_QUALIFICATION = 'flutter_bmfmap/map/getMapMappingQualification'
  // 获取基础地图审图号
  static MAP_APPROVAL_NUMBER = 'flutter_bmfmap/map/getMapApprovalNumber'
  // 地图交换图层顺序
  static WITCH_LAYER_ORDER = 'flutter_bmfmap/map/switchLayerOrder'
  // 地图View进入/移出室内图
  static MapInOrOutBaseIndoorMapCallback = 'flutter_bmfmap/map/mapViewInOrOutBaseIndoorMap'
  // 获得地图当前可视区域截图
  static MapTakeSnapshotMethod = 'flutter_bmfmap/map/takeSnapshot'
  // 获得地图指定区域截图
  static MapTakeSnapshotWithRectMethod = 'flutter_bmfmap/map/takeSnapshotWithRect'
}

/**
 * 地图获取属性方法id集合
 */
export class MapGetPropertyMethod {
  // 获取map的展示类型
  static GetMapTypeMethod = 'flutter_bmfmap/map/getMapType'
  // 获取map的语言类型
  static GetMapLanguageTypeMethod = 'flutter_bmfmap/map/getMapLanguageType'
  // 获取map的字体大小
  static GetMapFontSizeLevelMethod = 'flutter_bmfmap/map/getMapFontSizeLevel'
  // 获取map的比例尺级别
  static GetZoomLevelMethod = "flutter_bmfmap/map/getZoomLevel";
  // 获取map的自定义最小比例尺级别
  static GetMinZoomLevelMethod = 'flutter_bmfmap/map/getMinZoomLevel'
  // 获取map的自定义最大比例尺级别
  static GetMaxZoomLevelMethod = 'flutter_bmfmap/map/getMaxZoomLevel'
  // 获取map的旋转角度
  static GetRotationMethod = "flutter_bmfmap/map/getRotation";
  // 获取map的地图俯视角度
  static GetOverlookingMethod = 'flutter_bmfmap/map/getOverlooking'
  // 获取map的是否现显示3D楼块效果
  static GetBuildingsEnabledMethod = 'flutter_bmfmap/map/getBuildingsEnabled'
  // 获取map的是否打开路况图层
  static GetTrafficEnabledMethod = 'flutter_bmfmap/map/getTrafficEnabled'
  // 获取map的是否打开百度城市热力图图层
  static GetBaiduHeatMapEnabledMethod = 'flutter_bmfmap/map/getBaiduHeatMapEnabled'
  // 获取map的是否支持所有手势操作
  static GetGesturesEnabledMethod = 'flutter_bmfmap/map/getGesturesEnabled'
  // 获取map是否支持缩放
  static GetZoomEnabledMethod = 'flutter_bmfmap/map/getZoomEnabled'
  // 获取map是否支持拖拽手势
  static GetScrollEnabledMethod = 'flutter_bmfmap/map/getScrollEnabled'
  // 获取map是否支持俯仰角
  static GetOverlookEnabledMethod = 'flutter_bmfmap/map/getOverlookEnabled'
  // 获取map是否支持旋转
  static GetRotateEnabledMethod = 'flutter_bmfmap/map/getRotateEnabled'
  // 获取map的比例尺的位置
  static GetMapScaleBarPositionMethod = 'flutter_bmfmap/map/getMapScaleBarPosition'
  // 获取map的logo位置
  static GetLogoPositionMethod = 'flutter_bmfmap/map/getLogoPosition'
  // 获取map的可视范围
  static GetVisibleMapBoundsMethod = 'flutter_bmfmap/map/getVisibleMapBounds'
  // 获取map的显示室内图
  static GetBaseIndoorMapEnabledMethod = 'flutter_bmfmap/map/getBaseIndoorMapEnabled'
  // 获取map的室内图标注是否显示
  static GetShowIndoorMapPoiMethod = 'flutter_bmfmap/map/getShowIndoorMapPoi'
  // 获取map的运营图层是否显示
  static GetShowOperateLayerMethod = 'flutter_bmfmap/map/getShowOperateLayer'
}

/**
 * 屏幕坐标和地理坐标相互转换
 */
export class ProjectionMethod {
  // 屏幕坐标转地理坐标
  static FromScreenLocation = 'flutter_bmfmap/projection/coordinateFromScreenPoint'
  // 将地理坐标转换成屏幕坐标
  static ToScreenLocation = 'flutter_bmfmap/projection/screenPointfromCoordinate'
  // 将三维地理坐标转化为屏幕坐标
  static ScreenPointFromMapPoint3Dimensional = 'flutter_bmfmap/projection/screenPointFromMapPoint3'
}

/**
 * 个性化地图
 */
export class CustomMapMethod {
  // 开启个性化地图
  static MapSetCustomMapStyleEnableMethod = 'flutter_bmfmap/map/setCustomMapStyleEnable'
  // 设置个性化地图样式路径
  static MapSetCustomMapStylePathMethod = 'flutter_bmfmap/map/setCustomMapStylePath'
  // 在线个性化样式加载状态回调接口
  static MapSetCustomMapStyleWithOptionMethod = 'flutter_bmfmap/map/setCustomMapStyleWithOption'
}

/**
 * 室内地图
 */
export class IndoorMapMethod {
  // 展示室内地图
  static ShowBaseIndoorMapMethod = 'flutter_bmfmap/map/showBaseIndoorMap'
  // 室内图标注是否显示
  static ShowBaseIndoorMapPoiMethod = 'flutter_bmfmap/map/showBaseIndoorMapPoi'
  // 设置室内图楼层
  static SwitchBaseIndoorMapFloorMethod = 'flutter_bmfmap/map/switchBaseIndoorMapFloor'
  // 获取当前聚焦的室内图信息
  static GetFocusedBaseIndoorMapInfoMethod = 'flutter_bmfmap/map/getFocusedBaseIndoorMapInfo'
}

/**
 * 热力图
 */
export class HeatMapMethod {
  // 添加热力图
  static AddHeatMapMethod = 'flutter_bmfmap/heatMap/addHeatMap'
  // 更新热力图
  static UpdateHeatmapMethod = 'flutter_bmfmap/heatMap/updateHeatMap'
  // 移除热力图
  static RemoveHeatMapMethod = 'flutter_bmfmap/heatMap/removeHeatMap'
  // 是否展示热力图
  static ShowHeatMapMethod = "flutter_bmfmap/heatMap/showHeatMap";
  // 开始热力图动画
  static StartHeatFrameAnimationMethod = 'flutter_bmfmap/heatMap/startHeatFrameAnimation'
  // 停止热力图动画
  static StopHeatFrameAnimationMethod = 'flutter_bmfmap/heatMap/stopHeatFrameAnimation'
  // 控制渲染帧索引
  static SetHeatFrameAnimationIndexMethod = 'flutter_bmfmap/heatMap/setHeatFrameAnimationIndex'
  // 渲染帧索引回调
  static HeatMapFrameAnimationIndexCallbackMethod = 'flutter_bmfmap/heatMap/heatMapFrameAnimationIndexCallback'
}

export class TileMapMethod {
  // 添加瓦片图
  static AddTileMapMethod = 'flutter_bmfmap/overlay/addTile'
  // 移除瓦片图
  static RemoveTileMapMethod = 'flutter_bmfmap/overlay/removeTile'
}

/**
 * 粒子效果
 */
export class ParticleMethod {
  // 显示粒子效果
  static ShowMapParticleMethod = 'flutter_bmfmap/map/showMapParticleEffectMethod'
  // 关闭粒子效果
  static CloseMapParticleMethod = 'flutter_bmfmap/map/closeMapParticleEffectMethod'
  // 自定义粒子效果
  static CustomMapParticleMethod = 'flutter_bmfmap/map/customMapParticleEffectMethod'
}

/**
 * 海量点
 */
export class MultiPointMethod {
  // 添加multiPointOverlay
  static AddMultipointOverlayMethod = 'flutter_bmfmap/overlay/addMultiPointOverlay'
}

/**
 * 动态轨迹
 */
export class TrackMethod{
  // 添加track
  static AddTrackMethod = 'flutter_bmfmap/overlay/addTraceOverlay'
  // 移除track
  static RemoveTrackMethod = 'flutter_bmfmap/overlay/removeTraceOverlay'
  // 暂停轨迹动画绘制
  static PauseTrackMethod = 'flutter_bmfmap/overlay/pauseTraceOverlayDraw'
  // 继续轨迹动画绘制
  static ResumeTrackMethod = 'flutter_bmfmap/overlay/resumeTraceOverlayDraw'
  // 动态轨迹动画开始
  static TrackAnimationStartCallback = 'flutter_bmfmap/overlay/traceOverlayAnimationDidStart'
  // 动态轨迹动画进度
  static TrackAnimationProgressCallback = 'flutter_bmfmap/overlay/traceOverlayAnimationRunningProgress'
  // 动态轨迹动画结束
  static TrackAnimationEndCallback = 'flutter_bmfmap/overlay/traceOverlayAnimationDidEnd'
  // 动态轨迹动画更新当前位置
  static TrackAnimationUpdatePositionCallback = 'flutter_bmfmap/overlay/traceOverlayAnimationUpdatePosition'
}


/**
 * Circle
 */
export class CircleMethod {
  // 添加circle
  static AddCircleMethod = 'flutter_bmfmap/overlay/addCircle'
  // 更新circle属性
  static UpdateCircleMemberMethod = 'flutter_bmfmap/overlay/updateCircleMember'
  // 添加渐变圆
  static ADD_GRADIENT_CIRCLE_METHOD = 'flutter_bmfmap/overlay/addGradientCircle'
}

/**
 * 多边形
 */
export class PolygonMethod {
  // 添加polygon
  static AddPolygonMethod = 'flutter_bmfmap/overlay/addPolygon'
  // 更新polygon属性
  static UpdatePolygonMemberMethod = 'flutter_bmfmap/overlay/updatePolygonMember'
}

/**
 * Marker
 */
export class MarkerMethod {
  // 添加marker
  static AddMarkerMethod = 'flutter_bmfmap/marker/addMarker'
  // 添加markers
  static AddMarkersMethod = 'flutter_bmfmap/marker/addMarkers'
  // 删除marker
  static RemoveMarkerMethod = 'flutter_bmfmap/marker/removeMarker'
  // 删除markers
  static RemoveMarkersMethod = 'flutter_bmfmap/marker/removeMarkers'
  // 清除所有的markers
  static CleanAllMarkersMethod = 'flutter_bmfmap/marker/cleanAllMarkers'
  // marker点击回调
  static ClickedMarkedMethod = 'flutter_bmfmap/marker/clickedMarker'
  // 更新marker
  static UpdateMarkerMemberMethod = 'flutter_bmfmap/marker/updateMarkerMember'
}

/**
 * overlay
 */
export class OverlayMethod {
  // 删除单个overlay
  static RemoveOverlayMethod = 'flutter_bmfmap/overlay/removeOverlay'
  // 删除全部overlay
  static RemoveAllOverlayMethod = 'flutter_bmfmap/overlay/clear'
  // overlay点击回调
  static OverlayClickedCallback = 'flutter_bmfmap/overlay/onClickedOverlay'
}

/**
 * 定位图层
 */
export class LocationLayerMethod {
  // 设定是否显示定位图层
  static ShowUserLocationMethod = 'flutter_bmfmap/userLocation/showUserLocation'
  // 动态定制我的位置样式
  static UpdateLocationDisplayParamMethod = 'flutter_bmfmap/userLocation/updateLocationDisplayParam'
  // 动态更新我的位置数据
  static UpdateLocationDataMethod = 'flutter_bmfmap/userLocation/updateLocationData'
  // 设置定位图层模式
  static UserTrackingModeMethod = 'flutter_bmfmap/userLocation/userTrackingMode'
}

/**
 * 3D模型
 */
export class BM3DModelMethod {
  // 添加3D模型
  static Add3DModelMethod = 'flutter_bmfmap/overlay/add3DModelOverlay'
  // 更新3D模型属性
  static Update3DModelMember = 'flutter_bmfmap/overlay/update3DModelOverlayMember'
}

/**
 * Text
 */
export class TextMethod {
  // 添加Text
  static AddTextMethod = 'flutter_bmfmap/overlay/addText'
  // 更新Text属性
  static UpdateTextMemberMethod = 'flutter_bmfmap/overlay/updateTextMember'
}

/**
 * Arc
 */
export class ArcLineMethod {
  // 添加ArcLine
  static AddArcLineMethod = 'flutter_bmfmap/overlay/addArcline'
  // 更新ArcLine属性
  static UpdateArcLineMemberMethod = 'flutter_bmfmap/overlay/updateArclineMember'
}

/**
 * Ground
 */
export class GroundMethod {
  // 添加Ground
  static AddGroundMethod = 'flutter_bmfmap/overlay/addGround'
  // 更新Ground属性
  static UpdateGroundMemberMethod = 'flutter_bmfmap/overlay/updateGroundMember'
}

/**
 * Prism
 */
export class PrismMethod {
  // 添加Prism
  static AddPrismMethod = 'flutter_bmfmap/overlay/addPrismOverlay'
  // 更新Prism属性
  static UpdatePrismMemberMethod = 'flutter_bmfmap/overlay/updatePrismOverlayMember'
}

/**
 * Polyline
 */
export class PolylineMethod {
  // 添加polyline
  static AddPolylineMethod = 'flutter_bmfmap/overlay/addPolyline';
  // 更新polyline属性
  static UpdatePolylineMemberMethod = 'flutter_bmfmap/overlay/updatePolylineMember';
  // 添加大地曲线
  static AddGeodesicLineMethod = 'flutter_bmfmap/overlay/addGeodesicLine';
  // 添加渐变色line
  static AddGradientLineMethod = 'flutter_bmfmap/overlay/addGradientLine';
  // 更新geodesicLine属性
  static UpdateGeodesicLineMemberMethod = 'flutter_bmfmap/overlay/updateGeodesicLineMember';
  // 更新gradientLine属性
  static UpdateGradientLineMemberMethod = 'flutter_bmfmap/overlay/updateGradientLinMember';
}

