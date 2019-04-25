//
//  AppDelegate.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/4/23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "CXLoaclDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    EMConnectionState _connectionState;
    UIViewController *_storedViewController;
}

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) UIViewController* viewController;
@property (copy, nonatomic) NSString* compantID;
/**
 *  获取资本快报用的timer
 */
@property (nonatomic, strong) NSTimer *locateTimer;
/// 获取底部工具栏
+ (RDVTabBarController*)get_RDVTabBarController;
/// 获取底部工具栏
- (RDVTabBarController*)getRDVTabBarController;

//获取userId
+ (NSString*)getUserID;
///类方法获取用户名
+ (NSString*)getUserName:(NSInteger)userID;
+ (NSString*)getUserHXAccount;
+ (NSString*)getCompanyID;
+ (NSString*)getCompanyAccount;
/**
 *  获取当前登陆用户的部门ID
 *
 *  @return 部门ID
 */
+ (NSString*)getUserDeptId;
/**
 *  获取当前登陆用户的部门名称
 *
 *  @return 部门名称
 */
+ (NSString *)getUserDeptName;
/**
 *  获取指定用户的部门名称
 *  @param userId userId
 *  @return 部门名称
 */
+ (NSString *)getUserDeptNameByUserId:(NSInteger)userId;
/**
 *  根据部门ID获取部门名称
 *
 *  @param dpid 部门ID
 *
 *  @return 部门名称
 */
+ (NSString*)getUserDeptName:(NSInteger)dpid;

/**
 *  获取当前用户的角色属性（普通员工、管理层、领导层）
 *
 *  @return 角色属性
 */
+ (NSString*)getJobRole;
/**
 *  获取用户类型
 *
 *  @return userType
 */
+(NSString *)getUserType;


/** 跳转到IM */
+ (void)jumpToIMModule;
/** 从IM返回 */
+ (void)jumpBackFromIMModule;

- (void)reloadRedCount;



@end
