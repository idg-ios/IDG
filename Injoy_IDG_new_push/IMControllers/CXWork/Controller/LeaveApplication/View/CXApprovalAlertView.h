//
// Created by ^ on 2017/10/30.
// Copyright (c) 2017 Injoy. All rights reserved.
//

/// 审批视图
@interface CXApprovalAlertView : UIView

@property(copy, nonatomic) void (^callBack)(void);

- (instancetype)initWithBid:(NSString *)bid btype:(BusinessType)btype;
- (instancetype)initWithBid:(NSString *)bid btype:(BusinessType)btype andTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message content:(NSString *)contrnt;

- (void)show;

- (void)dismiss;
@end
