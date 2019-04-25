//
//  CXTMTPotentialProjectDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/27.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXTMTPotentialProjectDetailViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "HttpTool.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "CXApprovalPersonModel.h"
#import "CXTMTPotentialProjectDetailModel.h"
#import "UIView+CXCategory.h"
#import "CXYMNormalListCell.h"
#import "CXYMAppearanceManager.h"
#import "ActionSheetDatePicker.h"
#import "CXYMActionSheetView.h"

@interface CXTMTPotentialProjectDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

#define kLabelLeftSpace 16.0
#define kLabelTopSpace 16.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kBusinessLabelFontSize 14.0
#define kBusinessLabelTextColor RGBACOLOR(119.0, 119.0, 119.0, 1.0)

/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** basicInformationModel */
@property(strong, nonatomic) CXTMTPotentialProjectDetailModel * potentialProjectDetailModel;
/** jbzlTitleLabel */
@property (nonatomic, strong) UILabel * jbzlTitleLabel;
/** 项目名称 */
@property(strong, nonatomic) CXEditLabel *xmmcLabel;
/** 行业 */
@property(strong, nonatomic) CXEditLabel *hyLabel;
/** 投资机构 */
@property(strong, nonatomic) CXEditLabel *tzjgLabel;
/** 城市 */
@property(strong, nonatomic) CXEditLabel *gjrLabel;
/** 轮次 */
@property(strong, nonatomic) CXEditLabel *fkLabel;
/** 融资时间 */
@property(strong, nonatomic) CXEditLabel *lyLabel;
/** 融资额 */
@property(strong, nonatomic) CXEditLabel *rzeLabel;
/** ywjsTitleLabel */
@property (nonatomic, strong) UILabel * ywjsTitleLabel;
/** ywjsContentLabel */
@property (nonatomic, strong) UILabel * ywjsContentLabel;
/** qqrzTitleLabel */
@property (nonatomic, strong) UILabel * qqrzTitleLabel;
/** qqrzContentLabel */
@property (nonatomic, strong) UILabel * qqrzContentLabel;
/** xmtdTitleLabel */
@property (nonatomic, strong) UILabel * xmtdTitleLabel;
/** xmtdContentLabel */
@property (nonatomic, strong) UILabel * xmtdContentLabel;

/** line_7 */
@property (nonatomic, strong) UIView *line_7;
/** line_8 */
@property (nonatomic, strong) UIView *line_8;
/** line_9 */
@property (nonatomic, strong) UIView *line_9;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end

static NSString *const basicInfoCellIdentity = @"basicInfoCellIdentity";
static NSString *const textCellIdentity = @"textCellIdentity";
@implementation CXTMTPotentialProjectDetailViewController

#pragma mark - getter & setter
- (NSMutableArray *)contentArray{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (NSArray *)titleArray{
    if (_titleArray == nil){
        _titleArray = @[@"项目名称",@"行业",@"投资机构",@"城市",@"轮次",@"融资时间",@"融资额",];
        
    }
    return _titleArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc ] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:textCellIdentity];
        [_tableView registerClass:[CXYMNormalListCell class] forCellReuseIdentifier:basicInfoCellIdentity];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = SDBackGroudColor;
    }
    return _tableView;
}
#define kTextColor [UIColor blackColor]

- (CXTMTPotentialProjectDetailModel *)potentialProjectDetailModel{
    if(!_potentialProjectDetailModel){
        _potentialProjectDetailModel = [[CXTMTPotentialProjectDetailModel alloc] init];
    }
    return _potentialProjectDetailModel;
}

