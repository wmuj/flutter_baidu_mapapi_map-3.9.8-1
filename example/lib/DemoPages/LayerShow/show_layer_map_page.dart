import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_3dbuildings_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_heatmap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_maptraffic_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_tilemap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_userlocation_mode_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_userlocation_page.dart';

/// 图层展示入口
class ShowLayerMapPage extends StatelessWidget {
  const ShowLayerMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BMFAppBar(
          title: '图层展示',
          isBack: false,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          FunctionItem(
            label: '热力图示例',
            sublabel: 'show_heatmap_page',
            target: ShowHeatMapPage(),
          ),
          FunctionItem(
            label: '路况图示例',
            sublabel: 'show_maptraffic_page',
            target: ShowMapTrafficPage(),
          ),
          FunctionItem(
            label: '瓦片图示例',
            sublabel: 'show_tilemap_page',
            target: ShowTileMapPage(),
          ),
          FunctionItem(
            label: '3D建筑物地图示例',
            sublabel: 'show_3dbuildings_page',
            target: Show3DBuildingsMapPage(),
          ),
          FunctionItem(
            label: '自定义定位图层示例',
            sublabel: 'show_userlocation_page',
            target: ShowUserLoationPage(),
          ),
          FunctionItem(
            label: '定位模式示例',
            sublabel: 'show_userlocation_mode_page',
            target: ShowUserLoationModePage(),
          ),
        ])));
  }
}
