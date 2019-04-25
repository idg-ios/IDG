//
//  SDUserCusModel.m
//  SDMarketingManagement
//
//  Created by Rao on 15/10/24.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDUserCusModel.h"

@implementation SDUserCusModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"<self:%p\n,self.userId:%@\n,spaceType:%@\n,cusUserId:%@\n>",self,self.userId,self.spaceType,self.cusUserId];
}

@end