- (CXTMTPotentialProjectListModel *)model {
    if (!_model) {
        _model = [[CXTMTPotentialProjectListModel alloc] init];
    }
    return _model;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = SDBackGroudColor;
//        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpNavBar];
    self.scrollContentView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    [self setUpScrollView];
    [self findDetailRequest];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *sectionTitleArray = @[@"基本资料",@"业务介绍",@"前期融资",@"项目团队"];
    UIView *herder = [[UIView alloc] initWithFrame:CGRectZero];
    herder.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor yy_colorWithHexString:@"#333333"];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = sectionTitleArray[section];
    [herder addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.right.mas_equalTo(0);
    }];
    return herder;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.titleArray.count : 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        NSString *content = self.contentArray.count > 0 ? self.contentArray[indexPath.row] : @"";
        CGFloat height = [content boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [CXYMAppearanceManager textNormalFont]} context:nil].size.height;
        return height > 40 ? height : 40;
    }else if(indexPath.section == 1){
        return [self cellHeightWithText:self.potentialProjectDetailModel.zhDesc];
    }else if(indexPath.section == 2){
        return [self cellHeightWithText:self.potentialProjectDetailModel.pastFinancing];
    }else if(indexPath.section == 3){
        return [self cellHeightWithText:self.potentialProjectDetailModel.teamDesc];
    }else{
        return 0;
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = SDBackGroudColor;
    return footer;
}
- (CGFloat )cellHeightWithText:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(Screen_Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [CXYMAppearanceManager textNormalFont]} context:nil];
    return rect.size.height + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CXYMNormalListCell *cell = [tableView dequeueReusableCellWithIdentifier:basicInfoCellIdentity forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.contentLabel.numberOfLines = 0;
        if (self.contentArray.count > 0){
            cell.contentLabel.text = self.contentArray[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentity forIndexPath:indexPath];
        NSString *content;
        if (indexPath.section == 1) {
            content = self.potentialProjectDetailModel.zhDesc;
        } else if (indexPath.section == 2){
            content = self.potentialProjectDetailModel.pastFinancing;
        }else{
            content = self.potentialProjectDetailModel.teamDesc;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = content;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [CXYMAppearanceManager textNormalFont];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return;
    CXYMActionSheetView *actionSheet = [[CXYMActionSheetView alloc] initWithTitle:@"标题的文本内容" sheetArray:@[@"香蕉",@"苹果",@"橘子",@"芒果",@"桂圆",@"什么都没有"]];
    [actionSheet show];
    actionSheet.block = ^(NSInteger index, NSString *title) {
        NSLog(@"selected index = %ld,title = %@",index,title);
    } ;
    
    return;//下面测试浮选界面
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"请选择时间" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSLog(@"选择的时间是%@",selectedDate);
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
//    datePicker.toolbarButtonsColor = [UIColor redColor];
    [datePicker showActionSheetPicker];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.model.projName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}
- (UILabel *)setupLabel:(UILabel *)label linkLabel:(CXEditLabel *)linkLabel{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textColor = [UIColor yy_colorWithHexString:@""];
    newLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollContentView addSubview:newLabel];
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo( 100);
    }];
    return newLabel;
}
- (void)setUpScrollView {
    _scrollContentView.backgroundColor = [UIColor whiteColor];
    /// 左边距
    CGFloat leftMargin = 16.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 10.f;
    CGFloat lineWidth = Screen_Width;
    
    _jbzlTitleLabel = [[UILabel alloc] init];
    _jbzlTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    _jbzlTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
    _jbzlTitleLabel.numberOfLines = 0;
    _jbzlTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _jbzlTitleLabel.backgroundColor = [UIColor clearColor];
    _jbzlTitleLabel.textAlignment = NSTextAlignmentLeft;
    _jbzlTitleLabel.text = @"基本资料";
    CGSize jbzlTitleLabelSize = [_jbzlTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _jbzlTitleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, Screen_Width - kLabelLeftSpace, jbzlTitleLabelSize.height);
    [self.scrollContentView addSubview:_jbzlTitleLabel];
    
    //项目名称
    _xmmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, _jbzlTitleLabel.bottom, Screen_Width - leftMargin, viewHeight)];
    _xmmcLabel.title = @"项目名称：";
    _xmmcLabel.allowEditing = NO;
    _xmmcLabel.textColor = kTextColor;
    _xmmcLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_xmmcLabel];
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _xmmcLabel.bottom, lineWidth, lineHeight);
    
    //行业
    _hyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _hyLabel.title = @"行　　业：";
    _hyLabel.textColor = kTextColor;
    _hyLabel.allowEditing = NO;
    _hyLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_hyLabel];
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _hyLabel.bottom, lineWidth, lineHeight);
    
    //投资机构
    _tzjgLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _tzjgLabel.title = @"投资机构：";
    _tzjgLabel.textColor = kTextColor;
    _tzjgLabel.allowEditing = NO;
    _tzjgLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_tzjgLabel];
    
    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _tzjgLabel.bottom, lineWidth, lineHeight);
    
    //城市
    _gjrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
    _gjrLabel.title = @"城　　市：";
    _gjrLabel.textColor = kTextColor;
    _gjrLabel.allowEditing = NO;
    _gjrLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_gjrLabel];
    
    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = CGRectMake(0.f, _gjrLabel.bottom, lineWidth, lineHeight);
    
    //轮次
    _fkLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
    _fkLabel.title = @"轮　　次：";
    _fkLabel.textColor = kTextColor;
    _fkLabel.allowEditing = NO;
    _fkLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_fkLabel];
    
    // line_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = CGRectMake(0.f, _fkLabel.bottom, lineWidth, lineHeight);
    
    //融资时间
    _lyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
    _lyLabel.title = @"融资时间：";
    _lyLabel.textColor = kTextColor;
    _lyLabel.allowEditing = NO;
    _lyLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_lyLabel];
    
    // line_6
    UIView *line_6 = [self createFormSeperatorLine];
    line_6.frame = CGRectMake(0.f, _lyLabel.bottom, lineWidth, lineHeight);
    
    //融资额
    _rzeLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
    _rzeLabel.title = @"融 资 额：";
    _rzeLabel.textColor = kTextColor;
    _rzeLabel.allowEditing = NO;
    _rzeLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_rzeLabel];
    
    // line_7
    _line_7 = [self createFormSeperatorLine];
    _line_7.frame = CGRectMake(0.f, _rzeLabel.bottom, lineWidth, lineBoldHeight);
    
    _ywjsTitleLabel = [[UILabel alloc] init];
    _ywjsTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    _ywjsTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
    _ywjsTitleLabel.numberOfLines = 0;
    _ywjsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsTitleLabel.backgroundColor = [UIColor clearColor];
    _ywjsTitleLabel.textAlignment = NSTextAlignmentLeft;
    _ywjsTitleLabel.text = @"业务介绍";
    CGSize ywjsTitleLabelSize = [_ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _ywjsTitleLabel.frame = CGRectMake(leftMargin, _line_7.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, ywjsTitleLabelSize.height);
    [self.scrollContentView addSubview:_ywjsTitleLabel];
    
    _ywjsContentLabel = [[UILabel alloc] init];
    _ywjsContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
    _ywjsContentLabel.numberOfLines = 0;
    _ywjsContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsContentLabel.backgroundColor = [UIColor clearColor];
    _ywjsContentLabel.textAlignment = NSTextAlignmentLeft;
    CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    [self.scrollContentView addSubview:_ywjsContentLabel];
    
//    // line_8
//    _line_8 = [self createFormSeperatorLine];
//    _line_8.frame = CGRectMake(0.f, _ywjsContentLabel.bottom, lineWidth, lineBoldHeight);
//
//    _qqrzTitleLabel = [[UILabel alloc] init];
//    _qqrzTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
//    _qqrzTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
//    _qqrzTitleLabel.numberOfLines = 0;
//    _qqrzTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _qqrzTitleLabel.backgroundColor = [UIColor clearColor];
//    _qqrzTitleLabel.textAlignment = NSTextAlignmentLeft;
//    _qqrzTitleLabel.text = @"前期融资";
//    CGSize qqrzTitleLabelSize = [_qqrzTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
//    _qqrzTitleLabel.frame = CGRectMake(leftMargin, _line_8.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, qqrzTitleLabelSize.height);
//    [self.scrollContentView addSubview:_qqrzTitleLabel];
//
//    _qqrzContentLabel = [[UILabel alloc] init];
//    _qqrzContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
//    _qqrzContentLabel.textColor = kOpinionTypeNameLabelTextColor;
//    _qqrzContentLabel.numberOfLines = 0;
//    _qqrzContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _qqrzContentLabel.backgroundColor = [UIColor clearColor];
//    _qqrzContentLabel.textAlignment = NSTextAlignmentLeft;
//    CGSize qqrzContentLabelSize = [_qqrzContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
//    _qqrzContentLabel.frame = CGRectMake(leftMargin, _qqrzTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, qqrzContentLabelSize.height);
//    [self.scrollContentView addSubview:_qqrzContentLabel];
//
//    // line_9
//    _line_9 = [self createFormSeperatorLine];
//    _line_9.frame = CGRectMake(0.f, _qqrzContentLabel.bottom, lineWidth, lineBoldHeight);
//
//    _xmtdTitleLabel = [[UILabel alloc] init];
//    _xmtdTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
//    _xmtdTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
//    _xmtdTitleLabel.numberOfLines = 0;
//    _xmtdTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _xmtdTitleLabel.backgroundColor = [UIColor clearColor];
//    _xmtdTitleLabel.textAlignment = NSTextAlignmentLeft;
//    _xmtdTitleLabel.text = @"项目团队";
//    CGSize xmtdTitleLabelSize = [_xmtdTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
//    _xmtdTitleLabel.frame = CGRectMake(leftMargin, _line_9.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, xmtdTitleLabelSize.height);
//    [self.scrollContentView addSubview:_xmtdTitleLabel];
//
//    _xmtdContentLabel = [[UILabel alloc] init];
//    _xmtdContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
//    _xmtdContentLabel.textColor = kOpinionTypeNameLabelTextColor;
//    _xmtdContentLabel.numberOfLines = 0;
//    _xmtdContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _xmtdContentLabel.backgroundColor = [UIColor clearColor];
//    _xmtdContentLabel.textAlignment = NSTextAlignmentLeft;
//    CGSize xmtdContentLabelSize = [_xmtdContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
//    _xmtdContentLabel.frame = CGRectMake(leftMargin, _xmtdTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, xmtdContentLabelSize.height);
//    [self.scrollContentView addSubview:_xmtdContentLabel];
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _ywjsContentLabel.bottom + kLabelTopSpace);
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SDBackGroudColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)setUpDetail {
    _xmmcLabel.content = self.potentialProjectDetailModel.projName;
    _xmmcLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];
    
    _hyLabel.content = self.potentialProjectDetailModel.indu;
    _hyLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _tzjgLabel.content = self.potentialProjectDetailModel.investGroup;
    _tzjgLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _gjrLabel.content = self.potentialProjectDetailModel.followUpPersonName;
    _gjrLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _fkLabel.content = self.potentialProjectDetailModel.feedback;
    _fkLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _lyLabel.content = self.potentialProjectDetailModel.domain;
    _lyLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _rzeLabel.content = self.potentialProjectDetailModel.money;
    _rzeLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _ywjsContentLabel.text = self.potentialProjectDetailModel.zhDesc;
    _ywjsContentLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _qqrzContentLabel.text = self.potentialProjectDetailModel.pastFinancing;
    _qqrzContentLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];

    _xmtdContentLabel.text = self.potentialProjectDetailModel.teamDesc;
    _xmtdContentLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];
    
    /// 左边距
    CGFloat leftMargin = 16.0f;
    CGFloat lineBoldHeight = 10.f;
    CGFloat lineWidth = Screen_Width;
    
    CGSize ywjsTitleLabelSize = [_ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _ywjsTitleLabel.frame = CGRectMake(leftMargin, _line_7.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, ywjsTitleLabelSize.height);
    
    CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    
    // _line_8
    if(_line_8){
        [_line_8 removeFromSuperview];
        _line_8 = nil;
    }
    _line_8 = [self createFormSeperatorLine];
    _line_8.frame = CGRectMake(0.f, _ywjsContentLabel.bottom + kLabelTopSpace, lineWidth, lineBoldHeight);
    
    CGSize qqrzTitleLabelSize = [_qqrzTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _qqrzTitleLabel.frame = CGRectMake(leftMargin, _line_8.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, qqrzTitleLabelSize.height);
    
    CGSize qqrzContentLabelSize = [_qqrzContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _qqrzContentLabel.frame = CGRectMake(leftMargin, _qqrzTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, qqrzContentLabelSize.height);
    
    // _line_9
    if(_line_9){
        [_line_9 removeFromSuperview];
        _line_9 = nil;
    }
    _line_9 = [self createFormSeperatorLine];
    _line_9.frame = CGRectMake(0.f, _qqrzContentLabel.bottom + kLabelTopSpace, lineWidth, lineBoldHeight);
    
    CGSize xmtdTitleLabelSize = [_xmtdTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _xmtdTitleLabel.frame = CGRectMake(leftMargin, _line_9.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, xmtdTitleLabelSize.height);
    
    CGSize xmtdContentLabelSize = [_xmtdContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _xmtdContentLabel.frame = CGRectMake(leftMargin, _xmtdTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, xmtdContentLabelSize.height);
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _ywjsContentLabel.bottom + kLabelTopSpace);
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/tmt/detail/%zd", urlPrefix,[self.model.projId integerValue]];
    HUD_SHOW(nil);
    [HttpTool postWithPath:url params:nil success:^(id JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.potentialProjectDetailModel = [CXTMTPotentialProjectDetailModel yy_modelWithDictionary:JSON[@"data"]];
            [self setUpDetail];
            //数据源
            [self.contentArray addObject:self.potentialProjectDetailModel.projName ? : @" "];
            [self.contentArray addObject:self.potentialProjectDetailModel.indu ? : @" "];
            [self.contentArray addObject:self.potentialProjectDetailModel.investGroup ? : @" "];
            [self.contentArray addObject:self.potentialProjectDetailModel.followUpPersonName ? : @" "];
            [self.contentArray addObject:self.potentialProjectDetailModel.feedback ? : @" " ];
            [self.contentArray addObject:self.potentialProjectDetailModel.domain ? : @" "];
            [self.contentArray addObject:self.potentialProjectDetailModel.money ? : @" "];

            [self.tableView reloadData];
        }
        else if([JSON[@"status"] intValue] == 400){
                  [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
