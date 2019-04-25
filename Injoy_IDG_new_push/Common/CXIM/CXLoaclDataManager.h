//
//  CXLoaclDataManager.h
//  InjoyERP
//
//  Created by wtz on 2017/5/8.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMService.h"
#import "SDCompanyUserModel.h"
#import "CXSingleton.h"
#import "CXUserModel.h"

@interface CXLoaclDataManager : NSObject

singleton_interface(CXLoaclDataManager)

//本地群组成员信息字典
@property (nonatomic, strong) NSMutableDictionary * localGroupDataDic;
//本地好友字典
@property (nonatomic, strong) NSMutableDictionary * localFriendsDataDic;
//本地陌生人字典
@property (nonatomic, strong) NSMutableDictionary * localStrangersDataDic;
//本地通讯录字典（好友和陌生人）
@property (nonatomic, strong) NSMutableDictionary * localContactsDataDic;
//查询用本地好友字典
@property (nonatomic, strong) NSMutableDictionary * localSearchFriendsDataDic;

//用来保存新版的通讯录-----------------------------------------------------
//用来保存所有的可见部门的数组
@property (nonatomic, strong) NSMutableArray * depKJArray;
//用来保存所有的可见数据格式是[{"IT":[model,model]},{"IT":[model,model]}]
@property (nonatomic, strong) NSMutableArray * allKJDepDataArray;
//用来保存所有可见的Contacts字典
@property (nonatomic, strong) NSMutableArray * allKJDicContactsArray;
//用来保存所有的部门的数组
@property (nonatomic, strong) NSMutableArray * depArray;
//用来保存所有的数据格式是[{"IT":[model,model]},{"IT":[model,model]}]
@property (nonatomic, strong) NSMutableArray * allDepDataArray;
//用来保存所有的Contacts字典
@property (nonatomic, strong) NSMutableArray * allDicContactsArray;

//获取所有的可见部门人员
- (NSArray<SDCompanyUserModel *> *)getAllKJDepContacts;
//获取所有的部门人员
- (NSArray<SDCompanyUserModel *> *)getAllDepContacts;
//用来保存新版的通讯录-----------------------------------------------------


//本地保存群组成员信息
- (void)saveLocalGroupDataWithGroups:(NSArray<CXGroupInfo *>*)groups;

//根据群组ID和imAccount获取群组成员信息
- (SDCompanyUserModel *)getUserByGroupId:(NSString *)groupId AndIMAccount:(NSString *)imAccount;

//我被邀请加入群，或者XX邀请XX加入群组，或者我邀请XX加入群组，刷新本地群组成员信息
- (void)updateLocalDataWithGroupId:(NSString *)groupId AndGroup:(CXGroupInfo *)groupInfo;

//本地保存好友信息
- (void)saveLocalFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray;

//本地保存搜索用好友信息
- (void)saveSearchLocalFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray;

//本地保存客服信息
- (void)saveLocalKefuFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray;

//本地保存陌生人信息
- (void)saveLocalStrangersDataWithFriends:(NSArray<NSDictionary *>*)strangersArray;

//获取通讯录字典
- (NSArray<SDCompanyUserModel *> *)getContacts;

//获取客服字典
- (NSArray<SDCompanyUserModel *> *)getKefuArray;

//通过通讯录字典获取用户信息
- (SDCompanyUserModel *)getUserFromLocalContactsDicWithIMAccount:(NSString *)imAccount;

//根据用户userId通过通讯录字典获取用户信息
- (SDCompanyUserModel *)getUserFromLocalFriendsContactsDicWithUserId:(NSInteger)userId;

//根据用户account通过通讯录字典获取用户信息
- (SDCompanyUserModel *)getUserFromLocalFriendsContactsDicWithAccount:(NSString *)account;

//根据用户(NSArray<NSNumber *> *)userIdArray通过通讯录字典获取用户信息数组
- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithUserIdArray:(NSArray<NSNumber *> *)userIdArray;

//根据用户(NSArray<CXUserModel *> *)userModelArray通过通讯录字典获取用户信息数组
- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithUserModelArray:(NSArray<CXUserModel *> *)userModelArray;

//通过好友字典获取用户信息（如果查不到就去查通讯录）
- (SDCompanyUserModel *)getUserFromLocalFriendsDicWithIMAccount:(NSString *)imAccount;

//通过陌生人字典获取用户信息（如果查不到就去查通讯录）
- (SDCompanyUserModel *)getUserFromLocalStrangersDicWithIMAccount:(NSString *)imAccount;

//根据用户imAccount修改本地保存的用户头像
- (void)updateUserHeadWithIconUrl:(NSString*)headIconUrl AndIMAccount:(NSString *)imAccount;

//根据用户imAccount修改本地保存的用户真名
- (void)updateRealNameWithRealName:(NSString*)name AndIMAccount:(NSString *)imAccount;

//根据用户imAccount修改本地保存的用户性别
- (void)updateSexWithSex:(NSString *)sex AndIMAccount:(NSString *)imAccount;

//根据用户imAccount修改本地保存的用户邮箱
- (void)updateEamilWithEamil:(NSString*)eamil AndIMAccount:(NSString *)imAccount;

//根据用户imAccount修改本地保存的用户电话
- (void)updatePhoneWithPhone:(NSString*)telephone AndIMAccount:(NSString *)imAccount;

//根据用户userModel检测是否是好友
- (BOOL)checkIsFriendWithUserModel:(SDCompanyUserModel *)userModel;

//根据用户imAccount检测是否是好友
- (BOOL)checkIsFriendWithIMAccount:(NSString *)imAccount;

//根据groupId和imAccounts获取群组中的某些成员
- (NSArray<SDCompanyUserModel *>*)getUsersFromLocalGroupsWithGroupId:(NSString *)groupId AndMemberIMAccounts:(NSArray *)imAccounts;

//通过imAccount获取群组用户信息
- (CXGroupMember *)getGroupUserFromLocalContactsDicWithIMAccount:(NSString *)imAccount;

//通过imAccountArray获取群组用户信息数组
- (NSArray<CXGroupMember *> *)getGroupUsersFromLocalContactsDicWithIMAccountArray:(NSArray<NSString *>*)imAccountArray;

//根据部门ID获取该部门所有的用户
- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithDeptId:(NSNumber *)deptId;

@end
