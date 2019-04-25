//
//  CXMetProjectDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXMetProjectDetailViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "UIView+CXCategory.h"
#import "CXPEPotentialProjectModel.h"
#import "MJRefresh.h"
#import "CXPotentialFollowListModel.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXPotentialFollowListTableViewCell.h"
#import "CXAddPEPotentialProjectViewController.h"
#import "CXAddPotentialFollowViewController.h"
#import "CXIDGPEPotentialProjectViewController.h"
#import "CXPotentialBaseInfoView.h"
#import "CXPotentialFooterView.h"
#import "CXAddPEPotentialProjectViewController.h"
#import "CXYMAppearanceManager.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXMetProjectDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@property(nonatomic, strong) CXPEPotentialProjectModel * model;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXPotentialFollowListModel *> *dataSourceArr;

/** jbzlTitleLabel */
@property (nonatomic, strong) UILabel * jbzlTitleLabel;
/** editImageView */
@property (nonatomic, strong) UIImageView * editImageView;
/** editBtn */
@property (nonatomic, strong) UIButton * editBtn;
/** 项目名称 */
@property(strong, nonatomic) CXEditLabel *xmmcLabel;
/** 当前轮次 */
@property(strong, nonatomic) CXEditLabel *dqlcLabel;
/** 约见状态 */
@property(strong, nonatomic) CXEditLabel *yjztLabel;
/** 行业 */
@property(strong, nonatomic) CXEditLabel *hyLabel;
/** 投资机构 */
@property(strong, nonatomic) CXEditLabel *tzjgLabel;
/** 城市 */
@property(strong, nonatomic) CXEditLabel *csLabel;
/** 跟进状态 */
@property(strong, nonatomic) CXEditLabel *gjztLabel;
/** 接触时间 */
@property(strong, nonatomic) CXEditLabel *jcsjLabel;
/** 负责人 */
@property(strong, nonatomic) CXEditLabel *fzrLabel;
/** IDG投资情况 */
@property(strong, nonatomic) CXEditLabel *IDGtzqkLabel;
/** 重点项目 */
@property(strong, nonatomic) CXEditLabel *zdxmLabel;
/** ywjsTitleLabel */
@property (nonatomic, strong) UILabel * ywjsTitleLabel;
/** ywjsContentLabel */
@property (nonatomic, strong) UILabel * ywjsContentLabel;
/** 数据源：行业 */
@property (nonatomic, copy) NSArray<NSString *> *industryList;
/** ywjsTitleButton */
@property (nonatomic, strong) UIButton * ywjsTitleButton;
/** ywjsContentButton */
@property (nonatomic, strong) UIButton * ywjsContentButton;
/** gjqkTitleLabel */
@property (nonatomic, strong) UILabel * gjqkTitleLabel;
/** extendImageView */
@property (nonatomic, strong) UIImageView * extendImageView;
/** extendBtn */
@property (nonatomic, strong) UIButton * extendBtn;
/** isExtend */
@property (nonatomic) BOOL isExtend;
/** addImageView */
@property (nonatomic, strong) UIImageView * addImageView;
/** addBtn */
@property (nonatomic, strong) UIButton * addBtn;


@property (nonatomic, strong) UIView * scrollContentView;

@property (nonatomic, strong) CXPotentialBaseInfoView *topInfoView;
@property (nonatomic, strong) CXPotentialFooterView *footerView;
@end

static NSString * const CXYMMetProjectDetailCellIdentity = @"CXYMMetProjectDetailCellIdentity";
@implementation CXMetProjectDetailViewController

#define kLabelLeftSpace 10.0
#define kLabelTopSpace 10.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kTextColor [UIColor blackColor]
#define kContentLabelFontSize 16.0

#define uintpx (Screen_Width/375.0)
#define leftMargin 15.f*uintpx
#define topMargin 10.f*uintpx
#define bigTitleHeight 37.f*uintpx
#define kLabelCellHeight 32.f*uintpx
#define kcontentLabelLeftmargin 143.f*uintpx
#define krowHeight (20 * uintpx)
#define rowMargin (6 * uintpx)

