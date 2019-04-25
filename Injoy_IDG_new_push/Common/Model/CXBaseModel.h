//
// Created by ___ on 2017/8/10.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface CXBaseModel : NSObject <YYModel>
/// 当前页码
@property(nonatomic, assign) int pageNumber;
/// 总条数
@property(nonatomic, assign) int total;
/// 服务器返回状态码
@property(assign, nonatomic) int status;
/// 一共有多少页
@property(assign, nonatomic) int totalPage;
/// 返回请求的说明
@property(copy, nonatomic) NSString *msg;
/// 数据
@property(strong, nonatomic) CXBaseModel *data;
/// 分享URL
@property(copy, nonatomic) NSString *shareUrl;
/// 唯一ID
@property(assign, nonatomic) long eid;
/// 附件
@property(copy, nonatomic) NSArray *annexList;
/// 抄送
@property(copy, nonatomic) NSArray *ccList;
@end