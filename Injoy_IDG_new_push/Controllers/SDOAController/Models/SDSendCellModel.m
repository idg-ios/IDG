//
//  SDSendCellModel.m
//  SDMarketingManagement
//
//  Created by 郭航 on 15/6/12.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDSendCellModel.h"

@implementation SDSendCellModel


-(NSString *)description
{
    return [NSString stringWithFormat:@"cellModel:%p,imageString:%@,introduce:%@,modelType:%d\n",self,self.imageString,self.introduce,self.modelType];
}

-(id)copyWithZone:(NSZone *)zone
{
    SDSendCellModel *cellModel = [[SDSendCellModel alloc] init];
    cellModel.imageString = self.imageString;
    cellModel.introduce = self.introduce;
    cellModel.modelType = self.modelType;
    
    return cellModel;
}

@end
