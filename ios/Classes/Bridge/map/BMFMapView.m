//
//  BMFMapView.m
//  flutter_baidu_mapapi_map
//
//  Created by zbj on 2020/2/10.
//

#import "BMFMapView.h"
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/BMFDefine.h>
#import "BMFEdgeInsets.h"
#import "BMFFileManager.h"
@interface BMFMapView ()

/// map属性集合
@property (nonatomic, strong) NSDictionary *mapViewOptions;
@end

@implementation BMFMapView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[BMFMapView alloc] initWithFrame:frame];
}

+ (instancetype)viewWithFrame:(CGRect)frame dic:(nullable NSDictionary *)dic {
    
    BMFMapView *map = [[BMFMapView alloc] initWithFrame:frame];
    map.mapViewOptions = dic;
    [map updateMapViewWith:dic];
    return map;
}

// 此方法解决初始时设置的属性不生效问题
- (BOOL)updateMapInitOptions {
    if (_mapViewOptions) {
        // logo位置 默认BMKLogoPositionLeftBottom
        if ([_mapViewOptions[@"logoPosition"] isValidParam]) {
            self.logoPosition = [_mapViewOptions[@"logoPosition"] intValue];
        }
        // 指南针的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
        if ([_mapViewOptions[@"compassPosition"] isValidParam]) {
            BMFMapPoint *point = [BMFMapPoint bmf_modelWith:_mapViewOptions[@"compassPosition"]];
            self.compassPosition = [point toCGPoint];
        }
        // 设定地图是否打开百度城市热力图图层（百度自有数据）
        if ([_mapViewOptions[@"baiduHeatMapEnabled"] isValidParam]) {
            self.baiduHeatMapEnabled = [_mapViewOptions[@"baiduHeatMapEnabled"] boolValue];
        }
        // 设定是否显式比例尺
        if ([_mapViewOptions[@"showMapScaleBar"] isValidParam]) {
            self.showMapScaleBar = [_mapViewOptions[@"showMapScaleBar"] boolValue];
        }
        // 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
        if ([_mapViewOptions[@"mapScaleBarPosition"] isValidParam]) {
            self.mapScaleBarPosition = [[BMFMapPoint bmf_modelWith:_mapViewOptions[@"mapScaleBarPosition"]]  toCGPoint];
        }
        // 地图预留边界
        if ([_mapViewOptions[@"mapPadding"] isValidParam]) {
            BMFEdgeInsets *edge = [BMFEdgeInsets bmf_modelWith:_mapViewOptions[@"mapPadding"]];
            UIEdgeInsets e = [edge toUIEdgeInsets];
            self.mapPadding = e;
        }
        return YES;
    }
    return NO;
}

