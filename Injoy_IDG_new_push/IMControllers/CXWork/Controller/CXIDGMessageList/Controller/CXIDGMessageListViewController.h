//
//  CXIDGMessageListViewController.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

//类型
typedef NS_ENUM(NSInteger, MessageListType) {
    RSType = 0, //人事
    WDLCType = 1//我的流程
};

#import "SDRootViewController.h"
#import "CXIDGProjectManagementListModel.h"

@interface CXIDGMessageListViewController : SDRootViewController

@property(nonatomic) MessageListType type;
@property(strong, nonatomic) CXIDGProjectManagementListModel *model;

@end
