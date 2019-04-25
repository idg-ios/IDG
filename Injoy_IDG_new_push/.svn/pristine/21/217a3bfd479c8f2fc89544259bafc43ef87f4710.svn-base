//
//  CXCooperationPromotionViewController.m
//  InjoyERP
//
//  Created by wtz on 2017/5/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXCooperationPromotionViewController.h"
#import "UIView+Category.h"
#import "CXLabelTextView.h"
#import "SDCustomDatePicker2.h"
#import "CXWorkCreateDetailView.h"
#import "CXOLDERPAnnexView.h"
#import "CXSelectContactViewController.h"
#import "CXChooseIndustryView.h"
#import "HttpTool.h"

#define kLeftSpace kFormViewMargin

@interface CXCooperationPromotionViewController ()<UITableViewDelegate, UITableViewDataSource,CXWorkCreateDetailViewReloadHeightDelegate>

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
/** 选择行业视图 */
@property(nonatomic, strong) CXChooseIndustryView * chooseIndustryView;
/** 附件视图 */
@property(nonatomic, strong) CXOLDERPAnnexView *annexView;
/** 内容视图高度 */
@property(nonatomic) CGFloat contentDetailViewHeight;

@property(nonatomic, strong) UILabel * annexLabel;

@property(nonatomic, strong) UIView * thirdLineView;

//发送的附件数组
@property (nonatomic, strong) NSMutableArray * sendAnnexDataArray;
//发送图片声音
@property (nonatomic, strong) NSMutableDictionary * ImageVoiceFileDict;

@property (nonatomic, strong) NSMutableArray * annex;

@end

@implementation CXCooperationPromotionViewController

#pragma mark - 选择器  日期
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
    
    self.annex = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setupView];
}


- (void)setupView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"合作推广")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"发送" addTarget:self action:@selector(sendBtnClick)];
    
    self.contentDetailViewHeight = kCellHeight;
    
    /** UITableView */
    _theTableHeaderView = [[UIView alloc] init];
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, 3*kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + 3);
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
    
    _workCreateDetailView= [[CXWorkCreateDetailView alloc] initWithTitle:@"内容：" andFrame:CGRectMake(0, CGRectGetMaxY(secondLineView.frame), Screen_Width, self.contentDetailViewHeight) AndCXContentDetailViewMode:CXWorkCreateDetailViewModeCreate];
    _workCreateDetailView.delegate = self;
    [_theTableHeaderView addSubview:_workCreateDetailView];
    
    
    self.chooseIndustryView = [[CXChooseIndustryView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_workCreateDetailView.frame), Screen_Width, 3*kCellHeight+1)];
    [_theTableHeaderView addSubview:self.chooseIndustryView];
    
    self.annexLabel = [[UILabel alloc] init];
    self.annexLabel.text = [NSString stringWithFormat:@"附件："];
    self.annexLabel.backgroundColor = [UIColor clearColor];
    self.annexLabel.textColor = [UIColor blackColor];
    self.annexLabel.textAlignment = NSTextAlignmentLeft;
    self.annexLabel.font = kFontSizeForForm;
    [self.annexLabel sizeToFit];
    self.annexLabel.frame = CGRectMake(kLeftSpace, kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    [_theTableHeaderView addSubview:self.annexLabel];
    
    self.annexView = [[CXOLDERPAnnexView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.annexLabel.frame), kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1, Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace, kCellHeight) AndViewWidth:Screen_Width - CGRectGetMaxX(self.annexLabel.frame) - kLeftSpace AndIsOnlyPicture:YES];
    self.annexView.vc = self;
    [_theTableHeaderView addSubview:self.annexView];
    
    self.thirdLineView = [[UIView alloc] init];
    self.thirdLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + kCellHeight + 1, Screen_Width, 1);
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

-(void)deleteAnnex
{
    //将已有的数据取出  传给服务器删除
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableString *names = [NSMutableString stringWithString:@""];
    if (self.annex.count)
    {
        
        for (NSDictionary*dic in _annex)
        {
            [names appendString:dic[@"name"]];
            [names appendString:@","];
        }
        names.length>=1?[names replaceCharactersInRange:NSMakeRange(names.length-1, 1) withString:@""]:[names appendString:@""];
        
        [self.annex removeAllObjects];
        
    }
    
    [HttpTool deleteWithPath:[NSString stringWithFormat:@"%@/annex",urlPrefix] params:params success:^(id JSON){
        
    }failure:^(NSError *error){
        //        TTAlert(KNetworkFailRemind);
    }];
}

