//
//  CXAnnexDownLoadManager.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnexDownLoadManager.h"
#import "AFNetworking.h"

#define AnnexFile [NSString stringWithFormat:@"annexFileOf%@",VAL_USERNAME]
#define FilePlistPath @"managerPlistPath.plist"
@interface CXAnnexDownLoadManager()
@property (nonatomic, strong)NSMutableArray *unStartTaskArray;
@property (nonatomic, strong)NSMutableArray *downLoadingTaskArray;
@property (nonatomic, strong)NSMutableArray *endDownLoadTaskArray;
@property (nonatomic, strong)AFNetworkReachabilityManager *netWorkStatusManager;
@property (nonatomic, strong)AFHTTPSessionManager *AFManager;
@property (nonatomic, assign)NSInteger maxDownLoadCount;
@property (nonatomic, assign)BOOL resumeTaskFIFO;
@property (nonatomic, assign)BOOL batchDownload;
@property (nonatomic, strong)NSFileManager *fileManager;
@property (nonatomic, copy)NSString *downloadDirectory;
@property (nonatomic, copy)NSString *managerPlistPath;
@property (nonatomic, copy)NSMutableDictionary *downloadDic;
@end
@implementation CXAnnexDownLoadManager
static dispatch_once_t onceToken;
static CXAnnexDownLoadManager *manager;
static dispatch_queue_t statusQueue;
+ (instancetype)sharedManager{
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        statusQueue = dispatch_queue_create("com.statusQueue", DISPATCH_QUEUE_SERIAL);
    });
    return manager;
}
- (instancetype)init{
    if(self = [super init]){
        _AFManager = [[AFHTTPSessionManager alloc]init];
        _AFManager.requestSerializer.timeoutInterval = 5;
        _AFManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        _AFManager.responseSerializer.acceptableContentTypes = typeSet;
        _AFManager.securityPolicy.allowInvalidCertificates = YES;
        
        _maxDownLoadCount = 1;
        _resumeTaskFIFO = YES;
        _batchDownload = NO;
        
        _fileManager = [NSFileManager defaultManager];
        _downloadDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:AnnexFile];
        BOOL isDir;
        if(![_fileManager fileExistsAtPath:_downloadDirectory isDirectory:&isDir]){
            [_fileManager createDirectoryAtPath:_downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSDictionary <NSString *, NSString *> *plistDic = [[NSDictionary alloc]init];
        _managerPlistPath = [_downloadDirectory stringByAppendingPathComponent:FilePlistPath];
        [plistDic writeToFile:_managerPlistPath atomically:YES];
        
    }
    return self;
}
- (void)addDownLoadTask:(CXAnnexDownloadModel *)model{
    if(self.unStartTaskArray.count >5){
        CXAlert(@"在下载任务完成后继续添加");
        return;
    }
    NSLock *arrayLock = [[NSLock alloc]init];
    [arrayLock lock];
    [self.unStartTaskArray addObject:model];
    if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
        [_delegate downloadModel:model dowloadStatus:waiting];
    }
    if(self.downLoadingTaskArray.count == 0){
        self.downLoadingTaskArray = self.unStartTaskArray.mutableCopy ;
        [self.unStartTaskArray removeAllObjects];
    }
    [arrayLock unlock];
    [self resumeDownLoad];
}
- (void)resumeDownLoad{
    if(!self.downLoadingTaskArray.count){
        if(self.unStartTaskArray.count){
            self.downLoadingTaskArray = self.unStartTaskArray.mutableCopy ;
            [self.unStartTaskArray removeAllObjects];
        }else{
            return;
        }
    }
    if(self.downLoadingTaskArray.count){
        if(!self.downloadDic.allKeys.count){
        [self startNextTask];
        }
    }
    
    
}
- (void)sw_startDownloadWithDoawnloadModel:(CXAnnexDownloadModel *)downloadModel progress:(void (^)(CXAnnexDownloadModel *))progress copletionHandle:(void(^)(CXAnnexDownloadModel *, NSError *))completionHandler{
    NSString *fileName = [downloadModel.fileName componentsSeparatedByString:@"."].firstObject;
    downloadModel.fileDirectory = downloadModel.filePath?[downloadModel.filePath stringByAppendingPathComponent:fileName]:[self.downloadDirectory stringByAppendingPathComponent:fileName];
    BOOL isDir;
    if([_fileManager fileExistsAtPath:downloadModel.fileDirectory isDirectory:&isDir]){
        if(!isDir){
            [_fileManager createDirectoryAtPath:downloadModel.fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    else{
        [_fileManager createDirectoryAtPath:downloadModel.fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    downloadModel.filePath = [downloadModel.fileDirectory stringByAppendingPathComponent:downloadModel.fileName];
    downloadModel.plistFilePath = [downloadModel.fileDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.plist", fileName]];
    if(![self canBeStartDownloadtaskWithModel:downloadModel]){
        return;
    }
    downloadModel.resumeData = [NSData dataWithContentsOfFile:downloadModel.plistFilePath];
    NSProgress *progres = nil;
    
    dispatch_async(statusQueue, ^{
        if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate downloadModel:downloadModel dowloadStatus:start];
            });
        }
    });
    if(downloadModel.resumeData.length == 0){
        NSURLRequest *request = downloadModel.requestURL?:[NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.resourceURLString]];
        downloadModel.downloadTask = [self.AFManager downloadTaskWithRequest:request progress:&progres destination:^NSURL *_Nonnull(NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response){
            return [NSURL fileURLWithPath:downloadModel.filePath];
        } completionHandler:^(NSURLResponse *_Nonnull response , NSURL * _Nullable filePath, NSError * _Nullable error){
            if(error){
                [self sw_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadDic removeObjectForKey:downloadModel.resourceURLString];
                [self.downLoadingTaskArray removeObject:downloadModel];
                completionHandler(downloadModel, nil);
                [self sw_deletePlistFileWithDownloadModel:downloadModel];
            }
        }];
    }else{
        downloadModel.downloadTask = [self.AFManager downloadTaskWithResumeData:downloadModel.resumeData progress:&progres destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            return [NSURL fileURLWithPath:downloadModel.filePath];
        } completionHandler:^(NSURLResponse *response ,NSURL *filePath, NSError *error){
            if(error){
                [self sw_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadDic removeObjectForKey:downloadModel.resourceURLString];
                [self.downLoadingTaskArray removeObject:downloadModel];
                completionHandler(downloadModel, nil);
                [self sw_deletePlistFileWithDownloadModel:downloadModel];
       
            }
        }];
    }
//    if([_fileManager fileExistsAtPath:fileName isDirectory:&isDir]){
//        if(!isDir){
//            [_fileManager createDirectoryAtPath:fileName withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//    }else{
//        [_fileManager createDirectoryAtPath:fileName withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    [progres addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(void *)downloadModel.resourceURLString.UTF8String];
    [self sw_resumeDownloadWithDownloadModel:downloadModel];
}
- (void)startNextTask{
    CXAnnexDownloadModel *model;
    if(self.downLoadingTaskArray.count){
        model = self.downLoadingTaskArray.firstObject;
        
    }else{
        if(self.unStartTaskArray.count){
            self.downLoadingTaskArray = self.unStartTaskArray.mutableCopy;
            [self.unStartTaskArray removeAllObjects];
        }else{
            return;
        }
        model = self.downLoadingTaskArray.firstObject;
    }
    
    [self sw_startDownloadWithDoawnloadModel:model progress:nil copletionHandle:^(CXAnnexDownloadModel *model, NSError *error ){
        if(!error){
            NSLog(@"%@ 下载成功！", model.resourceURLString);
            dispatch_async(statusQueue, ^{
                if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_delegate downloadModel:model dowloadStatus:downloadSucess];
                    });
                
                }
            });
            [self startNextTask];
        }else{
            NSLog(@"下载失败：err %@", error);
            dispatch_async(statusQueue, ^{
                if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate downloadModel:model dowloadStatus:downloadFaild];
                    });
                    
                }
            });
        }
    }];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"completedUnitCount"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"progress is%f %@ %@",progress.fractionCompleted, progress.localizedDescription, progress.localizedAdditionalDescription);
