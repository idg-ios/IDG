//
//  CXERPTableView.m
//  InjoyERP
//
//  Created by cheng on 16/10/19.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXListView.h"
#import "CXTitleHeaderView.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "CXNormalCell.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"

#define kLeftViewWith 40

@interface CXListView () <UITableViewDataSource, UITableViewDelegate, CXNormalCellDelegate, CXTitleHeaderViewDelegate>


/** 冻结的tableView */
@property(nonatomic, strong) UITableView *leftTableView;
/** 右边可滚动的tableView */
@property(nonatomic, strong) UITableView *rightTableView;
/** 合计view */
@property(nonatomic, strong) UIView *summaryView;
/** 左边的合计 */
@property(nonatomic, strong) CXNormalCell *leftSummaryCell;
/** 右边的合计 */
@property(nonatomic, strong) CXNormalCell *rightSummaryCell;
/** 右边合计的滚动区 */
@property(nonatomic, strong) UIScrollView *rightSummaryScrollView;

@property(nonatomic, copy, readonly) NSArray<NSNumber *> *leftWidthRatios;
@property(nonatomic, copy, readonly) NSArray<NSString *> *leftTitles;
@property(nonatomic, copy, readonly) NSArray<NSNumber *> *rightWidthRatios;
@property(nonatomic, copy, readonly) NSArray<NSString *> *rightTitles;

//添加按钮
@property(nonatomic, strong) UIButton *addButton;

@end

@implementation CXListView {
    /** 真实行数 */
    NSInteger _trulyRows;
    /** 填充行数 */
    NSInteger _fakeRows;
}

#pragma mark - GET SET方法

- (UITableView *)weakRightTableView {
    return self.rightTableView;
}

- (NSArray<NSNumber *> *)leftWidthRatios {
    NSMutableArray<NSNumber *> *wrs = @[].mutableCopy;
    for (int i = 0; i < self.frozenColumns; i++) {
        NSNumber *wr = @(self.widths[i].doubleValue / GET_WIDTH(self.leftTableView));
        [wrs addObject:wr];
    }
    return wrs.copy;
}

- (NSArray<NSString *> *)leftTitles {
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    for (int i = 0; i < self.frozenColumns; i++) {
        [titles addObject:self.titles[i]];
    }
    return titles.copy;
}

- (NSArray<NSNumber *> *)rightWidthRatios {
    NSMutableArray<NSNumber *> *wrs = @[].mutableCopy;
    for (int i = self.frozenColumns; i < self.widths.count; i++) {
        NSNumber *wr = @(self.widths[i].doubleValue / GET_WIDTH(self.rightTableView));
        [wrs addObject:wr];
    }
    return wrs.copy;
}

- (NSArray<NSString *> *)rightTitles {
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    for (int i = self.frozenColumns; i < self.widths.count; i++) {
        [titles addObject:self.titles[i]];
    }
    return titles.copy;
}

- (void)setBounces:(BOOL)bounces {
    self->_bounces = bounces;
    self.leftTableView.bounces = self.scrollView.bounces = self.rightTableView.bounces = bounces;
}

- (void)setShowSummaryView:(BOOL)showSummaryView {
    self->_showSummaryView = showSummaryView;
    self.summaryView.hidden = !showSummaryView;
}

- (void)setFrozenColumns:(int)frozenColumns {
    _frozenColumns = frozenColumns;
    self.refreshComponentEnabled = self.refreshComponentEnabled;
}

