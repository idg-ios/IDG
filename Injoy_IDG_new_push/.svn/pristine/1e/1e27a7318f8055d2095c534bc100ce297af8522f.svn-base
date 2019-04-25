//
//  CXMyAttendanceViewController.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/17.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMyAttendanceViewController.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "VRGCalendarView.h"
#import "HttpTool.h"
#import "UIButton+LXMImagePosition.h"
#import "NSDate+YYAdd.h"
#import "CXAttendanceDetailModel.h"
#import "SDUserCurrentLocation.h"
#import "SDChatMapViewController.h"

// 定位间隔(sec)
#define kLocateInterval 10.0

// 是否专属定制 专属应用没有定位
#define kIsZSDZ (VAL_ISZHUAN_SHU_DING_ZHI)
// 是否开启定位（接口返回）
#define kOpenGetLocation (VAL_OPEN_GET_LOCATION)
// 定位是否可用=专属定制&&开启定位
//#define kAttendanceLocateEnable (kIsZSDZ && kOpenGetLocation)
//#define kAttendanceLocateEnable (kOpenGetLocation)
#define kAttendanceLocateEnable (YES)

@interface CXMyAttendanceViewController () <VRGCalendarViewDelegate>

/** 头部容器 */
@property (nonatomic, strong) UIView *headerView;
/** 签到 */
@property (nonatomic, strong) UIButton *signInButton;
/** 签退 */
@property (nonatomic, strong) UIButton *signOutButton;
/** 上班时间 */
@property (nonatomic, strong) CXEditLabel *startTimeLabel;
/** 下班时间 */
@property (nonatomic, strong) CXEditLabel *endTimeLabel;
/** 上班位置 */
@property (nonatomic, strong) UIButton *startPosButton;
/** 下班位置 */
@property (nonatomic, strong) UIButton *endPosButton;
/** 日历 */
@property (nonatomic, strong) VRGCalendarView *calendarView;
/** 定位计时器 */
@property (nonatomic, strong) NSTimer *locateTimer;
/** 用来定位 */
@property (nonatomic, strong) SDUserCurrentLocation *locator;
/** 当前经纬度 */
@property (nonatomic, assign) CLLocationCoordinate2D current_coordinate;
/** 地址 */
@property (nonatomic, copy) NSString *current_address;
/** 详情信息 */
@property (nonatomic, strong) CXAttendanceDetailModel *detailInfo;
/** 日历是否正在今天 */
@property (nonatomic, readonly) BOOL isShowingCurrentDate;

@end

@implementation CXMyAttendanceViewController

#pragma mark - Lazy
- (NSTimer *)locateTimer {
    if (_locateTimer == nil) {
        _locateTimer = [NSTimer scheduledTimerWithTimeInterval:kLocateInterval target:self selector:@selector(locateTimerFire) userInfo:nil repeats:YES];
        _locateTimer.fireDate = [NSDate distantFuture];
    }
    return _locateTimer;
}

- (BOOL)isShowingCurrentDate {
    return self.calendarView.selectedDate.year == [NSDate date].year &&
    self.calendarView.selectedDate.month == [NSDate date].month &&
    self.calendarView.selectedDate.day == [NSDate date].day;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setup];
    [self getSignStatus];
    
    if (kAttendanceLocateEnable == NO) {
        self.startPosButton.hidden = YES;
        self.endPosButton.hidden = YES;
    }
    else {
        self.locateTimer.fireDate = [NSDate distantPast];
    }
}

- (void)setupNavView {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"考勤"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(onLeftBarItemTap)];
}

- (void)setup {
    self.headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, 135)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });
    
    self.signInButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(60, 85);
        [btn setImage:Image(@"signin_enable") forState:UIControlStateNormal];
        [btn setImage:Image(@"signin_disable") forState:UIControlStateDisabled];
        [btn setTitle:@"签到" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:kColorWithRGB(167, 167, 167) forState:UIControlStateDisabled];
        [btn setImagePosition:LXMImagePositionTop spacing:5];
        btn.centerY = GET_HEIGHT(self.headerView) / 2;
        btn.right = Screen_Width / 2 - 35;
        [btn addTarget:self action:@selector(onSignInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        [self.headerView addSubview:btn];
        btn;
    });
    
    self.signOutButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(60, 85);
        [btn setImage:Image(@"signin_enable") forState:UIControlStateNormal];
        [btn setImage:Image(@"signin_disable") forState:UIControlStateDisabled];
        [btn setTitle:@"签退" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:kColorWithRGB(167, 167, 167) forState:UIControlStateDisabled];
        [btn setImagePosition:LXMImagePositionTop spacing:5];
        btn.centerY = GET_HEIGHT(self.headerView) / 2;
        btn.left = Screen_Width / 2 + 35;
        [btn addTarget:self action:@selector(onSignOutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        [self.headerView addSubview:btn];
        btn;
    });
    
    UIView *s1 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.headerView), Screen_Width, 1)];
        view.backgroundColor = kColorWithRGB(219, 219, 219);
        [self.view addSubview:view];
        view;
    });
    
    self.startPosButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:Image(@"signposition_gray") forState:UIControlStateDisabled];
        [btn setImage:Image(@"signposition_blue") forState:UIControlStateNormal];
        [btn setTitle:@"上班位置" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(onPositionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.right = Screen_Width - kFormViewMargin;
        btn.top = GET_MAX_Y(s1);
        btn.height = kLineHeight;
        [self.view addSubview:btn];
        btn;
    });
    
    self.startTimeLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s1), GET_MIN_X(self.startPosButton) - kFormViewMargin, kLineHeight)];
        label.title = @"上班时间：";
