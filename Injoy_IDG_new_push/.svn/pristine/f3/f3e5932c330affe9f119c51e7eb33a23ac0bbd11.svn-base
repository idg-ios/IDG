//
//  CXPromotionSettingsViewController.m
//  InjoyERP
//
//  Created by wtz on 2017/5/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXPromotionSettingsViewController.h"
#import "UIView+Category.h"
#import "HttpTool.h"
#import "CXPromotionSettingsView.h"

@interface CXPromotionSettingsViewController ()<UITableViewDelegate, UITableViewDataSource,CXPromotionSettingsViewReloadHeightDelegate>

/** TableView */
@property(nonatomic, strong) UITableView *tableView;
/** tableView的tableHeaderView */
@property(nonatomic, strong) UIView * theTableHeaderView;
/** 导航条 */
@property(nonatomic, strong) SDRootTopView* rootTopView;
/** 官网视图 */
@property(nonatomic, strong) CXPromotionSettingsView * guanPromotionSettingsView;
/** 官网视图高度 */
@property(nonatomic) CGFloat guanPromotionSettingsViewHeight;
/** 淘宝店视图 */
@property(nonatomic, strong) CXPromotionSettingsView * taobaoPromotionSettingsView;
/** 淘宝店视图高度 */
@property(nonatomic) CGFloat taobaoPromotionSettingsViewHeight;
/** 天猫店视图 */
@property(nonatomic, strong) CXPromotionSettingsView * tianmaoPromotionSettingsView;
/** 天猫店视图高度 */
@property(nonatomic) CGFloat tianmaoPromotionSettingsViewHeight;
/** 京东店视图 */
@property(nonatomic, strong) CXPromotionSettingsView * jingdongPromotionSettingsView;
/** 京东店视图高度 */
@property(nonatomic) CGFloat jingdongPromotionSettingsViewHeight;
/** 微店视图 */
@property(nonatomic, strong) CXPromotionSettingsView * weiPromotionSettingsView;
/** 微店视图高度 */
@property(nonatomic) CGFloat weiPromotionSettingsViewHeight;
/** 阿里店视图 */
@property(nonatomic, strong) CXPromotionSettingsView * aliPromotionSettingsView;
/** 阿里店视图高度 */
@property(nonatomic) CGFloat aliPromotionSettingsViewHeight;

@end

@implementation CXPromotionSettingsViewController

