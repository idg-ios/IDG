//
//  SDDataBaseHelper.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/5.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "FMDatabase.h"
#import "SDCompanyUserModel.h"
#import "SDDepartmentModel.h"
#import "SDDepartmentRealModel.h"
#import "SDIMAddFriendApplicationModel.h"
#import "SDUserCusModel.h"
#import "CXWorkCircleCommentPushModel.h"
#import "CXYJNewColleaguesModel.h"
#import <Foundation/Foundation.h>

@interface SDDataBaseHelper : NSObject

+ (SDDataBaseHelper *)shareDB;

- (BOOL)insertCompanyUser:(SDCompanyUserModel *)model;

- (BOOL)insertDepartmentRel:(SDDepartmentRealModel *)model;

- (BOOL)insertDepartment:(SDDepartmentModel *)model;

/// 插入4个圈内部员工与外部员工关系
- (void)insertUserCus:(SDUserCusModel *)userCusModel;

/**
 *  删除所有表数据(除了菜单表,好友申请表)
 */
- (BOOL)deleteAllTable;

/**
 *  删除用户菜单
 */
- (void)deleteUserMenu;

- (NSMutableArray *)getDepartment:(int)deID;

/**
 *  获取所有部门
 */
- (NSMutableArray *)getAllDepartment;

/**
 *  获取用户菜单
 */
- (NSMutableArray *)getUserMenu;

/**
 *  根据userid获取用户模型
 */
- (SDCompanyUserModel *)getUser:(NSInteger)userID;

/**
 *  通过环信用户名获取用户实体
 */
- (SDCompanyUserModel *)getUserByhxAccount:(NSString *)hxAccount;

/**
 *  通过Account获取用户实体
 */
- (SDCompanyUserModel *)getUserByAccount:(NSString *)account;

/**
 *  根据用户名获取userid（不建议使用，因为可能有重名）
 */
- (NSString *)getUserID:(NSString *)userName;

/**
 *  获取用户角色
 *
 *  @param userID 用户ID
 *  @return 用户角色jobRole
 */
- (NSString *)getUserJobRole:(NSInteger)userID;

/**
 *  根据部门ID获取部门名称
 *  @param dpid 部门ID
 *  @return 部门名称
 */
- (NSString *)getUserDeptName:(NSInteger)dpid;

/**
 *  根据部门编码获取部门ID
 *
 *  @param dpCode 部门编码
 *
 *  @return 部门ID
 */
- (NSString *)getUserDeptId:(NSString *)dpCode;

/// 根据code字符串获取部门信息  code（code1,code2,code3,code4）
- (NSMutableArray *)getUserDeptNameByCode:(NSString *)dpCodeStr;

/// 根据dpid字符串获取部门名称  id（id1,id2,id3,id4,...）
- (NSMutableArray *)getUserDeptNameByIdStr:(NSString *)dpIdStr;

/// 根据code字符串获取员工信息  code（code1,code2,code3,code4）
- (NSMutableArray *)getUserDataByCodeStr:(NSString *)dpCodeStr;

/// 获取companyid
- (NSString *)getCompanyID:(NSString *)userName;

/// 获取userName
- (NSString *)getUserName:(NSInteger)userID;

/// 获取用户的部门
- (NSString *)getUserDept:(NSInteger)userID;

///获取用户的部门ID
- (NSString *)getUserDeptID:(NSInteger)userID;

- (NSString *)getUserDeptID2:(NSInteger)userID;

/// 通过userName查询头像icon的url
- (NSString *)getHeadIconUrl:(NSString *)userName;

/// 通过userID查询头像icon的url
- (NSString *)getHeadIconURL:(NSString *)userID;

///获取用户名的类方法
+ (NSString *)getUserNameStr:(NSInteger)userID;

///通过用户的真实名字，获取用户的account
- (NSString *)getUserIDByUserRealName:(NSString *)realName;

/// 获取用户的数据模型 通过用户id
- (SDCompanyUserModel *)getUserByUserID:(NSString *)userID;

///获取用户类型
- (NSString *)getUserTypeByUserID:(NSString *)userID;

/// 查找员工存在哪几个圈
- (NSArray *)getSpaceTypeArrFromUserID:(NSString *)userId;

- (NSArray *)getExternalSpaceTypeArrFromUserID:(NSString *)userId;

// 获取发送范围用户
- (NSMutableArray *)getSendRangeUserData;

//获取所有客户
- (NSMutableArray *)getExternalEmployeeAuthorityData;

//获取本公司的所有用户（不包扩客服）
- (NSMutableArray *)getUserData;

//获取客服用户
- (NSMutableArray *)getKeFuArr;

