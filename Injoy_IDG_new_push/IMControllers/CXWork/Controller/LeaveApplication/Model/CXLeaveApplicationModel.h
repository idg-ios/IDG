//
// Created by ^ on 2017/10/25.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDBaseModel.h"

@interface CXLeaveApplicationModel : SDBaseModel
/** < 请假事由 */
@property(copy, nonatomic) NSString *title;
/** < 请假说明 */
@property(copy, nonatomic) NSString *remark;
/** < 开始时间 */
@property(copy, nonatomic) NSString *startTime;
/** < 结束时间 */
@property(copy, nonatomic) NSString *endTime;
/** < 附件 */
@property(copy, nonatomic) NSString *annex;
@property(copy, nonatomic) NSString *icon;
@property(copy, nonatomic) NSString *serNo;
/** < 创建时间 */
@property(copy, nonatomic) NSString *createTime;
/** < 最终批审结果 {审批状态：-1=还没人批审，0=审批中；1=审批完成；} */
@property(assign, nonatomic) int approvalFinal;
/** < 审批状态 {-1=还没人批审，0=审批中；1=审批完成；} */
@property(assign, nonatomic) int approvalSta;
@property(assign, nonatomic) long approvalUserId;
@property(assign, nonatomic) int approvalNo;
/** < 批审人列表 */
@property(copy, nonatomic) NSArray *approvalPerson;
@property(copy, nonatomic) NSString *statusName;
@end