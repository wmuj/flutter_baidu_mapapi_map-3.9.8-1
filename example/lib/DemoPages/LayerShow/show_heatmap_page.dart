import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

enum HeatMapType {
  // 自定义热力图
  CustomHeatMap,

  // 百度自有热力图
  BaiduHeatMap
}

/// 热力图示例
class ShowHeatMapPage extends StatefulWidget {
  ShowHeatMapPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ShowHeatMapPageState();
  }
}

class _ShowHeatMapPageState extends BMFBaseMapState<ShowHeatMapPage> {
  BMFHeatMap? _heatMap;
  HeatMapType heatMapType = HeatMapType.CustomHeatMap;

  bool _customHeatMapEnable = true;
  double sliderValue = 0;

  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      if (true == _customHeatMapEnable) {
        addHeatMap();
        myMapController.showHeatMap(false);
      }
    });

    myMapController.setHeatMapFrameAnimationIndexCallback(
        callback: (int index) {
          setState(() {
            print("热力图index：${index}");
          });
        });
  }

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
          appBar: BMFAppBar(
            title: '自定义热力图示例',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(children: <Widget>[
            generateMap(),
            generateControlBar(),
            animationButton(),
            Positioned(
              child: animationSlider(),
              bottom: 50,
            ),
          ]),
        ));
  }

  /// 加载热力图数据
  Future<List<BMFCoordinate>?> loadHeatMapData() async {
    Future<String> jsonString =
    DefaultAssetBundle.of(context).loadString('files/heatMapData.json');
    List<BMFCoordinate>? result;
    await jsonString.then((String value) async {
      List? list = json.decode(value);
      result = list?.map((coord) => BMFCoordinate.fromMap(coord)).toList();
    });
    return result;
  }

  Widget animationButton() {
    return Container(
      width: 150,
      height: 200,
      child: Column(children: [
        SizedBox(height: 70),
        ElevatedButton(
          onPressed: () {
            myMapController.startHeatMapFrameAnimation();
          },
          child: Text('开始动画'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            myMapController.stopHeatMapFrameAnimation();
          },
          child: Text('停止动画'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ]),
    );
  }

  Slider animationSlider() {
    return Slider(
      value: sliderValue,
      max: 20,
      onChanged: (value) {
        print("onChanged : $value");
        updateSlider(value);
      },
      onChangeStart: (value) {
        print("onChangeStart : $value");
        updateSlider(value);
      },
      onChangeEnd: (value) {
        print("onChangeEnd : $value");
        updateSlider(value);
      },
    );
  }

  void updateSlider(value) {
    sliderValue = value;
    setState(() {
      myMapController.setHeatMapFrameAnimatioIndex(value.round());
    });
  }

  @override
  Widget generateControlBar() {
    return Container(
        width: screenSize.width,
        height: 60,
        color: Color(int.parse(Constants.controlBarColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: HeatMapType.CustomHeatMap,
              groupValue: this.heatMapType,
              onChanged: (value) {
                myMapController.showHeatMap(false);
                setState(() {
                  addHeatMap();
                  this.heatMapType = value as HeatMapType;
                });
              },
            ),
            Text(
              "自定义热力图",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 20),
            Radio(
              value: HeatMapType.BaiduHeatMap,
              groupValue: this.heatMapType,
              onChanged: (value) async {
                removeHeatMap();
                myMapController.showHeatMap(true);
                setState(() {
                  this.heatMapType = value as HeatMapType;
                });
              },
            ),
            Text(
              "百度自有热力图",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  /// 删除热力图
  void removeHeatMap() {
    myMapController.removeHeatMap();
  }

  /// 添加自定义热力图
  Future<void> addHeatMap() async {
    if (_heatMap != null) {
      await myMapController.addHeatMap(_heatMap!);
      return;
    }

    /// 加载热力图数据
    List<BMFCoordinate>? _heatMapData = await loadHeatMapData();
    int count = _heatMapData?.length ?? 0;
    Random random = Random(300);

    /// 构建热力图节点信息
    List<List<BMFHeatMapNode>> heatMapNodeDatas = [];

    for (var i = 0; i < 20; i++) {
      List<BMFHeatMapNode> heatMapNodes = [];

      for (int i = 0; i < count; i++) {
        // random.nextInt(900) + 0.0 随机生成点强度
        heatMapNodes.add(BMFHeatMapNode(
            pt: _heatMapData![i], intensity: random.nextInt(900) + 0.0));
      }
      heatMapNodeDatas.add(heatMapNodes);
    }

    /// 颜色渐变
    BMFGradient gradient = BMFGradient(
        colors: [Colors.blue, Colors.yellow, Colors.red],
        startPoints: [0.08, 0.4, 1.0]);

    /// 热力图层
    _heatMap = BMFHeatMap(
        datas: heatMapNodeDatas,
        gradient: gradient,
        radius: 12,
        maxShowLevel: 19,
        minShowLevel: 4,
        opacity: 0.6,
        mMaxHight: 100,
        mMaxIntensity: 1,
        mMinIntensity: 0,
        animation:
        BMFAnimation(duration: 600, type: BMFAnimationType.CosineCurve),
        frameAnimation:
        BMFAnimation(duration: 3000, type: BMFAnimationType.OutSine));
    await myMapController.addHeatMap(_heatMap!);
    // await _mapController?.showHeapMap(true);
  }
}
