//
//  CXUserHeadView.h
//  SDMarketingManagement
//
//  Created by haihualai on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDCompanyUserModel.h"
#import <UIKit/UIKit.h>

@protocol CXUserHeadViewDelegate <NSObject>
@optional
- (void)touchButtonEvent:(SDCompanyUserModel*)userModel;
@end

@interface CXUserHeadView : UIButton
- (instancetype)initWithUserModel:(SDCompanyUserModel*)userModel;
@property (weak, nonatomic) id<CXUserHeadViewDelegate> userHeadViewDelegate;
@end
