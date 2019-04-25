//
//  CXNoticeEditController.h
//  InjoyDDXWBG
//
//  Created by admin on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXNoticeEditController : SDRootViewController

/** 提交成功后的回调 */
@property (nonatomic, copy) void(^onPostSuccess)();
/** 表单类型 */
@property (nonatomic, assign) CXFormType theFormType;
/** 表单ID（详情和修改的时候传） */
@property (nonatomic, assign) NSInteger ID;


/**
 初始化方法
 
 @param formType 表单类型
 @param id 表单ID（详情和修改的时候传）
 @return instance
 */
- (instancetype)initWithFormType:(CXFormType)formType Id:(NSInteger)Id;

@end
