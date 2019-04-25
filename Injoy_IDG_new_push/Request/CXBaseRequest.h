//
//  CXBaseRequest.h
//  SDMarketingManagement
//
//  Created by Rao on 16/7/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXHttpRequest.h"
#import <Foundation/Foundation.h>

#define HTTPSUCCESSOK 200

@interface CXBaseRequest : NSObject

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
                 failure:(CXHttpFailureBlock)failure;

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
                  failure:(CXHttpFailureBlock)failure;

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
                      failure:(CXHttpFailureBlock)failure;

/*!
 @method
 @brief 多部分上传
 @pram dataAry [SDUploadFileModel的集合]
 */
+ (void)multipartPostFileDataWithPath:(NSString *)url
                               params:(NSDictionary *)params
                              dataAry:(NSArray *)dataAry
                              success:(CXHttpSuccessBlock)success
                              failure:(CXHttpFailureBlock)failure;

@end
