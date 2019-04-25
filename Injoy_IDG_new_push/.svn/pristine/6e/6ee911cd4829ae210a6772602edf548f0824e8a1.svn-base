//
//  CXItemManagementListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/6.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXItemManagementListViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "CXIDGProjectManagementListViewController.h"
#import "UIView+CXCategory.h"
#import "HttpTool.h"
#import "CXIDGItemManagementListModel.h"
#import "CXIDGResearchReportListViewController.h"
#import "CXTMTPotentialProjectListViewController.h"
#import "CXIDGPEPotentialProjectViewController.h"
#import "CXHouseProjectListViewController.h"
#import "CXYMBadAssetsViewController.h"//新增不良资产
#import "CXSearchView.h"
#import "MBProgressHUD+Add.h"

@interface CXItemManagementListViewController
()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UICollectionView *collectionView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(copy, readonly, nonatomic) NSArray *imageArr;
@property(nonatomic, strong) NSMutableArray<CXIDGItemManagementListModel *> * itemManagementListModelArray;
@property(nonatomic, strong) NSMutableArray<NSString *> * itemManagementPicNameListArray;

@end

@implementation CXItemManagementListViewController

#define kItemWidth 90.0
#define kItemLeftSpace (Screen_Width - kItemWidth*3)/4.0
#define kItemTopSpace 23.0
#define kCollectionViewTopSpace 45.0
#define headPicHeight (IS_iPhoneX?(Screen_Width*855.0/1125.0):(Screen_Width*350.0/750.0))
#define kWhiteCornerRaius 16.0

static NSString *const cellId_1 = @"cellId";
static NSString *const headerId = @"headerId";

- (NSMutableArray<NSString *> *)itemManagementPicNameListArray{
    if(!_itemManagementPicNameListArray){
        _itemManagementPicNameListArray = @[].mutableCopy;
    }
    return _itemManagementPicNameListArray;
}

- (NSArray *)imageArr {
    for(CXIDGItemManagementListModel * model in self.itemManagementListModelArray){
        if([model.menuId isEqualToString:@"invest_proj"]){
            [self.itemManagementPicNameListArray addObject:@"XMGL"];
        }else if([model.menuId isEqualToString:@"projResearch"]){
            [self.itemManagementPicNameListArray addObject:@"YJBG"];
        }else if([model.menuId isEqualToString:@"lpsInfo"]){
            [self.itemManagementPicNameListArray addObject:@"projGroup8"];
        }else if([model.menuId isEqualToString:@"unInvProj"]){
            [self.itemManagementPicNameListArray addObject:@"PEQZXM"];
        }else if([model.menuId isEqualToString:@"unInvTMTProj"]){
            [self.itemManagementPicNameListArray addObject:@"TMTQZXM"];
        }else if ([model.menuId isEqualToString:@"reProj"]){
            [self.itemManagementPicNameListArray addObject:@"fdc"];
        }else if ([model.menuId isEqualToString:@"badProj"]){
            [self.itemManagementPicNameListArray addObject:@"BLZCImg"];
        }else if([model.menuId isEqualToString:@"projFinancing"]){
            [self.itemManagementPicNameListArray addObject:@"TMTQZXM"];
        }else{
            [self.itemManagementPicNameListArray addObject:@"TMTQZXM"];//默认使用tmt的图标
        }
    }
    return self.itemManagementPicNameListArray;
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        NSMutableArray * data = @[].mutableCopy;
        for(CXIDGItemManagementListModel * model in self.itemManagementListModelArray){
            [data addObject:model.menuName];
        }
        _dataSourceArr = [NSMutableArray arrayWithArray:data];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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

- (NSMutableArray<CXIDGItemManagementListModel *> *)itemManagementListModelArray{
    if(!_itemManagementListModelArray){
        _itemManagementListModelArray = @[].mutableCopy;
    }
    return _itemManagementListModelArray;
}

- (void)loadItemManagementListData{
    NSString *url = [NSString stringWithFormat:@"%@project/menu", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {

        if ([JSON[@"status"] intValue] == 200) {
            
            NSMutableArray *dataMutArray = [NSMutableArray arrayWithArray:[JSON objectForKey:@"data"]];
            NSArray<CXIDGItemManagementListModel *> *data = [NSArray yy_modelArrayWithClass:[CXIDGItemManagementListModel class] json:dataMutArray];
            NSMutableArray *array = [data mutableCopy];
            self.itemManagementListModelArray = array;
           
            [self setUpCollectionView];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"ICEForce"];//iceforce项目版块
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
- (void)pushBadAssets{
    [self.navigationController pushViewController:[CXYMBadAssetsViewController new] animated:YES];
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
    CXIDGItemManagementListModel *model = self.itemManagementListModelArray[indexPath.row];
    if ([model.menuId isEqualToString:@"invest_proj"]) {
        CXIDGProjectManagementListViewController *vc = [[CXIDGProjectManagementListViewController alloc] init];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([model.menuId isEqualToString:@"projResearch"]) {
        CXIDGResearchReportListViewController *vc = [CXIDGResearchReportListViewController new];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([model.menuId isEqualToString:@"unInvProj"]) {
        CXIDGPEPotentialProjectViewController *vc = [CXIDGPEPotentialProjectViewController new];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([model.menuId isEqualToString:@"unInvTMTProj"]) {
        CXTMTPotentialProjectListViewController *vc = [CXTMTPotentialProjectListViewController new];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    if ([model.menuId isEqualToString:@"projFinancing"]) {
        CXTMTPotentialProjectListViewController *vc = [CXTMTPotentialProjectListViewController new];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    if ([model.menuId isEqualToString:@"reProj"]) {
        CXHouseProjectListViewController *vc = [CXHouseProjectListViewController new];
        vc.titleName = model.menuName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([model.menuId isEqualToString:@"badProj"]) {
        CXYMBadAssetsViewController *badAssetsViewController = [[CXYMBadAssetsViewController alloc] init];
        badAssetsViewController.navTitle = model.menuName;
        [self.navigationController pushViewController:badAssetsViewController animated:YES];
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
    [self loadItemManagementListData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
