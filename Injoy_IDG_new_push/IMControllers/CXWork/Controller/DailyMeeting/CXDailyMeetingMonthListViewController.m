//
//  CXDailyMeetingMonthListViewController.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDailyMeetingMonthListViewController.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "CXDailyMeetingDayListCell.h"
#import "UIButton+LXMImagePosition.h"
#import "CXDailyMeetingModel.h"
#import "MJRefresh.h"
#import "NSDate+YYAdd.h"
#import "SDCustomTextPicker.h"
#import "CXIDGDailyMeetingDetailViewController.h"
#import "UIView+CXCategory.h"

@interface CXDailyMeetingMonthListViewController () <UITableViewDelegate, UITableViewDataSource>

/** 顶部视图 */
@property (nonatomic, strong) UIView *topView;
/** 年份按钮 */
@property (nonatomic, strong) UIButton *yearButton;
/** 月份按钮 */
@property (nonatomic, strong) UIButton *monthButton;
/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;

/** 年份数据 */
@property (nonatomic, strong) NSMutableArray<NSString *> *yearPickerData;
/** 年份数据 */
@property (nonatomic, strong) NSMutableArray<NSString *> *monthPickerData;

/** 会议数据 [CXDailyMeetingModel}] */
@property (nonatomic, strong) NSMutableArray<CXDailyMeetingModel *> *meetings;

/** 当前选择的年份 */
@property (readonly) NSString *selectedYear;
/** 当前选择的月份 */
@property (readonly) NSString *selectedMonth;

/** 是否显示已结束的会议 */
@property (nonatomic) BOOL showEndMeeting;

@end

NSString *const kCellId = @"cell";

@implementation CXDailyMeetingMonthListViewController

#pragma mark - Get Set

- (NSMutableArray<NSString *> *)yearPickerData {
    if (_yearPickerData == nil) {
        _yearPickerData = [NSMutableArray array];
        // 从1970年~后面10年
        for (NSInteger i = 1970; i <= [[NSDate date] stringWithFormat:@"yyyy"].integerValue + 10; i++) {
            NSString *year = [NSString stringWithFormat:@"%zd年", i];
            [_yearPickerData addObject:year];
        }
    }
    return _yearPickerData;
}

- (NSMutableArray<NSString *> *)monthPickerData {
    if (_monthPickerData == nil) {
        _monthPickerData = [NSMutableArray array];
        for (NSInteger i = 1; i <= 12; i++) {
            NSString *month = [NSString stringWithFormat:@"%zd月", i];
            [_monthPickerData addObject:month];
        }
    }
    return _monthPickerData;
}

- (NSMutableArray<CXDailyMeetingModel *> *)meetings {
    if (_meetings == nil) {
        _meetings = [NSMutableArray array];
    }
    return _meetings;
}

- (NSString *)selectedYear {
    return [self.yearButton.currentTitle stringByReplacingOccurrencesOfString:@"年" withString:@""];
}

- (NSString *)selectedMonth {
    return [self.monthButton.currentTitle stringByReplacingOccurrencesOfString:@"月" withString:@""];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    self.showEndMeeting = NO;
    
    [self getMonthMeetings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

- (void)setup {
    [self.RootTopView setNavTitle:self.type == CXDailyMeetingListTypeAll ? @"所有会议" : @"我的会议"];
    [self.RootTopView setUpLeftBarItemGoBack];
    
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@45);
        }];
        view;
    });
    
    self.yearButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[NSDate date] stringWithFormat:@"yyyy年"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:RGBACOLOR(31, 34, 40, 1.0) forState:UIControlStateNormal];
        [button setImage:Image(@"arrow_spread") forState:UIControlStateNormal];
        [button setImagePosition:LXMImagePositionRight spacing:15];
        [button addTarget:self action:@selector(onYearButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.topView);
            make.width.equalTo(self.topView).multipliedBy(0.5);
        }];
        button;
    });
    
    self.monthButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDate *date = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM"];
        NSString * month = [format stringFromDate:date];
        [button setTitle:[NSString stringWithFormat:@"%zd月",[month integerValue]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:RGBACOLOR(31, 34, 40, 1.0) forState:UIControlStateNormal];
        [button setImage:Image(@"arrow_spread") forState:UIControlStateNormal];
        [button setImagePosition:LXMImagePositionRight spacing:15];
        [button addTarget:self action:@selector(onMonthButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.topView);
            make.width.equalTo(self.topView).multipliedBy(0.5);
        }];
        button;
    });
    
    UIView *line = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(222, 222, 222);
        [self.topView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.topView);
            make.height.equalTo(@1);
        }];
        view;
    });
    [line hash];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = kColorWithRGB(245, 246, 248);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CXDailyMeetingDayListCell class] forCellReuseIdentifier:kCellId];
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(showAllMeetings)];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        }];
        tableView;
    });
}

