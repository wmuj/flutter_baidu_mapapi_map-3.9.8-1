//
//  BMFHeatMapModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/26.
//

#import "BMFHeatMapModel.h"
#import "BMFHeatMapHandles.h"
#import <BaiduMapAPI_Map/BMKHeatMap.h>
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <flutter_baidu_mapapi_base/UIColor+BMFString.h>

@implementation BMFHeatMapModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"data" : @"BMFHeatMapModelNode",
             @"datas" : @"NSArray"
    };
}

- (BMKHeatMap *)toBMKHeatMap {
    BMKHeatMap *heatMap = [BMKHeatMap new];
    heatMap.mRadius = self.radius;
    heatMap.mRadiusIsMeter = self.radiusIsMeter;
    heatMap.mRadiusMeter = self.radiusMeter;
    heatMap.mMaxShowLevel = self.maxShowLevel;
    heatMap.mMinShowLevel = self.minShowLevel;
    heatMap.mGradient = [self.gradient toBMKGradient];
    heatMap.mOpacity = self.opacity;
    heatMap.mMaxHight = self.mMaxHight;
    heatMap.mMaxIntensity = self.mMaxIntensity;
    heatMap.mMinIntensity = self.mMinIntensity;
    
    BMKAnimation *animation = [BMKAnimation new];
    animation.duration = self.animation.duration;
    animation.type = (int)self.animation.type;
    heatMap.animation = animation;
    BMKAnimation *frameAnimation = [BMKAnimation new];
    frameAnimation.duration = self.frameAnimation.duration;
    frameAnimation.type = (int)self.frameAnimation.type;
    heatMap.frameAnimation = frameAnimation;
    NSMutableArray *mut = [NSMutableArray array];
    for (BMFHeatMapModelNode *node in self.data) {
        [mut addObject:[node toBMKHeatMapNode]];
    }
    heatMap.mData = mut;
    
    if (self.datas && self.datas.count > 0) {
        NSMutableArray <NSMutableArray<BMKHeatMapNode *> *> *mut = [NSMutableArray array];
        
        for (NSArray *list in self.datas) {
            NSMutableArray <BMKHeatMapNode *> *listNode = [NSMutableArray array];
            
            for (NSDictionary *nodeDic in list) {
                BMFHeatMapModelNode *node = [BMFHeatMapModelNode bmf_modelWith:nodeDic];
                BMKHeatMapNode *fInfo = [node toBMKHeatMapNode];
                [listNode addObject:fInfo];
            }
            [mut addObject:listNode];
        }
        heatMap.mDatas = [mut copy];
    }
    return heatMap;
}

@end

@implementation BMFAnimation


@end

@implementation BMFGradient

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"colors" : @"NSString",
             @"startPoints" : @"NSNumber"
    };
}

- (BMKGradient *)toBMKGradient {
    BMKGradient *gradient = [BMKGradient new];
    NSMutableArray *colors = [NSMutableArray array];
    for (NSString *color in self.colors) {
        [colors addObject:[UIColor fromColorString:color]];
    }
    gradient.mColors = colors;
    gradient.mStartPoints = self.startPoints;
    return gradient;
}

@end


@implementation  BMFHeatMapModelNode

- (BMKHeatMapNode *)toBMKHeatMapNode {
    BMKHeatMapNode *node = [BMKHeatMapNode new];
    node.intensity = self.intensity;
    node.pt = [self.pt toCLLocationCoordinate2D];
    return node;
}

@end
