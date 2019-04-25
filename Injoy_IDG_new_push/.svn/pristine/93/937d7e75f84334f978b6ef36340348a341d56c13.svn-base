//
//  SDDepartmentModel.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDDepartmentModel.h"
#import "CXUserConcern.h"

@implementation SDDepartmentModel

- (BOOL)isEqual:(id)object {
    BOOL ret = NO;

    if (nil == object || NO == [object isKindOfClass:[self class]]) {
        ret = NO;
    }

    if ([self.departmentId isEqualToNumber:[object departmentId]] &&
            [self.departmentName isEqualToString:[object departmentName]] &&
            [self.companyId isEqualToNumber:[(SDDepartmentModel *) object companyId]]) {
        ret = YES;
    }

    return ret;
}

@end
