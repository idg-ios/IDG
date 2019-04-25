//
//  CXIMFileMessageBody.h
//  SDIMLib
//
//  Created by cheng on 16/8/5.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMMessageBody.h"
/** 下载状态 */
typedef NS_ENUM(NSInteger, CXIMFileDownloadState) {
    /** 未下载 */
    CXIMFileDownloadStateWaiting = 0,
    /** 下载中 */
    CXIMFileDownloadStateDownloading = 1,
    /** 成功 */
    CXIMFileDownloadStateSuccess = 3,
    /** 失败 */
    CXIMFileDownloadStateFailed = 4
};

/** 文件消息体 */
@interface CXIMFileMessageBody : CXIMMessageBody

/** 本地地址 */
@property(nonatomic, copy) NSString *localUrl;
/** 服务器地址 */
@property(nonatomic, copy) NSString *remoteUrl;
/** 文件名 */
@property(nonatomic, copy) NSString *name;
/** (语音)长度 */
@property(nonatomic, copy) NSNumber *length;
/** 文件大小 */
@property(nonatomic, copy) NSNumber *size;
/** 下载状态 */
@property(nonatomic, assign) CXIMFileDownloadState downloadState;

- (BOOL)isFileExist;
- (NSString *)fullLocalPath;

@end
