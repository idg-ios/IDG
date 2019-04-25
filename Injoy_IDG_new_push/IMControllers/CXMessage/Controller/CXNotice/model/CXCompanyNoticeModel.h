//
//  CXCompanyNoticeModel.h
//  InjoyYJ1
//
//  Created by cheng on 2017/7/26.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 公司公告模型 */
@interface CXCompanyNoticeModel : NSObject

/** 主键 */
@property (nonatomic, assign) NSInteger eid;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *remark;
/** 申请日期 */
@property (nonatomic, copy) NSString *applyDate;
/** 创建日期 */
@property (nonatomic, copy) NSString *createTime;

// 详情才有的属性

/** 编号 */
@property (nonatomic, copy) NSString *serNo;
/** 下一个审批人id */
@property (nonatomic, assign) NSInteger approvalUserId;
/** 审批状态 */
@property (nonatomic, assign) NSInteger approvalSta;
/** 审批流程id */
@property (nonatomic, assign) NSInteger approvalId;
/** comment */
@property (nonatomic, assign) NSInteger approvalNo;
/** 附件列表 */
@property (nonatomic, copy) NSArray<NSDictionary *> *annexList;
/** 创建人id */
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger createId;
/** 创建人 */
@property (nonatomic, copy) NSString *userName;
/** 部门名称 */
@property (nonatomic, copy) NSString *deptName;
/** 头像 */
@property (nonatomic, copy) NSString *icon;

@end
