//
//  SDSelectDeptViewController.h
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/5.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"

typedef void (^selectDept)( NSNumber* deptId);

@interface SDSelectDeptViewController : SDRootViewController

/// 已选部门的部门ID
@property (nonatomic, strong) NSNumber* deptId;

@property (nonatomic, strong) NSMutableArray* indexSectionAry;

@property (nonatomic, copy) selectDept selectDept;

@end
