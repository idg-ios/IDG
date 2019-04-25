//
//  CXIDGLCSXViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/27.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGLCSXViewController.h"
#import "UIView+CXCategory.h"
#import "UIButton+LXMImagePosition.h"
#import "CXVacationApplicationEditViewController.h"
#import "CXReimbursementApprovalListViewController.h"
#import "CXVacationApprovalListViewController.h"
#import "CXVacationApplicationListViewController.h"
#import "CXReimbursementListViewController.h"
#import "HttpTool.h"
#import "CXIDGMessageListViewController.h"
#import "CXWDXJListViewController.h"
#import "CXXJSPListViewController.h"
#import "IDGXJListViewController.h"
#import "CXBussinessTripListViewController.h"
#import "CXBussinessTripEditViewController.h"

#define headPicHeight (navHigh*2+45)

@interface CXIDGLCSXViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//导航条
@property(nonatomic, strong) SDRootTopView *rootTopView;
@property(nonatomic, strong) NSMutableArray *imageArrM;
@property(nonatomic, strong) NSArray *arr1;
@property(nonatomic, strong) NSArray *arr2;
@property(nonatomic, strong) NSArray *arr3;
@property(nonatomic, strong) NSArray *arr4;
@property(nonatomic, strong) NSArray *arr5;
@property(nonatomic, strong) NSArray *haderArr;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CXIDGLCSXViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 创建瀑布流对象,设置cell的尺寸和位置
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动的方向
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        // 设置cell的尺寸
        layout.itemSize = CGSizeMake(80, 80);
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = 0.0;
        // 设置行距
        layout.minimumLineSpacing = 10.0;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.headerReferenceSize = CGSizeMake(Screen_Width, 35);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headPicHeight+navHigh, Screen_Width, Screen_Height - navHigh - (headPicHeight)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (void)dealloc {
    //移除消息通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];
    NSMutableDictionary * dd = VAL_PUSHES.mutableCopy;
    if(VAL_HAS_RIGHT_XJPS){
        self.imageArrM = [NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:@"holiday_apply",@"XJListImage",@"出差",@"LCXXICON", nil],
                          [NSMutableArray arrayWithObjects:@"work_holiday",@"BXPSIcon",@"我的出差",@"WDXJICON", nil],
                          [NSMutableArray arrayWithObjects:@"XJPSImage",@"BXPSIMG",@"出差审批",@"XJSPICON", nil], nil];
    }else{
        self.imageArrM = [NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:@"holiday_apply",@"XJListImage",@"出差",@"LCXXICON", nil],
                          [NSMutableArray arrayWithObjects:@"work_holiday",@"BXPSIcon",@"我的出差",@"WDXJICON", nil],
                          [NSMutableArray arrayWithObjects:@"XJPSImage",@"BXPSIMG",@"出差审批", nil], nil];
    }
    self.arr1 = [NSArray arrayWithObjects:@"请假",@"销假",@"出差申请", @"流程消息", nil];
    self.arr2 = [NSArray arrayWithObjects:@"我的请假",@"我的报销",@"我的出差",@"我的销假", nil];
    if(VAL_HAS_RIGHT_XJPS){
        self.arr3 = [NSArray arrayWithObjects:@"请假审批",@"报销审批",@"出差审批",@"销假审批", nil];
    }else{
        self.arr3 = [NSArray arrayWithObjects:@"请假审批",@"报销审批", @"出差审批",nil];
    }
    
    self.haderArr = [NSArray arrayWithObjects:@"   我的申请",@"   已发申请", @"   我的待办", nil];
    self.dataArr = [NSMutableArray arrayWithObjects:_arr1, _arr2, _arr3, nil].mutableCopy;
    self.collectionView.bounces = NO;
    
    [self setupView];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.collectionView reloadData];
}

- (void)receivePushNotification:(NSNotification *)nsnotifi {
    [self.collectionView reloadData];
}

- (void)setupView {
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"我的流程")];
    
    UILabel *navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, headPicHeight)];
    [pic setImage:Image(@"myApproval")];
    [self.view addSubview:pic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.frame = cell.bounds;
    [cellButton setTitle:self.dataArr[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    [cellButton setImage:Image(self.imageArrM[indexPath.section][indexPath.row]) forState:UIControlStateNormal];
    
    [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:2 spacing:5];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];
    
    if (VAL_PUSHES_MSGS(IM_PUSH_PROGRESS)&& (indexPath.section == 0 && indexPath.row == 3)) {
        VAL_AddNumBadge(IM_PUSH_PROGRESS, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_QJ)&& (indexPath.section == 1 && indexPath.row == 0)) {
        VAL_AddNumBadge(IM_PUSH_QJ, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CK) && (indexPath.section == 2 && indexPath.row == 0)) {
        VAL_AddNumBadge(IM_PUSH_CK, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_BSPS)&& (indexPath.section == 2 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_BSPS, nil);
    }
    if (VAL_PUSHES_MSGS(IM_PUSH_CLSP2)&& (indexPath.section == 2 && indexPath.row == 2)){
        VAL_AddNumBadge(IM_PUSH_CLSP2, nil);
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = header.bounds;
        label.text = self.haderArr[indexPath.section];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = kColorWithRGB(247, 247, 247);
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        [header addSubview:label];
        //        if (indexPath.section != 0) {
        //            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, Screen_Width - 30, 0.5)];
        //            lineLabel.backgroundColor = [UIColor lightGrayColor];
        //            [header addSubview:lineLabel];
        //        }
        return header;
    } else {
        return nil;
    }
}


//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section:%zd---row:%zd", indexPath.section, indexPath.row);
    
    NSString *title = self.dataArr[indexPath.section][indexPath.row];
    
    NSLog(@"section = %zd,row = %zd",indexPath.section,indexPath.row);
    
    if ([@"请假" isEqualToString:title]) {
        CXVacationApplicationEditViewController *vc = [CXVacationApplicationEditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"销假" isEqualToString:title]) {
        IDGXJListViewController *vc = [IDGXJListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"出差申请" isEqualToString:title]){
        CXBussinessTripEditViewController *vc = [[CXBussinessTripEditViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"我的出差" isEqualToString:title]){
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"流程消息" isEqualToString:title]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PROGRESS);
        CXIDGMessageListViewController *vc = [CXIDGMessageListViewController new];
        vc.type = WDLCType;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"我的请假" isEqualToString:title]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_QJ);
        CXVacationApplicationListViewController *vc = [[CXVacationApplicationListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"我的销假" isEqualToString:title]) {
        CXWDXJListViewController *vc = [[CXWDXJListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"我的报销" isEqualToString:title]) {
        CXReimbursementListViewController *vc = [[CXReimbursementListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if([@"报销审批" isEqualToString:title]){
        CXReimbursementApprovalListViewController *vc = [[CXReimbursementApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([@"请假审批" isEqualToString:title]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
        CXVacationApprovalListViewController *vc = [[CXVacationApprovalListViewController alloc] init];
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
    else if ([@"出差审批" isEqualToString:title]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CLSP2);
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        vc.lbType = CXBusinessTripPS;
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
