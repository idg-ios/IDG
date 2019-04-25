//
//  SDJsonManager.m
//  SDMarketingManagement
//
//  Created by Rao on 15-5-26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDJsonManager.h"
#import <objc/runtime.h>

@implementation SDJsonManager

/// 将数组变成字符串
+ (NSString*)arrayToJson:(NSArray*)sourceAry
{
    if (0 == [sourceAry count]) {
        return nil;
    }

    NSData* data = [NSJSONSerialization dataWithJSONObject:sourceAry options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/// 将字典变成字符串
+ (NSString*)dictionaryToJson:(NSDictionary*)sourceDict
{
    if (0 == [[sourceDict allKeys] count]) {
        return nil;
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:sourceDict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/// 传入一个字典和model.解析字典成model模型
+ (NSObject<NSObject>*)modelFromDictionary:(NSDictionary*)sourceDict witheModel:(NSObject<NSObject>*)sourceModel
{
    NSArray* allKeys = [sourceDict allKeys];

    int length = (int)[sourceDict allKeys].count;
    for (int i = 0; i < length; i++) {
        SEL funSelector = NSSelectorFromString(allKeys[i]);
        if ([allKeys[i] isEqualToString:@"id"]) {
            [sourceModel setValue:sourceDict[allKeys[i]] forKey:@"ocId"];
        }
        else {
            if (NO == [sourceModel respondsToSelector:funSelector]) {
                NSLog(@"funSelector==%@", allKeys[i]);
                continue;
            }
            [sourceModel setValue:sourceDict[allKeys[i]] forKey:allKeys[i]];
        }
    }
    return sourceModel;
}

/// 将一个数组转换成对应的className实体数组
+ (NSArray*)modelAryFromSourceAry:(NSArray*)sourceAry withModelClassName:(NSString*)className
{
    NSMutableArray* resultAry = [[NSMutableArray alloc] init];

    for (NSDictionary* dict in sourceAry) {
        NSObject<SDBaseModel>* obj = [[NSClassFromString(className) alloc] init];
        NSObject<SDBaseModel>* model = [self modelFromDictionary:dict witheModel:obj];
        [resultAry addObject:model];
    }
    return resultAry;
}

/// 将一个字典转换成对应的className实体
+ (id<SDBaseModel>)modelFromSourceDict:(NSDictionary*)sourceDict withModelClassName:(NSString*)className
{
    NSObject<SDBaseModel>* obj = [[NSClassFromString(className) alloc] init];
    NSObject<SDBaseModel>* model = [self modelFromDictionary:sourceDict witheModel:obj];
    return model;
}

@end
