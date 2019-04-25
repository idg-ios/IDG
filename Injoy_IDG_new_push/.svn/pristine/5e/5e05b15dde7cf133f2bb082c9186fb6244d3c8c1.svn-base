//
//  CXZJYXLGSSearchView.h
//  InjoyIDG
//
//  Created by wtz on 2018/5/22.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXZJYXLGSSearchView : UIView

/**
 搜索的回调
 @param s_projManager       选中的项目经理account
 @param s_indusType         选中的行业
 @param keyword             搜索关键字
 */
@property (nonatomic, copy) void(^onSearchCallback)(NSString *s_projManager, NSString *s_indusType, NSString *keyword);

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
