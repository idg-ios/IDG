//
//  CXSuperRightsUserModel.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXSuperRightsUserModel : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 用户ID */
@property (nonatomic, assign) NSInteger eid;
/** 部门 */
@property (nonatomic, copy) NSString *deptName;
/** 职务 */
@property (nonatomic, copy) NSString *job;
/** IM账号 */
@property (nonatomic, copy) NSString *imAccount;
/** 账号状态 0=停用，1=启用 */
@property (nonatomic, assign) NSInteger status;
/** 超级用户状态 1=启用，0=停用 */
@property (nonatomic, assign) NSInteger superStatus;
/** 用户类型 1=公司管理员，2=普通用户，3=超级用户 */
@property (nonatomic, assign) NSInteger userType;
/** 是否是超级用户 1=是，0=否 */
@property (nonatomic, assign) NSInteger isSuper;
/** 头像 */
@property (nonatomic, copy) NSString *icon;

@end
