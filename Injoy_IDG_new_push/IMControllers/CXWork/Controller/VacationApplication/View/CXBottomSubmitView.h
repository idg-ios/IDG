//
// Created by ^ on 2017/11/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

extern const CGFloat CXBottomSubmitView_height;

@interface CXBottomSubmitView : UIView

@property (nonatomic, strong) NSString * submitTitle;

- (instancetype)initWithType:(CXFormType)formType;

-(instancetype)initWithFrame:(CGRect)frame andType:(CXFormType)formType;

@property(copy, nonatomic) void (^callBack)(NSString *title);
@end
