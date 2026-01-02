//
//  BMFPrismOverlayModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFBuildInfo;
NS_ASSUME_NONNULL_BEGIN

@interface BMFPrismOverlayModel : BMFModel

/// flutter层prismOverlay的唯一id(用于区别哪个prismOverlay)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 高度
@property (nonatomic, assign) float height;

/// 经纬度数组
@property (nonatomic, copy) NSArray<BMFCoordinate *> *coordinates;

/// 3D棱柱顶面颜色
@property (nonatomic, copy) NSString *topFaceColor;

/// 3D棱柱侧面颜色
@property (nonatomic, copy) NSString *sideFaceColor;

/// 3D棱柱侧面纹理图片路径
@property (nonatomic, copy) NSString *sideFacTexture;

/// 是否开启生长动画(仅对建筑物生效)，默认YES
@property (nonatomic, assign) BOOL isGrowthAnimation;

/// 建筑物显示层级(仅对建筑物生效), 默认18
@property (nonatomic, assign) int showLevel;

/// 地图建筑物信息
@property (nonatomic, strong) BMFBuildInfo *buildInfo;

/// 自定义建筑物的楼层高度
@property (nonatomic, assign) float floorHeight;

/// 自定义建筑物的楼层颜色 (仅对建筑物生效)
@property (nonatomic, copy) NSString *floorColor;

/// 自定义建筑物的楼层侧面纹理 (仅对建筑物生效)
@property (nonatomic, copy) NSString *floorSideTextureImage;
@end

NS_ASSUME_NONNULL_END
