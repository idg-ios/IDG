//
//  CXYMDDFeeDetailModel.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  CXAnnexFileModel;

@interface CXYMPaidList: NSObject

@property (nonatomic, copy) NSString *amt;///<金额
@property (nonatomic, copy) NSString *isPaid;///<是否付款

@end

@interface CXYMFileList: NSObject

@property (nonatomic, copy) NSString *id;///<id
@property (nonatomic, copy) NSString *fileName;///<附件名称
@property (nonatomic, copy) NSString *type;///<类型
@property (nonatomic, copy) NSString *fileUrl;///<url

@end

@interface CXYMDDFeeDetailModel : NSObject

@property (nonatomic, copy) NSString *id;///<主键ID
@property (nonatomic, copy) NSString *apply;///<申请人
@property (nonatomic, copy) NSString *startDate;///<时间
@property (nonatomic, copy) NSString *state;///<批审状态,1=批审完成，0=批审中
@property (nonatomic, assign) NSInteger finishFlag;///<
@property (nonatomic, copy) NSString *type;///<
@property (nonatomic, copy) NSString *projName;///<项目名称
@property (nonatomic, copy) NSString *feeDesc;///<费用说明
@property (nonatomic, copy) NSString *recommendVendor;///<推荐服务商
@property (nonatomic, copy) NSString *recommendAmount;///<金额
@property (nonatomic, copy) NSString *recommendCurrency;///<币种
@property (nonatomic, copy) NSString *comparable1Vendor;///<可比服务商1
@property (nonatomic, copy) NSString *comparable1Amount;///<金额
@property (nonatomic, copy) NSString *comparable1Currency;///<币种
@property (nonatomic, copy) NSString *comparable2Vendor;///<可比服务商2
@property (nonatomic, copy) NSString *comparable2Amount;///<金额
@property (nonatomic, copy) NSString *comparable2Currency;///<币种
@property (nonatomic, copy) NSString *chooseReason;///<选择理由
@property (nonatomic, copy) NSString *overBudgetDesc;///<超预算说明
@property (nonatomic, copy) NSString *approve1;///<审批人1
@property (nonatomic, copy) NSString *approve2;///<审批人2
@property (nonatomic, copy) NSString *approve3;///<审批人3
@property (nonatomic, copy) NSString *approve4;///<审批人4
@property (nonatomic, copy) NSString *budgetApprove;///<预算审批人
@property (nonatomic, copy) NSString *payFund;///<付款基金
@property (nonatomic, copy) NSString *payEntityOversea;///<付款境外管理公司
@property (nonatomic, copy) NSString *payEntityMainland;///< 付款境内管理公司
@property (nonatomic, copy) NSString *payForEntity;///<代垫管理公司
@property (nonatomic, copy) NSString *payForLast;///<最终承担主体
@property (nonatomic, copy) NSString *receiveBank;///<收款公司银行
@property (nonatomic, copy) NSString *receiveBankNo;///<收款公司银行账号
@property (nonatomic, copy) NSString *receiveCompany;///<收款公司
@property (nonatomic, copy) NSString *payAmt;///< 支付金额
@property (nonatomic, strong) NSArray <CXYMPaidList *>*payList;
@property (nonatomic, strong) NSArray <CXAnnexFileModel *>*fileList;

@end


