import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFNativeViewType;
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_controller.dart';
import 'package:flutter_baidu_mapapi_map/src/map/bmf_map_view.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_map_options.dart';

/// textureMapView,android设备独有
class BMFTextureMapWidget extends StatefulWidget {
  const BMFTextureMapWidget({
    Key? key,
    required this.onBMFMapCreated,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
    this.layoutDirection,
    this.mapOptions,
  }) : super(key: key);

  /// 创建mapView回调
  final BMFMapCreatedCallback onBMFMapCreated;

  /// 渗透点击事件，接收范围 opaque > translucent > transparent；
  final PlatformViewHitTestBehavior hitTestBehavior;

  /// 嵌入视图文本方向
  final TextDirection? layoutDirection;

  /// map属性配置
  final BMFMapOptions? mapOptions;
  @override
  _BMFTextureMapWidgetState createState() => _BMFTextureMapWidgetState();
}

class _BMFTextureMapWidgetState extends State<BMFTextureMapWidget> {
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  ].toSet();
  
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // ios没有textureView
      return Text('BMFTextureMapWidget不支持$defaultTargetPlatform');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: BMFNativeViewType.sTextureMapView,
        onPlatformViewCreated: _onPlatformCreated,
        gestureRecognizers: _gestureRecognizers, // 渗透手势
        hitTestBehavior: widget.hitTestBehavior, // 渗透点击事件
        layoutDirection: widget.layoutDirection, // 嵌入视图文本方向
        creationParams: widget.mapOptions!.toMap() as dynamic, // 向视图传递参数
        creationParamsCodec: new StandardMessageCodec(), // 编解码器类型
      );
    } else {
      return Text('flutter_baidu_mapapi_map插件尚不支持$defaultTargetPlatform');
    }
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print('implement dispose');
    super.dispose();
  }

  @override
  void didUpdateWidget(BMFTextureMapWidget oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  void _onPlatformCreated(int id) {
    // ignore: unnecessary_null_comparison
    if (widget.onBMFMapCreated == null) {
      return;
    }
    widget.onBMFMapCreated(new BMFMapController.withId(id));
  }
}
