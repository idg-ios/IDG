//
//  SDDataBaseHelper.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/5.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDatabaseQueue.h"
#import "SDDataBaseHelper.h"
#import <objc/runtime.h>

#define DB_VERSION @"1.0"

@interface SDDataBaseHelper ()
/// 用户表
@property(copy, nonatomic) NSString *userTable;
/// 部门表
@property(copy, nonatomic) NSString *departmentTable;
/// 用户部门中间表
@property(copy, nonatomic) NSString *userDeptTabel;
@property(strong, nonatomic) FMDatabaseQueue *databaseQueue;
@property(copy, nonatomic) NSString *dataBasePath;

/// 删除所有表
- (void)dropAllTable;

- (void)setUpDataBase;

/// 删除用户表数据
- (void)deleteUserTable;

/// 删除用户菜单数据
- (void)deleteUserMenu;

/// 删除部门表数据
- (void)deleteDeptTable;

/// 删除用户部门中间表数据
- (void)deleteUserDeptTable;

/// 删除用户关系表数据
- (void)deleteUserCusTable;
@end

@implementation SDDataBaseHelper

/// 数据库路径
- (NSString *)dataBasePath {
    // 获取路径
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"SDContactDB11_%@.db", [AppDelegate getUserHXAccount]]];
    return dbPath;
}

static FMDatabaseQueue *myQueue;

- (FMDatabaseQueue *)databaseQueue {
    myQueue = [[FMDatabaseQueue alloc] initWithPath:[self dataBasePath]];
    return myQueue;
}

static SDDataBaseHelper *helper;

+ (SDDataBaseHelper *)shareDB {
    helper = [[SDDataBaseHelper alloc] initExt];
    return helper;
}

- (instancetype)initExt {
    self = [super init];
    if (self) {
        [self setUpDataBase];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // [self setUpDataBase];
    }
    return self;
}

- (void)setUpDataBase {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *dbVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kDatabaseVersionKey];
        if (![dbVersion isEqualToString:DB_VERSION]) {
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USER"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_DEPARTMENT"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_DEPARTMENT_REAL"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USERMENU"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USER_CUS"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_NOTIFICATION"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_ADD_FRIEND_APPLICATION"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_CXYJNEW_COLLEAGUES_APPLICATION"];
            [db executeUpdate:@"DROP TABLE IF EXISTS SYS_KEFU_FRIENDLIST"];
        }
        _userTable = @"create table IF NOT EXISTS SYS_USER (id Integer PRIMARY KEY AUTOINCREMENT,USER_ID Integer,REAL_NAME varchar ,USERCODE varchar ,IDCARD varchar ,NICK_NAME varchar,TELEPHONE varchar,ACCOUNT varchar, EMAIL varchar,JOB varchar,jobRole varchar,SEX varchar,CREATE_TIME varchar,companyID Integer,hxAccount varchar,icon varchar,managerId Integer,user_status varchar,userType Integer,isKeFu Integer)";
        _departmentTable = @"create table IF NOT EXISTS SYS_DEPARTMENT (dpid Integer PRIMARY KEY,dpname varchar,dpCode varchar,dpparentid varchar,dpcategory varchar,dpcpid varchar)";
        _userDeptTabel = @"create table IF NOT EXISTS SYS_DEPARTMENT_REAL (id Integer PRIMARY KEY AUTOINCREMENT,dpid Integer,USER_ID Integer)";

        NSString *userMenu = @"create table IF NOT EXISTS SYS_USERMENU (id Integer PRIMARY KEY,name varchar,pmis integer,sortNum varchar,dpId integer)";

        // 4个圈内部员工与外部员工关系
        NSString *userCusSql = @"create table IF NOT EXISTS SYS_USER_CUS (id Integer PRIMARY KEY AUTOINCREMENT,userId Long,spaceType Integer,cusUserId Long)";

        // 推送消息
        NSString *notiSql = @"CREATE TABLE IF NOT EXISTS SYS_NOTIFICATION (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, content TEXT, read_flag INTEGER)";

        // 好友申请
        NSString *addFriendApplicationSql = @"CREATE TABLE IF NOT EXISTS SYS_ADD_FRIEND_APPLICATION (id INTEGER PRIMARY KEY AUTOINCREMENT, applicantMsgId TEXT, applicantTime TEXT, applicantId TEXT, applicantName TEXT, attached TEXT, status TEXT, operateTime TEXT, icon TEXT ,hxAccount TEXT ,companyId TEXT)";

        // 新同事
        NSString *newColleaguesApplicationSql = @"CREATE TABLE IF NOT EXISTS SYS_CXYJNEW_COLLEAGUES_APPLICATION (id INTEGER PRIMARY KEY AUTOINCREMENT, messageId TEXT, joinTime TEXT, deptId TEXT, deptName TEXT, name TEXT, job TEXT, icon TEXT, imAccount TEXT)";
        // 客服好友
        NSString *kefuListSql = @"CREATE TABLE IF NOT EXISTS SYS_KEFU_FRIENDLIST (id INTEGER PRIMARY KEY AUTOINCREMENT, icon TEXT, realName TEXT, sex TEXT, dpName TEXT, job TEXT, userType TEXT, email TEXT, telephone TEXT ,userId TEXT ,hxAccount TEXT ,account TEXT)";

        // 工作圈评论
        NSString *workCircleCommentListSql = @"CREATE TABLE IF NOT EXISTS SYS_WORK_CIRCLE_COMMENT_LIST (id INTEGER PRIMARY KEY AUTOINCREMENT, createTime INTEGER, icon TEXT, eid TEXT, remark TEXT, title TEXT, userName TEXT, btype TEXT,userId TEXT)";

        [db executeUpdate:_userTable];
        [db executeUpdate:_departmentTable];
        [db executeUpdate:_userDeptTabel];
        [db executeUpdate:userMenu];
        [db executeUpdate:userCusSql];
        [db executeUpdate:notiSql];
        [db executeUpdate:addFriendApplicationSql];
        [db executeUpdate:newColleaguesApplicationSql];
        [db executeUpdate:kefuListSql];
        [db executeUpdate:workCircleCommentListSql];
        [[NSUserDefaults standardUserDefaults] setObject:DB_VERSION forKey:kDatabaseVersionKey];
    }];
}

