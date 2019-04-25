//
//  SDIMPersonInfomationViewController.h
//  SDMarketingManagement
//
//  Created by wtz on 16/5/6.
//  Copyright © 2016年 slovelys. All rights reserved.
//

NSString * const PMSDidLoginOutNotificationName = @"com.chaoxiang.loginOutNotificationName";


//选择类型
typedef NS_ENUM(NSInteger, SDIMPersonInfomationType) {
    //自己的类型可以编辑
    SDIMMyselfType                     = 0,
    //他人的类型不可以编辑
    SDIMOtherPersonType                = 1
};
typedef void(^UpDateIconCallBack)(BOOL isUpdate);

#import "SDRootViewController.h"

@interface SDIMPersonInfomationViewController : SDRootViewController

@property (nonatomic, strong) NSString * imAccount;

@property (nonatomic, copy) UpDateIconCallBack upDateIconCallBack;

@property (nonatomic) BOOL canPopViewController;

@end
