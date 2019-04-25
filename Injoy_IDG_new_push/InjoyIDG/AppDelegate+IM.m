//
//  AppDelegate+IM.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AppDelegate+IM.h"
#import "MBProgressHUD.h"
#import "HttpTool.h"

//@interface AppDelegate () <CXIMSocketManagerDelegate>
//
//@end

@implementation AppDelegate (IM)

#pragma mark - UIApplication

- (void)        imApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *socketUrl;
    NSString *restUrl;
    if ([urlPrefix isEqualToString:@"http://192.168.101.236:8080/api/"]) {
        // 本地环境
        socketUrl = @"ws://192.168.101.158:8091";
        restUrl = @"http://192.168.101.158:8080";
    } else if ([urlPrefix isEqualToString:@"http://new-ts0emapi1.chinacloudapp.cn/api/"]
               || [urlPrefix isEqualToString:@"http://192.168.101.107:8080/api/"]
               || [urlPrefix isEqualToString:@"https://ts0erp.chinacloudapp.cn/erp/"]
               || [urlPrefix isEqualToString:@"http://192.168.101.15:8080/erp/"]
               || [urlPrefix isEqualToString:@"http://192.168.101.25/oa-api/"]
               || [urlPrefix isEqualToString:@"http://omsc.chinacloudapp.cn/oa-api/"]
               || [urlPrefix isEqualToString:@"http://192.168.101.16:8080/oa-api/"]    ){
        // 测试环境
        socketUrl = @"ws://tssdk.myinjoy.cn:8091";
        restUrl = @"http://tssdk.myinjoy.cn:8080";
    }
    else
    {
        // 正式环境
        socketUrl = @"ws://zssdk.myinjoy.cn:8091";
        restUrl = @"http://zssdk.myinjoy.cn:8080";
    }

    [[CXIMService sharedInstance] initializeSDKWithOptions:@{
            @"socketUrl": socketUrl,
            @"restUrl": restUrl
    }];

    [[CXIMService sharedInstance].socketManager addDelegate:self];

#if TARGET_IPHONE_SIMULATOR

#else
    
#endif
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
}

- (void)imApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)imApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = deviceToken.description;
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken=%@", token);

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //将token回传后台
    NSString *path = [NSString stringWithFormat:@"%@system/receiveDeviceToken",urlPrefix];
    NSString *userID = [AppDelegate getUserID];
    NSDictionary *parma = @{@"deviceToken":token ? : @"",
                            @"userId":userID ? : @""};
    [HttpTool postWithPath:path params:parma success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)imApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程通知失败----%@", error.localizedDescription);
}

#pragma mark - CXIMSocketManagerDelegate

- (void)socketManager:(CXIMSocketManager *)socketManager disConnectWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (code != 1001) {
        //如果不是被挤下线
        [[CXIMService sharedInstance].socketManager reconnectWithCompletion:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 提示

- (void)showMessage:(NSString *)msg {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5 ? 200.f : 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


@end
