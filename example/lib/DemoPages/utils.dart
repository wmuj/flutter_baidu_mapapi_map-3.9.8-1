import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/function_item.widget.dart';

/// 有些overlay有平台区分,需要区别展示
///
/// 目前iOS不支持dot和text
Widget generatePlatformizationItem(
    bool isCurrentPlatform, String label, String sublabel, Widget widget) {
  return isCurrentPlatform
      ? FunctionItem(label: label, sublabel: sublabel, target: widget)
      : Placeholder(
          color: Colors.transparent,
          strokeWidth: 0,
          fallbackHeight: 0,
        );
}
