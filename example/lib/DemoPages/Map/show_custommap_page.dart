import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 个性化地图示例
class ShowCustomMapPage extends StatefulWidget {
  ShowCustomMapPage({Key? key}) : super(key: key);

  @override
  _ShowCustomMapPageState createState() => _ShowCustomMapPageState();
}

class _ShowCustomMapPageState extends BMFBaseMapState<ShowCustomMapPage> {
  /// 地图controller
  bool _isShowCustomMap = true;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      myMapController.setCustomMapStyle('files/custom_map_config.sty', 0);
      // myMapController.setCustomMapStyleWithOptionPath(
      //                 customMapStyleOption: styleOption(),
      //                 preload: (String path) {
      //                   print('preload');
      //                 },
      //                 success: (String path) {
      //                   print('success');
      //                 },
      //                 error: (int errorCode, String path) {
      //                   print('error');
      //                 });
      myMapController.setCustomMapStyleEnable(_isShowCustomMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: BMFAppBar(
        title: '个性化地图示例',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(children: <Widget>[
        generateMap(),
        generateControlBar(),
      ]),
    ));
  }

  /// 设置地图参数
  @override
  BMFMapOptions initMapOptions() {
    BMFMapOptions mapOptions = BMFMapOptions(
      center: BMFCoordinate(39.917215, 116.380341),
      zoomLevel: 12,
      mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
    );
    return mapOptions;
  }

  @override
  Widget generateControlBar() {
    return Container(
      width: screenSize.width,
      height: 60,
      color: Color(int.parse(Constants.controlBarColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Switch(
              value: _isShowCustomMap,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                setState(() {
                  _isShowCustomMap = value;
                  if (_isShowCustomMap) {
                    myMapController.setCustomMapStyle(
                        'files/custom_map_config.sty', 0);
                  }

                  myMapController.setCustomMapStyleEnable(_isShowCustomMap);
                  // myMapController.setCustomMapStyleWithOptionPath(
                  //     customMapStyleOption: styleOption(),
                  //     preload: (String path) {
                  //       print('preload');
                  //     },
                  //     success: (String path) {
                  //       print('success');
                  //     },
                  //     error: (int errorCode, String path) {
                  //       print('error');
                  //     });
                });
              }),
          Text('开启个性化地图', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

BMFCustomMapStyleOption styleOption() {
  BMFCustomMapStyleOption customMapStyleOption = BMFCustomMapStyleOption(
      customMapStyleID: "ab0e0251e4e768a96dffde39e0034b12");
  return customMapStyleOption;
}
