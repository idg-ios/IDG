//
//  CXFundInvestmentListModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXFundInvestmentListContractModel.h"

@interface CXFundInvestmentListModel : NSObject

/** rmbCost CNY累计投资 String */
@property (nonatomic, copy) NSString * rmbCost;
/** rmbGrowth CNY估值增长 String */
@property (nonatomic, copy) NSString * rmbGrowth;
/** usdCost USD累计投资 String */
@property (nonatomic, copy) NSString * usdCost;
/** usdGrowth USD估值增长 String */
@property (nonatomic, copy) NSString * usdGrowth;
/** contracts 列表数据 Array */
@property (nonatomic, strong) NSArray<CXFundInvestmentListContractModel *> * contractsArray;

@end
