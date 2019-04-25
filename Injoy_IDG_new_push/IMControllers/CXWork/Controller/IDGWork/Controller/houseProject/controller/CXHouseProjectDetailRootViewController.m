//
//  CXHouseProjectDetailRootViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectDetailRootViewController.h"
#import "CXTopScrollView.h"
#import "CXHouseProjectBaseInfoViewController.h"
#import "CXHouseProjectDetailInfoViewController.h"
#import "CXHouseProjectMeetingViewController.h"
#import "CXHouseProjectAnnexViewController.h"

#define topScrollViewHeight 50.f
@interface CXHouseProjectDetailRootViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong)SDRootTopView *rootTopView;
@property (nonatomic, strong)CXTopScrollView *topScrollView;
@property (nonatomic, strong)UIPageViewController *pageViewController;
@property (nonatomic, strong)CXHouseProjectBaseInfoViewController *baseInfoController;
@property (nonatomic, strong)CXHouseProjectDetailInfoViewController *detailInfoController;
@property (nonatomic, strong)CXHouseProjectMeetingViewController *meetingController;
@property (nonatomic, strong)CXHouseProjectAnnexViewController *annexController;
@property (nonatomic, assign)NSInteger currentSelectVCIndex;
@property (nonatomic, copy)NSArray *vcArray;
@end

@implementation CXHouseProjectDetailRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self.view addSubview:self.rootTopView];
    [self.view addSubview:self.topScrollView];
    [self setUpPageViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpPageViewController{
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.frame = CGRectMake(0, navHigh+topScrollViewHeight, Screen_Width, Screen_Height - navHigh - topScrollViewHeight);
    [self.pageViewController setViewControllers:@[self.vcArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        // 之前的所在视图索引
        NSInteger lastSelectVCIndex = [self.vcArray indexOfObject:previousViewControllers.firstObject];
        if (self.currentSelectVCIndex != lastSelectVCIndex) {
            self.topScrollView.currentSelectIndex = self.currentSelectVCIndex;
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.currentSelectVCIndex = [self.vcArray indexOfObject:pendingViewControllers[0]];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return self.vcArray[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == self.vcArray.count - 1 || index == NSNotFound) {
        return nil;
    }
    return self.vcArray[++index];
}

- (CXHouseProjectBaseInfoViewController *)baseInfoController{
    if(nil == _baseInfoController){
        _baseInfoController = [[CXHouseProjectBaseInfoViewController alloc]init];
        _baseInfoController.projId = self.projId;
    }
    return _baseInfoController;
}
- (CXHouseProjectDetailInfoViewController *)detailInfoController{
    if(nil == _detailInfoController){
        _detailInfoController = [[CXHouseProjectDetailInfoViewController alloc]init];
        _detailInfoController.projId = self.projId;
    }
    return _detailInfoController;
}
- (CXHouseProjectMeetingViewController *)meetingController{
    if(nil == _meetingController){
        _meetingController = [[CXHouseProjectMeetingViewController alloc]init];
        _meetingController.projId = self.projId;
    }
    return _meetingController;
}
- (CXHouseProjectAnnexViewController *)annexController{
    if(nil == _annexController){
        _annexController = [[CXHouseProjectAnnexViewController alloc]init];
        _annexController.projId = self.projId;
    }
    return _annexController;
}
- (CXTopScrollView *)topScrollView{
    if(nil == _topScrollView){
        _topScrollView = [[CXTopScrollView alloc]initWithTitles:@[@"基本资料", @"详细信息", @"会议信息", @"附件"]];
        _topScrollView.frame = CGRectMake(0, navHigh, Screen_Width, topScrollViewHeight);
        @weakify(self);
        _topScrollView.callBack = ^(NSString *title, int tag, BOOL reverseOrForward) {
            @strongify(self);
            self.currentSelectVCIndex = tag - 1;
            NSLog(@"--title:%@--tag:%d--reverseOrForward:%d", title, tag, reverseOrForward);
            NSArray *vcArr = [NSArray arrayWithObject:self.vcArray[self.currentSelectVCIndex]];
            UIPageViewControllerNavigationDirection direction = reverseOrForward ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
            [self.pageViewController setViewControllers:vcArr direction:direction animated:YES completion:nil];
        };
        self.topScrollView.currentSelectIndex = 0;
    }
    return _topScrollView;
}
- (SDRootTopView *)rootTopView{
    if(nil == _rootTopView){
        _rootTopView = [self getRootTopView];
        [_rootTopView setNavTitle:@"地产项目"];
        [_rootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    }
    return _rootTopView;
}
- (UIPageViewController *)pageViewController{
    if(nil == _pageViewController){
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.backgroundColor = SDBackGroudColor;
    }
    return _pageViewController;
}
- (NSArray *)vcArray{
    return @[self.baseInfoController, self.detailInfoController, self.meetingController , self.annexController];
}
@end
