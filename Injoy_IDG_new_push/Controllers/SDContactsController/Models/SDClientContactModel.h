//
//  SDClientContactModel.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface SDClientContactModel : BaseModel<NSCoding>
/// 联系人ID
@property (nonatomic, assign) int  linkId;
/// 联系人头像
@property (nonatomic, copy) NSString *userPic;
/// 联系人名字
@property (nonatomic, copy) NSString *realName;
/// 联系人的职位
@property (nonatomic, copy) NSString *position;
/// 联系人的部门
@property (nonatomic, copy) NSString *dept;
/// 联系人的手机
@property (nonatomic, copy) NSString *cel;
/// 联系人的电话
@property (nonatomic, copy) NSString *telephone;
/// 公司名字
@property (nonatomic, copy) NSString *compName;
/// 公司ID
@property (nonatomic, assign) int compID;
/// 公司网址
@property (nonatomic, copy) NSString *webside;

@property (nonatomic, copy) NSString *fax;

@property (nonatomic, copy) NSString *email;
/// 联系人QQ
@property (nonatomic, copy) NSString *qq;
/// 微信
@property (nonatomic, copy) NSString *weChat;
/// 新浪微博
@property (nonatomic, copy) NSString *sinaBlog;
/// 腾讯微博
@property (nonatomic, copy) NSString *tengXun;
@property (nonatomic, assign) int relation;

@property (nonatomic, assign) int intimacy;

@property (nonatomic, assign) int sex;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *interest;

@property (nonatomic, assign) long userId;




@end