/// 删除所有表
- (void)dropAllTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USER"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_DEPARTMENT"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_DEPARTMENT_REAL"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USERMENU"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_USER_CUS"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_NOTIFICATION"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_ADD_FRIEND_APPLICATION"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_CXYJNEW_COLLEAGUES_APPLICATION"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_KEFU_FRIENDLIST"];
        [db executeUpdate:@"DROP TABLE IF EXISTS SYS_WORK_CIRCLE_COMMENT_LIST"];
    }];
}

#pragma mark--插入操作

/// 插入4个圈内部员工与外部员工关系
- (void)insertUserCus:(SDUserCusModel *)userCusModel; {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into SYS_USER_CUS (userId, spaceType,cusUserId) values(?,?,?)", userCusModel.userId, userCusModel.spaceType, userCusModel.cusUserId];
    }];
}

//插入用户表
- (BOOL)insertCompanyUser:(SDCompanyUserModel *)model {
    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"INSERT INTO SYS_USER (USER_ID, CREATE_TIME, REAL_NAME, USERCODE,JOB, jobRole,TELEPHONE, companyID, NICK_NAME, ACCOUNT, SEX, EMAIL, hxAccount, icon, managerId,user_status,userType,isKeFu) VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?, ?, ?, ?, ?, ?,?,?,?)", model.userId, model.createTime, model.name, model.userCode, model.job, model.jobRole, model.telephone, model.companyId, model.nickName, model.account, model.sex, model.email, model.imAccount, model.icon, model.managerId, model.status, model.userType, model.isKeFu];
    }];
    return ret;
}

- (BOOL)insertDepartmentRel:(SDDepartmentRealModel *)model {
    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"insert into SYS_DEPARTMENT_REAL (USER_ID, dpid) values(?, ?)", model.userId, model.dpId];
    }];
    return ret;
}

- (BOOL)insertDepartment:(SDDepartmentModel *)model {
    __block BOOL ret;

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        ret = [db executeUpdate:@"insert into SYS_DEPARTMENT (dpid, dpname, dpparentid, dpcategory, dpcpid) values (?, ?, ?, ?, ?)", model.departmentId, model.departmentName, model.dpparentid, model.dpcategory, model.companyId];
        ret = [db executeUpdate:@"insert into SYS_DEPARTMENT (dpid, dpname, dpCode,dpparentid, dpcategory, dpcpid) values (?, ?,?, ?, ?, ?)", model.dpId, model.dpName, model.dpCode, model.dpparentid, model.dpcategory, model.companyId];
    }];

    return ret;
}

//插入好友申请
- (BOOL)insertAddFriendApplication:(SDIMAddFriendApplicationModel *)model {
    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"insert into SYS_ADD_FRIEND_APPLICATION (applicantName, applicantId, applicantTime, applicantMsgId, attached, status, operateTime, icon, hxAccount, companyId) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.applicantName, model.applicantId, model.applicantTime, model.applicantMsgId, model.attached, model.status, model.operateTime, model.icon, model.hxAccount, model.companyId];
    }];
    return ret;
}

//插入新同事推送
- (BOOL)insertYJNewColleaguesApplication:(CXYJNewColleaguesModel *)model {

    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"insert into SYS_CXYJNEW_COLLEAGUES_APPLICATION (messageId, joinTime, deptId, deptName, name, job, icon, imAccount) values(?, ?, ?, ?, ?, ?, ?, ?)", model.messageId, model.joinTime, model.deptId, model.deptName, model.name, model.job, model.icon, model.imAccount];
    }];
    return ret;
}


//插入客服好友
- (BOOL)insertKefuFriend:(SDCompanyUserModel *)model {
    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"insert into SYS_KEFU_FRIENDLIST (icon, realName, sex, dpName, job, userType, email, telephone, userId, hxAccount, account) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.icon, model.realName, model.sex, model.dpName, model.job, [model.userType stringValue], model.email, model.telephone, [model.userId stringValue], model.hxAccount, model.account];
    }];
    return ret;
}

//插入工作圈评论
- (BOOL)insertWorkCircleCommentPushModel:(CXWorkCircleCommentPushModel *)model {
    __block BOOL ret;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"insert into SYS_WORK_CIRCLE_COMMENT_LIST (createTime, icon, eid, remark, title, userName, btype, userId) values(?, ?, ?, ?, ?, ?, ?, ?)", model.createTime, model.icon, model.eid, model.remark, model.title, model.userName, model.btype, model.userId];
    }];
    return ret;
}

#pragma mark--删除操作

/// 删除用户表数据
- (void)deleteUserTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_USER"];
    }];
}

/// 删除部门表数据
- (void)deleteDeptTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_DEPARTMENT"];
    }];
}

/// 删除用户部门中间表数据
- (void)deleteUserDeptTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_DEPARTMENT_REAL"];
    }];
}

- (void)deleteUserMenu {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_USERMENU"];
    }];
}

- (void)deleteUserCusTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_USER_CUS"];
    }];
}

- (void)deleteNotificationTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_NOTIFICATION"];
    }];
}

- (void)deleteAddFriendApplicationTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_ADD_FRIEND_APPLICATION"];
    }];
}

- (void)deleteYJNewColleaguesApplicationTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_CXYJNEW_COLLEAGUES_APPLICATION"];
    }];
}

- (void)deleteKefuFriendListTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_KEFU_FRIENDLIST"];
    }];
}

- (void)deleteWorkCircleCommentListTable {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM SYS_WORK_CIRCLE_COMMENT_LIST"];
    }];
}

/// 删除所有表数据
- (BOOL)deleteAllTable {
    [self deleteUserTable];
    [self deleteDeptTable];
    [self deleteUserDeptTable];
    //[self deleteUserMenu];
    [self deleteUserCusTable];
    [self deleteNotificationTable];
    return YES;
}

#pragma mark-- 获取外部员工权限数据

