//
//  SDBaseModel.h
//  SDMarketingManagement
//
//  Created by Rao on 15-5-26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "YYModel.h"
#import <Foundation/Foundation.h>

@protocol SDBaseModel <YYModel>
@optional

/**< 申请人ID */
@property(assign, nonatomic) long ygId;
/**< 申请人姓名 */
@property(strong, nonatomic) NSString *ygName;
/**< 申请部门ID */
@property(assign, nonatomic) long ygDeptId;
/**< 申请部门 */
@property(copy, nonatomic) NSString *ygDeptName;
/**< 申请人职务 */
@property(copy, nonatomic) NSString *ygJob;
@end

@interface SDBaseModel : NSObject <SDBaseModel>
/// 当前页码
@property(nonatomic) int page;
/// 总条数
@property(nonatomic) int total;
/// 服务器返回状态码
@property(nonatomic) int status;
/// 一共有多少页
@property(nonatomic) int totalPage;
/// 总页数
@property(nonatomic) int pageCount;
/// 返回请求的说明
@property(copy, nonatomic) NSString *msg;
/// 数据
@property(nonatomic, copy) NSArray *data;
/// 返回的data是字典的情况
@property(strong, nonatomic) SDBaseModel *dataExt;
/// 分享URL
@property(copy, nonatomic) NSString *shareUrl;
/// 唯一ID
@property(assign, nonatomic) long eid;
/// 附件
@property(copy, nonatomic) NSArray *annexList;
/// 抄送
@property(copy, nonatomic) NSArray *cc;
@end
