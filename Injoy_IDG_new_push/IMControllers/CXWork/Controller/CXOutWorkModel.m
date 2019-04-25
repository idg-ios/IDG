//
// Created by ^ on 2017/10/23.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXOutWorkModel.h"

@interface CXOutWorkModel ()
@end

@implementation CXOutWorkModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"data": [self class],
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