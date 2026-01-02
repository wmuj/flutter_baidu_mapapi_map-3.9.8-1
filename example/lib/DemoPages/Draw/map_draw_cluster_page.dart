import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';

import '../../CustomWidgets/map_appbar.dart';
import '../../constants.dart';

/// marker绘制示例
class DrawClusterMarkerPage extends StatefulWidget {
  DrawClusterMarkerPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawClusterMarkerPageState createState() => _DrawClusterMarkerPageState();
}

class _DrawClusterMarkerPageState
    extends BMFBaseMapState<DrawClusterMarkerPage> {
  late List<BMFClusterInfo?> clusters;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) async {
    super.onBMFMapCreated(controller);

    /// 地图区域改变完成后会调用此接口
    /// mapStatus 地图状态信息
    /// reason 地图改变原因
    myMapController.setMapRegionDidChangeWithReasonCallback(callback:
        (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
      print(
          '地图区域改变完成后会调用此接口4\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
      myMapController.mapRefresh();
    });

    /// 随机获取100个经纬度点
    var time1 = DateTime.now().millisecondsSinceEpoch;
    List<BMFClusterInfo> clusterInfoList = [];

    final List<Map<String, dynamic>> worldCities = [
      {'name': 'Beijing', 'lat': 39.9042, 'lon': 116.4074, 'count': 250},
      {'name': 'NewYork', 'lat': 40.7128, 'lon': -74.0060, 'count': 230},
      {'name': 'London', 'lat': 51.5074, 'lon': -0.1278, 'count': 220},
      {'name': 'Tokyo', 'lat': 35.6762, 'lon': 139.6503, 'count': 240},
      {'name': 'Sydney', 'lat': -33.8688, 'lon': 151.2093, 'count': 200},
      {'name': 'Paris', 'lat': 48.8566, 'lon': 2.3522, 'count': 210},
      {'name': 'Moscow', 'lat': 55.7558, 'lon': 37.6173, 'count': 220},
      {'name': 'Cairo', 'lat': 30.0444, 'lon': 31.2357, 'count': 190},
      {'name': 'Rio', 'lat': -22.9068, 'lon': -43.1729, 'count': 200},
      {'name': 'LosAngeles', 'lat': 34.0522, 'lon': -118.2437, 'count': 230},
      {'name': 'Berlin', 'lat': 52.5200, 'lon': 13.4050, 'count': 210},
      {'name': 'Mumbai', 'lat': 19.0760, 'lon': 72.8777, 'count': 240},
      {'name': 'Singapore', 'lat': 1.3521, 'lon': 103.8198, 'count': 200},
      {'name': 'Dubai', 'lat': 25.2048, 'lon': 55.2708, 'count': 190},
      {'name': 'Toronto', 'lat': 43.6532, 'lon': -79.3832, 'count': 210},
      {'name': 'Seoul', 'lat': 37.5665, 'lon': 126.9780, 'count': 220},
      {'name': 'MexicoCity', 'lat': 19.4326, 'lon': -99.1332, 'count': 200},
      {'name': 'Istanbul', 'lat': 41.0082, 'lon': 28.9784, 'count': 210},
      {'name': 'Bangkok', 'lat': 13.7563, 'lon': 100.5018, 'count': 220},
      {'name': 'Johannesburg', 'lat': -26.2041, 'lon': 28.0473, 'count': 190},
    ];

    Random random = Random();

    String imagePath = 'resoures/icon_mark.png';
    Uint8List imageBytes = await imageToUint8List(imagePath);

    for (var city in worldCities) {
      String cityName = city['name'];
      double baseLat = city['lat'];
      double baseLon = city['lon'];
      int pointCount = city['count'];

      print('正在生成 $cityName 的 $pointCount 个点...');

      List<BMFClusterInfo> cityPoints = [];

      for (int i = 0; i < pointCount; i++) {
        // 在基础坐标周围随机分布，范围约10公里
        double latOffset = (random.nextDouble() - 0.5) * 0.2; // 约±0.1度，约±11公里
        double lonOffset = (random.nextDouble() - 0.5) * 0.2; // 约±0.1度，在赤道约±11公里

        double lat = baseLat + latOffset;
        double lon = baseLon + lonOffset;

        BMFCoordinate coord = BMFCoordinate(lat, lon);
        cityPoints.add(BMFClusterInfo.iconData(
            coordinate: coord,
            iconData: imageBytes
        ));
      }

      clusterInfoList.addAll(cityPoints);
      print('$cityName 生成完成，当前总数: ${clusterInfoList.length}');
    }

    var time3 = DateTime.now().millisecondsSinceEpoch;
    print('组合数据耗时：${time3 - time1}ms');

    // bool visiable = await myMapController.setClusterVisible(false, false);
    // print('设置聚合点可见性结果：$visiable');

    /// 设置聚合点最大距离
    bool res1 = await myMapController
        .setClusterMaxDistanceInDP(Platform.isIOS ? 200 : 100);
    // print('最大距离设置结果：$res1');

    /// 设置聚合点的经纬度
    bool res = await myMapController.setClusterCoordinates(clusterInfoList);
    // print('点聚合设置结果：$res');

    var time2 = DateTime.now().millisecondsSinceEpoch;
    print('总耗时：${time2 - time1}ms');

    /// 如果需要首次展示地图时就展示聚合点，就需要调用onRefreshClusters
    if (Platform.isIOS) {
      /// 获取地图状态
      BMFMapStatus? status = await myMapController.getMapStatus();

      /// 根据当前的level刷新聚合点
      onRefreshClusters(status!);
    }

    /// 点聚合的点击事件
    /// andriod 独有 iOS暂不支持
    myMapController.setMapClusterClickCallback(
        callback: (List<BMFClusterInfo> clusterList, int size) {
      for (BMFClusterInfo item in clusterList) {
        print('setMapClusterClickCallback--\n item = ${item.toMap()}');
      }
      print('setMapClusterClickCallback--\n size = $size');
    });

    myMapController.setMapClusterItemClickCallback(
        callback: (BMFClusterInfo cluster) {
      print('setMapClusterItemClickCallback--\n cluster = ${cluster.toMap()}');
    });

    /// 地图状态改变回调
    myMapController.setMapRegionDidChangeCallback(
        callback: (BMFMapStatus status) async {
      print('mapRegionDidChange--\n');
      if (Platform.isIOS) {
        /// 根据当前的level刷新聚合点
        onRefreshClusters(status);
      }
    });
  }

  /// 刷新点聚合
  void onRefreshClusters(BMFMapStatus status) async {
    /// 根据当前的level获取聚合点列表
    clusters =
        await myMapController.getClusterOnZoomLevel(status.fLevel!.toInt());

    List<BMFClusterInfo> clusterInfos = [];
    for (BMFClusterInfo? item in clusters) {
      if (item == null) {
        continue;
      }
      int size = item.size!;

      /// 自定义聚合点样式
      if (size > 1) {
        CircularTextWidget text = CircularTextWidget(
          text: '$size',
          radius: 60.0,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        // 将Widget转换为图像
        Uint8List? imageBytes = await widgetToImage(text);
        clusterInfos.add(new BMFClusterInfo.iconData(
            coordinate: item.coordinate, iconData: imageBytes, size: size));
      } else {
        clusterInfos.add(new BMFClusterInfo.icon(
            coordinate: item.coordinate,
            icon: 'resoures/icon_end.png',
            size: size));
      }
    }

    /// 刷新聚合点
    bool res = await myMapController.refreshClusters(clusterInfos);
    print('refreshClusters--\n res = $res');
  }

  /// 图片转byte
  Future<Uint8List> imageToUint8List(String imagePath) async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    return Uint8List.view(imageBytes.buffer);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
          appBar: generateAppBar(),
          body: Stack(children: <Widget>[
            generateMap(),
            generateControlBar(),
          ])),
    );
  }

  BMFAppBar generateAppBar() {
    return BMFAppBar(
        title: '聚合marker示例',
        onBack: () {
          Navigator.pop(context);
        });
  }

  /// 创建地图
  @override
  Container generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: initMapOptions(),
      ),
    );
  }

  @override
  Widget generateControlBar() {
    return Container(
      width: screenSize.width,
      height: 60,
      color: Color(int.parse(Constants.controlBarColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
              style: ButtonStyle(backgroundColor: defaultBtnBgColor),
              child: Text(
                '删除大头针',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onBtnPress();
              }),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: defaultBtnBgColor),
              child: Text(
                '更新大头针',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onUpdate();
              }),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: defaultBtnBgColor),
              child: Text(
                '添加',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onAdd();
              }),
        ],
      ),
    );
  }

  void onAdd() async {
    /// 随机获取100个经纬度点
    List<BMFClusterInfo> clusterInfoList = [];
    BMFCoordinate coordinate = BMFCoordinate(39.915, 116.404);
    for (int i = 0; i < 100; i++) {
      Random random = Random();
      double lat = coordinate.latitude + (random.nextInt(100) * 0.001);
      double lon = coordinate.longitude + (random.nextInt(100) * 0.001);

      String imagePath = 'resoures/icon_mark.png';
      Uint8List imageBytes = await imageToUint8List(imagePath);

      BMFCoordinate coord = BMFCoordinate(lat, lon);
      // clusterInfoList.add(
      //     new BMFClusterInfo.iconData(coordinate: coord, iconData: imageBytes));
      clusterInfoList.add(new BMFClusterInfo.icon(coordinate: coord, icon: imagePath));
    }

    /// 设置聚合点最大距离
    bool res1 = await myMapController
        .setClusterMaxDistanceInDP(Platform.isIOS ? 200 : 100);
    print('最大距离设置结果：$res1');

    /// 设置聚合点的经纬度
    bool res = await myMapController.setClusterCoordinates(clusterInfoList);
    print('点聚合设置结果：$res');

    await myMapController.setNewMapStatus(mapStatus: BMFMapStatus(fLevel: 11, targetGeoPt: coordinate), animateDurationMs: 100);

  }

  bool _isVisible = false;

  void onUpdate() async {
    setState(() {
      myMapController.setClusterVisible(_isVisible, true);
      _isVisible = !_isVisible;
    });

    bool suc = await myMapController.getClusterVisible();
    if (suc) {
      print('聚合展示为true');
    } else {
      print('聚合展示为false');
    }

    // List<BMFClusterInfo> clusterInfoList = [];
    // BMFCoordinate coordinate = BMFCoordinate(39.915, 116.404);
    // for (int i = 0; i < 30; ++i) {
    //   Random random = Random();
    //   double lat = coordinate.latitude + (random.nextInt(100) * 0.001);
    //   double lon = coordinate.longitude + (random.nextInt(100) * 0.001);
    //
    //   String imagePath = 'resoures/route_detail_start.png';
    //
    //   BMFCoordinate coord = BMFCoordinate(lat, lon);
    //   clusterInfoList
    //       .add(new BMFClusterInfo.icon(coordinate: coord, icon: imagePath));
    // }
    //
    // bool res = await myMapController.updateClusters(clusterInfoList);
    // print('点聚合设置结果：$res');
    //
    // if (Platform.isIOS && res) {
    //   BMFMapStatus? status = await myMapController.getMapStatus();
    //   // 根据当前的level刷新聚合点
    //   onRefreshClusters(status!);
    // }
  }

  void onBtnPress() {
    myMapController.cleanCluster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Future<Uint8List> widgetToImage(
    Widget widget, {
    Alignment alignment = Alignment.center,
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0,
  }) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      // configuration: ViewConfiguration(
      //   physicalConstraints: BoxConstraints(maxWidth: 140, maxHeight: 140),
      //   logicalConstraints: BoxConstraints(maxWidth: 140, maxHeight: 140),
      //   devicePixelRatio: devicePixelRatio,
      // ),
      view: WidgetsBinding.instance.platformDispatcher.views.first,
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr, // 设置适当的阅读方向
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes!;
  }
}

class CircularTextWidget extends StatelessWidget {
  final String text;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  CircularTextWidget({
    required this.text,
    required this.radius,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
