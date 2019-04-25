//
//  CXIDGNewTZGGListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/6/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGNewTZGGListModel : NSObject

/** cover 缩略图图片 Sring */
@property (nonatomic, copy) NSString * cover;
/** thumb_url_height */
@property (nonatomic, strong) NSNumber * thumb_url_height;
/** thumb_url_width */
@property (nonatomic, strong) NSNumber * thumb_url_width;
/** title 标题 String */
@property (nonatomic, copy) NSString * title;
/** url 详情H5URL Sring */
@property (nonatomic, copy) NSString * url;
/** remark 消息摘要 String */
@property (nonatomic, copy) NSString * remark;
/** createTime 时间 String */
@property (nonatomic, copy) NSString * createTime;
/** eid id String */
@property (nonatomic, copy) NSString * eid;
/** createId id String */
@property (nonatomic, copy) NSString * createId;

@end
