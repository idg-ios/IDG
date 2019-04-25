//
//  CXIDGFJListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGFJListViewController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "CXIDGDJListModel.h"
#import "HttpTool.h"
#import "YWFilePreviewController.h"
#import "YWFilePreviewView.h"
#import "UIView+CXCategory.h"
#import "CXAnnexDownLoadTableViewCell.h"
#import "CXInternalBulletinDetailViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXIDGFJListViewController ()<UITableViewDelegate, UITableViewDataSource, CXAnnexDownloadDelegate>
@property(nonatomic, strong)UITableView *listTableView;
@property(nonatomic, strong)NSMutableArray <CXIDGDJListModel*>*listTableArray;
@property(nonatomic, assign)NSInteger pageNumber;
@property(nonatomic, assign)bool hasRightDownload;
@property(nonatomic, strong)NSMutableArray *cellArray;
@end

@implementation CXIDGFJListViewController{
    NSInteger totalPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    self.pageNumber = totalPage = 1;
    [self.view addSubview:self.listTableView];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    [self hasRightToDownLoad];
}
#pragma mark - deal method
-(void)requestDataFromServer{
    NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/%zd/%zd.json",urlPrefix, self.eid, self.pageNumber];
//    HUD_SHOW(nil)
    if(self.pageNumber == 1){
        [self.listTableArray removeAllObjects];
        [self.listTableView reloadData];
    }
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];
    [HttpTool postWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

//        HUD_HIDE
        if([JSON[@"status"]integerValue] == 200){
            totalPage = [JSON[@"pageCount"]integerValue];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CXIDGDJListModel class] json:JSON[@"data"]];
            NSAssert(tempArray, @"IDGFJListViewController requestDataFromServer Failed ");
            [self.listTableArray addObjectsFromArray:tempArray];
            [self.listTableView reloadData];
            
//            [self.listTableView setNeedShowAttentionAndEmptyPictureText:@"暂无数据" AndPictureName:@"pic_kzt_wsj"];
        }
        else if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView.header endRefreshing];
            [self.listTableView.footer endRefreshing];
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//            [self.listTableView setNeedShowAttentionAndEmptyPictureText:@"暂无数据" AndPictureName:@"pic_kzt_wsj"];

        }
        else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.listTableArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];

    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

//        HUD_HIDE
        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.listTableArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];

    }];
}
-(NSString *)transferTime:(NSString *)time{
    if(!trim(time).length){
        NSLog(@"没有时间！");
        return @"";
    }else{
        NSTimeInterval timeInterval = [time doubleValue]/1000.0;
        NSDate *dates = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
        fomatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        time = [fomatter stringFromDate:dates];
        return time;
    }
}
-(NSString *)fileIsExist:(CXIDGDJListModel *)model{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [docDir stringByAppendingPathComponent:FJPath];
    bool isDir = NO;
    if(![fileManager fileExistsAtPath:filePath isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        if(!isDir){
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",model.boxId,model.fileType];
            filePath = [filePath stringByAppendingPathComponent:fileName];
            if([fileManager fileExistsAtPath:filePath]){
                return filePath;
            }
        }
    }
    return nil;
}
-(void)hasRightToDownLoad{
    NSString *url = [NSString stringWithFormat:@"%@project/detail/annex/download/right.json",urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%zd",self.eid] forKey:@"projId"];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            self.hasRightDownload = YES;
            [self.listTableView.header beginRefreshing];
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.listTableView.header endRefreshing];
//            [self.listTableView.footer endRefreshing];
//            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            [self.listTableView.header beginRefreshing];
        }

    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(@"获取下载权限失败");
        self.hasRightDownload = NO;
        [self.listTableView.header beginRefreshing];
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
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXIDGDJListModel *model = self.listTableArray[indexPath.row];
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
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listTableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXAnnexDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[CXAnnexDownLoadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.model = self.listTableArray[indexPath.row];
    cell.projId = self.eid;
    cell.vc = self;
    cell.hasRightDownload = self.hasRightDownload;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*(Screen_Width/375.0);
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.cellArray containsObject:cell]){
        [self.cellArray addObject:cell];
    }
    [self selectCellStatus:(CXAnnexDownLoadTableViewCell *)cell];
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
#pragma mark - lazy load
-(UITableView *)listTableView{
    if(nil == _listTableView){
        _listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        CXWeakSelf(self)
        [_listTableView addLegendHeaderWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [weakself requestDataFromServer];
            
        }];
        [_listTableView addLegendFooterWithRefreshingBlock:^{
            if(weakself.pageNumber<totalPage){
                weakself.pageNumber ++;
                [weakself requestDataFromServer];
            }else{
                [weakself.listTableView.footer endRefreshing];
            }
        }];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = SDBackGroudColor;
    }
    return _listTableView;
}
-(NSMutableArray <CXIDGDJListModel *>*)listTableArray{
    if(nil == _listTableArray){
        _listTableArray = @[].mutableCopy;
    }
    return _listTableArray;
}
-(NSMutableArray *)cellArray{
    if(nil == _cellArray){
        _cellArray = @[].mutableCopy;
    }
    return _cellArray;
}
@end
