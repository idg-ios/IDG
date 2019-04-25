//
//  CXLeaveToSubmitViewController.m
//  InjoyERP
//
//  Created by wtz on 16/11/21.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXLeaveToSubmitViewController.h"
#import "UIView+Category.h"
#import "CXLabelTextView.h"
#import "SDCustomDatePicker2.h"
#import "CXLabelTextView.h"
#import "CXWorkCreateDetailView.h"
#import "CXOLDERPAnnexView.h"
#import "CXSelectContactViewController.h"
#import "SDUploadFileModel.h"
#import "HttpTool.h"

#define kLeftSpace kFormViewMargin

@interface CXLeaveToSubmitViewController ()<UITableViewDelegate, UITableViewDataSource,CXWorkCreateDetailViewReloadHeightDelegate>

/** TableView */
@property (nonatomic, strong) UITableView *tableView;
/** tableView的tableHeaderView */
@property(nonatomic, strong) UIView * theTableHeaderView;
/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
//日期选择器
@property (nonatomic, strong) SDCustomDatePicker2* datePicker;
//日期
@property (nonatomic, strong) UILabel * dateContentLabel;
//title
@property (nonatomic, strong) UILabel * titleContentLabel;
//开始时间
@property (nonatomic, strong) UILabel * startTimeContentLabel;
//结束时间
@property (nonatomic, strong) UILabel * endTimeContentLabel;
/** 内容视图 */
@property(nonatomic, strong) CXWorkCreateDetailView * workCreateDetailView;
/** 附件视图 */
@property(nonatomic, strong) CXOLDERPAnnexView *annexView;
/** 内容视图高度 */
@property(nonatomic) CGFloat contentDetailViewHeight;

@property(nonatomic, strong) UILabel * annexLabel;

@property(nonatomic, strong) UIView * fourthLineView;

@property (nonatomic, strong) NSString * startTimeStr;

@property (nonatomic, strong) NSString * endTimeStr;

@property (nonatomic, strong) NSString * compareStartStr;

@property (nonatomic, strong) NSString * compareEndStr;

//发送的附件数组
@property (nonatomic, strong) NSMutableArray * sendAnnexDataArray;

@property (nonatomic, strong) NSMutableArray * annex;

@end

@implementation CXLeaveToSubmitViewController

#pragma mark - 选择器  日期
- (NSMutableArray *)annex{
    if(!_annex){
        _annex = @[].mutableCopy;
    }
    return _annex;
}

- (SDCustomDatePicker2*)datePicker
{
    if (!_datePicker) {
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SDCustomDatePicker2" owner:self options:nil];
        _datePicker = [arr lastObject];
        _datePicker.isFromCXTravel = NO;
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    return _datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setupView];
}

