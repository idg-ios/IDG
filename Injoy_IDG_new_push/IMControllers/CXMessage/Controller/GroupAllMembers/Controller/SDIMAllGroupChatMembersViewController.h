//
//  SDIMAllGroupChatMembersViewController.h
//  SDMarketingManagement
//
//  Created by wtz on 16/4/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"

@interface SDIMAllGroupChatMembersViewController : SDRootViewController
@property (nonatomic, strong) NSString* groupId;
/// 群组类型
@property (nonatomic, assign) CXGroupType groupType;

//是否是发起通话
@property (nonatomic) BOOL isSendCall;

//是否是系统群
@property (nonatomic) BOOL isSystemGroup;

@end
