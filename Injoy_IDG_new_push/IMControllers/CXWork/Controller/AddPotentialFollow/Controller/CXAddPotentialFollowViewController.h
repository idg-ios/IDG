//
//  CXAddPotentialFollowViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXPotentialFollowListModel.h"
#import "CXPEPotentialProjectModel.h"

@interface CXAddPotentialFollowViewController : SDRootViewController

/** 提交成功后的回调 */
@property (nonatomic, copy) void(^onPostSuccess)(CXPotentialFollowListModel *);

/**
 初始化方法
 
 @param formType 表单类型
 @param model Model（详情和修改的时候传）
 @return instance
 */
- (instancetype)initWithFormType:(CXFormType)formType AndModel:(CXPotentialFollowListModel *)model AndCXPEPotentialProjectModel:(CXPEPotentialProjectModel *)PEPotentialProjectModel;



@end