- (BOOL)updateMapViewWith:(nullable NSDictionary *)dic {
    BOOL result = NO;
    if (dic) {
        // 当前地图类型，可设定为标准地图、卫星地图
        if ([dic[@"mapType"] isValidParam]) {
            self.mapType = [dic[@"mapType"] intValue];
        }
        // 地图语言
        if ([dic[@"languageType"] isValidParam]) {
            self.languageType = [[dic safeValueForKey:@"languageType"] intValue];
        }
        
        // 空白地图背景颜色
        if ([dic[@"backgroundColor"] isValidParam]) {
            self.backgroundColor = [UIColor fromColorString:[dic safeValueForKey:@"backgroundColor"]];
        }
        
        // 背景网格图片
        if ([dic[@"backgroundImage"] isValidParam]) {
            NSString *imagePath = [[BMFFileManager defaultCenter] pathForFlutterFileName:[dic safeValueForKey:@"backgroundImage"]];
            self.backgroundImage = [UIImage imageWithContentsOfFile:imagePath];
        }
        
        // 地图字体大小
        if ([dic[@"fontSizeLevel"] isValidParam]) {
            self.fontSizeLevel = [[dic safeValueForKey:@"fontSizeLevel"] intValue];
        }
        // 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
        if ([dic[@"limitMapBounds"] isValidParam]) {
            BMFCoordinateBounds *limitMapBounds = [BMFCoordinateBounds bmf_modelWith:dic[@"limitMapBounds"]];
            self.limitMapRegion = [limitMapBounds toCoordinateRegion];
        }
        // logo位置 默认BMKLogoPositionLeftBottom
        if ([_mapViewOptions[@"logoPosition"] isValidParam]) {
            self.logoPosition = [dic[@"logoPosition"] intValue];
        }
        // 指南针的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
        if ([dic[@"compassPosition"] isValidParam]) {
            BMFMapPoint *point = [BMFMapPoint bmf_modelWith:dic[@"compassPosition"]];
            self.compassPosition = [point toCGPoint];
        }
        // 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
        if ([dic[@"center"] isValidParam]) {
            BMFCoordinate *coord = [BMFCoordinate bmf_modelWith:dic[@"center"]];
            [self setCenterCoordinate:[coord toCLLocationCoordinate2D]];
        }
        // 地图比例尺级别，在手机上当前可使用的级别为4-21级
        if ([dic[@"zoomLevel"] isValidParam]) {
            self.zoomLevel = [dic[@"zoomLevel"] intValue];
        }
        // 地图的自定义最大比例尺级别
        if ([dic[@"minZoomLevel"] isValidParam]) {
            self.minZoomLevel = [dic[@"minZoomLevel"] intValue];
        }
        // 地图的自定义最大比例尺级别
        if ([dic[@"maxZoomLevel"] isValidParam]) {
            self.maxZoomLevel = [dic[@"maxZoomLevel"] intValue];
        }
        // 地图旋转角度，在手机上当前可使用的范围为－180～180度
        if ([dic[@"rotation"] isValidParam]) {
            self.rotation = [dic[@"rotation"] intValue];
        }
        // 地图俯视角度，在手机上当前可使用的范围为－45～0度
        if ([dic[@"overlooking"] isValidParam]) {
            self.overlooking = [dic[@"overlooking"] intValue];
        }
        // 地图俯视角度最小值（即角度最大值），在手机上当前可设置的范围为-79～0度
        if ([dic[@"minOverlooking"] isValidParam]) {
            self.minOverlooking = [dic[@"minOverlooking"] intValue];
        }
        // 设定地图是否现显示3D楼块效果
        if ([dic[@"buildingsEnabled"] isValidParam]) {
            self.buildingsEnabled = [dic[@"buildingsEnabled"] boolValue];
            [self setMapStatus:[self getMapStatus]];
        }
        // 设定地图是否显示底图poi标注(不包含室内图标注)，默认YES
        if ([dic[@"showMapPoi"] isValidParam]) {
            self.showMapPoi = [dic[@"showMapPoi"] boolValue];
        }
        // 设定地图是否打开路况图层
        if ([dic[@"trafficEnabled"] isValidParam]) {
            self.trafficEnabled = [dic[@"trafficEnabled"] boolValue];
        }
        // 设定地图是否打开百度城市热力图图层（百度自有数据）
        if ([dic[@"baiduHeatMapEnabled"] isValidParam]) {
            self.baiduHeatMapEnabled = [dic[@"baiduHeatMapEnabled"] boolValue];
        }
        // 设定地图View能否支持所有手势操作
        if ([dic[@"gesturesEnabled"] isValidParam]) {
            self.gesturesEnabled = [dic[@"gesturesEnabled"] boolValue];
        }
        // 设定地图View能否支持用户多点缩放(双指)
        if ([dic[@"zoomEnabled"] isValidParam]) {
            self.zoomEnabled = [dic[@"zoomEnabled"] boolValue];
        }
        // 设定地图View能否支持用户缩放(双击或双指单击)
        if ([dic[@"zoomEnabledWithTap"] isValidParam]) {
            self.zoomEnabledWithTap = [dic[@"zoomEnabledWithTap"] boolValue];
        }
        // 设定地图View能否支持用户移动地图
        if ([dic[@"scrollEnabled"] isValidParam]) {
            self.scrollEnabled = [dic[@"scrollEnabled"] boolValue];
        }
        // 设定地图View能否支持俯仰角
        if ([dic[@"overlookEnabled"] isValidParam]) {
            self.overlookEnabled = [dic[@"overlookEnabled"] boolValue];
        }
        // 设定地图View能否支持旋转
        if ([dic[@"rotateEnabled"] isValidParam]) {
            self.rotateEnabled = [dic[@"rotateEnabled"] boolValue];
        }
        // 设定地图是否回调force touch事件，默认为NO，仅适用于支持3D Touch的情况，
        // 开启后会回调 - mapview:onForceTouch:force:maximumPossibleForce:
        if ([dic[@"forceTouchEnabled"] isValidParam]) {
            self.forceTouchEnabled = [dic[@"forceTouchEnabled"] boolValue];
        }
        // 设定是否显式比例尺
        if ([dic[@"showMapScaleBar"] isValidParam]) {
            self.showMapScaleBar = [dic[@"showMapScaleBar"] boolValue];
        }
        // 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
        if ([dic[@"mapScaleBarPosition"] isValidParam]) {
            self.mapScaleBarPosition = [[BMFMapPoint bmf_modelWith:dic[@"mapScaleBarPosition"]]  toCGPoint];
        }

        // 当前地图范围，采用直角坐标系表示，向右向下增长
        if ([dic[@"visibleMapBounds"] isValidParam]) {
            BMFCoordinateBounds *visibleMapBounds = [BMFCoordinateBounds bmf_modelWith:dic[@"visibleMapBounds"]];
            [self setVisibleMapRect:[visibleMapBounds toBMKMapRect] animated:YES];
        }
        // 设置mapPadding时，地图中心(屏幕坐标：BMKMapStatus.targetScreenPt)是否跟着改变，默认YES
        if ([dic[@"updateTargetScreenPtWhenMapPaddingChanged"] isValidParam]) {
            self.updateTargetScreenPtWhenMapPaddingChanged = [dic[@"updateTargetScreenPtWhenMapPaddingChanged"] boolValue];
        }
        // 设定双指手势操作时，BMKMapView的旋转和缩放效果的中心点。
        // 设置为YES时，以手势的中心点（二个指头的中心点）为中心进行旋转和缩放，地图中心点会改变；
        // 设置为NO时，以当前地图的中心点为中心进行旋转和缩放，地图中心点不变；
        // 默认值为NO。
        if ([dic[@"changeWithTouchPointCenterEnabled"] isValidParam]) {
            self.ChangeWithTouchPointCenterEnabled = [dic[@"changeWithTouchPointCenterEnabled"] boolValue];
        }
        // 设定双击手势放大地图时，BMKMapView的放大效果的中心点。
        //  设置为YES时，以双击的位置为中心点进行放大，地图中心点会改变；
        // 设置为NO时，以当前地图的中心点为中心进行放大，地图中心点不变；
        // 默认值为YES。
        if ([dic[@"changeCenterWithDoubleTouchPointEnabled"] isValidParam]) {
            self.ChangeCenterWithDoubleTouchPointEnabled = [dic[@"changeCenterWithDoubleTouchPointEnabled"] boolValue];
        }
        //  设定地图是否显示室内图
        if ([dic[@"baseIndoorMapEnabled"] isValidParam]) {
            self.baseIndoorMapEnabled = [dic[@"baseIndoorMapEnabled"] boolValue];
        }
        // 设定室内图标注是否显示，默认YES，仅当显示室内图（baseIndoorMapEnabled为YES）时生效
        if ([dic[@"showIndoorMapPoi"] isValidParam] && self.baseIndoorMapEnabled) {
            self.showIndoorMapPoi = [dic[@"showIndoorMapPoi"] boolValue];
        }
        //  地图是否展示运营图层
        if ([dic[@"showOperateLayer"] isValidParam]) {
            self.showOperateLayer = [dic[@"showOperateLayer"] boolValue];
        }
        //  地图是否展示地形图层
        if ([dic[@"showDEMLayer"] isValidParam]) {
            self.showDEMLayer = [dic[@"showDEMLayer"] boolValue];
        }
        result = YES;
    }
    return result;
}

- (void)dealloc {
    _mapViewOptions = nil;
//    NSLog(@"-mapView-dealloc");
}

@end
