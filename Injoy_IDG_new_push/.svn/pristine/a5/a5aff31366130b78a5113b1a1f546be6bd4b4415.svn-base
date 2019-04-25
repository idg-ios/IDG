//
//  CXTMTProjectSearchView.h
//  InjoyIDG
//
//  Created by wtz on 2018/2/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

/** TMT潜在项目的搜索视图 */
@interface CXTMTProjectSearchView : UIView

/**
 搜索的回调
 @param bgmc                报告名称
 @param zy                  摘要
 @param keyword             搜索关键字
 */
@property (nonatomic, copy) void(^onSearchCallback)(NSString *keyword);

/**
 显示搜索视图
 
 @param view 在哪个视图中显示
 */
- (void)showInView:(UIView *)view;

/**
 隐藏搜索视图
 */
- (void)hide;

@end
