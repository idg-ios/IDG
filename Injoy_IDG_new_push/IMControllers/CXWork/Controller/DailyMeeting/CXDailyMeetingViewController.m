//
//  CXDailyMeetingViewController.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDailyMeetingViewController.h"
#import "FSCalendar.h"
#import <EventKit/EventKit.h>
#import "Masonry.h"
#import "HttpTool.h"
#import "NSObject+YYAdd.h"
#import "NSDate+YYAdd.h"
#import "CXDailyMeetingModel.h"
#import "UIButton+LXMImagePosition.h"
#import "CXDailyMeetingMonthListViewController.h"
#import "CXDailyMeetingDayListCell.h"
#import "CXIDGDailyMeetingDetailViewController.h"

#import "CXYMEventStore.h"

#define kTimeZone ([NSTimeZone localTimeZone])
#define kLocaleIdentifier @"zh-CN"
#define kLocale ([NSLocale localeWithLocaleIdentifier:kLocaleIdentifier])

@interface CXDailyMeetingViewController () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

/** 日期格式化器 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
/** 阳历 */
@property (nonatomic, strong) NSCalendar *gregorianCalendar;
/** 是否显示农历 */
@property (nonatomic, assign) BOOL showLunar;
/** 农历 */
@property (nonatomic, strong) NSCalendar *lunarCalendar;
/** 农历字符 */
@property (nonatomic, copy) NSArray<NSString *> *lunarChars;
/** 农历月份字符 */
@property (nonatomic, copy) NSArray<NSString *> *lunarMonthChars;

/** 头部的日期视图 */
@property (nonatomic, strong) UIView *dateView;
/** 日期+星期几 */
@property (nonatomic, strong) UILabel *dateLabel;
/** 农历 */
@property (nonatomic, strong) UILabel *lunarLabel;
/** 日历 */
@property (nonatomic, strong) FSCalendar *calendarView;
/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 底部视图顶部分割线 */
@property (nonatomic, strong) UIView *bottomViewTopLine;
/** 底部视图中间分割线 */
@property (nonatomic, strong) UIView *bottomViewMiddleLine;
/** 所有会议 */
@property (nonatomic, strong) UIButton *allMeetingsButton;
/** 我的会议 */
@property (nonatomic, strong) UIButton *myMeetingsButton;

/** 会议数据 key=日期,value=会议数组 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<CXDailyMeetingModel *> *> *meetingDictionay;

/** 当前日期（选中的日期，若没有选中，则为今天）  */
@property (nonatomic, strong) NSDate *focusedDate;

/** 切换日历scope的手势 */
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;


@property (nonatomic, strong) NSArray *eventStoreArray;

@end

NSString *const kCellId = @"cell";

@implementation CXDailyMeetingViewController

/** 会议日历默认进来是最近月份的数据（进入页面请求当前月份的数据，如果当前月份数据为空，则向前循环请求kGetMonthDataMaxCount次，有数据就停止，显示有数据的月份，如果之前kGetMonthDataMaxCount个月的数据均为空，则显示当前月份，如果当前月份为1月，则不往前循环，即循环到1月为止）*/
#define kGetMonthDataMaxCount 11

#pragma mark - Get Set
- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
        _dateFormatter.locale = kLocale;
        _dateFormatter.timeZone = kTimeZone;
    }
    return _dateFormatter;
}

- (NSCalendar *)gregorianCalendar {
    if (_gregorianCalendar == nil) {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _gregorianCalendar.locale = kLocale;
        _gregorianCalendar.timeZone = kTimeZone;
    }
    return _lunarCalendar;
}

- (NSCalendar *)lunarCalendar {
    if (_lunarCalendar == nil) {
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = kLocale;
        _lunarCalendar.timeZone = kTimeZone;
    }
    return _lunarCalendar;
}

- (NSArray<NSString *> *)lunarChars {
    if (_lunarChars == nil) {
        _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    }
    return _lunarChars;
}

- (NSArray<NSString *> *)lunarMonthChars {
    if (_lunarMonthChars == nil) {
        _lunarMonthChars = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"腊月"];
    }
    return _lunarMonthChars;
}

