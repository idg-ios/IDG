//
//  CXProjectSearchView.h
//  InjoyIDG
//
//  Created by cheng on 2017/12/16.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 项目管理的搜索视图 */
@interface CXProjectSearchView : UIView



/**
 搜索的回调
 @param selectedState       选中的项目阶段id
 @param selectedIndustry    选中的一级行业id
 @param keyword             搜索关键字
 */
@property (nonatomic, copy) void(^onSearchCallback)(NSArray<NSNumber *> *selectedState, NSArray<NSNumber *> *selectedIndustry, NSString *keyword);

@property (nonatomic, copy) void(^onSearchStart)(NSString *searchText);

@property (nonatomic, copy) NSString *searchText;
/**
 显示搜索视图

 @param view 在哪个视图中显示
 */
- (void)showInView:(UIView *)view;

/**
 移除搜索视图
 */
- (void)hide;
/**
 隐藏搜索视图
 */
- (void)hidenAllView;
/**
 显示搜索视图
 */
- (void)showAllView;
@end
