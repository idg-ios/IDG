//
//  CXSelectContactViewController.h
//  InjoyERP
//
//  Created by wtz on 16/11/21.
//  Copyright © 2016年 slovelys. All rights reserved.
//

//选择类型
typedef NS_ENUM(NSInteger, CXSelectContactType) {
    //事务报告
    CXTransactionCommitType            = 0,
    //借支申请
    CXBorrowingSubmissionType          = 1,
    //业绩报告
    CXPerformanceReportType            = 2,
    //请假申请
    CXLeaveToSubmitType                = 3,
    //工作日志
    CXWorkLogType                      = 4,
    //密语
    CXSecretLanguageType               = 5,
    //云镜
    CXYunJingType                     = 6
    
};

#import "SDRootViewController.h"

@interface CXSelectContactViewController : SDRootViewController

@property (nonatomic) CXSelectContactType type;

//附件数组
@property (nonatomic, strong) NSMutableArray * AllAnnexDataArray;

//参数字典
@property (nonatomic, strong) NSMutableDictionary * params;

@end
