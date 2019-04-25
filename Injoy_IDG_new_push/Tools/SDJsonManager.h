//
//  SDJsonManager.h
//  SDMarketingManagement
//
//  Created by Rao on 15-5-26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDBaseModel.h"
#import <Foundation/Foundation.h>

@interface SDJsonManager : NSObject
/// 将数组变成字符串
+ (NSString*)arrayToJson:(NSArray*)sourceAry;
/// 将字典变成字符串
+ (NSString*)dictionaryToJson:(NSDictionary*)sourceDict;
/// 传入一个字典和model.解析字典成model模型
+ (NSObject<NSObject>*)modelFromDictionary:(NSDictionary*)sourceDict witheModel:(NSObject<NSObject>*)sourceModel;
/// 将一个数组转换成对应的className实体数组
+ (NSArray*)modelAryFromSourceAry:(NSArray*)sourceAry withModelClassName:(NSString*)className;
/// 将一个字典转换成对应的className实体
+ (id<NSObject>)modelFromSourceDict:(NSDictionary*)sourceDict withModelClassName:(NSString*)className;
@end
