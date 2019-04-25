//
//  CXUserModel.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSubordinateUserModel.h"
#import "YYModel.h"

@interface CXSubordinateUserModel () <YYModel>
@end

@implementation CXSubordinateUserModel

+ (NSArray *)modelPropertyWhitelist {
    // 暂时只序列化以下字段
    return @[@"name", @"eid", @"job", @"imAccount"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

- (void)setNilValueForKey:(NSString *)key {

}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"eid": @"userId",
            @"name": @"userName"};
}

@end
