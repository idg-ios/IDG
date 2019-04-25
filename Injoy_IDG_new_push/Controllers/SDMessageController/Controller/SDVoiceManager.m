//
//  SDVoiceManager.m
//  SDMarketingManagement
//
//  Created by Rao on 15/12/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDVoiceManager.h"

@implementation SDVoiceManager

static SDVoiceManager* m_SDVoiceManager = nil;

NSString* voiceKey = @"__voice__";

+ (instancetype)sharedVoiceManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == m_SDVoiceManager) {
            m_SDVoiceManager = [[self.class alloc] init];
        }
    });
    return m_SDVoiceManager;
}

- (void)saveValue:(NSNumber*)value key:(NSString*)key
{
    NSMutableDictionary* params = [[[NSUserDefaults standardUserDefaults] valueForKey:voiceKey] mutableCopy];

    if (params == nil) {
        params = [[NSMutableDictionary alloc] init];
    }
    [params setValue:value forKey:key];

    [[NSUserDefaults standardUserDefaults] setValue:params forKey:voiceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber*)getValue:(NSString*)key
{
    NSMutableDictionary* params = [[[NSUserDefaults standardUserDefaults] valueForKey:voiceKey] mutableCopy];
    return [params valueForKey:key];
}

@end
