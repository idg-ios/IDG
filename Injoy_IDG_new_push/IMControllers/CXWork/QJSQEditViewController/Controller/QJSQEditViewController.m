//
//  QJSQEditViewController.m
//  InjoyIDG
//
//  Created by wtz on 2019/1/17.
//  Copyright © 2019年 Injoy. All rights reserved.
//

#import "QJSQEditViewController.h"
#import "CXBottomSubmitView.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXBaseRequest.h"
#import "CXHolidayInfoModel.h"
#import "NSDate+YYAdd.h"
#import "CXXJApplicationEditViewController.h"
#import "MBProgressHUD+CXCategory.h"
#import "QJSQEditModel.h"
#import "HttpTool.h"

@interface QJSQEditViewController ()

@property(strong, nonatomic) UIScrollView *scrollContentView;
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) CXBottomSubmitView *bottomSubmitView;
@property(weak, nonatomic) CXEditLabel *kindLabel;
@property(weak, nonatomic) CXEditLabel *startTimeLabel;
@property(weak, nonatomic) CXEditLabel *endTimeLabel;
@property(weak, nonatomic) CXEditLabel *timeLabel;
@property(weak, nonatomic) CXEditLabel *reasonLabel;
@property(weak, nonatomic) CXEditLabel *remarkLabel;
/// 我的休假信息
@property(copy, nonatomic) NSMutableArray *holidayInfoArr;
@property(weak, nonatomic) CXEditLabel *sqrLabel;
@property(weak, nonatomic) CXEditLabel *sqDateLabel;
@property(weak, nonatomic) CXEditLabel *endAMPMLabel;
@property(weak, nonatomic) CXEditLabel *startAMPMLabel;
@property(weak, nonatomic) UIImageView *arrow_1;

/** 可休类型天数Label */
@property(nonatomic, strong) UILabel *kxlxtsLabel;
/** 可休天数Label */
@property(nonatomic, strong) UILabel *kxtsLabel;
/** 本年度类型天数Label */
@property(nonatomic, strong) UILabel *bndlxtsLabel;
/** 本年度天数Label */
@property(nonatomic, strong) UILabel *bndtsLabel;
/** 中间分割线 */
@property(nonatomic, strong) UIView *topMiddleSeperatorLine;
/** 顶部天数底部分割线 */
@property(nonatomic, strong) UIView *topTSBottomLine;
/** 请假类型 */
@property(nonatomic, strong) CXEditLabel *qjlxLabel;
/** 开始时间 */
@property(nonatomic, strong) CXEditLabel *kssjLabel;
/** 结束时间 */
@property(nonatomic, strong) CXEditLabel *jssjLabel;
/** 请假原因 */
@property(nonatomic, strong) CXEditLabel *qjyyLabel;
/** 备注 */
@property(nonatomic, strong) CXEditLabel *bzLabel;
/** 说明Label */
@property(nonatomic, strong) UILabel *smLabel;
/** 提示Label */
@property(nonatomic, strong) UILabel *tsLabel;

@property(strong, nonatomic) NSMutableArray<QJSQEditModel *> *dataSourceArr;





@end

@implementation QJSQEditViewController

#define kKxlxtsLabelTopSpace 15.0
#define kKxlxtsLabelFontSize 14.0
#define kKxlxtsLabelTextColor RGBACOLOR(54.0, 54.0, 54.0, 1.0)
#define kTopMiddleSeperatorLineWidth 0.5
#define kTopMiddleSeperatorLineTopSpace 5.0
#define kTopMiddleSeperatorLineHeight (kKxlxtsLabelTopSpace + kKxlxtsLabelFontSize + kKxtsLabelTopSpace + kKxtsLabelFontSize + kKxtsLabelTopSpace - 2*kTopMiddleSeperatorLineTopSpace)
#define kTopMiddleSeperatorLineColor RGBACOLOR(231.0, 231.0, 231.0, 1.0)

