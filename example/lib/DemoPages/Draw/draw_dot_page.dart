import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// dot圆点绘制示例
class DrawDotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DrawDotPageState();
  }
}

class _DrawDotPageState extends BMFBaseMapState<DrawDotPage> {
  late BMFDot _bmfDot0;

  late BMFDot _bmfDot1;

  late BMFDot _bmfDot2;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    if (!_addState) {
      addDot();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
            appBar: BMFAppBar(
              title: 'dot示例',
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
      addDot();
    } else {
      removeDot();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addDot() {
    addDot0();
    addDot1();
    addDot2();
  }

  void addDot0() {
    _bmfDot0 = BMFDot(
        center: BMFCoordinate(39.835, 116.304),
        radius: 50,
        color: Colors.green);

    myMapController.addDot(_bmfDot0);
  }

  void addDot1() {
    _bmfDot1 = BMFDot(
        center: BMFCoordinate(39.835, 116.404),
        radius: 30,
        color: Colors.black);

    myMapController.addDot(_bmfDot1);
  }

  void addDot2() {
    _bmfDot2 = BMFDot(
        center: BMFCoordinate(39.835, 116.504), radius: 40, color: Colors.red);

    myMapController.addDot(_bmfDot2);
  }

  void removeDot() {
    myMapController.removeOverlay(_bmfDot0.id);
    myMapController.removeOverlay(_bmfDot1.id);
    myMapController.removeOverlay(_bmfDot2.id);
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
