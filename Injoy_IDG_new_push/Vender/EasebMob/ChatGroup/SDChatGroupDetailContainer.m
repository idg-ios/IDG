//
//  SDChatGroupDetailContainer.m
//  SDMarketingManagement
//
//  Created by Rao on 15-4-29.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//
//群组聊天信息页面，第二个要改的

#import "SDChatGroupDetailContainer.h"
#import "ChatGroupDetailViewController.h"
#import "RDVTabBarController.h"

@interface SDChatGroupDetailContainer ()
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 群组详情
@property (nonatomic, strong) ChatGroupDetailViewController* groupDetailVC;
@end

@implementation SDChatGroupDetailContainer

- (instancetype)initWithGroupId:(NSString*)chatGroupId
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _groupDetailVC = [[ChatGroupDetailViewController alloc] initWithGroupId:chatGroupId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.rootTopView = [self getRootTopView];

    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImage* backImage = [UIImage imageNamed:@"back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(backButton);
    [self.rootTopView addSubview:backButton];

    // backButton宽度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backButton(wd)]" options:0 metrics:@{ @"wd" : @(backImage.size.width) } views:NSDictionaryOfVariableBindings(backButton)]];
    // backButton高度

    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton(ht)]-5-|" options:0 metrics:@{ @"ht" : @(backImage.size.height) } views:NSDictionaryOfVariableBindings(backButton)]];

    [self addChildViewController:self.groupDetailVC];
    [self.view addSubview:self.groupDetailVC.tableView];

    UITableView* tableView = self.groupDetailVC.tableView;
    UseAutoLayout(tableView);

    // tableView宽度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView(_rootTopView)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView, _rootTopView)]];
    // tableView高度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rootTopView][tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView, _rootTopView)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏
    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    [tabBarVC setTabBarHidden:YES animated:NO];

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 显示
    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    [tabBarVC setTabBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
