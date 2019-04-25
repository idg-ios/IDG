//
//  NSDictionary+CXCategory.m
//  SDMarketingManagement
//
//  Created by fanzhong on 16/5/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "NSDictionary+CXCategory.h"

@implementation NSDictionary (CXCategory)

- (instancetype)removeNSNull {
    NSMutableDictionary *dict = NSMutableDictionary.alloc.init;
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:NSNull.class]) {
            dict[key] = obj;
        }
    }];
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [dict copy];
    }
    return dict;
}

- (BOOL)isNeedNextApproval {
    __block BOOL flag = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] && [obj length] <= 0) {
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;
}

@end
