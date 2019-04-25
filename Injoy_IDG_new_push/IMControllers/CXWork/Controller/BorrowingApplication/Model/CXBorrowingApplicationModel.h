//
// Created by ^ on 2017/10/26.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDBaseModel.h"

@interface CXBorrowingApplicationModel : SDBaseModel
/** < 借支事由 */
@property(copy, nonatomic) NSString *title;
/** < 借支说明 */
@property(copy, nonatomic) NSString *remark;
/** < 借支金额 */
@property(assign, nonatomic) double money;
/** < 借支金额(大写) */
@property(copy, nonatomic) NSString *bigMoney;
/** < 币种 */
@property(copy, nonatomic) NSString *currencyValue;
/** < 批审人列表 */
@property(copy, nonatomic) NSArray *approvalPerson;
/** < 附件 */
@property(copy, nonatomic) NSString *annex;
/** < 批审状态 */
@property(copy, nonatomic) NSString *statusName;
/** < 创建时间 */
@property(copy, nonatomic) NSString *createTime;
/** < 审批状态：-1=还没人批审，0=审批中；1=审批完成；*/
@property(assign, nonatomic) int approvalFinal;
/** < 申请人ID */
@property(assign, nonatomic) long approvalSta;
/** < 当前批审人ID */
@property(assign, nonatomic) long approvalUserId;
/** < 当前批审序号 */
@property(assign, nonatomic) int approvalNo;
@property(copy, nonatomic) NSString *icon;
@property(copy, nonatomic) NSString *serNo;
@end
