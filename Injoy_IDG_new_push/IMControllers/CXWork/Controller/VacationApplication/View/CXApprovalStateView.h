//
// Created by ^ on 2017/11/27.
// Copyright (c) 2017 Injoy. All rights reserved.
//

@interface CXApprovalStateView : UIView
- (instancetype)initWithTitle:(NSString *)title;

- (void)setSelected:(BOOL)bl;

@property(copy, nonatomic) void (^callBack)(NSString *);
@end