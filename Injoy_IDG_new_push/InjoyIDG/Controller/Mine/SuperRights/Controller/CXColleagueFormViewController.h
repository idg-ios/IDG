//
//  CXColleagueFormViewController.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXColleagueFormViewController : SDRootViewController

/** 详情主键 */
@property (nonatomic, assign) NSInteger eid;
/** 表单类型 */
@property (nonatomic, assign) CXFormType formType;

/** 添加成功/修改成功的回调 */
@property (nonatomic, copy) void(^didPostSuccess)();

@end
