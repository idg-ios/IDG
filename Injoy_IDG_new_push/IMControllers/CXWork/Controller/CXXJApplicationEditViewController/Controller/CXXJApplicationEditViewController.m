//
//  CXXJApplicationEditViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXXJApplicationEditViewController.h"
#import "CXBottomSubmitView.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXBaseRequest.h"
#import "CXHolidayInfoModel.h"
#import "CXApprovalAlertView.h"
#import "DLRadioButton.h"
#import "NSDate+YYAdd.h"
#import "SDDataBaseHelper.h"
#import "CXVacationApplicationListViewController.h"
#import "IDGXJListViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXXJApplicationEditViewController ()

@property(strong, nonatomic) UIScrollView *scrollContentView;
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) CXBottomSubmitView *bottomSubmitView;
@property(weak, nonatomic) CXEditLabel *kindLabel;
@property(weak, nonatomic) CXEditLabel *startTimeLabel;
@property(weak, nonatomic) CXEditLabel *endTimeLabel;
@property(weak, nonatomic) CXEditLabel *remarkLabel;
@property(copy, nonatomic) NSMutableArray *holidayInfoArr;
@property(weak, nonatomic) CXEditLabel *endAMPMLabel;
@property(weak, nonatomic) CXEditLabel *startAMPMLabel;
@property(weak, nonatomic) UIImageView *arrow_1;

@end

@implementation CXXJApplicationEditViewController

- (NSMutableArray *)holidayInfoArr {
    if (nil == _holidayInfoArr) {
        _holidayInfoArr = [[NSMutableArray alloc] init];
    }
    return _holidayInfoArr;
}

