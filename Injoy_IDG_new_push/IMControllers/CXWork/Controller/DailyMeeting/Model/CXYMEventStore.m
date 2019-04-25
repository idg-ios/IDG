//
//  CXYMEventStore.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/9/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMEventStore.h"

@implementation CXYMEventStore

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _eid = [dictionary[@"eid"] integerValue];
        _startTime = dictionary[@"startTime"];
        _endTime = dictionary[@"endTime"];
        _title = dictionary[@"title"];
        _meetPlace = dictionary[@"meetPlace"];
        _typeNum = [dictionary[@"typeNum"] integerValue];
    }
    return self;
}

+ (NSArray <CXYMEventStore *> *)eventStoreWithArray:(NSArray *)array{
    if (array == nil || array.count == 0) return nil;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if (![dic isKindOfClass:[NSDictionary class]]) return nil;
        CXYMEventStore *eventStore = [[[self class] alloc] initWithDictionary:dic];
        [dataArray addObject:eventStore];
    }
    
    return dataArray;
}
@end
