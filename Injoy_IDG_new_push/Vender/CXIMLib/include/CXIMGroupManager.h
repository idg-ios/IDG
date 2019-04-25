//
//  CXIMGroupManager.h
//  CXIMLib
//
//  Created by lancely on 7/18/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMMessage.h"
#import "CXIM-Singleton.h"
#import "CXGroupInfo.h"
@class CXIMService;

#pragma mark block

/**
 *  获取公司成员回调
 *
 *  @param success 是否成功
 *  @param users   用户 NSArray<CXUserInfo *>*
 *  @param errorMsg   错误信息
 */
typedef void(^getUsersCompletionBlock)(BOOL success,NSArray *users,NSString *errorMsg);

#pragma mark - 协议方法

@protocol CXIMGroupDelegate <NSObject>

@optional
/**
 *  解散群组
 *
 *  @param service     CXIMService对象
 *  @param groupId     群组id
 *  @param dismissTime 解散时间
 */
- (void)CXIMService:(CXIMService *)service didSelfDismissGroupWithGroupId:(NSString *)groupId dismissTime:(NSNumber *)dismissTime;

/**
 *  我邀请xxx加入群组
 *
 *  @param service   CXIMService对象
 *  @param members   成员列表(叮当享为NSArray<NSString *> *, ERP为NSArray<NSDictionary *> *)
 *  @param groupName 群组名称
 *  @param groupId   群组id
 */
- (void)CXIMService:(CXIMService *)service didSelfInviteMembers:(NSArray *)members intoGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time;

/**
 *  我退出群组
 *
 *  @param service CXIMService对象
 *  @param groupId 群组id
 */
- (void)CXIMService:(CXIMService *)service didSelfExitGroupWithGroupId:(NSString *)groupId time:(NSNumber *)time;

/**
 *  我被邀请加入群组
 *
 *  @param service   CXIMService对象
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param inviter   邀请人
 *  @param joinTime  加入时间
 */
- (void)CXIMService:(CXIMService *)service didAddedIntoGroup:(NSString *)groupName groupId:(NSString *)groupId inviter:(NSString *)inviter time:(NSNumber *)time;

/**
 *  成员被移出群组
 *
 *  @param service   CXIMService对象
 *  @param members   成员 NSArray<NSString *> *：成员id数组，NSArray<NSDictionary *> *：成员信息数组
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param owner     群主
 */
- (void)CXIMService:(CXIMService *)service didMembers:(NSArray<id> *)members removedFromGroup:(NSString *)groupName groupId:(NSString *)groupId byOwner:(NSString *)owner time:(NSNumber *)time;

/**
 *  我被移出群组/群解散
 *
 *  @param service   CXIMService对象
 *  @param groupName 群组名称
 *  @param groupId   群组id
 */
- (void)CXIMService:(CXIMService *)service didRemovedFromGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time;

/**
 *  群组名称被修改
 *
 *  @param service   CXIMService对象
 *  @param groupName 新的群组名称
 *  @param groupId   群组id
 *  @param owner     群主
 */
- (void)CXIMService:(CXIMService *)service didChangedGroupName:(NSString *)groupName groupId:(NSString *)groupId byOwner:(NSString *)owner time:(NSNumber *)time;



/**
 *  xxx邀请xxx加入群组
 *
 *  @param service   CXIMService对象
 *  @param inviter   邀请人
 *  @param members   成员列表(叮当享为NSArray<NSString *> *, ERP为NSArray<NSDictionary *> *)
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param joinTime  时间
 */
- (void)CXIMService:(CXIMService *)service didSomeone:(NSString *)inviter inviteMembers:(NSArray *)members intoGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time;

/**
 *  xxx退出群组
 *
 *  @param service   CXIMService对象
 *  @param members    成员
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param time      时间
 */
- (void)CXIMService:(CXIMService *)service didMembers:(NSArray *)members exitGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time;

@end

#pragma mark - 声明
@interface CXIMGroupManager : NSObject

singleton_interface(CXIMGroupManager)

#pragma mark 接口
/**
 *  创建群组
 *
 *  @param groupName       群组名称
 *  @param groupType       群组类型
 *  @param members         成员
 *  @param companyId       公司id
 *  @param completionBlock 完成回调
 */
- (void)createGroupWithName:(NSString *)groupName type:(CXGroupType)groupType members:(NSArray<NSString *> *)members companyId:(NSString *)companyId completion:(void(^)(CXGroupInfo *group, NSError *error))completionBlock;

/**
 *  ERP创建群组
 *
 *  @param groupName       群组名称
 *  @param groupType       群组类型
 *  @param owner           群主(需要userid,name,icon)
 *  @param members         成员(需要userid,name,icon)
 *  @param completionBlock 完成回调
 */
