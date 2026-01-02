//
//  BMFOLSearchRecordModel.m
//  flutter_baidu_mapapi_map
//
//  Created by zhangbaojin on 2020/3/25.
//

#import "BMFOLSearchRecordModel.h"
#import <flutter_baidu_mapapi_base/BMFMapModels.h>
#import <BaiduMapAPI_Map/BMKOfflineMapType.h>

@implementation BMFOLSearchRecordModel

+ (NSDictionary *)bmf_setupObjectClassInArray {
    return @{@"childCities" : @"BMFOLSearchRecordModel"
    };
}
+ (BMFOLSearchRecordModel *)fromBMKOLSearchRecord:(BMKOLSearchRecord *)olSearchRecord {
    BMFOLSearchRecordModel *model = [BMFOLSearchRecordModel new];
    model.cityID = olSearchRecord.cityID;
    model.cityName = olSearchRecord.cityName;
    model.dataSize = (int)olSearchRecord.size;
    model.cityType = olSearchRecord.cityType;
    if (olSearchRecord.childCities && olSearchRecord.childCities.count > 0) {
        model.childCities = [BMFOLSearchRecordModel fromDataArray:olSearchRecord.childCities];
    }
    
    return model;
}

+ (NSArray<BMFOLSearchRecordModel *> *)fromDataArray:(NSArray<BMKOLSearchRecord *> *)dataArray {
    NSMutableArray<BMFOLSearchRecordModel *> * models = [NSMutableArray array];
    for (BMKOLSearchRecord *record in dataArray) {
        [models addObject:[BMFOLSearchRecordModel fromBMKOLSearchRecord:record]];
    }
    return models;
}
@end


@implementation BMFOLUpdateElementModel 

+ (BMFOLUpdateElementModel *)fromBMKOLUpdateElement:(BMKOLUpdateElement *)olUpdateElement {
    BMFOLUpdateElementModel *model = [BMFOLUpdateElementModel new];
    model.cityID = olUpdateElement.cityID;
    model.cityName = olUpdateElement.cityName;
    model.size = (int)olUpdateElement.size;
    model.serversize = (int)olUpdateElement.serversize;
    model.ratio = olUpdateElement.ratio;
    model.status = olUpdateElement.status;
    model.update = olUpdateElement.update;
    model.geoPt = [BMFCoordinate fromCLLocationCoordinate2D:olUpdateElement.pt];
    return model;
}
+ (NSArray<BMFOLUpdateElementModel *> *)fromDataArray:(NSArray<BMKOLUpdateElement *> *)dataArray {
    NSMutableArray<BMFOLUpdateElementModel *> *models = [NSMutableArray array];
    for (BMKOLUpdateElement *element in dataArray) {
        [models addObject:[BMFOLUpdateElementModel fromBMKOLUpdateElement:element]];
    }
    return models;
}
@end
