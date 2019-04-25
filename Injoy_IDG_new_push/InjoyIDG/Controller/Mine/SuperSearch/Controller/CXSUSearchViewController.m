//
//  CXSUSearchViewController.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/17.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSUSearchViewController.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "CXStatementOfAffairsViewController.h"
#import "CXProjectCollaborationListViewController.h"
#import "CXDDXVoiceMeetingListViewController.h"
#import "CXNoticeController.h"
#import "CXWorkOutsideListViewController.h"
#import "CXBorrowingApplicationListViewController.h"
#import "CXWorkLogListViewController.h"
#import "CXLeaveApplicationListViewController.h"
#import "CXDailyMeetingViewController.h"

@interface CXSUSearchViewController ()

/** 内容视图 */
@property(nonatomic, strong) UIView *contentView;
/** 头部容器 */
@property(nonatomic, strong) UIView *headerView;
/** 主模块label */
@property(nonatomic, strong) CXEditLabel *menuLabel;
/** 搜索框 */
@property(nonatomic, strong) UITextField *searchField;
/** 输入框 */
@property(nonatomic, strong) CXEditLabel *inputLabel;
/** 当前菜单 */
@property(nonatomic, strong) NSString *currentMenu;

/** 大菜单 */
@property(nonatomic, copy) NSArray<NSString *> *menus;

@end

@implementation CXSUSearchViewController {
    /** 指定功能点 */
    BOOL _isFixedFunction;
}

#pragma mark - Getter & Setter

- (NSArray<NSString *> *)menus {
    if (!_menus) {
        _menus = @[
                @"公告通知",
                @"日常会议",
                @"语音会议"
        ];
    }
    return _menus;
}

#pragma mark - Life Cycle

- (instancetype)initWithMenu:(NSString *)menu {
    if (self = [super init]) {
        _menu = menu;
        if (menu.length) {
            _isFixedFunction = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavView];
    [self setup];

    if (self.menu.length) {
        self.menuLabel.content = self.menu;
        self.menuLabel.selectedPickerData = @{
                CXEditLabelCustomPickerTextKey: self.menu
        };
        self.menuLabel.didFinishEditingBlock(self.menuLabel);
    } else {
        self.menuLabel.didFinishEditingBlock(self.menuLabel);
    }
}

- (void)setupNavView {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.title ?: @"超级搜索"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setup {
    self.headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });

    // 左右间隔
    CGFloat marginLR = 40 * (Screen_Width / 375);

    self.menuLabel = ({
        CGFloat w = 80;
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(marginLR, 0, w, GET_HEIGHT(self.headerView) / 2 + 7)];
        if (Screen_Width > 320) {
            label.width = 80 * (Screen_Width / 360);
        }
        label.centerY = GET_HEIGHT(self.headerView) / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kColorWithRGB(230, 236, 250);
        label.showDropdown = YES;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = kColorWithRGB(123, 123, 123).CGColor;
        label.inputType = CXEditLabelInputTypeCustomPicker;
        label.pickerTextArray = self.menus;
        @weakify(self);
        label.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            @strongify(self);
            NSString *menu = editLabel.content;
            if ([menu isEqualToString:self.currentMenu]) {
                return;
            }
            self.currentMenu = menu;
            [self onSelectMenu:menu];
        };
        label.selectViewTitle = @"业务";
        label.content = label.pickerTextArray.firstObject;
        [self.headerView addSubview:label];
        label;
    });

    UIButton *searchButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(123, 123, 123)] forState:UIControlStateNormal];
        [btn setTitle:@"搜 索" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = self.menuLabel.contentFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = kColorWithRGB(123, 123, 123).CGColor;
        [btn addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });

    self.searchField = ({
        UITextField *txf = [[UITextField alloc] init];
        txf.left = GET_MAX_X(self.menuLabel) + 5;
        txf.width = Screen_Width - GET_MIN_X(txf) - marginLR;
        txf.height = GET_HEIGHT(self.menuLabel);
        txf.centerY = GET_HEIGHT(self.headerView) / 2;
        txf.placeholder = @"关键词";
        txf.layer.borderWidth = 0.5;
        txf.layer.borderColor = kColorWithRGB(123, 123, 123).CGColor;
        txf.leftViewMode = UITextFieldViewModeAlways;
        txf.leftView = ({
            UIView *view = [[UIView alloc] init];
            view.width = 5;
            view.height = GET_HEIGHT(txf);
            view;
        });
        txf.rightViewMode = UITextFieldViewModeAlways;
        txf.rightView = searchButton;
        searchButton.width = 54 * (Screen_Width / 360);
        searchButton.height = GET_HEIGHT(txf);
        [self.headerView addSubview:txf];
        txf;
    });

    self.inputLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        label.frame = self.searchField.frame;
        label.width = GET_WIDTH(self.searchField) - GET_WIDTH(self.searchField.rightView);
        label.inputType = CXEditLabelInputTypeText;
        label.textColor = [UIColor clearColor];
        @weakify(self);
        label.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            @strongify(self);
            editLabel.content = trim(editLabel.content);
            self.searchField.text = editLabel.content;
        };
        [self.headerView addSubview:label];
        label;
    });

    UIView *sLine = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.headerView), Screen_Width, 10)];
        view.backgroundColor = kColorWithRGB(242, 241, 247);
        [self.view addSubview:view];
        view;
    });
    [sLine hash];

    self.contentView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(sLine), Screen_Width, Screen_Height - GET_MAX_Y(sLine))];
        view.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:view belowSubview:self.RootTopView];
        view;
    });
}

