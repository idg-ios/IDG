//
//  CXHouseProjectAnnexViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectAnnexViewController.h"
#import "CXIDGDJListModel.h"
#import "HttpTool.h"
#import "CXAnnexDownLoadTableViewCell.h"
#import "CXInternalBulletinDetailViewController.h"
#import "YWFilePreviewView.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXHouseProjectAnnexViewController ()<UITableViewDataSource, UITableViewDelegate, CXAnnexDownloadDelegate>
@property (nonatomic, strong)UITableView *listTableView;
@property (nonatomic, strong)NSMutableArray *listTableDataArray;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, strong)NSMutableArray *cellArray;


@end

@implementation CXHouseProjectAnnexViewController{
    NSInteger totalPageNumber;
    BOOL hasRightToDownload;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNumber = totalPageNumber = 1;
    [self.view addSubview:self.listTableView];
    self.view.backgroundColor = SDBackGroudColor;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self hasDownloadRight];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 业务逻辑
- (void)hasDownloadRight{
    NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/download/right.json", urlPrefix];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%zd", self.projId] forKey:@"projId"];
    [HttpTool postWithPath:url params:nil success:^(id JSON){
        if([JSON[@"status"]integerValue] == 200){
            hasRightToDownload = YES;
        }else if ([JSON[@"msg"]integerValue] == 400){
            hasRightToDownload = NO;
        }
        [self.listTableView.header beginRefreshing];
       
    } failure:^(NSError *error){
        CXAlert(@"获取下载权限失败");
        [self.listTableView.header beginRefreshing];
    }];
    
}
- (void)requestListData{
    NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/%zd/%zd.json", urlPrefix, self.projId, self.pageNumber];
    
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            if(self.pageNumber == 1){
                [self.listTableDataArray removeAllObjects];
                [self.listTableView reloadData];
            }
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CXIDGDJListModel class] json:JSON[@"data"]];
            if(tempArray){
                [self.listTableDataArray addObjectsFromArray:tempArray];
            }
            [self.listTableView reloadData];
            totalPageNumber = [JSON[@"pageCount"]integerValue];
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.view setNeedShowEmptyTipAndEmptyPictureByCount:self.listTableDataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
    }];
}
- (void)selectCellStatus:(CXAnnexDownLoadTableViewCell *)cell{
    if([cell.model isKindOfClass:[CXIDGDJListModel class]]){
        CXIDGDJListModel *cellModel = cell.model;
        CXAnnexDownloadModel *dataModel = [[CXAnnexDownloadModel alloc]init];
        dataModel.fileName = [NSString stringWithFormat:@"%@.%@",cellModel.boxId,cellModel.fileType];
        dataModel.resourceURLString = cellModel.boxId;
        cell.status = [[CXAnnexDownLoadManager sharedManager]fileDownloadSatus:dataModel];
    }
}
#pragma mark - tableView代理回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXIDGDJListModel *model = self.listTableDataArray[indexPath.row];
    if([[model.fileType lowercaseString] isEqualToString:@"pdf"]){
        CXInternalBulletinDetailViewController *vc = [[CXInternalBulletinDetailViewController alloc]initWithEid:model.boxId.integerValue type:isFJListH5 andTitle:model.attaName];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",model.boxId,model.fileType];
        BOOL fileIsExist = [[CXAnnexDownLoadManager sharedManager]fileIsExit:fileName];
        if(fileIsExist){
            NSString *filePath = [[CXAnnexDownLoadManager sharedManager]filePathOfDownloded:fileName];
            [YWFilePreviewView previewFileWithPaths:filePath andFileName:model.attaName];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listTableDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXAnnexDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[CXAnnexDownLoadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.model = self.listTableDataArray[indexPath.row];
    cell.projId = self.projId;
    cell.vc = self;
    cell.hasRightDownload = hasRightToDownload;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.cellArray containsObject:cell]){
        [self.cellArray addObject:cell];
    }
    [self selectCellStatus:(CXAnnexDownLoadTableViewCell *)cell];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*(Screen_Width/375.0);
}
#pragma mark - cell刷新回调
- (void)downloadModel:(CXAnnexDownloadModel *)downloadModel dowloadStatus:(downloadStatus)status{
    [self.cellArray enumerateObjectsUsingBlock:^(CXAnnexDownLoadTableViewCell *cell, NSUInteger idx, BOOL *stop){
        if([cell.model isKindOfClass:[CXIDGDJListModel class]]){
            CXIDGDJListModel *model = cell.model;
            if([model.boxId isEqualToString:downloadModel.resourceURLString]){
                cell.status = status;
            }
        }
    }];
}
#pragma mark - 数据懒加载
- (UITableView *)listTableView{
    if(nil == _listTableView){
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        CXWeakSelf(self);
        [_listTableView addLegendHeaderWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [weakself requestListData];
        }];
        [_listTableView addLegendFooterWithRefreshingBlock:^{
            if(weakself.pageNumber < totalPageNumber){
                weakself.pageNumber ++;
                [weakself requestListData];
            }else{
                [weakself.listTableView.footer endRefreshing];
            }
        }];
    }
    return _listTableView;
}
- (NSMutableArray *)listTableDataArray{
    if(nil == _listTableDataArray){
        _listTableDataArray = @[].mutableCopy;
    }
    return _listTableDataArray;
}
- (NSMutableArray *)cellArray{
    if(nil == _cellArray){
        _cellArray = @[].mutableCopy;
    }
    return _cellArray;
}
@end
