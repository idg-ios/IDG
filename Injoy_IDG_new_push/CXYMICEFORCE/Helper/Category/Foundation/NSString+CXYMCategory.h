//
//  NSString+CXYMCategory.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CXYMCategory)

/**
 将服务器返回的时间戳转化为时间格式:2012-12-12 12:12:12,yyyy-MM-dd HH:mm:ss

 @param date 服务器返回的时间戳
 @return 时间格式:2012-12-12 12:12:12
 */
+ (NSString *)yyyyMMddHHmmssWithDate:(NSNumber *)date;
/**
 将服务器返回的时间戳转化为时间格式:2012-12-12 12:12,yyyy-MM-dd HH:mm
 
 @param date 服务器返回的时间戳
 @return 时间格式:2012-12-12 12:12
 */
+ (NSString *)yyyyMMddHHmmWithDate:(NSNumber *)date;


@end
