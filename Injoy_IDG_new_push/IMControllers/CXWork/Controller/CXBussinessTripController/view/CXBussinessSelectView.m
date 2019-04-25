//
//  CXBussinessSelectView.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/23.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBussinessSelectView.h"
#import "CXMiddleActionSheetSelectViewCell.h"

#define kBgBackgroundcolor kDialogCoverBackgroundColor

#define kTitleBackgroundcolor RGBACOLOR(227.0,231.0,229.0,1.0)

#define kCancleBtnBackgroundcolor RGBACOLOR(114.0,114.0,114.0,1.0)

#define kWhiteBackViewCornerRadios 0.0

#define kTitleBackViewHeight kDialogHeaderHeight

#define kSelectCellHeight kCellHeight

#define kBottomCancleBackView kDialogFooterHeight

#define kWhiteBackViewLeftSpace ((Screen_Width - kDialogWidth)/2)

#define kTitleFontSize 17.0

#define kSelcetDataFontSize kDialogButtonFont

#define kShowMaxSelectDataCount 5

#define kCancleBtnRightSpace (kDialogButtonMargin)

#define kCancleBtnWidth (kDialogButtonWidth)

#define kCancleBtnHeight (kDialogButtonHeight)

#define kTableViewHeight ([self.dataSource count]<kShowMaxSelectDataCount?(([self.dataSource count]*kSelectCellHeight) + searchBarHeight):((kShowMaxSelectDataCount*kSelectCellHeight) + searchBarHeight))

#define kWhiteBackViewHeight ([self.dataSource count]<kShowMaxSelectDataCount?(kTitleBackViewHeight + ([self.dataSource count]*kSelectCellHeight + kBottomCancleBackView) + searchBarHeight):(kTitleBackViewHeight + (kShowMaxSelectDataCount*kSelectCellHeight) + kBottomCancleBackView) + searchBarHeight)

#define searchBarHeight kSelectCellHeight

@interface CXBussinessSelectView () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) NSString *selectData;

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIView *whiteBackView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *titleBackView;

@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CXBussinessSelectView
{
    NSArray *searchArray;
}

