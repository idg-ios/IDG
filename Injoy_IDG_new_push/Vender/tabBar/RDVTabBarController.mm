// RDVTabBarController.m
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "AsyncSocket.h"
#import "HttpTool.h"
#import "NSString+TextHelper.h"
#import "RDVTabBarController+IM.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "SDCompanyUserModel.h"
#import "SDDataBaseHelper.h"
#import "SDIMConversationViewController.h"
#import "SDJsonManager.h"
#import "SDSocketCacheManager.h"
#import "SDWebSocketManager.h"
#import "UIView+CXCategory.h"
#import "YYModel.h"
#import <objc/runtime.h>
#import "UIView+CXCategory.h"

#import "SDIMConversationViewController.h"
#import "CXLoaclDataManager.h"
#import "CXNewIDGWorkRootViewController.h"

@interface UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController*)tabBarController;

@end

@interface RDVTabBarController () <UIAlertViewDelegate,
AsyncSocketDelegate> {
    UIView* _contentView;
}

@property (nonatomic, readwrite) RDVTabBar* tabBar;
@property (nonatomic, strong) NSDate* lastPlaySoundDate;
@property (nonatomic, assign) EMConnectionState connectionState;
@property (nonatomic, weak) UIImageView* curveImageView;

@end

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@implementation RDVTabBarController

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        /// 回到登录界面
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#warning duanwang
- (void)networkChanged:(EMConnectionState)connectionState
{
    // 企信首页网络变化
    SDIMConversationViewController* messageVC = (SDIMConversationViewController*)self.viewControllers[0];
    _connectionState = connectionState;
    [messageVC networkChanged:connectionState];
}

- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
#warning 这个震动和播放音频的库被我干掉了，以后再加－－－－－－－－－－－？？？？－－－－
    //    // 收到消息时，播放音频
    //    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    //    // 收到消息时，震动
    //    [[EMCDDeviceManager sharedInstance] playVibration];
}

#pragma mark - View lifecycle
- (instancetype)init
{
    if (self = [super init]) {
        
        //-----------------------------这个要注意--------------------------
        //这里从tabbar的init开始就下载四张数据库表
        
        [self imInit];
    }
    return self;
}

#pragma mark - view life

- (void)dealloc
{
    [self imDealoc];
    //移除消息通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
    UIView * bottomWhiteView = [[UIView alloc] init];
    bottomWhiteView.frame = CGRectMake(0, Screen_Height, Screen_Width, kTabbarSafeBottomMargin);
    bottomWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomWhiteView];
    
    //    if ([[[NSUserDefaults standardUserDefaults] valueForKey:KIMVoiceGroup] boolValue]) {
    //        [self.tabBar.items[tabBar_IMVoice] addBadge];
    //    }
    
    
}

static BOOL isFirstShow = YES;
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //外部员工登陆不显示curve.png
//    if (_tabBar.items.count == 2) {
//        return;
//    }
    
    [_tabBar bringSubviewToFront:self.curveImageView];
    //这段代码只执行一次
    if (isFirstShow) {
        
        isFirstShow = NO;
        UIImage* curveImage = nil;
        UIImageView* curveImageView = [[UIImageView alloc] initWithImage:curveImage];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_tabBar addSubview:curveImageView];
            UseAutoLayout(curveImageView);
            self.curveImageView = curveImageView;
            
            NSDictionary* curveMetrics = @{ @"wd" : @(curveImage.size.width),
                                            @"ht" : @(curveImage.size.height) };
            
            [_tabBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[curveImageView(wd)]" options:0 metrics:curveMetrics views:NSDictionaryOfVariableBindings(curveImageView)]];
            [_tabBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-10)-[curveImageView(ht)]" options:0 metrics:curveMetrics views:NSDictionaryOfVariableBindings(curveImageView)]];
            
            [_tabBar addConstraint:[NSLayoutConstraint constraintWithItem:curveImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_tabBar attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSelectedIndex:[self selectedIndex]];
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];
    
    
    //工作模块显示红点
    NSInteger count = [self.view countNumBadge:IM_PUSH_DM,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_PROGRESS,IM_PUSH_QJ,IM_PUSH_BS,IM_PUSH_XIAO,IM_PUSH_CLSP,nil];
    
    NSInteger num = [CXPushHelper getMyApprove];//我的审批
    if (num != 0) {
        count += num;
    }
    
    [self setReadOrUnRead:count andTypeNum:0];
    //I-Chat模块显示红点
    NSArray *conversations = [[CXIMService sharedInstance].chatManager loadConversations];
    // 未读总数
    NSInteger unreadMessagesToatl = 0;
    for (CXIMConversation *conversation in conversations) {
        unreadMessagesToatl += conversation.unreadNumber;
    }
    NSInteger I_ChatCount = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_GSXW,IM_PUSH_NEWSLETTER/*,CX_NK_Push*/,nil];
    NSInteger sysUnreadCount = 0;

    sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1

    [self setReadOrUnRead:I_ChatCount + unreadMessagesToatl + sysUnreadCount  andTypeNum:1];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceivePushNotificationKey object:nil];
}

