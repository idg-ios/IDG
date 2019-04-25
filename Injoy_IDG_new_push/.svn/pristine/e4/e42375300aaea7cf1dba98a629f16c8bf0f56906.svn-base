//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "SDBaseModel.h"

@interface CXVacationApplicationModel : SDBaseModel
/// 申请人
@property(copy, nonatomic) NSString *userName;
/// 开始时间
@property(copy, nonatomic) NSString *leaveStart;
/// 结束时间
@property(copy, nonatomic) NSString *leaveEnd;
/// 时长
@property(assign, nonatomic) CGFloat leaveDay;
/// 申请主键
@property(assign, nonatomic) long leaveId;
/// 请假类型
@property(strong, nonatomic) NSObject *leaveType;
/// 备注
@property(copy, nonatomic) NSString *leaveMemo;
/// 请假原因 {leaveType为22时必填}
@property(copy, nonatomic) NSString *leaveReason;
/// 当前审批人
@property(copy, nonatomic) NSString *currentApprove;
/// {1 审批中，2 通过 3-驳回}
@property(assign, nonatomic) int signed_objc;
/// {0-未审批  1-同意  2-不同意}
@property(assign, nonatomic) int isApprove;
/// 审批ID
@property(assign, nonatomic) long approveId;
/// 申请ID
@property(copy, nonatomic) NSString *applyId;
@property(copy, nonatomic) NSString *holidayType;
/// 请假人
@property(copy, nonatomic) NSString *name;
/// 开始时间上下午字段 {1=上午,2=下午}
@property(assign, nonatomic) int startType;
/// 开始时间上下午字段 {1=上午,2=下午}
@property(assign, nonatomic) int endType;
@property(assign, nonatomic) CGFloat minDay;
@property(assign, nonatomic) int availableDay;
@property(copy, nonatomic) NSString *applyDate;
@property(copy, nonatomic) NSString *leaveTypeCode;
@property(strong, nonatomic) CXVacationApplicationModel *leaveInfo;


@property (nonatomic, copy) NSString *approveReason;///<审批意见
@end
