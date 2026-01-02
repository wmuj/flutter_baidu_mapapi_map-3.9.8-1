import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_3dmodeloverlay_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_CollisionDetection_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_arcline_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_circle_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_dot_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_geodesicline_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_gradientline_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_ground_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_maker_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_multipointoverlay_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_polygon_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_polyline_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_prismoverlay_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_text_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Draw/draw_traceoverlay_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/utils.dart';

import 'map_draw_cluster_page.dart';

/// 在地图绘制入口
class MapDrawPage extends StatelessWidget {
  const MapDrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BMFAppBar(
          title: '在地图上绘制',
          isBack: false,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          FunctionItem(
            label: 'marker示例',
            sublabel: 'draw_maker_page',
            target: DrawMarkerPage(),
          ),
          FunctionItem(
            label: 'marker碰撞检测',
            sublabel: 'draw_collisiondetection_page',
            target: DrawCollisionDetectionPage(),
          ),
          FunctionItem(
            label: '点聚合示例',
            sublabel: 'marker点聚合',
            target: DrawClusterMarkerPage(),
          ),
          FunctionItem(
            label: 'polyline示例',
            sublabel: 'draw_polyline_page',
            target: DrawPolylinePage(),
          ),
          FunctionItem(
            label: 'arcline示例',
            sublabel: 'draw_arcline_page',
            target: DrawArclinePage(),
          ),
          FunctionItem(
            label: 'polygon示例',
            sublabel: 'draw_polygon_page',
            target: DrawPolygonPage(),
          ),
          FunctionItem(
            label: 'circle示例',
            sublabel: 'draw_circle_page',
            target: DrawCirclePage(),
          ),
          generatePlatformizationItem(
              Platform.isAndroid, 'dot示例', 'draw_dot_page', DrawDotPage()),
          FunctionItem(
              label: 'ground示例',
              sublabel: 'draw_ground_page',
              target: DrawGroundPage()),
          FunctionItem(
              label: 'text示例',
              sublabel: 'draw_text_page',
              target: DrawTextPage()),
          FunctionItem(
            label: '大地曲线示例',
            sublabel: 'draw_geodesicline_page',
            target: DrawGeodesicLinePage(),
          ),
          FunctionItem(
            label: '渐变线示例',
            sublabel: 'draw_gradientline_page',
            target: DrawGradientLinePage(),
          ),
          FunctionItem(
            label: '3D棱柱示例',
            sublabel: 'draw_prismoverlay_page',
            target: DrawPrismOverlayPage(),
          ),
          FunctionItem(
            label: '3D模型示例',
            sublabel: 'draw_3dmodeloverlay_page',
            target: Draw3DModelOverlayPage(),
          ),
          FunctionItem(
            label: '海量点示例',
            sublabel: 'draw_multipointoverlay_page',
            target: DrawMultiPointOverlayPage(),
          ),
          FunctionItem(
            label: '动态轨迹示例',
            sublabel: 'draw_traceoverlay_page',
            target: DrawTraceOverlayPage(),
          )
        ])));
  }
}