- (NSMutableArray *)getExternalEmployeeAuthorityData {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        //        FMResultSet* resultSet = [db executeQuery:@"SELECT USER_ID,REAL_NAME,NICK_NAME,TELEPHONE,ACCOUNT,EMAIL,JOB,SEX,CREATE_TIME,companyID,hxAccount,icon,managerId,user_status,userType,isKeFu from SYS_USER LEFT JOIN SYS_USER_CUS where SYS_USER.USER_ID = SYS_USER_CUS.userId and SYS_USER.userType = 3"];

        //        FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM SYS_USER where userType = 3"];
        //
        //        _userTable = @"create table IF NOT EXISTS SYS_USER (id Integer PRIMARY KEY AUTOINCREMENT,USER_ID Integer,REAL_NAME varchar ,USERCODE varchar ,IDCARD varchar ,NICK_NAME varchar,TELEPHONE varchar,ACCOUNT varchar, EMAIL varchar,JOB varchar,jobRole varchar,SEX varchar,CREATE_TIME varchar,companyID Integer,hxAccount varchar,icon varchar,managerId Integer,user_status varchar,userType Integer,isKeFu Integer)";

        NSString *sql = @"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER where userType = 2";
        FMResultSet *resultSet = [db executeQuery:sql];

        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];

    return userArr;
}

#pragma mark--获取全部操作

- (NSMutableArray *)getUserMenu {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql = @"SELECT * FROM SYS_USERMENU";

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSMutableDictionary *menuDict = [NSMutableDictionary dictionary];
            [menuDict setValue:[NSNumber numberWithInt:[resultSet intForColumn:@"id"]] forKey:@"ocId"];
            [menuDict setValue:[resultSet stringForColumn:@"name"] forKey:@"name"];
            [menuDict setValue:@([resultSet intForColumn:@"pmis"]) forKey:@"pmis"];
            [menuDict setValue:[resultSet stringForColumn:@"sortNum"] forKey:@"sortNum"];
            [menuDict setValue:[resultSet stringForColumn:@"dpId"] forKey:@"dpId"];
            [userArr addObject:menuDict];
        }
    }];
    return userArr;
}

/////获取本公司的所有用户（不包扩客服）
- (NSMutableArray *)getUserData {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        NSInteger userID = [[AppDelegate getUserID] integerValue];
        //        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE user_status = 1 AND userType = 1 AND USER_ID != %ld OR USER_ID IN (SELECT cusUserId FROM SYS_USER_CUS  WHERE userId = %ld) OR USER_ID IN (SELECT userId FROM SYS_USER_CUS  WHERE cusUserId = %ld) AND isKeFu = 0",userID,userID,userID];
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 AND USER_ID != %ld ", (long)userID];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID != %ld And userType != 3", (long) userID];

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            userModel.name = userModel.realName;
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

//获取本公司员工和客户（不包括客服）
- (NSMutableArray *)getIMUserData {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        NSInteger userID = [[AppDelegate getUserID] integerValue];
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE (userType = 1 OR userType = 3) AND USER_ID != %ld AND user_status = 1", (long)userID];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER where USER_ID != %ld AND userType != 3", (long) userID];

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

