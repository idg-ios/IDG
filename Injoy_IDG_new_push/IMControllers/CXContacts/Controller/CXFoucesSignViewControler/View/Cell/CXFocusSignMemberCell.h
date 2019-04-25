//
//  CXFocusSignMemberCell.h
//  SDMarketingManagement
//
//  Created by lancely on 4/22/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDCompanyUserModel;

@interface CXFocusSignMemberCell : UITableViewCell

@property (nonatomic, strong) SDCompanyUserModel *userModel;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL allowChecked;

@end
