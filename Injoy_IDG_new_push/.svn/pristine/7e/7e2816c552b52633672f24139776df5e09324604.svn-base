//
//  SDIMSelectColleaguesViewController.h
//  SDMarketingManagement
//
//  Created by wtz on 16/5/4.
//  Copyright © 2016年 slovelys. All rights reserved.
//

//选择类型
typedef NS_ENUM(NSInteger, SDIMSelectType) {
    SDIMSelectColleaguesType = 0,
    SDIMSelectDepartmentType = 1,
    SDIMSelectCustomerType = 2
};

typedef void (^selectContactUserCallBack)(NSArray* selectContactUserArr);

#import "SDRootViewController.h"

@interface SDIMSelectColleaguesViewController : SDRootViewController
/// 标题
@property (copy, nonatomic) NSString* navTitle;
//过滤掉的员工数组
@property (nonatomic, strong) NSArray* filterUsersArray;
//选择成员之后的回调
@property (copy, nonatomic) selectContactUserCallBack selectContactUserCallBack;

@end