- (void)setRefreshComponentEnabled:(BOOL)refreshComponentEnabled {
    self->_refreshComponentEnabled = refreshComponentEnabled;
    if (refreshComponentEnabled) {
        @weakify(self);
        if (self.frozenColumns > 0) {
            [self.leftTableView addLegendHeaderWithRefreshingBlock:^{
                @strongify(self);
                if ([self.delegate respondsToSelector:@selector(listView:beginRefreshing:)]) {
                    [self.delegate listView:self beginRefreshing:NULL];
                }
            }];
            self.leftTableView.header.relativeScrollView = self.rightTableView;
            MJRefreshLegendHeader *rHeader = [self.rightTableView addLegendHeaderWithRefreshingBlock:^{
//                @strongify(self);
//                [self.leftTableView.header beginRefreshing];
            }];
            rHeader.alpha = 0.01001;
            rHeader.relativeScrollView = self.leftTableView;
            if ([self.rightTableView.header respondsToSelector:NSSelectorFromString(@"activityView")]) {
                UIActivityIndicatorView *activityView = [self.rightTableView.header valueForKey:@"activityView"];
                UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
                [emptyView addSubview:activityView];
                emptyView.hidden = YES;
                [self addSubview:emptyView];
            }
            [self.leftTableView addLegendFooterWithRefreshingBlock:^{
                @strongify(self);
                [self.rightTableView.footer beginRefreshing];
                if ([self.delegate respondsToSelector:@selector(listView:beginLoadMore:)]) {
                    [self.delegate listView:self beginLoadMore:NULL];
                }
            }];
            MJRefreshLegendFooter *rFooter = [self.rightTableView addLegendFooterWithRefreshingBlock:^{
                @strongify(self);
                [self.leftTableView.footer beginRefreshing];
            }];
            rFooter.alpha = 0.01001;
        } else {
            [self.rightTableView addLegendHeaderWithRefreshingBlock:^{
                @strongify(self);
                if ([self.delegate respondsToSelector:@selector(listView:beginRefreshing:)]) {
                    [self.delegate listView:self beginRefreshing:NULL];
                }
            }];
            [self.rightTableView addLegendFooterWithRefreshingBlock:^{
                @strongify(self);
                if ([self.delegate respondsToSelector:@selector(listView:beginLoadMore:)]) {
                    [self.delegate listView:self beginLoadMore:NULL];
                }
            }];
        }
        [self setHasMoreData:NO];
    } else {
        [self.leftTableView removeHeader];
        [self.leftTableView removeFooter];
        [self.rightTableView removeHeader];
        [self.rightTableView removeFooter];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *arr = @[].mutableCopy;
    [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull t, NSUInteger idx, BOOL *_Nonnull stop) {
        NSUInteger subtitleIndex = [t rangeOfString:@"(" options:NSBackwardsSearch].location;
        BOOL hasSubtitle = subtitleIndex != NSNotFound;
        NSString *subtitle = hasSubtitle ? [t substringFromIndex:subtitleIndex] : @"";
        NSString *mainTitle = t;
        if (hasSubtitle) {
            mainTitle = [t substringToIndex:subtitleIndex];
        }
        if (mainTitle.length == 2) {
            mainTitle = [NSString stringWithFormat:@"%@ %@", [mainTitle substringToIndex:1], [mainTitle substringFromIndex:1]];
        }
        t = [NSString stringWithFormat:@"%@%@", mainTitle, subtitle];
        [arr addObject:t];
    }];
    _titles = arr.copy;
}

#pragma mark - 重写的方法

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.rightTableView ?: [self setup];
    super.backgroundColor = backgroundColor;
//    self.leftTableView.backgroundColor = backgroundColor;
//    self.scrollView.backgroundColor = backgroundColor;
//    self.rightTableView.backgroundColor = backgroundColor;
    self.summaryView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.leftTableView.backgroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.bounces = YES;
        self.showSummaryView = NO;
        self.refreshComponentEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.style = CXListViewStyleNew;
    }
    return self;
}

#pragma mark - 外部方法

- (void)setup {
    if (self.rightTableView) {
        return;
    }
    self.leftTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.rowHeight = kListCellHeight;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.allowsSelection = YES;
        tableView.clipsToBounds = NO;
        [self disableTouchesDelay:tableView];
        [self addSubview:tableView];
        tableView;
    });

    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self disableTouchesDelay:scrollView];
        [self addSubview:scrollView];
        scrollView;
    });

    self.rightTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = YES;
        tableView.rowHeight = kListCellHeight;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.allowsSelection = YES;
        [self disableTouchesDelay:tableView];
        [self.scrollView addSubview:tableView];
        tableView;
    });

    self.summaryView = ({
        UIView *view = [[UIView alloc] init];
        [self setTopBorder:view];
        [self setBottomBorder:view];
        [self addSubview:view];
        view;
    });

    self.rightSummaryScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.summaryView addSubview:scrollView];
        scrollView;
    });
}