//        if(progress.completedUnitCount == progress.totalUnitCount){
//            // self.dataCompleted = YES;
//        }else{
//            if(progress.totalUnitCount>0){
//
//            }
//        }
        __block CXAnnexDownloadModel *downloadModel;
        [self.downLoadingTaskArray enumerateObjectsUsingBlock:^(CXAnnexDownloadModel *model, NSUInteger idx, BOOL *stop){
            if([model.resourceURLString isEqualToString:[[NSString alloc]initWithUTF8String:context]]){
                downloadModel = model;
            }
        }];
        if(downloadModel){
        [self setValuesForDownloadModel:downloadModel withProgress:progress];
        }
        NSLog(@"Progress is %lld all is %lld",progress.completedUnitCount,progress.totalUnitCount);
        
    }
}
- (void)setValuesForDownloadModel:(CXAnnexDownloadModel *)model withProgress:(NSProgress *)progress{
    NSTimeInterval interval = -1 * [model.downloadDate timeIntervalSinceNow];
    model.progressModel.totalByWritten = model.downloadTask.countOfBytesReceived;
    model.progressModel.totalBytesExpetedToWrite = model.downloadTask.countOfBytesExpectedToReceive;
    model.progressModel.downloadProgress = progress.fractionCompleted;
    model.progressModel.downloadSpeed = (int64_t)((model.progressModel.totalByWritten - [self getResumeByteWithDownloadModel:model]) / interval);
    if (model.progressModel.downloadSpeed != 0) {
        int64_t remainingContentLength = model.progressModel.totalBytesExpetedToWrite - model.progressModel.totalByWritten;
        int currentLeftTime = (int)(remainingContentLength / model.progressModel.downloadSpeed);
        model.progressModel.downloadLeft = currentLeftTime;
    }
}
-(int64_t)getResumeByteWithDownloadModel:(CXAnnexDownloadModel *)downloadModel{
    int64_t resumeBytes = 0;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:downloadModel.plistFilePath];
    if (dict) {
        resumeBytes = [dict[@"NSURLSessionResumeBytesReceived"] longLongValue];
    }
    return resumeBytes;
}

