//
//  NSArray+CXCategory.m
//  SDMarketingManagement
//
//  Created by lancely on 5/17/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "NSArray+CXCategory.h"
#import "YYModel.h"
#import "SDCompanyUserModel.h"

@implementation NSArray (CXCategory)

- (NSString *)ccParam {
    NSMutableArray<NSDictionary *> *arr = NSMutableArray.array;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:SDCompanyUserModel.class]) {
            SDCompanyUserModel *userModel = (SDCompanyUserModel *)obj;
            [arr addObject:@{
                             @"id" : userModel.userId.stringValue,
                             @"name" : userModel.realName
                             }];
        }
    }];
    return [arr yy_modelToJSONString];
}

- (BOOL)isNeedNextApproval {
    __block BOOL flag = NO;
    [self enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 兼容性处理。。（状态有的是string有时是number）
        NSString *t = obj.allValues.firstObject;
        if ([t isKindOfClass:NSNumber.class]) {
            t = [(NSNumber *)t stringValue];
        }
        if (t.length <= 0) {
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;
}

@end