//根据条件获取本公司员工和客户（不包括客服）（姓名、性别、职务、部门）
- (NSMutableArray *)getUserDataWithCondition:(NSString *)condition andSearchType:(NSString *)type {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql;
        if ([type isEqualToString:@"REAL_NAME"]) {
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 And REAL_NAME like '%%%@%%'", condition];
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 And REAL_NAME like '%%%@%%'", condition];
        } else if ([type isEqualToString:@"SEX"]) {
            int sexValue = 1;
            if ([condition isEqualToString:@"女"]) {
                sexValue = 2;
            }
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 And SEX = %d", sexValue];
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 And SEX = %d", sexValue];
        } else if ([type isEqualToString:@"JOB"]) {
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 And JOB like '%%%@%%'", condition];
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 And JOB like '%%%@%%'", condition];
        } else if ([type isEqualToString:@"dpName"]) {
            //            sql = [NSString stringWithFormat:@"select a.* from SYS_USER a left join SYS_DEPARTMENT_REAL b  on a.USER_ID = b.USER_ID left join SYS_DEPARTMENT c on b.dpid = c.dpid Where a.userType = 1 And a.user_status = 1 And c.dpname like '%%%@%%'", condition];

            sql = [NSString stringWithFormat:@"select  distinct a.hxAccount, a.USER_ID, a.REAL_NAME, a.USERCODE, a.IDCARD, a.NICK_NAME, a.TELEPHONE, a.ACCOUNT, a.EMAIL, a.JOB, a.jobRole, a.SEX, a.CREATE_TIME, a.companyID, a.icon, a.managerId, a.user_status, a.userType, a.isKeFu from SYS_USER a left join SYS_DEPARTMENT_REAL b  on a.USER_ID = b.USER_ID left join SYS_DEPARTMENT c on b.dpid = c.dpid Where a.userType = 1 And a.user_status = 1 And c.dpname like '%%%@%%'", condition];
        }

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.jobRole = [resultSet stringForColumn:@"jobRole"];
            userModel.userCode = [resultSet stringForColumn:@"userCode"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

- (NSMutableArray *)getIMUserDataWithCondition:(NSString *)condition andSearchType:(NSString *)type {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        NSString *sql;
        if ([type isEqualToString:@"REAL_NAME"]) {
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE (userType = 1 OR userType = 3) And REAL_NAME like '%%%@%%'", condition];
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE (userType = 1 OR userType = 2) And REAL_NAME like '%%%@%%'", condition];
        } else if ([type isEqualToString:@"SEX"]) {
            int sexValue = 1;
            if ([condition isEqualToString:@"女"]) {
                sexValue = 2;
            }
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE (userType = 1 OR userType = 3) And SEX = %d", sexValue];
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE (userType = 1 OR userType = 2) And SEX = %d", sexValue];
        } else if ([type isEqualToString:@"JOB"]) {
            //            sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE (userType = 1 OR userType = 3) And JOB like '%%%@%%'", condition];
            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE (userType = 1 OR userType = 2) And JOB like '%%%@%%'", condition];
        } else if ([type isEqualToString:@"dpName"]) {
            //            sql = [NSString stringWithFormat:@"select a.* from SYS_USER a left join SYS_DEPARTMENT_REAL b  on a.USER_ID = b.USER_ID left join SYS_DEPARTMENT c on b.dpid = c.dpid Where a.userType = 1 And a.user_status = 1 And c.dpname like '%%%@%%'", condition];

            sql = [NSString stringWithFormat:@"select distinct a.hxAccount, a.USER_ID, a.REAL_NAME, a.USERCODE, a.IDCARD, a.NICK_NAME, a.TELEPHONE, a.ACCOUNT, a.EMAIL, a.JOB, a.jobRole, a.SEX, a.CREATE_TIME, a.companyID, a.icon, a.managerId, a.user_status, a.userType, a.isKeFu from SYS_USER a left join SYS_DEPARTMENT_REAL b  on a.USER_ID = b.USER_ID left join SYS_DEPARTMENT c on b.dpid = c.dpid Where a.userType = 1 And a.user_status = 1 And c.dpname like '%%%@%%'", condition];
        }

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

#pragma mark-- 获取发送范围用户

- (NSMutableArray *)getSendRangeUserData {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {

        //        NSString* sql = @"SELECT USER.*, DEPT.dpid AS dpid, DEPT.dpname AS dpname FROM SYS_USER AS USER JOIN SYS_DEPARTMENT_REAL AS RELATION ON USER.USER_ID = RELATION.USER_ID LEFT JOIN SYS_DEPARTMENT AS DEPT ON RELATION.dpid = DEPT.dpid WHERE USER.userType = 1 AND USER.user_status = 1";

        NSString *sql = @"SELECT distinct USER.hxAccount, USER.USER_ID, USER.REAL_NAME, USER.USERCODE, USER.IDCARD, USER.NICK_NAME, USER.TELEPHONE, USER.ACCOUNT, USER.EMAIL, USER.JOB, USER.jobRole, USER.SEX, USER.CREATE_TIME, USER.companyID, USER.icon, USER.managerId, USER.user_status, USER.userType, USER.isKeFu, DEPT.dpid AS dpid, DEPT.dpname AS dpname FROM SYS_USER AS USER JOIN SYS_DEPARTMENT_REAL AS RELATION ON USER.USER_ID = RELATION.USER_ID LEFT JOIN SYS_DEPARTMENT AS DEPT ON RELATION.dpid = DEPT.dpid WHERE USER.userType = 1 AND USER.user_status = 1";

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            userModel.dpid = [resultSet objectForColumnName:@"dpid"];
            userModel.dpName = [resultSet stringForColumn:@"dpname"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

- (NSMutableArray *)getKeFuArr {
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType == 2"];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType == 3"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

- (NSMutableArray *)getAllDepartment {
    __block NSMutableArray *deptrArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDDepartmentModel *model = [[SDDepartmentModel alloc] init];
            model.departmentId = [NSNumber numberWithInt:[resultSet intForColumnIndex:0]];
            model.departmentName = [resultSet stringForColumnIndex:1];
            model.dpparentid = [NSNumber numberWithInt:[resultSet intForColumnIndex:2]];
            model.dpcategory = [NSNumber numberWithInt:[resultSet intForColumnIndex:3]];
            model.companyId = [NSNumber numberWithInt:[resultSet intForColumnIndex:4]];
            [deptrArr addObject:model];
        }
    }];
    return deptrArr;
}

- (NSMutableArray *)getDepartment:(int)deID {
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID IN (SELECT USER_ID FROM SYS_DEPARTMENT_REAL WHERE dpid = %d) and userType == 1 and user_status = 1", deID];
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID IN (SELECT USER_ID FROM SYS_DEPARTMENT_REAL WHERE dpid = %d) and userType == 1", deID];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID IN (SELECT USER_ID FROM SYS_DEPARTMENT_REAL WHERE dpid = %d) and userType == 1", deID];

        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

#pragma mark--获取用户

- (SDCompanyUserModel *)getUser:(NSInteger)userID {
    SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %ld", (long)userID];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %ld", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            int userID = [[resultSet stringForColumn:@"USER_ID"] intValue];
            userModel.userId = [NSNumber numberWithInt:userID];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.name = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet objectForColumnName:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
        }
    }];
    return userModel;
}

- (SDCompanyUserModel *)getUserByAccount:(NSString *)account {
    SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE ACCOUNT = '%@'", account];

        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            int userID = [[resultSet stringForColumn:@"USER_ID"] intValue];
            userModel.userId = [NSNumber numberWithInt:userID];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            userModel.name = userModel.realName;
        }
    }];
    return userModel;
}

/// 获取用户实体通过环信用户名
- (SDCompanyUserModel *)getUserByhxAccount:(NSString *)hxAccount {
    SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE hxAccount = '%@'", hxAccount];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE hxAccount = '%@'", hxAccount];

        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            int userID = [[resultSet stringForColumn:@"USER_ID"] intValue];
            userModel.userId = [NSNumber numberWithInt:userID];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            userModel.name = userModel.realName;
        }

        if ([VAL_UserType integerValue] == 3) {
            NSString *kefusql = [NSString stringWithFormat:@"SELECT * FROM SYS_KEFU_FRIENDLIST WHERE hxAccount = '%@'", hxAccount];
            FMResultSet *kefuresultSet = [db executeQuery:kefusql];
            while (kefuresultSet.next) {
                int userID = [[kefuresultSet stringForColumn:@"userID"] intValue];
                userModel.userId = [NSNumber numberWithInt:userID];
                userModel.realName = [kefuresultSet stringForColumn:@"realName"];
                userModel.job = [kefuresultSet stringForColumn:@"job"];
                userModel.telephone = [kefuresultSet stringForColumn:@"telephone"];
                userModel.realName = [kefuresultSet stringForColumn:@"realName"];
                userModel.sex = [kefuresultSet objectForColumnName:@"sex"];
                userModel.email = [kefuresultSet stringForColumn:@"email"];
                userModel.hxAccount = [kefuresultSet stringForColumn:@"hxAccount"];
                userModel.icon = [kefuresultSet stringForColumn:@"icon"];
                userModel.userType = @([[kefuresultSet objectForColumnName:@"userType"] integerValue]);
                userModel.account = [kefuresultSet stringForColumn:@"account"];
                userModel.name = userModel.realName;
            }
        }

    }];
    return userModel;
}

