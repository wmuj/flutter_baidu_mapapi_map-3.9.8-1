/// overlay碰撞检测类型
enum BMFMarkerCollisionBehavior {
  ///< 不参与碰撞
  NotCollide,

  ///< 参与碰撞，但强制显示
  AlwaysShow,

  ///< 参与碰撞，根据碰撞优先级决定是否显示
  HideByPriority,

  ///< overlay内部点碰撞
  WithInner,

  ///< overlay与底图的POI进行碰撞，碰掉底图的POI
  WithBasePoi,

  ///< overlay内部的点先碰撞，再与底图的POI进行碰撞，最后碰掉底图的POI
  InnerAndBasePoi,

  ///< overlay内部点避让
  DodgeWithInner,

  ///< 当前要素不参与碰撞, marker和richview可分别设置为不参与碰撞
  ExceptSelf,

  ///< 所有图层都碰撞，按优先级碰
  WithAllLayersByPriority
}

// 插值器类型，当前仅支持Linear。
enum BMFInterpolatorMode {
  ///<  线性插值. @Default
  Linear,

  ///<  余弦函数的半个周期，起点和终点增长缓慢，而中间快速增长.
  AccelerateDecelerate,

  ///<  返回input的n次幂，即抛物线的右半部分，起点缓慢，然后加速.
  Accelerate,

  ///<  返回input的n次幂，即抛物线的右半部分，起点缓慢，然后加速.
  Decelerate,

  ///<  mTension默认值为2，因此下图也是按照mTension为2来绘制的。起点的时候回往回一定值，而后再往前.
  Anticipate,

  ///<  返回input的n次幂，即抛物线的右半部分，起点缓慢，然后加速.
  Overshoot,

  ///<  起点往回一定值，然后往前，到终点再超出一定值，然后返回.
  AnticipateOvershoot,

  ///<  类似于球掉落地面的效果.
  Bounce,

  ///<  正弦曲线， 循环播放mCycles次.
  Cycle,
}

enum BMFAnimationFillMode {
  ///<  Indicates whether the animation transformation should be applied before the animation starts.
  FillBefore,

  ///<  Indicates whether the animation transformation should be applied the first frame of animation starts.
  FillFirst,

  ///< Indicates whether the animation transformation should be applied after the animation ends.
  FillAfter
}

enum BMFAnimationRepeatMode {
  ///<  When the animation reaches the end and the repeat count is INFINTE_REPEAT or a positive value, the animation restarts from the beginning. @Default
  RepeatRestart,

  ///<  When the animation reaches the end and the repeat count is INFINTE_REPEAT or a positive value, the animation plays backward (and then forward again).
  ReleatReserse,
}

/// 轨迹动画，跟随
enum BMFAnimationTrackMode {
  ///< 不跟随
  TrackNone,

  ///< 跟随X方向
  TrackX,

  ///< 跟随Y方向
  TrackY,

  ///< 跟随（X、 Y）
  TrackXY,

  ///< 线段的Forward，而不是行进的Forward
  TrackForward,

  ///< 线段的Backward，而不是行进的Backward
  TrackBackward,
}

enum BMFAnimationSetOrderType {
  ///< 所有动画同时执行
  OrderTypeWith,

  ///< 所有动画按顺序执行
  OrderTypeThen
}
