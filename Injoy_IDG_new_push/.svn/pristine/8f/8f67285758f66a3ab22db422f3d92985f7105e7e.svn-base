//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXVacationApplicationEditViewController.h"
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
#import "CXXJApplicationEditViewController.h"
#import "MBProgressHUD+CXCategory.h"

@interface CXVacationApplicationEditViewController ()
@property(strong, nonatomic) UIScrollView *scrollContentView;
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) CXBottomSubmitView *bottomSubmitView;
@property(weak, nonatomic) CXEditLabel *kindLabel;
@property(weak, nonatomic) CXEditLabel *startTimeLabel;
@property(weak, nonatomic) CXEditLabel *endTimeLabel;
@property(weak, nonatomic) CXEditLabel *timeLabel;
@property(weak, nonatomic) CXEditLabel *reasonLabel;
@property(weak, nonatomic) CXEditLabel *remarkLabel;
@property(weak, nonatomic) CXEditLabel *opinionLabel;///<审批意见
/// 我的休假信息
@property(copy, nonatomic) NSMutableArray *holidayInfoArr;
@property(weak, nonatomic) CXEditLabel *sqrLabel;
@property(weak, nonatomic) CXEditLabel *sqDateLabel;
@property(weak, nonatomic) CXEditLabel *endAMPMLabel;
@property(weak, nonatomic) CXEditLabel *startAMPMLabel;
@property(weak, nonatomic) UIImageView *arrow_1;
@end

@implementation CXVacationApplicationEditViewController

#pragma mark - get & set

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