/// 获取用户实体通过userId
- (SDCompanyUserModel *)getUserFromKefuFriendsListByUserId:(NSString *)userId {
    SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        if ([VAL_UserType integerValue] == 3) {
            NSString *kefusql = [NSString stringWithFormat:@"SELECT * FROM SYS_KEFU_FRIENDLIST WHERE userId = '%@'", userId];
            FMResultSet *kefuresultSet = [db executeQuery:kefusql];
            while (kefuresultSet.next) {
                int userID = [[kefuresultSet stringForColumn:@"userID"] intValue];
                userModel.userId = [NSNumber numberWithInt:userID];
                userModel.realName = [kefuresultSet stringForColumn:@"realName"];
                userModel.job = [kefuresultSet stringForColumn:@"job"];
                userModel.telephone = [kefuresultSet stringForColumn:@"telephone"];
                userModel.realName = [kefuresultSet stringForColumn:@"realName"];
                userModel.sex = [kefuresultSet objectForColumnName:@"sex"];
                userModel.email = [kefuresultSet stringForColumn:@"email"];
                userModel.hxAccount = [kefuresultSet stringForColumn:@"hxAccount"];
                userModel.icon = [kefuresultSet stringForColumn:@"icon"];
                userModel.userType = @([[kefuresultSet objectForColumnName:@"userType"] integerValue]);
                userModel.account = [kefuresultSet stringForColumn:@"account"];
            }
        }

    }];
    return userModel;
}

/// 获取评论列表数据
- (NSArray<CXWorkCircleCommentPushModel *> *)getWorkCircleCommentPushModelArray {
    NSMutableArray *workCircleCommentPushModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *kefusql = [NSString stringWithFormat:@"SELECT * FROM SYS_WORK_CIRCLE_COMMENT_LIST ORDER BY createTime DESC"];
        FMResultSet *kefuresultSet = [db executeQuery:kefusql];
        while (kefuresultSet.next) {
            CXWorkCircleCommentPushModel *model = [[CXWorkCircleCommentPushModel alloc] init];
            model.createTime = [kefuresultSet objectForColumnName:@"createTime"];
            model.icon = [kefuresultSet stringForColumn:@"icon"];
            model.eid = [kefuresultSet stringForColumn:@"eid"];
            model.remark = [kefuresultSet stringForColumn:@"remark"];
            model.title = [kefuresultSet stringForColumn:@"title"];
            model.userName = [kefuresultSet stringForColumn:@"userName"];
            model.btype = [kefuresultSet stringForColumn:@"btype"];
            model.userId = [kefuresultSet stringForColumn:@"userId"];
            [workCircleCommentPushModelArray addObject:model];
        }
    }];
    return workCircleCommentPushModelArray;
}

/// 获取最新的评论列表数据
- (NSArray<CXWorkCircleCommentPushModel *> *)getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:(NSNumber *)createTime {
    NSMutableArray *workCircleCommentPushModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *kefusql = [NSString stringWithFormat:@"SELECT * FROM SYS_WORK_CIRCLE_COMMENT_LIST WHERE createTime > %@ ORDER BY createTime DESC", createTime];
        FMResultSet *kefuresultSet = [db executeQuery:kefusql];
        while (kefuresultSet.next) {
            CXWorkCircleCommentPushModel *model = [[CXWorkCircleCommentPushModel alloc] init];
            model.createTime = [kefuresultSet objectForColumnName:@"createTime"];
            model.icon = [kefuresultSet stringForColumn:@"icon"];
            model.eid = [kefuresultSet stringForColumn:@"eid"];
            model.remark = [kefuresultSet stringForColumn:@"remark"];
            model.title = [kefuresultSet stringForColumn:@"title"];
            model.userName = [kefuresultSet stringForColumn:@"userName"];
            model.btype = [kefuresultSet stringForColumn:@"btype"];
            model.userId = [kefuresultSet stringForColumn:@"userId"];
            [workCircleCommentPushModelArray addObject:model];
        }
    }];
    return workCircleCommentPushModelArray;
}

#pragma mark--获取id

- (NSString *)getUserID:(NSString *)userName {
    __block NSString *userId = @"";

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE REAL_NAME= '%@'", userName];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE REAL_NAME= '%@'", userName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            userId = [resultSet stringForColumn:@"USER_ID"];
        }
    }];
    return userId;
}

- (NSString *)getUserJobRole:(NSInteger)userID {
    __block NSString *userJobRole = @"";

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %ld", (long)userID];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %ld", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            userJobRole = [resultSet stringForColumn:@"jobRole"];
        }
    }];
    return userJobRole;
}

#pragma mark--获取companyid

- (NSString *)getCompanyID:(NSString *)userName {
    __block NSString *companyID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE ACCOUNT = '%@'", userName];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE ACCOUNT = '%@'", userName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            companyID = [resultSet stringForColumn:@"companyID"];
        }
    }];
    return companyID;
}

// 获取userName
- (NSString *)getUserName:(NSInteger)userID {
    __block NSString *userName = @"";

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %ld", (long)userID];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %ld", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            userName = [resultSet stringForColumn:@"REAL_NAME"];
        }
    }];
    return userName;
}

//获取用户类型
- (NSString *)getUserTypeByUserID:(NSString *)userID {
    __block NSString *userType = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %ld", [userID integerValue]];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %ld", [userID integerValue]];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            userType = [resultSet stringForColumn:@"userType"];
        }
    }];
    return userType;
}

///类方法获取用户名
+ (NSString *)getUserNameStr:(NSInteger)userID {
    return [helper getUserName:userID];
}

/// 通过userName查询头像icon的url
- (NSString *)getHeadIconUrl:(NSString *)userName {
    __block NSString *headIconUrl = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE REAL_NAME = '%@'", userName];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE REAL_NAME = '%@'", userName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            headIconUrl = [resultSet stringForColumn:@"icon"];
        }
    }];
    return headIconUrl;
}