#define kKxtsLabelTopSpace 17.0
#define kKxtsLabelFontSize 24.0
#define kDayLabelFontSize 16.0
#define kTopTSBottomLineHeight 5.0
#define kTopTSBottomLineColor RGBACOLOR(243.0, 245.0, 245.0, 1.0)
#define kArrowImageLeftOffset 30.0

#define kLabelTextColor RGBACOLOR(96.0, 96.0, 96.0, 1.0)


#pragma mark - get & set

- (NSMutableArray<QJSQEditModel *> *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (NSMutableArray *)holidayInfoArr {
    if (!_holidayInfoArr) {
        _holidayInfoArr = [[NSMutableArray alloc] init];
    }
    return _holidayInfoArr;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContentView;
}

- (CXVacationApplicationModel *)vacationApplicationModel {
    if (!_vacationApplicationModel) {
        _vacationApplicationModel = [[CXVacationApplicationModel alloc] init];
    }
    return _vacationApplicationModel;
}

#pragma mark - instance function
/// 箭头
- (UIImageView *)arrowImage {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.contentMode = UIViewContentModeCenter;
    return arrow;
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(248.0, 248.0, 248.0, 1.0);
    [self.scrollContentView addSubview:line];
    return line;
}

//保存
- (void)saveRequest {
    if (![self.qjlxLabel.content length]) {
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

- (QJSQEditModel *)getQJSQEditModelWithCode:(NSNumber *)code{
    for(QJSQEditModel * model in self.dataSourceArr){
        if([model.code integerValue] == [code integerValue]){
            return model;
        }
    }
    return nil;
}

#pragma mark - UI
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
        make.bottom.equalTo(self.view).mas_offset(-CXBottomSubmitView_height - kTabbarSafeBottomMargin);
        make.top.equalTo([self rootTopView].mas_bottom);
    }];
    /// 左边距
    CGFloat leftMargin = 15.0f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineWidth = Screen_Width;
    
    @weakify(self);
    
    
    self.kxlxtsLabel = [[UILabel alloc] init];
    self.kxlxtsLabel.frame = CGRectMake(0, kKxlxtsLabelTopSpace, (Screen_Width - kTopMiddleSeperatorLineWidth)/2.0, kKxlxtsLabelFontSize);
    self.kxlxtsLabel.font = [UIFont systemFontOfSize:kKxlxtsLabelFontSize];
    self.kxlxtsLabel.textAlignment = NSTextAlignmentCenter;
    self.kxlxtsLabel.backgroundColor = [UIColor clearColor];
    self.kxlxtsLabel.text = @"当前可休假天数";
    self.kxlxtsLabel.textColor = kKxlxtsLabelTextColor;
    [self.scrollContentView addSubview:self.kxlxtsLabel];
    
    self.topMiddleSeperatorLine = [[UIView alloc] init];
    self.topMiddleSeperatorLine.frame = CGRectMake((Screen_Width - kTopMiddleSeperatorLineWidth)/2.0, kTopMiddleSeperatorLineTopSpace, kTopMiddleSeperatorLineWidth, kTopMiddleSeperatorLineHeight);
    self.topMiddleSeperatorLine.backgroundColor = kTopMiddleSeperatorLineColor;
    [self.scrollContentView addSubview:self.topMiddleSeperatorLine];
    
    
    self.bndlxtsLabel = [[UILabel alloc] init];
    self.bndlxtsLabel.frame = CGRectMake((Screen_Width - kTopMiddleSeperatorLineWidth)/2.0 + kTopMiddleSeperatorLineWidth, kKxlxtsLabelTopSpace, Screen_Width/2.0, kKxlxtsLabelFontSize);
    self.bndlxtsLabel.font = [UIFont systemFontOfSize:kKxlxtsLabelFontSize];
    self.bndlxtsLabel.textAlignment = NSTextAlignmentCenter;
    self.bndlxtsLabel.backgroundColor = [UIColor clearColor];
    self.bndlxtsLabel.text = @"本年度假天数";
    self.bndlxtsLabel.textColor = kKxlxtsLabelTextColor;
    [self.scrollContentView addSubview:self.bndlxtsLabel];
    
    self.kxtsLabel = [[UILabel alloc] init];
    self.kxtsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.kxlxtsLabel.frame) + kKxtsLabelTopSpace, (Screen_Width - kTopMiddleSeperatorLineWidth)/2.0, kKxtsLabelFontSize);
    self.kxtsLabel.font = [UIFont systemFontOfSize:kKxtsLabelFontSize];
    self.kxtsLabel.textAlignment = NSTextAlignmentCenter;
    self.kxtsLabel.backgroundColor = [UIColor clearColor];
    self.kxtsLabel.text = @"0天";
    self.kxtsLabel.textColor = kKxlxtsLabelTextColor;
    NSMutableAttributedString *kxtsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:self.kxtsLabel.text];
    [kxtsLabelAttributedString addAttribute:NSFontAttributeName
                     value:[UIFont boldSystemFontOfSize:kDayLabelFontSize]
                     range:[self.kxtsLabel.text rangeOfString:@"天"]];
    self.kxtsLabel.attributedText = kxtsLabelAttributedString;
    [self.scrollContentView addSubview:self.kxtsLabel];
    
    self.bndtsLabel = [[UILabel alloc] init];
    self.bndtsLabel.frame = CGRectMake((Screen_Width - kTopMiddleSeperatorLineWidth)/2.0 + kTopMiddleSeperatorLineWidth, CGRectGetMaxY(self.kxlxtsLabel.frame) + kKxtsLabelTopSpace, (Screen_Width - kTopMiddleSeperatorLineWidth)/2.0, kKxtsLabelFontSize);
    self.bndtsLabel.font = [UIFont systemFontOfSize:kKxtsLabelFontSize];
    self.bndtsLabel.textAlignment = NSTextAlignmentCenter;
    self.bndtsLabel.backgroundColor = [UIColor clearColor];
    self.bndtsLabel.text = @"0天";
    self.bndtsLabel.textColor = kKxlxtsLabelTextColor;
    NSMutableAttributedString *bndtsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:self.bndtsLabel.text];
    [bndtsLabelAttributedString addAttribute:NSFontAttributeName
                     value:[UIFont boldSystemFontOfSize:kDayLabelFontSize]
                     range:[self.bndtsLabel.text rangeOfString:@"天"]];
    self.bndtsLabel.attributedText = bndtsLabelAttributedString;
    [self.scrollContentView addSubview:self.bndtsLabel];
    
    self.topTSBottomLine = [[UIView alloc] init];
    self.topTSBottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.kxtsLabel.frame) + kKxtsLabelTopSpace, Screen_Width, kTopTSBottomLineHeight);
    self.topTSBottomLine.backgroundColor = kTopTSBottomLineColor;
    [self.scrollContentView addSubview:self.topTSBottomLine];
    
    //请假类型
    self.qjlxLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(self.topTSBottomLine.frame), Screen_Width - 2*leftMargin, viewHeight)];
    self.qjlxLabel.textColor = kLabelTextColor;
    self.qjlxLabel.inputType = CXEditLabelInputTypeCustomPicker;
    self.qjlxLabel.showDropdown = NO;
    self.qjlxLabel.title = @"请假类型：";
    self.qjlxLabel.placeholder = @"请选择请假类型";
    [self.scrollContentView addSubview:self.qjlxLabel];
    self.qjlxLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        int leaveType = [editLabel.selectedPickerData[CXEditLabelCustomPickerValueKey] intValue];
        self.vacationApplicationModel.leaveType = [NSNumber numberWithInt:leaveType];
        CXHolidayInfoModel *model = [self.holidayInfoArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.code == %d", leaveType]].firstObject;
        self.vacationApplicationModel.minDay = model.minDay;
        self.vacationApplicationModel.availableDay = model.availableDay;
        
        
        QJSQEditModel * QJSQEditModel = [self getQJSQEditModelWithCode:@(leaveType)];
        self.qjlxLabel.content = QJSQEditModel.name;
        NSRange range = [QJSQEditModel.name rangeOfString:@"("];
        NSString * rangeName = QJSQEditModel.name;
        if(range.location != NSNotFound){
            rangeName = [rangeName substringToIndex:range.location];
        }
        self.kxlxtsLabel.text = [NSString stringWithFormat:@"当前可休%@天数",rangeName];
        self.bndlxtsLabel.text = [NSString stringWithFormat:@"本年度%@天数",rangeName];
        
        self.kxtsLabel.text = [NSString stringWithFormat:@"%zd天",[QJSQEditModel.availableDay integerValue]];
        self.kxtsLabel.textColor = kKxlxtsLabelTextColor;
        NSMutableAttributedString *kxtsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:self.kxtsLabel.text];
        [kxtsLabelAttributedString addAttribute:NSFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:kDayLabelFontSize]
                                          range:[self.kxtsLabel.text rangeOfString:@"天"]];
        self.kxtsLabel.attributedText = kxtsLabelAttributedString;
        
        self.bndtsLabel.text = [NSString stringWithFormat:@"%zd天",[QJSQEditModel.totalDays integerValue]];
        self.bndtsLabel.textColor = kKxlxtsLabelTextColor;
        NSMutableAttributedString *bndtsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:self.bndtsLabel.text];
        [bndtsLabelAttributedString addAttribute:NSFontAttributeName
                                           value:[UIFont boldSystemFontOfSize:kDayLabelFontSize]
                                           range:[self.bndtsLabel.text rangeOfString:@"天"]];
        self.bndtsLabel.attributedText = bndtsLabelAttributedString;
        

        if (model.minDay == 0.5f) {
            self.startAMPMLabel.hidden = NO;
            self.endAMPMLabel.hidden = NO;
        } else {
            self.startAMPMLabel.hidden = YES;
            self.endAMPMLabel.hidden = YES;
        }
    };
    
    // 箭头_1
    UIImageView *arrow_1 = [self arrowImage];
    self.arrow_1 = arrow_1;
    arrow_1.frame = CGRectMake(self.qjlxLabel.right - kArrowImageLeftOffset, self.qjlxLabel.top, 20.f, viewHeight);
    [self.scrollContentView addSubview:arrow_1];

    // 分隔线_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0, CGRectGetMaxY(self.qjlxLabel.frame), lineWidth, lineHeight);

    // 开始时间
    CXEditLabel *startTimeLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin - 150.f, viewHeight)];
    startTimeLabel.textColor = kLabelTextColor;
    self.startTimeLabel = startTimeLabel;
    startTimeLabel.title = @"开始时间：";
    startTimeLabel.placeholder = @"请选择开始时间";
    startTimeLabel.inputType = CXEditLabelInputTypeDate;
    [self.scrollContentView addSubview:startTimeLabel];
    startTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveStart = editLabel.content;
        [self checkConflict];
    };

    CXEditLabel *startAMPMLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(startTimeLabel.right, startTimeLabel.top, 100.f, viewHeight)];
    startAMPMLabel.textColor = kLabelTextColor;
    self.startAMPMLabel = startAMPMLabel;
    startAMPMLabel.hidden = YES;
    startAMPMLabel.content = @"上午(09:00)";
    startAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    startAMPMLabel.selectViewTitle = @"开始时间";
    startAMPMLabel.pickerTextArray = @[@"上午(09:00)", @"下午(14:00)"];
    startAMPMLabel.pickerValueArray = @[@"1", @"2"];
    startAMPMLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        [self checkConflict];
        
    };
    [self.scrollContentView addSubview:startAMPMLabel];

    // 箭头_2
    UIImageView *arrow_2 = [self arrowImage];
    arrow_2.frame = CGRectMake(self.arrow_1.left, startTimeLabel.top, 20.f, viewHeight);
    [self.scrollContentView addSubview:arrow_2];

    // 分隔线_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, startTimeLabel.bottom, lineWidth, lineHeight);

    // 结束时间
    CXEditLabel *endTimeLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin - 150.f, viewHeight)];
    endTimeLabel.textColor = kLabelTextColor;
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.inputType = CXEditLabelInputTypeDate;
    endTimeLabel.title = @"结束时间：";
    endTimeLabel.placeholder = @"请选择结束时间";
    [self.scrollContentView addSubview:endTimeLabel];
    endTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveEnd = editLabel.content;
        [self checkConflict];
    };
    
    CXEditLabel *endAMPMLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(endTimeLabel.right, endTimeLabel.top, 100.f, viewHeight)];
    endAMPMLabel.textColor = kLabelTextColor;
    endAMPMLabel.hidden = YES;
    self.endAMPMLabel = endAMPMLabel;
    endAMPMLabel.content = @"下午(18:00)";
    endAMPMLabel.selectViewTitle = @"结束时间";
    endAMPMLabel.inputType = CXEditLabelInputTypeCustomPicker;
    endAMPMLabel.pickerTextArray = @[@"下午(13:00)", @"下午(18:00)"];
    endAMPMLabel.pickerValueArray = @[@"1", @"2"];
    endAMPMLabel.selectedPickerData = @{@"text":@"下午(18:00)"};
    endAMPMLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        [self checkConflict];
        
    };
    [self.scrollContentView addSubview:endAMPMLabel];

    // 箭头_3
    UIImageView *arrow_3 = [self arrowImage];
    arrow_3.frame = CGRectMake(self.arrow_1.left, endTimeLabel.top, 20.f, viewHeight);
    [self.scrollContentView addSubview:arrow_3];

    // 分隔线_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, endTimeLabel.bottom, lineWidth, lineHeight);
    
    
    // 请假原因
    CXEditLabel *reasonLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
    reasonLabel.textColor = kLabelTextColor;
    self.reasonLabel = reasonLabel;
    reasonLabel.title = @"请假原因：";
    reasonLabel.placeholder = @"请输入请假原因";
    reasonLabel.scale = YES;
    [self.scrollContentView addSubview:reasonLabel];
    reasonLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveReason = editLabel.content;
    };

    // 分隔线_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = CGRectMake(0.f, reasonLabel.bottom + 50, lineWidth, lineHeight);

    // 备注
    CXEditLabel *remarkLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
    remarkLabel.textColor = kLabelTextColor;
    self.remarkLabel = remarkLabel;
    remarkLabel.title = @"备　　注：";
    remarkLabel.placeholder = @"请输入备注";
    remarkLabel.scale = YES;
    [self.scrollContentView addSubview:remarkLabel];
    remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.vacationApplicationModel.leaveMemo = editLabel.content;
    };
    
    // 分隔线_6
    UIView *line_6 = [self createFormSeperatorLine];
    line_6.frame = CGRectMake(0.f, remarkLabel.bottom, lineWidth, lineHeight);
    
    self.smLabel = [[UILabel alloc] init];
    self.smLabel.frame = CGRectMake(leftMargin, line_6.bottom + 10, Screen_Width - 2*leftMargin, kKxlxtsLabelFontSize);
    self.smLabel.font = [UIFont systemFontOfSize:12.0];
    self.smLabel.numberOfLines = 0;
    self.smLabel.textAlignment = NSTextAlignmentLeft;
    self.smLabel.backgroundColor = [UIColor clearColor];
    self.smLabel.text = @"备注：当前可休年假天数（4.1前包含前一年的结转天数）； 本年度年假总天数（包含法定带薪年假、司龄奖励假和公司奖励假）。";
    CGSize smLabelSize = [self.smLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    self.smLabel.frame = CGRectMake(leftMargin, line_6.bottom + 10, Screen_Width - 2*leftMargin, smLabelSize.height);
    self.smLabel.textColor = RGBACOLOR(158.0, 158.0, 158.0, 1.0);
    [self.scrollContentView addSubview:self.smLabel];
    
    // 更新frame
    reasonLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
        @strongify(self);
        line_5.frame = CGRectMake(0.f, self.reasonLabel.bottom, lineWidth, lineHeight);
        remarkLabel.frame = CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight);
        line_6.frame = CGRectMake(0.f, remarkLabel.bottom, lineWidth, lineHeight);
        self.smLabel.frame = CGRectMake(leftMargin, line_6.bottom + 10, Screen_Width - 2*leftMargin, smLabelSize.height);
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.smLabel.bottom);
    };
    // 更新frame
    remarkLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
        @strongify(self);
        line_6.frame = CGRectMake(0.f, self.remarkLabel.bottom, lineWidth, lineHeight);
        self.smLabel.frame = CGRectMake(leftMargin, line_6.bottom + 10, Screen_Width - 2*leftMargin, smLabelSize.height);
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.smLabel.bottom);
    };
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.smLabel.bottom);
}

