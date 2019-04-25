//
//  CXYMEventStore.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/9/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CXYMEventStoretypeNum) {
    CXYMEventStoretypeNumCommon = 1,///<普通会议
    CXYMEventStoretypeNumWeek,///<周会
    CXYMEventStoretypeNumMonth///<月会
};


@interface CXYMEventStore : NSObject

@property (nonatomic, assign) NSInteger eid;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *meetPlace;
@property (nonatomic, assign) CXYMEventStoretypeNum typeNum;

+ (NSArray <CXYMEventStore *> *)eventStoreWithArray:(NSArray *)array;

@end
