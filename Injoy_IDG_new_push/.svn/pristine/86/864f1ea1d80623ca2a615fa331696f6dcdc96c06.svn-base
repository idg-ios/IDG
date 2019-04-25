//
//  NSDate+CXYMCategory.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "NSDate+CXYMCategory.h"

@implementation NSDate (CXYMCategory)


+ (NSString *)yyyyMMddWithDate:(NSString *)dateString{
    if([dateString isEqualToString:@""] || dateString.length == 0) return nil;
    NSTimeInterval interval = [dateString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate: date];
}
+ (NSString *)yyyyMMddHHmmWithDate:(NSString *)dateString{
    if([dateString isEqualToString:@""] || dateString.length == 0) return nil;
    NSTimeInterval interval = [dateString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    return [formatter stringFromDate: date];
}
+ (NSString *)yyyyMMddHHmmssWithDate:(NSString *)dateString{
    if([dateString isEqualToString:@""] || dateString.length == 0) return nil;
    NSTimeInterval interval = [dateString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    return [formatter stringFromDate: date];
}
//获取2个日期的间隔天数
+ (NSUInteger)numberOfDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components  = [calendar components:NSCalendarUnitDay
                                                                                  fromDate:fromDate
                                                                                  toDate:toDate
                                                                                  options:NSCalendarWrapComponents];
//    NSLog(@" 获取2个日期的间隔===%@",components);
    return abs(components.day);
}
@end