- (NSMutableDictionary<NSString *,NSArray<CXDailyMeetingModel *> *> *)meetingDictionay {
    if (_meetingDictionay == nil) {
        _meetingDictionay = [NSMutableDictionary dictionary];
    }
    return _meetingDictionay;
}

#pragma mark - Life Cycle
- (void)dealloc {
    //移除消息通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)receivePushNotification{
//    [self.tableView reloadData];
     [self setup];
    [self getFirstInCurrentPageMonthMeetingListWithCount:0];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 红点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification) name:kReceivePushNotificationKey object:nil];//我的审批,收到推送
    
    self.showLunar = YES;
    
    [self setup];
    
    [self getFirstInCurrentPageMonthMeetingListWithCount:0];
    
    [self loadEventStore];//拉取所有的日历事件
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}
#pragma mark -- 拉取日历事件
- (void)loadEventStore{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;//年
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger year = [dateComponent year];

    NSString *type = @"year";
    NSString *path = [NSString stringWithFormat:@"%@meet/monthOrdayList/%@",urlPrefix,type];
    NSDictionary *params = @{@"type":type,
                         @"date":[NSString stringWithFormat:@"%ld",year],
                         @"kind":@"all"};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSLog(@"日历===%@",JSON[@"data"]);
            NSDictionary *valueDictionary = JSON[@"data"];
            NSArray *arr = valueDictionary.allValues;
            if(arr.count == 0 || arr == nil) return ;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i<arr.count; i++) {
                NSArray *array = arr[i];
                if(array == nil || array.count == 0) return;
                for (NSDictionary *dic in array) {
                    [dataArray addObject:dic];
                }
            }
            NSArray *eventStoreArray = [CXYMEventStore eventStoreWithArray:dataArray];
            self.eventStoreArray = eventStoreArray;
//            [self writeEventStoreToCalanderWithArray:eventStoreArray];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}
- (void)writeEventStoreToCalanderWithArray:(NSArray *)array{
    if(array == nil || array.count == 0) return;
    if ([UIDevice currentDevice].systemVersion.floatValue <6.0) return;
 
    NSMutableArray *failEventStoreArray = [NSMutableArray array];
    
    for (CXYMEventStore *ymEventStore in array) {
        EKEventStore *ekEventStore = [[EKEventStore alloc] init];
      
        if ([ekEventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
            [ekEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error){
                        NSLog(@"事件写入失败,error:%@",error);
                        [failEventStoreArray addObject:ekEventStore];
                        [self writeEventStoreToCalanderWithArray:failEventStoreArray];
                    }else if (!granted){
                        NSLog(@"事件写入失败,//被用户拒绝，不允许访问日历");
                        MAKE_TOAST_D(@"您没有开放日历权限,请前往系统设置打开日历权限", 3);
                    }else{
                        EKEvent *event  = [EKEvent eventWithEventStore:ekEventStore];
                        //是否已经存了
                        NSString *eventId = [[NSUserDefaults standardUserDefaults]objectForKey:@"eventId"];
                        if (eventId) {//如果已经存了
//                            return; NSLog(@"已经存了");
                            NSError *err;
                            EKEvent *ekEvent = [ekEventStore  eventWithIdentifier:eventId];
//                            if (ekEvent == event) return ;
                            [ekEventStore removeEvent:ekEvent span:EKSpanThisEvent error:&err];
                        }
                        event.title = ymEventStore.title ? : @"写一个demo,日历事件";
                        event.location = ymEventStore.meetPlace ? : @"超享公司";
                        NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                        [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        event.startDate = [tempFormatter dateFromString:ymEventStore.startTime];
                        event.endDate = [tempFormatter dateFromString:ymEventStore.endTime];
                        event.allDay = YES;
                        //添加提醒,开始前30分钟
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60.0f * 60.0f * 30]];
                        event.notes = ymEventStore.title ? : @"这里是备注,标题";
                        [event setCalendar:[ekEventStore defaultCalendarForNewEvents]];
                        NSError *err;
                        [ekEventStore saveEvent:event span:EKSpanThisEvent error:&err];
                        NSLog(@"保存成功");
                        //保存事件id，方便查询和删除
                        [[NSUserDefaults standardUserDefaults]setObject:event.eventIdentifier forKey:@"eventId"];
                    }
                });
            }];
        }
    }
