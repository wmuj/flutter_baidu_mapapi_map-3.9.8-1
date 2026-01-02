//
//  BMFMapPoiModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/6.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMKMapPoi;

NS_ASSUME_NONNULL_BEGIN

@interface BMFMapPoiModel : BMFModel

/// 点标注的名称
@property (nonatomic, copy) NSString *text;

/// 点标注的经纬度坐标
@property (nonatomic, strong) BMFCoordinate *pt;

/// 点标注的uid，可能为空
@property (nonatomic, copy) NSString *uid;

+ (BMFMapPoiModel *)fromBMKMapPoi:(BMKMapPoi *)poi;
@end

NS_ASSUME_NONNULL_END