- (CXVacationApplicationModel *)vacationApplicationModel {
    if (nil == _vacationApplicationModel) {
        _vacationApplicationModel = [[CXVacationApplicationModel alloc] init];
    }
    return _vacationApplicationModel;
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

- (void)findApproveDetailRequest {
    NSLog(@"详情approveId====%ld",self.vacationApplicationModel.approveId);
    NSString *url;
    if (self.vacationApplicationModel.approveId != 0) {//
          url = [NSString stringWithFormat:@"%@holiday/getApproveDetail/%ld", urlPrefix, self.vacationApplicationModel.approveId];
    }else{
        return;
    }

    [CXBaseRequest getResultWithUrl:url param:nil success:^(id responseObj) {
        if ([responseObj[@"status"] intValue] == HTTPSUCCESSOK) {
            CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.data"]];
            self.vacationApplicationModel = model;
            [self setUpDetail];
        } else {
            CXAlert(responseObj[@"msg"]);
            [self.bottomSubmitView removeFromSuperview];//不需要了
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

/// 休假详情 {不是批审详情}
- (void)findHolidayDdetail {
    NSString *url = [NSString stringWithFormat:@"%@holiday/detail/%zd", urlPrefix, self.vacationApplicationModel.leaveId];

    HUD_SHOW(nil);
    
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                if ([responseObj[@"status"] intValue] == HTTPSUCCESSOK) {
                                    CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.data"]];
                                    self.vacationApplicationModel = model;
                                    [self setUpDetail];
                                }
                                HUD_HIDE;
                            } failure:^(NSError *error) {
                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
            }];
}

/// 我的休假信息
- (void)findMyHolidayRequest {
    [self.holidayInfoArr removeAllObjects];

    NSString *url = [NSString stringWithFormat:@"%@holiday/myHoliday", urlPrefix];

    HUD_SHOW(nil);
    
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                CXHolidayInfoModel *model = [CXHolidayInfoModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    [self.holidayInfoArr addObjectsFromArray:model.data];
                                    NSArray * nameArray = [self.holidayInfoArr valueForKey:@"name"];
                                    NSArray * availableDayArray = [self.holidayInfoArr valueForKey:@"availableDay"];
                                    NSArray * totalDaysArray = [self.holidayInfoArr valueForKey:@"totalDays"];
                                    NSMutableArray * pickerTextArray = @[].mutableCopy;
                                    for(NSInteger i = 0;i<[nameArray count];i++){
                                        NSString * pickerText = [NSString stringWithFormat:@"%@(%zd[%zd]天)",nameArray[i],[availableDayArray[i] integerValue],[totalDaysArray[i] integerValue]];
                                        [pickerTextArray addObject:pickerText];
                                    }
                                    self.kindLabel.pickerTextArray = [NSArray arrayWithArray:pickerTextArray];
                                    self.kindLabel.pickerValueArray = [self.holidayInfoArr valueForKey:@"code"];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }
                                HUD_HIDE;
                            } failure:^(NSError *error) {
                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
            }];
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

- (void)approvalActionWithAgree:(BOOL)agree remark:(NSString *)remark{
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    NSString *url = [NSString stringWithFormat:@"%@holiday/approve", urlPrefix];
    //我的审批-请假审批,提交
    NSString *applyId = [self.vacationApplicationModel.applyId componentsSeparatedByString:@"."].firstObject;
//    NSString *approveId = self.vacationApplicationModel.approveId;
    NSDictionary *params = @{@"applyId":applyId,
                             @"approveId":@(self.vacationApplicationModel.approveId),
                             @"isApprove":agree ? @(1) :@(2),
                             @"reason":remark ? : @""};
    [CXBaseRequest postResultWithUrl:url param:params success:^(id responseObj) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        CXAlert(KNetworkFailRemind);
    }];
    
    /*
    NSString *applyId = [self.vacationApplicationModel.applyId componentsSeparatedByString:@"."].firstObject;
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc]
            initWithBid:applyId
                  btype:self.vacationApplicationModel.approveId];
    @weakify(self);
    approvalAlertView.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        if (self.callBack) {
            self.callBack();
        }
    };
    [approvalAlertView show];
    */
}
//销假
- (void)xjAction {
    CXXJApplicationEditViewController *vc = [[CXXJApplicationEditViewController alloc] init];
    vc.formType = CXFormTypeCreate;
    vc.vacationApplicationModel = self.vacationApplicationModel;
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
//保存
- (void)saveRequest {
    if (![self.kindLabel.content length]) {
        MAKE_TOAST_V(@"请选择请假类型");
        return;
    }

    if (![self.startTimeLabel.content length]) {
        MAKE_TOAST_V(@"请选择开始时间");
        return;
    }

    if (![self.endTimeLabel.content length]) {
        MAKE_TOAST_V(@"请选择结束时间");
        return;
    }

    NSTimeInterval startTimeInterval = [[NSDate dateWithString:self.startTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];

    NSTimeInterval endTimeInterval = [[NSDate dateWithString:self.endTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];
//不同天
    if (startTimeInterval > endTimeInterval + 1.f) {
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }
    //同一天
    NSLog(@"%@====%@",self.startTimeLabel.content,self.endTimeLabel.content);
    NSLog(@"%@====%@",self.startAMPMLabel.content,self.endAMPMLabel.content);
    if ([self.startTimeLabel.content isEqualToString:self.endTimeLabel.content] && [self.startAMPMLabel.content isEqualToString:@"下午(14:00)"] && [self.endAMPMLabel.content isEqualToString:@"下午(13:00)"]){
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }

    if ([(NSNumber *) self.vacationApplicationModel.leaveType intValue] == 22) {
        if (![self.reasonLabel.content length]) {
            MAKE_TOAST_V(@"请输入请假原因");
            return;
        }
    }

    NSString *url = [NSString stringWithFormat:@"%@holiday/save", urlPrefix];

    NSMutableDictionary *param = [self.vacationApplicationModel yy_modelToJSONObject];
    param[@"userName"] = VAL_Account;
    if (self.formType == CXFormTypeCreate) {
        param[@"eid"] = nil;
    }

    if (self.startAMPMLabel.hidden == NO) {
        param[@"startType"] = [self.startAMPMLabel.content isEqualToString:@"上午(09:00)"] ? @1 : @2;
    } else {
        param[@"startType"] = nil;
    }
    if (self.endAMPMLabel.hidden == NO) {
        param[@"endType"] = [self.endAMPMLabel.content isEqualToString:@"下午(13:00)"] ? @1 : @2;
    } else {
        param[@"endType"] = nil;
    }
//天数=相差的天数+(上午下午的类型差)*0.5
//如今天的上午,今天的上午就是0+(1-1)*0.5,如今天的上午,今天的上午就是0+(2-1)*0.5,如今天的上午,明天的上午就是1+(1-1)*0.5,如今天的下午,今天的上午就是1+(1-2)*0.5
    
    HUD_SHOW(nil);
    //防止重复提交
    self.view.userInteractionEnabled = NO;
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 //防止重复提交
                                 self.view.userInteractionEnabled = YES;
                                 
                                 CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
                                 if (HTTPSUCCESSOK == model.status) {
                                     CXAlertExt(@"提交成功", ^{
                                         if (self.callBack) {
                                             self.callBack();
                                         }
                                         [self.navigationController popViewControllerAnimated:YES];
                                     });
                                 } else {
                                     MAKE_TOAST(model.msg);
                                 }
                                 HUD_HIDE;
                             } failure:^(NSError *error) {
                                 //防止重复提交
                                 self.view.userInteractionEnabled = YES;
                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
            }];
}

#pragma mark - UI

- (void)setUpBottomSubmitView {
    // 提交
    CXBottomSubmitView *bottomSubmitView = [[CXBottomSubmitView alloc] initWithType:self.formType];
    if(self.formType == CXFormTypeDetail && self.vacationApplicationModel.signed_objc == 2){
        bottomSubmitView.submitTitle = @"销  假";
    }else if (self.formType == CXFormTypeDetail && self.vacationApplicationModel.signed_objc == -1){
        bottomSubmitView.backgroundColor = [UIColor clearColor];
        return;
    }
    
    self.bottomSubmitView = bottomSubmitView;
    @weakify(self);
    bottomSubmitView.callBack = ^(NSString *title) {
        @strongify(self);
        if ([@"提  交" isEqualToString:title]) {
            [self saveRequest];
        }
        if ([@"同  意" isEqualToString:title]) {
            [self approvalActionWithAgree:YES remark:nil];
        }
        if ([@"销  假" isEqualToString:title]) {
            [self xjAction];
        }
        if ([title isEqualToString:@"不同意"]) {
            [self showActionController];
        }
    };
    [self.view addSubview:bottomSubmitView];//底部点击
    [bottomSubmitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXBottomSubmitView_height);
    }];
}
- (void)showActionController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"批审" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
            NSString *remark = [[alertController textFields] objectAtIndex:0].text;
            NSLog(@"ok, %@", [[alertController textFields] objectAtIndex:0].text);
            if (remark.length == 0 || [remark isEqualToString:@""]) {
                [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空" duration:2];
                [self performSelector:@selector(showActionController) withObject:nil afterDelay:3.0];
            }else{
                [self approvalActionWithAgree:NO remark:remark];
            }
     
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];

}

