//
// Created by ^ on 2017/12/18.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 基金投资
@interface CXFundInvestmentModel : NSObject
@property(copy, nonatomic) NSArray *contracts;
/// CNY累计投资
@property(copy, nonatomic) NSString *rmbCost;
/// CNY估值增长
@property(copy, nonatomic) NSString *rmbGrowth;
/// USD累计投资
@property(copy, nonatomic) NSString *usdCost;
/// USD估值增长
@property(copy, nonatomic) NSString *usdGrowth;
@end