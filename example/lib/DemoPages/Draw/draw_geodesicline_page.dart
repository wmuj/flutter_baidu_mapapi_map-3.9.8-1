import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

class DrawGeodesicLinePage extends StatefulWidget {
  DrawGeodesicLinePage({Key? key}) : super(key: key);

  @override
  _DrawGeodesicLinePageState createState() => _DrawGeodesicLinePageState();
}

class _DrawGeodesicLinePageState extends BMFBaseMapState<DrawGeodesicLinePage> {
  late BMFGeodesicLine _geodesicLine;
  late bool _addState = false;
  late String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    BMFMapOptions options = BMFMapOptions(zoomLevel: 4);
    controller.updateMapOptions(options);

    _addGeodesicLine();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "大地曲线",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            generateMap(),
            generateControlBar(),
          ],
        ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text(
              _btnText,
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            onPressed: () {
              onBtnPress();
            },
          )
        ],
      ),
    );
  }

  void _addGeodesicLine() {
    List<BMFCoordinate> coords = [];
    coords.add(BMFCoordinate(36.53, -121.47));
    coords.add(BMFCoordinate(22.33, 114));

    _geodesicLine = BMFGeodesicLine(
        coordinates: coords,
        width: 5,
        strokeColor: Colors.blue,
        lineDirectionCross180: BMFLineDirectionCross180Type.EAST_TO_WEST);
    myMapController.addGeodesicLine(_geodesicLine);
  }

  void _removeGeodesicLine() {
    myMapController.removeOverlay(_geodesicLine.id);
  }

  void onBtnPress() {
    if (_addState) {
      _addGeodesicLine();
    } else {
      _removeGeodesicLine();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }
}
