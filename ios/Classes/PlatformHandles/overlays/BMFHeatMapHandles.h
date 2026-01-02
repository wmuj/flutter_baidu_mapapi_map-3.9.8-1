//
//  BMFHeatMapHandles.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/4/3.
//

#import <Flutter/Flutter.h>
#import "BMFMapViewHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFHeatMapHandles : NSObject

/// BMFHeatMapHandles管理中心
+ (instancetype)defalutCenter;

- (NSDictionary<NSString *, NSString *> *)heatMapHandles;

- (NSMutableArray<NSObject<BMFMapViewHandler> *> *)handlerArray;

@end
#pragma mark - heatMap

@interface BMFShowHeatMap : NSObject<BMFMapViewHandler>


@end

@interface BMFAddHeatMap : NSObject<BMFMapViewHandler>

@property (nonatomic, weak) FlutterMethodChannel *channel;

@end

@interface BMFUpdateHeatMap : NSObject<BMFMapViewHandler>

@end

@interface BMFRemoveHeatMap : NSObject<BMFMapViewHandler>

@end

@interface BMFStartHeatMapFrameAnimation : NSObject<BMFMapViewHandler>

@end

@interface BMFStopHeatMapFrameAnimation : NSObject<BMFMapViewHandler>

@end

@interface BMFHeatMapSetFrameAnimationIndex : NSObject<BMFMapViewHandler>

@end


NS_ASSUME_NONNULL_END
