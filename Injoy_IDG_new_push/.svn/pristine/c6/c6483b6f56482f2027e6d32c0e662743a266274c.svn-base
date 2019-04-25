//
//  CXNewYGZNRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewYGZNRootViewController.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXHolidaySystemViewController.h"
#import "CXTravelSystemViewController.h"
#import "CXInternalBulletinListViewController.h"
#import "CXCommonTemplateViewController.h"

@interface CXNewYGZNRootViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(copy, readonly, nonatomic) NSArray *imageArr;
@property (nonatomic, copy) NSString *eid;

@end

@implementation CXNewYGZNRootViewController

#define kItemWidth 90.0
#define kItemLeftSpace (Screen_Width - kItemWidth*3)/4.0
#define kItemTopSpace 23.0
#define kCollectionViewTopSpace 45.0
#define headPicHeight (IS_iPhoneX?(Screen_Width*855.0/1125.0):(Screen_Width*350.0/750.0))
#define kWhiteCornerRaius 16.0

static NSString *const cellId_1 = @"cellId";
static NSString *const headerId = @"headerId";

#pragma mark - get & set

- (NSArray *)imageArr {
    return @[@"icon_iceforce_gzzd", @"icon_iceforce_xzbg", @"icon_iceforce_commonTemplate"/*, @"icon_iceforce_gzzd", @"icon_iceforce_gzzd"*/];
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"规章制度", @"行政办公", @"常用模板"/*, @"年假制度", @"差旅制度"*/, nil];
    }
    return _dataSourceArr;
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(kItemWidth, 80);
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = kItemLeftSpace;
        // 设置行距
        layout.minimumLineSpacing = kItemTopSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, kItemLeftSpace, 0, kItemLeftSpace);
        layout.headerReferenceSize = CGSizeMake(GET_WIDTH(self.view), kCollectionViewTopSpace);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect) {0.f, headPicHeight - kWhiteCornerRaius, Screen_Width, Screen_Height - headPicHeight + kWhiteCornerRaius} collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId_1];
        
        _collectionView.layer.cornerRadius = kWhiteCornerRaius;
        _collectionView.clipsToBounds = YES;
    }
    return _collectionView;
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"员工指南"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    self.rootTopView.backgroundColor = [UIColor clearColor];
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, headPicHeight)];
    if(IS_iPhoneX){
        [pic setImage:Image(@"iphoneX_pic_iceforce_bg")];
    }else{
        [pic setImage:Image(@"ICEForceImg")];
    }
    [self.view addSubview:pic];
    [self.view bringSubviewToFront:self.rootTopView];
}

- (void)setUpCollectionView {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(headPicHeight - kWhiteCornerRaius);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSourceArr[indexPath.row];
    
    if ([@"规章制度" isEqualToString:title]) {
        CXInternalBulletinListViewController *vc = [[CXInternalBulletinListViewController alloc]initWithType:isTool];
        vc.i_kind = GZZD;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"行政办公" isEqualToString:title]) {
        CXInternalBulletinListViewController *vc = [[CXInternalBulletinListViewController alloc]initWithType:isTool];
        vc.i_kind = XZBG;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"年假制度" isEqualToString:title]) {
        CXHolidaySystemViewController *vc = [CXHolidaySystemViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"差旅制度" isEqualToString:title]) {
        CXTravelSystemViewController *vc = [CXTravelSystemViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"常用模板" isEqualToString:title]) {
        CXInternalBulletinListViewController *vc = [[CXInternalBulletinListViewController alloc]initWithType:isTool];
        vc.i_kind = CYMB;
//        CXCommonTemplateViewController *vc = [CXCommonTemplateViewController new];
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
        return headerView;
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
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:LXMImagePositionTop spacing:IS_iPhoneX?10.0:5.0];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];
    
    return cell;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavBar];
    
    [self setUpCollectionView];
    
//    [self loadData];
}
- (void)loadData{//常用模板
    NSString *path = [NSString stringWithFormat:@"%@tool/list/1",urlPrefix];
    //pageNumber,s_title,i_kind
    NSDictionary *parmas = @{@"pageNumber":@(1),
                             @"s_title":@"",
                             @"i_kind":@(3)};
    [HttpTool postWithPath:path params:parmas success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if(status == 200){
            self.eid = JSON[@"data"];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
