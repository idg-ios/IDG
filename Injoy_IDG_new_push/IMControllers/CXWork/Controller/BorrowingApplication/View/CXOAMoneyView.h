//
//  CXOAMoneyView.h
//  SDMarketingManagement
//
//  Created by huashao on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//  金钱输入框

#import <UIKit/UIKit.h>
#import "CXFormLabel.h"
#import "CXEditLabel.h"


@class CXOAMoneyView;

@protocol CXOAMoneyViewDelegate <NSObject>

@optional
- (void)selectedMoneyView:(CXOAMoneyView *)moneyView;

@end

@interface CXOAMoneyView : UIView

//申请金额
@property(nonatomic, strong) UILabel *moneyTitle;

//金钱的横条
@property(nonatomic, strong) UIView *moneyView;

//单位(量)
@property(nonatomic, strong) UILabel *unitLabel;

//币种
@property(nonatomic, strong) CXEditLabel *currency;

//金钱
@property(nonatomic, assign) double monney;

//代理方法
@property(nonatomic, weak) id <CXOAMoneyViewDelegate> delegate;

- (void)setViewEditOrNot:(BOOL)bl;

@end
