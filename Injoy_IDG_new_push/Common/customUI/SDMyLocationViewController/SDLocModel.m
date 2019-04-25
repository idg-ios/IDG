//
//  SDLocModel.m
//  SDMarketingManagement
//
//  Created by fanzhong on 15/5/26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDLocModel.h"

@implementation SDLocModel


- (instancetype)initWithBMKPoiInfo:(BMKPoiInfo *)info
{
    self = [super init];
    if (self) {
        self.locName = info.address;
        self.locationCoord = info.pt;
    }
    return self;
}
@end