//        label.content = @"2017-08-18 08:30:00";
        label.allowEditing = NO;
        [self.view addSubview:label];
        label;
    });
    
    UIView *s2 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.startTimeLabel), Screen_Width, 1)];
        view.backgroundColor = kColorWithRGB(219, 219, 219);
        [self.view addSubview:view];
        view;
    });
    
    self.endPosButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:Image(@"signposition_gray") forState:UIControlStateDisabled];
        [btn setImage:Image(@"signposition_blue") forState:UIControlStateNormal];
        [btn setTitle:@"下班位置" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(onPositionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.right = Screen_Width - kFormViewMargin;
        btn.top = GET_MAX_Y(s2);
        btn.height = kLineHeight;
        [self.view addSubview:btn];
        btn;
    });
    
    self.endTimeLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s2), GET_MIN_X(self.endPosButton) - kFormViewMargin, kLineHeight)];
        label.title = @"下班时间：";
        label.allowEditing = NO;
        [self.view addSubview:label];
        label;
    });
    
    UIView *s3 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.endTimeLabel), Screen_Width, 1)];
        view.backgroundColor = kColorWithRGB(219, 219, 219);
        [self.view addSubview:view];
        view;
    });
    
    self.calendarView = ({
        VRGCalendarView *view = [[VRGCalendarView alloc] init];
        view.delegate = self;
        CGFloat mg = Screen_Width > 320 ? 15 * (Screen_Width / 375) : 0;
        view.top = GET_MAX_Y(s3) + mg;
        [self.view addSubview:view];
        view;
    });
}

#pragma mark - Private
- (void)getSignStatus {
    HUD_SHOW(nil);
    [HttpTool getWithPath:@"/workTime/checkWork.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            // 是否已签到
            BOOL isSignIn = [JSON[@"data"][@"upWork"] integerValue] == 1;
            // 是否已签退
            BOOL isSignOut = [JSON[@"data"][@"outWork"] integerValue] == 1;
            if (isSignIn == NO) {
                self.signInButton.enabled = YES;
            }
            else {
                if (isSignOut == NO) {
                    self.signOutButton.enabled = YES;
                }
            }
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        HUD_HIDE;
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        HUD_HIDE;
    }];
}

- (void)getSignTimeWithDate:(NSDate *)date {
    self.startTimeLabel.content = nil;
    self.endTimeLabel.content = nil;
    NSString *url = [NSString stringWithFormat:@"/workTime/getDetailsByDate/%zd/%zd/%zd.json", date.year, date.month, date.day];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            CXAttendanceDetailModel *detailInfo = [CXAttendanceDetailModel yy_modelWithJSON:JSON[@"data"]];
            self.startTimeLabel.content = detailInfo.upTime;
            self.endTimeLabel.content = detailInfo.outTime;
            self.detailInfo = detailInfo;
            
            self.startPosButton.enabled = self.endPosButton.enabled = YES;
            if (self.isShowingCurrentDate) {
                // 今天还没有签到 则禁用下班位置按钮
                if (self.signInButton.enabled == YES) {
                    self.endPosButton.enabled = NO;
                }
            }
            else {
                // 这天没有签到，禁用上班位置按钮
                if (self.detailInfo.upLocat.length <= 0) {
                    self.startPosButton.enabled = NO;
                }
                // 这天没有签退，则禁用下班位置按钮
                if (self.detailInfo.outLocat.length <= 0) {
                    self.endPosButton.enabled = NO;
                }
            }
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)locateTimerFire {
    self.locator = [[SDUserCurrentLocation alloc] initWithSignIn];
    @weakify(self);
    self.locator.detailCallback = ^(CLLocationCoordinate2D location, NSString *address) {
        @strongify(self);
        self.current_coordinate = location;
        self.current_address = address;
        NSLog(@"lon=%g, lat=%g, address=%@", location.longitude, location.latitude, address);
    };
    self.locator.signFail = ^{
        @strongify(self);
        self.current_coordinate = CLLocationCoordinate2DMake(0, 0);
        self.current_address = nil;
    };
}

