package com.baidu.bmfmap.utils;

public class Env {
    public static Boolean DEBUG = false;

    /**
     * 空白地图
     */
    public static final int MAP_TYPE_NONE = 3;

    /**
     * 普通地图
     */
    public static final int MAP_TYPE_NORMAL = 1;

    /**
     * 卫星地图
     */
    public static final int MAP_TYPE_SATELLITE = 2;


    /**
     * 地图左下方
     */
    public static final int LOGO_POSITION_LEFT_BOTTOM = 0;

    /**
     * 地图左下方
     */
    public static final int LOGO_POSITION_LEFT_TOP = 1;

    /**
     * 地图中下方
     */
    public static final int LOGO_POSITION_CENTER_BOTTOM = 2;

    /**
     * 地图中上方
     */
    public static final int LOGO_POSITION_CENTER_TOP = 3;

    /**
     * 地图右下方
     */
    public static final int LOGO_POSITION_RIGTH_BOTTOM = 4;

    /**
     * 地图右上方
     */
    public static final int LOGO_POSITION_RIGTH_TOP = 5;

    /**
     * 定位图层显示方式
     */
    public static class LocationMode {
        /**
         * 普通态： 更新定位数据时不对地图做任何操作
         */
        public static final int NORMAL = 0;

        /**
         * 定位方向模式
         */
        public static final int MODEHEADING = 1;

        /**
         * 跟随态，保持定位图标在地图中心
         */
        public static final int FOLLOWING = 2;

        /**
         * 罗盘态，显示定位方向圈，保持定位图标在地图中心
         */
        public static final int COMPASS = 3;
    }
}