#pragma mark - 选择器  日期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setupView];
    
    NSString *url = [NSString stringWithFormat:@"%@extension/findTgsz",urlPrefix];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];//loading
    [HttpTool getWithPath:url params:nil success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            NSDictionary * allShareUrlDic = JSON[@"data"];
            if(allShareUrlDic != nil && [allShareUrlDic isKindOfClass:[NSDictionary class]] && [allShareUrlDic count] > 0){
                if([allShareUrlDic objectForKey:@"owAddress"] != nil && [[allShareUrlDic objectForKey:@"owAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"owAddress"] length] > 0){
                    [_guanPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"owAddress"]];
                }
                if([allShareUrlDic objectForKey:@"taobaoAddress"] != nil && [[allShareUrlDic objectForKey:@"taobaoAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"taobaoAddress"] length] > 0){
                    [_taobaoPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"taobaoAddress"]];
                }
                if([allShareUrlDic objectForKey:@"tianmaoAddress"] != nil && [[allShareUrlDic objectForKey:@"tianmaoAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"tianmaoAddress"] length] > 0){
                    [_tianmaoPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"tianmaoAddress"]];
                }
                if([allShareUrlDic objectForKey:@"jdAddress"] != nil && [[allShareUrlDic objectForKey:@"jdAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"jdAddress"] length] > 0){
                    [_jingdongPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"jdAddress"]];
                }
                if([allShareUrlDic objectForKey:@"wdAddress"] != nil && [[allShareUrlDic objectForKey:@"wdAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"wdAddress"] length] > 0){
                    [_weiPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"wdAddress"]];
                }
                if([allShareUrlDic objectForKey:@"aLiAddress"] != nil && [[allShareUrlDic objectForKey:@"aLiAddress"] isKindOfClass:[NSString class]] && [[allShareUrlDic objectForKey:@"aLiAddress"] length] > 0){
                    [_aliPromotionSettingsView setContentText:[allShareUrlDic objectForKey:@"aLiAddress"]];
                }
            }
        }else{
            MAKE_TOAST(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setupView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"推广设置")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveBtnClick)];
    self.guanPromotionSettingsViewHeight = kCellHeight;
    self.taobaoPromotionSettingsViewHeight = kCellHeight;
    self.tianmaoPromotionSettingsViewHeight = kCellHeight;
    self.jingdongPromotionSettingsViewHeight = kCellHeight;
    self.weiPromotionSettingsViewHeight = kCellHeight;
    self.aliPromotionSettingsViewHeight = kCellHeight;
    
    /** UITableView */
    _theTableHeaderView = [[UIView alloc] init];
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width,self.guanPromotionSettingsViewHeight + self.taobaoPromotionSettingsViewHeight + self.tianmaoPromotionSettingsViewHeight + self.jingdongPromotionSettingsViewHeight + self.weiPromotionSettingsViewHeight + self.aliPromotionSettingsViewHeight);
    _theTableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _guanPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  官　网：" andFrame:CGRectMake(0, 0, Screen_Width, self.guanPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的官网网址"];
    _guanPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_guanPromotionSettingsView];
    
    _taobaoPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  淘宝店：" andFrame:CGRectMake(0, CGRectGetMaxY(_guanPromotionSettingsView.frame), Screen_Width, self.taobaoPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的淘宝店网址"];
    _taobaoPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_taobaoPromotionSettingsView];
    
    _tianmaoPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  天猫店：" andFrame:CGRectMake(0, CGRectGetMaxY(_taobaoPromotionSettingsView.frame), Screen_Width, self.tianmaoPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的天猫店网址"];
    _tianmaoPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_tianmaoPromotionSettingsView];
    
    _jingdongPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  京东店：" andFrame:CGRectMake(0, CGRectGetMaxY(_tianmaoPromotionSettingsView.frame), Screen_Width, self.jingdongPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的京东店网址"];
    _jingdongPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_jingdongPromotionSettingsView];
    
    _weiPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  微　店：" andFrame:CGRectMake(0, CGRectGetMaxY(_jingdongPromotionSettingsView.frame), Screen_Width, self.weiPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的微店网址"];
    _weiPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_weiPromotionSettingsView];
    
    _aliPromotionSettingsView= [[CXPromotionSettingsView alloc] initWithTitle:@"  阿里店：" andFrame:CGRectMake(0, CGRectGetMaxY(_weiPromotionSettingsView.frame), Screen_Width, self.aliPromotionSettingsViewHeight) AndCXPromotionSettingsViewMode:CXPromotionSettingsViewModeCreate AndHoldLabelText:@"输入你的阿里店网址"];
    _aliPromotionSettingsView.delegate = self;
    [_theTableHeaderView addSubview:_aliPromotionSettingsView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height -navHigh);
    _tableView.backgroundColor = SDBackGroudColor;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.tableHeaderView = _theTableHeaderView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)saveBtnClick
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(_guanPromotionSettingsView.theContentText != nil || [_guanPromotionSettingsView.theContentText length] > 0){
        [params setObject:_guanPromotionSettingsView.theContentText forKey:@"owAddress"];
    }
    if(_taobaoPromotionSettingsView.theContentText != nil || [_taobaoPromotionSettingsView.theContentText length] > 0){
        [params setObject:_taobaoPromotionSettingsView.theContentText forKey:@"taobaoAddress"];
    }
    if(_tianmaoPromotionSettingsView.theContentText != nil || [_tianmaoPromotionSettingsView.theContentText length] > 0){
        [params setObject:_tianmaoPromotionSettingsView.theContentText forKey:@"tianmaoAddress"];
    }
    if(_jingdongPromotionSettingsView.theContentText != nil || [_jingdongPromotionSettingsView.theContentText length] > 0){
        [params setObject:_jingdongPromotionSettingsView.theContentText forKey:@"jdAddress"];
    }
    if(_weiPromotionSettingsView.theContentText != nil || [_weiPromotionSettingsView.theContentText length] > 0){
        [params setObject:_weiPromotionSettingsView.theContentText forKey:@"wdAddress"];
    }
    if(_aliPromotionSettingsView.theContentText != nil || [_aliPromotionSettingsView.theContentText length] > 0){
        [params setObject:_aliPromotionSettingsView.theContentText forKey:@"aLiAddress"];
    }
    if([params count]<=0){
        [params setObject:@"" forKey:@"owAddress"];
        [params setObject:@"" forKey:@"taobaoAddress"];
        [params setObject:@"" forKey:@"tianmaoAddress"];
        [params setObject:@"" forKey:@"jdAddress"];
        [params setObject:@"" forKey:@"wdAddress"];
        [params setObject:@"" forKey:@"aLiAddress"];
    }
    NSString *url = [NSString stringWithFormat:@"%@extension/saveOrUpdateTgsz",urlPrefix];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            TTAlert(@"保存成功!");
        }else{
            MAKE_TOAST(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CXPromotionSettingsViewReloadHeightDelegate
/**
 *  CXPromotionSettingsViewReloadHeightDelegate 内容视图代理方法
 *
 *  @param viewHeight 内容视图高度
 *
 */
- (void)promotionSettingsViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight AndHoldLabelText:(NSString *)holdLabelText
{
    if([holdLabelText isEqualToString:@"输入你的官网网址"]){
        self.guanPromotionSettingsViewHeight = viewHeight;
    }else if([holdLabelText isEqualToString:@"输入你的淘宝店网址"]){
        self.taobaoPromotionSettingsViewHeight = viewHeight;
    }else if([holdLabelText isEqualToString:@"输入你的天猫店网址"]){
        self.tianmaoPromotionSettingsViewHeight = viewHeight;
    }else if([holdLabelText isEqualToString:@"输入你的京东店网址"]){
        self.jingdongPromotionSettingsViewHeight = viewHeight;
    }else if([holdLabelText isEqualToString:@"输入你的微店网址"]){
        self.weiPromotionSettingsViewHeight = viewHeight;
    }else if([holdLabelText isEqualToString:@"输入你的阿里店网址"]){
        self.aliPromotionSettingsViewHeight = viewHeight;
    }
    self.guanPromotionSettingsView.frame = CGRectMake(0, 0, Screen_Width, self.guanPromotionSettingsViewHeight);
    self.taobaoPromotionSettingsView.frame = CGRectMake(0, CGRectGetMaxY(_guanPromotionSettingsView.frame), Screen_Width, self.taobaoPromotionSettingsViewHeight);
    self.tianmaoPromotionSettingsView.frame = CGRectMake(0, CGRectGetMaxY(_taobaoPromotionSettingsView.frame), Screen_Width, self.tianmaoPromotionSettingsViewHeight);
    self.jingdongPromotionSettingsView.frame = CGRectMake(0, CGRectGetMaxY(_tianmaoPromotionSettingsView.frame), Screen_Width, self.jingdongPromotionSettingsViewHeight);
    self.weiPromotionSettingsView.frame = CGRectMake(0, CGRectGetMaxY(_jingdongPromotionSettingsView.frame), Screen_Width, self.weiPromotionSettingsViewHeight);
    self.aliPromotionSettingsView.frame = CGRectMake(0, CGRectGetMaxY(_weiPromotionSettingsView.frame), Screen_Width, self.aliPromotionSettingsViewHeight);
    _theTableHeaderView.frame = CGRectMake(0, 0, Screen_Width,self.guanPromotionSettingsViewHeight + self.taobaoPromotionSettingsViewHeight + self.tianmaoPromotionSettingsViewHeight + self.jingdongPromotionSettingsViewHeight + self.weiPromotionSettingsViewHeight + self.aliPromotionSettingsViewHeight);
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
