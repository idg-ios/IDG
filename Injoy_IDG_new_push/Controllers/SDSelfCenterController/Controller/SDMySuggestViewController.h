//
//  SDMySuggestViewController.h
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"

//数据发送成功的回调方法
typedef void (^postOADataSuccess)();

@interface SDMySuggestViewController : SDRootViewController

@property (nonatomic, copy) postOADataSuccess dataSuccess;

@end
