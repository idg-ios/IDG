//
//  CXFocusSignListCell.h
//  SDMarketingManagement
//
//  Created by wtz on 16/4/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXFocusSignModel.h"

@interface CXFocusSignListCell : UITableViewCell

@property (nonatomic, strong) CXFocusSignModel *model;

- (void)setFocusSignModel:(CXFocusSignModel *)model;

@end
