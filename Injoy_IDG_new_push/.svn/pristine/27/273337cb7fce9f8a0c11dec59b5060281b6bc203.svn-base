//
//  CXAnnexDownloadModel.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXAnnexDownloadProgressModel.h"

@interface CXAnnexDownloadModel : NSObject
@property (nonatomic, copy, nullable) NSString *resourceURLString;
@property (nonatomic, copy)NSMutableURLRequest *requestURL;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *fileDirectory;
@property (nonatomic, strong, nullable) NSDate *downloadDate;
@property (nonatomic, strong, nullable) NSData *resumeData;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *plistFilePath;
@property (nonatomic, strong) CXAnnexDownloadProgressModel *progressModel;
@end
