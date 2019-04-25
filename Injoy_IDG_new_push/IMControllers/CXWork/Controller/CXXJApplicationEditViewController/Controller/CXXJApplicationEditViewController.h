//
//  CXXJApplicationEditViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/4/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXVacationApplicationModel.h"

@interface CXXJApplicationEditViewController : SDRootViewController

@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;

@property(copy, nonatomic) void (^callBack)(void);

@end