- (void)reloadData {
    if (!self.rightTableView) {
        [self setup];
    }
    NSAssert(self.titles.count == self.widths.count, @"标题列数和宽度列数不匹配");
    if (self.frozenColumns > 0 && self.leftWidthRatios.count > 0) {
        [self.leftTableView reloadData];
    }
    [self.rightTableView reloadData];
    if (self.showSummaryView) {
        [self reloadSummaryData];
    }
    [self layoutSubviews];
    // 防止不同步情况
    [self scrollViewDidScroll:self.rightTableView];
    
    
    // 数据为空时提示
//    BOOL rows = [self.dataSource numberOfRowsInListView:self];
//    if (rows > 0) {
//        [self removeEmptyTip];
//    }
//    else if (self.showSummaryView == NO && self.isDisplayedInScreen) {
//        [self addEmptyTip];
//    }
}

- (void)reloadSummaryData {
    [self.leftSummaryCell removeFromSuperview];
    [self.rightSummaryCell removeFromSuperview];
    self.leftSummaryCell = nil;
    if (![self.dataSource respondsToSelector:@selector(listView:contentsForSummaryView:)]) {
        NSAssert(NO, @"需要实现listView:contentsForSummaryView:");
    }
    NSArray<NSString *> *summaryContents = [self.dataSource listView:self contentsForSummaryView:NULL];
    NSMutableArray<NSNumber *> *leftWidths = @[].mutableCopy;
    NSMutableArray<NSString *> *leftContents = @[].mutableCopy;
    for (int i = 0; i < self.frozenColumns; i++) {
        [leftWidths addObject:self.widths[i]];
        [leftContents addObject:summaryContents[i]];
    }
    if (self.frozenColumns) {
        self.leftSummaryCell = [[CXNormalCell alloc] initWithWidths:leftWidths reuseIdentifier:@""];
        [[self.leftSummaryCell viewWithTag:'B'] removeFromSuperview];
        [self setRightBorder:self.leftSummaryCell];
        [self.summaryView addSubview:self.leftSummaryCell];
        [self.leftSummaryCell.textLabels enumerateObjectsUsingBlock:^(CXNormalCellLabel *_Nonnull label, NSUInteger idx, BOOL *_Nonnull stop) {
            label.text = leftContents[idx];
        }];
    }

    NSMutableArray<NSNumber *> *rightWidths = @[].mutableCopy;
    NSMutableArray<NSString *> *rightContents = @[].mutableCopy;
    for (int i = self.frozenColumns; i < self.widths.count; i++) {
        [rightWidths addObject:self.widths[i]];
        [rightContents addObject:summaryContents[i]];
    }
    self.rightSummaryCell = [[CXNormalCell alloc] initWithWidths:rightWidths reuseIdentifier:@""];
    [[self.rightSummaryCell viewWithTag:'B'] removeFromSuperview];
    [self.rightSummaryScrollView addSubview:self.rightSummaryCell];
    [self.rightSummaryCell.textLabels enumerateObjectsUsingBlock:^(CXNormalCellLabel *_Nonnull label, NSUInteger idx, BOOL *_Nonnull stop) {
        label.text = rightContents[idx];
    }];
}

- (void)beginRefreshing {
    if (self.frozenColumns > 0) {
        [self.leftTableView.header beginRefreshing];
        [self.rightTableView.header beginRefreshing];
    } else {
        [self.rightTableView.header beginRefreshing];
    }
}

- (void)headerEndRefreshing {
    [self.leftTableView.header endRefreshing];
    [self.rightTableView.header endRefreshing];
}

- (void)footerEndRefreshing {
    [self.leftTableView.footer endRefreshing];
    [self.rightTableView.footer endRefreshing];
}

