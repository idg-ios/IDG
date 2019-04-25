//
//  SDScopeTableViewController.h
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/6/6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"

typedef enum {
    scopeId = 1, //有些抄送的数字是传id
    scopeUserName, //有些抄送是直接传送userName;
} scopeType;

@interface SDScopeTableViewController : SDRootViewController

@property (strong, nonatomic) NSArray* dataArr;
@property (nonatomic) scopeType type;

@end
