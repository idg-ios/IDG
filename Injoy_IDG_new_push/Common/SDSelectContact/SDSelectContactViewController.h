//
//  SDSelectContactViewController.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
#import "SDCompanyUserModel.h"


#pragma mark - 回调声明
/**
 *  选择联系人回调 (选择单人 保存联系人model)
 *
 *  @param selectContactArr 选择联系人回调 (选择单人 保存联系人model)
 */
typedef void(^selectContactCallBack)(SDCompanyUserModel *selectContactArr);
/**
 *  选择联系人回调 (可多选 数组中保存联系人model)
 *
 *  @param contactArray 选择联系人回调 (可多选 数组中保存联系人model)
 */
typedef void(^selectContactArray)(NSMutableArray *contactArray);


#pragma mark - 控制器声明
@interface SDSelectContactViewController : SDRootViewController

/**
 *  选择控制器标题
 */
@property (nonatomic, copy) NSString * titleName;
/**
 *  费用单发布人ID
 */
@property (nonatomic, copy)NSNumber *applyUserID;

/**
 *  已选人员数组
 *
 *  @return 已选人员数组
 */
- (NSMutableArray*)hasSelectPersonAry;

/**
 *  群组已选人员
 */
@property (nonatomic, strong) NSMutableArray* groupHasSelectPersonAry;

@property(nonatomic,strong)NSMutableArray *sharePerson;
/**
 *  接收已经选择了的用户模型回传
 */
@property (nonatomic, strong) SDCompanyUserModel *model;

/// 多选时已选联系人的model
@property (nonatomic, strong) NSMutableArray *allModelsArray;

/// 多选时已选联系人的数组 保存的是联系人的model
@property (nonatomic, strong) NSMutableArray *selectArray;

// 从@某人传过来的参数
@property (nonatomic, assign) BOOL isSomeone;
// 从前面传过来的联系人id
@property (nonatomic, assign) long  linkId;
// 用于判断通讯录里边要不要显示自己
@property (nonatomic, assign) BOOL isSelf;

/** 是否是跨部门审批 */
@property (nonatomic, assign, getter=isCrossDept) BOOL crossDept;


@property (nonatomic, assign, getter=isPurchaseCrossDept) BOOL purchaseCrossDept;

@property (nonatomic, assign) CXPurchaseType purchaseType;


/****************** 改造选择人员控制器 *************************/
/**
 *  使用条件(如果是审批人，和本部门人员，必填)
 */
@property (nonatomic, assign) UseConditionType useCondition;
/************************************************************/


/**
 *  是否是多选 (多选时需要右上的确定button)
 */
@property (nonatomic, assign) BOOL  isNeedSureBtn;
/**
 *  单选回调
 */
@property (nonatomic, copy) selectContactCallBack selectCallBackContactModel;
/**
 *  多选回调
 */
@property (nonatomic, copy) selectContactArray selectContactArray;

@end
