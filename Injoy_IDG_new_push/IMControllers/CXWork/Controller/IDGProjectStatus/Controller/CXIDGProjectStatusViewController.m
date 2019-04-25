//
//  CXIDGProjectStatusViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGProjectStatusViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGConferenceInformationListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXIDGProjectManagementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXIDGConferenceInformationListTableViewCell.h"
#import "CXIDGConferenceInformationDetailViewController.h"
#import "CXIDGProjectStatusModel.h"
#import "CXIDGProjectStatusTableViewCell.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXIDGProjectStatusViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXIDGProjectStatusTableViewCellModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@property(nonatomic, strong) CXIDGProjectStatusModel * projectStatusModel;

@end

@implementation CXIDGProjectStatusViewController

#pragma mark - get & set

- (CXIDGProjectStatusModel *)projectStatusModel{
    if(!_projectStatusModel){
        _projectStatusModel = [[CXIDGProjectStatusModel alloc] init];
    }
    return _projectStatusModel;
}

- (NSMutableArray<CXIDGProjectStatusTableViewCellModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor clearColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function
- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.pageNumber = 1;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpTableView];
    [self getListWithPage:self.pageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXIDGProjectStatusTableViewCellModel * model = [self.dataSourceArr objectAtIndex:indexPath.section];
    model.isExpand = !model.isExpand;
    self.dataSourceArr[indexPath.section] = model;
    [self.listTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0){
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = SDBackGroudColor;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section != 0){
        return 8.0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXIDGProjectStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXIDGProjectStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        for(UIView * subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    CXIDGProjectStatusTableViewCellModel *model = self.dataSourceArr[indexPath.section];
    [cell setCXIDGProjectStatusTableViewCellModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXIDGProjectStatusTableViewCellModel *model = self.dataSourceArr[indexPath.section];
    return [CXIDGProjectStatusTableViewCell getCXIDGConferenceInformationListTableViewCellHeightWithCXIDGProjectStatusTableViewCellModel:model];
}

#pragma mark <---请求列表--->

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/detail/more/%zd", urlPrefix, [self.model.projId integerValue]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"eid"] = self.model.projId;
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];
    
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            [self.dataSourceArr removeAllObjects];
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.footer setHidden:!hasNextPage];
            self.projectStatusModel = [CXIDGProjectStatusModel yy_modelWithDictionary:JSON[@"data"]];
            
            CXIDGProjectStatusTableViewCellModel * ywjsModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            ywjsModel.title = @"业务介绍";
            ywjsModel.content = self.projectStatusModel.business;
            ywjsModel.isExpand = YES;
            if(self.projectStatusModel.business && [self.projectStatusModel.business length] > 0){
                [self.dataSourceArr addObject:ywjsModel];
            }
            
            
            CXIDGProjectStatusTableViewCellModel * cwsjModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            cwsjModel.title = @"财务数据";
            cwsjModel.content = self.projectStatusModel.finData;
            cwsjModel.isExpand = YES;
            if(self.projectStatusModel.finData && [self.projectStatusModel.finData length] > 0){
                [self.dataSourceArr addObject:cwsjModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jhrzejgzxxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jhrzejgzxxModel.title = @"计划融资额及估值信息";
            jhrzejgzxxModel.content = self.projectStatusModel.finPlan;
            jhrzejgzxxModel.isExpand = YES;
            if(self.projectStatusModel.finPlan && [self.projectStatusModel.finPlan length] > 0){
                [self.dataSourceArr addObject:jhrzejgzxxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jstdjysModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jstdjysModel.title = @"技术特点及优势";
            jstdjysModel.content = self.projectStatusModel.technicalFeature;
            jstdjysModel.isExpand = YES;
            if(self.projectStatusModel.technicalFeature && [self.projectStatusModel.technicalFeature length] > 0){
                [self.dataSourceArr addObject:jstdjysModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tzldModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tzldModel.title = @"投资亮点";
            tzldModel.content = self.projectStatusModel.invHighlights;
            tzldModel.isExpand = YES;
            if(self.projectStatusModel.invHighlights && [self.projectStatusModel.invHighlights length] > 0){
                [self.dataSourceArr addObject:tzldModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tdjsModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tdjsModel.title = @"团队介绍";
            tdjsModel.content = self.projectStatusModel.teamDesc;
            tdjsModel.isExpand = YES;
            self.projectStatusModel.teamDesc = [self.projectStatusModel.teamDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//处理首尾空行
            if(self.projectStatusModel.teamDesc && [self.projectStatusModel.teamDesc length] > 0){
                [self.dataSourceArr addObject:tdjsModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * gqjgModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            gqjgModel.title = @"股权结构";
            gqjgModel.content = self.projectStatusModel.ownershipStructure;
            gqjgModel.isExpand = YES;
            if(self.projectStatusModel.ownershipStructure && [self.projectStatusModel.ownershipStructure length] > 0){
                [self.dataSourceArr addObject:gqjgModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * sfdsjsxwModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            sfdsjsxwModel.title = @"是否董事/监事席位";
            sfdsjsxwModel.content = self.projectStatusModel.board;
            sfdsjsxwModel.isExpand = YES;
            if(self.projectStatusModel.board && [self.projectStatusModel.board length] > 0){
                [self.dataSourceArr addObject:sfdsjsxwModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * scgmqlhjzdModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            scgmqlhjzdModel.title = @"市场规模/潜力和集中度";
            scgmqlhjzdModel.content = self.projectStatusModel.marketDesc;
            scgmqlhjzdModel.isExpand = YES;
            if(self.projectStatusModel.marketDesc && [self.projectStatusModel.marketDesc length] > 0){
                [self.dataSourceArr addObject:scgmqlhjzdModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jrmkjzzfxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jrmkjzzfxModel.title = @"进入门槛/竞争者分析";
            jrmkjzzfxModel.content = self.projectStatusModel.entryThreshold;
            jrmkjzzfxModel.isExpand = YES;
            if(self.projectStatusModel.entryThreshold && [self.projectStatusModel.entryThreshold length] > 0){
                [self.dataSourceArr addObject:jrmkjzzfxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * hyjgsnzzlModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            hyjgsnzzlModel.title = @"行业及公司年增长率";
            hyjgsnzzlModel.content = self.projectStatusModel.growthRate;
            hyjgsnzzlModel.isExpand = YES;
            if(self.projectStatusModel.growthRate && [self.projectStatusModel.growthRate length] > 0){
                [self.dataSourceArr addObject:hyjgsnzzlModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tlssgsjzfxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tlssgsjzfxModel.title = @"同类上市公司价值分析";
            tlssgsjzfxModel.content = self.projectStatusModel.similarListedValue;
            tlssgsjzfxModel.isExpand = YES;
            if(self.projectStatusModel.similarListedValue && [self.projectStatusModel.similarListedValue length] > 0){
                [self.dataSourceArr addObject:tlssgsjzfxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tcqdjsyycModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tcqdjsyycModel.title = @"退出渠道及收益预测";
            tcqdjsyycModel.content = self.projectStatusModel.exitChannel;
            tcqdjsyycModel.isExpand = YES;
            if(self.projectStatusModel.exitChannel && [self.projectStatusModel.exitChannel length] > 0){
                [self.dataSourceArr addObject:tcqdjsyycModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * fxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            fxModel.title = @"风险";
            fxModel.content = self.projectStatusModel.riskDesc;
            fxModel.isExpand = YES;
            if(self.projectStatusModel.riskDesc && [self.projectStatusModel.riskDesc length] > 0){
                [self.dataSourceArr addObject:fxModel];
            }
            //

            [self.listTableView reloadData];
        }else if ([JSON[@"status"] intValue] == 400) {
            CXIDGProjectStatusTableViewCellModel * ywjsModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            ywjsModel.title = @"业务介绍";
            ywjsModel.content = self.projectStatusModel.business;
            ywjsModel.isExpand = YES;
            if(self.projectStatusModel.business && [self.projectStatusModel.business length] > 0){
                [self.dataSourceArr addObject:ywjsModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * cwsjModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            cwsjModel.title = @"财务数据";
            cwsjModel.content = self.projectStatusModel.finData;
            cwsjModel.isExpand = YES;
            if(self.projectStatusModel.finData && [self.projectStatusModel.finData length] > 0){
                [self.dataSourceArr addObject:cwsjModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jhrzejgzxxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jhrzejgzxxModel.title = @"计划融资额及估值信息";
            jhrzejgzxxModel.content = self.projectStatusModel.finPlan;
            jhrzejgzxxModel.isExpand = YES;
            if(self.projectStatusModel.finPlan && [self.projectStatusModel.finPlan length] > 0){
                [self.dataSourceArr addObject:jhrzejgzxxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jstdjysModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jstdjysModel.title = @"技术特点及优势";
            jstdjysModel.content = self.projectStatusModel.technicalFeature;
            jstdjysModel.isExpand = YES;
            if(self.projectStatusModel.technicalFeature && [self.projectStatusModel.technicalFeature length] > 0){
                [self.dataSourceArr addObject:jstdjysModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tzldModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tzldModel.title = @"投资亮点";
            tzldModel.content = self.projectStatusModel.invHighlights;
            tzldModel.isExpand = YES;
            if(self.projectStatusModel.invHighlights && [self.projectStatusModel.invHighlights length] > 0){
                [self.dataSourceArr addObject:tzldModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tdjsModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tdjsModel.title = @"团队介绍";
            tdjsModel.content = self.projectStatusModel.teamDesc;
            tdjsModel.isExpand = YES;
            if(self.projectStatusModel.teamDesc && [self.projectStatusModel.teamDesc length] > 0){
                [self.dataSourceArr addObject:tdjsModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * gqjgModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            gqjgModel.title = @"股权结构";
            gqjgModel.content = self.projectStatusModel.ownershipStructure;
            gqjgModel.isExpand = YES;
            if(self.projectStatusModel.ownershipStructure && [self.projectStatusModel.ownershipStructure length] > 0){
                [self.dataSourceArr addObject:gqjgModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * sfdsjsxwModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            sfdsjsxwModel.title = @"是否董事/监事席位";
            sfdsjsxwModel.content = self.projectStatusModel.board;
            sfdsjsxwModel.isExpand = YES;
            if(self.projectStatusModel.board && [self.projectStatusModel.board length] > 0){
                [self.dataSourceArr addObject:sfdsjsxwModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * scgmqlhjzdModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            scgmqlhjzdModel.title = @"市场规模/潜力和集中度";
            scgmqlhjzdModel.content = self.projectStatusModel.marketDesc;
            scgmqlhjzdModel.isExpand = YES;
            if(self.projectStatusModel.marketDesc && [self.projectStatusModel.marketDesc length] > 0){
                [self.dataSourceArr addObject:scgmqlhjzdModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * jrmkjzzfxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            jrmkjzzfxModel.title = @"进入门槛/竞争者分析";
            jrmkjzzfxModel.content = self.projectStatusModel.entryThreshold;
            jrmkjzzfxModel.isExpand = YES;
            if(self.projectStatusModel.entryThreshold && [self.projectStatusModel.entryThreshold length] > 0){
                [self.dataSourceArr addObject:jrmkjzzfxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * hyjgsnzzlModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            hyjgsnzzlModel.title = @"行业及公司年增长率";
            hyjgsnzzlModel.content = self.projectStatusModel.growthRate;
            hyjgsnzzlModel.isExpand = YES;
            if(self.projectStatusModel.growthRate && [self.projectStatusModel.growthRate length] > 0){
                [self.dataSourceArr addObject:hyjgsnzzlModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tlssgsjzfxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tlssgsjzfxModel.title = @"同类上市公司价值分析";
            tlssgsjzfxModel.content = self.projectStatusModel.similarListedValue;
            tlssgsjzfxModel.isExpand = YES;
            if(self.projectStatusModel.similarListedValue && [self.projectStatusModel.similarListedValue length] > 0){
                [self.dataSourceArr addObject:tlssgsjzfxModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * tcqdjsyycModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tcqdjsyycModel.title = @"退出渠道及收益预测";
            tcqdjsyycModel.content = self.projectStatusModel.exitChannel;
            tcqdjsyycModel.isExpand = YES;
            if(self.projectStatusModel.exitChannel && [self.projectStatusModel.exitChannel length] > 0){
                [self.dataSourceArr addObject:tcqdjsyycModel];
            }
            
            CXIDGProjectStatusTableViewCellModel * fxModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            fxModel.title = @"风险";
            fxModel.content = self.projectStatusModel.riskDesc;
            fxModel.isExpand = YES;
            if(self.projectStatusModel.riskDesc && [self.projectStatusModel.riskDesc length] > 0){
                [self.dataSourceArr addObject:fxModel];
            }
            //

            [self.listTableView reloadData];
        }else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
//        [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];

    }              failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

@end
