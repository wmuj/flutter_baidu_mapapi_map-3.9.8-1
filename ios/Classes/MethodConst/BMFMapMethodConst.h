#ifndef __BMFMapMethodConst__H__
#define __BMFMapMethodConst__H__

#import <Foundation/Foundation.h>

// Map

/// mapChannelName
FOUNDATION_EXPORT NSString *const kBMFMapChannelName;
/// flutter与原生交互时map唯一标识符
FOUNDATION_EXPORT NSString *const kBMFMapIdentifier;

// get
/// 获取map的展示类型
FOUNDATION_EXPORT NSString *const kBMFMapGetMapTypeMethod;
/// 获取map的语言类型
FOUNDATION_EXPORT NSString *const kBMFMapGetMapLanguageTypeMethod;
/// 获取空白map的背景颜色
FOUNDATION_EXPORT NSString *const kBMFMapGetMapBackgroundColorMethod;
/// 获取map的字体大小
FOUNDATION_EXPORT NSString *const kBMFMapGetFontSizeLevelMethod;
/// 获取map的比例尺级别
FOUNDATION_EXPORT NSString *const kBMFMapGetZoomLevelMethod;
/// 获取map的自定义最小比例尺级别
FOUNDATION_EXPORT NSString *const kBMFMapGetMinZoomLevelMethod;
/// 获取map的自定义最大比例尺级别
FOUNDATION_EXPORT NSString *const kBMFMapGetMaxZoomLevelMethod;
/// 获取map的旋转角度
FOUNDATION_EXPORT NSString *const kBMFMapGetRotationMethod;
/// 获取map的地图俯视角度
FOUNDATION_EXPORT NSString *const kBMFMapGetOverlookingMethod;
/// 获取map的俯视角度最小值
FOUNDATION_EXPORT NSString *const kBMFMapGetMinOverlookingMethod;
/// 获取map的是否现显示3D楼块效果
FOUNDATION_EXPORT NSString *const kBMFMapGetBuildingsEnabledMethod;
/// 获取map的是否显示底图poi标注
FOUNDATION_EXPORT NSString *const kBMFMapGetShowMapPoiMethod;
/// 获取map的是否打开路况图层
FOUNDATION_EXPORT NSString *const kBMFMapGetTrafficEnabledMethod;
/// 获取map的是否打开百度城市热力图图层
FOUNDATION_EXPORT NSString *const kBMFMapGetBaiduHeatMapEnabledMethod;
/// 获取map的是否支持所有手势操作
FOUNDATION_EXPORT NSString *const kBMFMapGetGesturesEnabledMethod;
/// 获取map的是否支持用户多点缩放(双指)
FOUNDATION_EXPORT NSString *const kBMFMapGetZoomEnabledMethod;
/// 获取map的是否支持用户缩放(双击或双指单击)
FOUNDATION_EXPORT NSString *const kBMFMapGetZoomEnabledWithTapMethod;
/// 获取map的是否支持用户移动地图
FOUNDATION_EXPORT NSString *const kBMFMapGetScrollEnabledMethod;
/// 获取map的是否支持俯仰角
FOUNDATION_EXPORT NSString *const kBMFMapGetOverlookEnabledMethod;
/// 获取map的是否支持旋转
FOUNDATION_EXPORT NSString *const kBMFMapGetRotateEnabledMethod;
/// 获取map的是否支持3Dtouch
FOUNDATION_EXPORT NSString *const kBMFMapGetForceTouchEnabledMethod;
/// 获取map的是否显式比例尺
FOUNDATION_EXPORT NSString *const kBMFMapGetShowMapScaleBarMethod;
/// 获取map的比例尺的位置
FOUNDATION_EXPORT NSString *const kBMFMapGetMapScaleBarPositionMethod;
/// 获取map的logo位置
FOUNDATION_EXPORT NSString *const kBMFMapGetLogoPositionMethod;
/// 获取map的可视范围
FOUNDATION_EXPORT NSString *const kBMFMapGetVisibleMapBoundsMethod;
/// 获取map的显示室内图
FOUNDATION_EXPORT NSString *const kBMFMapGetBaseIndoorMapEnabledMethod;
/// 获取map的室内图标注是否显示
FOUNDATION_EXPORT NSString *const kBMFMapGetShowIndoorMapPoiMethod;
/// 获取map的室内图标注是否显示
FOUNDATION_EXPORT NSString *const kBMFMapGetShowOperateLayerMethod;
/// 获取当前地图版权信息
FOUNDATION_EXPORT NSString *const kBMFMapGetMapCopyrightInformationMethod;
/// 获取当前地图测绘资质
FOUNDATION_EXPORT NSString *const kBMFMapGetMapMappingQualificationMethod;
/// 获取当前地图审图号
FOUNDATION_EXPORT NSString *const kBMFMapGetMapApprovalNumberMethod;

