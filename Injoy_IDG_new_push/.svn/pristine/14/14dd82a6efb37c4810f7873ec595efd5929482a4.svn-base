//
//  CXLoaclDataManager.m
//  InjoyERP
//
//  Created by wtz on 2017/5/8.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXLoaclDataManager.h"

@implementation CXLoaclDataManager

singleton_implementation(CXLoaclDataManager)

- (NSMutableDictionary *)localGroupDataDic {
    if (!_localGroupDataDic) {
        _localGroupDataDic = @{}.mutableCopy;
    }
    return _localGroupDataDic;
}

- (NSMutableDictionary *)localFriendsDataDic {
    if (!_localFriendsDataDic) {
        _localFriendsDataDic = @{}.mutableCopy;
    }
    return _localFriendsDataDic;
}

- (NSMutableDictionary *)localSearchFriendsDataDic {
    if (!_localSearchFriendsDataDic) {
        _localSearchFriendsDataDic = @{}.mutableCopy;
    }
    return _localSearchFriendsDataDic;
}

- (NSMutableDictionary *)localStrangersDataDic {
    if (!_localStrangersDataDic) {
        _localStrangersDataDic = @{}.mutableCopy;
    }
    return _localStrangersDataDic;
}

- (NSMutableDictionary *)localContactsDataDic {
    if (!_localContactsDataDic) {
        _localContactsDataDic = @{}.mutableCopy;
    }
    return _localContactsDataDic;
}

- (NSMutableArray *)depKJArray {
    if (!_depKJArray) {
        _depKJArray = @[].mutableCopy;
    }
    return _depKJArray;
}

- (NSMutableArray *)allKJDepDataArray {
    if (!_allKJDepDataArray) {
        _allKJDepDataArray = @[].mutableCopy;
    }
    return _allKJDepDataArray;
}

- (NSMutableArray *)allKJDicContactsArray {
    if (!_allKJDicContactsArray) {
        _allKJDicContactsArray = @[].mutableCopy;
    }
    return _allKJDicContactsArray;
}

- (NSMutableArray *)depArray {
    if (!_depArray) {
        _depArray = @[].mutableCopy;
    }
    return _depArray;
}

- (NSMutableArray *)allDepDataArray {
    if (!_allDepDataArray) {
        _allDepDataArray = @[].mutableCopy;
    }
    return _allDepDataArray;
}

- (NSMutableArray *)allDicContactsArray {
    if (!_allDicContactsArray) {
        _allDicContactsArray = @[].mutableCopy;
    }
    return _allDicContactsArray;
}

- (void)saveLocalGroupDataWithGroups:(NSArray<CXGroupInfo *>*)groups
{
    [[CXLoaclDataManager sharedInstance].localGroupDataDic removeAllObjects];
    for(CXGroupInfo * groupInfo in groups){
        NSMutableDictionary * groupMemberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        BOOL isIn = NO;
        for(CXGroupMember * member in groupInfo.members){
            NSMutableDictionary * memberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [memberDic setObject:member.userId forKey:@"imAccount"];
            [memberDic setObject:member.name forKey:@"name"];
            [memberDic setObject:member.icon forKey:@"icon"];
            [groupMemberDic setObject:memberDic forKey:member.userId];
            if([member.userId isEqualToString:groupInfo.ownerDetail.userId]){
                isIn = YES;
            }
        }
        if(!isIn){
            NSMutableDictionary * memberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            if(groupInfo.ownerDetail){
                [memberDic setObject:groupInfo.ownerDetail.userId?groupInfo.ownerDetail.userId:VAL_HXACCOUNT forKey:@"imAccount"];
                [memberDic setObject:groupInfo.ownerDetail.name forKey:@"name"];
                [memberDic setObject:groupInfo.ownerDetail.icon forKey:@"icon"];
                [groupMemberDic setObject:memberDic forKey:groupInfo.ownerDetail.userId?groupInfo.ownerDetail.userId:VAL_HXACCOUNT];
            }else{
                [memberDic setObject:groupInfo.owner forKey:@"imAccount"];
                [memberDic setObject:groupInfo.owner forKey:@"name"];
                [memberDic setObject:@"" forKey:@"icon"];
                [groupMemberDic setObject:memberDic forKey:groupInfo.owner];
            }
        }
        [[CXLoaclDataManager sharedInstance].localGroupDataDic setObject:groupMemberDic forKey:groupInfo.groupId];
    }
}

