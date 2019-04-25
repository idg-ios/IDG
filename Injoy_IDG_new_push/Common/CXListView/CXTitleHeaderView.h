//
//  CXTitleHeaderView.h
//  SDMarketingManagement
//
//  Created by cheng on 5/6/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXTitleHeaderView;
#define kCXTitleHeaderViewHeight kFormHeaderHeight

@protocol CXTitleHeaderViewDelegate<NSObject>

@optional
- (void)titleHeaderViewClickInLastLabel;


/**
 点击了搜索按钮

 @param headerView   头部视图
 @param searchButton 搜索按钮
 */
- (void)titleHeaderView:(CXTitleHeaderView *)headerView didTapSearchButton:(UIButton *)searchButton;

/**
 点击了标题

 @param headerView 头部视图
 @param titleLabel 被点击的标题
 @param index      标题所在的索引
 */
- (void)titleHeaderView:(CXTitleHeaderView *)headerView didTapTitleLabel:(UILabel *)titleLabel atIndex:(NSInteger)index;

@end

/** 公共的标题头view */
@interface CXTitleHeaderView : UIView

/**
 *  实例化方法
 *
 *  @param titles      标题数组
 *  @param widthRatios 每一列宽度比例
 *
 *  @return 对象
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles widthRatios:(NSArray<NSNumber *> *)widthRatios;
/**
 *  实例化方法
 *
 *  @param titles      标题数组
 *  @param widthRatios 每一列宽度
 *
 *  @return 对象
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths;

/**
 *  实例化方法
 *
 *  @param titles      标题数组
 *  @param widthRatios 每一列宽度比例
 *
 *  @return 对象
 */
+ (instancetype)headerViewWithTitles:(NSArray<NSString *> *)titles widthRatios:(NSArray<NSNumber *> *)widthRatios;
/**
 *  实例化方法
 *
 *  @param titles      标题数组
 *  @param widthRatios 每一列宽度比例
 *
 *  @return 对象
 */
+ (instancetype)headerViewWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths;

/** 自定义线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 是否显示搜索按钮(默认是NO) */
@property (nonatomic, assign) BOOL showSearchButton;

//初始设置界面
@property (nonatomic, assign) BOOL isFromSetting;

//代理协议方法
@property (nonatomic, weak) id<CXTitleHeaderViewDelegate> delegate;
/** Label数组 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *textLabels;
@end