#pragma mark - Private

- (void)searchButtonTapped:(UIButton *)searchButton {
    [self.view endEditing:YES];
    // 大菜单：eg. 公告通知
    NSString *menu = self.menuLabel.content;
    // 搜索文字
    NSString *searchText = trim(self.searchField.text);
    NSLog(@"menu=%@&query=%@", menu, searchText);

    if ([menu isEqualToString:@"公告通知"]) {
        CXNoticeController *vc = [[CXNoticeController alloc] init];
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"日常会议"]) {
        CXDailyMeetingViewController *vc = [[CXDailyMeetingViewController alloc] init];
        vc.fromSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"项目协同"]) {
        CXProjectCollaborationListViewController *vc = [[CXProjectCollaborationListViewController alloc] init];
        vc.isSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"语音会议"]) {
        CXDDXVoiceMeetingListViewController *vc = [[CXDDXVoiceMeetingListViewController alloc] init];
        vc.isSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"工作外出"]) {
        CXWorkOutsideListViewController *vc = [[CXWorkOutsideListViewController alloc] init];
        vc.fromSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"借支申请"]) {
        CXBorrowingApplicationListViewController *vc = [[CXBorrowingApplicationListViewController alloc] init];
        vc.fromSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"工作日志"]) {
        CXWorkLogListViewController *vc = [[CXWorkLogListViewController alloc] init];
        vc.fromSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    } else if ([menu isEqualToString:@"请假申请"]) {
        CXLeaveApplicationListViewController *vc = [[CXLeaveApplicationListViewController alloc] init];
        vc.fromSuperSearch = YES;
        vc.searchText = searchText;
        [self displayViewController:vc];
    }
}

- (void)displayViewController:(__kindof UIViewController *)viewController {
    if ([viewController isKindOfClass:[SDRootViewController class]]) {
        SDRootViewController *vc = (SDRootViewController *) viewController;
        if (_isFixedFunction == NO) {
            vc.fromSuperSearch = YES;
        }
    }

    static NSInteger kSubViewTag = 12345;
    UIView *subView = [self.contentView viewWithTag:kSubViewTag];
    [subView removeFromSuperview];
    [subView.viewController removeFromParentViewController];

    BOOL isContainsRootTopView = ({
        NSInteger idx = [viewController.view.subviews indexOfObjectPassingTest:^BOOL(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return [obj isKindOfClass:[SDRootTopView class]];
        }];
        idx != NSNotFound;
    });
    if (isContainsRootTopView) {
        // 遮住 rootTopView
        viewController.view.frame = CGRectMake(0, -navHigh, GET_WIDTH(self.contentView), GET_HEIGHT(self.contentView) + navHigh);
    } else {
        viewController.view.frame = self.contentView.bounds;
    }
    viewController.view.tag = kSubViewTag;
    [self.contentView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)onSelectMenu:(NSString *)menu {
    self.inputLabel.content = nil;
    self.searchField.text = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
