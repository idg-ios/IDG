//
//  CXGroupMembersCollectionView.m
//  SDMarketingManagement
//
//  Created by haihualai on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXGroupMembersCollectionView.h"
#import "CXUserHeadView.h"
#import "SDContactsDetailController.h"
#import "SDDataBaseHelper.h"
#import "SDIMPersonInfomationViewController.h"

@interface CXGroupMembersCollectionView () <CXUserHeadViewDelegate>

@end

@implementation CXGroupMembersCollectionView

CGFloat userHeadHeight = 80.f;

- (instancetype)initWithFrame:(CGRect)frame groupMembers:(NSArray*)groupMembers
{
    if (self = [super initWithFrame:frame]) {

        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        CGFloat wd = CGRectGetWidth(frame);
        CGFloat ht = CGRectGetHeight(frame);
        /// 每行4个
        int column = 4;
        /// 头像宽度
        CGFloat userHeadWidth = 60.f;
        CGFloat userHeadHeight = 80.f;

        int count = (int)[groupMembers count];
        if (count > 12) {
            // 不要超过12个人数
            count = 12;
        }
        CGFloat space = ceilf((wd - column * userHeadWidth) / (column + 1));
        CGFloat topBottomMargin = 0.f;

        if (count <= column) {
            topBottomMargin = (ht - userHeadHeight) / 2.f;
        }
        else {
            // 算出有多少row
            int row = 0;
            row = (int)ceil((float)count / column);
            topBottomMargin = ceilf((ht - row * userHeadHeight) / (row + 1));
        }

        SDCompanyUserModel* userModel = nil;

        for (int i = 0; i < count; i++) {
            int temp = i % column;
            float x = (temp * userHeadWidth) + (temp + 1) * space;
            float y = 0.f;
            int temp_y = (int)(i / column);
            y = (temp_y * userHeadHeight) + (temp_y + 1) * topBottomMargin;

            userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:[groupMembers[i] valueForKey:@"userId"]];
            CXUserHeadView* oneView = [[CXUserHeadView alloc] initWithUserModel:userModel];
            oneView.userHeadViewDelegate = self;
            [self addSubview:oneView];
            oneView.frame = CGRectMake(x, y, userHeadWidth, userHeadHeight);
        }
    }
    return self;
}

#pragma mark - CXUserHeadViewDelegate

- (void)touchButtonEvent:(SDCompanyUserModel*)userModel
{
    if (userModel) {
        if ([userModel.imAccount isEqualToString:VAL_HXACCOUNT]) {
            // 本人
            SDIMPersonInfomationViewController* personVC = [[SDIMPersonInfomationViewController alloc] init];
            personVC.canPopViewController = YES;
            personVC.imAccount = userModel.imAccount;
            [self.navigationController_ pushViewController:personVC animated:YES];
        }
        else {
            // 其他人
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.imAccount = userModel.imAccount;
            pivc.canPopViewController = YES;
            [self.navigationController_ pushViewController:pivc animated:YES];
            if ([self.navigationController_ respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController_.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }
}

@end
