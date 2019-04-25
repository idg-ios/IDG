//
//  SDSocketCacheManager.h
//  SDMarketingManagement
//
//  Created by Rao on 15/12/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* holiday_socket; //请假
extern NSString* purchase_socket; //费用
extern NSString* travel_socket; //差旅
extern NSString* workrepot_socket; //事务
extern NSString* workrepotspecial_socket; //特殊事务
extern NSString* order_socket; //工作任务
extern NSString* atreply_socket; //@我的回复
extern NSString* atwork_socket; //@我的工作
extern NSString* reply_socket; //收到的回复
extern NSString* approval_socket;//审批
extern NSString* procurement_socket; //采购申请
extern NSString* market_socket; //市场申请
extern NSString* sale_socket; //销售申请
extern NSString* visit_socket; //拜访申请
extern NSString* store_socket; //仓库业务
extern NSString* storebis_socket; //仓库查询
extern NSString* notice_socket; //消息通知
extern NSString* contact_socket; //联系人
extern NSString* staticdata_socket; //静态数据
extern NSString* sysnotice_socket; //公告
extern NSString* workspace_socket; //工作圈
extern NSString* report_socket; //工作报告
extern NSString* performance_socket; //业绩报告
extern NSString* voicemeeting_socket; //语音会议
extern NSString* marketsurvey_socket; //市场调查
extern NSString* marketing_socket; //市场活动
extern NSString* saleproduct_socket; //销售订单
extern NSString* salecontract_socket; //销售合同
extern NSString* saleclue_socket; //销售线索
extern NSString* salechance_socket; //销售机会

/*
//extern int holiday_socketNum; //请假
//extern int purchase_socketNum; //费用
//extern int travel_socketNum; //差旅
//extern int workrepot_socketNum; //事务
//extern int workrepotspecial_socketNum; //特殊事务
//extern int order_socketNum; //工作任务
//extern int atreply_socketNum; //@我的回复
//extern int atwork_socketNum; //@我的工作
//extern int reply_socketNum; //收到的回复
//extern int approval_socketNum;//审批
//extern int procurement_socketNum; //采购申请
//extern int market_socketNum; //市场申请
//extern int sale_socketNum; //销售申请
//extern int visit_socketNum; //拜访申请
//extern int store_socketNum; //仓库业务
//extern int storebis_socketNum; //仓库查询
//extern int notice_socketNum; //消息通知
//extern int contact_socketNum; //联系人
//extern int staticdata_socketNum; //静态数据
//extern int sysnotice_socketNum; //公告
//extern int workspace_socketNum; //工作圈
//extern int report_socketNum; //工作报告
//extern int performance_socketNum; //业绩报告
//extern int voicemeeting_socketNum; //语音会议
//extern int marketsurvey_socketNum; //市场调查
//extern int marketing_socketNum; //市场活动
//extern int saleproduct_socketNum; //销售订单
//extern int salecontract_socketNum; //销售合同
//extern int saleclue_socketNum; //销售线索
//extern int salechance_socketNum; //销售机会
 */

@interface SDSocketCacheManager : NSObject

@property (nonatomic,assign) int offLineNum; //离线数据数量

+ (instancetype)shareCacheManager;

/// 通过上面定义的type返回相应的推送个数
- (NSInteger)getNumFromSocketType:(NSString*)type;

/// 通过上面定义的type设置值为0
- (void)setTypeValueFromSocketType:(NSString*)type;

/// 通过上面定义的type返回相应的推送个数+已经推送的数
- (NSInteger)getNumFromSocketType:(NSString*)type pushValue:(NSString*)val;

/// 通过一组type获取推送总数
- (NSInteger)getNumFromSocketTypeArr:(NSArray*)typeArr;

/// 通过上面定义的type设置值
- (void)setTypeValueFromSocketTypeArr:(NSArray*)typeArr;

/// 根据类型计算离线消息数量
- (void)countSocketTypeNum:(NSString *)oneKey;

@end
