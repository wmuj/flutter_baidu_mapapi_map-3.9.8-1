import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  StandardMessageCodec,
} from '@ohos/flutter_ohos';
import { MapViewFactory } from './MapViewFactory';
import { MAP_VIEW, NATIVE_SDK_VERSION_CHANNEL } from './util/Constants';

export default class FlutterBmfmapPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    binding.getPlatformViewRegistry()?.
    registerViewFactory(MAP_VIEW, new MapViewFactory(binding.getBinaryMessenger(), StandardMessageCodec.INSTANCE));
    this.channel = new MethodChannel(binding.getBinaryMessenger(), NATIVE_SDK_VERSION_CHANNEL);
    this.channel.setMethodCallHandler(this)
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    // 接受Dart侧发来的消息
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  getUniqueClassName(): string {
    return 'FlutterBmfmapPlugin';
  }
}