//
//  CXWorkCircleDetailRecordCell.h
//  InjoyERP
//
//  Created by wtz on 16/11/25.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXWorkCircleDetailRecordModel.h"

@interface CXWorkCircleDetailRecordCell : UITableViewCell

- (void)setCXWorkCircleDetailRecordModel:(CXWorkCircleDetailRecordModel *)model;

+ (CGFloat)getCellHeightWithCXWorkCircleDetailRecordModel:(CXWorkCircleDetailRecordModel *)model;

@end