#pragma mark -- 获取当前创建时间
-(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

//检测字节数
- (int)LengthOfNSString:(NSString*)str
{
    int nIndex=0;
    for(int i=0;i<[str length];i++){
        if ([str characterAtIndex:i]<256) {
            nIndex=nIndex+1;
        }
        else
            nIndex=nIndex+2;
    }
    return nIndex;
}


- (void)sendBtnClick
{
    if(self.titleContentLabel.text == nil || [self.titleContentLabel.text length] <= 0){
        TTAlert(@"请填写标题");
        return;
    }
    if([self LengthOfNSString:self.titleContentLabel.text] > 26){
        [self.view makeToast:@"标题最大长度为13个汉字，您输入的标题超出长度限制，请重新输入" duration:2 position:@"center"];
        return;
    }
    if(self.workCreateDetailView.theContentText == nil || [self.workCreateDetailView.theContentText length] <= 0){
        TTAlert(@"请填写内容");
        return;
    }
    if([self LengthOfNSString:self.workCreateDetailView.theContentText] > 500){
        [self.view makeToast:@"内容最大长度为250个汉字，您输入的内容超出长度限制，请重新输入" duration:2 position:@"center"];
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
                for (NSDictionary *dic in JSON[@"data"]) {
                    [_annex addObject:dic];
                }
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setValue:self.titleContentLabel.text forKey:@"name"];
                [params setValue:self.workCreateDetailView.theContentText forKey:@"remark"];
                [params setValue:@(44) forKey:@"type"];
                NSString *url = [NSString stringWithFormat:@"%@extension/saveExtension",urlPrefix];
                
                NSData *data;
                if (_annex.count)
                {
                    data = [NSJSONSerialization dataWithJSONObject:_annex options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *annexList= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    [params setValue:annexList forKey:@"annex"];
                }
                
                [HttpTool multipartPostFileDataWithPath:url params:params dataAry:nil success:^(id JSON) {
                    [weakSelf hideHud];
                    NSDictionary *jsonDict = JSON;
                    if ([jsonDict[@"status"] integerValue] == 200) {
                        TTAlert([NSString stringWithFormat:@"推广成功!本月剩余发送次数:%zd次。",[JSON[@"data"] integerValue]]);
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        TTAlert(JSON[@"msg"]);
                    }
                } failure:^(NSError *error) {
                    [weakSelf hideHud];
                    CXAlert(KNetworkFailRemind);
                }];
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
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:self.titleContentLabel.text forKey:@"name"];
        [params setValue:self.workCreateDetailView.theContentText forKey:@"remark"];
        [params setValue:@(44) forKey:@"type"];
        NSString *url = [NSString stringWithFormat:@"%@extension/saveExtension",urlPrefix];
        __weak __typeof(self)weakSelf = self;
        [self showHudInView:self.view hint:nil];
        [HttpTool multipartPostFileDataWithPath:url params:params dataAry:self.annexView.AllAnnexDataArray success:^(id JSON) {
            [weakSelf hideHud];
            NSDictionary *jsonDict = JSON;
            if ([jsonDict[@"status"] integerValue] == 200) {
                TTAlert([NSString stringWithFormat:@"推广成功!本月剩余发送次数:%zd次。",[JSON[@"data"] integerValue]]);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            CXAlert(KNetworkFailRemind);
        }];
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
    self.chooseIndustryView.frame = CGRectMake(0, CGRectGetMaxY(_workCreateDetailView.frame), Screen_Width, 3*kCellHeight + 1);
    self.annexLabel.frame = CGRectMake(kLeftSpace, kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + (kCellHeight - kFontSizeValueForForm)/2, self.annexLabel.size.width, kFontSizeValueForForm);
    self.annexView.frame = CGRectMake(CGRectGetMaxX(self.annexLabel.frame)+ kLeftSpace, kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1, Screen_Width, kCellHeight);
    self.thirdLineView.frame = CGRectMake(0, kCellHeight + 1 + kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + kCellHeight + 1, Screen_Width, 1);
    self.thirdLineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width, 3*kCellHeight + self.contentDetailViewHeight + 3*kCellHeight + 1 + 3);;
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
