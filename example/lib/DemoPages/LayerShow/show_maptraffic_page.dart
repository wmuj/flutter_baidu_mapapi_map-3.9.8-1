import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_base_page_state.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 路况图示例
class ShowMapTrafficPage extends StatefulWidget {
  ShowMapTrafficPage({Key? key}) : super(key: key);

  @override
  _ShowMapTrafficPageState createState() => _ShowMapTrafficPageState();
}

class _ShowMapTrafficPageState extends BMFBaseMapState<ShowMapTrafficPage> {
  /// 地图controller
  bool _trafficEnabled = true;

  @override
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);

    /// 地图加载回调
    myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
      //设置路况颜色
      myMapController.setCustomTrafficColor(
          smooth: Colors.blue,
          slow: Colors.orange,
          congestion: Colors.pink,
          severeCongestion: Colors.red);
      myMapController
          .updateMapOptions(BMFMapOptions(trafficEnabled: _trafficEnabled));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: BMFAppBar(
          title: '路况图示例',
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(children: <Widget>[generateMap(), generateControlBar()]),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Switch(
                value: _trafficEnabled,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _trafficEnabled = value;
                    myMapController.updateMapOptions(
                        BMFMapOptions(trafficEnabled: _trafficEnabled));
                  });
                }),
            Text(
              '地图展示路况',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
