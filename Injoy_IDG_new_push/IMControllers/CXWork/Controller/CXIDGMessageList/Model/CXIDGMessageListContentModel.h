//
//  CXIDGMessageListContentModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGMessageListContentModel : NSObject

/** btype btype Long 2=休假 */
@property (nonatomic, strong) NSNumber * btype;
/** msg 内容 Sring */
@property (nonatomic, copy) NSString * msg;
/** appId 休假详情ID Sring */
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * applyId;
/** title 标题 String */
@property (nonatomic, copy) NSString * title;
/** approvalTime 批审时间 String */
@property (nonatomic, copy) NSString * approvalTime;
/** approveId 批审id Long 点击详情使用这个ID，调用的我批审详情接口 */
@property (nonatomic, strong) NSNumber * approveId;

@end
