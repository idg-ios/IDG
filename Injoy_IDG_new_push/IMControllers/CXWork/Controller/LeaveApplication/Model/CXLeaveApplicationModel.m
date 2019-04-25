//
// Created by ^ on 2017/10/25.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXLeaveApplicationModel.h"

@implementation CXLeaveApplicationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"data": [self class],
            @"approvalPerson": @"CXApprovalPersonModel",
            @"cc": @"CXUserModel"
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if ([self.approvalPerson count]) {
        dic[@"approvalPerson"] = [self.approvalPerson yy_modelToJSONString];
    }
    if ([self.cc count]) {
        dic[@"cc"] = [self.cc yy_modelToJSONString];
    }
    return YES;
}

@end
