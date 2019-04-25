//
//  SDUploadFileModel.h
//  SDMarketingManagement
//
//  Created by Rao on 15-6-18.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDUploadFileModel : NSObject

/// 文件流
@property(nonatomic, strong) NSData *fileData;
/// 文件名.要求唯一的
@property(nonatomic, copy) NSString *fileName;
/// 文件mimeType
@property(nonatomic, copy) NSString *mimeType;

/// 长度
@property(nonatomic, copy) NSString *duration;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *srcName;
@property(nonatomic, assign) NSInteger showType;
@property (nonatomic ,assign) float voiceTimeLength;
@property(assign, nonatomic) long eid;
@end
