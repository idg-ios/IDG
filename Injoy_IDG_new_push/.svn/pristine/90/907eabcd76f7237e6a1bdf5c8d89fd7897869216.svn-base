//
//  CXPEProjectSearchView.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPEProjectSearchView.h"
#import "CXProjectSearchItemCell.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "NSString+YYAdd.h"
#import "UIButton+LXMImagePosition.h"

@interface CXPEProjectSearchView()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout>

/** 背景白色 */
@property (nonatomic, strong) UIView *backWhiteView;
/** 搜索栏 */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 负责人*/
@property (nonatomic, strong) UILabel * fzrTitleLable;
/** 负责人TextField */
@property (nonatomic, strong) UITextField * fzrTextField;
/** 列表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/** 重置按钮 */
@property (nonatomic, strong) UIButton *resetButton;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchButton;

/** 数据源：行业 */
@property (nonatomic, copy) NSMutableArray *industryList;

/** 选择的一级行业 */
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedIndustryList;

/** 是否展开一级行业 */
@property (nonatomic, assign, getter=isExpandIndustry) BOOL expandIndustry;

@end

NSString * const kCollectionViewCellID = @"cell";
NSString * const kCollectionViewHeaderViewID = @"header";

@implementation CXPEProjectSearchView{
    /** 遮罩层 */
    __weak UIView *_maskView;
}

#define kTitleSpace 10.0
#define kTitleLeftSpace 10.0
#define kTextFontSize 16.0
#define kTextFieldHeight 40.0

#pragma mark - Get Set

- (NSMutableArray<NSString *> *)selectedIndustryList {
    if (_selectedIndustryList == nil) {
        _selectedIndustryList = [NSMutableArray array];
    }
    return _selectedIndustryList;
}

- (NSMutableArray *)industryList{
    if(!_industryList){
        _industryList = @[].mutableCopy;
    }
    return _industryList;
}


#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.expandIndustry = NO;
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup {
    _backWhiteView = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view;
    });
    
    _searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.showsCancelButton = YES;
        searchBar.placeholder = @"请输入关键词";
        searchBar.delegate = self;
        [self addSubview:searchBar];
        searchBar;
    });
    
    _fzrTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"负责人";
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label;
    });
    
    _fzrTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入负责人";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        [self addSubview:textField];
        textField;
    });
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[CXProjectSearchItemCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderViewID];
        [self addSubview:collectionView];
        collectionView;
    });
    
    _footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view;
    });
    
    _resetButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:kColorWithRGB(236, 72, 73) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onResetButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        button;
    });
    
    _searchButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kColorWithRGB(236, 72, 73)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onSearchButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        button;
    });
}

- (void)layout {
    self.backWhiteView.frame = CGRectMake(0, 0, Screen_Width, 51.0 + 3*kTitleSpace + kTextFontSize + kTextFieldHeight + 1.0);
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(51);
    }];
    
    UIView *line = [self addDividingLineInView:self below:self.searchBar offset:0];
    
    [self.fzrTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(kTitleSpace);
        make.left.equalTo(self).offset(kTitleLeftSpace);
        make.right.equalTo(self).offset(-kTitleLeftSpace);
        make.height.mas_equalTo(kTextFontSize);
    }];
    
    [self.fzrTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fzrTitleLable.mas_bottom).offset(kTitleSpace);
        make.left.equalTo(self).offset(kTitleLeftSpace);
        make.right.equalTo(self).offset(-kTitleLeftSpace);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fzrTextField.mas_bottom).offset(kTitleSpace);
        make.left.right.equalTo(self);
    }];
    
    line = [self addDividingLineInView:self below:self.collectionView offset:0];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(50);
        make.top.equalTo(line.mas_bottom);
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 30));
        make.centerY.equalTo(self.footerView);
        make.right.equalTo(self.footerView.mas_centerX).offset(-5);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 30));
        make.centerY.equalTo(self.footerView);
        make.left.equalTo(self.footerView.mas_centerX).offset(5);
    }];

}

#pragma mark - Public

- (void)showInView:(UIView *)view {
    [self findDataList];
    
    UIView *maskView = ({
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = kDialogCoverBackgroundColor;
        [view addSubview:maskView];
        [maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        maskView;
    });
    _maskView = maskView;
    [view addSubview:self];
    
    if ([view.viewController isKindOfClass:[SDRootViewController class]]) {
        UIView *rootTopView = [view viewWithTag:kRootTopViewTag];
        if (rootTopView) {
            [view bringSubviewToFront:rootTopView];
        }
    }
}

- (void)hide {
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Private
- (UIView *)addDividingLineInView:(UIView *)superView below:(UIView *)view offset:(CGFloat)offset {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorWithRGB(241, 241, 241);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(offset);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    return line;
}

DEALLOC_ADDITION

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isExpandIndustry ? self.industryList.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CXProjectSearchItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    NSString *industry = self.industryList[indexPath.row];
    cell.text = industry;
    cell.checked = [self.selectedIndustryList containsObject:industry];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-40)/3, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10,10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeaderViewID forIndexPath:indexPath];
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.equalTo(headerView);
            }];
            label;
        });
        
        UIButton *showTypeControlButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            [btn setTitleColor:kColorWithRGB(124, 124, 124) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:Image(@"expand") forState:UIControlStateNormal];
            [btn setImage:Image(@"collapse") forState:UIControlStateSelected];
            [btn setImagePosition:LXMImagePositionRight spacing:3];
            [btn addTarget:self action:@selector(onShowTypeControlButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.equalTo(titleLabel);
            }];
            btn;
        });
        
        titleLabel.text = @"行业";
        showTypeControlButton.tag = indexPath.section;
        showTypeControlButton.selected = self.isExpandIndustry;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *industry = self.industryList[indexPath.row];
    [self.selectedIndustryList removeAllObjects];
    [self.selectedIndustryList addObject:industry];
    [self.collectionView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self onSearchButtonTap];
    [searchBar resignFirstResponder];
}

#pragma mark - Private
- (void)findDataList {
    [self findIndustryList];
}

- (void)findIndustryList {
    if (self.industryList.count) {
        return;
    }
    [HttpTool getWithPath:@"/project/potential/indus/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSMutableArray * data = [NSMutableArray arrayWithArray:JSON[@"data"]];
            for(NSObject * object in data){
                if(![object isKindOfClass:[NSNull class]]){
                    [self.industryList addObject:object];
                }
            }
            
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - Event
- (void)onResetButtonTap {
    self.searchBar.text = nil;
    self.fzrTextField.text = nil;
    [self.selectedIndustryList removeAllObjects];
    [self.collectionView reloadData];
}

- (void)onSearchButtonTap {
    if (self.onSearchCallback) {
        NSArray<NSString *> *industries = self.selectedIndustryList;
        NSString *keyword = [self.searchBar.text stringByTrim];
        NSString * fzr = [self.fzrTextField.text stringByTrim];
        self.onSearchCallback(industries, keyword, fzr);
    }
    [self hide];
}

- (void)onShowTypeControlButtonTap: (UIButton *)btn {
    NSInteger section = btn.tag;
    self.expandIndustry = !self.expandIndustry;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

@end