//    MAKE_TOAST_D(@"同步日历成功", 3);
//    [CXShareAlertView showViewWithMessage:@"同步日历成功"];
    [self showHUDWithMessage];
}
- (void)showHUDWithMessage{
    UIView* view = [[UIApplication sharedApplication].delegate window];
    if(!view){
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"同步日历成功";
    hud.margin = 20.f;
    hud.yOffset = IS_IPHONE_5 ? 200.f : 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
#pragma mark -- write event to location
- (void)rightBarButtonItemClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提\t示" message:@"是否将会议信息同步到日历" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.eventStoreArray == nil || self.eventStoreArray.count == 0) return;
        [self writeEventStoreToCalanderWithArray:self.eventStoreArray];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (void)setup {
    [self.RootTopView setNavTitle:@"月会安排"];
    [self.RootTopView setUpLeftBarItemGoBack];
//    [self.RootTopView setUpRightBarItemTitle:@"同步" addTarget:self action:@selector(rightBarButtonItemClick)];
    
    self.view.backgroundColor = RGBACOLOR(246.0, 246.0, 246.0, 1.0);
    
    self.dateView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        view;
    });
    
    self.dateLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        // 格式化为：2017-12-20 星期三
        label.text = @"";
        [self.dateView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dateView);
            make.bottom.equalTo(self.dateView.mas_centerY).offset(-2);
        }];
        label;
    });
    
    self.lunarLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(95, 94, 100);
        label.font = [UIFont systemFontOfSize:14];
        // "十一月初五"
        label.text = @"";
        [self.dateView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dateView);
            make.top.equalTo(self.dateView.mas_centerY).offset(2);
        }];
        label;
    });
    
    self.calendarView = ({
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
        calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
        calendar.backgroundColor = [UIColor whiteColor];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.locale = kLocale;
        calendar.appearance.headerDateFormat = @"yyyy / MM"; // 头部日期格式
        calendar.headerHeight = 30; // 头部高度
        calendar.firstWeekday = 2; // 星期一开始
        calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase; // 直接显示一二三四五六日
        calendar.appearance.headerTitleColor = [UIColor blackColor]; // 日历顶部标题颜色
        calendar.appearance.weekdayTextColor = kColorWithRGB(136, 136, 136); // 周x的文字颜色
        calendar.appearance.todayColor = kColorWithRGB(239, 240, 242); // 今天背景颜色
        calendar.appearance.todaySelectionColor = RGBACOLOR(172, 21, 45, 1.0); // 今天选中时的背景颜色
        calendar.appearance.selectionColor = RGBACOLOR(172, 21, 45, 1.0); // 其他日期选中时的背景颜色
        calendar.appearance.titleFont = [UIFont boldSystemFontOfSize:18]; // 日标题字体
        calendar.appearance.subtitleFont = [UIFont systemFontOfSize:10]; // 农历标题字体
        calendar.appearance.subtitleDefaultColor = kColorWithRGB(169, 176, 184); // 农历标题颜色
        [calendar reloadData];
        [self.view addSubview:calendar];
        [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@325);
        }];
        calendar;
    });
    
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
            make.height.mas_equalTo(48.0);
        }];
        view;
    });
    
    self.bottomViewTopLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
        [self.bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bottomView);
            make.top.equalTo(self.bottomView);
            make.height.mas_equalTo(1.0);
        }];
        view;
    });
    
    self.bottomViewMiddleLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(247, 248, 250, 1.0);
        [self.bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((Screen_Width - 1.0)/2.0);
            make.top.mas_equalTo((48.0 - 24.0)/2.0);
            make.width.mas_equalTo(1.0);
            make.height.mas_equalTo(24.0);
        }];
        view;
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = RGBACOLOR(246.0, 246.0, 246.0, 1.0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CXDailyMeetingDayListCell class] forCellReuseIdentifier:kCellId];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.calendarView.mas_bottom).offset(7.0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        tableView;
    });
    
    self.allMeetingsButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"所有会议" forState:UIControlStateNormal];
        [button setTitleColor:kColorWithRGB(31, 34, 40) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setImage:Image(@"icon_SYHY") forState:UIControlStateNormal];
        [button setImagePosition:LXMImagePositionLeft spacing:10];
        [button addTarget:self action:@selector(onAllMeetingsButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.bottomView);
            make.width.equalTo(self.bottomView).multipliedBy(0.5);
        }];
        button;
    });
    
    self.myMeetingsButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"我的会议" forState:UIControlStateNormal];
        [button setTitleColor:kColorWithRGB(31, 34, 40) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setImage:Image(@"icon_WDHY") forState:UIControlStateNormal];
        [button setImagePosition:LXMImagePositionLeft spacing:10];
        [button addTarget:self action:@selector(onMyMeetingsButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.bottomView);
            make.width.equalTo(self.bottomView).multipliedBy(0.5);
        }];
        button;
    });
    
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(246.0, 246.0, 246.0, 1.0);
        view;
    });
    
    // 顶部的线
    UIView *line1 = [line deepCopy];
    [self.bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomView);
        make.height.mas_equalTo(1 / UIScreen.mainScreen.scale);
    }];
    
    // 中间的线
    UIView *line2 = [line deepCopy];
    [self.bottomView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(1 / UIScreen.mainScreen.scale);
        make.centerX.equalTo(self.bottomView);
    }];
    
    self.scopeGesture = ({
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(handleScopeGesture:)];
        panGesture.delegate = self;
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 2;
        [self.view addGestureRecognizer:panGesture];
        panGesture;
    });
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:self.scopeGesture];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    shouldBegin = shouldBegin && [self tableView:self.tableView numberOfRowsInSection:0];
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendarView.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    if (self.showLunar) {
        NSInteger day = [self.lunarCalendar component:NSCalendarUnitDay fromDate:date];
        return self.lunarChars[day-1];
    }
    return nil;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    [self.calendarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(CGRectGetHeight(bounds)));
    }];
    [self.view layoutIfNeeded];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    BOOL hasMeeting = self.meetingDictionay[dateString].count > 0;
    // 有会议的日期才能选择
    return hasMeeting;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (monthPosition == FSCalendarMonthPositionPrevious || monthPosition == FSCalendarMonthPositionNext) {
        [calendar selectDate:date scrollToDate:YES];
    }
    self.focusedDate = date;
    [self setTopViewInfoWithDate:date];
    [self.tableView reloadData];
    
