import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';

import 'flutter_map_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 设置用户是否同意SDK隐私协议
  BMFMapSDK.setAgreePrivacy(true);

  // 百度地图sdk初始化鉴权
  if (Platform.isIOS) {
    BMFMapSDK.setApiKeyAndCoordType('请输入您的AK', BMF_COORD_TYPE.BD09LL);
  } else if (Platform.isAndroid) {
    /// 初始化获取Android 系统版本号
    await BMFAndroidVersion.initAndroidVersion();
    // Android 目前不支持接口设置Apikey,
    // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  }
  Map? map = await BMFMapVersion.nativeMapVersion;
  print('获取原生地图版本号：$map');
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: BMFAppBar(
            title: '百度地图flutter插件Demo',
            isBack: false,
          ),
          body: FlutterBMFMapDemo()),
    );
  }
}
