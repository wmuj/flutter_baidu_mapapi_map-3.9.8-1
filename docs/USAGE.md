# flutter_baidu_mapapi_map 使用方法（详细版）

> 本文档以插件源码中的公开 API 为准，覆盖 **地图展示、地图状态控制、交互回调、覆盖物、聚合、热力图、离线地图、粒子效果、室内图、个性化地图** 等能力。
> 若你需要 **路线规划、POI 搜索、地理编码、天气服务** 等能力，本插件中并未实现（这些通常在搜索/路线规划类插件中提供）。

---

## 目录

- [1. 快速开始](#1-快速开始)
- [2. 地图组件与创建流程](#2-地图组件与创建流程)
- [3. MapOptions（地图初始化配置）](#3-mapoptions地图初始化配置)
- [4. 地图控制与状态操作（BMFMapController）](#4-地图控制与状态操作bmfmapcontroller)
- [5. 事件与回调](#5-事件与回调)
- [6. 覆盖物与图层](#6-覆盖物与图层)
- [7. 点聚合（Cluster）](#7-点聚合cluster)
- [8. 定位与定位展示](#8-定位与定位展示)
- [9. 室内图](#9-室内图)
- [10. 热力图](#10-热力图)
- [11. 个性化地图](#11-个性化地图)
- [12. 粒子效果图层](#12-粒子效果图层)
- [13. 离线地图](#13-离线地图)
- [14. 坐标与屏幕点转换](#14-坐标与屏幕点转换)
- [15. 版本与版权信息](#15-版本与版权信息)
- [16. 本插件不包含的能力说明](#16-本插件不包含的能力说明)

---

## 1. 快速开始

### 1.1 初始化 Android 版本（建议）

Android 10 以下设备使用 TextureMapView，Android 10 及以上使用 SurfaceMapView。
在 `runApp` 前调用：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BMFAndroidVersion.initAndroidVersion();
  runApp(const MyApp());
}
```

### 1.2 基础地图展示

```dart
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late BMFMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BMFMapWidget(
        mapOptions: BMFMapOptions(
          center: BMFCoordinate(39.915, 116.404),
          zoomLevel: 15,
          mapType: BMFMapType.Standard,
          compassEnabled: true,
        ),
        onBMFMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
```

---

## 2. 地图组件与创建流程

- **BMFMapWidget**：主地图控件，通过 `onBMFMapCreated` 获取 `BMFMapController` 进行后续操作。
- **BMFMapController**：所有地图操作接口的入口，按功能分为多个 extension（地图状态、覆盖物、热力图、定位、回调等）。
- **BMFAndroidVersion**：用于在 Android 10 以下设备选择 TextureMapView 渲染。

---

## 3. MapOptions（地图初始化配置）

`BMFMapOptions` 用于创建地图时的默认配置，常用字段包括：

- **基础展示**：`mapType`、`languageType`、`fontSizeLevel`、`backgroundColor`。
- **地图状态**：`center`、`zoomLevel`、`rotation`、`overlooking`。
- **手势控制**：`gesturesEnabled`、`zoomEnabled`、`scrollEnabled`、`rotateEnabled`、`overlookEnabled`。
- **图层控制**：`trafficEnabled`、`baiduHeatMapEnabled`、`showMapPoi`、`buildingsEnabled`。
- **UI 控件**：`compassEnabled`、`showMapScaleBar`、`mapScaleBarPosition`、`showZoomControl`、`mapZoomControlPosition`、`logoPosition`。
- **室内图**：`baseIndoorMapEnabled`、`showIndoorMapPoi`。
- **地图范围**：`limitMapBounds`、`visibleMapBounds`、`mapPadding`。

> 你也可以在地图创建后通过 `updateMapOptions` 动态更新这些属性。

---

## 4. 地图控制与状态操作（BMFMapController）

### 4.1 地图属性读取

- `getMapStatus()` / `getMapType()` / `getMapLanguageType()` / `getZoomLevel()` / `getRotation()` / `getOverlooking()`
- `getVisibleMapBounds()` / `getMapScaleBarPosition()` / `getLogoPosition()`
- `getTrafficEnabled()` / `getBaiduHeatMapEnabled()` / `getBuildingsEnabled()` / `getShowMapPoi()`

### 4.2 地图状态更新

- `updateMapOptions(BMFMapOptions change)`
- `setNewMapStatus(mapStatus: ...)`
- `setCenterCoordinate(...)` / `setNewLatLngZoom(...)`
- `zoomIn()` / `zoomOut()` / `setZoomTo(...)` / `setZoomBy(...)`
- `setScrollBy(...)` / `setZoomPointBy(...)`
- `setVisibleMapBounds(...)` / `setVisibleMapRectWithPadding(...)` / `fitVisibleMapRectWithPadding(...)`
- `setMapCenterToScreenPt(...)`
- `mapRefresh()`

### 4.3 截图与图层配置

- `takeSnapshot()` / `takeSnapshotWithRect(...)`
- `setCustomTrafficColor(...)`
- `setCompassImage(...)`

---

## 5. 事件与回调

### 5.1 地图回调（MapCallbackExtension）

- 地图加载完成：`setMapDidLoadCallback`
- 渲染完成/绘制帧：`setMapDidFinishedRenderCallback` / `setMapOnDrawMapFrameCallback`
- 地图区域变化：`setMapRegionWillChangeCallback` / `setMapRegionDidChangeCallback`
- 地图状态变化：`setMapStatusDidChangedCallback`
- 定位模式变化：`setUserTrackingModeChangedCallback`

### 5.2 手势回调（MapGestureCallbackExtension）

- 点击 POI：`setMapOnClickedMapPoiCallback`
- 点击空白：`setMapOnClickedMapBlankCallback`
- 双击：`setMapOnDoubleClickCallback`
- 长按：`setMapOnLongClickCallback`
- 3D Touch：`setMapOnForceTouchCallback`

### 5.3 覆盖物/Marker/聚合回调

- 覆盖物点击：`setMapOnClickedOverlayCallback`
- 海量点点击：`setMapOnClickedMultiPointOverlaItemCallback`
- Marker：`setMapClickedMarkerCallback` / `setMaptDidSelectMarkerCallback` / `setMapDidDeselectMarkerCallback`
- Marker 拖拽：`setMapDragMarkerCallback`
- InfoWindow 点击：`setMapDidClickedInfoWindowCallback`
- 聚合点击：`setMapClusterClickCallback` / `setMapClusterItemClickCallback`

---

## 6. 覆盖物与图层

### 6.1 常用覆盖物

覆盖物都通过 `BMFMapController` 的 **OverlayExtension** 或 **MarkerExtension** 添加：

- **Marker**：`addMarker` / `addMarkers` / `removeMarker` / `selectMarker` / `deselectMarker`
- **Polyline**：`addPolyline`
- **Polygon**：`addPolygon`
- **Circle**：`addCircle` / `addGradientCircle`
- **ArcLine**：`addArcline`
- **GeodesicLine**：`addGeodesicLine`
- **Ground**（图片覆盖物）：`addGround`
- **Text / TextMarker / IconMarker**：`addText` / `addTextMarker` / `addIconMarker`
- **MultiPoint**（海量点）：`addMultiPointOverlay`
- **TraceOverlay**（动态轨迹）：`addTraceOverlay`
- **3D 模型 & 3D 棱柱**：`add3dModelOverlay` / `addPrismOverlay`
- **Tile**（瓦片图层）：`addTile` / `removeTile`

### 6.2 覆盖物批量操作

- `addOverlays(List<BMFOverlay> overlays)`
- `clearOverlays()`
- `removeOverlay(overlayId)`

### 6.3 图层顺序控制

- `switchOverlayLayerAndPOILayer(...)`：Overlay 与 POI 层级互换
- `switchLayerOrder(...)`：任意图层顺序交换
- `setPoiTagEnableAndPoiTagType(...)`：按类型隐藏/显示底图 POI 标签

---

## 7. 点聚合（Cluster）

Android/iOS 聚合支持基于 `BMFClusterInfo`：

- 设置聚合点：`setClusterCoordinates(List<BMFClusterInfo>)`
- 更新聚合：`updateClusters(...)`
- 清理聚合：`cleanCluster()`
- 设置聚合最大距离：`setClusterMaxDistanceInDP(...)`
- 获取某 zoom 的聚合结果：`getClusterOnZoomLevel(...)`
- 控制显示/刷新：`setClusterVisible(...)`

> iOS 可在 `setMapRegionDidChangeCallback` 内调用 `refreshClusters` 自定义样式。

---

## 8. 定位与定位展示

- 显示/隐藏定位图层：`showUserLocation(bool show)`
- 设置定位模式：`setUserTrackingMode(...)`
- 更新定位数据：`updateLocationData(BMFUserLocation userLocation)`
- 自定义定位样式：`updateLocationViewWithParam(...)`

定位数据对象为 `BMFUserLocation`，支持设置经纬度、精度、方向等字段。

---

## 9. 室内图

- 显示/隐藏室内图：`showBaseIndoorMap(bool show)`
- 显示/隐藏室内图 POI：`showBaseIndoorMapPoi(bool showPoi)`
- 切换楼层：`switchBaseIndoorMapFloor(floorId, indoorId)`
- 获取当前室内图信息：`getFocusedBaseIndoorMapInfo()`

回调：`setMapInOrOutBaseIndoorMapCallback`

---

## 10. 热力图

- 添加热力图：`addHeatMap(BMFHeatMap heatMap)`
- 更新热力图：`updateHeatMap(...)`
- 删除热力图：`removeHeatMap()`
- 显示/隐藏：`showHeatMap(bool show)`
- 帧动画控制：`startHeatMapFrameAnimation()` / `stopHeatMapFrameAnimation()` / `setHeatMapFrameAnimatioIndex(...)`

回调：`setHeatMapFrameAnimationIndexCallback`

---

## 11. 个性化地图

- 开关：`setCustomMapStyleEnable(bool enable)`
- 本地样式：`setCustomMapStyle(String path, int mode)`
- 在线样式：`setCustomMapStyleWithOptionPath(...)`

在线样式需要在百度地图控制台创建样式 ID。

---

## 12. 粒子效果图层

- 显示粒子效果：`showParticleEffect(BMFParticleEffectType effect)`
- 关闭粒子效果：`closeParticleEffect(BMFParticleEffectType effect)`
- 自定义粒子效果：`customParticleEffectWithOption(effect, option)`

---

## 13. 离线地图

使用 `OfflineController`：

- 初始化：`init()`
- 下载/更新/暂停：`startOfflineMap(cityId)` / `updateOfflineMap(cityId)` / `pauseOfflineMap(cityId)`
- 删除：`removeOfflineMap(cityId)`
- 城市列表：`getHotCityList()` / `getOfflineCityList()` / `searchCity(cityName)`
- 下载状态：`getAllUpdateInfo()` / `getUpdateInfo(cityId)`
- 回调：`onGetOfflineMapStateBack(...)`

---

## 14. 坐标与屏幕点转换

- 屏幕点 -> 经纬度：`convertPointToCoordinate(...)`
- 经纬度 -> 屏幕点：`convertCoordinateToScreenPoint(...)`
- 三维坐标 -> 屏幕点：`convertScreenPointFromMapPoint3(...)`

---

## 15. 版本与版权信息

- 获取 SDK 版本：`BMFMapVersion.nativeMapVersion`
- 版权信息：`getNativeMapCopyright()`
- 测绘资质/审图号：`getNativeMapQualification()` / `getNativeMapApprovalNumber()`

---

## 16. 本插件不包含的能力说明

本仓库仅封装 **地图展示与图层绘制能力**，并不包含：

- POI 检索、地点输入提示、公交/驾车/骑行/步行路线规划
- 天气服务、推荐上车点、地理编码
- 分享短串等

如果你需要这些功能，请查看 **Baidu Map Search/Route** 相关 Flutter 插件（例如 `flutter_baidu_mapapi_search` / `flutter_baidu_mapapi_utils` 等）。

---

如需更深入的字段说明，请参考对应模型类：

- `BMFMapOptions`：地图初始化配置
- `BMFMapStatus`：地图状态
- `BMFMarker` / `BMFPolyline` / `BMFPolygon` / `BMFCircle` / `BMFHeatMap` 等覆盖物模型

这些模型均在 `lib/src/models/` 与 `lib/src/models/overlays/` 目录中。
