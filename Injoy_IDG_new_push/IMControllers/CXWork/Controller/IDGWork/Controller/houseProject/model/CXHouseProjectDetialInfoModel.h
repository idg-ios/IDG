//
//  CXHouseProjectDetialInfoModel.h
//  InjoyIDG
//
//  Created by ^ on 2018/6/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXHouseProjectDetialInfoModel : NSObject
// 建筑面积相关
@property (nonatomic, strong) NSString *floorSpace;
// 土地指标
@property (nonatomic, strong) NSString *landIndicator;
// 证照及法律手续
@property (nonatomic, strong) NSString *legalFormalities;
// 市场描述
@property (nonatomic, strong) NSString *marketDesc;
// ID
@property (nonatomic, strong) NSString *projId;
// 风险提示
@property (nonatomic, strong) NSString *riskDesc;
// 交易对手及合作伙伴
@property (nonatomic, strong) NSString *teamDesc;
// 时间节点
@property (nonatomic, strong) NSString *timeNode;
//交易思路
@property (nonatomic, strong) NSString *tradeThinking;
//退出总结
@property (nonatomic, strong) NSString *withdrawSummary;
@end
