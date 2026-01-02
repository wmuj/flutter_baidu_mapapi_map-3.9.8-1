import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 自定义定位图层示例
class ShowUserLoationPage extends StatefulWidget {
  ShowUserLoationPage({Key? key}) : super(key: key);

  @override
  _ShowUserLoationPageState createState() => _ShowUserLoationPageState();
}

class _ShowUserLoationPageState extends BMFBaseMapState<ShowUserLoationPage> {
  /// 是否展示定位图层
  bool _showUserEnabled = true;

  /// 我的位置
  BMFUserLocation? _userLocation;

  /// 定位点样式
  BMFUserLocationDisplayParam? _displayParam;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');

      myMapController.showUserLocation(_showUserEnabled);

      if (_showUserEnabled) {
        updateUserLocation();
        updatUserLocationDisplayParam();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: '定位图层示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
      ),
    );
  }

  @override
  Container generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (mapController) {
          onBMFMapCreated(mapController);
        },
        mapOptions: initMapOptions(),
      ),
    );
  }

  /// 设置地图参数
  @override
  BMFMapOptions initMapOptions() {
    BMFMapOptions mapOptions = BMFMapOptions(
      center: BMFCoordinate(39.965, 116.404),
      zoomLevel: 18,
      maxZoomLevel: 18,
      minZoomLevel: 15,
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
                value: _showUserEnabled,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _showUserEnabled = value;
                    myMapController.showUserLocation(_showUserEnabled);

                    if (_showUserEnabled) {
                      updateUserLocation();
                      updatUserLocationDisplayParam();
                    }
                  });
                }),
            Text(
              '地图用户点',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  /// 更新位置
  void updateUserLocation() {
    BMFCoordinate coordinate = BMFCoordinate(39.965, 116.404);
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    _userLocation = userLocation;
    myMapController.updateLocationData(_userLocation!);
  }

  /// 更新定位图层样式
  void updatUserLocationDisplayParam() {
    BMFUserLocationDisplayParam displayParam = BMFUserLocationDisplayParam(
        locationViewOffsetX: 0,
        locationViewOffsetY: 0,
        accuracyCircleFillColor: Colors.red,
        accuracyCircleStrokeColor: Colors.blue,
        isAccuracyCircleShow: true,
        locationViewImage: 'resoures/animation_red.png',
        locationViewHierarchy:
            BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

    _displayParam = displayParam;
    myMapController.updateLocationViewWithParam(_displayParam!);
  }
}
