//
//  CXIDGPEPotentialProjectViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/27.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGPEPotentialProjectViewController.h"
#import "Masonry.h"
#import "CXAddPEPotentialProjectViewController.h"
#import "CXHaveMetProjectListViewController.h"
#import "CXHaveNotMetProjectListViewController.h"
#import "CXAllProjectListViewController.h"
#import "CXZJYXLGSViewController.h"
#import "UIView+YYAdd.h"

@interface CXIDGPEPotentialProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CXIDGPEPotentialProjectViewController

#define kImageTopSpace 12.0

#define kHeaderViewHeight 8.0

#define kViewLeftSpace 15.0

#define kImageLeftSpace 8.0

#define kImageWidth 60.0

#define kTextFontSize 18.0

#define kArrowImageWidth 16.0

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.titleName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(navHigh);
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){//新建项目
        CXAddPEPotentialProjectViewController *vc = [[CXAddPEPotentialProjectViewController alloc] init];
        vc.formType = CXFormTypeCreate;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(indexPath.section == 1){//已约见
        CXHaveMetProjectListViewController *vc = [[CXHaveMetProjectListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(indexPath.section == 2){
        CXHaveNotMetProjectListViewController *vc = [[CXHaveNotMetProjectListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(indexPath.section == 3){
        CXAllProjectListViewController *vc = [[CXAllProjectListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.section == 4){
        CXZJYXLGSViewController *vc = [[CXZJYXLGSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderViewHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"cellName";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(kViewLeftSpace, 0, Screen_Width - 2*kViewLeftSpace, kImageTopSpace*2 + kImageWidth);
    backView.backgroundColor = RGBACOLOR(245.0, 246.0, 248.0, 1.0);
    backView.layer.cornerRadius = 5.0;
    backView.clipsToBounds = YES;
    [cell.contentView addSubview:backView];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kImageLeftSpace, kImageTopSpace, kImageWidth, kImageWidth);
    if(indexPath.section == 0){
        imageView.image = [UIImage imageNamed:@"icon_iceforce_xjxm"];
        imageView.highlightedImage = [UIImage imageNamed:@"icon_iceforce_xjxm"];
    }else if(indexPath.section == 1){
        imageView.image = [UIImage imageNamed:@"icon_iceforce_yyj"];
        imageView.highlightedImage = [UIImage imageNamed:@"icon_iceforce_yyj"];
    }else if(indexPath.section == 2){
        imageView.image = [UIImage imageNamed:@"icon_iceforce_wyj"];
        imageView.highlightedImage = [UIImage imageNamed:@"icon_iceforce_wyj"];
    }else if(indexPath.section == 3){
        imageView.image = [UIImage imageNamed:@"icon_iceforce_QZXM"];
        imageView.highlightedImage = [UIImage imageNamed:@"icon_iceforce_QZXM"];
    }else if(indexPath.section == 4){
        imageView.image = [UIImage imageNamed:@"icon_iceforce_GS"];
        imageView.highlightedImage = [UIImage imageNamed:@"icon_iceforce_GS"];
    }
    [backView addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(kImageLeftSpace + kImageWidth + kImageLeftSpace, kImageTopSpace + (kImageWidth - kTextFontSize)/2, 300, kTextFontSize);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:kTextFontSize];
    titleLabel.textColor = [UIColor blackColor];
    if(indexPath.section == 0){
        titleLabel.text = @"新建项目";
    }else if(indexPath.section == 1){
        titleLabel.text = @"已约见项目";
    }else if(indexPath.section == 2){
        titleLabel.text = @"未约见项目";
    }else if(indexPath.section == 3){
        titleLabel.text = @"潜在项目(所有)";
    }else if(indexPath.section == 4){
        titleLabel.text = @"最具影响力公司";
    }
    [backView addSubview:titleLabel];
    
    UIImageView * detailImageView = [[UIImageView alloc] init];
    detailImageView.frame = CGRectMake(Screen_Width - kViewLeftSpace - kImageLeftSpace - 15.0 - kArrowImageWidth, kImageLeftSpace + (kImageWidth - kArrowImageWidth)/2, kArrowImageWidth, kArrowImageWidth);
    detailImageView.centerY = imageView.centerY;
    detailImageView.image = [UIImage imageNamed:@"arrow_more"];
    detailImageView.highlightedImage = [UIImage imageNamed:@"arrow_more"];
    [backView addSubview:detailImageView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 4){
        return kImageTopSpace*2 + kImageWidth + kHeaderViewHeight;
    }
    return kImageTopSpace*2 + kImageWidth;
}

@end
