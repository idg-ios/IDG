//
//  QJSQEditViewController.h
//  InjoyIDG
//
//  Created by wtz on 2019/1/17.
//  Copyright © 2019年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXVacationApplicationModel.h"

@interface QJSQEditViewController : SDRootViewController

@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;

@property(copy, nonatomic) void (^callBack)(void);

@end
