//
//  CXPushHelper.m
//  SDMarketingManagement
//
//  Created by lancely on 6/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXPushHelper.h"
#import "HttpTool.h"

@implementation CXPushHelper

+ (BOOL)haveNew:(NSString *)firstType, ... {
    va_list types;
    id type;
    NSMutableDictionary *temp_v_pushes = [VAL_PUSHES mutableCopy];
    if (firstType) {
        if ([VAL_PUSHES_MSGS(firstType) count] > 0) {
            return YES;
        }
        va_start(types, firstType);
        while ((type = va_arg(types, id))) {
            if ([VAL_PUSHES_MSGS(type) count] > 0) return YES;
        }
        va_end(types);
    }
    return NO;
}

+ (void)haveRead:(NSString *)firstType, ... {
    va_list types;
    id type;
    NSMutableDictionary *temp_v_pushes = [VAL_PUSHES mutableCopy];
    if (!temp_v_pushes) {
        return;
    }
    if (firstType) {
        if ([VAL_PUSHES_MSGS(firstType) count] > 0) {
            [temp_v_pushes removeObjectForKey:firstType];
            VAL_PUSHES_RESET(temp_v_pushes);
        }
        va_start(types, firstType);
        while ((type = va_arg(types, id))) {
            [temp_v_pushes removeObjectForKey:type];
            VAL_PUSHES_RESET(temp_v_pushes);
        }
        va_end(types);
    }
}

+ (NSInteger)getUnreadCount {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate reloadRedCount];
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

+ (void)updateDeviceToken {
    if (VAL_DeviceToken.length <= 0) {
        return;
    }
    NSDictionary *params = @{
                             @"userId": VAL_USERID,
                             @"deviceToken": VAL_DeviceToken
                             };
    [HttpTool postWithPath:@"/system/receiveDeviceToken.json" params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            NSLog(@"deviceToken 发送成功");
        }
        else {
            NSLog(@"deviceToken 发送失败, %@", JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"deviceToken 发送失败：%@", error.description);
    }];
}

+ (void)sendBadgeToServer {
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KUserID];
    if (userId == nil) {
        return;
    }
    
    NSInteger unreadCount = [self getUnreadCount];
    NSDictionary *params = @{
                             @"userId": userId,
                             @"badge": @(unreadCount)
                             };
    [HttpTool postWithPath:@"/system/updateAppleApnsBadge" params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSLog(@"更新badge成功");
        }
        else {
            NSLog(@"更新badge失败：%@", JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"更新badge失败：%@", error.description);
    }];
}

#pragma mark - 我的审批数量
+(NSInteger)getMyApprove{
    
    NSInteger trave = [[NSUserDefaults standardUserDefaults] integerForKey:CX_trave];
    NSInteger holiday = [[NSUserDefaults standardUserDefaults] integerForKey:CX_holiday];
    NSInteger resumption = [[NSUserDefaults standardUserDefaults] integerForKey:CX_resumption];
    NSInteger cost = [[NSUserDefaults standardUserDefaults] integerForKey:CX_cost];
    
    NSInteger sum = trave+holiday+resumption+cost;
    return sum;
}

@end
