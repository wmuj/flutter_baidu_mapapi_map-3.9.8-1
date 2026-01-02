import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// arcline弧线绘制示例
class DrawArclinePage extends StatefulWidget {
  DrawArclinePage({Key? key}) : super(key: key);

  @override
  _DrawArclinePageState createState() => _DrawArclinePageState();
}

class _DrawArclinePageState extends BMFBaseMapState<DrawArclinePage> {
  BMFArcLine? _arcline0;
  BMFArcLine? _arcline1;
  BMFArcLine? _arcline2;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addArcline();
    }

    myMapController.setMapOnClickedOverlayCallback(
        callback: (BMFOverlay arcLine) {
          print('地图点击arcLine覆盖物回调=${arcLine.toMap()}');
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: 'arcline示例',
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
                _onBtnPress();
              }),
        ],
      ),
    );
  }

  void _onBtnPress() {
    if (_addState) {
      addArcline();
    } else {
      removeArcline();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addArcline() {
    //addArline0();
    addArcline1();
    addArcline2();
  }

  void addArline0() {
    List<BMFCoordinate> coordinates0 = [];
    coordinates0[0] = BMFCoordinate(40.065, 116.224);
    coordinates0[1] = BMFCoordinate(40.125, 116.404);
    coordinates0[2] = BMFCoordinate(40.065, 116.504);
    _arcline0 = BMFArcLine(
        coordinates: coordinates0,
        lineDashType: BMFLineDashType.LineDashTypeNone,
        width: 6,
        clickable: true,
        color: Colors.blue);
    myMapController.addArcline(_arcline0!);
  }

  void addArcline1() {
    List<BMFCoordinate> coordinates1 = List.filled(3, BMFCoordinate(0, 0));
    coordinates1[0] = BMFCoordinate(39.965, 116.324);
    coordinates1[1] = BMFCoordinate(39.825, 116.374);
    coordinates1[2] = BMFCoordinate(39.865, 116.304);
    _arcline1 = BMFArcLine(
        coordinates: coordinates1,
        lineDashType: BMFLineDashType.LineDashTypeDot,
        width: 4,
        clickable: true,
        color: Colors.green);
    myMapController.addArcline(_arcline1!);
  }

  void addArcline2() {
    List<BMFCoordinate> coordinates2 = List.filled(3, BMFCoordinate(0, 0));
    coordinates2[0] = BMFCoordinate(39.975, 116.224);
    coordinates2[1] = BMFCoordinate(39.935, 116.404);
    coordinates2[2] = BMFCoordinate(39.975, 116.584);
    _arcline2 = BMFArcLine(
        coordinates: coordinates2,
        lineDashType: BMFLineDashType.LineDashTypeDot,
        width: 30,
        clickable: true,
        color: Colors.red);
    myMapController.addArcline(_arcline2!);
  }

  void removeArcline() {
    // myMapController.removeOverlay(_arcline0!.id);
    myMapController.removeOverlay(_arcline1!.id);
    myMapController.removeOverlay(_arcline2!.id);
  }
}
