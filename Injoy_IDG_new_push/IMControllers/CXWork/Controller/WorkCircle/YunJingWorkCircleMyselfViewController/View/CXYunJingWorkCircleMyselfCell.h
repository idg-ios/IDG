//
//  CXYunJingWorkCircleMyselfCell.h
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAllPeoplleWorkCircleModel.h"

@interface CXYunJingWorkCircleMyselfCell : UITableViewCell

- (void)setCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model;

+ (CGFloat)getCXMyselfWorkTableViewCellHeightWithCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model;

@end
