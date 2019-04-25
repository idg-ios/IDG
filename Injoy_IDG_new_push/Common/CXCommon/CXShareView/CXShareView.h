//
//  CXShareView.h
//  InjoyCRM
//
//  Created by cheng on 16/8/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 分享视图 */
@interface CXShareView : UIView

/** 分享标题 */
@property(nonatomic, copy) NSString *shareTitle;
/** 分享内容 */
@property(nonatomic, copy) NSString *shareContent;
/** 分享网址 */
@property(nonatomic, copy) NSString *shareUrl;
/** 是否能分享到APP（默认YES） */
@property (nonatomic, assign, getter=isShareToAppEnabled) BOOL shareToAppEnabled;
/** 需要付费才能分享（默认YES） */
@property (nonatomic, assign, getter=isNeedPay) BOOL needPay;

/** 创建实例 */
+ (instancetype)view;

/** 显示分享视图 */
- (void)show;

/**
 *  显示分享视图
 *
 *  @param view 容器视图
 */
//- (void)showInView:(__kindof UIView *)view;

/** 关闭 */
- (void)dismiss;

/** 清空分享信息 */
- (void)reset;

@end