//    if (calendar.scope != FSCalendarScopeWeek) {
//        // 显示不下时更改为周视图
//        BOOL overflow = self.tableView.contentSize.height > self.tableView.frame.size.height;
//        if (overflow) {
//            [calendar setScope:FSCalendarScopeWeek animated:YES];
//        }
//    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSString *month = [calendar.currentPage stringWithFormat:@"yyyy-MM" timeZone:kTimeZone locale:kLocale];
    [self getMonthMeetingList:month];
}

#pragma mark - FSCalendarDelegateAppearance

/** 填充颜色 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    BOOL hasMeeting = self.meetingDictionay[dateString].count > 0;
    BOOL isToday = [self.gregorianCalendar isDate:date inSameDayAsDate:[NSDate date]];
    if (hasMeeting) {
        if (isToday == NO) {
            // 有会议时显示红色背景
            return kColorWithRGB(244, 206, 212);
        }
    }
    return nil;
}

/** 边框颜色 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    BOOL hasMeeting = self.meetingDictionay[dateString].count > 0;
    BOOL isToday = [self.gregorianCalendar isDate:date inSameDayAsDate:[NSDate date]];
    if (hasMeeting) {
        if (isToday == NO) {
            // 有会议时显示红色边框
            return kColorWithRGB(244, 206, 212);
        }
    }
    return nil;
}

#pragma mark - UITableView Protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *selectedDate = [self.dateFormatter stringFromDate:self.focusedDate];
    NSArray<CXDailyMeetingModel *> *meetings = self.meetingDictionay[selectedDate];
    return meetings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1.0 + 20.0 + 18.0 + 8.0 + 14.0 + 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedDate = [self.dateFormatter stringFromDate:self.focusedDate];
    NSArray<CXDailyMeetingModel *> *meetings = self.meetingDictionay[selectedDate];
    CXDailyMeetingDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.isShowYear = NO;
    cell.meetingModel = meetings[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedDate = [self.dateFormatter stringFromDate:self.focusedDate];
    NSArray<CXDailyMeetingModel *> *meetings = self.meetingDictionay[selectedDate];
    
    CXIDGDailyMeetingDetailViewController *vc = [[CXIDGDailyMeetingDetailViewController alloc] init];
    vc.eid = meetings[indexPath.row].eid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (NSString *)getMonthStringWithMonthInteger:(NSInteger)monthInteger{
    if(monthInteger < 10){
        return [NSString stringWithFormat:@"0%zd",monthInteger];
    }
    return [NSString stringWithFormat:@"%zd",monthInteger];
}

/**
 第一次进入页面，需要显示最近的月份的会议数据，最大请求次数为kGetMonthDataMaxCount
 
 @param month 传 2017-12
 */

