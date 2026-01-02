import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// circle圆形绘制示例
class DrawCirclePage extends StatefulWidget {
  DrawCirclePage({Key? key}) : super(key: key);

  @override
  _DrawCirclePageState createState() => _DrawCirclePageState();
}

class _DrawCirclePageState extends BMFBaseMapState<DrawCirclePage> {
  BMFCircle? _circle0;
  BMFCircle? _circle1;
  BMFCircle? _circle2;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    if (!_addState) {
      addCircle();
    }

    myMapController.setMapOnClickedOverlayCallback(
        callback: (BMFOverlay circle) {
          print('地图点击circle覆盖物回调=${circle.toMap()}');
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: 'circle示例',
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
                _btnText,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onBtnPress();
              })
        ],
      ),
    );
  }

  void onBtnPress() {
    if (_addState) {
      addCircle();
    } else {
      removeCircle();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addCircle() {
    addCircle0();
    // addCircle1();
    // addCircle2();
  }

  void addCircle0() {
    BMFHollowShape hollowShapeCircle = BMFHollowShape.circle(
        center: BMFCoordinate(39.945, 116.404), radius: 2000);
    _circle0 = BMFCircle(
        center: BMFCoordinate(39.915, 116.404),
        radius: 5000,
        width: 6,
        clickable: true,
        strokeColor: Colors.green,
        fillColor: Colors.amber,
        lineDashType: BMFLineDashType.LineDashTypeSquare,
        hollowShapes: [hollowShapeCircle]);
    myMapController.addCircle(_circle0!);
  }

  void addCircle1() {
    _circle1 = BMFCircle(
        center: BMFCoordinate(40.045, 116.404),
        radius: 4000,
        width: 6000,
        strokeColor: Colors.blue,
        fillColor: Colors.deepPurpleAccent,
        lineDashType: BMFLineDashType.LineDashTypeDot);
    myMapController.addCircle(_circle1!);
  }

  void addCircle2() {
    _circle2 = BMFCircle(
        center: BMFCoordinate(39.835, 116.404),
        radius: 7000,
        width: 14,
        strokeColor: Colors.blue,
        fillColor: Colors.brown,
        lineDashType: BMFLineDashType.LineDashTypeNone);
    myMapController.addCircle(_circle2!);
  }

  void removeCircle() {
    if (_circle0 != null) myMapController.removeOverlay(_circle0!.id);
    if (_circle1 != null) myMapController.removeOverlay(_circle1!.id);
    if (_circle2 != null) myMapController.removeOverlay(_circle2!.id);
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