- (UIScrollView *)scrollContentView {
    if (nil == _scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContentView;
}

#pragma mark - instance function
/// 替换中文输入法出现乱字符集{unicode->\u2006}
- (NSString *)replaceSpace:(NSString *)targetStr {
    NSRegularExpression *regularExpression =
    [NSRegularExpression regularExpressionWithPattern:@"\u2006"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:nil];
    return [regularExpression stringByReplacingMatchesInString:targetStr
                                                       options:0
                                                         range:NSMakeRange(0, targetStr.length)
                                                  withTemplate:@""];
}

/// 箭头
- (UIImageView *)arrowImage {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.contentMode = UIViewContentModeCenter;
    return arrow;
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)saveRequest {
    if (![self.startTimeLabel.content length]) {
        MAKE_TOAST_V(@"请选择开始时间");
        return;
    }
    
    if (![self.endTimeLabel.content length]) {
        MAKE_TOAST_V(@"请选择结束时间");
        return;
    }
    
    NSString * startTimeYear = [self.startTimeLabel.content substringToIndex:4];
    NSString * startTimeMonth = [self.startTimeLabel.content substringWithRange:NSMakeRange(5, 2)];
    NSString * startTimeDay = [self.startTimeLabel.content substringWithRange:NSMakeRange(8, 2)];
    NSString * startTimeStr = [NSString stringWithFormat:@"%@%@%@",startTimeYear,startTimeMonth,startTimeDay];
    
    NSString * endTimeYear = [self.endTimeLabel.content substringToIndex:4];
    NSString * endTimeMonth = [self.endTimeLabel.content substringWithRange:NSMakeRange(5, 2)];
    NSString * endTimeDay = [self.endTimeLabel.content substringWithRange:NSMakeRange(8, 2)];
    NSString * endTimeStr = [NSString stringWithFormat:@"%@%@%@",endTimeYear,endTimeMonth,endTimeDay];
    
    if([startTimeStr longLongValue] > [endTimeStr longLongValue]){
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }
    
    if([startTimeStr longLongValue] == [endTimeStr longLongValue] && self.startAMPMLabel.hidden == NO && self.endAMPMLabel.hidden == NO && [self.startAMPMLabel.content isEqualToString:@"下午"] && [self.endAMPMLabel.content isEqualToString:@"上午"]){
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/apply", urlPrefix];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:[self getTimeStringWithTime:self.vacationApplicationModel.leaveStart] forKey:@"leaveStart"];
    [param setValue:[self getTimeStringWithTime:self.vacationApplicationModel.leaveEnd] forKey:@"leaveEnd"];
    [param setValue:[NSString stringWithFormat:@"%.1lf",self.vacationApplicationModel.leaveDay] forKey:@"leaveDay"];
    [param setValue:self.vacationApplicationModel.leaveTypeCode forKey:@"leaveType"];
    [param setValue:self.vacationApplicationModel.leaveMemo forKey:@"remark"];
    int leaveType = [self.kindLabel.selectedPickerData[CXEditLabelCustomPickerValueKey] intValue];
    CXHolidayInfoModel *model = [self.holidayInfoArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.code == %d", leaveType]].firstObject;
    [param setValue:[NSString stringWithFormat:@"%.1lf",model.minDay] forKey:@"minDay"];
    if (self.startAMPMLabel.hidden == NO) {
        param[@"startType"] = [self.startAMPMLabel.content isEqualToString:@"上午"] ? @1 : @2;
    } else {
        param[@"startType"] = nil;
    }
    if (self.endAMPMLabel.hidden == NO) {
        param[@"endType"] = [self.endAMPMLabel.content isEqualToString:@"上午"] ? @1 : @2;
    } else {
        param[@"endType"] = nil;
    }
    [param setValue:@(self.vacationApplicationModel.leaveId) forKey:@"eid"];
    HUD_SHOW(nil);
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
//                                 [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                 CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
                                 if (HTTPSUCCESSOK == model.status) {
                                     CXAlertExt(@"提交成功", ^{
                                         if (self.callBack) {
                                             self.callBack();
                                         }
                                         [self popToController];
                                     });
                                 } else {
                                     MAKE_TOAST(model.msg);
                                 }
                                 HUD_HIDE;
                             } failure:^(NSError *error) {
//                                 [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                 HUD_HIDE;
                                 CXAlert(KNetworkFailRemind);
                             }];
}

#pragma mark - UI
- (void)setUpBottomSubmitView {
    // 提交
    CXBottomSubmitView *bottomSubmitView = [[CXBottomSubmitView alloc] initWithType:self.formType];
    bottomSubmitView.submitTitle = @"提  交";
    self.bottomSubmitView = bottomSubmitView;
    @weakify(self);
    bottomSubmitView.callBack = ^(NSString *title) {
        @strongify(self);
        if ([@"提  交" isEqualToString:title]) {
            [self saveRequest];
        }
    };
    [self.view addSubview:bottomSubmitView];
    [bottomSubmitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXBottomSubmitView_height);
    }];
}

