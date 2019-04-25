//
//  CXIDGGroupAddUsersViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXIDGGroupAddUsersViewController : SDRootViewController

typedef void (^selectContactUserCallBack)(NSArray* selectContactUserArr);

/// 标题
@property (copy, nonatomic) NSString* navTitle;
//过滤掉的员工数组
@property (nonatomic, strong) NSMutableArray<SDCompanyUserModel *>* filterUsersArray;
//选择成员之后的回调
@property (copy, nonatomic) selectContactUserCallBack selectContactUserCallBack;

@end