- (void)setupView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"请假申请")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"发送" addTarget:self action:@selector(sendBtnClick)];
    
    self.contentDetailViewHeight = kCellHeight;
    
    /** UITableView */
    _theTableHeaderView = [[UIView alloc] init];
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, 4*kCellHeight + self.contentDetailViewHeight + 4);
    _theTableHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"日期："];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = kFontSizeForForm;
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(kLeftSpace, (kCellHeight - kFontSizeValueForForm)/2, dateLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:dateLabel];
    
    self.dateContentLabel = [[UILabel alloc] init];
    self.dateContentLabel.text = [self getCurrentDate];
    self.dateContentLabel.backgroundColor = [UIColor clearColor];
    self.dateContentLabel.textColor = [UIColor blackColor];
    self.dateContentLabel.textAlignment = NSTextAlignmentLeft;
    self.dateContentLabel.font = kFontSizeForForm;
    [self.dateContentLabel sizeToFit];
    self.dateContentLabel.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame), (kCellHeight - kFontSizeValueForForm)/2, Screen_Width - kLeftSpace - CGRectGetMaxX(dateLabel.frame), kFontSizeValueForForm);
    [_theTableHeaderView addSubview:self.dateContentLabel];
    
    UIButton * dateContentLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateContentLabelBtn.frame = self.dateContentLabel.frame;
    [dateContentLabelBtn addTarget:self action:@selector(dateContentLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [_theTableHeaderView addSubview:dateContentLabelBtn];
    
    UIView * firstLineView = [[UIView alloc] init];
    firstLineView.frame = CGRectMake(0, kCellHeight, Screen_Width, 1);
    firstLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [_theTableHeaderView addSubview:firstLineView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"标题："];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = kFontSizeForForm;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(kLeftSpace, kCellHeight + (kCellHeight - kFontSizeValueForForm)/2, titleLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:titleLabel];
    
    self.titleContentLabel = [[UILabel alloc] init];
    self.titleContentLabel.text = @"";
    self.titleContentLabel.backgroundColor = [UIColor clearColor];
    self.titleContentLabel.textColor = [UIColor blackColor];
    self.titleContentLabel.textAlignment = NSTextAlignmentLeft;
    self.titleContentLabel.font = kFontSizeForForm;
    [self.titleContentLabel sizeToFit];
    self.titleContentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), kCellHeight + 1 + (kCellHeight - kFontSizeValueForForm)/2, Screen_Width - kLeftSpace - CGRectGetMaxX(titleLabel.frame), kFontSizeValueForForm);
    [_theTableHeaderView addSubview:self.titleContentLabel];
    
    UIButton * titleContentLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleContentLabelBtn.frame = self.titleContentLabel.frame;
    [titleContentLabelBtn addTarget:self action:@selector(titleContentLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [_theTableHeaderView addSubview:titleContentLabelBtn];
    
    UIView * secondLineView = [[UIView alloc] init];
    secondLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight, Screen_Width, 1);
    secondLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [_theTableHeaderView addSubview:secondLineView];
    
    UILabel * leaveTimeLabel = [[UILabel alloc] init];
    leaveTimeLabel.text = [NSString stringWithFormat:@"请假时间："];
    leaveTimeLabel.backgroundColor = [UIColor clearColor];
    leaveTimeLabel.textColor = [UIColor blackColor];
    leaveTimeLabel.textAlignment = NSTextAlignmentLeft;
    leaveTimeLabel.font = kFontSizeForForm;
    [leaveTimeLabel sizeToFit];
    leaveTimeLabel.frame = CGRectMake(kLeftSpace, kCellHeight + 1 + kCellHeight + (kCellHeight - kFontSizeValueForForm)/2, leaveTimeLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:leaveTimeLabel];
    
    self.startTimeContentLabel = [[UILabel alloc] init];
    self.startTimeContentLabel.text = @"11月05日 11:08 ";
    self.startTimeContentLabel.backgroundColor = [UIColor clearColor];
    self.startTimeContentLabel.textColor = [UIColor lightGrayColor];
    self.startTimeContentLabel.textAlignment = NSTextAlignmentLeft;
    self.startTimeContentLabel.font = [UIFont systemFontOfSize:13.f];
    [self.startTimeContentLabel sizeToFit];
    self.startTimeContentLabel.frame = CGRectMake(CGRectGetMaxX(leaveTimeLabel.frame), kCellHeight + 1 + kCellHeight + (kCellHeight - kFontSizeValueForForm)/2, self.startTimeContentLabel.size.width + 7, kFontSizeValueForForm);
    self.startTimeContentLabel.text = @"";
    [_theTableHeaderView addSubview:self.startTimeContentLabel];
    
    UIButton * startTimeContentLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startTimeContentLabelBtn.frame = self.startTimeContentLabel.frame;
    [startTimeContentLabelBtn addTarget:self action:@selector(startTimeContentLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [_theTableHeaderView addSubview:startTimeContentLabelBtn];
    
    UILabel * toLabel = [[UILabel alloc] init];
    toLabel.text = [NSString stringWithFormat:@"至"];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.textColor = [UIColor blackColor];
    toLabel.textAlignment = NSTextAlignmentLeft;
    toLabel.font = kFontSizeForForm;
    [toLabel sizeToFit];
    toLabel.frame = CGRectMake(CGRectGetMaxX(_startTimeContentLabel.frame) + kLeftSpace, kCellHeight + 1 + kCellHeight + (kCellHeight - kFontSizeValueForForm)/2, toLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:toLabel];
    
    self.endTimeContentLabel = [[UILabel alloc] init];
    self.endTimeContentLabel.text = @"11月05日 11:08 ";
    self.endTimeContentLabel.backgroundColor = [UIColor clearColor];
    self.endTimeContentLabel.textColor = [UIColor lightGrayColor];
    self.endTimeContentLabel.textAlignment = NSTextAlignmentLeft;
    self.endTimeContentLabel.font = [UIFont systemFontOfSize:13.f];
    [self.endTimeContentLabel sizeToFit];
    self.endTimeContentLabel.frame = CGRectMake(CGRectGetMaxX(toLabel.frame) + kLeftSpace, kCellHeight + 1 + kCellHeight + (kCellHeight - kFontSizeValueForForm)/2, self.endTimeContentLabel.size.width + 7, kFontSizeValueForForm);
    self.endTimeContentLabel.text = @"";
    [_theTableHeaderView addSubview:self.endTimeContentLabel];
    
    UIButton * endTimeContentLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endTimeContentLabelBtn.frame = self.endTimeContentLabel.frame;
    [endTimeContentLabelBtn addTarget:self action:@selector(endTimeContentLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [_theTableHeaderView addSubview:endTimeContentLabelBtn];
    
    UIView * thirdLineView = [[UIView alloc] init];
    thirdLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight + 1 + kCellHeight, Screen_Width, 1);
    thirdLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [_theTableHeaderView addSubview:thirdLineView];
    
    _workCreateDetailView= [[CXWorkCreateDetailView alloc] initWithTitle:@"内容：" andFrame:CGRectMake(0, CGRectGetMaxY(thirdLineView.frame), Screen_Width, self.contentDetailViewHeight) AndCXContentDetailViewMode:CXWorkCreateDetailViewModeCreate];
    _workCreateDetailView.delegate = self;
    [_theTableHeaderView addSubview:_workCreateDetailView];
    
    self.annexLabel = [[UILabel alloc] init];
    self.annexLabel.text = [NSString stringWithFormat:@"附件："];
    self.annexLabel.backgroundColor = [UIColor clearColor];
    self.annexLabel.textColor = [UIColor blackColor];
    self.annexLabel.textAlignment = NSTextAlignmentLeft;
    self.annexLabel.font = kFontSizeForForm;
    [self.annexLabel sizeToFit];
    self.annexLabel.frame = CGRectMake(kLeftSpace, kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:self.annexLabel];
    
    self.annexView = [[CXOLDERPAnnexView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.annexLabel.frame), kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight, Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace, kCellHeight) AndViewWidth:Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace];
    self.annexView.vc = self;
    [_theTableHeaderView addSubview:self.annexView];
    
    self.fourthLineView = [[UIView alloc] init];
    self.fourthLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight + kCellHeight + 1, Screen_Width, 1);
    self.fourthLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [_theTableHeaderView addSubview:self.fourthLineView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height -navHigh);
    _tableView.backgroundColor = SDBackGroudColor;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.tableHeaderView = _theTableHeaderView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- 获取当前创建时间
-(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)sendBtnClick
{
    
    if(self.titleContentLabel.text == nil || [self.titleContentLabel.text length] <= 0){
        TTAlert(@"请填写标题");
        return;
    }
    if(self.workCreateDetailView.theContentText == nil || [self.workCreateDetailView.theContentText length] <= 0){
        TTAlert(@"请填写内容");
        return;
    }
    if(self.startTimeStr == nil || [self.startTimeStr length] <= 0){
        TTAlert(@"请选择开始时间");
        return;
    }
    if(self.endTimeStr == nil || [self.endTimeStr length] <= 0){
        TTAlert(@"请选择结束时间");
        return;
    }
    if([_compareStartStr longLongValue] > [_compareEndStr longLongValue]){
        TTAlert(@"开始时间不能大于结束时间");
        return;
    }
    
    _sendAnnexDataArray = [_annexView.AllAnnexDataArray mutableCopy];
    if (_sendAnnexDataArray.count) {
        
        //将已有的数据取出  传给服务器删除
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSMutableString *names = [NSMutableString stringWithString:@""];
        for (SDUploadFileModel * model in self.sendAnnexDataArray)
        {
            [names appendString:model.fileName];
            [names appendString:@","];
        }
        names.length>=1?[names replaceCharactersInRange:NSMakeRange(names.length-1, 1) withString:@""]:[names appendString:@""];
        [params setValue:names forKey:@"names"];
        [self.annex removeAllObjects];
        __weak __typeof(self)weakSelf = self;
        [self showHudInView:self.view hint:nil];
        [HttpTool multipartPostFileDataWithPath:[NSString stringWithFormat:@"%@/annex/fileUpload",urlPrefix] params:params dataAry:self.sendAnnexDataArray success:^(id JSON){
            if ([JSON[@"status"] integerValue] == 200) {
                [weakSelf hideHud];
                CXSelectContactViewController * selectContactViewController = [[CXSelectContactViewController alloc] init];
                selectContactViewController.type = CXLeaveToSubmitType;
                
                selectContactViewController.AllAnnexDataArray = self.annexView.AllAnnexDataArray;
                
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setValue:self.titleContentLabel.text forKey:@"name"];
                [params setValue:self.workCreateDetailView.theContentText forKey:@"remark"];
                [params setValue:self.startTimeStr forKey:@"startDate"];
                [params setValue:self.endTimeStr forKey:@"endDate"];
                
                for (NSDictionary *dic in JSON[@"data"]) {
                    [self.annex addObject:dic];
                }
                NSData *data;
                if (self.annex.count)
                {
                    data = [NSJSONSerialization dataWithJSONObject:self.annex options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *annexList= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [params setValue:annexList forKey:@"annex"];
                }
                
                selectContactViewController.params = params;
                
                
                [self.navigationController pushViewController:selectContactViewController animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
            else{
                [weakSelf hideHud];
            }
        }failure:^(NSError *error){
            [weakSelf hideHud];
            TTAlert(KNetworkFailRemind);
        }];
    }
    else{
        CXSelectContactViewController * selectContactViewController = [[CXSelectContactViewController alloc] init];
        selectContactViewController.type = CXLeaveToSubmitType;
        
        selectContactViewController.AllAnnexDataArray = self.annexView.AllAnnexDataArray;
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:self.titleContentLabel.text forKey:@"name"];
        [params setValue:self.workCreateDetailView.theContentText forKey:@"remark"];
        [params setValue:self.startTimeStr forKey:@"startDate"];
        [params setValue:self.endTimeStr forKey:@"endDate"];
        selectContactViewController.params = params;
        
        
        [self.navigationController pushViewController:selectContactViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)dateContentLabelClick
{
    //    [self showTimePickerView:_dateContentLabel];
}


#pragma mark -- 开始时间和结束时间点击事件
-(void)showTimePickerView:(UILabel *)timeLabel
{
    if (self.datePicker != nil) {
        //清空之前的视图
        [self.datePicker removeFromSuperview];
    }
    
    self.datePicker.dateCallBack2 = ^(NSDate* date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        timeLabel.text = strDate;
        if(timeLabel == self.startTimeContentLabel){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *startDate = [dateFormatter stringFromDate:date];
            _startTimeStr = startDate;
            
            [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
            NSString *start = [dateFormatter stringFromDate:date];
            _compareStartStr = start;
            
        }else if(timeLabel == self.endTimeContentLabel){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *startDate = [dateFormatter stringFromDate:date];
            _endTimeStr = startDate;
            
            [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
            NSString *end = [dateFormatter stringFromDate:date];
            _compareEndStr = end;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
}

- (void)titleContentLabelClick
{
    CXLabelTextView *keyboard = [[CXLabelTextView alloc] initWithKeyboardType:UIKeyboardTypeDefault AndLabel:self.titleContentLabel];
    keyboard.maxLengthOfString = 1000;
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:keyboard];
}

- (void)startTimeContentLabelClick
{
    [self showTimePickerView:_startTimeContentLabel];
}

- (void)endTimeContentLabelClick
{
    [self showTimePickerView:_endTimeContentLabel];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CXWorkCreateDetailViewReloadHeightDelegate
/**
 *  CXContentDetailViewReloadHeightDelegate 内容视图代理方法
 *
 *  @param viewHeight 内容视图高度
 *
 */
- (void)workCreateDetailViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight
{
    self.contentDetailViewHeight = viewHeight;
    self.annexLabel.frame = CGRectMake(kLeftSpace, kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    self.annexView.frame = CGRectMake(CGRectGetMaxX(self.annexLabel.frame)+ kLeftSpace, kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight, Screen_Width, kCellHeight);
    self.fourthLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight + kCellHeight + 1 + self.contentDetailViewHeight + kCellHeight + 1, Screen_Width, 1);
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, 4*kCellHeight + self.contentDetailViewHeight + 4);;
    [self.tableView setTableHeaderView:_theTableHeaderView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
