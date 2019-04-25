//
//  SDChatManager.m
//  SDMarketingManagement
//
//  Created by Rao on 15-5-7.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDChatManager.h"
#import "SDDataBaseHelper.h"

@interface SDChatManager () {
    SDDataBaseHelper* helper;
}

- (instancetype)initInstance;
@end

@implementation SDChatManager

- (instancetype)initInstance
{
    if (self = [super init]) {
        helper = [SDDataBaseHelper shareDB];
    }
    return self;
}

static SDChatManager* m_instance;

+ (SDChatManager*)sharedChatManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == m_instance) {
            m_instance = [[self alloc] initInstance];
        }
    });
    return m_instance;
}

/// 获取所有用户
- (NSArray*)userContactAry
{
    return [helper getUserData];
}

- (NSArray*)deptArr
{
    return [helper getAllDepartment];
}

/// 通过部门ID获取部门所有人员
- (NSArray*)deptUserArr:(int)dpid
{
    NSMutableArray* resultAry = [[NSMutableArray alloc] init];

    NSArray* arr = [helper getDepartment:dpid];
    for (SDCompanyUserModel* deptRelModel in arr) {
        [resultAry addObject:deptRelModel];
    }
    return resultAry;
}

/// 通过环信ID查找到相应的实体
- (SDCompanyUserModel*)searchUserByHxAccount:(NSString*)hxaccount
{
    @synchronized(hxaccount)
    {
        NSArray* allUsers = [[SDDataBaseHelper shareDB] getUserData];

        SDCompanyUserModel* result = nil;

        for (SDCompanyUserModel* userModel in allUsers) {
            if ([hxaccount isEqualToString:userModel.hxAccount]) {
                result = userModel;
                break;
            }
        }
        return result;
    }
}

- (NSArray*)embuddyAry
{
    NSArray* allUsers = [m_instance userContactAry];

    NSMutableArray* resultAry = [[NSMutableArray alloc] initWithCapacity:[allUsers count]];

//    for (SDCompanyUserModel* model in allUsers) {
//        EMBuddy* buddy = [EMBuddy buddyWithUsername:model.hxAccount];
//        buddy.followState = eEMBuddyFollowState_FollowedBoth;
//        [resultAry addObject:buddy];
//    }

    return resultAry;
}

@end