// set
/// map更新参数
FOUNDATION_EXPORT NSString *const kBMFMapUpdateMethod;
/// map放大一级比例尺
FOUNDATION_EXPORT NSString *const kBMFMapZoomInMethod;
/// map缩小一级比例尺
FOUNDATION_EXPORT NSString *const kBMFMapZoomOutMethod;
/// map设置路况颜色
FOUNDATION_EXPORT NSString *const kBMFMapSetCustomTrafficColorMethod;
/// map设定地图中心点坐标
FOUNDATION_EXPORT NSString *const kBMFMapSetCenterCoordinateMethod;
/// 获得地图当前可视区域截图
FOUNDATION_EXPORT NSString *const kBMFMapTakeSnapshotMethod;
/// 获得地图指定区域截图
FOUNDATION_EXPORT NSString *const kBMFMapTakeSnapshotWithRectMethod;
/// 设置罗盘的图片
FOUNDATION_EXPORT NSString *const kBMFMapSetCompassImageMethod;
/// 设定当前地图的显示范围
FOUNDATION_EXPORT NSString *const kBMFMapSetVisibleMapBoundsMethod;
/// 设定地图的显示范围,并使bounds四周保留insets指定的边界区域
FOUNDATION_EXPORT NSString *const kBMFMapSetVisibleMapBoundsWithPaddingMethod;
/// 根据当前mapView的窗口大小，预留insets指定的边界区域后，将mapRect指定的地理范围显示在剩余的区域内，并尽量充满
FOUNDATION_EXPORT NSString *const kBMFMapFitVisibleMapRectWithPaddingMethod;
/// 设置mapStatus
FOUNDATION_EXPORT NSString *const kBMFMapSetMapStatusMethod;
/// 获取mapStatus
FOUNDATION_EXPORT NSString *const kBMFMapGetMapStatusMethod;
/// 设置地图中心点在地图中的屏幕坐标位置
FOUNDATION_EXPORT NSString *const kBMFMapSetMapCenterToScreenPtMethod;

// 室内地图
/// map展示室内地图
FOUNDATION_EXPORT NSString *const kBMFMapShowBaseIndoorMapMethod;
/// map室内图标注是否显示
FOUNDATION_EXPORT NSString *const kBMFMapShowBaseIndoorMapPoiMethod;
/// map设置室内图楼层
FOUNDATION_EXPORT NSString *const kBMFMapSwitchBaseIndoorMapFloorMethod;
/// map获取当前聚焦的室内图信息
FOUNDATION_EXPORT NSString *const kBMFMapGetFocusedBaseIndoorMapInfoMethod;



// 个性化地图
/// 开启个性化地图
FOUNDATION_EXPORT NSString *const kBMFMapSetCustomMapStyleEnableMethod;
/// 设置个性化地图样式路径
FOUNDATION_EXPORT NSString *const kBMFMapSetCustomMapStylePathMethod;
/// 在线个性化样式加载状态回调接口
FOUNDATION_EXPORT NSString *const kBMFMapSetCustomMapStyleWithOptionMethod;

// layer
/// 地图overlay图层与POI图层交换位置
FOUNDATION_EXPORT NSString *const kBMFMapSwitchOverlayLayerAndPOILayerMethod;
/// 设置地图是否展示底图poi标签 since 3.4.0
FOUNDATION_EXPORT NSString *const kBMFMapPoiTagEnableAndPoiTagTypeMethod;
/// 地图交换图层顺序
FOUNDATION_EXPORT NSString *const kBMFMapSwitchLayerOrderMethod;


// 粒子效果
/// 显示粒子效果
FOUNDATION_EXPORT NSString *const kBMFMapShowMapParticleEffectMethod;
/// 关闭粒子效果
FOUNDATION_EXPORT NSString *const kBMFMapCloseMapParticleEffectMethod;
/// 自定义粒子效果
FOUNDATION_EXPORT NSString *const kBMFMapCustomMapParticleEffectMethod;

#endif
