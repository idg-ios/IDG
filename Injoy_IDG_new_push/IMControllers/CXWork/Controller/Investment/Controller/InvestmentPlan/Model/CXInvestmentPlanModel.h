//
// Created by ^ on 2017/12/15.
// Copyright (c) 2017 Injoy. All rights reserved.
//

/// 投资方案
@interface CXInvestmentPlanModel : SDBaseModel
/// 投资金额
@property(copy, nonatomic) NSString *amt;
/// 通过
@property(copy, nonatomic) NSString *approvedFlag;
@property(copy, nonatomic) NSString *currency;
@property(copy, nonatomic) NSString *planDate;
/// 内容
@property(copy, nonatomic) NSString *planDesc;
@property(copy, nonatomic) NSString *planId;
@property(copy, nonatomic, readonly) NSString *approvedFlagVal;
@end