#pragma mark - UITableView Protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1.0 + 20.0 + 18.0 + 8.0 + 14.0 + 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXDailyMeetingDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.isShowYear = YES;
    cell.meetingModel = self.meetings[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXIDGDailyMeetingDetailViewController *vc = [[CXIDGDailyMeetingDetailViewController alloc] init];
    vc.eid = self.meetings[indexPath.row].eid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Event
- (void)onYearButtonTap {
    SDCustomTextPicker *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil] lastObject];
    picker.pickerData = self.yearPickerData;
    NSString *year = self.yearButton.currentTitle;
    if (year.length) {
        NSInteger idx = [self.yearPickerData indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return [obj isEqualToString:year];
        }];
        if (idx != NSNotFound) {
            [picker.pickerView selectRow:idx inComponent:0 animated:NO];
        }
    }
    picker.selectCallBack = ^(NSString *text, NSInteger idx) {
        [self.yearButton setTitle:text forState:UIControlStateNormal];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy"];
        NSString *year = [forMatter stringFromDate:date];
        [forMatter setDateFormat:@"MM"];
        NSString *month = [forMatter stringFromDate:date];
        if([self.selectedYear isEqualToString:year] && [month integerValue] == [self.selectedMonth integerValue]){
            self.showEndMeeting = NO;
            [self getMonthMeetings];
        }else{
            [self showAllMeetings];
        }
    };
    [KEY_WINDOW addSubview:picker];
}

- (void)onMonthButtonTap {
    SDCustomTextPicker *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SDCustomTextPicker.class) owner:nil options:nil] lastObject];
    picker.pickerData = self.monthPickerData;
    NSString *year = self.monthButton.currentTitle;
    if (year.length) {
        NSInteger idx = [self.monthPickerData indexOfObjectPassingTest:^BOOL(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return [obj isEqualToString:year];
        }];
        if (idx != NSNotFound) {
            [picker.pickerView selectRow:idx inComponent:0 animated:NO];
        }
    }
    picker.selectCallBack = ^(NSString *text, NSInteger idx) {
        [self.monthButton setTitle:text forState:UIControlStateNormal];
        NSDate *date = [NSDate date];
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy"];
        NSString *year = [forMatter stringFromDate:date];
        [forMatter setDateFormat:@"MM"];
        NSString *month = [forMatter stringFromDate:date];
        if([self.selectedYear isEqualToString:year] && [month integerValue] == [self.selectedMonth integerValue]){
            self.showEndMeeting = NO;
            [self getMonthMeetings];
        }else{
            [self showAllMeetings];
        }
    };
    [KEY_WINDOW addSubview:picker];
}

#pragma mark - Private
/**
 获取全部的会议数据
 */
- (void)showAllMeetings {
    self.showEndMeeting = YES;
    [self getMonthMeetings];
}

/**
 获取某月的会议数据
 */
- (void)getMonthMeetings {
    NSString *month = [NSString stringWithFormat:@"%@-%@", self.selectedYear, self.selectedMonth];
    NSMutableDictionary *params = @{
                                     @"date": month
                                     }.mutableCopy;
    if (self.type == CXDailyMeetingListTypeAll) {
        params[@"kind"] = @"all";
    }
    [HttpTool postWithPath:@"meet/list/month.json" params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            [self.meetings removeAllObjects];
            NSArray<CXDailyMeetingModel *> *meetings = [NSArray yy_modelArrayWithClass:[CXDailyMeetingModel class] json:JSON[@"data"]];
            NSMutableArray * showMeetings = @[].mutableCopy;
            if(self.showEndMeeting){
                showMeetings = [NSMutableArray arrayWithArray:meetings];
            }else{
                for(CXDailyMeetingModel * model in meetings){
                    NSString * format = @"yyyy-MM-dd HH:mm:ss";
                    // 结束时间戳
                    NSTimeInterval endTimestamp = [NSDate dateWithString:model.endTime format:format].timeIntervalSince1970;
                    // 当前时间戳
                    NSTimeInterval nowTimestamp = [NSDate date].timeIntervalSince1970;
                    if (nowTimestamp <= endTimestamp) {
                        [showMeetings addObject:model];
                    }
                }
            }
            self.meetings = [NSMutableArray arrayWithArray:showMeetings];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.meetings.count AndPictureName:@"pic_Nomeetings" AndAttentionText:@"暂无会议安排"];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        CXAlert(KNetworkFailRemind);
    }];
}

@end
