import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 地图截图示例
class ShowMapScreenshotPage extends StatefulWidget {
  ShowMapScreenshotPage({Key? key}) : super(key: key);

  @override
  _ShowMapScreenshotPageState createState() => _ShowMapScreenshotPageState();
}

class _ShowMapScreenshotPageState
    extends BMFBaseMapState<ShowMapScreenshotPage> {
  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
  }

  /// 地图controller
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
            title: '地图截图示例',
            onBack: () {
              Navigator.pop(context);
            }),
        body: Column(children: <Widget>[
          Stack(
            children: <Widget>[generateMap(), generateControlBar()],
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _image != null ? Image.memory(_image!) : Text('地图截屏'),
            ),
          ),
        ]),
      ),
    );
  }

  /// 创建地图
  @override
  Container generateMap() {
    return Container(
      height: screenSize.height * 0.5,
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color(int.parse(Constants.btnColor))),
              ),
              child: Text(
                '截屏',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                takeSnapshort();
              }),
        ],
      ),
    );
  }

  void takeSnapshort() async {
    Uint8List? image = await myMapController.takeSnapshot();
    setState(() {
      _image = image;
    });
  }

  void takeSnapshortWitdhRect() async {
    BMFMapRect mapRect = BMFMapRect(BMFPoint(10, 10), BMFSize(200, 200));
    Uint8List? image = await myMapController.takeSnapshotWithRect(mapRect);
    setState(() {
      _image = image;
    });
  }
}
