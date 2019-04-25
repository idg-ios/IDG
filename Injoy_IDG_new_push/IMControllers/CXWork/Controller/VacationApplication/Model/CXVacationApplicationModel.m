//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXVacationApplicationModel.h"


@implementation CXVacationApplicationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
            @"data": [self class]
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"signed_objc": @"signed"};
}

@end