- (id)initWithSelectArray:(NSArray *)dataSource Title:(NSString *)title AndSelectData:(NSString *)selectData {
    if ([super init]) {
        self.dataSource = [NSArray arrayWithArray:dataSource];
        
        self.title = title;
        
        self.selectData = selectData;
        
        searchArray = self.dataSource.copy;
        
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    _bgView = [[UIView alloc] init];
    _bgView.frame = KEY_WINDOW.frame;
    _bgView.backgroundColor = kBgBackgroundcolor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap)];
    [_bgView addGestureRecognizer:tap];
    [KEY_WINDOW addSubview:_bgView];
    
    _whiteBackView = [[UIView alloc] init];
    _whiteBackView.backgroundColor = kDialogContentBackgroundColor;
    _whiteBackView.userInteractionEnabled = YES;
    _whiteBackView.layer.cornerRadius = kWhiteBackViewCornerRadios;
    _whiteBackView.clipsToBounds = YES;
    [KEY_WINDOW addSubview:_whiteBackView];
    
    _whiteBackView.frame = CGRectMake(kWhiteBackViewLeftSpace, (Screen_Height - kWhiteBackViewHeight) / 2, Screen_Width - 2 * kWhiteBackViewLeftSpace, kWhiteBackViewHeight);
    
    _titleBackView = [[UIView alloc] init];
    _titleBackView.frame = CGRectMake(0, 0, Screen_Width - 2 * kWhiteBackViewLeftSpace, kTitleBackViewHeight);
    _titleBackView.backgroundColor = kTitleBackgroundcolor;
    [_whiteBackView addSubview:_titleBackView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, kTitleBackViewHeight - 0.5, Screen_Width - 2 * kWhiteBackViewLeftSpace, 0.5);
    lineView.backgroundColor = RGBACOLOR(184.0, 184.0, 184.0, 1.0);
    [_titleBackView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, (kTitleBackViewHeight - kTitleFontSize) / 2, Screen_Width - 2 * kWhiteBackViewLeftSpace, kTitleFontSize);
    titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    if ([self.title length] == 2) {
        titleLabel.text = [NSString stringWithFormat:@"%@%@%@", [self.title substringToIndex:1], kDialogTextSpacing, [self.title substringFromIndex:1]];
    } else {
        titleLabel.text = self.title;
    }
    
    [_whiteBackView addSubview:titleLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleBackView.frame), Screen_Width - 2 * kWhiteBackViewLeftSpace, kTableViewHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = kDialogContentBackgroundColor;
    [_tableView setSeparatorColor:RGBACOLOR(184.0, 184.0, 184.0, 1.0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_whiteBackView addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
 //   _searchBar.showsSearchResultsButton = YES;
    _searchBar.frame = CGRectMake(0, 0, Screen_Width - 2 * kWhiteBackViewLeftSpace, searchBarHeight);
    _tableView.tableHeaderView = _searchBar;
    
    UIView *bottomCancleBackGroundView = [[UIView alloc] init];
    bottomCancleBackGroundView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), Screen_Width - 2 * kWhiteBackViewLeftSpace, kBottomCancleBackView);
    bottomCancleBackGroundView.backgroundColor = kTitleBackgroundcolor;
    [_whiteBackView addSubview:bottomCancleBackGroundView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(kCancleBtnRightSpace, CGRectGetMaxY(_tableView.frame) + (kBottomCancleBackView - kCancleBtnHeight) / 2, kCancleBtnWidth, kCancleBtnHeight);
    confirmBtn.backgroundColor = kCancleBtnBackgroundcolor;
    [confirmBtn setImage:[UIImage imageNamed:@"common_save"] forState:UIControlStateNormal];
    [confirmBtn setImage:[UIImage imageNamed:@"common_save"] forState:UIControlStateHighlighted];
    [confirmBtn setImageEdgeInsets:kDialogButtonImageInsets];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确 认" forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:confirmBtn];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(Screen_Width - 2 * kWhiteBackViewLeftSpace - kCancleBtnRightSpace - kCancleBtnWidth, CGRectGetMaxY(_tableView.frame) + (kBottomCancleBackView - kCancleBtnHeight) / 2, kCancleBtnWidth, kCancleBtnHeight);
    cancleBtn.backgroundColor = kCancleBtnBackgroundcolor;
    [cancleBtn setImage:[UIImage imageNamed:@"common_delete"] forState:UIControlStateNormal];
    [cancleBtn setImage:[UIImage imageNamed:@"common_delete"] forState:UIControlStateHighlighted];
    [cancleBtn setImageEdgeInsets:kDialogButtonImageInsets];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取 消" forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:cancleBtn];
}

- (void)confirmBtnBtnClick {
    if ([_dataSource count] && ![_dataSource containsObject:_selectData]) {
        TTAlert([NSString stringWithFormat:@"请先选择%@！", self.title]);
        return;
    }
    if (self.selectDataCallBack) {
        self.selectDataCallBack(_selectData);
    }
    [_bgView removeFromSuperview];
    [_whiteBackView removeFromSuperview];
}

- (void)cancleBtnClick {
    [_bgView removeFromSuperview];
    [_whiteBackView removeFromSuperview];
}

- (void)bgViewTap {
    if([self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
    }else{
        [_bgView removeFromSuperview];
        [_whiteBackView removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSelectCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"CXMiddleActionSheetSelectViewCell";
    CXMiddleActionSheetSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[CXMiddleActionSheetSelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    [cell setData:searchArray[indexPath.row] AndIsSelected:[searchArray[indexPath.row] isEqualToString:self.selectData]];
    return cell;
}

#pragma mark - UITableViewDelegate

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectData = searchArray[indexPath.row];
    [_tableView reloadData];
    if (self.selectDataCallBack) {
        self.selectDataCallBack(_selectData);
    }
    [_bgView removeFromSuperview];
    [_whiteBackView removeFromSuperview];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(trim(searchText).length){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains %@", searchText];
        searchArray = [self.dataSource filteredArrayUsingPredicate:predicate];
    }else{
        searchArray = self.dataSource.copy;
    }
    [self.tableView reloadData];
    NSLog(@"array is %@",searchArray);
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}
@end
