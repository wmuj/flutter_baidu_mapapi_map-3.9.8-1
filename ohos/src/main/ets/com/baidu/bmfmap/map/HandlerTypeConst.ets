/**
 * MapHandler类型
 */
export class MapHandlerType {
  static CUSTOM_MAP = 0
  static MAP_STATE = 1
  static INDOOR_MAP = 2
  static MAP_SNAPSHOT = 3;
  static CUSTOM_COMPASS = 4;
  static CUSTOM_TRAFFIC_COLOR = 5;
  static MAP_UPDATE = 6;
  static HEAT_MAP = 7;
  static TILE_MAP = 8;
  static LOCATION_LAYER = 9;
  static PROJECTION = 10;
  static PARTICLE = 11;
}

/**
 * overlayHandler类型
 */
export class OverlayHandlerType {
  static OVERLAY_COMMON_HANDLER = 0
  static CIRCLE_HANDLER = 1
  static DOT_HANDLER = 2
  static POLYGON_HANDLER = 3;
  static POLYLINE_HANDLER = 4;
  static TEXT_HANDLER = 5;
  static ARC_LINE_HANDLER = 6;
  static GROUND_HANDLER = 7;
  static MARKER_HANDLER = 8;
  static INFO_WINDOW_HANDLER = 9;
  static PRISM_HANDLER = 10;
  static BM3D_MODEL_HANDLER = 11;
  static MULTIPOINT_HANDLER = 12;
  static TRACK_HANDLER = 13;
  static CLUSTER_HANDLER = 14;
}
