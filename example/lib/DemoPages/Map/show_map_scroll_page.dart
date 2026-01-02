import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';

/// 地图滑动示例
class ShowMapScrollPage extends StatefulWidget {
  ShowMapScrollPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowMapScrollPage createState() => _ShowMapScrollPage();
}

class _ShowMapScrollPage extends BMFBaseMapState<ShowMapScrollPage>{
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
        rotation: 0.0,
        rotateEnabled: false,
        overlooking: 0.0,
        overlookEnabled: false,
        showZoomControl: false,
        gesturesEnabled: true,
        zoomEnabled: true,
        zoomEnabledWithTap: true,
        zoomEnabledWithDoubleClick: true,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        logoPosition: BMFLogoPosition.LeftBottom,
        center: center);
    return mapOptions;
  }

  bool _isMapInteracting = false;

  Scaffold generateMap2() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          // 当地图正在交互时，阻止父容器滚动
          return _isMapInteracting;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 400, color: Colors.blue),
              Listener(
                onPointerDown: (_) => _isMapInteracting = true,
                onPointerUp: (_) => _isMapInteracting = false,
                child: SizedBox(
                    height: 300,
                    child:
                    BMFMapWidget(
                      onBMFMapCreated: (mapController) {
                        myMapController = mapController;
                      },
                      mapOptions: initMapOptions(),
                    )
                ),
              ),
              Container(height: 1000, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: BMFAppBar(
            title: '地图ScrollView使用示例',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          body: Stack(children: <Widget>[generateMap2()]),
        ));
  }
}
