//
//  AppDelegate+IM.h
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (IM)<CXIMSocketManagerDelegate>

- (void)imApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;


- (void)imApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
- (void)imApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken ;
- (void)imApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

@end
