//
//  CXReimbursementApprovalListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXReimbursementApprovalListModel : NSObject

/** amount 金额 String */
@property(nonatomic,copy)NSString * amount;
/** company company String */
@property(nonatomic,copy)NSString * company;
/** create create String */
@property(nonatomic,copy)NSString * create;
/** createDate createDate String */
@property(nonatomic,copy)NSString * createDate;
/** currency currency String */
@property(nonatomic,copy)NSString * currency;
/** itemType 报销类型 String Reimbursement=报销单，Payment=付款单，Reim2Pay=报销付款单，Loan=借款单 根据此字段调用不用的详情页 */
@property(nonatomic,copy)NSString * itemType;
/** itemTypeName 报销类型中文名称 String */
@property(nonatomic,copy)NSString * itemTypeName;
/** subject subject String */
@property(nonatomic,copy)NSString * subject;
/** id 主键 String */
@property(nonatomic,copy)NSNumber * eid;
/** subObjectId 批审ID 批审的时候用到，需要传到详情页 */
@property(nonatomic,copy)NSNumber * subObjectId;
/** 审批状态 */
@property(nonatomic,copy)NSString * state;
/** stateInt 1=审批中，3=审批完成 */
@property(nonatomic,copy)NSNumber * stateInt;
/** objectId 详情ID */
@property(nonatomic,copy)NSString * objectId;


@end
