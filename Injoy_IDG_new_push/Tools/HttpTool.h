//
//  HttpTool.h
//  httpTool2
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "SDUploadFileModel.h"
#import <Foundation/Foundation.h>

/** http返回状态 */
typedef NS_ENUM(int, HTTPResponseStatus) {
    /** 成功 */
    HTTPResponse_OK = 200,
    /** 服务器遇到了一个未曾预料的状况，导致了它无法完成对请求的处理 */
    HTTPResponse_InternalServerError = 500,
    /** 请求失败，请求所希望得到的资源未被在服务器上发现 */
    HTTPResponse_NotFound = 404,
    /// 记录不存在
    HTTPResponse_NOT_EXIST_ERROR = 501,
    /// 已存在记录
    HTTPResponse_EXIST_ERROR = 502,
    /// 登陆错误
    HTTPResponse_LOGIN_ERROR = 503,
    /// 参数不合法
    HTTPResponse_VALIDATOR_ERROR = 504,
    /// 参数超时
    HTTPResponse_TIME_OUT_ERROR = 505,
    /// 请求过于频繁
    HTTPResponse_BUSYNESS_ERROR = 506,
    // IM服务器错误
    HTTPResponse_IM_SERVER_ERROR = 507
};

@interface HttpTool : NSObject
typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError* error);

/**
 *  多部分多文件上传
 *
 *  @param path    路径
 *  @param params  参数
 *  @param files   文件数组（以表单name为key, SDUploadFileModel数组为value）
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)multipartPostWithPath:(NSString*)path params:(NSDictionary*)params files:(NSDictionary<NSString*, NSArray<SDUploadFileModel*>*>*)files success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/*!
 @method
 @brief 多部分上传
 @pram dataAry [SDUploadFileModel的集合]
 */
+ (void)multipartPostFileDataWithPath:(NSString*)path params:(NSDictionary*)params dataAry:(NSArray*)dataAry success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)postWithPath:(NSString*)path params:(NSDictionary*)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)getWithPath:(NSString*)path params:(NSDictionary*)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)httpPostPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)putWithPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)deleteWithPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

//保存工作轨迹
+ (void)saveTrajectoryDataByLocation:(NSString*)location;

+ (NSString*)suffixUrl:(NSString*)url WithStr:(NSString*)str;

@end
