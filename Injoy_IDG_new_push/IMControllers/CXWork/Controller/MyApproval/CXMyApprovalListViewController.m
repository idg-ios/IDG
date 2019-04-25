//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXMyApprovalListViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "CXVacationApprovalListViewController.h"
#import "UIView+CXCategory.h"
#import "CXReimbursementApprovalListViewController.h"

@interface CXMyApprovalListViewController ()
        <
        UICollectionViewDelegate,
        UICollectionViewDataSource
        >
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@end

@implementation CXMyApprovalListViewController

static NSString *const cellId_ = @"cellId";
static NSString *const headerId = @"headerId";

#pragma mark - get & set

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(Screen_Width / 3.5f, 80.f);
        layout.sectionInset = UIEdgeInsetsMake(10.f, 10.f, 0.f, 0.f);
        layout.headerReferenceSize = CGSizeMake(GET_WIDTH(self.view), [UIImage imageNamed:@"myApproval"].size.height);

        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0.f, navHigh, Screen_Width, Screen_Height - navHigh} collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId_];
    }
    return _collectionView;
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"我的流程"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpCollectionView {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
        CXVacationApprovalListViewController *vc = [[CXVacationApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(indexPath.section == 0 && indexPath.row == 1){
        CXReimbursementApprovalListViewController *vc = [[CXReimbursementApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        UICollectionReusableView *headerView = [collectionView
                dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                   withReuseIdentifier:headerId
                                          forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myApproval"]];
        [headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        return headerView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId_ forIndexPath:indexPath];

    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.frame = cell.bounds;
    if(indexPath.section == 0 && indexPath.row == 0){
        [cellButton setTitle:@"请假批审" forState:UIControlStateNormal];
        [cellButton setImage:[UIImage imageNamed:@"holiday_apply"] forState:UIControlStateNormal];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        [cellButton setTitle:@"报销批审" forState:UIControlStateNormal];
        [cellButton setImage:[UIImage imageNamed:@"BXPSIcon"] forState:UIControlStateNormal];
    }
    [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:LXMImagePositionTop spacing:5];

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CK) && (indexPath.section == 0 && indexPath.row == 0)) {
        VAL_AddNumBadge(IM_PUSH_CK, nil);
    }

    return cell;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
    [self setUpCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
