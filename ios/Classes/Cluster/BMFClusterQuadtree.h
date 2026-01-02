//
//  BMFClusterQuadtree.h
//  flutter_baidu_mapapi_map
//
//  Created by baidu on 2024/3/22.
//

#import <Foundation/Foundation.h>
#import "BMFCluster.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMFQuadItem : NSObject
@property (nonatomic, readonly) CGPoint pt;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@interface BMFClusterQuadtree : NSObject

//四叉树区域
@property (nonatomic, assign) CGRect rect;
//所包含BMFQuadItem
@property(nonatomic, readonly) NSMutableArray *quadItems;
- (id)initWithRect:(CGRect) rect;
//添加item
- (void)addItem:(BMFQuadItem*) quadItem;
//清除items
- (void)clearItems;
//获取rect范围内的BMFQuadItem
- (NSArray*)searchInRect:(CGRect) searchRect;

@end

NS_ASSUME_NONNULL_END
