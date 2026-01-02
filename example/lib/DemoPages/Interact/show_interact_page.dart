import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Interact/show_mapinteract_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Interact/show_mapscreenshot_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Interact/show_mapzoom_page.dart';

/// 地图交互入口
class ShowInteractPage extends StatelessWidget {
  const ShowInteractPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BMFAppBar(
          title: '与地图交互',
          isBack: false,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          FunctionItem(
            label: '修改地图中心点，以及触摸点、poi点显示',
            sublabel: 'show_mapinteract_page',
            target: ShowMapInteractPage(),
          ),
          FunctionItem(
            label: '地图截图示例',
            sublabel: 'show_mapscreenshot_page',
            target: ShowMapScreenshotPage(),
          ),
          FunctionItem(
            label: '缩放地图示例',
            sublabel: 'show_mapzoom_page',
            target: ShowMapZoomPage(),
          ),
        ])));
  }
}