- (void)getFirstInCurrentPageMonthMeetingListWithCount:(NSInteger)aCount{
    //第一次进入页面，先请求当前月份的数据，如果数据不为空，则显示当前日期和月份的数据，如果为空，继续向前请求，如果当前月份为1月，则停止
    __block NSInteger count = aCount;
    NSDate *today = [NSDate date];
    NSString *nowMonth = [today stringWithFormat:@"yyyy-MM" timeZone:kTimeZone locale:kLocale];
    NSString *nowYearStr = [today stringWithFormat:@"yyyy" timeZone:kTimeZone locale:kLocale];
    NSString *nowMonthStr = [today stringWithFormat:@"MM" timeZone:kTimeZone locale:kLocale];
    if([nowMonthStr isEqualToString:@"01"]){
        NSDictionary *params = @{
                                 @"date": nowMonth
                                 };
        [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
                __block BOOL needUpdate = NO;
                [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                    // date: 2017-12-12
                    // meetingsDict: [CXDailyMeetingModel]
                    // 还没有获取过这天的数据
                    if (self.meetingDictionay[date] == nil) {
                        NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                        self.meetingDictionay[date] = meetings;
                        needUpdate = YES;
                    }
                }];
                // 需要更新时才重新加载，改善卡顿
                if (needUpdate) {
                    [self.calendarView reloadData];
                    [self.tableView reloadData];
                }
                self.focusedDate = today;

                NSString *nowMonth = [today stringWithFormat:@"yyyy-MM" timeZone:kTimeZone locale:kLocale];
                [self getMonthMeetingList:nowMonth];

                [self.calendarView selectDate:today];
                [self setTopViewInfoWithDate:today];
                [self.tableView reloadData];
                return;
            }
            else {
                CXAlert(JSON[@"msg"]);
                return;
            }
        } failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
            return;
        }];
    }else{
        //循环往前请求月份数据
        NSDictionary *params = @{
                                 @"date": [NSString stringWithFormat:@"%@-%@",nowYearStr,[self getMonthStringWithMonthInteger:[nowMonthStr integerValue] - count]]
                                 };
        [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
                //如果1月有数据，则显示一月的数据，如果一月没有数据，则显示当前月份的数据
                if(data && [data count] > 0){
                    __block BOOL needUpdate = NO;
                    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                        // date: 2017-12-12
                        // meetingsDict: [CXDailyMeetingModel]
                        // 还没有获取过这天的数据
                        if (self.meetingDictionay[date] == nil) {
                            NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                            self.meetingDictionay[date] = meetings;
                            needUpdate = YES;
                        }
                    }];
                    // 需要更新时才重新加载，改善卡顿
                    if (needUpdate) {
                        [self.calendarView reloadData];
                        [self.tableView reloadData];
                    }
                    NSDate * date = [self getMinimumDateWithData:data];
                    self.focusedDate = date;
                    
                    [self getMonthMeetingList:[NSString stringWithFormat:@"%@-%@",nowYearStr,[self getMonthStringWithMonthInteger:[nowMonthStr integerValue] - count]]];
                    
                    [self.calendarView selectDate:date];
                    [self setTopViewInfoWithDate:date];
                    [self.tableView reloadData];
                    return;
                }else{
                    count++;
                    if(([nowMonthStr integerValue] - count) <= 1){
                        NSDictionary *params = @{
                                                 @"date": [NSString stringWithFormat:@"%@-01",nowYearStr]
                                                 };
                        [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
                            if ([JSON[@"status"] intValue] == 200) {
                                NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
                                //如果1月有数据，则显示一月的数据，如果一月没有数据，则显示当前月份的数据
                                if(data && [data count] > 0){
                                    __block BOOL needUpdate = NO;
                                    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                                        // date: 2017-12-12
                                        // meetingsDict: [CXDailyMeetingModel]
                                        // 还没有获取过这天的数据
                                        if (self.meetingDictionay[date] == nil) {
                                            NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                                            self.meetingDictionay[date] = meetings;
                                            needUpdate = YES;
                                        }
                                    }];
                                    // 需要更新时才重新加载，改善卡顿
                                    if (needUpdate) {
                                        [self.calendarView reloadData];
                                        [self.tableView reloadData];
                                    }
                                    NSDate * date = [self getMinimumDateWithData:data];
                                    self.focusedDate = date;
                                    
                                    [self getMonthMeetingList:[NSString stringWithFormat:@"%@-01",nowYearStr]];
                                    
                                    [self.calendarView selectDate:date];
                                    [self setTopViewInfoWithDate:date];
                                    [self.tableView reloadData];
                                    return;
                                }else{
                                    NSDictionary *params = @{
                                                             @"date": nowMonth
                                                             };
                                    [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
                                        if ([JSON[@"status"] intValue] == 200) {
                                            NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
                                            __block BOOL needUpdate = NO;
                                            [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                                                // date: 2017-12-12
                                                // meetingsDict: [CXDailyMeetingModel]
                                                // 还没有获取过这天的数据
                                                if (self.meetingDictionay[date] == nil) {
                                                    NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                                                    self.meetingDictionay[date] = meetings;
                                                    needUpdate = YES;
                                                }
                                            }];
                                            // 需要更新时才重新加载，改善卡顿
                                            if (needUpdate) {
                                                [self.calendarView reloadData];
                                                [self.tableView reloadData];
                                            }
                                            self.focusedDate = today;
                                            
                                            NSString *nowMonth = [today stringWithFormat:@"yyyy-MM" timeZone:kTimeZone locale:kLocale];
                                            [self getMonthMeetingList:nowMonth];
                                            
                                            [self.calendarView selectDate:today];
                                            [self setTopViewInfoWithDate:today];
                                            [self.tableView reloadData];
                                            return;
                                        }
                                        else {
                                            CXAlert(JSON[@"msg"]);
                                            return;
                                        }
                                    } failure:^(NSError *error) {
                                        CXAlert(KNetworkFailRemind);
                                        return;
                                    }];
                                }
                            }
                            else {
                                CXAlert(JSON[@"msg"]);
                                return;
                            }
                        } failure:^(NSError *error) {
                            CXAlert(KNetworkFailRemind);
                            return;
                        }];
                    }
                    else if(count == kGetMonthDataMaxCount){
                        NSDictionary *params = @{
                                                 @"date": nowMonth
                                                 };
                        [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
                            if ([JSON[@"status"] intValue] == 200) {
                                NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
                                __block BOOL needUpdate = NO;
                                [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                                    // date: 2017-12-12
                                    // meetingsDict: [CXDailyMeetingModel]
                                    // 还没有获取过这天的数据
                                    if (self.meetingDictionay[date] == nil) {
                                        NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                                        self.meetingDictionay[date] = meetings;
                                        needUpdate = YES;
                                    }
                                }];
                                // 需要更新时才重新加载，改善卡顿
                                if (needUpdate) {
                                    [self.calendarView reloadData];
                                    [self.tableView reloadData];
                                }
                                self.focusedDate = today;
                                
                                NSString *nowMonth = [today stringWithFormat:@"yyyy-MM" timeZone:kTimeZone locale:kLocale];
                                [self getMonthMeetingList:nowMonth];
                                
                                [self.calendarView selectDate:today];
                                [self setTopViewInfoWithDate:today];
                                [self.tableView reloadData];
                                return;
                            }
                            else {
                                CXAlert(JSON[@"msg"]);
                                return;
                            }
                        } failure:^(NSError *error) {
                            CXAlert(KNetworkFailRemind);
                            return;
                        }];
                    }else{
                        [self getFirstInCurrentPageMonthMeetingListWithCount:count];
                    }
                }
            }
            else {
                CXAlert(JSON[@"msg"]);
                return;
            }
        } failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
            return;
        }];
    }
}