//输入内容为空
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *remark = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        if (remark.text == nil || remark.text.length == 0) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空" duration:2];
            return;
        }else{
            okAction.enabled = YES;
           [self approvalActionWithAgree:NO remark:remark.text];
        }
    }
}
- (void)setUpDetail {
    self.sqrLabel.allowEditing = NO;
    self.sqDateLabel.allowEditing = NO;
    self.kindLabel.allowEditing = NO;
    self.kindLabel.showDropdown = NO;
    self.startTimeLabel.allowEditing = NO;
    self.endTimeLabel.allowEditing = NO;
    self.reasonLabel.allowEditing = NO;
    self.remarkLabel.allowEditing = NO;

    if (self.formType == CXFormTypeApproval) {
        // 批审
        self.sqrLabel.content = self.vacationApplicationModel.leaveInfo.name;
        self.sqDateLabel.content = self.vacationApplicationModel.leaveInfo.applyDate;
        self.kindLabel.content = [NSString stringWithFormat:@"%@", self.vacationApplicationModel.leaveInfo.leaveType];
        self.startTimeLabel.content = self.vacationApplicationModel.leaveInfo.leaveStart;
        self.endTimeLabel.content = self.vacationApplicationModel.leaveInfo.leaveEnd;
        self.timeLabel.content = [NSString stringWithFormat:@"%.1f天", self.vacationApplicationModel.leaveInfo.leaveDay];
        self.reasonLabel.content = self.vacationApplicationModel.leaveInfo.leaveReason;
        self.remarkLabel.content = !self.vacationApplicationModel.leaveInfo.leaveMemo || (self.vacationApplicationModel.leaveInfo.leaveMemo && [self.vacationApplicationModel.leaveInfo.leaveMemo length] <= 0)?@" ":self.vacationApplicationModel.leaveInfo.leaveMemo;
        self.opinionLabel.content = [NSString stringWithFormat:@"%@",self.vacationApplicationModel.approveReason ? : @""];

        if (self.vacationApplicationModel.isApprove != 0) {
            [self.bottomSubmitView removeFromSuperview];
        }
    } else if (self.formType == CXFormTypeDetail) {
        self.sqrLabel.content = VAL_USERNAME;
        self.sqDateLabel.content = self.vacationApplicationModel.applyDate;
        // 详情
        self.kindLabel.content = [NSString stringWithFormat:@"%@", self.vacationApplicationModel.leaveType];
        self.startTimeLabel.content = [self getTimeStringWithTime:self.vacationApplicationModel.leaveStart];
        self.endTimeLabel.content = [self getTimeStringWithTime:self.vacationApplicationModel.leaveEnd];
        self.reasonLabel.content = self.vacationApplicationModel.leaveReason;
        self.remarkLabel.content = !self.vacationApplicationModel.leaveMemo || (self.vacationApplicationModel.leaveMemo && [self.vacationApplicationModel.leaveMemo length] <= 0)?@" ":self.vacationApplicationModel.leaveMemo;
        self.timeLabel.content = [NSString stringWithFormat:@"%.1f天", self.vacationApplicationModel.leaveDay];
        self.opinionLabel.content = self.vacationApplicationModel.approveReason ? : @"";
        self.opinionLabel.placeholder = @"";//详情不需要提示文字,不能编辑
        self.opinionLabel.allowEditing = NO;
        if (self.vacationApplicationModel.signed_objc != 2) {
            [self.bottomSubmitView removeFromSuperview];
        }
    }
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"请假申请"];
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

    // 申请人
    CXEditLabel *sqrLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, topMargin, Screen_Width - leftMargin, viewHeight}];
    self.sqrLabel = sqrLabel;
    sqrLabel.title = @"  申 请 人：";
    [self.scrollContentView addSubview:sqrLabel];

    // 分隔线_0
    UIView *line_0 = [self createFormSeperatorLine];
    line_0.frame = (CGRect) {0.f, sqrLabel.bottom, lineWidth, lineHeight};

    // 申请日期
    CXEditLabel *sqDateLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_0.bottom, Screen_Width - leftMargin, viewHeight}];
    self.sqDateLabel = sqDateLabel;
    sqDateLabel.title = @"申请日期：";
    [self.scrollContentView addSubview:sqDateLabel];

    // 分隔线_01
    UIView *line_01 = [self createFormSeperatorLine];
    line_01.frame = (CGRect) {0.f, sqDateLabel.bottom, lineWidth, lineHeight};

    CGFloat y = line_01.bottom;

    if (self.formType != CXFormTypeApproval) {
        [sqrLabel removeFromSuperview];
        [line_0 removeFromSuperview];
        [sqDateLabel removeFromSuperview];
        [line_01 removeFromSuperview];
        y = topMargin;
        //
    }

    // 休假类型
    CXEditLabel *kindLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, y, Screen_Width - leftMargin - 30.f, viewHeight}];
    self.kindLabel = kindLabel;
    kindLabel.inputType = CXEditLabelInputTypeCustomPicker;
    kindLabel.showDropdown = NO;
    kindLabel.title = @"请假类型：";
    kindLabel.placeholder = @"请选择请假类型";
    [self.scrollContentView addSubview:kindLabel];
    kindLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        int leaveType = [editLabel.selectedPickerData[CXEditLabelCustomPickerValueKey] intValue];
        self.vacationApplicationModel.leaveType = [NSNumber numberWithInt:leaveType];
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

    if (self.formType == CXFormTypeCreate) {
        // 箭头_1
        UIImageView *arrow_1 = [self arrowImage];
        self.arrow_1 = arrow_1;
        arrow_1.frame = (CGRect) {kindLabel.right, kindLabel.top, 20.f, viewHeight};
        [self.scrollContentView addSubview:arrow_1];
    }

    // 分隔线_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, kindLabel.bottom, lineWidth, lineHeight};

    // 开始时间
    CXEditLabel *startTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_1.bottom, Screen_Width - leftMargin - 150.f, viewHeight}];
    self.startTimeLabel = startTimeLabel;
    startTimeLabel.title = @"开始时间：";
    startTimeLabel.placeholder = @"请选择开始时间";
    startTimeLabel.inputType = CXEditLabelInputTypeDate;
    [self.scrollContentView addSubview:startTimeLabel];
    startTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveStart = editLabel.content;
    };

    CXEditLabel *startAMPMLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {startTimeLabel.right, startTimeLabel.top, 100.f, viewHeight}];
    self.startAMPMLabel = startAMPMLabel;
    startAMPMLabel.hidden = YES;
    startAMPMLabel.content = @"上午(09:00)";
    startAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    startAMPMLabel.selectViewTitle = @"开始时间";
    startAMPMLabel.pickerTextArray = @[@"上午(09:00)", @"下午(14:00)"];
    startAMPMLabel.pickerValueArray = @[@"1", @"2"];
    [self.scrollContentView addSubview:startAMPMLabel];

    // 箭头_2
    if (self.formType == CXFormTypeCreate) {
        UIImageView *arrow_2 = [self arrowImage];
        arrow_2.frame = (CGRect) {self.arrow_1.left, startTimeLabel.top, 20.f, viewHeight};
        [self.scrollContentView addSubview:arrow_2];
    }

    // 分隔线_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = (CGRect) {0.f, startTimeLabel.bottom, lineWidth, lineHeight};

    // 结束时间
    CXEditLabel *endTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_2.bottom, Screen_Width - leftMargin - 150.f, viewHeight}];
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.inputType = CXEditLabelInputTypeDate;
    endTimeLabel.title = @"结束时间：";
    endTimeLabel.placeholder = @"请选择结束时间";
    [self.scrollContentView addSubview:endTimeLabel];
    endTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveEnd = editLabel.content;
    };

    CXEditLabel *endAMPMLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {endTimeLabel.right, endTimeLabel.top, 100.f, viewHeight}];
    endAMPMLabel.hidden = YES;
    self.endAMPMLabel = endAMPMLabel;
    endAMPMLabel.content = @"下午(18:00)";
    endAMPMLabel.selectViewTitle = @"结束时间";
    endAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    endAMPMLabel.pickerTextArray = @[@"下午(13:00)", @"下午(18:00)"];
    endAMPMLabel.pickerValueArray = @[@"1", @"2"];
    endAMPMLabel.selectedPickerData = @{@"text":@"下午(18:00)"};
    [self.scrollContentView addSubview:endAMPMLabel];

    // 箭头_3
    if (self.formType == CXFormTypeCreate) {
        UIImageView *arrow_3 = [self arrowImage];
        arrow_3.frame = (CGRect) {self.arrow_1.left, endTimeLabel.top, 20.f, viewHeight};
        [self.scrollContentView addSubview:arrow_3];
    }

    // 分隔线_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = (CGRect) {0.f, endTimeLabel.bottom, lineWidth, lineHeight};

    // 时长
    CXEditLabel *timeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight}];
    self.timeLabel = timeLabel;
    timeLabel.allowEditing = NO;
    timeLabel.title = @"时　　长：";
    [self.scrollContentView addSubview:timeLabel];

    // 分隔线_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = (CGRect) {0.f, timeLabel.bottom, lineWidth, lineHeight};

    y = line_4.bottom;
    if (self.formType == CXFormTypeCreate) {
        [timeLabel removeFromSuperview];
        [line_4 removeFromSuperview];
        y = line_3.bottom;
    }

    // 请假原因
    CXEditLabel *reasonLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, y, Screen_Width - leftMargin, viewHeight}];
    self.reasonLabel = reasonLabel;
    reasonLabel.title = @"请假原因：";
    reasonLabel.placeholder = @"请输入请假原因";
    reasonLabel.scale = YES;
    [self.scrollContentView addSubview:reasonLabel];
    reasonLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveReason = [self replaceSpace:editLabel.content];
    };

    // 分隔线_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = (CGRect) {0.f, reasonLabel.bottom + 50, lineWidth, lineHeight};

    // 备注
    CXEditLabel *remarkLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight}];
    self.remarkLabel = remarkLabel;
    remarkLabel.title = @"备　　注：";
    remarkLabel.placeholder = @"请输入备注";
    remarkLabel.scale = YES;
    [self.scrollContentView addSubview:remarkLabel];
    remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveMemo = [self replaceSpace:editLabel.content];
    };
    // 更新frame
    reasonLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
        @strongify(self);
        line_5.frame = (CGRect) {0.f, self.reasonLabel.bottom, lineWidth, lineHeight};
        remarkLabel.frame = (CGRect) {leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight};
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, remarkLabel.bottom);
    };
    if (self.vacationApplicationModel.signed_objc == 3) {//驳回
        // 分隔线_5
        UIView *line_6 = [self createFormSeperatorLine];
        line_6.frame = (CGRect) {0.f, remarkLabel.bottom, lineWidth, lineHeight};
        // 审批意见
        CXEditLabel *opinionLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, remarkLabel.bottom + 1, Screen_Width - leftMargin, viewHeight}];
        self.opinionLabel = opinionLabel;
        opinionLabel.title = @"审批意见：";
        opinionLabel.placeholder = @"请输入审批意见";
        opinionLabel.scale = YES;
        [self.scrollContentView addSubview:opinionLabel];
        opinionLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            
        };
        
        remarkLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
            @strongify(self);
            self.scrollContentView.contentSize = CGSizeMake(Screen_Width, remarkLabel.bottom);
        };
    }
 
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, remarkLabel.bottom);
}

- (NSString *)getTimeStringWithTime:(NSString *)time{
    NSString * year = [time substringToIndex:4];
    NSString * month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString * day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString * timeStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return timeStr;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;

    [self setUpNavBar];
    [self setUpSubViews];

    if (self.vacationApplicationModel.isApprove == 0 || (self.formType == CXFormTypeDetail && self.vacationApplicationModel.signed_objc == 2)) {//未审批或者详情页的审批中
        [self setUpBottomSubmitView];
    }

    if (self.formType == CXFormTypeCreate) {
        // 添加时.获取休假类型
        [self findMyHolidayRequest];
    }
    if (self.formType == CXFormTypeApproval) {
        // 获取批审界面详情
        [self findApproveDetailRequest];
    }
    if (self.formType == CXFormTypeDetail) {
        // 获取详情
        [self findHolidayDdetail];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
