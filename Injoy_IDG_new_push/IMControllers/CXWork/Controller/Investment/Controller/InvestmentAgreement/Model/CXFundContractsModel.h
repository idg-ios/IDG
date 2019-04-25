//
// Created by ^ on 2017/12/18.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 基金投资的contracts
@interface CXFundContractsModel : NSObject
/// 基金
@property(copy, nonatomic) NSString *fund;
/// 占比
@property(copy, nonatomic) NSString *ownership;
/// 投资金额
@property(copy, nonatomic) NSString *cost;
/// 币种
@property(copy, nonatomic) NSString *currency;
/// 倍数
@property(copy, nonatomic) NSString *multiply;
@end