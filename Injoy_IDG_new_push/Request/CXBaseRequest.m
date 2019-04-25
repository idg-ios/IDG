//
//  CXBaseRequest.m
//  SDMarketingManagement
//
//  Created by Rao on 16/7/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXBaseRequest.h"

@implementation CXBaseRequest

/**
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param success      请求成功后的回调
 *  @param failure      请求失败后的回调
 */
+ (void)getResultWithUrl:(NSString *)url
                   param:(id)param
                 success:(CXHttpSuccessBlock)success
                 failure:(CXHttpFailureBlock)failure {
    CXHttpRequest *httpRequest = [[CXHttpRequest alloc] init];

    [httpRequest get:url
              params:param
             success:^(id responseObj) {
                 if (success) {
                     success(responseObj);
                 }
             }
             failure:^(NSError *error) {
                 if (failure) {
                     failure(error);
                 }
             }];
}

/**
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param success      请求成功后的回调
 *  @param failure      请求失败后的回调
 */
+ (void)postResultWithUrl:(NSString *)url
                    param:(id)param
                  success:(CXHttpSuccessBlock)success
                  failure:(CXHttpFailureBlock)failure {
    CXHttpRequest *httpRequest = [[CXHttpRequest alloc] init];

    [httpRequest post:url
               params:param
              success:^(id responseObj) {
                  if (success) {
                      success(responseObj);
                  }
              }
              failure:^(NSError *error) {
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
+ (void)multipartPostWithPath:(NSString *)path
                       params:(NSDictionary *)params
                        files:(NSDictionary<NSString *, NSArray<SDUploadFileModel *> *> *)files
                      success:(CXHttpSuccessBlock)success
                      failure:(CXHttpFailureBlock)failure {
    CXHttpRequest *httpRequest = [[CXHttpRequest alloc] init];

    [httpRequest multipartPostWithPath:path
                                params:params
                                 files:files
                               success:^(id responseObj) {
                                   if (success) {
                                       success(responseObj);
                                   }
                               }
                               failure:^(NSError *error) {
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
+ (void)multipartPostFileDataWithPath:(NSString *)url
                               params:(NSDictionary *)params
                              dataAry:(NSArray *)dataAry
                              success:(CXHttpSuccessBlock)success
                              failure:(CXHttpFailureBlock)failure {
    CXHttpRequest *httpRequest = [[CXHttpRequest alloc] init];

    [httpRequest multipartPostFileDataWithPath:url
                                        params:params
                                       dataAry:dataAry
                                       success:^(id responseObj) {
                                           if (success) {
                                               success(responseObj);
                                           }
                                       }
                                       failure:^(NSError *error) {
                                           if (failure) {
                                               failure(error);
                                           }
                                       }];
}

@end
