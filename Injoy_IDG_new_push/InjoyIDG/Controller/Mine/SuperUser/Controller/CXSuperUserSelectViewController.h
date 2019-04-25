//
//  CXSuperUserSelectViewController.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXSuperUserModel.h"

@interface CXSuperUserSelectViewController : SDRootViewController

/** 选择后的回调 */
@property (nonatomic, copy) void(^didSelectedUser)(CXSuperUserModel *user);

@end
