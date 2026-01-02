import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

class DrawMultiPointOverlayPage extends StatefulWidget {
  DrawMultiPointOverlayPage({Key? key}) : super(key: key);

  @override
  _DrawMultiPointOverlayPageState createState() =>
      _DrawMultiPointOverlayPageState();
}

class _DrawMultiPointOverlayPageState extends State<DrawMultiPointOverlayPage> {
  late BMFMapController myMapController;
  late Size screenSize;

  late BMFMultiPointOverlay _multiPointOverlay;
  late bool _addState = false;
  late String _btnText = "删除";

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 设置海量点回调
    myMapController.setMapOnClickedMultiPointOverlaItemCallback(
        callback: (multiPointOverlay, item) {
      print(
          'multiPointOverlay = ${multiPointOverlay.id} item = ${item.toMap()}');
    });

    /// 添加海量点
    _addMultiPointOverlay();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: "海量点",
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
            center: BMFCoordinate(40.048997, 116.309648), zoomLevel: 4),
      ),
    );
  }

  Future<void> _addMultiPointOverlay() async {
    /// 读取海量点
    String coordinateString = await rootBundle.loadString('resoures/10w.txt');
    // print('coordinateString = ${coordinateString}');

    /// string -> list
    List<String> coordStringList = coordinateString.split('\n');

    /// 海量点
    List<BMFMultiPointItem> items = [];
    for (var i = 0; i < 100000; i++) {
      List<String> itemString = coordStringList[i].split(',');
      BMFCoordinate coordinate = BMFCoordinate(
          double.parse(itemString[1]), double.parse(itemString[0]));
      BMFMultiPointItem item =
          BMFMultiPointItem(coordinate: coordinate, title: '${i}');
      items.add(item);
    }

    /// 构造海量点overlay
    _multiPointOverlay = BMFMultiPointOverlay(
        items: items,
        icon: 'resoures/marker_blue.png',
        pointSize: BMFSize(50, 50));
    await myMapController.addMultiPointOverlay(_multiPointOverlay);
  }

  void _removeMultiPointOverlay() {
    myMapController.removeOverlay(_multiPointOverlay.id);
  }

  void onBtnPress() {
    if (_addState) {
      _addMultiPointOverlay();
    } else {
      _removeMultiPointOverlay();
    }
    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }
}
