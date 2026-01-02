import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFNativeViewType;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';

/// 地图创建回调
typedef BMFMapCreatedCallback = void Function(BMFMapController controller);

/// 百度地图Widget
class BMFMapWidget extends StatefulWidget {
  /// BMFMapWidget构造方法
  const BMFMapWidget({
    Key? key,
    required this.onBMFMapCreated,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
    this.layoutDirection = TextDirection.ltr,
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
  _BMFMapWidgetState createState() => _BMFMapWidgetState();
}

class _BMFMapWidgetState extends State<BMFMapWidget> {
  final _gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  ].toSet();

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS
      return UiKitView(
        viewType: BMFNativeViewType.sMapView, // 原生交互时唯一标识符
        onPlatformViewCreated: _onPlatformViewCreated, // 创建视图后的回调
        gestureRecognizers: _gestureRecognizers, // 透传手势
        hitTestBehavior: widget.hitTestBehavior, // 渗透点击事件
        layoutDirection: widget.layoutDirection, // 嵌入视图文本方向
        creationParams: widget.mapOptions!.toMap() as dynamic, // 向视图传递参数
        creationParamsCodec: new StandardMessageCodec(), // 编解码器类型
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      /// 适配BMFMapWidget在flutter sdk升级3.0之后兼容底版本手机问题。
      /// 在Andriod 10 以下手机上在使用BMFMapWidget的时，会使用textureMapview渲染
      /// Android 10 及以上机型则使用surfaceMapView渲染。
      /// 如果没有在创建地图前设置BMFAndroidVersion.initAndroidVersion()接口
      /// BMFAndroidVersion.getAndroidVersion 默认是false使用textureMapview渲染
      if (BMFAndroidVersion.getAndroidVersion) {
        return PlatformViewLink(
          viewType: BMFNativeViewType.sMapView,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: _gestureRecognizers,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final ExpensiveAndroidViewController controller =
                PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: BMFNativeViewType.sMapView,
              layoutDirection: TextDirection.ltr,
              creationParams: widget.mapOptions!.toMap() as dynamic,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            );
            controller.addOnPlatformViewCreatedListener(
              params.onPlatformViewCreated,
            );
            controller.addOnPlatformViewCreatedListener(
              _onPlatformViewCreated,
            );

            controller.create();
            return controller;
          },
        );
      } else {
        return PlatformViewLink(
          viewType: BMFNativeViewType.sTextureMapView,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: widget.hitTestBehavior, // 渗透点击事件
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final ExpensiveAndroidViewController controller =
                PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: BMFNativeViewType.sTextureMapView,
              layoutDirection: TextDirection.ltr,
              // 嵌入视图文本方向
              creationParams: widget.mapOptions!.toMap() as dynamic,
              // 向视图传递参数
              creationParamsCodec: const StandardMessageCodec(),
              // 编解码器类型
              onFocus: () {
                params.onFocusChanged(true);
              },
            );
            controller
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();

            return controller;
          },
        );
      }
        } else {
      return Text('flutter_baidu_mapapi_map插件尚不支持$defaultTargetPlatform');
    }
  }

  void _onPlatformViewCreated(int id) {
    // ignore: unnecessary_null_comparison
    if (widget.onBMFMapCreated == null) {
      return;
    }

    widget.onBMFMapCreated(new BMFMapController.withId(id));
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
  void didUpdateWidget(BMFMapWidget oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    print('reassemble');
    super.reassemble();
  }
}
