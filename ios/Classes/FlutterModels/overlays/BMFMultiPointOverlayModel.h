//
//  BMFMultiPointOverlayModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2021/12/29.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFMapSize;
@class BMFMapPoint;
@class BMKMultiPointItem;
@class BMFMultiPointItem;


NS_ASSUME_NONNULL_BEGIN

@interface BMFMultiPointOverlayModel : BMFModel

/// flutter层multiPointOverlay的唯一id(用于区别哪个multiPointOverlay)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

///点对象集合
@property (nonatomic, copy) NSArray<BMFMultiPointItem *> *items;

/// 标注纹理图片
@property (nonatomic, copy) NSString *icon;

/// 纹理渲染大小，默认为icon图片大小
@property (nonatomic, strong) BMFMapSize *pointSize;

/// 经纬度对应图片中的位置，默认为(0.5,0.5)，范围[0-1] 负值自动取其绝对值 左上角为 (0,0) 右下角为 (1,1)
@property (nonatomic, strong) BMFMapPoint *anchor;

@end

@interface BMFMultiPointItem : BMFModel

/// 经纬度
@property (nonatomic, strong) BMFCoordinate *coordinate;

/// 标题
@property (nonatomic, copy, nullable) NSString *title;

/// 副标题
@property (nonatomic, copy, nullable) NSString *subtitle;

+ (instancetype)fromBMKMultiPointItem:(BMKMultiPointItem *)item;

- (nullable BMKMultiPointItem *)toBMKMultiPointItem;

@end

NS_ASSUME_NONNULL_END
