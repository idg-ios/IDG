//
// Created by ^ on 2017/12/15.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXInvestmentPlanModel.h"


@implementation CXInvestmentPlanModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"data": [self class]
    };
}

- (NSString *)approvedFlagVal {
    if ([@"1" isEqualToString:self.approvedFlag]) {
        return @"是";
    }
    return @"否";
}

@end