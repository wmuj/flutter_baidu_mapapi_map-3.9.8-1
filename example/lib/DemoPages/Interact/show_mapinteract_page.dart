import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 地图交互示例
class ShowMapInteractPage extends StatefulWidget {
  ShowMapInteractPage({Key? key}) : super(key: key);

  @override
  _ShowMapInteractPageState createState() => _ShowMapInteractPageState();
}

class _ShowMapInteractPageState extends BMFBaseMapState<ShowMapInteractPage> {
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 点中底图标注后会回调此接口
    myMapController.setMapOnClickedMapPoiCallback(callback: (BMFMapPoi mapPoi) {
      print('点中底图标注后会回调此接口poi=${mapPoi.toMap()}');
    });

    /// 点中底图空白处会回调此接口
    myMapController.setMapOnClickedMapBlankCallback(
        callback: (BMFCoordinate coordinate) {
      print('点中底图空白处会回调此接口coord=${coordinate.toMap()}');
    });

    /// 双击地图时会回调此接口
    myMapController.setMapOnDoubleClickCallback(
        callback: (BMFCoordinate coordinate) {
      print('双击地图时会回调此接口coord=${coordinate.toMap()}');
    });

    /// 长按地图时会回调此接口
    myMapController.setMapOnLongClickCallback(
        callback: (BMFCoordinate coordinate) {
      print('长按地图时会回调此接口coord=${coordinate.toMap()}');
    });

    /// 3DTouch 按地图时会回调此接口
    ///（仅在支持3D Touch，且fouchTouchEnabled属性为true时，会回调此接口）
    /// coordinate 触摸点的经纬度
    /// force 触摸该点的力度(参考UITouch的force属性)
    /// maximumPossibleForce 当前输入机制下的最大可能力度(参考UITouch的maximumPossibleForce属性)
    myMapController.setMapOnForceTouchCallback(callback:
        (BMFCoordinate coordinate, double force, double maximumPossibleForce) {
      print(
          '3DTouch 按地图时会回调此接口\ncoord=${coordinate.toMap()}\nforce=$force\nmaximumPossibleForce=$maximumPossibleForce');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: BMFAppBar(
        title: '地图交互示例',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
    ));
  }

  @override
  Widget generateControlBar() {
    return Container(
        width: screenSize.width,
        height: 100,
        color: Color(int.parse(Constants.controlBarColor)),
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(int.parse(Constants.btnColor))),
                      ),
                      child: Text(
                        '改变地图中心点',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        myMapController.setCenterCoordinate(
                            BMFCoordinate(39.90, 116.40), true,
                            animateDurationMs: 1000);
                      }),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(int.parse(Constants.btnColor))),
                      ),
                      child: Text(
                        '旋转地图',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        myMapController.setNewMapStatus(
                            mapStatus: BMFMapStatus(fRotation: 45));
                      }),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(int.parse(Constants.btnColor))),
                      ),
                      child: Text(
                        '设置俯仰角',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        myMapController.setNewMapStatus(
                            mapStatus: BMFMapStatus(fOverlooking: -45));
                      }),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(int.parse(Constants.btnColor))),
                      ),
                      child: Text(
                        '设置地图显示区域',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        BMFCoordinateBounds visibleMapBounds =
                            BMFCoordinateBounds(
                                northeast: BMFCoordinate(
                                    39.94001804746338, 116.41224644234747),
                                southwest: BMFCoordinate(
                                    39.90299859954822, 116.38359947963427));
                        await myMapController.setVisibleMapBounds(
                            visibleMapBounds, false);
                      }),
                  Platform.isAndroid
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color(int.parse(Constants.btnColor))),
                          ),
                          child: Text(
                            '按像素移动地图中心点',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            myMapController.setScrollBy(30, 30,
                                animateDurationMs: 1000);
                          })
                      : SizedBox(width: 0),
                ]),
          ],
        ));
  }

  /// 设置地图参数
  @override
  BMFMapOptions initMapOptions() {
    BMFCoordinate center = BMFCoordinate(39.965, 116.404);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 12,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        compassPosition: BMFPoint(0, 0),
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        logoPosition: BMFLogoPosition.LeftBottom,
        //116.40329,39.928617
        center: center);
    return mapOptions;
  }
}
