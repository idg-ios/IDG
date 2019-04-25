//
//  CXAnnexDownLoadManager.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXAnnexDownloadModel.h"
typedef NS_ENUM(NSInteger, downloadStatus) {
    start = 0,
    downloading = 1,
    hasDownload = 2,
    downloadSucess = 3,
    downloadFaild =4,
    waiting = 5,
    notFound
};
@protocol CXAnnexDownloadDelegate<NSObject>
- (void)downloadModel:(CXAnnexDownloadModel *)downloadModel dowloadStatus:(downloadStatus)status;
@end
@interface CXAnnexDownLoadManager : NSObject
@property (nonatomic, copy) NSString *downLoadString;
@property (nonatomic, weak) id<CXAnnexDownloadDelegate> delegate;
+ (instancetype)sharedManager;
- (void)addDownLoadTask:(CXAnnexDownloadModel *)model;
- (BOOL)fileIsExit:(NSString *)fileName;
- (BOOL)fileIsExit:(NSString *)filePath andName:(NSString *)fileName;
- (NSString *)filePathOfDownloded:(NSString *)fileName;
- (NSString *)filePathOfDownloded:(NSString *)filePath andName:(NSString *)fileName;
- (downloadStatus)fileDownloadSatus:(CXAnnexDownloadModel *)downloadModel;
- (unsigned long long)getToatalCacheSize;
- (void)clearCacheData;
@end
