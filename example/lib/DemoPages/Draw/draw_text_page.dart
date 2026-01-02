import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// text文本绘制示例
///
/// Android独有
class DrawTextPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DrawTextPageState();
  }
}

class _DrawTextPageState extends BMFBaseMapState<DrawTextPage> {
  late BMFText _bmfText0;
  late BMFText _bmfText1;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addText();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: BMFAppBar(
        title: 'text示例',
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
      addText();
    } else {
      removeText();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addText() {
    addText0();
    addText1();
  }

  void addText0() {
    BMFCoordinate position = new BMFCoordinate(39.83235, 116.350338);

    _bmfText0 = BMFText(
        text: 'hello world',
        position: position,
        bgColor: Colors.blue,
        fontColor: Colors.red,
        fontSize: 50,
        typeFace: BMFTypeFace(
            familyName: BMFFamilyName.sMonospace,
            textStype: BMFTextStyle.BOLD_ITALIC),
        alignY: BMFVerticalAlign.ALIGN_BOTTOM,
        alignX: BMFHorizontalAlign.ALIGN_LEFT);

    myMapController.addText(_bmfText0);
  }

  void addText1() {
    BMFCoordinate position = new BMFCoordinate(39.73235, 116.350338);

    _bmfText1 = BMFText(
        text: '欢迎使用百度地图SDK',
        position: position,
        bgColor: Colors.red,
        fontColor: Colors.white,
        fontSize: 50,
        typeFace: BMFTypeFace(
            familyName: BMFFamilyName.sSansSerif,
            textStype: BMFTextStyle.NORMAL),
        alignY: BMFVerticalAlign.ALIGN_CENTER_VERTICAL,
        alignX: BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
        rotate: 0.0);

    myMapController.addText(_bmfText1);
  }

  void removeText() {
    myMapController.removeOverlay(_bmfText0.id);
    myMapController.removeOverlay(_bmfText1.id);
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