- (void)sw_resumeDownloadWithDownloadModel:(CXAnnexDownloadModel *)model{
    if(model.downloadTask){
        model.downloadDate = [NSDate date];
        [model.downloadTask resume];
        self.downloadDic[model.resourceURLString] = model;
//        [self.downLoadingTaskArray addObject:model];
    }
}
- (void)sw_deletePlistFileWithDownloadModel:(CXAnnexDownloadModel *)model{
    if(model.downloadTask.countOfBytesReceived == model.downloadTask.countOfBytesExpectedToReceive){
        [self.fileManager removeItemAtPath:model.plistFilePath error:nil];
        [self removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:model];
    }
}
- (void)removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:(CXAnnexDownloadModel *)model{
    NSMutableDictionary *dict = [self managerPlistDic];
    [dict removeObjectForKey:model.resourceURLString];
    [dict writeToFile:_managerPlistPath atomically:YES];
}
- (void)sw_cancelDownloadTaskWithDownloadModel:(CXAnnexDownloadModel *)model{
    if(!model) return;
    NSURLSessionTaskState state = model.downloadTask.state;
    if(state == NSURLSessionTaskStateRunning){
        [model.downloadTask cancelByProducingResumeData:^(NSData *resumeData){
            model.resumeData = resumeData;
            @synchronized(self){
                BOOL isSuc = [model.resumeData writeToFile:model.plistFilePath atomically:YES];
                [self saveTotalBytesExpectedToWriteWithDownloadModel:model];
                if(isSuc){
                    model.resumeData = nil;
                    [self.downloadDic removeObjectForKey:model.resourceURLString];
                    [self.downLoadingTaskArray removeObject:model];
                }
            }
        }];
    }
}
- (void)saveTotalBytesExpectedToWriteWithDownloadModel:(CXAnnexDownloadModel *)model{
    NSMutableDictionary *dic = [self managerPlistDic];
    [dic setValue:[NSString stringWithFormat:@"%lld", model.downloadTask.countOfBytesExpectedToReceive] forKey:model.resourceURLString];
    [dic writeToFile:_managerPlistPath atomically:YES];
}
- (NSMutableDictionary <NSString *, NSString *>*)managerPlistDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:_managerPlistPath];
    return dic;
}
- (BOOL)canBeStartDownloadtaskWithModel:(CXAnnexDownloadModel *)model{
    if(!model) return NO;
    if(model.downloadTask && model.downloadTask.state == NSURLSessionTaskStateRunning){
        if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
            [_delegate downloadModel:model dowloadStatus:downloading];
        }
        return NO;
    }if([self sw_hasDownloadedFileWithDownloadModel:model]){
        if(_delegate && [_delegate respondsToSelector:@selector(downloadModel:dowloadStatus:)]){
            [_delegate downloadModel:model dowloadStatus:hasDownload];
        }
        return NO;
    }
    return YES;
}
- (NSString *)filePathOfDownloded:(NSString *)fileName{

    NSString *name = [fileName componentsSeparatedByString:@"."].firstObject;
    NSString *fileDirectory = [self.downloadDirectory stringByAppendingPathComponent:name];
    return  [fileDirectory stringByAppendingPathComponent:fileName];
}
- (NSString *)filePathOfDownloded:(NSString *)filePath andName:(NSString *)fileName{
    NSString *name = [fileName componentsSeparatedByString:@"."].firstObject;
    NSString *fileDirectory = [filePath stringByAppendingPathComponent:name];
    return  [fileDirectory stringByAppendingPathComponent:fileName];
}
- (BOOL)fileIsExit:(NSString *)fileName{
    CXAnnexDownloadModel *downloadModel = [[CXAnnexDownloadModel alloc]init];
    NSString *name = [fileName componentsSeparatedByString:@"."].firstObject;
    downloadModel.fileDirectory = [self.downloadDirectory stringByAppendingPathComponent:name];
    downloadModel.filePath = [downloadModel.fileDirectory stringByAppendingPathComponent:fileName];
    return [self sw_hasDownloadedFileWithDownloadModel:downloadModel];
}
- (BOOL)fileIsExit:(NSString *)filePath andName:(NSString *)fileName{
    CXAnnexDownloadModel *downloadModel = [[CXAnnexDownloadModel alloc]init];
    NSString *name = [fileName componentsSeparatedByString:@"."].firstObject;
    downloadModel.fileDirectory = [filePath stringByAppendingPathComponent:name];
    downloadModel.filePath = [downloadModel.fileDirectory stringByAppendingPathComponent:fileName];
    return [self sw_hasDownloadedFileWithDownloadModel:downloadModel];
}
- (downloadStatus)fileDownloadSatus:(CXAnnexDownloadModel *)downloadModel{
    __block bool found = NO;
    if(self.downloadDic[downloadModel.resourceURLString]){
        return downloading;
    }else if (self.unStartTaskArray.count ||self.downLoadingTaskArray.count){
        if(self.unStartTaskArray.count){
            [self.unStartTaskArray enumerateObjectsUsingBlock:^(CXAnnexDownloadModel *model, NSUInteger idx, BOOL *stop){
                if([model.resourceURLString isEqualToString:downloadModel.resourceURLString]){
                    found = YES;
                    *stop = YES;
                }
                }];
            if(found) return waiting;
        }
        if(self.downLoadingTaskArray.count){
            [self.unStartTaskArray enumerateObjectsUsingBlock:^(CXAnnexDownloadModel *model, NSUInteger idx, BOOL *stop){
                    if([model.resourceURLString isEqualToString:downloadModel.resourceURLString]){
                        found = YES;
                        *stop = YES;
                    }
            }];
            if(found) return waiting;
        }
    }
    if(!found){
        if(downloadModel.filePath){
            BOOL isDownload = [self sw_hasDownloadedFileWithDownloadModel:downloadModel];
            if (isDownload) return hasDownload;
        }else{
            BOOL isDownload = [self fileIsExit:downloadModel.fileName];
            if (isDownload) return hasDownload;
        }
    
    }
    return notFound;
}
- (BOOL)sw_hasDownloadedFileWithDownloadModel:(CXAnnexDownloadModel *)model{
    if([self.fileManager fileExistsAtPath:model.filePath]){
        NSLog(@"已下载的文件, filePath is %@", model.filePath);
        return YES;
    }
    return NO;
}
- (unsigned long long)getToatalCacheSize{
    NSEnumerator *filePaths = [self.fileManager enumeratorAtPath:self.downloadDirectory];
    unsigned long long totalSize = 0;
    NSString *filePath = nil;
    while ((filePath = [filePaths nextObject]) !=nil) {
        filePath = [self.downloadDirectory stringByAppendingPathComponent:filePath];
        NSString *subpath = nil;
        NSEnumerator *subFilePaths = [self.fileManager enumeratorAtPath:filePath];
        while ((subpath = [subFilePaths nextObject]) != nil) {
            subpath = [filePath stringByAppendingPathComponent:subpath];
            if ([self.fileManager fileExistsAtPath:subpath]) {
                totalSize += [[self.fileManager attributesOfItemAtPath:subpath error:nil] fileSize];
            }
        }
    }
    return totalSize;
}
- (void)clearCacheData{
    NSEnumerator *filePaths = [self.fileManager enumeratorAtPath:self.downloadDirectory];
    NSString *filePath = nil;
    while ((filePath = [filePaths nextObject]) !=nil) {
        filePath = [self.downloadDirectory stringByAppendingPathComponent:filePath];
        NSString *subpath = nil;
        NSEnumerator *subFilePaths = [self.fileManager enumeratorAtPath:filePath];
        while ((subpath = [subFilePaths nextObject]) != nil) {
            subpath = [filePath stringByAppendingPathComponent:subpath];
            if ([self.fileManager fileExistsAtPath:subpath]) {
                [self.fileManager removeItemAtPath:subpath error:nil];
            }
        }
        [self.fileManager removeItemAtPath:filePath error:nil];
    }

}
#pragma mark - 数据懒加载
- (NSMutableArray *)unStartTaskArray{
    if(nil == _unStartTaskArray){
        _unStartTaskArray = @[].mutableCopy;
    }
    return _unStartTaskArray;
}
- (NSMutableArray *)downLoadingTaskArray{
    if(nil == _downLoadingTaskArray){
        _downLoadingTaskArray = @[].mutableCopy;
    }
    return _downLoadingTaskArray;
}
- (NSMutableArray *)endDownLoadTaskArray{
    if(nil == _endDownLoadTaskArray){
        _endDownLoadTaskArray = @[].mutableCopy;
    }
    return _endDownLoadTaskArray;
}
- (AFNetworkReachabilityManager *)netWorkStatusManager{
    if(nil == _netWorkStatusManager){
        _netWorkStatusManager = [AFNetworkReachabilityManager sharedManager];
    }
    return _netWorkStatusManager;
}
- (NSMutableDictionary *)downloadDic{
    if(nil == _downloadDic){
        _downloadDic = [NSMutableDictionary dictionary];
    }
    return _downloadDic;
    
}
- (void)dealloc{
    NSLog(@"附件下载管理dealloc");
}
@end
