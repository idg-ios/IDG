//
//  CXNewWDCLRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewWDCLRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXBussinessTripEditViewController.h"
#import "CXTravalController.h"
#import "CXBussinessTripListViewController.h"

@interface CXNewWDCLRootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(copy, readonly, nonatomic) NSArray *imageArr;

@end

@implementation CXNewWDCLRootViewController

static NSString *const cellId_1 = @"cellId";
static NSString *const headerId = @"headerId";

#pragma mark - get & set

- (NSArray *)imageArr {
    return @[@"出差", @"work_traval", @"我的出差"];
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"差旅申请", @"差旅预定", @"我的出差", nil];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0.f, Screen_Width*350.0/750.0, Screen_Width, Screen_Height - Screen_Width*350.0/750.0} collectionViewLayout:layout];
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
    [rootTopView setNavTitle:@"我的差旅"];
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
    if ([@"差旅申请" isEqualToString:title]) {
        CXBussinessTripEditViewController *vc = [[CXBussinessTripEditViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"差旅预定" isEqualToString:title]) {
        CXTravalController *vc = [CXTravalController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"我的出差" isEqualToString:title] ){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CLSP);
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
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
    
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CLSP) && (indexPath.section == 0 && indexPath.row == 2)) {
        VAL_AddNumBadge(IM_PUSH_CLSP, nil);
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