//获取本公司员工和客户（不包括客服）
- (NSMutableArray *)getIMUserData;

/**
 *  根据用户属性获取员工数据
 *  @param jobRole 用户属性（普通员工、管理层、秘书、领导层）
 *  当jobRole == chargeDept, 查找的是管理层和领导层的人员
 */
- (NSMutableArray *)getUserDataWithJobRole:(NSString *)jobRole;

/// 更新用户头像
- (BOOL)updateHeadIconUrl:(NSInteger)userID withHeadIconUrl:(NSString *)headIconUrl;

/// 更新真名
- (BOOL)updateUserRealName:(NSInteger)userID withRealName:(NSString *)realName;

/// 更新性别
- (BOOL)updateUserSex:(NSInteger)userID withSex:(NSString *)sex;

//更新用户邮箱
- (BOOL)updateUserEamil:(NSInteger)userID withEail:(NSString *)email;

/// 更新手机号码
- (BOOL)updateUserPhone:(NSInteger)userID withPhone:(NSString *)phone;

/// 通过userID查询职务归属
- (NSString *)getJobRole:(NSInteger)userID;

/**
 *  根据部门ID获取部门同事
 *
 *  @return 部门同事
 */
- (NSMutableArray *)getUserDataByDpid:(NSInteger)dpid;

/**
 *  根据条件搜索工作平台用户数据
 *
 *  @param condition 搜索内容
 *  @param type      搜索类别（姓名REAL_NAME，性别SEX，职务JOB，部门dpName）
 *
 *  @return 用户数据
 */
- (NSMutableArray *)getUserDataWithCondition:(NSString *)condition andSearchType:(NSString *)type;

/**
 *  根据条件搜索超信用户数据
 *
 *  @param condition 搜索内容
 *  @param type      搜索类别（姓名REAL_NAME，性别SEX，职务JOB，部门dpName）
 *
 *  @return 用户数据
 */
- (NSMutableArray *)getIMUserDataWithCondition:(NSString *)condition andSearchType:(NSString *)type;

/**
 插入好友申请
 */
- (BOOL)insertAddFriendApplication:(SDIMAddFriendApplicationModel *)model;

/**
 获取好友申请数组
 */
- (NSArray *)getAddFriendApplicationArray;

/**
 更新好友申请
 */
- (BOOL)updateNewFriendApplicationWith:(SDIMAddFriendApplicationModel *)model;

/**
 删除好友申请
 */
- (BOOL)deleteAddNewFriendApplicationWith:(SDIMAddFriendApplicationModel *)model;

/**
 根据userId更新好友申请为已添加
 */
- (BOOL)updateAddNewFriendApplicationWith:(NSString *)userId;

/**
 用户换了公司要删除公司ID不同的好友申请记录
 */
- (BOOL)deleteFromAddNewFriendApplicationWith:(NSString *)companyId;

/**
 插入新同事推送
 */
- (BOOL)insertYJNewColleaguesApplication:(CXYJNewColleaguesModel *)model;

/**
 获取新同事数组
 */
- (NSArray *)getYJNewColleaguesApplicationArray;

/**
 更新新同事
 */
- (BOOL)updateNewColleaguesApplicationWith:(CXYJNewColleaguesModel *)model;

/**
 删除新同事推送
 */
- (BOOL)deleteYJNewColleaguesApplicationWith:(CXYJNewColleaguesModel *)model;


/// 更新用户归属
- (BOOL)updateUserJobRoleWithUserId:(NSInteger)userID AndJobRole:(NSString *)jobRole;

//插入客服好友
- (BOOL)insertKefuFriend:(SDCompanyUserModel *)model;

//获取客服好友数组
- (NSArray *)getKefuFriendsListArray;

/// 获取用户实体通过userId
- (SDCompanyUserModel *)getUserFromKefuFriendsListByUserId:(NSString *)userId;

//根据姓名模糊搜索用户（不包括客服）（姓名）
- (NSMutableArray *)getUserDataWithSearchKey:(NSString *)key;

//插入工作圈评论
- (BOOL)insertWorkCircleCommentPushModel:(CXWorkCircleCommentPushModel *)model;

/// 获取评论列表数据
- (NSArray<CXWorkCircleCommentPushModel *> *)getWorkCircleCommentPushModelArray;

/// 获取最新的评论列表数据
- (NSArray<CXWorkCircleCommentPushModel *> *)getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:(NSNumber *)createTime;

/// 删除评论列表所有数据
- (void)deleteWorkCircleCommentListTable;

/// 删除特定评论
- (BOOL)deleteNewCommentNotificationWith:(CXWorkCircleCommentPushModel *)model;

@end
