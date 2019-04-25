//
//  CXZJYXLGSSearchView.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/22.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXZJYXLGSSearchView.h"
#import "CXProjectSearchItemCell.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "NSString+YYAdd.h"
#import "UIButton+LXMImagePosition.h"

@interface CXZJYXLGSSearchView()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout>

/** 搜索栏 */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 列表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/** 重置按钮 */
@property (nonatomic, strong) UIButton *resetButton;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchButton;
/** 数据源：项目经理
 {
 "account": "yi_zhang",
 "userName": "张屹"
 } */
@property (nonatomic, copy) NSArray<NSDictionary *> *stageList;
/** 数据源：行业
 [
 "人工智能",
 "测试行业2"
 ]
 */
@property (nonatomic, copy) NSArray<NSString *> *industryList;
/** 选择的项目经理 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *selectedStageList;
/** 选择的行业 */
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedIndustryList;

/** 是否展开项目经理 */
@property (nonatomic, assign, getter=isExpandStage) BOOL expandStage;
/** 是否展开行业 */
@property (nonatomic, assign, getter=isExpandIndustry) BOOL expandIndustry;

@end

NSString * const kCollectionViewCellID = @"cell";
NSString * const kCollectionViewHeaderViewID = @"header";

@implementation CXZJYXLGSSearchView{
    /** 遮罩层 */
    __weak UIView *_maskView;
}

#pragma mark - Get Set
- (NSMutableArray<NSDictionary *> *)selectedStageList {
    if (_selectedStageList == nil) {
        _selectedStageList = [NSMutableArray array];
    }
    return _selectedStageList;
}

- (NSMutableArray<NSString *> *)selectedIndustryList {
    if (_selectedIndustryList == nil) {
        _selectedIndustryList = [NSMutableArray array];
    }
    return _selectedIndustryList;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.expandStage = NO;
        self.expandIndustry = NO;
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup {
    _searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.showsCancelButton = YES;
        searchBar.placeholder = @"请输入关键词";
        searchBar.delegate = self;
        [self addSubview:searchBar];
        searchBar;
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
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(51);
    }];
    
    UIView *line = [self addDividingLineInView:self below:self.searchBar offset:0];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.isExpandStage ? self.stageList.count : 0;
    }
    else {
        return self.isExpandIndustry ? self.industryList.count : 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CXProjectSearchItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    // 项目经理
    if (indexPath.section == 0) {
        NSDictionary *stage = self.stageList[indexPath.row];
        cell.text = stage[@"userName"];
        cell.checked = [self.selectedStageList containsObject:stage];
    }
    // 行业
    else {
        NSString *industry = self.industryList[indexPath.row];
        cell.text = industry;
        cell.checked = [self.selectedIndustryList containsObject:industry];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-40)/3, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
        
        NSArray *texts = @[@"项目经理", @"行业"];
        titleLabel.text = texts[indexPath.section];
        showTypeControlButton.tag = indexPath.section;
        if (indexPath.section == 0) {
            showTypeControlButton.selected = self.isExpandStage;
        }
        else {
            showTypeControlButton.selected = self.isExpandIndustry;
        }
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 项目经理
    if (indexPath.section == 0) {
        NSDictionary *stage = self.stageList[indexPath.row];
        if([self.selectedStageList containsObject:stage]){
            [self.selectedStageList removeAllObjects];
        }else{
            [self.selectedStageList removeAllObjects];
            [self.selectedStageList addObject:stage];
        }
    }
    // 行业
    else {
        NSString *industry = self.industryList[indexPath.row];
        if([self.selectedIndustryList containsObject:industry]){
            [self.selectedIndustryList removeAllObjects];
        }else{
            [self.selectedIndustryList removeAllObjects];
            [self.selectedIndustryList addObject:industry];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self onSearchButtonTap];
}

#pragma mark - Private
- (void)findDataList {
    [self findStageList];
    [self findIndustryList];
}

- (void)findStageList {
    if (self.stageList.count) {
        return;
    }
    [HttpTool postWithPath:@"/project/influ/filter/items/managers.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.stageList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }   else if ([JSON[@"status"] intValue] == 400) {
            [self.collectionView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)findIndustryList {
    if (self.industryList.count) {
        return;
    }
    [HttpTool postWithPath:@"/project/influ/filter/items/indus.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.industryList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }   else if ([JSON[@"status"] intValue] == 400) {
            [self.collectionView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
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
    [self.selectedStageList removeAllObjects];
    [self.selectedIndustryList removeAllObjects];
    [self.collectionView reloadData];
}

- (void)onSearchButtonTap {
    if (self.onSearchCallback) {
        NSString * s_projManager = nil;
        NSString * s_indusType = nil;
        NSString *keyword = [self.searchBar.text stringByTrim];
        if(self.selectedStageList && [self.selectedStageList count] > 0){
            s_projManager = [self.selectedStageList[0] objectForKey:@"account"];
        }
        if(self.selectedIndustryList && [self.selectedIndustryList count] > 0){
            s_indusType = self.selectedIndustryList[0];
        }
        self.onSearchCallback(s_projManager, s_indusType, keyword);
    }
    [self hide];
}

- (void)onShowTypeControlButtonTap: (UIButton *)btn {
    NSInteger section = btn.tag;
    if (section == 0) {
        self.expandStage = !self.expandStage;
    }
    else {
        self.expandIndustry = !self.expandIndustry;
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

@end
