//
//  BMFTextModel.h
//  flutter_baidu_mapapi_map
//
//  Created by v_wangdachuan on 2022/9/13.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMFTypeFace;
NS_ASSUME_NONNULL_BEGIN

@interface BMFTextModel : BMFModel
/// flutter层text的唯一id(用于区别哪个text)
@property (nonatomic, copy) NSString *Id;

/// 自定义字段
@property (nonatomic, strong) NSDictionary *customMap;

/// 文本
@property (nonatomic, copy) NSString *text;

/// 经纬度
@property (nonatomic, strong) BMFCoordinate *position;

/// 背景颜色
@property (nonatomic, copy) NSString *bgColor;

/// 字体颜色
@property (nonatomic, copy) NSString *fontColor;

/// 字体大小
@property (nonatomic, assign) int fontSize;

/// 字体类型
@property (nonatomic, strong) BMFTypeFace *typeFace;

/// 旋转角度，逆时针
@property (nonatomic, assign) double rotate;

/// 字符间距
@property (nonatomic, assign) double paragraphSpacing;

/// 文字的最大行宽
@property (nonatomic, assign) int maxLineWidth;

/// 文字的行间距
@property (nonatomic, assign) int lineSpacing;

/// 文字对齐方式
@property (nonatomic, assign) int alignment;

/// 字符截断类型
@property (nonatomic, assign) int lineBreakMode;

/// 文字最小显示层级
@property (nonatomic, assign) int startLevel;

/// 文字最大显示层级
@property (nonatomic, assign) int endLevel;

@end

@interface BMFTypeFace : BMFModel

@property (nonatomic, assign) int textStype;

@end

NS_ASSUME_NONNULL_END
