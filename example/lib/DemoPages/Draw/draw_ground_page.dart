import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';

import '../../constants.dart';

/// ground图片图层绘制示例
///
/// Android独有
class DrawGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DrawGroundPageState();
  }
}

class _DrawGroundPageState extends BMFBaseMapState<DrawGroundPage> {
  late BMFGround _bmfGround0;
  late BMFGround _bmfGround1;

  bool _addState = false;
  String _btnText = "删除";

  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addGround();
    }

    myMapController.setMapOnClickedOverlayCallback(
        callback: (BMFOverlay ground) {
          print('地图点击ground覆盖物回调=${ground.toMap()}');
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
            appBar: BMFAppBar(
              title: 'ground示例',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            body: Stack(
                children: <Widget>[generateMap(), generateControlBar()])));
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
                _btnText,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onBtnPress();
              }),
        ],
      ),
    );
  }

  void onBtnPress() {
    if (_addState) {
      addGround();
    } else {
      removeGround();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addGround() {
    addGround0();
    addGround1();
  }

  /// 添加ground0
  void addGround0() {
    BMFCoordinate southwest = BMFCoordinate(40.00235, 116.330338);
    BMFCoordinate northeast = BMFCoordinate(40.147246, 116.464977);
    BMFCoordinateBounds bounds =
        BMFCoordinateBounds(southwest: southwest, northeast: northeast);

    _bmfGround0 = BMFGround(
        image: 'resoures/groundIcon.png',
        bounds: bounds,
        transparency: 0.8,
        width: 200,
        height: 200,
        clickable: true);

    myMapController.addGround(_bmfGround0);
  }

  /// 添加ground1
  void addGround1() {
    BMFCoordinate southwest = BMFCoordinate(39.82235, 116.330338);
    BMFCoordinate northeast = BMFCoordinate(39.847246, 116.464977);
    BMFCoordinateBounds bounds =
        BMFCoordinateBounds(southwest: southwest, northeast: northeast);

    _bmfGround1 = BMFGround(
        image: 'resoures/groundIcon.png', bounds: bounds, transparency: 0.8, clickable: true);

    myMapController.addGround(_bmfGround1);
  }

  /// 删除ground
  void removeGround() {
    myMapController.removeOverlay(_bmfGround0.id);
    myMapController.removeOverlay(_bmfGround1.id);
  }
}

/// 设置地图参数
BMFMapOptions initMapOptions() {
  BMFMapOptions mapOptions = BMFMapOptions(
      mapType: BMFMapType.Standard,
      zoomLevel: 13,
      center: BMFCoordinate(39.915, 116.404));
  return mapOptions;
}
