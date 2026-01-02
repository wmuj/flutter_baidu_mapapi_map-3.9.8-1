//
//  BMFCluster.h
//  device_info_plus
//
//  Created by baidu on 2024/3/22.
//
#import <CoreLocation/CoreLocation.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMFCluster : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableArray *clusterAnnotations;
@property (nonatomic, readonly) NSUInteger size;
@end

NS_ASSUME_NONNULL_END