/// 通过userID查询头像icon的url
- (NSString *)getHeadIconURL:(NSString *)userID {
    __block NSString *headIconUrl = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %d", [userID intValue]];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %d", [userID intValue]];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            headIconUrl = [resultSet stringForColumn:@"icon"];
        }
    }];
    return headIconUrl;
}

/// 更新用户头像
- (BOOL)updateHeadIconUrl:(NSInteger)userID withHeadIconUrl:(NSString *)headIconUrl {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set icon = ? where USER_ID = ?", headIconUrl, @(userID)];
    }];
    return result;
}

/// 更新真名
- (BOOL)updateUserRealName:(NSInteger)userID withRealName:(NSString *)realName {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set REAL_NAME = ? where USER_ID = ?", realName, @(userID)];
    }];
    return result;
}

/// 更新性别
- (BOOL)updateUserSex:(NSInteger)userID withSex:(NSString *)sex {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set SEX = ? where USER_ID = ?", sex, @(userID)];
    }];
    return result;
}

//更新用户邮箱
- (BOOL)updateUserEamil:(NSInteger)userID withEail:(NSString *)email {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set EMAIL = ? where USER_ID = ?", email, @(userID)];
    }];
    return result;
}

/// 更新手机号码
- (BOOL)updateUserPhone:(NSInteger)userID withPhone:(NSString *)phone {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set TELEPHONE = ? where USER_ID = ?", phone, @(userID)];
    }];
    return result;
}

/// 更新用户归属
- (BOOL)updateUserJobRoleWithUserId:(NSInteger)userID AndJobRole:(NSString *)jobRole {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_USER set jobRole = ? where USER_ID = ?", jobRole, @(userID)];
    }];
    return result;
}

//更新好友申请
- (BOOL)updateNewFriendApplicationWith:(SDIMAddFriendApplicationModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_ADD_FRIEND_APPLICATION set applicantTime = ?,applicantMsgId = ?,attached = ?,status = ?,operateTime = ?,icon = ?,applicantName = ?,applicantId = ?,hxAccount = ?,companyId = ? where applicantId = ?", model.applicantTime, model.applicantMsgId, model.attached, model.status, model.operateTime, model.icon, model.applicantName, model.applicantId, model.hxAccount, model.companyId, model.applicantId];
    }];
    return result;
}

//更新新同事
- (BOOL)updateNewColleaguesApplicationWith:(CXYJNewColleaguesModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_CXYJNEW_COLLEAGUES_APPLICATION set messageId = ?,joinTime = ?,deptId = ?,deptName = ?,name = ?,job = ?,icon = ?,imAccount = ? where imAccount = ?", model.messageId, model.joinTime, model.deptId, model.deptName, model.name, model.job, model.icon, model.imAccount, model.imAccount];
    }];
    return result;
}


//更新客服好友列表
- (BOOL)updateKefuFriendListWith:(SDCompanyUserModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_KEFU_FRIENDLIST set icon = ?,realName = ?,sex = ?,dpName = ?,job = ?,userType = ?,email = ?,telephone = ?,userId = ?,hxAccount = ?,account = ? where userId = ?", model.icon, model.realName, model.sex, model.dpName, model.job, [model.userType stringValue], model.email, model.telephone, [model.userId stringValue], model.hxAccount, model.account, [model.userId stringValue]];
    }];
    return result;
}

/// 获取用户的部门
- (NSString *)getUserDept:(NSInteger)userID {
    __block NSString *companyName = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT WHERE dpid IN (SELECT dpid FROM SYS_DEPARTMENT_REAL WHERE USER_ID = %ld)", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            companyName = [resultSet stringForColumn:@"dpname"];
        }
    }];
    return companyName;
}

//获取用户的部门ID
- (NSString *)getUserDeptID:(NSInteger)userID {
    __block NSString *deptID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT WHERE dpid IN (SELECT dpid FROM SYS_DEPARTMENT_REAL WHERE USER_ID = %ld)", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            deptID = [resultSet stringForColumn:@"dpid"];
        }
    }];
    return deptID;
}

//获取用户的部门ID
- (NSString *)getUserDeptID2:(NSInteger)userID {
    __block NSString *deptID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT dpid FROM SYS_DEPARTMENT_REAL WHERE USER_ID = %ld", (long) userID];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            deptID = [resultSet stringForColumn:@"dpid"];
        }
    }];
    return deptID;
}

- (NSString *)getUserDeptName:(NSInteger)dpid {
    __block NSString *deptID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT dpname FROM SYS_DEPARTMENT WHERE dpid = %ld", (long) dpid];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            deptID = [resultSet stringForColumn:@"dpname"];
        }
    }];
    return deptID;
}

- (NSString *)getUserDeptId:(NSString *)dpCode {
    __block NSString *deptID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT WHERE dpCode = '%@'", dpCode];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            deptID = [resultSet stringForColumn:@"dpid"];
        }
    }];
    return deptID;
}

- (NSMutableArray *)getUserDeptNameByCode:(NSString *)dpCodeStr {
    __block NSMutableArray *deptrArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT WHERE dpCode IN (%@)", dpCodeStr];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDDepartmentModel *model = [[SDDepartmentModel alloc] init];
            model.departmentId = [NSNumber numberWithInt:[[resultSet stringForColumn:@"dpid"] intValue]];
            model.departmentName = [resultSet stringForColumn:@"dpName"];
            [deptrArr addObject:model];
        }
    }];
    return deptrArr;
}

- (NSMutableArray *)getUserDeptNameByIdStr:(NSString *)dpIdStr {
    __block NSMutableArray *deptrArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_DEPARTMENT WHERE dpid IN (%@)", dpIdStr];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDDepartmentModel *model = [[SDDepartmentModel alloc] init];
            model.departmentId = [NSNumber numberWithInt:[[resultSet stringForColumn:@"dpid"] intValue]];
            model.departmentName = [resultSet stringForColumn:@"dpName"];
            [deptrArr addObject:model];
        }
    }];
    return deptrArr;
}

