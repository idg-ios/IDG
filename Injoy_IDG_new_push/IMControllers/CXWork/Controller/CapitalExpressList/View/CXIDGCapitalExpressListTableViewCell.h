//
//  CXIDGCapitalExpressListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIDGCapitalExpressListModel.h"

@interface CXIDGCapitalExpressListTableViewCell : UITableViewCell

- (void)setCXIDGCapitalExpressListModel:(CXIDGCapitalExpressListModel *)model;

+ (CGFloat)getCXIDGCapitalExpressListTableViewCellHeightWithCXIDGCapitalExpressListModel:(CXIDGCapitalExpressListModel *)model;

@end