- (void)setVacationApplicationModel:(CXVacationApplicationModel *)vacationApplicationModel{
    vacationApplicationModel.leaveMemo = nil;
    _vacationApplicationModel = vacationApplicationModel;
    self.kindLabel.allowEditing = NO;
    self.kindLabel.showDropdown = NO;
    self.startTimeLabel.allowEditing = YES;
    self.endTimeLabel.allowEditing = YES;
    self.remarkLabel.allowEditing = YES;
    // 详情
    self.kindLabel.content = [NSString stringWithFormat:@"%@", _vacationApplicationModel.leaveType];
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"销假申请"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpSubViews {
    [self.view addSubview:self.scrollContentView];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-CXBottomSubmitView_height * 2 - kTabbarSafeBottomMargin);
        make.top.equalTo([self rootTopView].mas_bottom);
    }];
    
    CGFloat topMargin = 10.f;
    /// 左边距
    CGFloat leftMargin = 5.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineWidth = Screen_Width;
    
    @weakify(self);
    // 休假类型
    CXEditLabel *kindLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, topMargin, Screen_Width - leftMargin - 30.f, viewHeight}];
    self.kindLabel = kindLabel;
    kindLabel.inputType = CXEditLabelInputTypeCustomPicker;
    kindLabel.showDropdown = NO;
    kindLabel.title = @"销假类型：";
    kindLabel.placeholder = @"请选择销假类型";
    [self.scrollContentView addSubview:kindLabel];
    
    kindLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
    
    };
    // 分隔线_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, kindLabel.bottom, lineWidth, lineHeight};
    
    // 开始时间
    CXEditLabel *startTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_1.bottom, Screen_Width - leftMargin - 120.f, viewHeight}];
    self.startTimeLabel = startTimeLabel;
    startTimeLabel.title = @"开始时间：";
    startTimeLabel.placeholder = @"请选择开始时间";
    startTimeLabel.inputType = CXEditLabelInputTypeDate;
    [self.scrollContentView addSubview:startTimeLabel];
    startTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveStart = editLabel.content;
        int leaveType = [self.kindLabel.selectedPickerData[CXEditLabelCustomPickerValueKey] intValue];
        CXHolidayInfoModel *model = [self.holidayInfoArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.code == %d", leaveType]].firstObject;
        self.vacationApplicationModel.minDay = model.minDay;
        self.vacationApplicationModel.availableDay = model.availableDay;
        
        if (model.minDay == 0.5f) {
            self.startAMPMLabel.hidden = NO;
            self.endAMPMLabel.hidden = NO;
        } else {
            self.startAMPMLabel.hidden = YES;
            self.endAMPMLabel.hidden = YES;
        }
    };
    
    CXEditLabel *startAMPMLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {startTimeLabel.right, startTimeLabel.top, 60.f, viewHeight}];
    self.startAMPMLabel = startAMPMLabel;
    startAMPMLabel.hidden = YES;
    startAMPMLabel.selectViewTitle = @"时间";
    startAMPMLabel.content = @"上午";
    startAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    startAMPMLabel.pickerTextArray = @[@"上午", @"下午"];
    startAMPMLabel.pickerValueArray = @[@"1", @"2"];
    [self.scrollContentView addSubview:startAMPMLabel];
    
    // 箭头_2
    if (self.formType == CXFormTypeCreate) {
        UIImageView *arrow_2 = [self arrowImage];
        arrow_2.frame = (CGRect) {kindLabel.right, startTimeLabel.top, 20.f, viewHeight};
        [self.scrollContentView addSubview:arrow_2];
    }
    
    // 分隔线_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = (CGRect) {0.f, startTimeLabel.bottom, lineWidth, lineHeight};
    
    // 结束时间
    CXEditLabel *endTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_2.bottom, Screen_Width - leftMargin - 120.f, viewHeight}];
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.inputType = CXEditLabelInputTypeDate;
    endTimeLabel.title = @"结束时间：";
    endTimeLabel.placeholder = @"请选择结束时间";
    [self.scrollContentView addSubview:endTimeLabel];
    endTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveEnd = editLabel.content;
        int leaveType = [self.kindLabel.selectedPickerData[CXEditLabelCustomPickerValueKey] intValue];
        CXHolidayInfoModel *model = [self.holidayInfoArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.code == %d", leaveType]].firstObject;
        self.vacationApplicationModel.minDay = model.minDay;
        self.vacationApplicationModel.availableDay = model.availableDay;
        
        if (model.minDay == 0.5f) {
            self.startAMPMLabel.hidden = NO;
            self.endAMPMLabel.hidden = NO;
        } else {
            self.startAMPMLabel.hidden = YES;
            self.endAMPMLabel.hidden = YES;
        }
    };
    
    CXEditLabel *endAMPMLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {endTimeLabel.right, endTimeLabel.top, 60.f, viewHeight}];
    endAMPMLabel.hidden = YES;
    self.endAMPMLabel = endAMPMLabel;
    endAMPMLabel.selectViewTitle = @"时间";
    endAMPMLabel.content = @"下午";
    endAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    endAMPMLabel.pickerTextArray = @[@"上午", @"下午"];
    endAMPMLabel.pickerValueArray = @[@"1", @"2"];
    [self.scrollContentView addSubview:endAMPMLabel];
    
    // 箭头_3
    if (self.formType == CXFormTypeCreate) {
        UIImageView *arrow_3 = [self arrowImage];
        arrow_3.frame = (CGRect) {kindLabel.right, endTimeLabel.top, 20.f, viewHeight};
        [self.scrollContentView addSubview:arrow_3];
    }
    
    // 分隔线_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = (CGRect) {0.f, endTimeLabel.bottom, lineWidth, lineHeight};
    
    // 备注
    CXEditLabel *remarkLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight}];
    self.remarkLabel = remarkLabel;
    remarkLabel.title = @"备　　注：";
    remarkLabel.placeholder = @"请输入备注";
    remarkLabel.scale = YES;
    [self.scrollContentView addSubview:remarkLabel];
    remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveMemo = [self replaceSpace:editLabel.content];
    };
    
    remarkLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
        @strongify(self);
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.remarkLabel.bottom);
    };
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, remarkLabel.bottom);
}

