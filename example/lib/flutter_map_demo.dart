import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/map_draw_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Interact/show_interact_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/LayerShow/show_layer_map_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_create_map_page.dart';

class FlutterBMFMapDemo extends StatelessWidget {
  const FlutterBMFMapDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: <Widget>[
        FunctionItem(
          label: '创建地图',
          sublabel: '基础地图、个性化地图、TextureMapView、离线地图、室内地图以及多地图创建',
          target: ShowCreateMapPage(),
        ),
        FunctionItem(
          label: '图层展示',
          sublabel: '卫星图、交通流量图、百度城市热力图、3D地图及定位图层的展示',
          target: ShowLayerMapPage(),
        ),
        FunctionItem(
          label: '在地图上绘制',
          sublabel: '介绍自定义绘制点、线、多边形、圆等几何图形和文字',
          target: MapDrawPage(),
        ),
        FunctionItem(
          label: '与地图交互',
          sublabel: '介绍地图基本控制方法，事件响应、手势控制以及UI控件的显示与隐藏',
          target: ShowInteractPage(),
        ),
      ]),
    );
  }
}
