import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

class DrawPrismOverlayPage extends StatefulWidget {
  DrawPrismOverlayPage({Key? key}) : super(key: key);

  @override
  _DrawPrismOverlayPageState createState() => _DrawPrismOverlayPageState();
}

class _DrawPrismOverlayPageState extends State<DrawPrismOverlayPage> {
  late BMFMapController myMapController;
  late Size screenSize;

  late BMFPrismOverlay _prismOverlay;
  late bool _addState = false;
  late String _btnText = "删除";

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "3D棱柱绘制",
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: [
            _generateMap(),
            _generateControlBar(),
          ],
        ),
      ),
    );
  }

  /// 创建地图
  Container _generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          _onBMFMapCreated(controller);
        },
        mapOptions: BMFMapOptions(
            center: BMFCoordinate(23.1007452, 113.5056388),
            zoomLevel: 21,
            overlooking: -45),
      ),
    );
  }

  Widget _generateControlBar() {
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
              _onBtnPress();
            },
          )
        ],
      ),
    );
  }

  void _addPrismOverlay() {
    /// 棱柱围点
    List<BMFCoordinate> coords = [
      BMFCoordinate(23.1007972, 113.5056531),
      BMFCoordinate(23.1007758, 113.5056175),
      BMFCoordinate(23.1007452, 113.5056388),
      BMFCoordinate(23.1007892, 113.505714),
      BMFCoordinate(23.1008206, 113.5056922),
      BMFCoordinate(23.1007972, 113.5056531)
    ];

    /// 构造3d棱柱
    _prismOverlay = BMFPrismOverlay.colorPrismOverlay(
        coordinates: coords,
        topFaceColor: Colors.green,
        sideFaceColor: Colors.green,
        height: 20);
    myMapController.addPrismOverlay(_prismOverlay);
  }

  void _removePrismOverlay() {
    myMapController.removeOverlay(_prismOverlay.id);
  }

  void _onBtnPress() {
    _addState ? _addPrismOverlay() : _removePrismOverlay();
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  /// 创建完成回调
  void _onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;
    _addPrismOverlay();
  }
}
