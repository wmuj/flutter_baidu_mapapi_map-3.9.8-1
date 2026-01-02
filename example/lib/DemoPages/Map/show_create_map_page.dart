import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_custommap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_indoormap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_list_map_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_map_scroll_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_map_type_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_multimap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_offline_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_particleeffect_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/Map/show_textureviewmap_page.dart';
import 'package:flutter_baidu_mapapi_map_example/DemoPages/utils.dart';

/// 地图入创建入口
class ShowCreateMapPage extends StatelessWidget {
  const ShowCreateMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BMFAppBar(
          title: '创建地图',
          isBack: false,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          FunctionItem(
            label: '地图类型示例',
            sublabel: 'show_map_type_page',
            target: ShowMapTypePage(),
          ),
          generatePlatformizationItem(Platform.isAndroid, 'TextureView地图示例',
              'show_textureviewmap_page', ShowTextureViewMapPage()),
          FunctionItem(
            label: '粒子效果',
            sublabel: '多种粒子效果展示',
            target: ShowParticleEffectPage(),
          ),
          FunctionItem(
            label: '多地图示例',
            sublabel: 'show_multimap_page',
            target: ShowMultiMapPage(),
          ),
          FunctionItem(
            label: '室内图示例',
            sublabel: 'show_indoormap_page',
            target: ShowIndoorMapPage(),
          ),
          FunctionItem(
            label: '个性化地图示例',
            sublabel: 'show_custommap_page',
            target: ShowCustomMapPage(),
          ),
          FunctionItem(
            label: '离线地图示例',
            sublabel: 'show_offline_page',
            target: ShowOfflineMapPage(),
          ),
          FunctionItem(
              label: 'listView上展示地图',
              sublabel: 'show_list_map_page',
              target: ShowListMapPage()),
          FunctionItem(
              label: '地图ScrollView使用示例',
              sublabel: 'show_map_scroll_page',
              target: ShowMapScrollPage()),
        ])));
  }
}
