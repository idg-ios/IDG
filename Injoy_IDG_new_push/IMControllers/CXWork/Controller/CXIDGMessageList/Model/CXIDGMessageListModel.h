//
//  CXIDGMessageListModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIDGMessageListContentModel.h"

@interface CXIDGMessageListModel : NSObject

/** btype btype Long 2=休假 */
@property (nonatomic, strong) NSNumber * btype;
/** content 数据内容 String */
@property (nonatomic, copy) NSString * content;
/** createTime 时间 Sring 列表上的时间用这个显示 */
@property (nonatomic, copy) NSString * createTime;
/** eid id Long */
@property (nonatomic, strong) NSNumber * eid;
/** contentModel */
@property (nonatomic, strong) CXIDGMessageListContentModel * contentModel;


@end
