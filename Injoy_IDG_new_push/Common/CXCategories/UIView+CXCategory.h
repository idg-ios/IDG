//
//  UIView+CXCategory.h
//  SDMarketingManagement
//
//  Created by lancely on 5/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CXCategory)

@property (readonly) BOOL isDisplayedInScreen;

- (void)disableTouchesDelay;

/** 添加小红点 */
- (void)addBadge;
/** 添加数字小红点 */
- (void)addNumBadge:(NSString *)typeParam, ...;
- (void)addMeNumBadgeWithText:(NSString *)text;
- (NSInteger)countNumBadge:(NSString *)typeParam, ...;
- (void)getNumBadge:(NSInteger)msgCount;
/** 移除小红点 */
- (void)removeBadge;

/** 添加空数据的提示 */
- (void)addEmptyTipWithAttentionText:(NSString *)attentionText;
/** 移除空数据的提示 */
- (void)removeEmptyTip;
/**
 通过数据条数控制是否显示空数据的提示

 @param dataCount 数据条数
 */
- (void)setNeedShowEmptyTipByCount:(NSInteger)dataCount;
/**
 返回400时候的提示语
 @param Text
 */
- (void)setNeedShowAttentionText:(NSString *)text;

/**
 通过数据条数控制是否显示空数据的提示
 
 @param dataCount 数据条数
 
 @param pictureName 图片名字
 
 @param attentionText 提示语
 */
- (void)setNeedShowEmptyTipAndEmptyPictureByCount:(NSInteger)dataCount AndPictureName:(NSString *)pictureName AndAttentionText:(NSString *)attentionText;
/**
 返回400时候的提示语
 @param Text
 */
- (void)setNeedShowAttentionAndEmptyPictureText:(NSString *)text AndPictureName:(NSString *)pictureName;

/**
 给 view 添加分享按钮
 
 @param shareTitle 分享标题
 @param shareContent 分享内容
 @param shareUrl 分享 url
 @return 分享按钮
 */
- (UIButton *)setShareButtonWithTitle:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl;

/**
 给 view 添加分享按钮
 
 @param shareTitle 分享标题
 @param shareContent 分享内容
 @param shareUrl 分享 url
 @param dataCount 数据条数
 @return 分享按钮
 */
- (UIButton *)setShareButtonWithTitle:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl dataCount:(NSInteger)dataCount;

/**
 移除分享按钮
 */
- (void)removeShareButton;

@end
