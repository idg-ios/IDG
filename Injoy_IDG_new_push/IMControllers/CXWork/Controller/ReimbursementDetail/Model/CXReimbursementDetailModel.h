//
//  CXReimbursementDetailModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXFeeModel.h"
#import "CXAnnexFileModel.h"

@interface CXReimbursementDetailModel : NSObject

/** accounting 会计 String */
@property(nonatomic,copy)NSString * accounting;
/** apply 申请人 String */
@property(nonatomic,copy)NSString * apply;
/** cashier 出纳 String */
@property(nonatomic,copy)NSString * cashier;
/** company 公司 String */
@property(nonatomic,copy)NSString * company;
@property(nonatomic,copy)NSString * payCompany;

/** feeList 费用项目列表 String */
@property(nonatomic,copy)NSString * feeList;
/** finishFlag 批审状态 int 1=批审完成，0=批审中 */
@property(nonatomic,strong)NSNumber * finishFlag;

/** specialName 专项费用名称 String */
@property(nonatomic,copy)NSString * specialName;
/** specialDesc 专项费用描述 String */
@property(nonatomic,copy)NSString * specialDesc;

/** firstApprove 一级批审 String */
@property(nonatomic,copy)NSString * firstApprove;
/** id 主键 String */
@property(nonatomic,copy)NSNumber * eid;
/** secondApprove 二级批审 String */
@property(nonatomic,copy)NSString * secondApprove;
/** startDate 日期 String */
@property(nonatomic,copy)NSString * startDate;
/** state int */
@property(nonatomic,copy)NSNumber * state;
/** total 发票费用合计 String */
@property(nonatomic,copy)NSString * total;
/** totalRmb RMB费用合计 String */
@property(nonatomic,copy)NSString * totalRmb;
/** feeArray */
@property (nonatomic, strong) NSArray<CXFeeModel *> * feeArray;

/** receiveAccount 收款单位账号 String */
@property(nonatomic,copy)NSString * receiveAccount;
/** receiveBank 收款单位开户行 String */
@property(nonatomic,copy)NSString * receiveBank;
/** receiveCompany 收款单位名称 String */
@property(nonatomic,copy)NSString * receiveCompany;

/** finApprove 财务审批 String */
@property(nonatomic,copy)NSString * finApprove;
/** loanAmt 借款金额（小写）String */
@property(nonatomic,copy)NSString * loanAmt;
@property(nonatomic,copy)NSString * payAmt;

/** reason 借款事由 String */
@property(nonatomic,copy)NSString * reason;
/** remark 备注 String */
@property(nonatomic,copy)NSString * remark;
/** fileList 附件列表 array */
@property(nonatomic,copy)NSArray<CXAnnexFileModel *> * fileList;

@end
