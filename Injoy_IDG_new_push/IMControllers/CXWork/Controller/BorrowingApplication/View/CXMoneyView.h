//
// Created by ^ on 2017/10/26.
// Copyright (c) 2017 Injoy. All rights reserved.
//


/// 金额大写
@interface CXMoneyView : UIView
@property(copy, nonatomic) void (^delegate)(NSString *);
@property(copy, nonatomic, readonly) NSString *bigMoneyVal;

- (void)setMoney:(NSString *)money;

@end