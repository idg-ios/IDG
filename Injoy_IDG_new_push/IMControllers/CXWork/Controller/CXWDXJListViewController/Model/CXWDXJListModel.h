//
//  CXWDXJListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXWDXJListModel : NSObject

/** kid 销假申请ID Long */
@property(nonatomic,copy)NSNumber * kid;
/** kleaveId 请假ID Long */
@property(nonatomic,copy)NSNumber * kleaveId;
/** leaveType 请假类型 Sring */
@property(nonatomic,copy)NSString * leaveType;
/** leaveTypeCode 请假类型 int */
@property(nonatomic,copy)NSNumber * leaveTypeCode;
/** operateDate 申请时间 String */
@property(nonatomic,copy)NSString * operateDate;
/** remark 备注 String */
@property(nonatomic,copy)NSString * remark;
/** resumpitonDays 销假天数 double */
@property(nonatomic,copy)NSNumber * resumptionDays;
/** resumptionBegin 开始时间 String */
@property(nonatomic,copy)NSString * resumptionBegin;
/** resumptionEnd 结束时间 String */
@property(nonatomic,copy)NSString * resumptionEnd;
/** userName 申请用户 String */
@property(nonatomic,copy)NSString * userName;
/** signed_objc 状态 int 1=审批中  2=同意  3-未通过 */
@property(nonatomic,copy)NSNumber * signed_objc;
@property (nonatomic, copy) NSString *reason;///<审批意见
@end
