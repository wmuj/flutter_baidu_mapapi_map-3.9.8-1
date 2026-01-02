import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// marker绘制示例
class DrawMarkerPage extends StatefulWidget {
  DrawMarkerPage({
    Key? key,
  }) : super(key: key);

  @override
  _DrawMarkerPageState createState() => _DrawMarkerPageState();
}

class DragState {
  ///开始拖拽
  static const String sDragStart = "dragStart";

  /// 正在拖拽
  static const String sDragging = "dragging";

  ///拖拽完成
  static const String sDragEnd = "dragEnd";
}

class _DrawMarkerPageState extends BMFBaseMapState<DrawMarkerPage> {
  // static const TAG = "_DrawMarkerPageState";

  /// 地图controller
  late BMFMarker _marker;
  late BMFMarker _marker0;
  final List<BMFMarker> _markers = [];
  String? _markerID;
  String? _action;
  String? _state;
  late bool _show;
  BMFCoordinate? _coordinates;

  // final BMFCoordinate _startPos = BMFCoordinate(39.928617, 116.30329);
  // final BMFCoordinate _endPos = BMFCoordinate(39.928617, 116.50329);

  bool _addState = false;
  String _btnText = "删除";

  // Timer _timer;

  bool enable = true;
  bool dragable = true;

  bool startState = true;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    if (!_addState) {
      addMarkers();
    }

    /// 地图marker选中回调
    myMapController.setMaptDidSelectMarkerCallback(
        callback: (BMFMarker marker) {
      print('mapDidSelectMarker-- marker = ${marker.toMap()}');

      setState(() {
        _markerID = marker.id;
        _action = "选中";
      });
    });

    /// 地图marker取消选中回调
    myMapController.setMapDidDeselectMarkerCallback(
        callback: (BMFMarker marker) {
      print('MapDidDeselectMarker-- marker = ${marker.toMap()}');

      setState(() {
        _markerID = marker.id;
        _action = "取消选中";
      });
    });

    /// 地图marker点击回调
    myMapController.setMapClickedMarkerCallback(callback: (BMFMarker marker) {
      print('MapClickedMarker-- marker = ${marker.toMap()}');
      setState(() {
        _markerID = marker.id;
        _action = "点击";
      });
    });

    /// 拖拽marker点击回调
    myMapController.setMapDragMarkerCallback(callback: (BMFMarker marker,
        BMFMarkerDragState newState, BMFMarkerDragState oldState) {
      print(
          'MapDragMarker-- marker = ${marker.toMap()}\n newState = ${newState.toString()}\n oldState = ${oldState.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
          appBar: generateAppBar(),
          body: Stack(children: <Widget>[
            generateMap(),
            generateControlBar(),
          ])),
    );
  }

  /// 添加大头针
  void addMarker() {
    BMFMarker marker = BMFMarker.icon(
        position: BMFCoordinate(39.928617, 116.40329),
        title: 'flutterMaker',
        subtitle: 'test',
        identifier: 'flutter_marker',
        icon: 'resoures/icon_end.png');
    // bool result;
    myMapController.addMarker(marker);
    _marker = marker;
  }

  BMFAppBar generateAppBar() {
    return BMFAppBar(
        title: 'marker示例',
        onBack: () {
          Navigator.pop(context);
        });
  }

  Container generateMarkerInfo() {
    Text text;
    if (null == _markerID || _markerID!.isEmpty) {
      text = Text('');
    } else if (_action != "拖拽") {
      text = Text('当前marker id:$_markerID, 操作类型: $_action');
    } else if (_state != DragState.sDragging && null != _coordinates) {
      double latitude = _coordinates!.latitude;
      double longtitude = _coordinates!.longitude;
      text = Text(
          '当前marker id:$_markerID, 操作类型:$_action 状态:$_state x:$latitude y:$longtitude');
    } else {
      text = Text('当前marker id:$_markerID, 操作类型:$_action 状态:$_state');
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 400,
      height: 40,
      child: text,
    );
  }

  /// 创建地图
  @override
  Container generateMap() {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: initMapOptions(),
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
      addMarkers();
    } else {
      removeMarkers();
    }

    _addState = !_addState;
    setState(() {
      _btnText = _addState == true ? "添加" : "删除";
    });
  }

  /// 创建更新属性栏
  Row generateUpdateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(child: Text('更新位置'), onPressed: () {}),
        Switch(
            value: _show,
            activeColor: Colors.green,
            onChanged: (bool value) {
              setState(() {
                _show = value;
              });
            }),
        Text('锁定屏幕位置'),
      ],
    );
  }

  /// 删除大头针
  void removeMarker() {
    myMapController.removeMarker(_marker);
  }

  /// 批量添加大头针
  Future<void> addMarkers() async {
    if (_markers.isEmpty) {
      BMFLog.d('dragable:$dragable', tag: '_DrawMarkerPageState');
      ByteData bytes = await rootBundle.load('resoures/icon_ugc_start.png');
      Uint8List iconData = bytes.buffer.asUint8List();
      _marker0 = BMFMarker.iconData(
          position: BMFCoordinate(39.928617, 116.40329),
          title: '第一个',
          subtitle: 'test',
          identifier: 'flutter_marker',
          iconData: iconData,
          enabled: enable,
          draggable: dragable,
          customMap: {'id': 123, "phone": "110"});

      _markers.add(_marker0);
      await myMapController.addMarkers(_markers);
    }
  }

  /// 批量删除大头针
  void removeMarkers() {
    myMapController.removeMarkers(_markers);
    _markers.clear();
  }

  Future<Uint8List> loadAsset() async {
    ByteData bytes = await rootBundle.load('resoures/icon_ugc_start.png');
    //  Uint8List list = bytes.buffer.asUint8List();
    return bytes.buffer.asUint8List();
  }
}
