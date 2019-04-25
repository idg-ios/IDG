//
//  SDBaseModel.m
//  SDMarketingManagement
//
//  Created by Rao on 15-5-26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDBaseModel.h"

@interface SDBaseModel ()
@end

@implementation SDBaseModel
@synthesize ygJob;
@synthesize ygDeptName;
@synthesize ygName;
@synthesize ygId;
@synthesize ygDeptId;

#pragma mark - get & set

- (int)totalPage {
    NSNumber *num = [NSNumber numberWithInt:kPageSize];
    return (int) ceil(self.total / [num floatValue]);
}

#pragma mark - YYModel

+ (NSArray *)modelPropertyBlacklist {
    return @[@"debugDescription", @"description", @"hash", @"superclass", @"totalPage", @"dataExt"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"data"] isKindOfClass:NSDictionary.class]) {
        self.dataExt = [self.class yy_modelWithDictionary:dic[@"data"]];
    }
    return YES;
}

@end
