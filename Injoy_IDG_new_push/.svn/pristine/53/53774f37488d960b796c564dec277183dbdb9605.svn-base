//
//  CXYunJingAddNewWorkCircleViewController.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYunJingAddNewWorkCircleViewController.h"
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

@interface CXYunJingAddNewWorkCircleViewController ()<UITableViewDelegate, UITableViewDataSource,CXWorkCreateDetailViewReloadHeightDelegate>

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
/** 内容视图 */
@property(nonatomic, strong) CXWorkCreateDetailView * workCreateDetailView;
/** 附件视图 */
@property(nonatomic, strong) CXOLDERPAnnexView *annexView;
/** 内容视图高度 */
@property(nonatomic) CGFloat contentDetailViewHeight;

@property(nonatomic, strong) UILabel * annexLabel;

@property(nonatomic, strong) UIView * thirdLineView;

//发送的附件数组
@property (nonatomic, strong) NSMutableArray * sendAnnexDataArray;

@property (nonatomic, strong) NSMutableArray * annex;

@end

@implementation CXYunJingAddNewWorkCircleViewController

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
        _datePicker.isFromCXTravel = YES;
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
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
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"发送" addTarget:self action:@selector(sendBtnClick)];
    
    self.contentDetailViewHeight = kCellHeight;
    
    /** UITableView */
    _theTableHeaderView = [[UIView alloc] init];
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kCellHeight + self.contentDetailViewHeight + 1);
    _theTableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _workCreateDetailView= [[CXWorkCreateDetailView alloc] initWithTitle:@"内容：" andFrame:CGRectMake(0, 0, Screen_Width, self.contentDetailViewHeight) AndCXContentDetailViewMode:CXWorkCreateDetailViewModeCreate];
    _workCreateDetailView.delegate = self;
    [_theTableHeaderView addSubview:_workCreateDetailView];
    
    self.annexLabel = [[UILabel alloc] init];
    self.annexLabel.text = [NSString stringWithFormat:@"附件："];
    self.annexLabel.backgroundColor = [UIColor clearColor];
    self.annexLabel.textColor = [UIColor blackColor];
    self.annexLabel.textAlignment = NSTextAlignmentLeft;
    self.annexLabel.font = kFontSizeForForm;
    [self.annexLabel sizeToFit];
    self.annexLabel.frame = CGRectMake(kLeftSpace, self.contentDetailViewHeight + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:self.annexLabel];
    
    self.annexView = [[CXOLDERPAnnexView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.annexLabel.frame), self.contentDetailViewHeight, Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace, kCellHeight) AndViewWidth:Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace];
    self.annexView.vc = self;
    [_theTableHeaderView addSubview:self.annexView];
    
    self.thirdLineView = [[UIView alloc] init];
    self.thirdLineView.frame = CGRectMake(0, self.contentDetailViewHeight + kCellHeight + 1, Screen_Width, 1);
    self.thirdLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [_theTableHeaderView addSubview:self.thirdLineView];
    
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
    if(self.workCreateDetailView.theContentText == nil || [self.workCreateDetailView.theContentText length] <= 0){
        TTAlert(@"请填写内容");
        return;
    }
    if([self.workCreateDetailView.theContentText length] > 140){
        TTAlert(@"内容最多140字");
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
                selectContactViewController.type = CXYunJingType;
                selectContactViewController.AllAnnexDataArray = weakSelf.annexView.AllAnnexDataArray;
                
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setValue:weakSelf.workCreateDetailView.theContentText forKey:@"remark"];
                
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
                
                [weakSelf.navigationController pushViewController:selectContactViewController animated:YES];
                if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
        selectContactViewController.type = CXYunJingType;
        selectContactViewController.AllAnnexDataArray = self.annexView.AllAnnexDataArray;
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:self.workCreateDetailView.theContentText forKey:@"remark"];
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
    
    self.datePicker.selectCallBackModeDate2 = ^(NSString* time) {
        //将字符串时间转为nsdate类型
        timeLabel.text = time;
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
    self.annexLabel.frame = CGRectMake(kLeftSpace, self.contentDetailViewHeight + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    self.annexView.frame = CGRectMake(CGRectGetMaxX(self.annexLabel.frame)+ kLeftSpace, self.contentDetailViewHeight, Screen_Width, kCellHeight);
    self.thirdLineView.frame = CGRectMake(0, self.contentDetailViewHeight + kCellHeight + 1, Screen_Width, 1);
    self.thirdLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kCellHeight + self.contentDetailViewHeight + 1);;
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
