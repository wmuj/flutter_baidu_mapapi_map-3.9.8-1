import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 缩放地图示例
class ShowMapZoomPage extends StatefulWidget {
  ShowMapZoomPage({Key? key}) : super(key: key);

  @override
  _ShowMapZoomPageState createState() => _ShowMapZoomPageState();
}

class _ShowMapZoomPageState extends BMFBaseMapState<ShowMapZoomPage> {
  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图渲染回调
    myMapController.setMapDidFinishedRenderCallback(callback: (bool success) {
      print('mapDidFinishedReder-地图渲染完成');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: '缩放地图示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
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
                '放大',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                myMapController.zoomIn();
              }),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color(int.parse(Constants.btnColor))),
              ),
              child: Text(
                '缩小',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                myMapController.zoomOut();
              }),
        ],
      ),
    );
  }
}