- (void)setHasMoreData:(BOOL)hasMoreData {
    if (hasMoreData) {
        self.leftTableView.footer.hidden = NO;
        self.rightTableView.footer.hidden = NO;
    } else {
        self.leftTableView.footer.hidden = YES;
        self.rightTableView.footer.hidden = YES;
    }
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    // 合计高度
    CGFloat summaryHeight = self.showSummaryView ? kListCellHeight : 0;
    // 内容的高度
    CGFloat contentHeight = GET_HEIGHT(self) - self.padding.top - self.padding.bottom - summaryHeight;
    // 冻结视图
    CGFloat leftTableViewWidth = 0;
    if (self.frozenColumns) {
        for (int i = 0; i < self.frozenColumns; i++) {
            leftTableViewWidth += self.widths[i].floatValue;
        }
    } else {
        leftTableViewWidth = 0;
    }
    self.leftTableView.frame = CGRectMake(self.padding.left, self.padding.top, leftTableViewWidth, contentHeight);

    // 右边滚动视图
    CGFloat totalWidth = [[self.widths valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat rightWidth = GET_WIDTH(self) - leftTableViewWidth - self.padding.left - self.padding.right;
    self.scrollView.contentSize = CGSizeMake(totalWidth - leftTableViewWidth, contentHeight);
    self.scrollView.frame = CGRectMake(self.frozenColumns ? GET_MAX_X(self.leftTableView) : self.padding.left, self.padding.top, rightWidth, contentHeight);

    // 右边表格视图
    self.rightTableView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, GET_HEIGHT(self.scrollView));

    // 合计
    self.summaryView.frame = CGRectMake(self.padding.left, GET_HEIGHT(self) - self.padding.bottom - kListCellHeight, GET_WIDTH(self) - self.padding.left - self.padding.right, summaryHeight);
    self.leftSummaryCell.frame = CGRectMake(0, 0, leftTableViewWidth, kListCellHeight);
    self.rightSummaryScrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, kListCellHeight);
    self.rightSummaryScrollView.frame = CGRectMake(self.scrollView.left, 0, rightWidth, kListCellHeight);
    self.rightSummaryCell.frame = CGRectMake(0, 0, self.rightSummaryScrollView.contentSize.width, kListCellHeight);

    // 调整刷新控件位置
    for (UIView *subView in self.superview.subviews) {
        if ([subView isKindOfClass:[SDRootTopView class]]) {
            [self.superview insertSubview:self belowSubview:subView];
        }
    }

    if (self.frozenColumns > 0) {
        self.leftTableView.header.width = 200;
        self.leftTableView.footer.width = 200;
        self.leftTableView.header.centerX = GET_WIDTH(self) * 0.5;
        self.leftTableView.footer.centerX = GET_WIDTH(self) * 0.5;
    } else {
        self.rightTableView.header.centerX = GET_WIDTH(self) * 0.5;
        self.rightTableView.footer.centerX = GET_WIDTH(self) * 0.5;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 实际行数
    NSInteger trulyRows = [self.dataSource numberOfRowsInListView:self];
    _trulyRows = trulyRows;
    _fakeRows = trulyRows;
    // 显示合计时表格需要充满
    if (self.showSummaryView) {
        CGFloat contentHeight = GET_HEIGHT(self) - self.padding.top - kCXTitleHeaderViewHeight - (self.showSummaryView ? kListCellHeight : 0) - self.padding.bottom;
        // 能够充满
        if (trulyRows * kListCellHeight >= contentHeight) {
            return trulyRows;
        }
            // 不能充满
        else {
            NSInteger fakeRows = ceil(contentHeight / kListCellHeight);
            _fakeRows = fakeRows;
            return fakeRows;
        }
    }
    return trulyRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 以标题内存地址作为identifier(用于改变标题的情况)
    NSString *ID = [NSString stringWithFormat:@"%p", self.titles];
    CXNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 获取数据源方法的内容
    NSArray<id> *contents;
    if (_trulyRows > 0 && indexPath.row < _trulyRows) {
        contents = [self.dataSource listView:self contentsForRow:indexPath.row];
    } else {
        NSMutableArray<NSString *> *arr = @[].mutableCopy;
        for (int i = 0; i < self.titles.count; i++) {
            [arr addObject:@""];
        }
        contents = arr.copy;
    }
    if (!cell) {
        NSArray<NSNumber *> *widthRatios = tableView == self.leftTableView ? self.leftWidthRatios : self.rightWidthRatios;
        cell = [CXNormalCell cellWithWidthRatios:widthRatios reuseIdentifier:ID];
        // 设置代理，监听手势
        cell.delegate = self;
        // 给左边的tableView设置右边框
        !(tableView == self.leftTableView) ?: [self setRightBorder:cell.contentView];
    }
    cell.indexPath = indexPath;
    // 背景色
    UIColor *cellBackgroundColor = kOddCellBackgroundColor;
    if ([self.delegate respondsToSelector:@selector(listView:cellBackgroundColorForRow:)]) {
        cellBackgroundColor = [self.delegate listView:self cellBackgroundColorForRow:indexPath.row];
    }
    cell.backgroundColor = cellBackgroundColor;
    // 线条颜色
    !self.lineColor ?: [cell setLineColor:self.lineColor];
    
    // 水平分割线高度
    if ([self.delegate respondsToSelector:@selector(listView:cellSeparatorLineHeightForRow:)]) {
        CGFloat hLineHeight = [self.delegate listView:self cellSeparatorLineHeightForRow:indexPath.row];
        cell.hLineHeight = hLineHeight;
    }
    
    NSArray<UIView *> *vLines = [cell valueForKey:@"vLines"];
    // style
    if (self.style == CXListViewStyleNew) {
        for (UIView *v in vLines) {
            v.hidden = YES;
        }
    }
    else {
        for (UIView *v in vLines) {
            v.hidden = NO;
        }
    }

    if (contents.count) {
        // 遍历结束条件
        NSInteger loopEnd = tableView == self.leftTableView ? self.frozenColumns : self.widths.count - self.frozenColumns;
        NSAssert(cell.textLabels.count <= contents.count, @"列数不匹配");

        //清空之前的添加按钮
        UIButton *addButton = (UIButton *) [cell.textLabels[0] viewWithTag:101];
        if (addButton) {
            [addButton removeFromSuperview];
        }

        for (NSInteger i = 0; i < loopEnd; i++) {
            NSInteger idx = tableView == self.leftTableView ? i : i + self.frozenColumns;
            id content = contents[idx];
            // 清空原有内容
            NSInteger CustomViewTag = 1000 + idx;
            cell.textLabels[i].text = nil;
            cell.textLabels[i].attributedText = nil;
            [[cell.contentView viewWithTag:CustomViewTag] removeFromSuperview];
            // 设置内容
            if ([content isKindOfClass:[NSAttributedString class]]) {
                cell.textLabels[i].attributedText = contents[idx];
            } else if ([content isKindOfClass:NSString.class]) {
                cell.textLabels[i].text = contents[idx];
            } else if ([content isKindOfClass:UIImage.class]) {
                cell.textLabels[i].image = content;
            } else if ([content isKindOfClass:UIView.class]) {
                UIView *view = content;
                view.layer.masksToBounds = YES;
//                NSAssert(!CGSizeEqualToSize(CGSizeZero, view.frame.size), @"没有设置size");
                view.tag = CustomViewTag;
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(cell.textLabels[i]);
                    if (!CGSizeEqualToSize(CGSizeZero, view.frame.size)) {
                        make.size.mas_equalTo(view.frame.size);
                    } else {
                        make.size.equalTo(cell.textLabels[i]);
                    }
                }];
            }
        }
    } else {
//        NSInteger loopEnd = tableView == self.leftTableView ? self.frozenColumns : self.widths.count - self.frozenColumns;
//        [self cellLabel:cell.textLabels[0]];
//        for (NSInteger i = 0; i < loopEnd; i++) {
//            cell.textLabels[i].text = @" ";
//        }
    }

    if (self.isFromSetting) {
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = kColorWithRGB(255, 255, 255);
        } else {
            cell.backgroundColor = kColorWithRGB(255, 250, 243);
        }
        cell.lineColor = kColorWithRGB(255, 218, 164);
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        CXTitleHeaderView *headerView = [CXTitleHeaderView headerViewWithTitles:self.leftTitles widthRatios:self.leftWidthRatios];
        // 表示左边的标题头
        if (self.isFromSetting) {
            headerView.isFromSetting = self.isFromSetting;
            [headerView setBackgroundColor:kColorWithRGB(255, 242, 224)];
            headerView.lineColor = kColorWithRGB(255, 218, 164);
        }
        headerView.tag = 'L';
        headerView.delegate = self;
        if (self.showSearchButton) {
            headerView.showSearchButton = self.showSearchButton;
            headerView.delegate = self;
        }
        !self.titleViewBackgroundColor ?: [headerView setBackgroundColor:self.titleViewBackgroundColor];
        !self.lineColor ?: [headerView setLineColor:self.lineColor];
        
        NSArray<UIView *> *vLines = [headerView valueForKey:@"vLines"];
        // style
        if (self.style == CXListViewStyleNew) {
            for (UIView *v in vLines) {
                v.hidden = YES;
            }
        }
        else {
            for (UIView *v in vLines) {
                v.hidden = NO;
            }
        }
        
        [self setRightBorder:headerView];
        return headerView;
    } else {
        CXTitleHeaderView *headerView = [CXTitleHeaderView headerViewWithTitles:self.rightTitles widthRatios:self.rightWidthRatios];
        if (self.isFromSetting) {
            headerView.isFromSetting = self.isFromSetting;
            [headerView setBackgroundColor:kColorWithRGB(255, 242, 224)];
            headerView.lineColor = kColorWithRGB(255, 218, 164);
        }
        // 表示右边的标题头
        headerView.tag = 'R';
        headerView.delegate = self;
        !self.titleViewBackgroundColor ?: [headerView setBackgroundColor:self.titleViewBackgroundColor];
        !self.lineColor ?: [headerView setLineColor:self.lineColor];
        
        NSArray<UIView *> *vLines = [headerView valueForKey:@"vLines"];
        // style
        if (self.style == CXListViewStyleNew) {
            for (UIView *v in vLines) {
                v.hidden = YES;
            }
        }
        else {
            for (UIView *v in vLines) {
                v.hidden = NO;
            }
        }
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCXTitleHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

#pragma mark - CXTitleHeaderViewDelegate

- (void)titleHeaderView:(CXTitleHeaderView *)headerView didTapSearchButton:(UIButton *)searchButton {
    //点击头部的搜索按钮
    if (self.searchClick) {
        self.searchClick();
    }
}

/**
 点击了标题
 
 @param headerView 头部视图
 @param titleLabel 被点击的标题
 @param index      标题所在的索引
 */
- (void)titleHeaderView:(CXTitleHeaderView *)headerView didTapTitleLabel:(UILabel *)titleLabel atIndex:(NSInteger)index {
    NSInteger idx = NSNotFound;
    if (headerView.tag == 'L') {
        idx = index;
    } else if (headerView.tag == 'R') {
        idx = self.leftTitles.count + index;
    }
    if ([self.delegate respondsToSelector:@selector(listView:didTapTitleLabel:atIndex:)]) {
        [self.delegate listView:self didTapTitleLabel:titleLabel atIndex:idx];
    }
}

#pragma mark - CXNormalCellDelegate

- (void)normalCell:(CXNormalCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _trulyRows) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(listView:didSelectRowAtIndex:)]) {
        [self.delegate listView:self didSelectRowAtIndex:indexPath.row];
    }
}