- (NSDate *)getMinimumDateWithData:(NSDictionary<NSString *, NSArray<NSDictionary *> *> *)data{
    NSDate *today = [NSDate date];
    __block NSString * minimumDate = [today stringWithFormat:@"yyyy-MM-dd" timeZone:kTimeZone locale:kLocale];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
        // date: 2017-12-12
        // meetingsDict: [CXDailyMeetingModel]
        minimumDate = [self getMinimumDateWithDate:minimumDate AndDate2:date];
        
    }];
    NSDate * date = [NSDate dateWithString:minimumDate format:@"yyyy-MM-dd"];
    return date;
}

- (NSString *)getMinimumDateWithDate:(NSString *)date1 AndDate2:(NSString *)date2
{
    NSString * str1 = [date1 substringToIndex:4];
    NSString * str2 = [date1 substringWithRange:NSMakeRange(5, 2)];
    NSString * str3 = [date1 substringFromIndex:8];
    NSString * str4 = [date2 substringToIndex:4];
    NSString * str5 = [date2 substringWithRange:NSMakeRange(5, 2)];
    NSString * str6 = [date2 substringFromIndex:8];
    NSString * dateStr1 = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSString * dateStr2 = [NSString stringWithFormat:@"%@%@%@",str4,str5,str6];
    if([dateStr1 longLongValue] <= [dateStr2 longLongValue]){
        return date1;
    }
    return date2;
}

