//
//  BMFOLSearchRecordModel.h
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import <flutter_baidu_mapapi_base/BMFModel.h>

@class BMFCoordinate;
@class BMKOLSearchRecord;
@class BMKOLUpdateElement;

NS_ASSUME_NONNULL_BEGIN

@interface BMFOLSearchRecordModel : BMFModel

/// 城市名称
@property (nonatomic, copy) NSString *cityName;

/// 数据包总大小
@property (nonatomic, assign) int dataSize;

/// 城市ID
@property (nonatomic, assign) int cityID;

/// 城市类型 0：全国；1：省份；2：城市；如果是省份，可以通过childCities得到子城市列表
@property (nonatomic, assign) int cityType;

/// 子城市列表
@property (nonatomic, copy) NSArray<BMFOLSearchRecordModel *> *childCities;

+ (BMFOLSearchRecordModel *)fromBMKOLSearchRecord:(BMKOLSearchRecord *)olSearchRecord;

+ (NSArray<BMFOLSearchRecordModel *> *)fromDataArray:(NSArray<BMKOLSearchRecord *> *)dataArray;
@end


@interface BMFOLUpdateElementModel : BMFModel

/// 城市名称
@property (nonatomic, copy) NSString *cityName;

/// 城市ID
@property (nonatomic, assign) int cityID;

/// 已下载数据大小，单位：字节
@property (nonatomic, assign) int size;

/// 服务端数据大小，当update为YES时有效，单位：字节
@property (nonatomic, assign) int serversize;

/// 下载比率，100为下载完成，下载完成后会自动导入，status为4时离线包导入完成
@property (nonatomic, assign) int ratio;

/// 下载状态, -1:未定义 1:正在下载　2:等待下载　3:已暂停　4:完成 5:校验失败 6:网络异常 7:读写异常 8:Wifi网络异常 9:离线包数据格式异常，需重新下载离线包 10:离线包导入中
@property (nonatomic, assign) int status;

/// 更新状态，离线包是否有更新（有更新需重新下载）
@property (nonatomic, assign) BOOL update;

/// 城市中心点
@property (nonatomic, strong) BMFCoordinate *geoPt;

+ (BMFOLUpdateElementModel *)fromBMKOLUpdateElement:(BMKOLUpdateElement *)olUpdateElement;

+ (NSArray<BMFOLUpdateElementModel *> *)fromDataArray:(NSArray<BMKOLUpdateElement *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
