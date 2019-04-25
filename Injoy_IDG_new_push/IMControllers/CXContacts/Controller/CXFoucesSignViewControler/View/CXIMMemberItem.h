//
//  CXIMMemberItem.h
//  SDMarketingManagement
//
//  Created by lancely on 4/26/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kItemWidth 80.0
@class SDCompanyUserModel;

@interface CXIMMemberItem : UIButton

@property (nonatomic, strong) SDCompanyUserModel *userModel;

@end
