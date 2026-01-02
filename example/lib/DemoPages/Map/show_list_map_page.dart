import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';

class ShowListMapPage extends StatefulWidget {
  ShowListMapPage({Key? key}) : super(key: key);

  @override
  _ShowListMapPageState createState() => _ShowListMapPageState();
}

class _ShowListMapPageState extends State<ShowListMapPage> {
  late BMFMapController myMapController;

  late Size screenSize;
  late BMFMarker _marker;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
        home: Scaffold(
            appBar: BMFAppBar(
              title: 'listView上展示地图',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            body: Container(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  generateMapView(),
                  Container(
                    child: TextButton(
                      child: Text('next'),
                      onPressed: buttonClicked,
                    ),
                    width: screenSize.width,
                    height: screenSize.height * 0.5,
                  )
                ],
              ),
            )));
  }

  /// 创建地图
  Container generateMapView() {
    return Container(
      height: screenSize.height * 0.5,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },

        /// 设置地图参数
        mapOptions: BMFMapOptions(
            center: BMFCoordinate(39.917215, 116.380341), zoomLevel: 12),
      ),
    );
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
    });

    myMapController.setMapClickedMarkerCallback(callback: (BMFMarker marker) {
      print('marker点击----${marker.toMap()}');
    });

    myMapController.setMapDragMarkerCallback(callback: (BMFMarker marker,
        BMFMarkerDragState newState, BMFMarkerDragState oldState) {
      print('marker推拽----${marker.id}');
    });

    addMarker();
  }

  Future<void> addMarker() async {
    final ByteData bytes = await rootBundle.load('resoures/icon_ugc_start.png');
    final Uint8List list = bytes.buffer.asUint8List();
    _marker = BMFMarker.iconData(
        position: BMFCoordinate(39.917215, 116.380341),
        // icon: 'resoures/icon_ugc_start.png',
        iconData: list,
        title: '第一个',
        subtitle: 'test',
        identifier: 'flutter_marker',
        enabled: true,
        draggable: true);
    await this.myMapController.addMarker(_marker);
  }

  void buttonClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShowListMapPage()),
    );
  }
}
