//
//  NSString+CXYMCategory.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "NSString+CXYMCategory.h"

@implementation NSString (CXYMCategory)
+ (NSString *)yyyyMMddHHmmWithDate:(NSNumber *)date{
    double time = [date doubleValue];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    return [formatter stringFromDate:dateTime];
}
+ (NSString *)yyyyMMddHHmmssWithDate:(NSNumber *)date{
    double time = [date doubleValue];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:dateTime];
}





@end
