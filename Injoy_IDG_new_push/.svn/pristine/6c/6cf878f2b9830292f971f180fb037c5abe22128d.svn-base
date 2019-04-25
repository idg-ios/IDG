//
//  CXHttpRequest.m
//  SDMarketingManagement
//
//  Created by Rao on 16/7/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AFNetworking.h"
#import "CXHttpRequest.h"
#import "SDWebSocketManager.h"

@interface CXHttpRequest ()
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation CXHttpRequest

#pragma mark - get & set

- (AFHTTPRequestOperationManager *)manager {
    if (nil == _manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
        _manager.responseSerializer = responseSerializer;
    }
    return _manager;
}

#pragma mark - function

/// 给url添加后缀
+ (NSString *)suffixUrl:(NSString *)url WithStr:(NSString *)str {
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    url= [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [url stringByAppendingString:str];
}

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(CXHttpSuccessBlock)success
    failure:(CXHttpFailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [self manager];
    url = [self.class suffixUrl:url WithStr:@".json"];

    NSLog(@"当前请求的url是=>：%@", url);
    NSLog(@"当前请求的参数是=>：%@", params);

    [mgr GET:url
  parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
             if ([[responseObject valueForKey:@"status"] intValue] == 509) {
                 CXAlert(@"登陆超时,请重新登录");
                 [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                 ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                 [[CXIMService sharedInstance] logout];
                 [[SDWebSocketManager shareWebSocketManager] closeSocket];
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
             } else {
                 success(responseObject);
             }
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(CXHttpSuccessBlock)success
     failure:(CXHttpFailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = self.manager;
    url = [self.class suffixUrl:url WithStr:@".json"];

    NSLog(@"当前请求的url是=>：%@", url);
    NSLog(@"当前请求的参数是=>：%@", params);

    [mgr POST:url
   parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
              if ([[responseObject valueForKey:@"status"] intValue] == 509) {
                  CXAlert(@"登陆超时,请重新登录");
                  [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                  ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                  [[CXIMService sharedInstance] logout];
                  [[SDWebSocketManager shareWebSocketManager] closeSocket];
                  [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
              } else {
                  success(responseObject);
              }
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

/*!
 @method
 @brief 多部分上传
 @pram dataAry [SDUploadFileModel的集合]
 */
- (void)multipartPostFileDataWithPath:(NSString *)url
                               params:(NSDictionary *)params
                              dataAry:(NSArray *)dataAry
                              success:(CXHttpSuccessBlock)success
                              failure:(CXHttpFailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = self.manager;
    url = [self.class suffixUrl:url WithStr:@".json"];

    NSLog(@"当前请求的url是=>：%@", url);
    NSLog(@"当前请求的参数是=>：%@", params);

    [mgr             POST:url parameters:params
constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
    for (SDUploadFileModel *uploadModel in dataAry) {
        [formData appendPartWithFileData:uploadModel.fileData name:@"fileShow" fileName:uploadModel.fileName mimeType:uploadModel.mimeType];
    }
}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      if (success) {
                          NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
                          if ([[responseObject valueForKey:@"status"] intValue] == 509) {
                              CXAlert(@"登陆超时,请重新登录");
                              [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                              ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                              [[CXIMService sharedInstance] logout];
                              [[SDWebSocketManager shareWebSocketManager] closeSocket];
                              [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                          } else {
                              success(responseObject);
                          }
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
}

/**
 *  多部分多文件上传
 *
 *  @param path    路径
 *  @param params  参数
 *  @param files   文件数组（以表单name为key, SDUploadFileModel数组为value）
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)multipartPostWithPath:(NSString *)path
                       params:(NSDictionary *)params
                        files:(NSDictionary<NSString *, NSArray<SDUploadFileModel *> *> *)files
                      success:(CXHttpSuccessBlock)success
                      failure:(CXHttpFailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = self.manager;
    path = [self.class suffixUrl:path WithStr:@".json"];

    NSLog(@"当前请求的url是=>：%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    [mgr             POST:path
               parameters:params
constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
    [files enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSArray<SDUploadFileModel *> *fileModels, BOOL *stop) {
        [fileModels enumerateObjectsUsingBlock:^(SDUploadFileModel *file, NSUInteger idx2, BOOL *stop) {
            [formData appendPartWithFileData:file.fileData name:name fileName:file.fileName mimeType:file.mimeType];
        }];
    }];
}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      if (success) {
                          NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
                          if ([[responseObject valueForKey:@"status"] intValue] == 509) {
                              CXAlert(@"登陆超时,请重新登录");
                              [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                              ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                              [[CXIMService sharedInstance] logout];
                              [[SDWebSocketManager shareWebSocketManager] closeSocket];
                              [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                          } else {
                              success(responseObject);
                          }
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
}

@end