- (SDCompanyUserModel *)getUserByGroupId:(NSString *)groupId AndIMAccount:(NSString *)imAccount{
    NSDictionary * userDic = [[[[CXLoaclDataManager sharedInstance].localGroupDataDic copy] objectForKey:groupId] objectForKey:imAccount];
    SDCompanyUserModel * userModel = [[SDCompanyUserModel alloc] init];
    if(!userDic){
        userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsDicWithIMAccount:imAccount];
        if(userModel.name){
            return userModel;
        }
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.imAccount = imAccount;
        userModel.hxAccount = imAccount;
        userModel.name = name;
        userModel.realName = name;
        userModel.icon = @"";
        return userModel;
    }
    userModel.imAccount = imAccount;
    userModel.hxAccount = imAccount;
    if([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0){
        userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsDicWithIMAccount:imAccount];
        if(userModel.name){
            return userModel;
        }
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }else{
        userModel.name = ([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0)?[userDic objectForKey:@"imAccount"]:[userDic objectForKey:@"name"];
        userModel.realName = ([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0)?[userDic objectForKey:@"imAccount"]:[userDic objectForKey:@"name"];
    }
    userModel.icon = [userDic objectForKey:@"icon"];
    if([userModel.name isEqualToString:@"null"]){
        userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsDicWithIMAccount:imAccount];
        if(userModel.name){
            return userModel;
        }
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }
    return userModel;
}

- (void)updateLocalDataWithGroupId:(NSString *)groupId AndGroup:(CXGroupInfo *)groupInfo{
    [[CXLoaclDataManager sharedInstance].localGroupDataDic removeObjectForKey:groupId];
    NSMutableDictionary * groupMemberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    BOOL isIn = NO;
    for(CXGroupMember * member in groupInfo.members){
        NSMutableDictionary * memberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [memberDic setObject:member.userId forKey:@"imAccount"];
        [memberDic setObject:member.name forKey:@"name"];
        [memberDic setObject:member.icon forKey:@"icon"];
        [groupMemberDic setObject:memberDic forKey:member.userId];
    }
    if(!isIn){
        NSMutableDictionary * memberDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        if(groupInfo.ownerDetail){
            [memberDic setObject:groupInfo.ownerDetail.userId forKey:@"imAccount"];
            [memberDic setObject:groupInfo.ownerDetail.name forKey:@"name"];
            [memberDic setObject:groupInfo.ownerDetail.icon forKey:@"icon"];
            [groupMemberDic setObject:memberDic forKey:groupInfo.ownerDetail.userId];
        }else{
            [memberDic setObject:groupInfo.owner forKey:@"imAccount"];
            [memberDic setObject:groupInfo.owner forKey:@"name"];
            [memberDic setObject:@"" forKey:@"icon"];
            [groupMemberDic setObject:memberDic forKey:groupInfo.owner];
        }
    }
    [[CXLoaclDataManager sharedInstance].localGroupDataDic setObject:groupMemberDic forKey:groupInfo.groupId];
}

- (void)saveLocalFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray{
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic removeAllObjects];
    for (NSDictionary* userDic in fiendsArray){
        [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:[userDic objectForKey:@"imAccount"]];
    }
}

- (void)saveSearchLocalFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray{
    [[CXLoaclDataManager sharedInstance].localSearchFriendsDataDic removeAllObjects];
    for (NSDictionary* userDic in fiendsArray){
        [[CXLoaclDataManager sharedInstance].localSearchFriendsDataDic setObject:userDic forKey:[userDic objectForKey:@"imAccount"]];
    }
}

