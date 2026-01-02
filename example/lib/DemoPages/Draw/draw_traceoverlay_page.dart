import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';

import '../../constants.dart';

class DrawTraceOverlayPage extends StatefulWidget {
  DrawTraceOverlayPage({Key? key}) : super(key: key);

  @override
  _DrawTraceOverlayPageState createState() => _DrawTraceOverlayPageState();
}

class _DrawTraceOverlayPageState extends State<DrawTraceOverlayPage> {
  late BMFMapController myMapController;
  late Size screenSize;

  late BMFTraceOverlay _traceOverlay;
  late bool _addState = false;
  late String _btnText = "删除";

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 设置traceOverlay动画开始回调
    myMapController.setTraceOverlayAnimationDidStartCallback((traceOverlay) {
      print(
          'TraceOverlayAnimationDidStartCallback: traceOverlay = ${traceOverlay.id}');
    });

    /// 设置traceOverlay动画进度回调
    myMapController.setTraceOverlayAnimationRunningProgressCallback(
            (traceOverlay, progress) {
          print(
              'TraceOverlayAnimationRunningProgressCallback: traceOverlay = ${traceOverlay.id} progress = ${progress}}');
        });

    /// 设置traceOverlay动画结束回调
    myMapController
        .setTraceOverlayAnimationDidEndCallback((traceOverlay, flag) {
      print(
          'TraceOverlayAnimationDidEndCallback: traceOverlay = ${traceOverlay.id} flag = ${flag}}');
    });

    myMapController
        .setTraceOverlayAnimationUpdatePositionCallback((coordinate) {
      print(
          'setTraceOverlayAnimationUpdatePositionCallback: coordinate = ${coordinate.toMap()}}');
    });

    /// 添加traceOverlay
    _addTraceOverlay();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "动态轨迹",
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
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Text(
              "暂停",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            onPressed: () {
              _traceOverlay.pauseTraceOverlayDraw();
            },
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Text(
              "继续",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            onPressed: () {
              _traceOverlay.resumeTraceOverlayDraw();
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
            center: BMFCoordinate(40.048997, 116.309648), zoomLevel: 16),
      ),
    );
  }

  Future<void> _addTraceOverlay() async {
    /// 读取动态轨迹点
    String coordinateStrings =
    await rootBundle.loadString('resoures/trace_path.txt');

    /// string -> list
    List<String> coordinateStringList = coordinateStrings.split(',');

    /// 动态轨迹点
    List<BMFCoordinate> coords = [];

    /// 渐变色
    List<Color> colors = [];
    for (var i = 0; i < coordinateStringList.length; i += 2) {
      BMFCoordinate coordinate = BMFCoordinate(
          double.parse(coordinateStringList[i + 1]),
          double.parse(coordinateStringList[i]));
      coords.add(coordinate);
      if (i < 50) {
        colors.add(Color.fromARGB(255, 255, 0, 0));
      } else if (i >= 50 && i < 100) {
        colors.add(Color.fromARGB(255, 0, 255, 0));
      } else if (i >= 100 && i < 150) {
        colors.add(Color.fromARGB(255, 0, 0, 255));
      } else {
        colors.add(Color.fromARGB(255, 123, 11, 13));
      }
    }

    /// 构造动态轨迹动画参数
    BMFTraceOverlayAnimateOption traceOverlayAnimateOption =
    BMFTraceOverlayAnimateOption(
      animate: true,
      delay: 0.0,
      duration: 8,
      fromValue: 0.0,
      toValue: 1.0,
      easingCurve: BMFTraceOverlayAnimationEasingCurve.Linear,
      trackMove: false,
      isPointMove: true,
      isRotateWhenTrack: true,
      // icon: "resoures/driving.png",
      modelOption: BMFTrace3DModelOption(
          modelName: "scenes",
          modelPath: 'resoures/Model3D',
          yawAxis: BMFTraceOverlay3DModelYawAxis.YawAxisX,
          scale: 3.0,
          zoomFixed: true,
          animationIsEnable: true,
          animationIndex: 1,
          type: BMF3DModelType.BMF3DModelTypeGLTF),
    );

    /// 构造动态轨迹
    _traceOverlay = BMFTraceOverlay(
        coordinates: coords,
        traceOverlayAnimateOption: traceOverlayAnimateOption,
        isTrackBloom: true,
        isGradientColor: true,
        bloomSpeed: 5.0,
        isCornerSmooth: false,
        strokeColors: colors);
    await myMapController.addTraceOverlay(_traceOverlay);
  }

  void _removeTraceOverlay() {
    myMapController.removeTraceOverlay(_traceOverlay.id);
  }

  void onBtnPress() {
    if (_addState) {
      _addTraceOverlay();
    } else {
      _removeTraceOverlay();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }
}
