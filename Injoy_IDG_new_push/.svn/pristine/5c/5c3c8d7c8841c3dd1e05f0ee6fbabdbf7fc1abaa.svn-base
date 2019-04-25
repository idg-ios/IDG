//
//  CXERPBaseView.m
//  InjoyERP
//
//  Created by cheng on 17/1/4.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXERPBaseView.h"

@implementation CXERPBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginStateChange:(NSNotification *)noti {
    BOOL loginSuccess = [noti.object boolValue];
    if (!loginSuccess) {
        [self removeFromSuperview];
    }
}

@end
