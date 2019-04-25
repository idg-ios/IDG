 //
//  SDRootViewController.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/4/23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXMineViewController.h"

NSString *const SDRootViewControllerViewDidLoadNotification = @"SDRootViewControllerViewDidLoad";
NSInteger const kRootTopViewTag = 10200;

@interface SDRootViewController ()
/// 导航栏
@property(nonatomic, strong) SDRootTopView *rootTopView_;
@end

@implementation SDRootViewController

- (SDRootTopView *)getRootTopView {
    return [self rootTopView_];
}

- (SDRootTopView *)RootTopView {
    return [self getRootTopView];
}

- (SDRootTopView *)rootTopView_ {
    if (nil == _rootTopView_) {
        _rootTopView_ = [[NSBundle mainBundle] loadNibNamed:@"SDRootTopView" owner:self options:nil][0];
        _rootTopView_.tag = kRootTopViewTag;
        [self.view addSubview:_rootTopView_];
        _rootTopView_.translatesAutoresizingMaskIntoConstraints = NO;
        _rootTopView_.navTitleLabel.text = @"";

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_rootTopView_]-0-|" options:0 metrics:@{@"wd": @(CGRectGetWidth(self.view.bounds))} views:NSDictionaryOfVariableBindings(_rootTopView_)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rootTopView_(wd)]" options:0 metrics:@{@"wd": @(navHigh)} views:NSDictionaryOfVariableBindings(_rootTopView_)]];
    }

    return _rootTopView_;
}

- (void)networkChanged:(EMConnectionState)connectionState {

}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    // UIViewController只能有唯一一个UIScollView或者其子类，如果超过一个，需要将此属性设置为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    RDVTabBarController *tabBarVC = [AppDelegate get_RDVTabBarController];
//    if ([tabBarVC.selectedViewController isKindOfClass:[CXMineViewController class]]) {
//        self.RootTopView.backgroundColor = kMineModuleNavBackgroundColor;
//    }
    self.RootTopView.backgroundColor = kColorWithRGB(66, 81, 109);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDRootViewControllerViewDidLoadNotification object:self];
}

- (void)dealloc {
    HUD_HIDE;
    if (self.viewLoaded) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
