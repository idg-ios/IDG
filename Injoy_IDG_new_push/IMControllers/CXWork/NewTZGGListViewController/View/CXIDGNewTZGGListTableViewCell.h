//
//  CXIDGNewTZGGListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/6/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIDGNewTZGGListModel.h"

@interface CXIDGNewTZGGListTableViewCell : UITableViewCell

- (void)setCXIDGNewTZGGListModel:(CXIDGNewTZGGListModel *)model;

+ (CGFloat)getCXIDGNewTZGGListTableViewCellHeightWithCXIDGNewTZGGListModel:(CXIDGNewTZGGListModel *)model;

@end
