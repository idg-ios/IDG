//
// Created by ___ on 2017/8/10.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXBaseModel.h"


@implementation CXBaseModel

- (int)totalPage {
    NSNumber *num = [NSNumber numberWithInt:kPageSize];
    // 15是后台规定的每页的数据条数
    return (int) ceil(self.total / [num floatValue]);
}

#pragma mark - YYModel

+ (NSArray *)modelPropertyBlacklist {
    return @[@"debugDescription", @"description", @"hash", @"superclass"];
}


@end