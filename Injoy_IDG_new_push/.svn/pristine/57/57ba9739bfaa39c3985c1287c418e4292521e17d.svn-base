//
//  CXStaticDataHelper.m
//  SDMarketingManagement
//
//  Created by lancely on 5/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXStaticDataHelper.h"
#import "HttpTool.h"
#import "YYModel.h"

/** 币种 */
NSString *const CXStaticDataTypeCurrency = @"currency_type";
/** 财务简报 */
NSString *const CXStaticDataTypeFinanceReport = @"cw_cwjb";
/** 费用简报 */
NSString *const CXStaticDataTypeChargeReport = @"cw_fyjb";
/** 损益简报 */
NSString *const CXStaticDataTypeProfitLossReport = @"cw_syjb";
/** 工资/社保/税金简报 */
NSString *const CXStaticDataTypeGZSBSJReport = @"cw_gzsbsjjb";
/** 出入库理由 */
NSString *const CXStaticDataTypeOutInReason = @"ck_ckly";
/** 货品类型 */
NSString *const CXStaticDataTypeProduct = @"sp_lx";
/** 人民币简报 */
NSString *const CXStaticDataTypeRMBReport = @"cw_bbjb";
/** 外币简报 */
NSString *const CXStaticDataTypeFBReport = @"qj_bz";
/** 资金流量表*/
NSString *const CXStaticDataTypeMoneyFlowReport = @"cw_xjlljb";
/** 广告类型*/
NSString *const CXStaticDataTypeAdvertisementType = @"mk_gglx";
/** 活动类型*/
NSString *const CXStaticDataTypeActivityType = @"mk_hdlx";
/** PR类型*/
NSString *const CXStaticDataTypePRType = @"mk_prlx";
/** 竞价类型*/
NSString *const CXStaticDataTypeBiddingType = @"mk_jjlx";
/** 网盟类型*/
NSString *const CXStaticDataTypeNetworkType = @"mk_wmlx";
/** 口碑类型*/
NSString *const CXStaticDataTypeMouthWordType = @"mk_kblx";
/** 学历*/
NSString *const CXStaticDataTypeEducation = @"khgx_xl";
/** 婚姻*/
NSString *const CXStaticDataTypeMarriage = @"xz_khhy";
/** 用工形式*/
NSString *const CXStaticDataTypeEmploymentType = @"xz_hyxs";
/**请假类型*/
NSString *const CXStaticDataTypeLeaveType = @"xz_qjlx";
/**调薪类型*/
NSString *const CXStaticDataTypeChangePayType = @"xz_txlx";
/**交通工具*/
//NSString *const CXStaticDataTypeVehicleype = @"xz_jtgj";
/**< 研发验收完成情况 */
NSString *const CXStaticDatatypeWCQKType = @"yf_yswcqk";
/**< 客户关系--关怀类型 */
NSString *const CXStaticDatatypeCustomsCareType = @"yf_yswcqk";
/**< 客户关系--客户喜好 */
NSString *const CXStaticDatatypeCustomsHobyType = @"khgx_xh";
/**< 客户关系--客户支持类型 */
NSString *const CXStaticDatatypeCustomsSupportType = @"khgx_zclx";
/// 客户类型
NSString *const CXStaticDatatypeCusType = @"cus_type";
/**< 客户关系--客户类别 */
NSString *const CXStaticDatatypeCusCore = @"cus_core";
/**< 客户关怀--关怀类型 */
NSString *const CXStaticDatatypeCaretype = @"care_type";
/**< 其它入库--入库理由 */
NSString *const CXStaticDatatypeIwh_Type = @"iwh_type";
/**< 其它出库--出库理由 */
NSString *const CXStaticDatatypeOwh_Type = @"owh_type";
NSString *const CXStaticDataType_CusActivity = @"khhd_type";

@implementation CXStaticDataHelper

singleton_implementation(CXStaticDataHelper)

- (NSArray<CXStaticDataModel *> *)getStaticData {

    NSArray *result = [NSArray yy_modelArrayWithClass:CXStaticDataModel.class json:VAL_StaticData];
    return result;
}

- (NSArray<CXStaticDataModel *> *)getStaticDataWithType:(NSString *)type {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.code = %@", type];
    return [[self getStaticData] filteredArrayUsingPredicate:pred];
}

- (NSString *)getNameByValue:(NSString *)value ofType:(NSString *)type {
    NSArray<CXStaticDataModel *> *datas = [self getStaticDataWithType:type];
    datas = [datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.value = %@", value]];
    if (datas.count) {
        return datas.firstObject.name;
    }
    return nil;
}

- (NSString *)getValueByName:(NSString *)name ofType:(NSString *)type {
    NSArray<CXStaticDataModel *> *datas = [self getStaticDataWithType:type];
    datas = [datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name = %@", name]];
    if (datas.count) {
        return datas.firstObject.value;
    }
    return nil;
}

- (NSString *)getLogisticsCompanyNameByValue:(NSString *)value {
    if (value.length) {
        NSArray<CXStaticDataModel *> *datas = [NSArray yy_modelArrayWithClass:CXStaticDataModel.class json:VAL_LogisticsCompanyData];
        datas = [datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.value = %@", value]];
        if (datas.count) {
            return datas.firstObject.name;
        }
    }
    return nil;
}

- (NSString *)getLogisticsCompanyValueByName:(NSString *)name {
    if (name.length) {
        NSArray<CXStaticDataModel *> *datas = [NSArray yy_modelArrayWithClass:CXStaticDataModel.class json:VAL_LogisticsCompanyData];
        datas = [datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name = %@", name]];
        if (datas.count) {
            return datas.firstObject.value;
        }
    }
    return nil;
}

- (void)getStaticDataFromServer {
    NSString *url = [NSString stringWithFormat:@"%@dictionary/list/%@", urlPrefix, @"-3"];
    //NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //[params setValue:VAL_companyId forKey:@"companyId"];
    [HttpTool getWithPath:url
                   params:nil
                  success:^(id JSON) {
                      NSDictionary *dic = JSON;
                      NSNumber *status = dic[@"status"];
                      if ([status intValue] == 200) {
                          // 保存到本地
                          dispatch_async(dispatch_get_global_queue(0, 0), ^{
                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                              [userDefaults setValue:JSON[@"data"] forKey:KStaticData];
                              [userDefaults synchronize];
                          });
                      }
                  }
                  failure:^(NSError *error) {
                      //                      TTAlertNoTitle([error debugDescription]);
                      TTAlertNoTitle(@"获取静态数据失败");
                  }];
}

- (void)getStaticDataWithType:(CXStaticDataType)type completion:(void (^)(NSError *, NSArray<CXStaticDataModel *> *))completionBlock {
    // /dictionary/list/{type}.json
    NSString *url = [NSString stringWithFormat:@"/dictionary/list/%zd.json", type];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            if (completionBlock) {
                NSArray<CXStaticDataModel *> *datas = [NSArray yy_modelArrayWithClass:CXStaticDataModel.class json:JSON[@"data"]];
                completionBlock(nil, datas);
            }
        } else {
            if (completionBlock) {
                NSError *error = [NSError errorWithDomain:@"cxerp" code:[JSON[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey: JSON[@"msg"]}];
                completionBlock(error, nil);
            }
        }
    }             failure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(error, nil);
        }
    }];
}

@end
