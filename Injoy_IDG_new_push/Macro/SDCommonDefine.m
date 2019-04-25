//
//  SDCommonDefine.m
//  SDMarketingManagement
//
//  Created by Rao on 15/11/19.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDCommonDefine.h"

NSString *urlPrefix;
/** 分享的网址 */
NSString *shareUrlPrefix;
NSString *experienceString;

NSString *kImagePrefix;

@interface SDCommonDefine ()
- (void)setUpDefine:(BOOL)systemUseOrNot;
@end

@implementation SDCommonDefine

static SDCommonDefine *m_instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[self.class alloc] initExt];
    });
    return m_instance;
}

- (instancetype)initExt {
    if (self = [super init]) {
        [self setUpDefine:YES];
    }
    return self;
}

- (void)systemUse {
    [m_instance setUpDefine:YES];
}

- (void)experienceAccount {
    [m_instance setUpDefine:NO];
    
}

- (void)setUpDefine:(BOOL)systemUseOrNot {

#ifdef DEBUG
//    NSString *apiString = @"http://localhost:8080/idg-api"; //微软云网测试环境api
//        NSString* apiString = @"http://192.168.101.16:8080/oa-api"; //子敬台机192.168.101.18
//    NSString* apiString = @"http://192.168.101.45:8080/oa-api"; //伟堂台机
//    NSString* apiString = @"http://192.168.101.58:8080/erp"; //武峰台机
//        NSString* apiString = @"http://192.168.101.236:8080/api"; //内网
//    NSString* apiString = @"http://192.168.101.25:8080/oa-api"; //吴海峰机器测试环境api
//    NSString *apiString = @"http://125.35.46.20:8081/idg-api"; //微软云网测试环境api
//    NSString *apiString = @"http://192.168.105.16:8081/idg-api"; //IDG测试环境api
    //临时公网
    NSString *apiString = @"http://125.35.46.20:8081/idg-api";
    
//    NSString* apiString = @"https://app.idgcapital.com"; // 正式环境

    experienceString = @"https://erpty.injoy360.cn/erp-tiyan"; //正式环境来自体验账号的apiString
    //来自体验账号的api
    NSString *Experience = systemUseOrNot ? apiString : experienceString;
    urlPrefix = [NSString stringWithFormat:@"%@/", Experience]; //本地地址
    shareUrlPrefix = @"http://erpbs.chinacloudapp.cn:8080/erp-bs/";// 测试环境分享
//    shareUrlPrefix = @"http://erpbs.injoy360.cn/erp-bs/";//正式环境分享

    //图片显示是否加前缀
    //kImagePrefix = [urlPrefix substringToIndex:[urlPrefix length] - 1]; //adbadsd需要加网络请求前缀
    kImagePrefix = @""; //不需要加网络前缀

#else
    NSString* apiString = @"https://app.idgcapital.com"; //微软云正式环境api
//    experienceString = @"https://erpty.injoy365.cn/erp-tiyan"; //正式环境来自体验账号的apiString
    NSString* Experience = systemUseOrNot ? apiString : experienceString;
    urlPrefix = [NSString stringWithFormat:@"%@/", Experience]; //本地地址
    shareUrlPrefix = @"http://erpbs.injoy365.cn/erp-bs/";//正式环境分享
    kImagePrefix = @""; //不需要加网络前缀
#endif
}

@end
