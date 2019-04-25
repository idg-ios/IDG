//
//  CXPotentialFollowListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIDGProjectManagementListTableViewCell.h"
#import "CXPotentialFollowListModel.h"
#import "CXPEPotentialProjectModel.h"

@interface CXPotentialFollowListTableViewCell : UITableViewCell

#define uinitPx (Screen_Width/375.0)
#define kFollowTextFontSize 16.0
#define kFollowTitleTextColor RGBACOLOR(106.0, 106.0, 106.0, 1.0)
#define kFollowContentTextColor [UIColor blackColor]
#define kLabelTopSpace (6.0 * uinitPx)

@property (strong, nonatomic) UIViewController *parentVC;

/** CXPEPotentialProjectModel */
@property (nonatomic, strong) CXPEPotentialProjectModel * PEPotentialProjectModel;
@property (nonatomic, strong) CXPotentialFollowListModel * PotentialFollowListModel;

- (void)setCXPotentialFollowListModel:(CXPotentialFollowListModel *)model;

+ (CGFloat)getCellHeightWithCXPotentialFollowListModel:(CXPotentialFollowListModel *)model;

@end
