//
//  CXNewHRRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewHRRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXVacationApplicationListViewController.h"
#import "CXWDXJListViewController.h"
#import "CXIDGMessageListViewController.h"
#import "CXVacationApplicationEditViewController.h"
#import "IDGXJListViewController.h"

@interface CXNewHRRootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(copy, readonly, nonatomic) NSArray *imageArr;

@end

@implementation CXNewHRRootViewController

static NSString *const cellId_1 = @"cellId";
static NSString *const headerId = @"headerId";

#pragma mark - get & set

- (NSArray *)imageArr {
    return @[@"holiday_apply", @"work_holiday", @"CXIDGMSGPIC", @"XJListImage", @"WDXJICON", @"LCXXICON"];
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"请假", @"我的请假", @"消息", @"销假", @"我的销假", @"流程消息", nil];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0.f, navHigh, Screen_Width, Screen_Height - navHigh} collectionViewLayout:layout];
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
    [rootTopView setNavTitle:@"移动HR"];
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
    
    if ([@"请假" isEqualToString:title]) {//请假
        CXVacationApplicationEditViewController *vc = [CXVacationApplicationEditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"我的请假" isEqualToString:title]) {//我的请假
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_QJ);
        CXVacationApplicationListViewController *vc = [[CXVacationApplicationListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"消息" isEqualToString:title]) {//消息
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PUSH_HOLIDAY);
        CXIDGMessageListViewController *vc = [CXIDGMessageListViewController new];
        vc.type = RSType;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"销假" isEqualToString:title]) {//销假
        IDGXJListViewController *vc = [IDGXJListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"我的销假" isEqualToString:title]) {//我的销假
        CXWDXJListViewController *vc = [[CXWDXJListViewController alloc] init];
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_XIAO);//我的销假和流程消息一样
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"流程消息" isEqualToString:title]) {//流程消息
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PROGRESS);
        CXIDGMessageListViewController *vc = [CXIDGMessageListViewController new];
        vc.type = WDLCType;
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
    
    if (VAL_PUSHES_MSGS(IM_PUSH_QJ)&& (indexPath.section == 0 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_QJ, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_PUSH_HOLIDAY)&& (indexPath.section == 0 && indexPath.row == 2)) {
        VAL_AddNumBadge(IM_PUSH_PUSH_HOLIDAY, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_PROGRESS)&& (indexPath.section == 0 && indexPath.row == 5)) {
        VAL_AddNumBadge(IM_PUSH_PROGRESS, nil);
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
