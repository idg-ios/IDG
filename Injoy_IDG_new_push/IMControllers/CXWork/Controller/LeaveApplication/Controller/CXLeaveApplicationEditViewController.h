//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXLeaveApplicationModel.h"

/*
 * 请假申请
 */
@interface CXLeaveApplicationEditViewController : SDRootViewController
@property(copy, nonatomic) void (^callBack)(void);
@property(strong, nonatomic) CXLeaveApplicationModel *leaveApplicationModel;
@end