//
//  CXNewWDSPRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewWDSPRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXBussinessTripListViewController.h"
#import "CXVacationApprovalListViewController.h"
#import "CXReimbursementApprovalListViewController.h"
#import "CXXJSPListViewController.h"

@interface CXNewWDSPRootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(copy, readonly, nonatomic) NSArray *imageArr;

@end

@implementation CXNewWDSPRootViewController

static NSString *const cellId_1 = @"cellId";
static NSString *const headerId = @"headerId";

#pragma mark - get & set

- (NSArray *)imageArr {
    NSMutableArray * data = @[].mutableCopy;
    if(VAL_HAS_RIGHT_CCPS){
        [data addObject:@"出差审批"];
    }
    if(VAL_HAS_RIGHT_QJPS){
        [data addObject:@"XJPSImage"];
    }
    if(VAL_HAS_RIGHT_BXPS){
        [data addObject:@"BXPSIMG"];
    }
    if(VAL_HAS_RIGHT_XJPS){
        [data addObject:@"WDXJICON"];
    }
    return data;
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        NSMutableArray * data = @[].mutableCopy;
        if(VAL_HAS_RIGHT_CCPS){
            [data addObject:@"差旅审批"];
        }
        if(VAL_HAS_RIGHT_QJPS){
            [data addObject:@"请假审批"];
        }
        if(VAL_HAS_RIGHT_BXPS){
            [data addObject:@"报销审批"];
        }
        if(VAL_HAS_RIGHT_XJPS){
            [data addObject:@"销假审批"];
        }
        
        _dataSourceArr = [[NSMutableArray alloc] initWithArray:data];
    }
    return _dataSourceArr;
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(Screen_Width / 3.5f, 80.f);
        layout.sectionInset = UIEdgeInsetsMake(10.f, 10.f, 0.f, 0.f);
        layout.headerReferenceSize = CGSizeMake(GET_WIDTH(self.view), 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0.f, Screen_Width*350.0/750.0, Screen_Width, Screen_Height - navHigh} collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId_1];
    }
    return _collectionView;
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"我的审批"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    self.rootTopView.backgroundColor = [UIColor clearColor];
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width*350.0/750.0)];
    [pic setImage:Image(@"ICEForceImg")];
    [self.view addSubview:pic];
    [self.view bringSubviewToFront:self.rootTopView];
}

- (void)setUpCollectionView {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(Screen_Width*350.0/750.0);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSourceArr[indexPath.row];
    if ([@"差旅审批" isEqualToString:title]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CLSP2);
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        vc.lbType = CXBusinessTripPS;
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"请假审批" isEqualToString:title]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
        CXVacationApprovalListViewController *vc = [[CXVacationApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"报销审批" isEqualToString:title]) {
        CXReimbursementApprovalListViewController *vc = [[CXReimbursementApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if([@"销假审批" isEqualToString:title]){
        CXXJSPListViewController *vc = [[CXXJSPListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSourceArr count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        UICollectionReusableView *headerView = [collectionView
                                                dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                withReuseIdentifier:headerId
                                                forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hrBgImage"]];
        [headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        return nil;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId_1 forIndexPath:indexPath];
    
    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.frame = cell.bounds;
    [cellButton setTitle:self.dataSourceArr[indexPath.row] forState:UIControlStateNormal];
    [cellButton setImage:[UIImage imageNamed:self.imageArr[indexPath.row]] forState:UIControlStateNormal];
    [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:LXMImagePositionTop spacing:5];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CLSP2)&& (indexPath.section == 0 && indexPath.row == 0)) {
        VAL_AddNumBadge(IM_PUSH_CLSP2, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CK)&& (indexPath.section == 0 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_CK, nil);
    }
        
    return cell;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    
    [self setUpCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