- (void)saveLocalKefuFriendsDataWithFriends:(NSArray<NSDictionary *>*)fiendsArray{
    for (NSDictionary* userDic in fiendsArray){
        [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:[userDic objectForKey:@"imAccount"]];
    }
}

- (void)saveLocalStrangersDataWithFriends:(NSArray<NSDictionary *>*)strangersArray{
    [[CXLoaclDataManager sharedInstance].localStrangersDataDic removeAllObjects];
    for (NSDictionary* userDic in strangersArray){
        [[CXLoaclDataManager sharedInstance].localStrangersDataDic setObject:userDic forKey:[userDic objectForKey:@"imAccount"]];
    }
}

- (NSArray<SDCompanyUserModel *> *)getContacts
{
    NSMutableDictionary * destinationDict = [NSMutableDictionary dictionaryWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic copy]];
    [destinationDict addEntriesFromDictionary:[[CXLoaclDataManager sharedInstance].localStrangersDataDic copy]];
    [CXLoaclDataManager sharedInstance].localContactsDataDic = [NSMutableDictionary dictionaryWithDictionary:destinationDict];
    NSMutableArray * users = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary * userDic in [CXLoaclDataManager sharedInstance].localContactsDataDic.allValues) {
        SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
        user.name = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        user.realName = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        if([user.userType integerValue] != 3){
            [users addObject:user];
        }
    }
    return users;
}

- (NSArray<SDCompanyUserModel *> *)getAllKJDepContacts
{
    NSMutableArray * users = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary * userDic in [CXLoaclDataManager sharedInstance].allKJDicContactsArray) {
        SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
        user.name = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        user.realName = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        if([user.userType integerValue] != 3){
            [users addObject:user];
        }
    }
    return users;
}

- (NSArray<SDCompanyUserModel *> *)getAllDepContacts
{
    NSMutableArray * users = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary * userDic in [CXLoaclDataManager sharedInstance].allDicContactsArray) {
        SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
        user.name = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        user.realName = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        if([user.userType integerValue] != 3){
            [users addObject:user];
        }
    }
    return users;
}


- (NSArray<SDCompanyUserModel *> *)getKefuArray
{
    NSMutableDictionary * destinationDict = [NSMutableDictionary dictionaryWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic copy]];
    [destinationDict addEntriesFromDictionary:[[CXLoaclDataManager sharedInstance].localStrangersDataDic copy]];
    [CXLoaclDataManager sharedInstance].localContactsDataDic = [NSMutableDictionary dictionaryWithDictionary:destinationDict];
    NSMutableArray * users = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary * userDic in [CXLoaclDataManager sharedInstance].localContactsDataDic.allValues) {
        SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
        user.hxAccount = user.imAccount;
        user.name = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        user.realName = (user.name ==nil||[user.name length]<=0)?user.imAccount:user.name;
        if([user.userType integerValue] == 3){
            [users addObject:user];
        }
    }
    return users;
}

// 1
- (SDCompanyUserModel *)getUserFromLocalContactsDicWithIMAccount:(NSString *)imAccount{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localSearchFriendsDataDic objectForKey:imAccount];
    SDCompanyUserModel* userModel = [[SDCompanyUserModel alloc] init];
    if(!userDic){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.imAccount = imAccount;
        userModel.hxAccount = imAccount;
        userModel.name = name;
        userModel.realName = name;
        userModel.icon = @"";
        return userModel;
    }
    userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
    userModel.imAccount = imAccount;
    userModel.hxAccount = imAccount;
    if([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }else{
        userModel.name = [userDic objectForKey:@"name"];
        userModel.realName = [userDic objectForKey:@"name"];
    }
    userModel.icon = [userDic objectForKey:@"icon"];
    return userModel;
}

