//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXProjectDetailViewController.h"
#import "CXTopScrollView.h"
#import "UIView+YYAdd.h"
#import "CXBasicDataListViewController.h"
#import "CXInvestmentPlanListViewController.h"
#import "CXInvestmentAgreementListViewController.h"
#import "CXProjectSituationListViewController.h"
#import "CXConferenceInformationListViewController.h"

@interface CXProjectDetailViewController ()
        <
        UIPageViewControllerDelegate,
        UIPageViewControllerDataSource
        >
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) CXTopScrollView *topScrollView;
@property(nonatomic, strong) UIPageViewController *pageViewController;
@property(copy, nonatomic, readonly) NSArray *vcArr;
/// 基本资料
@property(strong, nonatomic) CXBasicDataListViewController *basicDataListViewController;
/// 投资方案
@property(strong, nonatomic) CXInvestmentPlanListViewController *investmentPlanListViewController;
/// 投资协议
@property(strong, nonatomic) CXInvestmentAgreementListViewController *agreementListViewController;
/// 项目情况
@property(strong, nonatomic) CXProjectSituationListViewController *projectSituationListViewController;
/// 会议信息
@property(strong, nonatomic) CXConferenceInformationListViewController *conferenceInformationListViewController;
@end

@implementation CXProjectDetailViewController {
    int currentSelectVCIndex;
}

#pragma mark - get & set

- (CXProjectManagerModel *)projectManagerModel {
    if (nil == _projectManagerModel) {
        _projectManagerModel = [[CXProjectManagerModel alloc] init];
    }
    return _projectManagerModel;
}

/// 基本资料
- (CXBasicDataListViewController *)basicDataListViewController {
    if (nil == _basicDataListViewController) {
        _basicDataListViewController = [[CXBasicDataListViewController alloc] init];
    }
    return _basicDataListViewController;
}

/// 投资方案
- (CXInvestmentPlanListViewController *)investmentPlanListViewController {
    if (nil == _investmentPlanListViewController) {
        _investmentPlanListViewController = [[CXInvestmentPlanListViewController alloc] init];
        _investmentPlanListViewController.eid = self.projectManagerModel.projId;
    }
    return _investmentPlanListViewController;
}

/// 基金投资
- (CXInvestmentAgreementListViewController *)agreementListViewController {
    if (nil == _agreementListViewController) {
        _agreementListViewController = [[CXInvestmentAgreementListViewController alloc] init];
        _agreementListViewController.eid = self.projectManagerModel.projId;
    }
    return _agreementListViewController;
}

/// 项目情况
- (CXProjectSituationListViewController *)projectSituationListViewController {
    if (nil == _projectSituationListViewController) {
        _projectSituationListViewController = [[CXProjectSituationListViewController alloc] init];
    }
    return _projectSituationListViewController;
}

/// 会议信息
- (CXConferenceInformationListViewController *)conferenceInformationListViewController {
    if (nil == _conferenceInformationListViewController) {
        _conferenceInformationListViewController = [[CXConferenceInformationListViewController alloc] init];
        _conferenceInformationListViewController.eid = self.projectManagerModel.projId;
    }
    return _conferenceInformationListViewController;
}

- (UIPageViewController *)pageViewController {
    if (nil == _pageViewController) {
        NSDictionary *options = @{
                UIPageViewControllerOptionSpineLocationKey: @(UIPageViewControllerSpineLocationMin)
        };

        _pageViewController = [[UIPageViewController alloc]
                initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _pageViewController;
}

- (NSArray *)vcArr {
    return @[
            self.basicDataListViewController, // 基本资料
            self.projectSituationListViewController, // 项目情况
            self.investmentPlanListViewController, // 投资方案
            self.agreementListViewController, // 投资协议
            self.conferenceInformationListViewController // 会议信息
    ];
}

/// 顶部滚动view
- (CXTopScrollView *)topScrollView {
    if (nil == _topScrollView) {
        _topScrollView = [[CXTopScrollView alloc] initWithTitles:@[
                @"基本资料",
                @"项目情况",
                @"投资方案",
                @"基金投资",
                @"会议信息"]];
    }
    return _topScrollView;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (YES == completed) {
        // 之前的所在视图索引
        int lastSelectVCIndex = [self.vcArr indexOfObject:previousViewControllers.firstObject];
        if (currentSelectVCIndex != lastSelectVCIndex) {
            self.topScrollView.currentSelectIndex = currentSelectVCIndex;
        }
    }
}

- (void)     pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    currentSelectVCIndex = [self.vcArr indexOfObject:pendingViewControllers[0]];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = [self.vcArr indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return self.vcArr[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    int index = [self.vcArr indexOfObject:viewController];
    if (index == self.vcArr.count - 1 || index == NSNotFound) {
        return nil;
    }
    return self.vcArr[++index];
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:self.title];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopScrollView {
    [self.view addSubview:self.topScrollView];
    self.topScrollView.frame = (CGRect) {0.f, self.rootTopView.bottom, Screen_Width, CXTopScrollView_height};
    @weakify(self);
    self.topScrollView.callBack = ^(NSString *title, int tag, BOOL reverseOrForward) {
        @strongify(self);
        currentSelectVCIndex = tag - 1;
        NSLog(@"--title:%@--tag:%d--reverseOrForward:%d", title, tag, reverseOrForward);
        NSArray *vcArr = [NSArray arrayWithObject:self.vcArr[currentSelectVCIndex]];
        UIPageViewControllerNavigationDirection direction = reverseOrForward ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;

        [self.pageViewController setViewControllers:vcArr
                                          direction:direction
                                           animated:YES
                                         completion:nil];
    };

    self.topScrollView.currentSelectIndex = 0;
}

- (void)setUpPageViewController {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    CGFloat y = self.rootTopView.bottom + CXTopScrollView_height + 10.f;
    self.pageViewController.view.frame = (CGRect) {0.f, y, GET_WIDTH(self.view), Screen_Height - y};

    [self.pageViewController setViewControllers:@[self.vcArr[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;

    [self setUpNavBar];
    [self setUpPageViewController];
    [self setUpTopScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