#pragma mark - Event

- (void)onLeftBarItemTap {
    [self.navigationController popViewControllerAnimated:YES];
    [self.locateTimer invalidate];
    self.locateTimer = nil;
}

/** 签到 */
- (void)onSignInButtonTapped:(UIButton *)signInButton {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (kAttendanceLocateEnable) {
        if (self.current_coordinate.longitude == 0) {
            CXAlert(@"定位失败，不能签到");
            return;
        }
        params[@"upLocat"] = [NSString stringWithFormat:@"%g,%g", self.current_coordinate.longitude, self.current_coordinate.latitude];
        params[@"upLocation"] = self.current_address ?: @"";
    }
    HUD_SHOW(nil);
    [HttpTool postWithPath:@"/workTime/upWork.json" params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            // 日历是否正在今天
            if (self.isShowingCurrentDate) {
                self.startTimeLabel.content = JSON[@"data"][@"upDate"][@"upTime"];
            }
            self.signInButton.enabled = NO;
            self.signOutButton.enabled = YES;
            self.endPosButton.enabled = YES;
            CXAlert(@"签到成功");
        }
        else {
            CXAlert(JSON[@"msg"]);
            // 已经签到
            if ([JSON[@"status"] intValue] == 502) {
                self.signInButton.enabled = NO;
            }
        }
        [self.calendarView selectDate:[NSDate date].day];
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

/** 签退 */
- (void)onSignOutButtonTapped:(UIButton *)signOutButton {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (kAttendanceLocateEnable) {
        if (self.current_coordinate.longitude == 0) {
            CXAlert(@"定位失败，不能签退");
            return;
        }
        params[@"outLocat"] = [NSString stringWithFormat:@"%g,%g", self.current_coordinate.longitude, self.current_coordinate.latitude];
        params[@"upLocation"] = self.current_address ?: @"";
    }
    HUD_SHOW(nil);
    [HttpTool postWithPath:@"/workTime/outWork.json" params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            // 日历是否正在今天
            if (self.isShowingCurrentDate) {
                self.endTimeLabel.content = JSON[@"data"][@"outDate"][@"outTime"];
            }
            self.signOutButton.enabled = NO;
            CXAlert(@"签退成功");
        }
        else {
            CXAlert(JSON[@"msg"]);
            // 已经签退
            if ([JSON[@"status"] intValue] == 502) {
                self.signOutButton.enabled = NO;
            }
        }
        [self.calendarView selectDate:[NSDate date].day];
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)onPositionButtonTap:(UIButton *)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
    NSString *address = nil;
    // 上班位置
    if (sender == self.startPosButton) {
        if (self.detailInfo.upLocat.length) {
            NSArray<NSString *> *arr = [self.detailInfo.upLocat componentsSeparatedByString:@","];
            coordinate.longitude = arr[0].doubleValue;
            coordinate.latitude = arr[1].doubleValue;
            address = self.detailInfo.upLocation;
        }
        else {
            if (self.isShowingCurrentDate) {
                coordinate = self.current_coordinate;
                address = self.current_address;
            }
        }
    }
    // 下班位置
    else {
        if (self.detailInfo.outLocat.length) {
            NSArray<NSString *> *arr = [self.detailInfo.outLocat componentsSeparatedByString:@","];
            coordinate.longitude = arr[0].doubleValue;
            coordinate.latitude = arr[1].doubleValue;
            address = self.detailInfo.outLocation;
        }
        else {
            if (self.isShowingCurrentDate) {
                coordinate = self.current_coordinate;
                address = self.current_address;
            }
        }
    }
    if (coordinate.longitude != 0) {
        SDChatMapViewController *locationController = [[SDChatMapViewController alloc] initWithLocation:coordinate];
        locationController.address = address;
        locationController.showAddressAnnotation = YES;
        [self.navigationController pushViewController:locationController animated:YES];
    }
    else {
        CXAlert(@"没有位置信息");
    }
}

#pragma mark - VRGCalendarViewDelegate

- (void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month toYear:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated {
    
}

- (void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date lunarDict:(NSMutableDictionary*) dict {
    [self getSignTimeWithDate:date];
}

@end
