import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 3d建筑物示例
class Show3DBuildingsMapPage extends StatefulWidget {
  Show3DBuildingsMapPage({Key? key}) : super(key: key);

  @override
  _Show3DBuildingsMapPageState createState() => _Show3DBuildingsMapPageState();
}

class _Show3DBuildingsMapPageState
    extends BMFBaseMapState<Show3DBuildingsMapPage> {
  /// 地图controller
  bool _isShowBuildings = true;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      myMapController.updateMapOptions(BMFMapOptions(
          buildingsEnabled: _isShowBuildings,
          showMapPoi: false,
          overlookEnabled: true,
          overlooking: -30));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: BMFAppBar(
        title: '3D建筑物地图示例',
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
      center: BMFCoordinate(39.917215, 116.381351),
      mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
      zoomLevel: 19,
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
              value: _isShowBuildings,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                setState(() {
                  _isShowBuildings = value;

                  myMapController.updateMapOptions(BMFMapOptions(
                      buildingsEnabled: _isShowBuildings,
                      showMapPoi: false,
                      overlookEnabled: true,
                      overlooking: -30));

                  ;
                });
              }),
          Text('显示3D建筑物', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
