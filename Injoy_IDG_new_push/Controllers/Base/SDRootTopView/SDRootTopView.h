//
//  SDRootTopView.h
//  SDMarketingManagement
//
//  Created by fanzhong on 15/4/25.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDRootTopView : UIView
@property(weak, nonatomic) IBOutlet UILabel *tipsLabel;
/// 顶部logo视图
@property(weak, nonatomic) IBOutlet UIImageView *topLogoImageView;
@property(weak, nonatomic) IBOutlet UILabel *navTitleLabel;

/// 设置标题
- (void)setNavTitle:(NSString *)title;

/// 设置富文本标题
- (void)setAttributeNavTitle:(NSString *)title withInteger:(int)length;

/// 设置logo显示
- (void)setTopLogoImageViewShowOrHidden:(BOOL)bl;

/// 设置导航左边按钮.使用图片
- (void)setUpLeftBarItemImage:(UIImage *)leftImage addTarget:(id)target action:(SEL)action;

/// 设置导航左边按钮.使用文字
- (void)setUpLeftBarItemTitle:(NSString *)leftTitle addTarget:(id)target action:(SEL)action;

/** 设置左边按钮为返回 */
- (void)setUpLeftBarItemGoBack;

/// 设置导航右边按钮.使用图片
- (void)setUpRightBarItemImage:(UIImage *)rightImage addTarget:(id)target action:(SEL)action;

- (void)setUpRightBarItemImage2:(UIImage *)rightImage2 addTarget:(id)target action:(SEL)action;

/// 设置导航右边按钮.使用文字
- (void)setUpRightBarItemTitle:(NSString *)rightTitle addTarget:(id)target action:(SEL)action;

/** 移除右边的按钮 */
- (void)removeRightBarItem;

@end
