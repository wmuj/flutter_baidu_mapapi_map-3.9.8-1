//
//  BMFClusterManager.m
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2024/3/22.
//

#import "BMFClusterManager.h"


@interface BMFClusterManager ()
@property (nonatomic, readonly) NSMutableArray *quadItems;
@property (nonatomic, readonly) BMFClusterQuadtree *quadtree;
@end
@implementation BMFClusterManager

#pragma mark - Initialization method

static BMFClusterManager *_instance = nil;
+ (instancetype)defaultCenter {
    return [[BMFClusterManager alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
     @synchronized(self) { // 同步
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
 
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setClusterCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count {
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 20; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    _quadtree = [[BMFClusterQuadtree alloc] initWithRect:CGRectMake(0, 0, 1, 1)];
    _quadItems = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count; i++) {

        CLLocationCoordinate2D coordinate = coords[i];
        BMFQuadItem *quadItem = [[BMFQuadItem alloc] init];
        quadItem.coordinate = coordinate;
        @synchronized(_quadtree) {
            [_quadItems addObject:quadItem];
            [_quadtree addItem:quadItem];
        }
    }
}

#pragma mark - Clusters
- (void)clearClusterItems {
    @synchronized(_quadtree) {
        [_quadItems removeAllObjects];
        [_quadtree clearItems];
    }
}

- (NSArray *)getClusters:(CGFloat) zoomLevel {
    if (zoomLevel < 4 || zoomLevel > 22) {
        return nil;
    }
    NSMutableArray *results = [NSMutableArray array];
    
    CGFloat zoomSpecificSpan = self.maxDistance / pow(2, zoomLevel) / 256;
    NSMutableSet *visitedCandidates = [NSMutableSet set];
    NSMutableDictionary *distanceToCluster = [NSMutableDictionary dictionary];
    NSMutableDictionary *itemToCluster = [NSMutableDictionary dictionary];
    
    @synchronized(_quadtree) {
        for (BMFQuadItem *candidate in _quadItems) {
            //candidate已经添加到另一cluster中
            if ([visitedCandidates containsObject:candidate]) {
                continue;
            }
            BMFCluster *cluster = [[BMFCluster alloc] init];
            cluster.coordinate = candidate.coordinate;
            
            CGRect searchRect = [self getRectWithPt:candidate.pt span:zoomSpecificSpan];
            NSMutableArray *items = (NSMutableArray *)[_quadtree searchInRect:searchRect];
            if (items.count == 1) {
                CLLocationCoordinate2D coor = candidate.coordinate;
                NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                [cluster.clusterAnnotations addObject:value];
                
                [results addObject:cluster];
                [visitedCandidates addObject:candidate];
                [distanceToCluster setObject:[NSNumber numberWithDouble:0] forKey:[NSNumber numberWithLongLong:candidate.hash]];
                continue;
            }
            
            for (BMFQuadItem *quadItem in items) {
                NSNumber *existDistache = [distanceToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                CGFloat distance = [self getDistanceSquared:candidate.pt otherPoint:quadItem.pt];
                if (existDistache != nil) {
                    if (existDistache.doubleValue < distance) {
                        continue;
                    }
                    BMFCluster *existCluster = [itemToCluster objectForKey:[NSNumber numberWithLongLong:quadItem.hash]];
                    CLLocationCoordinate2D coor = quadItem.coordinate;
                    NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                    [existCluster.clusterAnnotations removeObject:value];
                }
                
                [distanceToCluster setObject:[NSNumber numberWithDouble:distance] forKey:[NSNumber numberWithLongLong:quadItem.hash]];
                CLLocationCoordinate2D coor = quadItem.coordinate;
                NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
                [cluster.clusterAnnotations addObject:value];
                [itemToCluster setObject:cluster forKey:[NSNumber numberWithLongLong:quadItem.hash]];
            }
            [visitedCandidates addObjectsFromArray:items];
            [results addObject:cluster];
        }
    }
    return results;
}

- (CGRect)getRectWithPt:(CGPoint) pt  span:(CGFloat) span {
    CGFloat half = span / 2.f;
    return CGRectMake(pt.x - half, pt.y - half, span, span);
}

- (CGFloat)getDistanceSquared:(CGPoint) pt otherPoint:(CGPoint)otherPoint {
    return pow(pt.x - otherPoint.x, 2) + pow(pt.y - otherPoint.y, 2);
}
@end
