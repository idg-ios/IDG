//
//  CXYMBadAssetsDetailViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMBadAssetsDetailViewController.h"
#import "CXYMProjectModel.h"
#import "CXYMNormalListCell.h"
#import "HttpTool.h"
#import "Masonry.h"
#import "CXYMBadAssetsDetailModel.h"
#import "CXYMBadAssetsProgress.h"
#import "CXYMBadAssetsProgressViewController.h"
#import "CXYMAppearanceManager.h"

@interface CXYMBadAssetsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CXYMBadAssetsModel *badAssets;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;///<左侧标题
@property (nonatomic, strong) NSArray *contentArray;///<右侧文本
@property (nonatomic, strong) NSMutableArray <CXYMBadAssetsProgress *> *progressArray;///<进度列表
@property (nonatomic, assign) NSInteger pageNumber;
@end

static NSString *badAssetsDetailCellIdentity = @"badAssetsDetailCellIdentity";
@implementation CXYMBadAssetsDetailViewController


- (instancetype)initWithBadAssets:(CXYMBadAssetsModel *)badAssets{
    self = [super init];
    if(self){
        self.badAssets = badAssets;
    }
    return self;
}
#pragma mark -- setter&&getter
- (NSMutableArray *)progressArray{
    if (_progressArray == nil) {
        _progressArray = [NSMutableArray array];
    }
    return _progressArray;
}
- (NSArray *)titleArray{
    if(_titleArray == nil) {
        NSArray *array0 = @[@"日期",
                            @"项目负责人",
                            @"律师",
                            @"项目名称",
                            @"投资金额",
                            @"占比",
                            @"境内实体",
                            @"境外实体",
                            @"unknown",
                            @"评级",
                            @"行业"];
        NSArray *array1 = @[@"当前情况",
                            @"确认信息",
                            @"项目分析",
                            @"风险控制与纠偏"
                           ];
        _titleArray = @[array0,array1];
    }
    return _titleArray;
}
//- (NSMutableArray *)contentArray{
//    if(_contentArray == nil) {
//        _contentArray = [NSMutableArray array];
//    }
//    return _contentArray;
//}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMNormalListCell class] forCellReuseIdentifier:badAssetsDetailCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.RootTopView setNavTitle:self.badAssets.ename ? : @"" ];
      [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
//    [self.RootTopView setUpRightBarItemTitle:@"进度" addTarget:self action:@selector(pushProgress)];
    [self setupTableView];
    [self loadData];
    [self loadProgressData];
}
-(void)loadProgressData{
    self.pageNumber = 1;
    NSString *path = [NSString stringWithFormat:@"badAssets/progress/list/%ld/%zd",(long)[self.badAssets.projId integerValue],self.pageNumber];
    NSDictionary *params = @{@"projId":self.badAssets.projId,@"pageNumber":@(self.pageNumber)};
    [HttpTool getWithPath:path params:params success:^(id JSON) {
        NSInteger statue = [JSON[@"status"] integerValue];
        if(statue == 200){
            NSArray <CXYMBadAssetsProgress *>*array = [NSArray yy_modelArrayWithClass:[CXYMBadAssetsProgress class] json:JSON[@"data"]];
            [self.progressArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
    
}
- (void)pushProgress{
    CXYMBadAssetsProgressViewController *badAssetsProgressViewController = [[CXYMBadAssetsProgressViewController alloc] initWithBadAssets:self.badAssets];
    [self.navigationController pushViewController:badAssetsProgressViewController animated:YES];
}
- (void)setupTableView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabbarSafeBottomMargin);
    }];
}
- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"badAssets/detail/%@",self.badAssets.projId];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger statue = [JSON[@"status"] integerValue];
        if(statue == 200){
            //            
            CXYMBadAssetsDetailModel *badAssetsDetail = [CXYMBadAssetsDetailModel yy_modelWithJSON:JSON[@"data"]];
            NSMutableArray *array0 = [NSMutableArray array];
            NSMutableArray *array1 = [NSMutableArray array];
            
//            [array0 addObject:badAssetsDetail.projInDate = nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.projInDate]];
//            [array0 addObject:badAssetsDetail.dealLeadName= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.dealLeadName]];
//            [array0 addObject:badAssetsDetail.dealLegalName= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.dealLegalName]];
//            [array0 addObject:badAssetsDetail.ename = nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.ename]];
//            [array0 addObject:badAssetsDetail.investAmt = nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.investAmt]];
//            [array0 addObject:badAssetsDetail.percent= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.percent]];
//            [array0 addObject:badAssetsDetail.entity= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.entity]];
//            [array0 addObject:badAssetsDetail.entityOversea= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.entityOversea]];
//            [array0 addObject:badAssetsDetail.classType= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.classType]];
//            [array0 addObject:badAssetsDetail.grade= nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.grade]];
//            [array0 addObject:badAssetsDetail.indusName = nil ? : @" "];
            [array0 addObject:[self changeNilWithString:badAssetsDetail.indusName]];
            //
//            [array1 addObject:badAssetsDetail.situation = nil ? : @" "];
            [array1 addObject:[self changeNilWithString:badAssetsDetail.situation]];
//            [array1 addObject:badAssetsDetail.confirmInfo = nil ? : @" "];
            [array1 addObject:[self changeNilWithString:badAssetsDetail.confirmInfo]];
//            [array1 addObject:badAssetsDetail.analysis = nil ? : @" "];
            [array1 addObject:[self changeNilWithString:badAssetsDetail.analysis]];
//            [array1 addObject:badAssetsDetail.riskControl = nil ? : @" "];
            [array1 addObject:[self changeNilWithString:badAssetsDetail.riskControl]];

            self.contentArray = @[array0,array1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}
- (NSString *)changeNilWithString:(NSString *)string{
//    if(![string isKindOfClass:[NSString class]]) return ;
    if ([string isEqualToString:@""] || string == nil) {
        return @" ";
    }else{
        return string;
    }
}
#pragma mark-- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
//    NSInteger index = self.contentArray.count+self.progressArray.count;
//    return index;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *array = self.contentArray[0];
        return array.count;
    }else if(section == 1){
    NSArray *array = self.contentArray[1];
    return array.count;
    }else{
        return self.progressArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return section == 0 ? 30 : 0;
    if (section == 0) {
        return 30;
    } else if(section == 1){
        return 20;
    }else{
        return .001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 0) {
        footer.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        [footer addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    } else if(section == 1){
        footer.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        [footer addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(8);
        }];
    } else {
        footer.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return section == 1 ? 0 : 30;
    if (section == 0) {
        return 30;
    } else if(section == 1){
        return 0;
    }else{
        if (self.progressArray.count == 0 || self.progressArray == nil) {
            return 0;
        }else{
            return 30;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    header.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [CXYMAppearanceManager textNormalFont];
    label.textColor = [CXYMAppearanceManager textNormalColor];
    label.text = section == 0 ? @"基本资料" : @"跟进";
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.centerY.mas_equalTo(0);
    }];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.estimatedRowHeight = 30;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMNormalListCell *cell = [tableView dequeueReusableCellWithIdentifier:badAssetsDetailCellIdentity forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSArray *titleArray = self.titleArray[0];
        NSArray *contentArray = self.contentArray[0];
        cell.titleLabel.text = titleArray[indexPath.row];
        cell.titleLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.text = contentArray[indexPath.row];
        cell.contentLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.numberOfLines = 0;
    } else if(indexPath.section == 1){
        NSArray *titleArray = self.titleArray[1];
        NSArray *contentArray = self.contentArray[1];
        cell.titleLabel.text = titleArray[indexPath.row];
        cell.titleLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.text = contentArray[indexPath.row];
        cell.contentLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.numberOfLines = 0;
    }else{
        CXYMBadAssetsProgress *progress = self.progressArray[indexPath.row];
        cell.titleLabel.text = progress.editDate;
        cell.titleLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.text = progress.actionContent;
        cell.contentLabel.font = [CXYMAppearanceManager textMediumFont];
        cell.contentLabel.numberOfLines = 0;
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