- (CXPEPotentialProjectModel *)model {
    if(!_model){
        _model = [[CXPEPotentialProjectModel alloc] init];
    }
    return _model;
}

- (CXPotentialBaseInfoView *)topInfoView{
    if(nil == _topInfoView){
        NSLog(@"业务介绍===%@",self.model.bizDesc);
        CGSize strSize = [self.model.bizDesc boundingRectWithSize:CGSizeMake(Screen_Width - 2 * leftMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;

        _topInfoView = [[CXPotentialBaseInfoView alloc]init];
        if (strSize.height == 0){
            _topInfoView.frame = CGRectMake(0, 0, Screen_Width,topMargin + bigTitleHeight + (krowHeight + rowMargin)*10 + rowMargin + topMargin + bigTitleHeight);
        }else{
        _topInfoView.frame = CGRectMake(0, 0, Screen_Width,topMargin + bigTitleHeight + (krowHeight + rowMargin)*10 + rowMargin + topMargin + bigTitleHeight + strSize.height + topMargin + bigTitleHeight);
        }
        
    }
    return _topInfoView;
}
- (CXPotentialFooterView *)footerView{
    if(nil == _footerView){
        _footerView = [[CXPotentialFooterView alloc]init];
        CXWeakSelf(self)
        _footerView.addFollowAction = ^{
            [weakself addBtnClick];
        };
    }
    return _footerView;
}
- (NSMutableArray<CXPotentialFollowListModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.listModel.projName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popToController)];
}

