//
//  HttpTool.m
//  httpTool2
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 baidu. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>yaogai gaiwanle

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "SDWebSocketManager.h"

@implementation HttpTool

/*!
 @method
 @brief 多部分上传
 @pram dataAry SDUploadFileModel的集合
 */
+ (void)multipartPostFileDataWithPath:(NSString*)path params:(NSDictionary*)params dataAry:(NSMutableArray*)dataAry success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];

    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【MultipartPost】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager POST:path
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (SDUploadFileModel* uploadModel in dataAry) {
                [formData appendPartWithFileData:uploadModel.fileData name:@"fileShow" fileName:uploadModel.fileName mimeType:uploadModel.mimeType];
            }
        }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {

            NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic valueForKey:@"status"] intValue] == 509) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                [[CXIMService sharedInstance] logout];
                [[SDWebSocketManager shareWebSocketManager] closeSocket];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
            else {
                success(dic);
            }

            NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)multipartPostWithPath:(NSString*)path params:(NSDictionary*)params files:(NSDictionary<NSString*, NSArray<SDUploadFileModel*>*>*)files success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【MultipartPost】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];

    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager POST:path
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [files enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull name, NSArray<SDUploadFileModel*>* _Nonnull fileModels, BOOL* _Nonnull stop) {
                [fileModels enumerateObjectsUsingBlock:^(SDUploadFileModel* _Nonnull file, NSUInteger idx2, BOOL* _Nonnull stop) {
                    [formData appendPartWithFileData:file.fileData name:name fileName:file.fileName mimeType:file.mimeType];
                }];
            }];
        }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {

            NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic valueForKey:@"status"] intValue] == 509) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                [[CXIMService sharedInstance] logout];
                [[SDWebSocketManager shareWebSocketManager] closeSocket];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
            else {
                success(dic);
            }

            NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)httpPostPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【POST】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager POST:path
        parameters:params
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
            success(operation.responseString);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)postWithPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【POST】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager POST:path
        parameters:params
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
            NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic valueForKey:@"status"] intValue] == 509) {
                if(![[dic valueForKey:@"msg"] isEqualToString:@"登录超时"]){
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                [[CXIMService sharedInstance] logout];
                [[SDWebSocketManager shareWebSocketManager] closeSocket];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];

            }
            else {
                success(dic);
            }
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)getWithPath:(NSString*)path params:(NSDictionary*)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【GET】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];
    
    [manager GET:path
        parameters:params
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
            NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic valueForKey:@"status"] intValue] == 509) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
                [[CXIMService sharedInstance] logout];
                [[SDWebSocketManager shareWebSocketManager] closeSocket];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
            else {
                success(dic);
            }

        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)putWithPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：%@【PUT】", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager PUT:path parameters:params success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
        NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic valueForKey:@"status"] intValue] == 509) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
            [[CXIMService sharedInstance] logout];
            [[SDWebSocketManager shareWebSocketManager] closeSocket];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        else {
            success(dic);
        }

    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

+ (void)deleteWithPath:(NSString*)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //    NSLog(@"\r\n=>url:%@", path);
    path = [self suffixUrl:path WithStr:@".json"];
    //    if (params) {
    //        NSLog(@"\r\n=>params:%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
    //    }

    NSLog(@"当前请求的url是=>：【DELETE】%@", path);
    NSLog(@"当前请求的参数是=>：%@", params);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [manager setResponseSerializer:responseSerializer];

    [manager DELETE:path parameters:params success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"当前请求的结果是:%@\r\n", operation.responseString);
        NSData* JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic valueForKey:@"status"] intValue] == 509) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
            [[CXIMService sharedInstance] logout];
            [[SDWebSocketManager shareWebSocketManager] closeSocket];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        else {
            success(dic);
        }

    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(error);
        }];
}

//保存工作轨迹
+ (void)saveTrajectoryDataByLocation:(NSString*)location
{
    if (!location.length) {
        return;
    }

    NSMutableDictionary* requstDict = [NSMutableDictionary dictionaryWithCapacity:4];
    NSArray* locationArray = [location componentsSeparatedByString:@","];

    if (locationArray.count < 3) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:@"location"];
    [requstDict setObject:[locationArray firstObject] forKey:@"address"];
    [requstDict setObject:[NSString stringWithFormat:@"%@,%@", locationArray[1], locationArray[2]] forKey:@"position"];
    //    [requstDict setObject:[AppDelegate getUserID] forKey:@"userId"];
    //    [requstDict setObject:[AppDelegate getCompanyID] forKey:@"companyId"];
    [requstDict setValue:[AppDelegate getUserID] forKey:@"userId"];
    [requstDict setValue:[AppDelegate getCompanyID] forKey:@"companyId"];

    NSString* urlString = [NSString stringWithFormat:@"%@trackserver/track", urlPrefix];

    [self postWithPath:urlString params:requstDict success:^(id JSON) {
        NSDictionary* jsonDict = JSON;
        if ([jsonDict[@"status"] intValue] == 200) {
            NSLog(@"工作轨迹保存成功");
        }
        else {
            NSLog(@"工作轨迹保存失败,错误500");
        }
    }
        failure:^(NSError* error) {
            NSLog(@"工作轨迹保存失败");
        }];
}

// 给url添加后缀
+ (NSString*)suffixUrl:(NSString*)url WithStr:(NSString*)str
{
    // 去掉多余的/
    url = [url stringByReplacingOccurrencesOfString:urlPrefix withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    // 去掉结尾的/
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    url = [urlPrefix stringByAppendingString:url];
    // 添加url后缀
    if (![url hasSuffix:str]) {
        url = [url stringByAppendingString:str];
    }
    url= [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    return url;
}

@end
