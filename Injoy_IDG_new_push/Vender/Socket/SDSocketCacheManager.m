//
//  SDSocketCacheManager.m
//  SDMarketingManagement
//
//  Created by Rao on 15/12/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

NSString* holiday_socket = @"holiday"; //请假
NSString* purchase_socket = @"purchase"; //费用
NSString* travel_socket = @"travel"; //差旅
NSString* workrepot_socket = @"workrepot"; //事务
NSString* workrepotspecial_socket = @"workrepotspecial"; //特殊事务
NSString* order_socket = @"order"; //指令(工作任务)
NSString* atreply_socket = @"atreply"; //@我的回复
NSString* atwork_socket = @"atwork"; //@我的工作
NSString* reply_socket = @"reply"; //收到的回复
NSString* procurement_socket = @"procurement"; //采购申请
NSString* market_socket = @"market"; //市场业务
NSString* sale_socket = @"sale"; //销售申请
NSString* visit_socket = @"visit"; //拜访计划
NSString* store_socket = @"store"; //仓库业务
NSString* storebis_socket = @"storebis"; //仓库查询
NSString* notice_socket = @"notice"; //消息通知
NSString* contact_socket = @"contact"; //联系人
NSString* staticdata_socket = @"staticdata"; //静态数据
NSString* sysnotice_socket = @"sysnotice"; //公告
NSString* workspace_socket = @"workspace"; //工作圈
NSString* report_socket = @"report"; //工作报告
NSString* performance_socket = @"performance"; //业绩报告
NSString* voicemeeting_socket = @"voicemeeting"; //语音会议
NSString* marketsurvey_socket = @"marketsurvey"; //市场调查
NSString* marketing_socket = @"marketing"; //市场活动
NSString* saleproduct_socket = @"saleproduct"; //销售订单
NSString* salecontract_socket = @"salecontract"; //销售合同
NSString* saleclue_socket = @"saleclue"; //销售线索
NSString* salechance_socket = @"salechance"; //销售机会
NSString* approval_socket = @"approval"; //审批

#import "SDSocketCacheManager.h"
#import "AppDelegate.h"

@interface SDSocketCacheManager ()

- (instancetype)initExt;

@end

@implementation SDSocketCacheManager

static SDSocketCacheManager* m_instance = nil;

+ (instancetype)shareCacheManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == m_instance) {
            m_instance = [[self alloc] initExt];
        }
    });
    return m_instance;
}

- (NSInteger)getNumFromSocketType:(NSString*)type
{
    NSString *uid = [AppDelegate getUserID];
    type = [NSString stringWithFormat:@"%@%@",uid,type];
    NSMutableDictionary* params = [VAL_SocketNotify mutableCopy];
    return [[params valueForKey:type] integerValue];
}

- (NSInteger)getNumFromSocketType:(NSString*)type pushValue:(NSString*)val
{
    NSString *uid = [AppDelegate getUserID];
    type = [NSString stringWithFormat:@"%@%@",uid,type];
    
    NSMutableDictionary* params = [VAL_SocketNotify mutableCopy];
    NSInteger flag = [[params valueForKey:type] integerValue];
    return flag + [val integerValue];
}

- (NSInteger)getNumFromSocketTypeArr:(NSArray*)typeArr
{
    NSInteger flag = 0;
    for (NSString* type in typeArr) {
        flag += [[SDSocketCacheManager shareCacheManager] getNumFromSocketType:type];
    }
    return flag;
}

- (void)setTypeValueFromSocketTypeArr:(NSArray*)typeArr
{
    for (NSString* type in typeArr) {
        [[SDSocketCacheManager shareCacheManager] setTypeValueFromSocketType:type];
    }
}