- (SDCompanyUserModel *)getUserFromLocalFriendsContactsDicWithUserId:(NSInteger)userId{
    for(NSDictionary * userDic in [CXLoaclDataManager sharedInstance].localSearchFriendsDataDic.allValues){
        if([[userDic objectForKey:@"eid"] integerValue] == userId){
            SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
            return user;
        }
    }
    return nil;
}

- (SDCompanyUserModel *)getUserFromLocalFriendsContactsDicWithAccount:(NSString *)account{
    for(NSDictionary * userDic in [CXLoaclDataManager sharedInstance].localSearchFriendsDataDic.allValues){
        if([[userDic objectForKey:@"account"] isEqualToString:account]){
            SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
            return user;
        }
    }
    return nil;
}

- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithUserIdArray:(NSArray<NSNumber *> *)userIdArray{
    NSMutableArray * users = @[].mutableCopy;
    for(NSNumber * userId in userIdArray){
        [users addObject:[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:[userId integerValue]]];
    }
    return users;
}

- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithUserModelArray:(NSArray<CXUserModel *> *)userModelArray
{
    NSMutableArray * users = @[].mutableCopy;
    for(CXUserModel * user in userModelArray){
        if([[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:user.eid]){
            [users addObject:[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:user.eid]];
        }
    }
    return users;
}

// 2
- (SDCompanyUserModel *)getUserFromLocalFriendsDicWithIMAccount:(NSString *)imAccount{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount];
    SDCompanyUserModel* userModel = [[SDCompanyUserModel alloc] init];
    if(!userDic){
        userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalContactsDicWithIMAccount:imAccount];
        return userModel;
    }
    userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
    userModel.imAccount = imAccount;
    userModel.hxAccount = imAccount;
    if([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }else{
        userModel.name = [userDic objectForKey:@"name"];
        userModel.realName = [userDic objectForKey:@"name"];
    }
    userModel.icon = [userDic objectForKey:@"icon"];
    if([userModel.icon isKindOfClass:[NSNull class]]){
        userModel.icon = @"";
    }
    return userModel;
}

// 3
- (SDCompanyUserModel *)getUserFromLocalStrangersDicWithIMAccount:(NSString *)imAccount{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localStrangersDataDic objectForKey:imAccount];
    SDCompanyUserModel* userModel = [[SDCompanyUserModel alloc] init];
    if(!userDic){
        userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalContactsDicWithIMAccount:imAccount];
        return userModel;
    }
    userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
    userModel.imAccount = imAccount;
    userModel.hxAccount = imAccount;
    if([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }else{
        userModel.name = [userDic objectForKey:@"name"];
        userModel.realName = [userDic objectForKey:@"name"];
    }
    userModel.icon = [userDic objectForKey:@"icon"];
    return userModel;
}

- (void)updateUserHeadWithIconUrl:(NSString*)headIconUrl AndIMAccount:(NSString *)imAccount
{
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] initWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount]];
    [userDic setObject:headIconUrl forKey:@"icon"];
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:imAccount];
    [[CXLoaclDataManager sharedInstance].localContactsDataDic setObject:userDic forKey:imAccount];
}

- (void)updateRealNameWithRealName:(NSString*)name AndIMAccount:(NSString *)imAccount
{
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] initWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount]];
    [userDic setObject:name forKey:@"name"];
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:imAccount];
    [[CXLoaclDataManager sharedInstance].localContactsDataDic setObject:userDic forKey:imAccount];
}

- (void)updateSexWithSex:(NSString *)sex AndIMAccount:(NSString *)imAccount
{
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] initWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount]];
    [userDic setObject:sex forKey:@"sex"];
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:imAccount];
    [[CXLoaclDataManager sharedInstance].localContactsDataDic setObject:userDic forKey:imAccount];
}

- (void)updateEamilWithEamil:(NSString*)eamil AndIMAccount:(NSString *)imAccount
{
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] initWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount]];
    [userDic setObject:eamil forKey:@"eamil"];
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:imAccount];
    [[CXLoaclDataManager sharedInstance].localContactsDataDic setObject:userDic forKey:imAccount];
}

