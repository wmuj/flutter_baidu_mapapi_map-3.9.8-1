//
//  BMFClusterManager.h
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2024/3/22.
//

#import <Foundation/Foundation.h>
#import "BMFClusterQuadtree.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFClusterManager : NSObject

@property (nonatomic, strong) NSMutableArray *clusterCaches;

@property (nonatomic, assign) NSInteger zoomlevel;
// 最大聚合距离，单位dp
@property (nonatomic, assign) NSInteger maxDistance; //BMF_MAX_DISTANCE_IN_DP;

+ (instancetype)defaultCenter;

- (void)clearClusterItems;
- (NSArray*)getClusters:(CGFloat)zoomLevel;
- (void)setClusterCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
