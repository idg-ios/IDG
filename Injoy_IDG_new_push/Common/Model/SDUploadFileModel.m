//
//  SDUploadFileModel.m
//  SDMarketingManagement
//
//  Created by Rao on 15-6-18.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  文件上传model

#import "SDUploadFileModel.h"

@implementation SDUploadFileModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"fileModel:%p\n,self.fileData:%@\n,self.fileName:%@\n,self.mimeType:%@\n",self,self.fileData,self.fileName,self.mimeType];
}

@end
