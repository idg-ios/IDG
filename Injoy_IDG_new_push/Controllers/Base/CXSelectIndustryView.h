//
//  CXSelectIndustryView.h
//  InjoyERP
//
//  Created by haihualai on 2016/12/21.
//  Copyright © 2016年 Injoy. All rights reserved.
//  行业选择视图

#import <UIKit/UIKit.h>

@class CXSelectIndustryView;
@protocol CXSelectIndustryViewDelegate <NSObject>

@optional
-(void)industryView:(CXSelectIndustryView *)industryView clickItem:(NSInteger)clickItem;

@end

@interface CXSelectIndustryView : UIView

-(void)showInView:(UIView *)view;

@property (nonatomic, weak) id<CXSelectIndustryViewDelegate> delegate;

@property (nonatomic, weak)  UIView *bgView;

@end