- (NSString *)getTimeStringWithTime:(NSString *)time{
    NSString * year = [time substringToIndex:4];
    NSString * month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString * day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString * timeStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return timeStr;
}

- (void)popToController{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[IDGXJListViewController class]]) {
            IDGXJListViewController * aController = (IDGXJListViewController *)controller;
            [self.navigationController popToViewController:aController animated:YES];
            return;
        }
        if ([controller isKindOfClass:[CXVacationApplicationListViewController class]]) {
            CXVacationApplicationListViewController * aController = (CXVacationApplicationListViewController *)controller;
            [self.navigationController popToViewController:aController animated:YES];
        }
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self setUpNavBar];
    [self setUpSubViews];
    [self setUpBottomSubmitView];
    [self findMyHolidayRequest];
}

/// 我的休假信息
- (void)findMyHolidayRequest {
    [self.holidayInfoArr removeAllObjects];
    
    NSString *url = [NSString stringWithFormat:@"%@holiday/myHoliday", urlPrefix];
    
    HUD_SHOW(nil);
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
//                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                CXHolidayInfoModel *model = [CXHolidayInfoModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    [self.holidayInfoArr addObjectsFromArray:model.data];
                                    NSArray * nameArray = [self.holidayInfoArr valueForKey:@"name"];
                                    NSArray * availableDayArray = [self.holidayInfoArr valueForKey:@"availableDay"];
                                    NSMutableArray * pickerTextArray = @[].mutableCopy;
                                    for(NSInteger i = 0;i<[nameArray count];i++){
                                        NSString * pickerText = [NSString stringWithFormat:@"%@(%zd天)",nameArray[i],[availableDayArray[i] integerValue]];
                                        [pickerTextArray addObject:pickerText];
                                    }
                                    self.kindLabel.pickerTextArray = [NSArray arrayWithArray:pickerTextArray];
                                    self.kindLabel.pickerValueArray = [self.holidayInfoArr valueForKey:@"code"];
                                    NSInteger i = 0;
                                    for(NSString * name in nameArray){
                                        if([name isEqualToString:(NSString *)_vacationApplicationModel.leaveType]){
                                            _kindLabel.selectedPickerData = @{
                                                                    CXEditLabelCustomPickerTextKey : name,
                                                                                    CXEditLabelCustomPickerValueKey : [self.kindLabel.pickerValueArray objectAtIndex:i]
                                                                                    };
                                        }
                                        i++;
                                    }
                                    [self setVacationApplicationModel:_vacationApplicationModel];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }
                                HUD_HIDE;
                            } failure:^(NSError *error) {
//                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                HUD_HIDE;
                                CXAlert(KNetworkFailRemind);
                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
