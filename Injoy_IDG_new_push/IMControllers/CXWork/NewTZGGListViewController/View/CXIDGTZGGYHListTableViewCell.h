//
//  CXIDGTZGGYHListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/6/26.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIDGNewTZGGListModel.h"

@interface CXIDGTZGGYHListTableViewCell : UITableViewCell

- (void)setCXIDGNewTZGGListModel:(CXIDGNewTZGGListModel *)model;

+ (CGFloat)getCXIDGNewTZGGListTableViewCellHeightWithCXIDGNewTZGGListModel:(CXIDGNewTZGGListModel *)model;

@end
