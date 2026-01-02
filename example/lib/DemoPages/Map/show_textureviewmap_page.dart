import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';

/// TextureView地图示例示例
class ShowTextureViewMapPage extends StatefulWidget {
  ShowTextureViewMapPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowTextureViewMapPage createState() => _ShowTextureViewMapPage();
}

class _ShowTextureViewMapPage extends BMFBaseMapState<ShowTextureViewMapPage> {
  /// 创建完成回调
  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('MapDidLoad-地图加载回调');
    });

    /// 地图渲染回调
    myMapController.setMapDidFinishedRenderCallback(callback: (bool success) {
      print('mapDidFinishedReder-地图渲染完成');
    });

    /// 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
    myMapController.setMapOnDrawMapFrameCallback(
        callback: (BMFMapStatus mapStatus) {
      print('地图渲染每一帧\n mapStatus = ${mapStatus.toMap()}');
    });
  }

  /// 设置地图参数
  @override
  BMFMapOptions initMapOptions() {
    BMFCoordinate center = BMFCoordinate(39.965, 116.404);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 15,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        compassPosition: BMFPoint(0, 0),
        logoPosition: BMFLogoPosition.LeftBottom,
        //116.40329,39.928617
        center: center);
    return mapOptions;
  }

  @override
  Container generateMap() {
    return Container(
      child: BMFTextureMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: initMapOptions(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: BMFAppBar(
            title: 'TextureView地图示例',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: generateMap()),
    );
  }
}