- (void)receivePushNotification:(NSNotification*)nsnotifi
{
    //NSMutableDictionary* params = [[nsnotifi object] mutableCopy];
    //for (NSString* key in [params allKeys]) {
    //
    //}
    //工作模块显示红点
    NSInteger count = [self.view countNumBadge:IM_PUSH_DM,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_PROGRESS,IM_PUSH_QJ,IM_PUSH_XIAO,IM_PUSH_BS,IM_PUSH_CLSP,nil];
    
    NSInteger num = [CXPushHelper getMyApprove];
    if (num != 0) {
        count += num;
    }
    
    [self setReadOrUnRead:count andTypeNum:0];
    //I-Chat模块显示红点
    NSArray *conversations = [[CXIMService sharedInstance].chatManager loadConversations];
    // 未读总数
    NSInteger unreadMessagesToatl = 0;
    for (CXIMConversation *conversation in conversations) {
        unreadMessagesToatl += conversation.unreadNumber;
    }
    NSInteger I_ChatCount = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_GSXW,IM_PUSH_NEWSLETTER/*,CX_NK_Push*/,nil];
    
    NSInteger sysUnreadCount = 0;

    sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1

    [self setReadOrUnRead:I_ChatCount + unreadMessagesToatl + sysUnreadCount andTypeNum:1];
}

- (void)setReadOrUnRead:(NSInteger)numRead andTypeNum:(int)typeNum
{
    if (numRead > 0) {
        [self.tabBar.items[typeNum] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)numRead]];
    }
    else {
        [self.tabBar.items[typeNum] setBadgeValue:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController* viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    for (UIViewController* viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] || ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController*)selectedViewController
{
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    UIImage* curveImage;
    if (selectedIndex == 2) {
        //        curveImage = [UIImage imageNamed:@"curve_highlight.png"];
    }
    else {
        //        curveImage = [UIImage imageNamed:@"curve.png"];
    }
    self.curveImageView.image = curveImage;
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setViewControllers:(NSArray*)viewControllers
{
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController* viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray* tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController* viewController in viewControllers) {
            RDVTabBarItem* tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController rdv_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    }
    else {
        for (UIViewController* viewController in _viewControllers) {
            [viewController rdv_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController*)viewController
{
    UIViewController* searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (RDVTabBar*)tabBar
{
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor whiteColor]];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _tabBarHidden = hidden;
    
    __weak RDVTabBarController* weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = kTabbarHeight + kTabbarSafeBottomMargin;
        }
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    }
    else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar*)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController* selectedController = (UINavigationController*)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar*)tabBar didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
    //    if (index == tabBar_IMVoice) {
    //        /// 点击就移除红点
    //        [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:KIMVoiceGroup];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        [self.tabBar.items[tabBar_IMVoice] removeBadge];
    //    }
}






@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController*)tabBarController
{
    objc_setAssociatedObject(self, @selector(rdv_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (RDVTabBarControllerItem)

- (RDVTabBarController*)rdv_tabBarController
{
    RDVTabBarController* tabBarController = objc_getAssociatedObject(self, @selector(rdv_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController rdv_tabBarController];
    }
    
    return tabBarController;
}

- (RDVTabBarItem*)rdv_tabBarItem
{
    RDVTabBarController* tabBarController = [self rdv_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)rdv_setTabBarItem:(RDVTabBarItem*)tabBarItem
{
    RDVTabBarController* tabBarController = [self rdv_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    RDVTabBar* tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray* tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

#pragma mark - 我的审批数量
-(NSInteger)getMyApprove{
    
    NSInteger trave = [[NSUserDefaults standardUserDefaults] integerForKey:CX_trave];
    NSInteger holiday = [[NSUserDefaults standardUserDefaults] integerForKey:CX_holiday];
    NSInteger resumption = [[NSUserDefaults standardUserDefaults] integerForKey:CX_resumption];
    NSInteger cost = [[NSUserDefaults standardUserDefaults] integerForKey:CX_cost];
    
    NSInteger sum = trave+holiday+resumption+cost;
    return sum;
}

#pragma mark - 获取我的审批总数量
-(void)getSumNumber{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getTraveService];
        [self getHolidayService];
        [self getResumptionService];
        [self getCostService];
        dispatch_sync(dispatch_get_main_queue(), ^{
          
        });
    });
    
}

#pragma 获取出差数量
-(void)getTraveService{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/trave",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_trave];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取请假数量
-(void)getHolidayService{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/holiday",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_holiday];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取销假数量
-(void)getResumptionService{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/resumption",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_resumption];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取报销数量
-(void)getCostService{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/cost",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_cost];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