- (void)popToController{
    [self.navigationController popViewControllerAnimated:YES];//需求变更
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[CXIDGPEPotentialProjectViewController class]]) {
//            CXIDGPEPotentialProjectViewController * aController = (CXIDGPEPotentialProjectViewController *)controller;
//            [self.navigationController popToViewController:aController animated:YES];
//        }
//    }
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [CXYMAppearanceManager appBackgroundColor];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CXPotentialFollowListTableViewCell class] forCellReuseIdentifier:CXYMMetProjectDetailCellIdentity];
    self.tableView.tableHeaderView = self.topInfoView;
    __weak typeof(self) weakSelf = self;
    self.topInfoView.block = ^{
        NSLog(@" self topInfoView block");
        CXAddPEPotentialProjectViewController *addPEPotentialProjectViewController = [[CXAddPEPotentialProjectViewController alloc] init];
        addPEPotentialProjectViewController.model = weakSelf.model;
        addPEPotentialProjectViewController.formType = CXFormTypeModify;
        [weakSelf.navigationController pushViewController:addPEPotentialProjectViewController animated:YES];
    };
 
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    self.isExtend = YES;
    NSLog(@"topInfoView==%@",self.topInfoView);
    NSLog(@"tableView==%@",self.tableView);
    NSLog(@"footerView===%@",self.footerView);

    return;
    /*
    self.scrollContentView = [[UIView alloc] init];
    CXWeakSelf(self)
    _scrollContentView.backgroundColor = [UIColor whiteColor];
    /// 左边距
    CGFloat leftMargin = 10.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 10.f;
    CGFloat lineWidth = Screen_Width;
    /// 宽度
    CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;
    
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
    
    if(_editImageView){
        [_editImageView removeFromSuperview];
        _editImageView = nil;
    }
    _editImageView = [[UIImageView alloc] init];
    _editImageView.image = [UIImage imageNamed:@"EditImg"];
    _editImageView.highlightedImage = [UIImage imageNamed:@"EditImg"];
    _editImageView.frame = CGRectMake(Screen_Width - leftMargin - 19.0, kLabelTopSpace, 19.0, 19.0);
    [self.scrollContentView addSubview:_editImageView];
    
    if(_editBtn){
        [_editBtn removeFromSuperview];
        _editBtn = nil;
    }
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.frame = CGRectMake(Screen_Width - leftMargin - 19.0 - 5.0, kLabelTopSpace - 15.0, 19.0 + 10.0, 19.0 + 20.0);
    [self.scrollContentView addSubview:_editBtn];
    
    //项目名称
    _xmmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, _jbzlTitleLabel.bottom, Screen_Width - leftMargin, viewHeight)];
    _xmmcLabel.title = @"项目名称：";
    _xmmcLabel.allowEditing = NO;
    _xmmcLabel.textColor = kTextColor;
    _xmmcLabel.inputType = CXEditLabelInputTypeText;
    _xmmcLabel.content = self.model.projName;
    _xmmcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        SDRootTopView *rootTopView = [self getRootTopView];
        [rootTopView setNavTitle:editLabel.content];
        self.model.projName = editLabel.content;
    };
    [self.scrollContentView addSubview:_xmmcLabel];
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _xmmcLabel.bottom, lineWidth, lineHeight);
    
    //当前轮次
    _dqlcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _dqlcLabel.title = @"当前轮次：";
    _dqlcLabel.textColor = kTextColor;
    _dqlcLabel.allowEditing = NO;
    _dqlcLabel.content = self.model.invRound;
    _dqlcLabel.inputType = CXEditLabelInputTypeText;
    _dqlcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.invRound = editLabel.content;
    };
    [self.scrollContentView addSubview:_dqlcLabel];
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _dqlcLabel.bottom, lineWidth, lineHeight);
    
    //约见状态
    _yjztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _yjztLabel.title = @"约见状态：";
    _yjztLabel.textColor = kTextColor;
    _yjztLabel.inputType = CXEditLabelInputTypeCustomPicker;
    _yjztLabel.pickerTextArray = @[@"未约见",@"已约见"];
    _yjztLabel.pickerValueArray = @[@"unDate",@"date"];
    _yjztLabel.allowEditing = YES;
    _yjztLabel.showDropdown = YES;
    if([self.model.invContactStatus isEqualToString:@"unDate"]){
        _yjztLabel.content = @"未约见";
    }else if([self.model.invContactStatus isEqualToString:@"date"]){
        _yjztLabel.content = @"已约见";
    }
    if([self.model.invContactStatus isEqualToString:@"unDate"]){
        _yjztLabel.selectedPickerData = @{
                                          CXEditLabelCustomPickerTextKey : @"未约见",
                                          CXEditLabelCustomPickerValueKey : @"unDate"
                                          };
    }else if([self.model.invContactStatus isEqualToString:@"date"]){
        _yjztLabel.selectedPickerData = @{
                                          CXEditLabelCustomPickerTextKey : @"已约见",
                                          CXEditLabelCustomPickerValueKey : @"date"
                                          };
    }
    _yjztLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        if([editLabel.content isEqualToString:@"未约见"]){
            NSString *url = [NSString stringWithFormat:@"%@project/potential/contactstatus/update", urlPrefix];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setValue:@"unDate" forKey:@"invContactStatus"];
            [params setValue:self.model.projId forKey:@"eid"];
            [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                    [mainWindow makeToast:@"修改成功!" duration:3.0 position:@"center"];
                    self.yjztLabel.selectedPickerData = @{
                                                          CXEditLabelCustomPickerTextKey : @"未约见",
                                                          CXEditLabelCustomPickerValueKey : @"unDate"
                                                          };
                    self.model.invContactStatus = @"unDate";
                } else {
                    self.yjztLabel.content = @"已约见";
                    self.yjztLabel.selectedPickerData = @{
                                                          CXEditLabelCustomPickerTextKey : @"已约见",
                                                          CXEditLabelCustomPickerValueKey : @"date"
                                                          };
                    self.model.invContactStatus = @"date";
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        }else if([editLabel.content isEqualToString:@"已约见"]){
            NSString *url = [NSString stringWithFormat:@"%@project/potential/contactstatus/update", urlPrefix];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setValue:@"date" forKey:@"invContactStatus"];
            [params setValue:self.model.projId forKey:@"eid"];
            [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                    [mainWindow makeToast:@"修改成功!" duration:3.0 position:@"center"];
                    self.yjztLabel.selectedPickerData = @{
                                                          CXEditLabelCustomPickerTextKey : @"已约见",
                                                          CXEditLabelCustomPickerValueKey : @"date"
                                                          };
                    self.model.invContactStatus = @"date";
                } else {
                    self.yjztLabel.content = @"未约见";
                    self.yjztLabel.selectedPickerData = @{
                                                          CXEditLabelCustomPickerTextKey : @"未约见",
                                                          CXEditLabelCustomPickerValueKey : @"unDate"
                                                          };
                    self.model.invContactStatus = @"unDate";
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        }
    };
    [self.scrollContentView addSubview:_yjztLabel];
    
    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _yjztLabel.bottom, lineWidth, lineHeight);
    
    //行业
    _hyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
    _hyLabel.title = @"行　　业：";
    _hyLabel.inputType = CXEditLabelInputTypeCustomPicker;
    _hyLabel.textColor = kTextColor;
    _hyLabel.allowEditing = NO;
    _hyLabel.showDropdown = NO;
    _hyLabel.pickerTextArray = self.industryList;
    _hyLabel.pickerValueArray = self.industryList;
    _hyLabel.content = self.model.comIndus;
    _hyLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.comIndus = editLabel.content;
    };
    [self.scrollContentView addSubview:_hyLabel];
    
    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = CGRectMake(0.f, _hyLabel.bottom, lineWidth, lineHeight);
    
    //投资机构
    _tzjgLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
    _tzjgLabel.title = @"投资机构：";
    _tzjgLabel.textColor = kTextColor;
    _tzjgLabel.allowEditing = NO;
    _tzjgLabel.inputType = CXEditLabelInputTypeText;
    _tzjgLabel.content = self.model.invGroup;
    _tzjgLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.invGroup = editLabel.content;
    };
    [self.scrollContentView addSubview:_tzjgLabel];
    
    // line_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = CGRectMake(0.f, _tzjgLabel.bottom, lineWidth, lineHeight);
    
    //城市
    _csLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
    _csLabel.title = @"城　　市：";
    _csLabel.textColor = kTextColor;
    _csLabel.allowEditing = NO;
    _csLabel.inputType = CXEditLabelInputTypeText;
    _csLabel.content = self.model.region;
    _csLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.region = editLabel.content;
    };
    [self.scrollContentView addSubview:_csLabel];
    
    // line_6
    UIView *line_6 = [self createFormSeperatorLine];
    line_6.frame = CGRectMake(0.f, _csLabel.bottom, lineWidth, lineHeight);
    
    //跟进状态
    _gjztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
    _gjztLabel.title = @"跟进状态：";
    _gjztLabel.textColor = kTextColor;
    _gjztLabel.allowEditing = NO;
    _gjztLabel.inputType = CXEditLabelInputTypeText;
    if([self.model.invFlowUp isEqualToString:@"flowUp"]){
        _gjztLabel.content = @"继续跟进";
    }else if([self.model.invFlowUp isEqualToString:@"abandon"]){
        _gjztLabel.content = @"放弃";
    }else if([self.model.invFlowUp isEqualToString:@"WS"]){
        _gjztLabel.content = @"观望";
    }
    _gjztLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.invFlowUp = editLabel.content;
    };
    [self.scrollContentView addSubview:_gjztLabel];
    
    // line_7
    UIView *line_7 = [self createFormSeperatorLine];
    line_7.frame = CGRectMake(0.f, _gjztLabel.bottom, lineWidth, lineHeight);
    
    //接触时间
    _jcsjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_7.bottom, Screen_Width - leftMargin, viewHeight)];
    _jcsjLabel.inputType = CXEditLabelInputTypeDate;
    _jcsjLabel.title = @"接触时间：";
    _jcsjLabel.textColor = kTextColor;
    _jcsjLabel.allowEditing = NO;
    _jcsjLabel.showDropdown = NO;
    _jcsjLabel.content = self.model.invDate;
    _jcsjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.invDate = editLabel.content;
    };
    [self.scrollContentView addSubview:_jcsjLabel];
    
    // line_8
    UIView *line_8 = [self createFormSeperatorLine];
    line_8.frame = CGRectMake(0.f, _jcsjLabel.bottom, lineWidth, lineHeight);
    
    //负责人
    _fzrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - leftMargin, viewHeight)];
    _fzrLabel.title = @"负责人：";
    _fzrLabel.textColor = kTextColor;
    _fzrLabel.allowEditing = NO;
    _fzrLabel.showDropdown = NO;
    _fzrLabel.inputType = CXEditLabelInputTypeDate;
    _fzrLabel.content = self.model.userName;
    [self.scrollContentView addSubview:_fzrLabel];
    
    // line_9
    UIView *line_9 = [self createFormSeperatorLine];
    line_9.frame = CGRectMake(0.f, _fzrLabel.bottom, lineWidth, lineHeight);
    
    //IDG投资情况
    _IDGtzqkLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_9.bottom, Screen_Width - leftMargin, viewHeight)];
    _IDGtzqkLabel.title = @"IDG投资情况：";
    _IDGtzqkLabel.textColor = kTextColor;
    _IDGtzqkLabel.inputType = CXEditLabelInputTypeCustomPicker;
    _IDGtzqkLabel.allowEditing = NO;
    _IDGtzqkLabel.showDropdown = NO;
    _IDGtzqkLabel.pickerTextArray = @[@"未投资", @"已投资"];
    _IDGtzqkLabel.pickerValueArray = @[@"unInv", @"inv"];
    if([self.model.invStatus isEqualToString:@"unInv"]){
        _IDGtzqkLabel.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"未投资",
                                             CXEditLabelCustomPickerValueKey : @"unInv"
                                             };
        _IDGtzqkLabel.content = @"未投资";
    }else if([self.model.invStatus isEqualToString:@"inv"]){
        _IDGtzqkLabel.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"已投资",
                                             CXEditLabelCustomPickerValueKey : @"inv"
                                             };
        _IDGtzqkLabel.content = @"已投资";
    }
    _IDGtzqkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        if([editLabel.content isEqualToString:@"未投资"]){
            self.yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"未投资",
                                                  CXEditLabelCustomPickerValueKey : @"unInv"
                                                  };
        }else if([editLabel.content isEqualToString:@"已投资"]){
            self.yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"已投资",
                                                  CXEditLabelCustomPickerValueKey : @"inv"
                                                  };
        }
    };
    [self.scrollContentView addSubview:_IDGtzqkLabel];
    
    // line_10
    UIView *line_10 = [self createFormSeperatorLine];
    line_10.frame = CGRectMake(0.f, _IDGtzqkLabel.bottom, lineWidth, lineHeight);
    
    //重点项目
    _zdxmLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_10.bottom, Screen_Width - leftMargin, viewHeight)];
    _zdxmLabel.title = @"是否重点项目：";
    _zdxmLabel.textColor = kTextColor;
    _zdxmLabel.allowEditing = NO;
    _zdxmLabel.inputType = CXEditLabelInputTypeCustomPicker;
    _zdxmLabel.pickerTextArray = @[@"是",@"是(新增)",@"否"];
    _zdxmLabel.pickerValueArray = @[@(1),@(2),@(3)];
    if(self.model.importantStatus && [self.model.importantStatus integerValue] == 1){
        _zdxmLabel.content = @"是";
        self.model.importantStatus = @(1);
        _zdxmLabel.selectedPickerData = @{
                                          CXEditLabelCustomPickerTextKey : @"是",
                                          CXEditLabelCustomPickerValueKey : @(1)
                                          };
    }else if(self.model.importantStatus && [self.model.importantStatus integerValue] == 2){
        _zdxmLabel.content = @"是(新增)";
        self.model.importantStatus = @(2);
        _zdxmLabel.selectedPickerData = @{
                                          CXEditLabelCustomPickerTextKey : @"是(新增)",
                                          CXEditLabelCustomPickerValueKey : @(2)
                                          };
    }else if(self.model.importantStatus && [self.model.importantStatus integerValue] == 3){
        _zdxmLabel.content = @"否";
        self.model.importantStatus = @(3);
        _zdxmLabel.selectedPickerData = @{
                                          CXEditLabelCustomPickerTextKey : @"否",
                                          CXEditLabelCustomPickerValueKey : @(3)
                                          };
    }
    _zdxmLabel.showDropdown = NO;
    _zdxmLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        if([editLabel.content isEqualToString:@"是"]){
            self.zdxmLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"是",
                                                  CXEditLabelCustomPickerValueKey : @(1)
                                                  };
            self.model.importantStatus = @(1);
        }else if([editLabel.content isEqualToString:@"是(新增)"]){
            self.zdxmLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                  CXEditLabelCustomPickerValueKey : @(2)
                                                  };
            self.model.importantStatus = @(2);
        }else if([editLabel.content isEqualToString:@"否"]){
            self.zdxmLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"否",
                                                  CXEditLabelCustomPickerValueKey : @(3)
                                                  };
            self.model.importantStatus = @(3);
        }
    };
    [self.scrollContentView addSubview:_zdxmLabel];
    
    // line_11
    UIView *line_11 = [self createFormSeperatorLine];
    line_11.frame = CGRectMake(0.f, _zdxmLabel.bottom, lineWidth, lineBoldHeight);
    
    _ywjsTitleLabel = [[UILabel alloc] init];
    _ywjsTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    _ywjsTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
    _ywjsTitleLabel.numberOfLines = 0;
    _ywjsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsTitleLabel.backgroundColor = [UIColor clearColor];
    _ywjsTitleLabel.textAlignment = NSTextAlignmentLeft;
    _ywjsTitleLabel.text = @"业务介绍";
    CGSize ywjsTitleLabelSize = [_ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _ywjsTitleLabel.frame = CGRectMake(leftMargin, line_11.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, ywjsTitleLabelSize.height);
    [self.scrollContentView addSubview:_ywjsTitleLabel];
    
    
    if(self.model.bizDesc && [self.model.bizDesc length] > 0){
        if(_ywjsContentLabel){
            [_ywjsContentLabel removeFromSuperview];
        }
        _ywjsContentLabel = [[UILabel alloc] init];
        _ywjsContentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
        _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
        _ywjsContentLabel.text = self.model.bizDesc;
        _ywjsContentLabel.numberOfLines = 0;
        _ywjsContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _ywjsContentLabel.backgroundColor = [UIColor clearColor];
        _ywjsContentLabel.textAlignment = NSTextAlignmentLeft;
        CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
        _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
        [self.scrollContentView addSubview:_ywjsContentLabel];
        
        // line_12
        UIView *line_12 = [self createFormSeperatorLine];
        line_12.frame = CGRectMake(0.f, _ywjsContentLabel.bottom + kLabelTopSpace, lineWidth, lineBoldHeight);
        
        _gjqkTitleLabel = [[UILabel alloc] init];
        _gjqkTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _gjqkTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
        _gjqkTitleLabel.numberOfLines = 0;
        _gjqkTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _gjqkTitleLabel.backgroundColor = [UIColor clearColor];
        _gjqkTitleLabel.textAlignment = NSTextAlignmentLeft;
        _gjqkTitleLabel.text = @"跟进情况";
        CGSize gjqkTitleLabelSize = [_gjqkTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _gjqkTitleLabel.frame = CGRectMake(leftMargin, line_12.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, gjqkTitleLabelSize.height);
        [self.scrollContentView addSubview:_gjqkTitleLabel];
        
        
        if(_extendImageView){
            [_extendImageView removeFromSuperview];
            _extendImageView = nil;
        }
        _extendImageView = [[UIImageView alloc] init];
        _extendImageView.image = [UIImage imageNamed:@"expand"];
        _extendImageView.highlightedImage = [UIImage imageNamed:@"expand"];
        _extendImageView.frame = CGRectMake(Screen_Width - leftMargin - 19.0, line_12.bottom + kLabelTopSpace, 19.0, 19.0);
        [self.scrollContentView addSubview:_extendImageView];
        
        if(_extendBtn){
            [_extendBtn removeFromSuperview];
            _extendBtn = nil;
        }
        _extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.isExtend = YES;
        [_extendBtn addTarget:self action:@selector(extendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _extendBtn.frame = CGRectMake(Screen_Width - leftMargin - 19.0 - 5.0, line_12.bottom + kLabelTopSpace - 15.0, 19.0 + 10.0, 19.0 + 20.0);
        [self.scrollContentView addSubview:_extendBtn];
        
        if(_addImageView){
            [_addImageView removeFromSuperview];
            _addImageView = nil;
        }
        _addImageView = [[UIImageView alloc] init];
        _addImageView.image = [UIImage imageNamed:@"AddImage"];
        _addImageView.highlightedImage = [UIImage imageNamed:@"AddImage"];
        [_gjqkTitleLabel sizeToFit];
        _addImageView.frame = CGRectMake(leftMargin + kRedViewWidth + kRedViewRightSpace + _gjqkTitleLabel.size.width + 15.0, line_12.bottom + kLabelTopSpace, 19.0, 19.0);
        [self.scrollContentView addSubview:_addImageView];
        
        if(_addBtn){
            [_addBtn removeFromSuperview];
            _addBtn = nil;
        }
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.frame = CGRectMake(leftMargin + kRedViewWidth + kRedViewRightSpace + _gjqkTitleLabel.size.width + 15.0 - 5.0, line_12.bottom + kLabelTopSpace - 15.0, 19.0 + 10.0, 19.0 + 20.0);
        [self.scrollContentView addSubview:_addBtn];
    }else{
        // line_13
        UIView *line_13 = [self createFormSeperatorLine];
        line_13.frame = CGRectMake(0.f, _ywjsTitleLabel.bottom + kLabelTopSpace, lineWidth, lineBoldHeight);
        
        _gjqkTitleLabel = [[UILabel alloc] init];
        _gjqkTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _gjqkTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
        _gjqkTitleLabel.numberOfLines = 0;
        _gjqkTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _gjqkTitleLabel.backgroundColor = [UIColor clearColor];
        _gjqkTitleLabel.textAlignment = NSTextAlignmentLeft;
        _gjqkTitleLabel.text = @"跟进情况";
        CGSize gjqkTitleLabelSize = [_gjqkTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _gjqkTitleLabel.frame = CGRectMake(leftMargin, line_13.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, gjqkTitleLabelSize.height);
        [self.scrollContentView addSubview:_gjqkTitleLabel];
        
        if(_extendImageView){
            [_extendImageView removeFromSuperview];
            _extendImageView = nil;
        }
        _extendImageView = [[UIImageView alloc] init];
        _extendImageView.image = [UIImage imageNamed:@"expand"];
        _extendImageView.highlightedImage = [UIImage imageNamed:@"expand"];
        _extendImageView.frame = CGRectMake(Screen_Width - leftMargin - 19.0, line_13.bottom + kLabelTopSpace, 19.0, 19.0);
        [self.scrollContentView addSubview:_extendImageView];
        
        if(_extendBtn){
            [_extendBtn removeFromSuperview];
            _extendBtn = nil;
        }
        _extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.isExtend = YES;
        [_extendBtn addTarget:self action:@selector(extendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _extendBtn.frame = CGRectMake(Screen_Width - leftMargin - 19.0 - 5.0, line_13.bottom + kLabelTopSpace - 15.0, 19.0 + 10.0, 19.0 + 20.0);
        [self.scrollContentView addSubview:_extendBtn];
        
        if(_addImageView){
            [_addImageView removeFromSuperview];
            _addImageView = nil;
        }
        _addImageView = [[UIImageView alloc] init];
        _addImageView.image = [UIImage imageNamed:@"AddImage"];
        _addImageView.highlightedImage = [UIImage imageNamed:@"AddImage"];
        [_gjqkTitleLabel sizeToFit];
        _addImageView.frame = CGRectMake(leftMargin + kRedViewWidth + kRedViewRightSpace + _gjqkTitleLabel.size.width + 15.0, line_13.bottom + kLabelTopSpace, 19.0, 19.0);
        [self.scrollContentView addSubview:_addImageView];
        
        if(_addBtn){
            [_addBtn removeFromSuperview];
            _addBtn = nil;
        }
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.frame = CGRectMake(leftMargin + kRedViewWidth + kRedViewRightSpace + _gjqkTitleLabel.size.width + 15.0 - 5.0, line_13.bottom + kLabelTopSpace - 15.0, 19.0 + 10.0, 19.0 + 20.0);
        [self.scrollContentView addSubview:_addBtn];
    }
    
    self.scrollContentView.frame = CGRectMake(0, 0, Screen_Width, _gjqkTitleLabel.bottom + kLabelTopSpace);
    [self.tableView setTableHeaderView:self.scrollContentView];
    
    
    
    @weakify(self)
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self)
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self)
        [self getListWithPage:self.pageNumber + 1];
    }];
    //    [self.tableView.footer setHidden:YES];
    [self.view addSubview:self.tableView];
    */
}

