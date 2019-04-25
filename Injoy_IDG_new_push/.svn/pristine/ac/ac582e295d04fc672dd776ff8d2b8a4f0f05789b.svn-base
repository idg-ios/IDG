//
//  CXIDGProjectManagementDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGProjectManagementDetailViewController.h"
#import "CXTopScrollView.h"
#import "UIView+YYAdd.h"
#import "CXBasicDataListViewController.h"
#import "CXInvestmentPlanListViewController.h"
#import "CXInvestmentAgreementListViewController.h"
#import "CXProjectSituationListViewController.h"
#import "CXIDGConferenceInformationListViewController.h"
#import "CXFundInvestmentListViewController.h"
#import "CXIDGBasicInformationViewController.h"
#import "CXIDGInvestmentProgramListViewController.h"
#import "CXIDGProjectStatusViewController.h"
#import "CXIDGFJListViewController.h"

@interface CXIDGProjectManagementDetailViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

/** rootTopView */
@property(strong, nonatomic) SDRootTopView *rootTopView;
/** topScrollView */
@property(strong, nonatomic) CXTopScrollView * topScrollView;
/** pageViewController */
@property(strong, nonatomic) UIPageViewController *pageViewController;
/** currentSelectVCIndex */
@property(nonatomic) NSInteger currentSelectVCIndex;
/** vcArr */
@property(copy, nonatomic, readonly) NSArray *vcArr;
/// 基本资料
@property(strong, nonatomic) CXIDGBasicInformationViewController *basicDataListViewController;
/// 投资方案
@property(strong, nonatomic) CXIDGInvestmentProgramListViewController *investmentPlanListViewController;
/// 项目情况
@property(strong, nonatomic) CXIDGProjectStatusViewController *projectSituationListViewController;
/// 基金投资
@property(strong, nonatomic) CXFundInvestmentListViewController *fundInvestmentListViewController;
/// 会议信息
@property(strong, nonatomic) CXIDGConferenceInformationListViewController *conferenceInformationListViewController;
/// 附件
@property(strong, nonatomic) CXIDGFJListViewController *FJListViewController;

@end

@implementation CXIDGProjectManagementDetailViewController

#pragma mark - get & set
- (CXIDGProjectManagementListModel *)model {
    if (!_model) {
        _model = [[CXIDGProjectManagementListModel alloc] init];
    }
    return _model;
}

/// 基本资料
- (CXIDGBasicInformationViewController *)basicDataListViewController {
    if (!_basicDataListViewController) {
        _basicDataListViewController = [[CXIDGBasicInformationViewController alloc] init];
        _basicDataListViewController.model = self.model;
    }
    return _basicDataListViewController;
}

/// 投资方案
- (CXIDGInvestmentProgramListViewController *)investmentPlanListViewController {
    if (!_investmentPlanListViewController) {
        _investmentPlanListViewController = [[CXIDGInvestmentProgramListViewController alloc] init];
        _investmentPlanListViewController.model = self.model;
    }
    return _investmentPlanListViewController;
}

/// 项目情况
- (CXIDGProjectStatusViewController *)projectSituationListViewController {
    if (!_projectSituationListViewController) {
        _projectSituationListViewController = [[CXIDGProjectStatusViewController alloc] init];
        _projectSituationListViewController.model = self.model;
    }
    return _projectSituationListViewController;
}

/// 基金投资
- (CXFundInvestmentListViewController *)fundInvestmentListViewController {
    if (!_fundInvestmentListViewController) {
        _fundInvestmentListViewController = [[CXFundInvestmentListViewController alloc] init];
        _fundInvestmentListViewController.model = self.model;
    }
    return _fundInvestmentListViewController;
}

/// 会议信息
- (CXIDGConferenceInformationListViewController *)conferenceInformationListViewController {
    if (!_conferenceInformationListViewController) {
        _conferenceInformationListViewController = [[CXIDGConferenceInformationListViewController alloc] init];
        _conferenceInformationListViewController.model = self.model;
    }
    return _conferenceInformationListViewController;
}

/// 附件
- (CXIDGFJListViewController *)FJListViewController {
    if (!_FJListViewController) {
        _FJListViewController = [[CXIDGFJListViewController alloc] init];
        _FJListViewController.eid = self.model.projId.integerValue;//16322;  //
    }
    return _FJListViewController;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
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
             self.fundInvestmentListViewController, // 基金投资
             self.conferenceInformationListViewController, // 会议信息
             self.FJListViewController // 附件
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
                                                                   @"会议信息",
                                                                   @"附件"]];
    }
    return _topScrollView;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        // 之前的所在视图索引
        NSInteger lastSelectVCIndex = [self.vcArr indexOfObject:previousViewControllers.firstObject];
        if (self.currentSelectVCIndex != lastSelectVCIndex) {
            self.topScrollView.currentSelectIndex = self.currentSelectVCIndex;
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.currentSelectVCIndex = [self.vcArr indexOfObject:pendingViewControllers[0]];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArr indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return self.vcArr[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArr indexOfObject:viewController];
    if (index == self.vcArr.count - 1 || index == NSNotFound) {
        return nil;
    }
    return self.vcArr[++index];
}

#pragma mark - UI
- (void)setUpNavBar {
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:self.title];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopScrollView {
    [self.view addSubview:self.topScrollView];
    self.topScrollView.frame = CGRectMake(0, self.rootTopView.bottom, Screen_Width, CXTopScrollView_height);
    @weakify(self);
    self.topScrollView.callBack = ^(NSString *title, int tag, BOOL reverseOrForward) {
        @strongify(self);
        self.currentSelectVCIndex = tag - 1;
        NSLog(@"--title:%@--tag:%d--reverseOrForward:%d", title, tag, reverseOrForward);
        NSArray *vcArr = [NSArray arrayWithObject:self.vcArr[self.currentSelectVCIndex]];
        UIPageViewControllerNavigationDirection direction = reverseOrForward ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        [self.pageViewController setViewControllers:vcArr
                                          direction:direction
                                           animated:YES
                                         completion:nil];
        [self.rootTopView setNavTitle:self.model.projName];
    };
    
    self.topScrollView.currentSelectIndex = 0;
    [self.rootTopView setNavTitle:self.model.projName];
}

- (void)setUpPageViewController {
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGFloat y = self.rootTopView.bottom + CXTopScrollView_height;
    self.pageViewController.view.frame = CGRectMake(0, y, GET_WIDTH(self.view), Screen_Height - y);
    
    [self.pageViewController setViewControllers:@[self.vcArr[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    
    [self setUpNavBar];
    [self setUpPageViewController];
    [self setUpTopScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
