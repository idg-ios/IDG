//
//  CXBusinessTripEditDataManager.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBusinessTripEditDataManager.h"
#import "CXBusinessTripCityModel.h"

@implementation CXBusinessTripEditDataManager
@synthesize model = _model;
static CXBusinessTripEditDataManager *_instance;
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil){
            _instance = [[CXBusinessTripEditDataManager alloc]init];
        }
    });
    return _instance;
}

- (void)setModel:(CXBusinessTripDetailModel *)model{
    _model = model;
    if([model.tripType isEqualToString:@"MAINLAND"]){
        self.tripType = @"国内";
        if(!self.cityArray.count){
            return;
        }
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.id = %@",self.model.startCity];
        CXBusinessTripCityModel *sModel = [self.cityArray filteredArrayUsingPredicate:predicate1].firstObject;
        self.startCityRealName = sModel.name?:self.model.startCity;
        __block NSMutableArray *targetCities = [NSMutableArray array];
        [self.model.targetCitys enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop){
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"self.id = %@",object];
            CXBusinessTripCityModel *cModel = [self.cityArray filteredArrayUsingPredicate:predicate2].firstObject;
            if(cModel != nil){
                [targetCities addObject:cModel.name];
            }else{
                [targetCities addObject:object];
            }
        }];
        self.targetCitiesRealName = [targetCities componentsJoinedByString:@","];
    }
    else{
        self.tripType = @"海外";
        self.startCityRealName = self.model.startCity;
        self.targetCitiesRealName = [self.model.targetCitys componentsJoinedByString:@","];
    }
}
- (CXBusinessTripDetailModel *)dataModel{
    if(nil == _model){
        _model = [[CXBusinessTripDetailModel alloc]init];
    }
    return _model;
}
@end
