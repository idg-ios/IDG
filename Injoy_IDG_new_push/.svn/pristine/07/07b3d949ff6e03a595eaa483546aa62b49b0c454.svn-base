//
//  CXFocusSignMembersViewController.h
//  SDMarketingManagement
//
//  Created by lancely on 4/22/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
#import "SDCompanyUserModel.h"

/**
 *  页面展现模式
 */
typedef NS_ENUM(NSInteger, CXFocusSignMembersPresentMode) {
    /**
     *  仅显示成员
     */
    CXFocusSignMembersPresentModeDisplay,
    /**
     *  删除
     */
    CXFocusSignMembersPresentModeDelete
};

typedef void(^DidTapDeleteBtnCallback)(NSArray<SDCompanyUserModel *> *selectedUsers, NSArray<SDCompanyUserModel *> *unselectedUsers);

@interface CXFocusSignMembersViewController : SDRootViewController

/**
 *  展现模式
 */
@property (nonatomic, assign) CXFocusSignMembersPresentMode presentMode;

/**
 *  用户(userid)
 */
@property (nonatomic, copy) NSArray<NSNumber *> *users;

/**
 *  点击删除按钮回调
 *
 *  @param callback 回调
 */
- (void)setDidTapDeleteBtnCallback:(DidTapDeleteBtnCallback)callback;

@end