- (void)updatePhoneWithPhone:(NSString*)telephone AndIMAccount:(NSString *)imAccount
{
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] initWithDictionary:[[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount]];
    [userDic setObject:telephone forKey:@"telephone"];
    [[CXLoaclDataManager sharedInstance].localFriendsDataDic setObject:userDic forKey:imAccount];
    [[CXLoaclDataManager sharedInstance].localContactsDataDic setObject:userDic forKey:imAccount];
}

- (BOOL)checkIsFriendWithUserModel:(SDCompanyUserModel *)userModel
{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:userModel.imAccount];
    if(!userDic){
        return NO;
    }
    return YES;
}

- (BOOL)checkIsFriendWithIMAccount:(NSString *)imAccount
{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localFriendsDataDic objectForKey:imAccount];
    if(!userDic){
        return NO;
    }
    return YES;
}

- (NSArray<SDCompanyUserModel *>*)getUsersFromLocalGroupsWithGroupId:(NSString *)groupId AndMemberIMAccounts:(NSArray *)imAccounts
{
    NSMutableArray * users = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSString * imAccount in imAccounts){
        SDCompanyUserModel * userModel = [self getUserByGroupId:groupId AndIMAccount:imAccount];
        [users addObject:userModel];
    }
    return users;
}

- (CXGroupMember *)getGroupUserFromLocalContactsDicWithIMAccount:(NSString *)imAccount{
    NSDictionary * userDic = [[CXLoaclDataManager sharedInstance].localContactsDataDic objectForKey:imAccount];
    SDCompanyUserModel* userModel = [[SDCompanyUserModel alloc] init];
    if(!userDic){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.imAccount = imAccount;
        userModel.hxAccount = imAccount;
        userModel.name = name;
        userModel.realName = name;
        userModel.icon = @"";
        CXGroupMember * member = [[CXGroupMember alloc] initWithUserId:userModel.imAccount name:userModel.name icon:userModel.icon joinTime:nil joinTimeMillisecond:nil];
        return member;
    }
    userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
    userModel.imAccount = imAccount;
    userModel.hxAccount = imAccount;
    if([userDic objectForKey:@"name"]==nil||[[userDic objectForKey:@"name"] length]<=0){
        NSInteger loc = [imAccount rangeOfString:@"_"].location;
        NSString * name = [NSString stringWithFormat:@"%@",imAccount];
        if (loc != NSNotFound) {
            name = [imAccount substringFromIndex:loc+1];
        }
        userModel.name = name;
        userModel.realName = name;
    }else{
        userModel.name = [userDic objectForKey:@"name"];
        userModel.realName = [userDic objectForKey:@"name"];
    }
    userModel.icon = [userDic objectForKey:@"icon"];
    CXGroupMember * member = [[CXGroupMember alloc] initWithUserId:userModel.imAccount name:userModel.name icon:userModel.icon joinTime:nil joinTimeMillisecond:nil];
    return member;
}

- (NSArray<CXGroupMember *> *)getGroupUsersFromLocalContactsDicWithIMAccountArray:(NSArray<NSString *>*)imAccountArray
{
    NSMutableArray * groupMembers = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSString * imAccount in imAccountArray){
        CXGroupMember * member = [[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:imAccount];
        [groupMembers addObject:member];
    }
    return groupMembers;
}

- (NSArray<SDCompanyUserModel *> *)getUserFromLocalFriendsContactsDicWithDeptId:(NSNumber *)deptId
{
    NSMutableArray * users = @[].mutableCopy;
    for(NSDictionary * userDic in [CXLoaclDataManager sharedInstance].localFriendsDataDic.allValues){
        if([[userDic objectForKey:@"deptId"] integerValue] == [deptId integerValue]){
            SDCompanyUserModel * user = [SDCompanyUserModel yy_modelWithDictionary:userDic];
            [users addObject:user];
        }
    }
    return users;
}

@end
