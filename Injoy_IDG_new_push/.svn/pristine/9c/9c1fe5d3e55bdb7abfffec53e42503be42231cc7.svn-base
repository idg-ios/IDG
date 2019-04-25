//
// Created by ^ on 2017/10/26.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXBorrowingApplicationModel.h"


@implementation CXBorrowingApplicationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"data": [self class],
            @"loan": [self class],
            @"approvalPerson": @"CXApprovalPersonModel"
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if ([self.approvalPerson count]) {
        dic[@"approvalPerson"] = [self.approvalPerson yy_modelToJSONString];
    }
    return YES;
}

@end