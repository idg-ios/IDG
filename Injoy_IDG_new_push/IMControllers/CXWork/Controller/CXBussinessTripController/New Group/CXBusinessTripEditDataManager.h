//
//  CXBusinessTripEditDataManager.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXBusinessTripDetailModel.h"
@interface CXBusinessTripEditDataManager : NSObject
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong, getter=dataModel)CXBusinessTripDetailModel *model;
@property(nonatomic, strong)NSArray *cityArray;
@property(nonatomic, strong)NSString *startCityRealName;
@property(nonatomic, strong)NSString *targetCitiesRealName;
@property(nonatomic, strong)NSString *tripType;
@property(nonatomic, strong)NSString *startCityJsonString;
@property(nonatomic, strong)NSString *targetCitiesJsonString;
@end