// 获取同部门同事
- (NSMutableArray *)getUserDataByDpid:(NSInteger)dpid {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"select * from SYS_USER a left join SYS_DEPARTMENT_REAL b on a.USER_ID = b.USER_ID Where a.userType = 1 And a.user_status = 1 And b.dpid = %ld", (long)dpid];

        NSString *sql = [NSString stringWithFormat:@"select distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu from SYS_USER a left join SYS_DEPARTMENT_REAL b on a.USER_ID = b.USER_ID Where a.userType = 1 And a.user_status = 1 And b.dpid = %ld", (long) dpid];

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

/// 获取用的的account
- (NSString *)getUserIDByUserRealName:(NSString *)realName {
    __block NSString *userID = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE REAL_NAME = '%@'", realName];
        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE REAL_NAME = '%@'", realName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            userID = [resultSet stringForColumn:@"USER_ID"];
        }
    }];
    return userID;
}

/// 获取用户的数据模型 通过用户id
- (SDCompanyUserModel *)getUserByUserID:(NSString *)userID {
    SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = '%@'", userID];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = '%@'", userID];

        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            int userID = [[resultSet stringForColumn:@"USER_ID"] intValue];
            userModel.userId = [NSNumber numberWithInt:userID];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            userModel.realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];
            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet objectForColumnName:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
        }
    }];
    return userModel;
}

/// 查找员工存在哪几个圈
- (NSArray *)getSpaceTypeArrFromUserID:(NSString *)userId {
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER_CUS WHERE userId = %@", userId];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDUserCusModel *userCusModel = [[SDUserCusModel alloc] init];
            userCusModel.userId = [resultSet objectForColumnName:@"userId"];
            userCusModel.cusUserId = [resultSet objectForColumnName:@"cusUserId"];
            userCusModel.spaceType = [resultSet objectForColumnName:@"spaceType"];
            [resultArr addObject:userCusModel];
        }
    }];
    return resultArr;
}

#pragma mark-- 获取外部员工权限数据

- (NSArray *)getExternalSpaceTypeArrFromUserID:(NSString *)userId {
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER_CUS WHERE cusUserId = %@", userId];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDUserCusModel *userCusModel = [[SDUserCusModel alloc] init];
            userCusModel.userId = [resultSet objectForColumnName:@"userId"];
            userCusModel.cusUserId = [resultSet objectForColumnName:@"cusUserId"];
            userCusModel.spaceType = [resultSet objectForColumnName:@"spaceType"];
            [resultArr addObject:userCusModel];
        }
    }];
    return resultArr;
}

/// 通过userID查询职务归属
- (NSString *)getJobRole:(NSInteger)userID {
    __block NSString *jobRole = @"";
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE USER_ID = %ld", userID];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE USER_ID = %ld", userID];

        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            jobRole = [resultSet stringForColumn:@"jobRole"];
        }
    }];
    return jobRole;
}

- (NSMutableArray *)getUserDataWithJobRole:(NSString *)jobRole {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql;
        if (jobRole != nil) {
            if ([jobRole isEqualToString:@"management_layer"]) {
                //                sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 AND (jobRole = '%@' OR jobRole = '%@')", jobRole, @"secretary"];

                sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 AND (jobRole = '%@' OR jobRole = '%@')", jobRole, @"secretary"];
            } else if ([jobRole isEqualToString:@"chargeDept"]) {
                //                sql = @"SELECT * FROM SYS_USER WHERE userType = 1 AND (jobRole = 'secretary' OR jobRole = 'management_layer' OR jobRole = 'company_manager')";

                sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 AND (jobRole = 'secretary' OR jobRole = 'management_layer' OR jobRole = 'company_manager')"];
            } else {
                //                sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE userType = 1 AND jobRole = '%@'", jobRole];

                sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 AND jobRole = '%@'", jobRole];
            }
        } else {
            //            sql = @"SELECT * FROM SYS_USER WHERE userType = 1 AND user_status = 1";

            sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE userType = 1 AND user_status = 1"];
        }

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.jobRole = [resultSet stringForColumn:@"jobRole"];
            userModel.userCode = [resultSet stringForColumn:@"userCode"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

#pragma mark--获取加好友申请数组

- (NSArray *)getAddFriendApplicationArray {
    [self deleteFromAddNewFriendApplicationWith:[AppDelegate getCompanyID]];
    NSMutableArray *addFriendApplicationArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_ADD_FRIEND_APPLICATION"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDIMAddFriendApplicationModel *addFriendApplicationModel = [[SDIMAddFriendApplicationModel alloc] init];
            addFriendApplicationModel.applicantName = [resultSet stringForColumn:@"applicantName"];
            addFriendApplicationModel.applicantId = [resultSet stringForColumn:@"applicantId"];
            addFriendApplicationModel.applicantTime = [resultSet stringForColumn:@"applicantTime"];
            addFriendApplicationModel.applicantMsgId = [resultSet stringForColumn:@"applicantMsgId"];
            addFriendApplicationModel.attached = [resultSet stringForColumn:@"attached"];
            addFriendApplicationModel.status = [resultSet stringForColumn:@"status"];
            addFriendApplicationModel.operateTime = [resultSet stringForColumn:@"operateTime"];
            addFriendApplicationModel.icon = [resultSet stringForColumn:@"icon"];
            addFriendApplicationModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            addFriendApplicationModel.companyId = [resultSet stringForColumn:@"companyId"];
            [addFriendApplicationArray addObject:addFriendApplicationModel];
        }
    }];
    return addFriendApplicationArray;
}

#pragma mark--获取新同事数组

- (NSArray *)getYJNewColleaguesApplicationArray {
    NSMutableArray *newColleaguesApplicationArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_CXYJNEW_COLLEAGUES_APPLICATION"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            CXYJNewColleaguesModel *newColleaguesModel = [[CXYJNewColleaguesModel alloc] init];
            newColleaguesModel.messageId = [resultSet stringForColumn:@"messageId"];
            newColleaguesModel.joinTime = [resultSet stringForColumn:@"joinTime"];
            newColleaguesModel.deptId = [resultSet stringForColumn:@"deptId"];
            newColleaguesModel.deptName = [resultSet stringForColumn:@"deptName"];
            newColleaguesModel.name = [resultSet stringForColumn:@"name"];
            newColleaguesModel.job = [resultSet stringForColumn:@"job"];
            newColleaguesModel.icon = [resultSet stringForColumn:@"icon"];
            newColleaguesModel.icon = [resultSet stringForColumn:@"icon"];
            newColleaguesModel.imAccount = [resultSet stringForColumn:@"imAccount"];
            [newColleaguesApplicationArray addObject:newColleaguesModel];
        }
    }];
    return newColleaguesApplicationArray;
}

