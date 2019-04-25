//
//  SDScopeTableViewCell.m
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/6/8.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDScopeTableViewCell.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDContactsDetailController.h"
#import "AppDelegate.h"
#import "SDDataBaseHelper.h"

@implementation SDScopeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = 10.f;
    imageFrame.size.width = 35.0f;
    imageFrame.size.height = 35.0f;
    self.imageView.frame = imageFrame;
    
    //给头像添加一个手势，点击到个人信息页面
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.imageView addGestureRecognizer:tapGesture];

    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x = 70.0f;
    self.textLabel.frame = labelFrame;
}

- (void)tapAction
{
    if ([[AppDelegate getUserID] isEqualToString:[NSString stringWithFormat:@"%d",self.userID]])
    {
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
//        NSNumber *userID = [NSNumber numberWithInt:self.userID];
//        pivc.imAccount = userID;
        [self.userInfoDelegate.navigationController pushViewController:pivc animated:YES];
        if ([self.userInfoDelegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.userInfoDelegate.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
    }else
    {
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = [[SDDataBaseHelper shareDB] getUserByUserID:[NSString stringWithFormat:@"%d",self.userID]].imAccount;
        pivc.canPopViewController = YES;
        [self.userInfoDelegate.navigationController pushViewController:pivc animated:YES];
        if ([self.userInfoDelegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.userInfoDelegate.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

}

@end
