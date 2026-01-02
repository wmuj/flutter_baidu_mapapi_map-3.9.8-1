//
//  BMFCluster.m
//  device_info_plus
//
//  Created by baidu on 2024/3/22.
//

#import "BMFCluster.h"

@implementation BMFCluster
#pragma mark - Initialization method
- (id)init {
    self = [super init];
    if (self) {
        _clusterAnnotations = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - View life cycle
- (NSUInteger)size {
    return _clusterAnnotations.count;
}

@end
