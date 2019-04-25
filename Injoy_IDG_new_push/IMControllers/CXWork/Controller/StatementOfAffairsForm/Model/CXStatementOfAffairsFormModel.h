//
//  CXStatementOfAffairsFormModel.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXApprovalPersonModel.h"
#import "CXCCUserModel.h"
#import "SDUploadFileModel.h"

@interface CXStatementOfAffairsFormModel : NSObject

/** ygId 申请人ID Long 是 */
@property (nonatomic, strong) NSNumber * ygId;
/** ygName 申请人姓名 String 是 */
@property (nonatomic, copy) NSString * ygName;
/** ygDeptId 申请部门ID Long 是 */
@property (nonatomic, strong) NSNumber * ygDeptId;
/** ygDeptName 申请部门 String 是 */
@property (nonatomic, copy) NSString * ygDeptName;
/** ygJob 申请人职务 String 是 */
@property (nonatomic, copy) NSString * ygJob;
/** title 报告标题 String 是 */
@property (nonatomic, copy) NSString * title;
/** remark 报告内容 String 是 */
@property (nonatomic, copy) NSString * remark;
/** approvalPerson 批审人列表 String 是
 [{"job":"系统管理员","name":"子敬","no":"1","userId":14}] */
@property (nonatomic, copy) NSString * approvalPerson;
/** cc 抄送人 List 否 [{"eid":1,"name":"小明"},{"eid":2,"name":"小红"}] */
@property (nonatomic, copy) NSString * cc;
/** annex 附件 List 否 [{ "createTime": "2017-09-23 10:36:23", "fileSize": 11473, "name": "2871ca32dcfc4759b98ec459ed8ef348.jpg", "path": "http://chun.blob.core.chinacloudapi.cn/public/2871ca32dcfc4759b98ec459ed8ef348.jpg", "showType": 1, "srcName": "u=2251976294,960678079&fm=27&gp=0.jpg", "type": "jpg", "userId": 368 }] */
@property (nonatomic, copy) NSString * annex;
/** eid 主键 long 否 */
@property (nonatomic, strong) NSNumber * eid;

/** approvalFinal 最终批审结果 Integer 审批状态：-1=还没人批审，0=审批中；1=审批完成； */
@property (nonatomic, strong) NSNumber * approvalFinal;
/** approvalSta 申请人ID long */
@property (nonatomic, strong) NSNumber * approvalSta;
/** approvalUserId 当前批审人ID Long */
@property (nonatomic, strong) NSNumber * approvalUserId;
/** approvalNo 当前批审序号 Integer */
@property (nonatomic, strong) NSNumber * approvalNo;
/** createId 创建人ID Long */
@property (nonatomic, strong) NSNumber * createId;
/** createTime 创建时间 String */
@property (nonatomic, copy) NSString * createTime;
/** serNo 编号 String */
@property (nonatomic, copy) NSString * serNo;
/** icon 用户头像 String */
@property (nonatomic, copy) NSString * icon;



/** approvalPersonArray */
@property (nonatomic, strong) NSArray<CXApprovalPersonModel *> * approvalPersonArray;
/** ccArray */
@property (nonatomic, strong) NSArray<CXCCUserModel *> * ccArray;
/** annexArray */
@property (nonatomic, strong) NSArray<NSDictionary *> * annexArray;

@end