- (void)normalCell:(CXNormalCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath currentColumn:(int)column {
    if (indexPath.row >= _trulyRows) {
        return;
    }
    if ([cell.weakTableView isEqual:self.rightTableView]) {
        column = column + self.frozenColumns;
    }
    // column的值不包括冻结的列.column是指可以滚动的列表的索引
    if ([self.delegate respondsToSelector:@selector(listView:didSelectRowAtIndex:atColumnIndex:)]) {
        [self.delegate listView:self didSelectRowAtIndex:indexPath.row atColumnIndex:column];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 同步滚动
    if (scrollView == self.leftTableView) {
        self.rightTableView.contentOffset = scrollView.contentOffset;
    } else if (scrollView == self.rightTableView && self.frozenColumns) {
        self.leftTableView.contentOffset = scrollView.contentOffset;
//        if (self.showSummaryView) {
//            self.rightSummaryScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
//        }
    } else if (scrollView == self.rightSummaryScrollView) {
        self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.scrollView.contentOffset.y);
    } else if (scrollView == self.scrollView) {
        // 禁用左边弹簧效果
        if (self.scrollView.contentOffset.x < 0) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        }
        self.rightSummaryScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.rightSummaryScrollView.contentOffset.y);
    }
}

#pragma mark - 私有方法

