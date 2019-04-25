//
//  CXERPTableView.h
//  InjoyERP
//
//  Created by cheng on 16/10/19.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXListViewStyle) {
    /** 新版样式(横线)，默认 */
    CXListViewStyleNew,
    /** 旧版样式(横线+竖线) */
    CXListViewStyleOld
};

typedef void (^headderViewSearchClick)();

@protocol CXListViewDataSource;
@protocol CXListViewDelegate;

/**
 ERP的列表视图
 */
@interface CXListView : UIView

/** 列标题 */
@property(nonatomic, copy) NSArray<NSString *> *titles;
/** 列宽度(pt) */
@property(nonatomic, copy) NSArray<NSNumber *> *widths;
/** 冻结列数(默认是0,不冻结) */
@property(nonatomic, assign) int frozenColumns;
/** 数据源 */
@property(nonatomic, weak) id <CXListViewDataSource> dataSource;
/** 代理 */
@property(nonatomic, weak) id <CXListViewDelegate> delegate;
/** 内间距(默认是0) */
@property(nonatomic, assign) UIEdgeInsets padding;
/** 弹簧效果(默认是yes) */
@property(nonatomic, assign) BOOL bounces;
/** 标题视图背景色 */
@property(nonatomic, strong) UIColor *titleViewBackgroundColor;
/** 分割线颜色 */
@property(nonatomic, strong) UIColor *lineColor;
/** 显示搜索按钮*/
@property(nonatomic, assign) BOOL showSearchButton;
/** 显示合计(默认是NO) */
@property(nonatomic, assign) BOOL showSummaryView;
@property(weak, nonatomic, readonly) UITableView *weakRightTableView;
/** 滚动区 */
@property(nonatomic, strong) UIScrollView *scrollView;

/** 是否启用刷新控件（默认是YES） */
@property(nonatomic, assign, getter=isRefreshComponentEnabled) BOOL refreshComponentEnabled;

/** 控件样式，默认是CXListViewStyleNew */
@property (nonatomic, assign) CXListViewStyle style;

/** 添加按钮比例*/
//@property(nonatomic, assign) CGFloat addButtonRate;

/** 搜索视图点击代理方法*/
@property(nonatomic, copy) headderViewSearchClick searchClick;

//我的设置界面
@property(nonatomic, assign) BOOL isFromSetting;


/** 重新加载数据 */
- (void)reloadData;

/** 开始刷新 */
- (void)beginRefreshing;

/** 头部结束刷新 */
- (void)headerEndRefreshing;

/** 尾部结束刷新 */
- (void)footerEndRefreshing;

/** 是否还有下一页数据 */
- (void)setHasMoreData:(BOOL)hasMoreData;

@end

/** 数据源方法 */
@protocol CXListViewDataSource <NSObject>

/**
 列表视图数据行数

 @param listView 列表视图实例

 @return 返回行数
 */
- (NSInteger)numberOfRowsInListView:(CXListView *)listView;

/**
 列表视图某行的各列内容

 @param listView 列表视图实例
 @param rowIndex 行号

 @return 内容数组(对应列数，支持NSString、UIImage、__kindof UIView)
 */
- (NSArray<id> *)listView:(CXListView *)listView contentsForRow:(NSInteger)rowIndex;


@optional
/**
 列表视图合计内容

 @param listView 列表视图实例
 @param _        并没有什么x用

 @return 内容数组
 */
- (NSArray<NSString *> *)listView:(CXListView *)listView contentsForSummaryView:(void *)_;

@end

/** 代理方法 */
@protocol CXListViewDelegate <NSObject>

@optional
/**
 选中了一行

 @param listView 列表视图实例
 @param rowIndex 行号
 */
- (void)listView:(CXListView *)listView didSelectRowAtIndex:(NSInteger)rowIndex;

/**
 选中了一行

 @param listView 列表视图实例
 @param rowIndex 行号
 @param columnIndex 列号(columnIndex的值不包括冻结的列.column是指可以滚动的列表的索引)
 */
- (void)listView:(CXListView *)listView didSelectRowAtIndex:(NSInteger)rowIndex atColumnIndex:(int)columnIndex;

/**
 点击了标题

 @param listView   列表视图实例
 @param titleLabel 被点击的标题
 @param index      标题的索引
 */
- (void)listView:(CXListView *)listView didTapTitleLabel:(UILabel *)titleLabel atIndex:(NSInteger)index;

/**
 cell背景色
 @param listView 列表视图实例
 @param rowIndex 行号

 @return 颜色
 */
- (UIColor *)listView:(CXListView *)listView cellBackgroundColorForRow:(NSInteger)rowIndex;

/**
 cell 底部水平分割线的高度

 @param listView listView
 @param rowIndex 行号
 @return 高度
 */
- (CGFloat)listView:(CXListView *)listView cellSeparatorLineHeightForRow:(NSInteger)rowIndex;

/**
 下拉刷新
 */
- (void)listView:(CXListView *)listView beginRefreshing:(void *)_;

/**
 上拉加载
 */
- (void)listView:(CXListView *)listView beginLoadMore:(void *)_;

@end
