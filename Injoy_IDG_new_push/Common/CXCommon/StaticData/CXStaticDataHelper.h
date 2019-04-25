//
//  CXStaticDataHelper.h
//  SDMarketingManagement
//
//  Created by lancely on 5/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXSingleton.h"
#import "CXStaticDataModel.h"
#import "CXStaticDataModel2.h"
#import <Foundation/Foundation.h>

/** 静态数据类型 */
typedef NS_ENUM(NSInteger, CXStaticDataType) {
    /** 物流公司 */
            CXStaticDataTypeLogistics = -1,
    /** 汇率币种 */
            CXStaticDataTypeCurrencies = -2,
    /** 关怀，客户类型类别，仓库出入库 */
            CXStaticDataTypeOther = -3
};

@interface CXStaticDataHelper : NSObject

singleton_interface(CXStaticDataHelper)

#pragma mark - 静态数据类型常量
/** 币种 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeCurrency;
/** 财务简报 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeFinanceReport;
/** 费用简报 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeChargeReport;
/** 损益简报 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeProfitLossReport;
/** 工资/社保/税金简报 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeGZSBSJReport;
/** 货品类型 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeProduct;
/** 出入库理由 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeOutInReason;
/** 资金简报 */
FOUNDATION_EXPORT NSString *const CXStaticDataTypeMoneyReport;
/** 资金报告（人民币）*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeRMBReport;
/** 资金报告(外币)*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeFBReport;
/** 资金流量表*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeMoneyFlowReport;
/** 广告类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeAdvertisementType;
/** 活动类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeActivityType;
/** PR类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypePRType;
/** 竞价类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeBiddingType;
/** 网盟类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeNetworkType;
/** 口碑类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeMouthWordType;
/** 学历*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeEducation;
/** 婚姻*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeMarriage;
/** 用工形式*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeEmploymentType;
/**请假类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeLeaveType;
/**调薪类型*/
FOUNDATION_EXPORT NSString *const CXStaticDataTypeChangePayType;
/**< 研发验收完成情况 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeWCQKType;
/**< 客户关系--关怀类型 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCustomsCareType;
/**< 客户关系--客户喜好 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCustomsHobyType;
/**< 客户关系--客户支持类型 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCustomsSupportType;
/**< 客户关系--客户类型 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCusType;
/**< 客户关系--客户类别 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCusCore;
/**< 客户关怀--关怀类型 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeCaretype;
/**< 其它入库--入库理由 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeIwh_Type;
/**< 其它出库--出库理由 */
FOUNDATION_EXPORT NSString *const CXStaticDatatypeOwh_Type;
/**< 客户关怀--关怀类型 */
FOUNDATION_EXPORT NSString *const CXStaticDataType_CusActivity;

#pragma mark - 获取静态数据

/**
 *  获取所有静态数据
 *
 *  @return 静态数据模型数组
 */
- (NSArray<CXStaticDataModel *> *)getStaticData;

/**
 *  根据类型获取静态数据
 *
 *  @param type 静态数据类型
 *
 *  @return 静态数据模型数组
 */
- (NSArray<CXStaticDataModel *> *)getStaticDataWithType:(NSString *)type;

/**
 *  @author lancely, 16-05-27 20:05:37
 *
 *  根据value获取名称
 *
 *  @param value 值
 *  @param type  静态数据类型
 *
 *  @return 名称
 */
- (NSString *)getNameByValue:(NSString *)value ofType:(NSString *)type;

/**
 *  @author lancely, 16-05-27 20:05:01
 *
 *  根据名称获取value值
 *
 *  @param name 名称
 *  @param type 静态数据类型
 *
 *  @return value值
 */
- (NSString *)getValueByName:(NSString *)name ofType:(NSString *)type;

/**
 *  @author lancely, 16-06-13 11:06:30
 *
 *  根据id获取客户类别名称
 *
 *  @param ID id
 *
 *  @return name
 */
- (NSString *)getCusTypeNameById:(NSInteger)ID;

/**
 *  @author lancely, 16-06-13 11:06:13
 *
 *  根据id获取客户级别名称
 *
 *  @param ID id
 *
 *  @return name
 */
- (NSString *)getCusLevelNameById:(NSInteger)ID;


/**
 根据物流公司编码获取名称

 @param value 物流公司编码

 @return 物流公司名称
 */
- (NSString *)getLogisticsCompanyNameByValue:(NSString *)value;

/**
 根据物流公司名称获取编码
 
 @param name 物流公司名称
 
 @return 物流公司编码
 */
- (NSString *)getLogisticsCompanyValueByName:(NSString *)name;

/**
 *  从服务器获取静态数据
 */
- (void)getStaticDataFromServer;


/**
 获取静态数据

 @param type            静态数据类型
 @param completionBlock 完成的回调
 */
- (void)getStaticDataWithType:(CXStaticDataType)type completion:(void (^)(NSError *error, NSArray<CXStaticDataModel *> *datas))completionBlock;

@end
