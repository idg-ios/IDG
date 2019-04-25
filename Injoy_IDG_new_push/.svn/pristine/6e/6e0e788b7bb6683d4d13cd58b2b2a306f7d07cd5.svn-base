//
//  CXGroupSelectContactViewController.h
//  InjoyERP
//
//  Created by wtz on 16/11/26.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXGroupSelectContactViewController : SDRootViewController

typedef void (^selectContactUserCallBack)(NSArray* selectContactUserArr);

/// 标题
@property (copy, nonatomic) NSString* navTitle;
//过滤掉的员工数组
@property (nonatomic, strong) NSArray* filterUsersArray;
//选择成员之后的回调
@property (copy, nonatomic) selectContactUserCallBack selectContactUserCallBack;

@end
