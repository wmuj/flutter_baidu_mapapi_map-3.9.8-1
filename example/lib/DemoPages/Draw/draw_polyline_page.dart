import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// polyline折线绘制示例
class DrawPolylinePage extends StatefulWidget {
  DrawPolylinePage({Key? key}) : super(key: key);

  @override
  _DrawPolylinePageState createState() => _DrawPolylinePageState();
}

class _DrawPolylinePageState extends BMFBaseMapState<DrawPolylinePage> {
  late BMFPolyline _texturesPolyline;
  late BMFPolyline _colorsPolyline;

  bool _addState = false;
  String _btnText = "删除";

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addPolyline();
    }

    /// 地图点击覆盖物回调，目前只支持polyline，text
    /// polyline 只返回了id
    myMapController.setMapOnClickedOverlayCallback(
        callback: (BMFOverlay polyline) {
      print('地图点击覆盖物回调，只支持polyline=${polyline.toMap()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
            title: 'polyline示例',
            onBack: () {
              Navigator.pop(context);
            }),
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
              }),
        ],
      ),
    );
  }

  void onBtnPress() {
    if (_addState) {
      addPolyline();
    } else {
      removePolyline();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  void addPolyline() {
    addTexturesPolyline();
    addColorsPolyline();
  }

  /// 添加纹理渲染polyline
  void addTexturesPolyline() {
    List<BMFCoordinate> coordinates = List.filled(5, BMFCoordinate(0, 0));
    coordinates[0] = BMFCoordinate(39.965, 116.304);
    coordinates[1] = BMFCoordinate(39.925, 116.354);
    coordinates[2] = BMFCoordinate(39.955, 116.394);
    coordinates[3] = BMFCoordinate(39.905, 116.454);
    coordinates[4] = BMFCoordinate(39.965, 116.504);

    List<int> indexs = [0, 1, 2, 3];

    List<String> textures = List.filled(4, '');
    textures[0] = 'resoures/traffic_texture_smooth.png';
    textures[1] = 'resoures/traffic_texture_slow.png';
    textures[2] = 'resoures/traffic_texture_unknown.png';
    textures[3] = 'resoures/traffic_texture_smooth.png';

    _texturesPolyline = BMFPolyline.multiTextureline(
        coordinates: coordinates,
        textures: textures,
        indexs: indexs,
        width: 16,
        lineCapType: BMFLineCapType.LineCapButt,
        lineJoinType: BMFLineJoinType.LineJoinRound);
    myMapController.addPolyline(_texturesPolyline);
  }

  /// 添加颜色渲染polyline
  void addColorsPolyline() {
    List<BMFCoordinate> coordinates = List.filled(5, BMFCoordinate(0, 0));
    coordinates[0] = BMFCoordinate(39.865, 116.304);
    coordinates[1] = BMFCoordinate(39.825, 116.354);
    coordinates[2] = BMFCoordinate(39.855, 116.394);
    coordinates[3] = BMFCoordinate(39.805, 116.454);
    coordinates[4] = BMFCoordinate(39.865, 116.504);

    List<int> indexs = [2, 3, 2, 3];

    List<Color> colors = [];
    colors.add(Colors.blue);
    colors.add(Colors.orange);
    colors.add(Colors.red);
    colors.add(Colors.green);

    _colorsPolyline = BMFPolyline.multiColorline(
        coordinates: coordinates,
        colors: colors,
        indexs: indexs,
        width: 16,
        lineBloomMode: BMFLineBloomMode.LineBLUR,
        lineBloomBlurTimes: 5,
        lineBloomWidth: 16,
        lineDashType: BMFLineDashType.LineDashTypeSquare,
        lineCapType: BMFLineCapType.LineCapButt,
        lineJoinType: BMFLineJoinType.LineJoinRound);
    myMapController.addPolyline(_colorsPolyline);
  }

  /// 删除polyline
  void removePolyline() {
    myMapController.removeOverlay(_texturesPolyline.id);
    myMapController.removeOverlay(_colorsPolyline.id);
  }
}
