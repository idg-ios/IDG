//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXBorrowingApplicationModel.h"

/*
 * 借支申请
 */
@interface CXBorrowingApplicationEditViewController : SDRootViewController
@property(strong, nonatomic) CXBorrowingApplicationModel *borrowingApplicationModel;
@property(copy, nonatomic) void (^callBack)(void);
@end