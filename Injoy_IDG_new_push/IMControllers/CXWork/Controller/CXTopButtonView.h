//
// Created by ^ on 2017/10/24.
// Copyright (c) 2017 Injoy. All rights reserved.
//


@interface CXTopButtonView : UIView
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image style:(CXTopViewStyle)style;

@property(copy, nonatomic) void (^callBack)(void);
@end