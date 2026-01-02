import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// marker碰撞检测
class DrawCollisionDetectionPage extends StatefulWidget {
  DrawCollisionDetectionPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawMarkerPageState createState() => _DrawMarkerPageState();
}

class _DrawMarkerPageState extends BMFBaseMapState<DrawCollisionDetectionPage> {
  // static const TAG = "_DrawMarkerPageState";

  /// 地图controller
  final List<BMFMarker> _markers = [];
  //批量添加marker基准坐标
  final BMFCoordinate _baseCoordinates = BMFCoordinate(39.928617, 116.30329);

  bool enable = true;
  bool dragable = true;

  bool startState = true;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
      addMarkers();

    });

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

  /// 添加大头针
  void addLevelMarker(bool isStart) {
    BMFCoordinate coordinate = isStart
        ? BMFCoordinate(_baseCoordinates.latitude + 0.012,
            _baseCoordinates.longitude + 0.012)
        : BMFCoordinate(_baseCoordinates.latitude + 0.028,
            _baseCoordinates.longitude + 0.028);
    BMFMarker marker = BMFMarker.icon(
        position: coordinate,
        isOpenCollisionDetection: true,
        isForceDisplay: !isStart,
        collisionDetectionPriority: 10,
        title: isStart ? '高等级maker' : '强制展示maker',
        subtitle: 'test',
        titleOptions: BMFTitleOptions(
            text: "我是标题",
            bgColor: Colors.black,
            fontColor: Colors.white,
            fontSize: 36
        ),
        identifier: 'flutter_marker',
        icon: isStart
            ? 'resoures/icon_ugc_start.png'
            : 'resoures/icon_ugc_end.png');
    _markers.add(marker);
    // bool result;
    myMapController.addMarker(marker);
  }

  BMFAppBar generateAppBar() {
    return BMFAppBar(
        title: 'marker碰撞检测',
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
        height: 100,
        color: Color(int.parse(Constants.controlBarColor)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(Constants.btnColor))),
                    ),
                    child: Text(
                      "批量添加marker",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      addMarkers();
                    }),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(Constants.btnColor))),
                    ),
                    child: Text(
                      "删除全部marker",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      removeMarkers();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(Constants.btnColor))),
                    ),
                    child: Text(
                      "添加高等级marker",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      addLevelMarker(true);
                    }),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(Constants.btnColor))),
                    ),
                    child: Text(
                      "添加强制展示marker",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      addLevelMarker(false);
                    }),
              ],
            ),
          ],
        ));
  }

  /// 批量添加大头针
  Future<void> addMarkers() async {
    List<BMFMarker> _markerList = [];
    for (var i = 0; i < 20; i++) {
      var rng = new Random();
      double lat = rng.nextInt(100) * 0.001;
      double lon = rng.nextInt(100) * 0.001;

      // ByteData bytes = await rootBundle.load('resoures/icon_binding_point.png');
      // Uint8List iconData = bytes.buffer.asUint8List();
      BMFMarker marker = BMFMarker.icon(
          position: BMFCoordinate(_baseCoordinates.latitude + lat,
              _baseCoordinates.longitude + lon),
          title: '默认等级',
          subtitle: 'test',
          identifier: 'flutter_marker',
          icon: 'resoures/icon_binding_point.png',
          enabled: enable,
          draggable: dragable,
          isOpenCollisionDetection: true,
          customMap: {'id': 123, "phone": "110"});

      _markers.add(marker);
      _markerList.add(marker);
    }
    await myMapController.addMarkers(_markerList);
  }

  /// 批量删除大头针
  void removeMarkers() {
    myMapController.removeMarkers(_markers);
    _markers.clear();
  }

  Future<Uint8List> loadAsset() async {
    ByteData bytes = await rootBundle.load('resoures/icon_ugc_start.png');
    //  Uint8List list = bytes.buffer.asUint8List();
    return bytes.buffer.asUint8List();
  }
}