- (BOOL)updateAddNewFriendApplicationWith:(NSString *)userId {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"update SYS_ADD_FRIEND_APPLICATION set status = ? where hxAccount = ?", @"1", userId];
    }];
    return result;
}

- (BOOL)deleteFromAddNewFriendApplicationWith:(NSString *)companyId {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"delete from SYS_ADD_FRIEND_APPLICATION where companyId != ?", companyId];
    }];
    return result;
}

#pragma mark--获取客服好友列表数组

- (NSArray *)getKefuFriendsListArray {
    NSMutableArray *kefuFriendListArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_KEFU_FRIENDLIST"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            SDCompanyUserModel *model = [[SDCompanyUserModel alloc] init];
            model.icon = [resultSet stringForColumn:@"icon"];
            model.realName = [resultSet stringForColumn:@"realName"];
            model.name = [resultSet stringForColumn:@"realName"];
            model.sex = [resultSet stringForColumn:@"sex"];
            model.dpName = [resultSet stringForColumn:@"dpName"];
            model.job = [resultSet stringForColumn:@"job"];
            model.userType = @([[resultSet stringForColumn:@"userType"] integerValue]);
            model.email = [resultSet stringForColumn:@"email"];
            model.telephone = [resultSet stringForColumn:@"telephone"];
            model.userId = @([[resultSet stringForColumn:@"userId"] integerValue]);
            model.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            model.account = [resultSet stringForColumn:@"account"];
            [kefuFriendListArray addObject:model];
        }
    }];
    return kefuFriendListArray;
}

- (BOOL)deleteAddNewFriendApplicationWith:(SDIMAddFriendApplicationModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM SYS_ADD_FRIEND_APPLICATION WHERE applicantMsgId = ?", model.applicantMsgId];
    }];
    return result;
}

- (BOOL)deleteYJNewColleaguesApplicationWith:(CXYJNewColleaguesModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM SYS_CXYJNEW_COLLEAGUES_APPLICATION WHERE messageId = ?", model.messageId];
    }];
    return result;
}

- (BOOL)deleteKefuFriendWith:(SDCompanyUserModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM SYS_KEFU_FRIENDLIST WHERE userId = ?", [model.userId stringValue]];
    }];
    return result;
}

- (BOOL)deleteNewCommentNotificationWith:(CXWorkCircleCommentPushModel *)model {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM SYS_WORK_CIRCLE_COMMENT_LIST WHERE eid = ?", model.eid];
    }];
    return result;
}

#pragma mark-- 分管部门相应操作

- (NSMutableArray *)getUserDataByCodeStr:(NSString *)dpCodeStr {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER A LEFT JOIN SYS_DEPARTMENT_REAL B ON A.USER_ID = B.USER_ID LEFT JOIN SYS_DEPARTMENT C ON B.dpid = C.dpid WHERE A.userType = 1 AND C.dpCode IN (%@);",dpCodeStr];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER A LEFT JOIN SYS_DEPARTMENT_REAL B ON A.USER_ID = B.USER_ID LEFT JOIN SYS_DEPARTMENT C ON B.dpid = C.dpid WHERE A.userType = 1 AND C.dpCode IN (%@);", dpCodeStr];

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

//根据姓名模糊搜索用户（不包括客服）（姓名）
- (NSMutableArray *)getUserDataWithSearchKey:(NSString *)key {
    __block NSMutableArray *userArr = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        //        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM SYS_USER WHERE (userType = 1 OR userType = 3) And REAL_NAME like '%%%@%%'", key];

        NSString *sql = [NSString stringWithFormat:@"SELECT distinct hxAccount, USER_ID, REAL_NAME, USERCODE, IDCARD, NICK_NAME, TELEPHONE, ACCOUNT, EMAIL, JOB, jobRole, SEX, CREATE_TIME, companyID, icon, managerId, user_status, userType, isKeFu FROM SYS_USER WHERE (userType = 1 OR userType = 2) And REAL_NAME like '%%%@%%'", key];

        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SDCompanyUserModel *userModel = [[SDCompanyUserModel alloc] init];
            userModel.userId = [NSNumber numberWithInt:[resultSet intForColumn:@"USER_ID"]];
            userModel.createTime = [resultSet stringForColumn:@"CREATE_TIME"];
            NSString *realName = [resultSet stringForColumn:@"REAL_NAME"];
            userModel.realName = realName;
            if (realName.length == 0) {
                userModel.realName = @"";
            }
            userModel.job = [resultSet stringForColumn:@"JOB"];
            userModel.jobRole = [resultSet stringForColumn:@"jobRole"];
            userModel.userCode = [resultSet stringForColumn:@"userCode"];
            userModel.telephone = [resultSet stringForColumn:@"TELEPHONE"];
            userModel.companyId = [resultSet objectForColumnName:@"companyID"];
            userModel.nickName = [resultSet stringForColumn:@"NICK_NAME"];

            userModel.account = [resultSet stringForColumn:@"ACCOUNT"];
            userModel.sex = [resultSet stringForColumn:@"SEX"];
            userModel.email = [resultSet stringForColumn:@"EMAIL"];
            userModel.hxAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.imAccount = [resultSet stringForColumn:@"hxAccount"];
            userModel.icon = [resultSet stringForColumn:@"icon"];
            userModel.managerId = [resultSet objectForColumnName:@"managerId"];
            userModel.status = [resultSet objectForColumnName:@"user_status"];
            userModel.userType = [resultSet objectForColumnName:@"userType"];
            userModel.isKeFu = [resultSet objectForColumnName:@"isKeFu"];
            [userArr addObject:userModel];
        }
    }];
    return userArr;
}

@end
