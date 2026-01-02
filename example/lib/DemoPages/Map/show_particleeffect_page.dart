import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

import '../../CustomWidgets/map_appbar.dart';
import '../../CustomWidgets/map_base_page_state.dart';
import '../../constants.dart';

class ShowParticleEffectPage extends StatefulWidget {
  ShowParticleEffectPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowParticleEffectPageState createState() => _ShowParticleEffectPageState();
}

class _ShowParticleEffectPageState
    extends BMFBaseMapState<ShowParticleEffectPage> {
  BMFParticleEffectType _effectType = BMFParticleEffectType.PUnknow;
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    myMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: BMFAppBar(
        title: '粒子效果展示',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
    ));
  }

  @override
  Widget generateControlBar() {
    return Container(
        width: screenSize.width,
        height: 100,
        color: Color(int.parse(Constants.controlBarColor)),
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 3.0,
              runSpacing: -3.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '雪',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _effectType = BMFParticleEffectType.Snow;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '雨',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _effectType = BMFParticleEffectType.RainStorm;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '雾霾',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _effectType = BMFParticleEffectType.Smog;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '沙尘暴',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _effectType = BMFParticleEffectType.SandStorm;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '烟花',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _effectType = BMFParticleEffectType.Fireworks;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '花瓣',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _effectType = BMFParticleEffectType.Flower;
                      showEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '关闭粒子效果',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      closeEffect();
                    }),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: defaultBtnBgColor),
                    child: Text(
                      '自定义雪花粒子效果',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      customEffect();
                    }),
                SizedBox(width: 0),
              ],
            ),
          ],
        ));
  }

  showEffect() async {
    bool suc = await myMapController.showParticleEffect(_effectType);
    if (suc) {
      print('粒子效果设置成功');
    } else {
      print('粒子效果设置失败');
    }
  }

  closeEffect() {
    myMapController.closeParticleEffect(BMFParticleEffectType.PUnknow);
  }

  customEffect() async {
    List<String> imgs = [];
    imgs.add('resoures/below_s.png');
    imgs.add('resoures/driving.png');
    BMFParticleEffectOption option = BMFParticleEffectOption(
        location: BMFCoordinate(39.98192, 116.324356), images: imgs);
    myMapController.customParticleEffectWithOption(_effectType, option);
    bool suc = await myMapController.showParticleEffect(_effectType);
    if (suc) {
      print('自定义粒子效果设置成功');
    } else {
      print('自定义粒子效果设置失败');
    }
  }

  /// 设置地图参数
  @override
  BMFMapOptions initMapOptions() {
    BMFCoordinate center = BMFCoordinate(39.965, 116.404);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 12,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        compassPosition: BMFPoint(0, 0),
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        logoPosition: BMFLogoPosition.LeftBottom,
        center: center);
    return mapOptions;
  }
}