- (void)erpCreateGroupWithName:(NSString *)groupName type:(CXGroupType)groupType owner:(CXGroupMember *)owner members:(NSArray<CXGroupMember *> *)members completion:(void(^)(CXGroupInfo *group, NSError *error))completionBlock;

/**
 *  修改群组名称
 *
 *  @param newGroupName    新群组名称
 *  @param groupId         群组id
 *  @param completionBlock 回调
 */
- (void)modifyGroupNameWithNewName:(NSString *)newGroupName groupId:(NSString *)groupId completion:(void(^)(CXGroupInfo *group, NSError *error))completionBlock;

/**
 *  获取单个群组详情
 *
 *  @param groupId         群组id
 *  @param groupName       群组名称
 *  @param completionBlock 回调
 */
- (void)getGroupDetailInfoWithGroupId:(NSString *)groupId completion:(void(^)(CXGroupInfo *group, NSError *error))completionBlock;

/**
 *  群组添加成员
 *
 *  @param groupId         群组id
 *  @param members         成员 格式 ["Andy","wenjun",...]
 *  @param completionBlock 回调
 */
- (void)addGroupMembersWithGroupId:(NSString *)groupId members:(NSArray *)members completion:(void(^)(NSArray<NSString *> *newMembers, NSError *error))completionBlock;


/**
 ERP群组添加成员

 @param groupId         群组id
 @param members         成员（需要userId name icon）
 @param user            操作人（需要userId name icon）
 @param completionBlock 回调
 */
- (void)erpAddGroupMembersWithGroupId:(NSString *)groupId members:(NSArray<CXGroupMember *> *)members user:(CXGroupMember *)user completion:(void(^)(NSArray<CXGroupMember *> *newMembers, NSError *error))completionBlock;

/**
 *  群组删除成员
 *
 *  @param groupId         群组id
 *  @param members         要移除的成员
 *  @param completionBlock 回调
 */
- (void)removeGroupMembersWithGroupId:(NSString *)groupId members:(NSArray *)members completion:(void(^)(NSArray<NSString *> *removedMembers, NSError *error))completionBlock;


/**
 群组删除成员新接口

 @param groupId 群组id
 @param members 要移除的成员
 @param completionBlock 回调
 */
- (void)erpRemoveGroupMembersWithGroupId:(NSString *)groupId members:(NSArray *)members completion:(void (^)(NSArray<CXGroupMember *> *, NSError *))completionBlock;

/**
 *  获取一个用户参与的所有群组
 *
 *  @param account         用户名
 *  @param completionBlock 回调
 */
- (void)getJoinedGroups:(void(^)(NSArray<CXGroupInfo *> *groups, NSError *error))completionBlock;

/**
 *  解散群组
 *
 *  @param groupId         群组id
 *  @param completionBlock 回调
 */
- (void)dismissGroup:(NSString *)groupId completion:(void(^)(NSError *error))completionBlock;

/**
 *  退出群组
 *
 *  @param groupId         群组id
 *  @param completionBlock 回调
 */
- (void)exitGroup:(NSString *)groupId completion:(void(^)(NSError *error))completionBlock;

/**
 退出群组新接口

 @param groupId 群组id
 @param completionBlock 回调
 */
- (void)erpExitGroup:(NSString *)groupId completion:(void (^)(NSError *error))completionBlock;

#pragma mark 公开方法

/**
 *  屏蔽群
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
- (BOOL)shieldGroupForId:(NSString *)groupId;

/**
 *  解除屏蔽群
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
- (BOOL)unshieldGroupForId:(NSString *)groupId;

/**
 *  是否被屏蔽的群
 *
 *  @param groupId 群组id
 *
 *  @return 是否被屏蔽
 */
- (BOOL)isShieldedGroupForId:(NSString *)groupId;

/**
 *  获取屏蔽列表
 *
 *  @return 屏蔽列表(groupId数组)
 */
- (NSArray<NSString *> *)loadShieldList;

/**
 *  从数据库获取群组
 *
 *  @return 群组列表
 */
- (NSArray<CXGroupInfo *> *)loadGroupsFromDB;

/**
 *  根据groupId查找群组信息
 *
 *  @param groupId 群组id
 *
 *  @return 群组信息
 */
- (CXGroupInfo *)loadGroupForId:(NSString *)groupId;

/**
 *  添加代理
 *
 *  @param delegate 代理对象
 */
- (void)addDelegate:(id<CXIMGroupDelegate>)delegate;

/**
 *  移除代理
 *
 *  @param delegate 代理对象
 */
- (void)removeDelegate:(id<CXIMGroupDelegate>)delegate;

@end