/**
 获取月份的会议列表

 @param month 传 2017-12
 */
- (void)getMonthMeetingList:(NSString *)month {
    NSDictionary *params = @{
                             @"date": month
                             };
    [HttpTool postWithPath:@"meet/monthOrdayList/month.json" params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSDictionary<NSString *, NSArray<NSDictionary *> *> *data = JSON[@"data"];
            __block BOOL needUpdate = NO;
            [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull date, NSArray<NSDictionary *> * _Nonnull meetingsDict, BOOL * _Nonnull stop) {
                // date: 2017-12-12
                // meetingsDict: [CXDailyMeetingModel]
                // 还没有获取过这天的数据
                if (self.meetingDictionay[date] == nil) {
                    NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:meetingsDict];
                    self.meetingDictionay[date] = meetings;
                    needUpdate = YES;
                }
            }];
            // 需要更新时才重新加载，改善卡顿
            if (needUpdate) {
                [self.calendarView reloadData];
                [self.tableView reloadData];
            }
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setTopViewInfoWithDate:(NSDate *)date {
    // 2017-12-22 星期五
    self.dateLabel.text = [date stringWithFormat:@"yyyy-MM-dd EEEE" timeZone:kTimeZone locale:kLocale];
    
    // 十月
    NSInteger lunarMonth = [self.lunarCalendar component:NSCalendarUnitMonth fromDate:date];
    NSString *month_zhcn = self.lunarMonthChars[lunarMonth-1];
    // 初三
    NSInteger lunarDay = [self.lunarCalendar component:NSCalendarUnitDay fromDate:date];
    NSString *lunar = self.lunarChars[lunarDay-1];
    // "十月初三"
    self.lunarLabel.text = [month_zhcn stringByAppendingString:lunar];
}

#pragma mark - Event

- (void)onAllMeetingsButtonTap {//所有回忆
    CXDailyMeetingMonthListViewController *vc = [[CXDailyMeetingMonthListViewController alloc] init];
    vc.type = CXDailyMeetingListTypeAll;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onMyMeetingsButtonTap {//我的会议
    CXDailyMeetingMonthListViewController *vc = [[CXDailyMeetingMonthListViewController alloc] init];
    vc.type = CXDailyMeetingListTypeMine;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