- (void)setRightBorder:(__kindof UIView *)view {
    if ([view viewWithTag:'r']) {
        return;
    }
    UIView *rightBorder = [[UIView alloc] init];
    rightBorder.backgroundColor = self.lineColor ?: kTableViewLineColor;
    rightBorder.tag = 'r';
    [view addSubview:rightBorder];
    [rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.right.bottom.equalTo(view);
    }];
}

- (void)setTopBorder:(__kindof UIView *)view {
    if ([view viewWithTag:'t']) {
        return;
    }
    UIView *topBorder = [[UIView alloc] init];
    topBorder.backgroundColor = self.lineColor ?: kTableViewLineColor;
    topBorder.tag = 't';
    [view addSubview:topBorder];
    [topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.leading.trailing.equalTo(view);
    }];
}

- (void)setBottomBorder:(__kindof UIView *)view {
    if ([view viewWithTag:'b']) {
        return;
    }
    UIView *topBorder = [[UIView alloc] init];
    topBorder.backgroundColor = self.lineColor ?: kTableViewLineColor;
    topBorder.tag = 'b';
    [view addSubview:topBorder];
    [topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.leading.trailing.equalTo(view);
    }];
}

- (void)disableTouchesDelay:(UIScrollView *)scrollView {
    scrollView.delaysContentTouches = NO;
    for (id view in scrollView.subviews) {
        if ([view respondsToSelector:@selector(setDelaysContentTouches:)]) {
            [view setDelaysContentTouches:NO];
        }
    }
}

