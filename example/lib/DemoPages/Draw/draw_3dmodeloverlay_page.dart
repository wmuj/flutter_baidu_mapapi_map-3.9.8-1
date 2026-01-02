import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class Draw3DModelOverlayPage extends StatefulWidget {
  Draw3DModelOverlayPage({Key? key}) : super(key: key);

  @override
  _Draw3DModelOverlayPageState createState() => _Draw3DModelOverlayPageState();
}

class _Draw3DModelOverlayPageState extends State<Draw3DModelOverlayPage> {
  late BMFMapController myMapController;
  late Size screenSize;

  late BMF3DModelOverlay _modelOverlay;
  late bool _addState = false;
  late String _btnText = "删除";

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      requestPermiss();
    }
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;
    _add3DmodelOverlay();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "3D模型",
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

  /// 创建地图
  Container generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: BMFMapOptions(
            center: BMFCoordinate(39.915119, 116.403963), zoomLevel: 16),
      ),
    );
  }

  void _add3DmodelOverlay() {
    BMF3DModelOption option = BMF3DModelOption(
        modelPath: 'resoures/Model3D', modelName: 'among_us', scale: 5);
    _modelOverlay = BMF3DModelOverlay(
        center: BMFCoordinate(39.915119, 116.403963), option: option);
    myMapController.add3dModelOverlay(_modelOverlay);
  }

  void _remove3DmodelOverlay() {
    myMapController.removeOverlay(_modelOverlay.id);
  }

  void onBtnPress() {
    if (_addState) {
      _add3DmodelOverlay();
    } else {
      _remove3DmodelOverlay();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  requestPermiss() async {
    Future<bool> isGranted = Permission.storage.isGranted;

    await isGranted.then((value) => {
          if (false == value) {Permission.storage.request()}
        });
  }
}
