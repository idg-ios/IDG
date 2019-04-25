//
//  CXUserModel.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXUserModel.h"

@interface CXUserModel () <YYModel>
@end

@implementation CXUserModel

+ (NSArray *)modelPropertyWhitelist {
    // 暂时只序列化以下字段
    return @[@"name", @"eid", @"job", @"imAccount", @"userName", @"userId"];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

@end
