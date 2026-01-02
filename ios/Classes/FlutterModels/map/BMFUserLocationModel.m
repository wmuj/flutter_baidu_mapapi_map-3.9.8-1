//
//  BMFUserLocationModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/01.
//

#import "BMFUserLocationModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>
#import <BaiduMapAPI_Map/BMKLocationViewDisplayParam.h>

#import "BMFFileManager.h"

struct BMFHeadingInfo {
    double x;
    double y;
    double z;
    double magneticHeading;
    double trueHeading;
    double accuracy;
    double timestamp;
};
typedef struct CG_BOXABLE BMFHeadingInfo BMFHeadingInfo;

@implementation BMFUserLocationModel

- (BMKUserLocation *)toBMKUserLocation {
    BMKUserLocation *userLocation = [BMKUserLocation new];
    userLocation.location = [self.location toCLLocation];
    userLocation.heading = [self.heading toCLHeading];
    userLocation.title = self.title;
    userLocation.subtitle = self.subtitle;
    return userLocation;
}
@end

@implementation BMFLocationModel

- (CLLocation *)toCLLocation {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:[self.coordinate toCLLocationCoordinate2D]
                                                         altitude:self.altitude
                                               horizontalAccuracy:self.horizontalAccuracy
                                                 verticalAccuracy:self.verticalAccuracy
                                                           course:self.course speed:self.speed
                                                        timestamp:self.timestamp ? [dateFormatter dateFromString:self.timestamp] : [NSDate date]];
    return location;
}

@end


@implementation BMFHeadingModel

- (CLHeading *)toCLHeading {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = self.timestamp ? [dateFormatter dateFromString:self.timestamp] : [NSDate date];
    
    CLHeading *heading = [CLHeading new];
    BMFHeadingInfo info = {};
    // 磁北 则对应于随时间变化的地球磁场北极
    info.magneticHeading = self.magneticHeading;
    // 真北 始终指向地理北极点
    info.trueHeading = self.trueHeading;
    // 方向值的误差范围
    info.accuracy = self.headingAccuracy;
    // 获取该设备在 X 方向上监听得到的原始磁力值，该磁力值的强度单位是微特斯拉。
    info.x = self.x;
    // 获取该设备在 Y 方向上监听得到的原始磁力值，该磁力值的强度单位是微特斯拉。
    info.y = self.y;
    // 获取该设备在 Z 方向上监听得到的原始磁力值，该磁力值的强度单位是微特斯拉。
    info.z = self.z;
    info.timestamp = [date timeIntervalSince1970] - NSTimeIntervalSince1970;
    
    // KVC赋值
    NSValue *value = [NSValue valueWithBytes:&info objCType:@encode(BMFHeadingInfo)];
    // CLHeadingInternal
    id _internal = [[NSClassFromString(@"CLHeadingInternal") alloc] init];
    // NSConcreteValue
    [_internal setValue:value forKey:@"fHeading"];
    [heading setValue:_internal forKey:@"_internal"];
    
    return heading;
}

@end

@implementation BMFLocationViewDisplayParam

- (BMKLocationViewDisplayParam *)toBMKLocationViewDisplayParam {
    BMKLocationViewDisplayParam *param = [BMKLocationViewDisplayParam new];
    param.locationViewOffsetX = self.locationViewOffsetX;
    param.locationViewOffsetY = self.locationViewOffsetY;
    param.isAccuracyCircleShow = self.isAccuracyCircleShow;
    param.accuracyCircleStrokeColor = [UIColor fromColorString:self.accuracyCircleStrokeColor];
    param.accuracyCircleFillColor = [UIColor fromColorString:self.accuracyCircleFillColor];
    param.accuracyCircleBorderWidth = self.accuracyCircleBorderWidth;
    param.isRotateAngleValid = self.isRotateAngleValid;
    param.locationViewImage = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:self.locationViewImage]];
    param.canShowCallOut = self.canShowCallOut;
    param.locationViewHierarchy = self.locationViewHierarchy;
    param.locationViewImageNew = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:self.locationViewImageNew]];
    param.locationViewGifImageFilePath = [[BMFFileManager defaultCenter] pathForFlutterFileName:self.locationViewGifImageFilePath];
    param.locationViewImageSizeScale = self.locationViewImageSizeScale;
    param.breatheEffectOpenForWholeStyle = self.breatheEffectOpenForWholeStyle;
    param.locationViewCenterImage = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:self.locationViewCenterImage]];
    param.locationViewCenterGifImageFilePath = [[BMFFileManager defaultCenter] pathForFlutterFileName:self.locationViewCenterGifImageFilePath];
    param.locationViewCenterImageSizeScale = self.locationViewCenterImageSizeScale;
    param.locationViewAroundArrowsImage = [UIImage imageWithContentsOfFile:[[BMFFileManager defaultCenter] pathForFlutterImageName:self.locationViewAroundArrowsImage]];
    param.locationViewAroundArrowsImageSizeScale = self.locationViewAroundArrowsImageSizeScale;
    param.breatheEffectOpenForArrowsStyle = self.breatheEffectOpenForArrowsStyle;
    param.isLocationArrowStyleCustom = self.isLocationArrowStyleCustom;
    return param;
}

@end
