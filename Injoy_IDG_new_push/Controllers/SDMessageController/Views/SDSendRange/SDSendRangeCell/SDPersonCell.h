//
//  SDPersonCell.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/13.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDPersonCell : UITableViewCell

@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *hxId;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *deptLabel;
@end