- (void)checkConflict{
    if(self.startTimeLabel.content && [self.startTimeLabel.content length] > 0 && self.endTimeLabel.content && [self.endTimeLabel.content length] > 0){
        NSString *url = [NSString stringWithFormat:@"%@holiday/check/conflict", urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.startTimeLabel.content forKey:@"leaveStart"];
        [params setValue:self.endTimeLabel.content forKey:@"leaveEnd"];
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                if([JSON[@"data"][@"isConflict"] integerValue]){
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }
}

- (void)setUpBottomSubmitView {
    // 提交
    CXBottomSubmitView *bottomSubmitView = [[CXBottomSubmitView alloc] initWithType:self.formType];
    self.bottomSubmitView = bottomSubmitView;
    @weakify(self);
    bottomSubmitView.callBack = ^(NSString *title) {
        @strongify(self);
        if ([@"提  交" isEqualToString:title]) {
            [self saveRequest];
        }
    };
    [self.view addSubview:bottomSubmitView];//底部点击
    [bottomSubmitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXBottomSubmitView_height);
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    NSString *url = [NSString stringWithFormat:@"%@holiday/myHoliday", urlPrefix];
    
    HUD_SHOW(nil);
    
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
        CXHolidayInfoModel *model = [CXHolidayInfoModel yy_modelWithDictionary:responseObj];
        if (HTTPSUCCESSOK == model.status) {
            NSArray<QJSQEditModel *> *data = [NSArray yy_modelArrayWithClass:[QJSQEditModel class] json:responseObj[@"data"]];
            [self.dataSourceArr removeAllObjects];
            [self.dataSourceArr addObjectsFromArray:data];
            
            [self.holidayInfoArr removeAllObjects];
            [self.holidayInfoArr addObjectsFromArray:model.data];
            NSArray * nameArray = [self.holidayInfoArr valueForKey:@"name"];
            NSArray * availableDayArray = [self.holidayInfoArr valueForKey:@"availableDay"];
            NSMutableArray * pickerTextArray = @[].mutableCopy;
            for(NSInteger i = 0;i<[nameArray count];i++){
                NSString * pickerText = [NSString stringWithFormat:@"%@(%zd天)",nameArray[i],[availableDayArray[i] integerValue]];
                [pickerTextArray addObject:pickerText];
            }
            self.qjlxLabel.pickerTextArray = [NSArray arrayWithArray:pickerTextArray];
            self.qjlxLabel.pickerValueArray = [self.holidayInfoArr valueForKey:@"code"];
        } else {
            MAKE_TOAST(model.msg);
        }
        HUD_HIDE;
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
    
    [self setUpNavBar];
    [self setUpSubViews];
    [self setUpBottomSubmitView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
