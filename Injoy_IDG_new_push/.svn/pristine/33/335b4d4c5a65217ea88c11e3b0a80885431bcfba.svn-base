//
//  SDGroupSettingContainer.m
//  SDMarketingManagement
//
//  Created by Rao on 15-4-29.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//
// 第四个要改的，屏蔽群消息页面

#import "SDGroupSettingContainer.h"
#import "GroupSettingViewController.h"
#import "RDVTabBarController.h"

@interface SDGroupSettingContainer ()
@property (nonatomic, strong) GroupSettingViewController* groupSettingVC;
@property (nonatomic, strong) SDRootTopView* rootTopView;
@end

@implementation SDGroupSettingContainer

- (instancetype)initWithGroup:(EMGroup*)group
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _groupSettingVC = [[GroupSettingViewController alloc] initWithGroup:group];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rootTopView = [self getRootTopView];

    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(backButton);
    [self.rootTopView addSubview:backButton];

    // backButton宽度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backButton(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];
    // backButton高度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton(44)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];

    UITableView* tableView = self.groupSettingVC.tableView;
    UseAutoLayout(tableView);
    

#warning 屏蔽群消息页面－－－－－－－－－－－？？？？－－－－－－－－－－这个重新写
    [self addChildViewController:self.groupSettingVC];
    [self.view addSubview:tableView];

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
