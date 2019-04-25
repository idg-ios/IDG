//
//  CXIDGMessageListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CXIDGMessageListModel.h"
#import "CXIDGMessageListViewController.h"

@interface CXIDGMessageListTableViewCell : UITableViewCell

@property(nonatomic) MessageListType type;

- (void)setCXIDGMessageListModel:(CXIDGMessageListModel *)model;

+ (CGFloat)getCXIDGMessageListTableViewCellHeightWithCXIDGMessageListModel:(CXIDGMessageListModel *)model;

@end