#pragma mark -- 视图上添加添加按钮

//- (void)cellLabel:(CXNormalCellLabel *)cellLabel {
//    UIButton *button = (UIButton *) [cellLabel viewWithTag:101];
//    if (!button) {
//        [cellLabel addSubview:self.creatAddButton];
//    }
//}

#pragma mark -- 创建添加按钮

//- (UIButton *)creatAddButton {
//    if (!_addButton) {
//        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat orginX = (self.rightTableView.frame.size.width * self.addButtonRate - kLeftViewWith * 2) / 2.f;
//        CGFloat orginY = (44.f - 20.f) / 2.f;
//        [_addButton setFrame:CGRectMake(orginX, orginY, kLeftViewWith * 2, 20)];
//        _addButton.tag = 101;
//        [_addButton setTitle:@"添 加" forState:UIControlStateNormal];
//        _addButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        CGFloat scaleSize = 1;
//
//        UIImage *image = [UIImage imageNamed:@"common_add"];
//        if (self.isFromSetting) {
//            image = [UIImage imageNamed:@"common_add2"];
//        }
//        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
//        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [_addButton setImage:scaledImage forState:UIControlStateNormal];
//        _addButton.imageView.backgroundColor = kLetterGreen2;
//        _addButton.imageView.layer.cornerRadius = _addButton.imageView.frame.size.width / 2.0;
//        _addButton.imageView.layer.masksToBounds = YES;
//        _addButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//        _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//
//    }
//    return _addButton;
//}

@end