- (void)editBtnClick
{
    CXAddPEPotentialProjectViewController *vc = [[CXAddPEPotentialProjectViewController alloc] init];
    vc.formType = CXFormTypeModify;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)extendBtnClick
{
    self.isExtend = !self.isExtend;
    if(self.isExtend){
        _extendImageView.image = [UIImage imageNamed:@"expand"];
        _extendImageView.highlightedImage = [UIImage imageNamed:@"expand"];
    }else{
        _extendImageView.image = [UIImage imageNamed:@"collapse"];
        _extendImageView.highlightedImage = [UIImage imageNamed:@"collapse"];
    }
    [self.tableView reloadData];
}

- (void)addBtnClick
{
    CXAddPotentialFollowViewController *vc = [[CXAddPotentialFollowViewController alloc] initWithFormType:CXFormTypeCreate AndModel:nil AndCXPEPotentialProjectModel:self.model];
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SDBackGroudColor;
    [self.scrollContentView addSubview:line];
    return line;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _topInfoView = nil;
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataSourceArr.count == 0 ? 0 : 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"    跟进情况";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = RGBACOLOR(65, 65, 65, 1);
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isExtend){
        return [self.dataSourceArr count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CXPotentialFollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CXYMMetProjectDetailCellIdentity  forIndexPath:indexPath];
    CXPotentialFollowListModel *model = self.dataSourceArr[indexPath.row];
    cell.parentVC = self;
    cell.PEPotentialProjectModel = self.model;
    cell.PotentialFollowListModel = model;
    [cell setCXPotentialFollowListModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXPotentialFollowListModel *model = self.dataSourceArr[indexPath.row];
//    return [CXPotentialFollowListTableViewCell getCellHeightWithCXPotentialFollowListModel:model];
    return UITableViewAutomaticDimension;
}

- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@project/potential/detail/%zd", urlPrefix, [self.listModel.projId integerValue]];
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏oading
        
        if ([JSON[@"status"] intValue] == 200) {
            self.model = [CXPEPotentialProjectModel yy_modelWithJSON:JSON[@"data"]];
            SDRootTopView *rootTopView = [self getRootTopView];
            [rootTopView setNavTitle:self.model.projName];
            
            if(self.model.invDate){
                // timeStampString 是服务器返回的13位时间戳
                NSString *timeStampString  = self.model.invDate;
                // iOS 生成的时间戳是10位
                NSTimeInterval interval =[timeStampString doubleValue] / 1000.0;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [formatter stringFromDate:date];
                self.model.invDate = dateString;
            }
            
            self.pageNumber = 1;
            self.topInfoView.model = self.model;
            [self setUpTableView];
            [self getListWithPage:self.pageNumber];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏oading

        CXAlert(KNetworkFailRemind);
    }];
}

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/potential/follow/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.model.projId forKey:@"s_projId"];
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏oading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.tableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXPotentialFollowListModel *> *data = [NSArray yy_modelArrayWithClass:[CXPotentialFollowListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            if(self.dataSourceArr.count == 0){
                self.topInfoView.hasFollowDataSource = NO;
            }
            [self.tableView reloadData];

            
            
//            if(self.dataSourceArr.count == 0){//没有跟进情况
//                CGRect rect = self.topInfoView.frame;
//                self.topInfoView.frame = CGRectMake(0, 0, Screen_Width,rect.size.height - bigTitleHeight - topMargin);
//            }
//            NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
//            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }              failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏oading

        CXAlert(KNetworkFailRemind);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

@end
