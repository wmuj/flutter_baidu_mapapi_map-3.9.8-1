import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 定位模式示例
class ShowUserLoationModePage extends StatefulWidget {
  ShowUserLoationModePage({Key? key}) : super(key: key);

  @override
  _ShowUserLoationModePageState createState() =>
      _ShowUserLoationModePageState();
}

class _ShowUserLoationModePageState
    extends BMFBaseMapState<ShowUserLoationModePage> {
  /// 我的位置
  BMFUserLocation? _userLocation;

  /// 定位模式
  BMFUserTrackingMode _userTrackingMode = BMFUserTrackingMode.Follow;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');

      myMapController.showUserLocation(true);
      updateUserLocation();
      myMapController.setUserTrackingMode(_userTrackingMode);
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
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: BMFUserTrackingMode.None,
                    groupValue: this._userTrackingMode,
                    onChanged: (value) {
                      setUserLocationMode(value as BMFUserTrackingMode);
                    },
                  ),
                  Text(
                    "普通模式",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: BMFUserTrackingMode.Follow,
                    groupValue: this._userTrackingMode,
                    onChanged: (value) {
                      setUserLocationMode(value as BMFUserTrackingMode);
                    },
                  ),
                  Text(
                    "跟随模式",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: BMFUserTrackingMode.FollowWithHeading,
                    groupValue: this._userTrackingMode,
                    onChanged: (value) {
                      setUserLocationMode(value as BMFUserTrackingMode);
                    },
                  ),
                  Text(
                    "罗盘模式",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void setUserLocationMode(BMFUserTrackingMode userTrackingMode) {
    setState(() {
      this._userTrackingMode = userTrackingMode;
    });
    myMapController.setUserTrackingMode(userTrackingMode,
        enableDirection: false);

    if (BMFUserTrackingMode.Follow == userTrackingMode ||
        BMFUserTrackingMode.Heading == userTrackingMode) {
      myMapController.setNewMapStatus(mapStatus: BMFMapStatus(fOverlooking: 0));
    }
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
}