- (void)setTypeValueFromSocketType:(NSString*)type
{
    NSString *uid = [AppDelegate getUserID];
    type = [NSString stringWithFormat:@"%@%@",uid,type];
    NSMutableDictionary* params = [VAL_SocketNotify mutableCopy];
    [params setValue:@"" forKey:type];
    [[NSUserDefaults standardUserDefaults] setValue:params forKey:KSocketNotify];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initExt
{
    if (self = [super init]) {
        //
    }
    return self;
}

- (void)countSocketTypeNum:(NSString *)oneKey
{
    if ([oneKey isEqualToString:holiday_socket]) {
        //请假
        _offLineNum++;
        //holiday_socketNum++;
    }
    else if ([oneKey isEqualToString:purchase_socket]) {
        //费用
        _offLineNum++;
        //purchase_socketNum++;
    }
    else if ([oneKey isEqualToString:travel_socket]) {
        //差旅
        _offLineNum++;
        //travel_socketNum++;
    }
    else if ([oneKey isEqualToString:workrepot_socket]) {
        //事务
        _offLineNum++;
        //workrepot_socketNum++;
    }
    else if ([oneKey isEqualToString:workrepotspecial_socket]) {
        //特殊事务
        _offLineNum++;
        //workrepotspecial_socketNum++;
    }
    else if ([oneKey isEqualToString:order_socket]) {
        //工作任务
        _offLineNum++;
        //order_socketNum++;
    }
    else if ([oneKey isEqualToString:atreply_socket]) {
        //@我的回复
        _offLineNum++;
        //atreply_socketNum++;
    }
    else if ([oneKey isEqualToString:atwork_socket]) {
        //@我的工作
        _offLineNum++;
        //atwork_socketNum++;
    }
    else if ([oneKey isEqualToString:reply_socket]) {
        //收到的回复
        _offLineNum++;
        //reply_socketNum++;
    }
    else if ([oneKey isEqualToString:approval_socket]) {
        //审批
        _offLineNum++;
        //approval_socketNum++;
    }
    else if ([oneKey isEqualToString:procurement_socket]) {
        //采购申请
        _offLineNum++;
        //procurement_socketNum++;
    }
    else if ([oneKey isEqualToString:market_socket]) {
        //市场业务
        _offLineNum++;
        //market_socketNum++;
    }
    else if ([oneKey isEqualToString:sale_socket]) {
        //销售申请
        _offLineNum++;
        //sale_socketNum++;
    }
    else if ([oneKey isEqualToString:visit_socket]) {
        //拜访申请
        _offLineNum++;
        //visit_socketNum++;
    }
    else if ([oneKey isEqualToString:store_socket]) {
        //仓库报告
        _offLineNum++;
        //store_socketNum++;
    }
    else if ([oneKey isEqualToString:storebis_socket]) {
        //仓库查询
        _offLineNum++;
        //storebis_socketNum++;
    }
    else if ([oneKey isEqualToString:notice_socket]) {
        //消息通知
        _offLineNum++;
        //notice_socketNum++;
    }
    else if ([oneKey isEqualToString:contact_socket]) {
        //联系人
        _offLineNum++;
        //contact_socketNum++;
    }
    else if ([oneKey isEqualToString:staticdata_socket]) {
        //静态数据
        
    }
    else if ([oneKey isEqualToString:sysnotice_socket]) {
        //公告
        _offLineNum++;
        //sysnotice_socketNum++;
    }
    else if ([oneKey isEqualToString:workspace_socket]) {
        //工作圈
        _offLineNum++;
        //workspace_socketNum++;
    }
    else if ([oneKey isEqualToString:report_socket]) {
        //工作报告
        _offLineNum++;
        //report_socketNum++;
    }
    else if ([oneKey isEqualToString:performance_socket]) {
        //业绩报告
        _offLineNum++;
        //performance_socketNum++;
    }
    else if ([oneKey isEqualToString:marketsurvey_socket]) {
        //市场调查
        _offLineNum++;
        //marketsurvey_socketNum++;
    }
    else if ([oneKey isEqualToString:marketing_socket]) {
        //市场活动
        _offLineNum++;
        //marketing_socketNum++;
    }
    else if ([oneKey isEqualToString:saleproduct_socket]) {
        //销售订单
        _offLineNum++;
        //saleproduct_socketNum++;
    }
    else if ([oneKey isEqualToString:salecontract_socket]) {
        //销售合同
        _offLineNum++;
        //salecontract_socketNum++;
    }
    else if ([oneKey isEqualToString:saleclue_socket]) {
        //销售线索
        _offLineNum++;
        //saleclue_socketNum++;
    }
    else if ([oneKey isEqualToString:salechance_socket]) {
        //销售机会
        _offLineNum++;
        //salechance_socketNum++;
    }
}


@end
