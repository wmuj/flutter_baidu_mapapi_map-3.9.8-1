import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

class DrawGradientLinePage extends StatefulWidget {
  DrawGradientLinePage({Key? key}) : super(key: key);

  @override
  _DrawGradientLinePageState createState() => _DrawGradientLinePageState();
}

class _DrawGradientLinePageState extends BMFBaseMapState<DrawGradientLinePage> {
  late BMFGradientLine _gradientLine;
  late bool _addState = false;
  late String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    _addGradientLine();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "渐变线",
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

  void _addGradientLine() {
    /// 渐变线点
    List<BMFCoordinate> coords = [
      BMFCoordinate(39.965, 116.404),
      BMFCoordinate(39.925, 116.454),
      BMFCoordinate(39.955, 116.494),
      BMFCoordinate(39.905, 116.554),
      BMFCoordinate(39.965, 116.604)
    ];

    /// 分段索引
    List<int> indexs = [0, 1, 0, 1];

    /// 颜色数组
    List<Color> colors = [
      Color.fromARGB(123, 0, 0, 255),
      Color.fromARGB(123, 255, 0, 0),
      Color.fromARGB(123, 0, 255, 0),
      Color.fromARGB(123, 255, 214, 0)
    ];

    /// 构造渐变线
    _gradientLine = BMFGradientLine(
        coordinates: coords, indexs: indexs, colors: colors, width: 10);
    myMapController.addGradientLine(_gradientLine);
  }

  void _removeGradientLine() {
    myMapController.removeOverlay(_gradientLine.id);
  }

  void onBtnPress() {
    if (_addState) {
      _addGradientLine();
    } else {
      _removeGradientLine();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }
}
