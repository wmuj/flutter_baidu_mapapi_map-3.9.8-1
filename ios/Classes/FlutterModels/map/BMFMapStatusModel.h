//
//  BMFMapStatusModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/20.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFMapPoint;
@class BMFCoordinateBounds;
@class BMKMapStatus;
NS_ASSUME_NONNULL_BEGIN

@interface BMFMapStatusModel : BMFModel

/// 缩放级别:[3~19]
@property (nonatomic, assign) float fLevel;

/// 旋转角度
@property (nonatomic, assign) float fRotation;

/// 俯视角度:[-45~0]
@property (nonatomic, assign) float fOverlooking;

/// 屏幕中心点坐标:在屏幕内，超过无效
@property (nonatomic, strong) BMFMapPoint *targetScreenPt;

/// 地理中心点坐标:经纬度
@property (nonatomic, strong) BMFCoordinate *targetGeoPt;

/// 当前地图范围，采用经纬度坐标系东北，西南两坐标表示范围
@property (nonatomic, strong) BMFCoordinateBounds *visibleMapBounds;


+ (BMFMapStatusModel *)fromMapStatus:(BMKMapStatus *)mapStatus;

- (BMKMapStatus *)toMapStatus;

@end

NS_ASSUME_NONNULL_END
