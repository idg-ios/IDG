//
//  CXZJYXLGSListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/5/22.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXZJYXLGSListModel.h"

@interface CXZJYXLGSListTableViewCell : UITableViewCell

#define kImageLeftSpace 10.0
#define kImageTopSpace 10.0
#define kLabelMiddleSpace 8.0
#define kLabelLeftImageSpace 8.0
#define kProjNameLabelFontSize 16.0
#define kProjNameLabelTextColor [UIColor blackColor]
#define kProjManagerNameLabelFontSize 14.0
#define kProjManagerNameLabelTextColor RGBACOLOR(229.0, 130.0, 143.0, 1.0)
#define kInduNameLabelFontSize 14.0
#define kInduNameLabelTextColor RGBACOLOR(133.0, 133.0, 133.0, 1.0)
#define kBusinessLabelFontSize 14.0
#define kBusinessLabelTextColor RGBACOLOR(133.0, 133.0, 133.0, 1.0)
#define kImageViewWidth (kProjNameLabelFontSize + kLabelMiddleSpace + kInduNameLabelFontSize + kLabelMiddleSpace + kBusinessLabelFontSize)

- (void)setCXZJYXLGSListModel:(CXZJYXLGSListModel *)model;

@end
