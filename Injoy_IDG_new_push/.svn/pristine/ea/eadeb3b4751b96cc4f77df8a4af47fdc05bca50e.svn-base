//
//  SDRootNavigationController.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/4/23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootNavigationController.h"


@interface SDRootNavigationController ()

@end

@implementation SDRootNavigationController

- (void)viewDidLoad
{
    // 隐藏导航条
    self.navigationBarHidden = YES;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/// 支持旋转不
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

/// 支持旋转方向
//- (NSUInteger)supportedInterfaceOrientations
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

/// 设置viewController被presented的首选方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
