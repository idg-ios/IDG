//
// Created by ^ on 2017/11/27.
// Copyright (c) 2017 Injoy. All rights reserved.
//

const CGFloat CXTopSwitchView_height = 50.f;

#import "CXTopSwitchView.h"
#import "CXApprovalStateView.h"
#import "UIView+YYAdd.h"

@interface CXTopSwitchView ()
@end

@implementation CXTopSwitchView

- (void)setUpSubviews {
    CGFloat width = ceilf(CGRectGetWidth(self.frame) / 3.f);
    CGFloat height = CGRectGetHeight(self.frame);

    NSArray *titleArr = @[@"审批中", @"同意", @"驳回"];

    @weakify(self);
    CGFloat x = 0.f;
    for (NSString *title in titleArr) {
        CXApprovalStateView *view = [[CXApprovalStateView alloc] initWithTitle:title];
        __weak CXApprovalStateView *weakView = view;
        view.callBack = ^(NSString *titleVal) {
            @strongify(self);
            for (CXApprovalStateView *stateView in self.subviews) {
                [stateView setSelected:NO];
            }
            [weakView setSelected:YES];
            if (self.callBack) {
                self.callBack(titleVal);
            }
        };
        [self addSubview:view];
        view.frame = (CGRect) {x, 0.f, width, height};
        x = self.subviews.lastObject.right;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXTopSwitchView_height}]) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setUpSubviews];
        [(CXApprovalStateView *) self.subviews.firstObject setSelected:YES];
    }
    return self;
}
- (instancetype)initWithFrames:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setUpSubviews];
        [(CXApprovalStateView *) self.subviews.firstObject setSelected:YES];
    }
    return self;
}
@end
