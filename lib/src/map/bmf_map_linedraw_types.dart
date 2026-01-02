/// line拐角处理方式枚举（不支持虚线）
enum BMFLineJoinType {
  /// 平角衔接
  LineJoinBevel,

  /// 尖角衔接(尖角过长(大于线宽)按平角处理)
  LineJoinMiter,

  /// 圆⻆角衔接
  LineJoinRound,

  /// 贝塞尔平滑衔接(仅支持多纹理和多颜色的polyline绘制) 此衔接不可以与kBMKLineCapRound配合使用
  LineJoinBerzier
}

/// line头尾处理方式枚举(不支持虚线)
enum BMFLineCapType {
  /// 普通头
  LineCapButt,

  /// 圆形头
  LineCapRound
}

/// 虚线绘制样式
enum BMFLineDashType {
  /// 实折线
  LineDashTypeNone,

  /// 方块样式
  LineDashTypeSquare,

  /// 圆点样式
  LineDashTypeDot,
}

/// 折线跨经度180的方式枚举
enum BMFLineDirectionCross180Type {
  ///< 不跨180经度
  None,

  ///< 从东到西跨180经度
  EAST_TO_WEST,

  ///< 从西到东跨180经度
  WEST_TO_EAST
}

/// line发光模式
enum BMFLineBloomMode {
  ///< 不发光
  LineBloomModeNone,

  ///< 渐变发光模式  iOS暂不支持渐变发光
  LineBloomModeGradient,

  ///< 模糊发光
  LineBLUR,
}
