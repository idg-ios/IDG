//
//  SDScopeTableViewCell.h
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/6/8.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDScopeTableViewController.h"

@interface SDScopeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) UIView *lineView;
@property (nonatomic, assign) int userID;

@property(nonatomic,weak) SDScopeTableViewController *userInfoDelegate;

@end
