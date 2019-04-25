//
//  SDChatManager.h
//  SDMarketingManagement
//
//  Created by Rao on 15-5-7.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCompanyUserModel.h"
#import "SDDepartmentModel.h"
#import "SDDepartmentRealModel.h"

@interface SDChatManager : NSObject
+ (SDChatManager*)sharedChatManager;
/// 联系人列表
@property (nonatomic, strong, readonly) NSArray* userContactAry;
/// 部门联系人列表
@property (nonatomic, strong, readonly) NSArray* deptUserArr;
/// 部门列表
@property (nonatomic, strong) NSArray* deptArr;
/// 通过部门ID获取部门所有人员
- (NSArray*)deptUserArr:(int)dpid;
/// 通过环信ID查找到相应的实体
- (SDCompanyUserModel*)searchUserByHxAccount:(NSString*)hxaccount;
/// 将SDCompanyUserModel转换成EMbuddy实体.ContactSelectionViewController中使用
@property (nonatomic,strong,readonly) NSArray *embuddyAry;

-(NSArray *)authorityData;
@end
