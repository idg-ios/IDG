//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXVacationApplicationModel.h"

@interface CXVacationApplicationEditViewController : SDRootViewController
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@property(copy, nonatomic) void (^callBack)(void);
@end
