//
//  BMFEdgeInsets.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/3.
//

#import "BMFEdgeInsets.h"

@implementation BMFEdgeInsets

- (UIEdgeInsets)toUIEdgeInsets {
    return UIEdgeInsetsMake(self.top, self.left, self.bottom, self.right);
}

@end
