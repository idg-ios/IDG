//
//  CXHouseProjectListViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectListViewController.h"
#import "CXHouseProjectModel.h"
#import "CXHouseProjectModelFrame.h"
#import "HttpTool.h"
#import "CXHouseProjectListTableViewCell.h"
#import "CXHouseProjectDetailRootViewController.h"
#import "MJRefresh.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXHouseProjectListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)SDRootTopView *rootTopView;
@property (nonatomic, strong)UITableView *listTableView;
@property (nonatomic, strong)NSMutableArray *listDataArray;
@property (nonatomic, strong)NSMutableArray *frameArrays;
@property (nonatomic, assign)NSInteger pageNumber;

@end

@implementation CXHouseProjectListViewController{
    NSInteger totalPage;
}
static dispatch_queue_t queue;
- (void)viewDidLoad {
    [super viewDidLoad];
    totalPage = self.pageNumber = 1;
    self.view.backgroundColor = kColorWithRGB(255, 255, 255);
    queue = dispatch_queue_create("com.CXHouseProjectListView", DISPATCH_QUEUE_SERIAL);
    [self.view addSubview:self.rootTopView];
    [self.view addSubview:self.listTableView];
    [self.listTableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //需求变更
//    [self.listTableView.header beginRefreshing];
}
- (void)requestListData{
    NSString *url = [NSString stringWithFormat:@"%@project/house/list/%zd.json", urlPrefix, self.pageNumber];
    
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            totalPage = [JSON[@"pageCount"]integerValue];
            if(self.pageNumber == 1){
                [self.listDataArray removeAllObjects];
                [self.listTableView reloadData];
            }
            //修改没有更多数据的样式
            BOOL notHaveNextPage = totalPage < self.pageNumber;
            [self.listTableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CXHouseProjectModel class] json:JSON[@"data"]];
      
            if(tempArray){
                [self.listDataArray addObjectsFromArray:tempArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getFrameArray:tempArray];
                });
            }
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
    }];
}
- (void)getFrameArray:(NSArray *)addArray{
    if(!self.listDataArray.count){
        [self.listTableView reloadData];
        return;
    }
    [addArray enumerateObjectsUsingBlock:^(CXHouseProjectModel *model , NSUInteger idx, BOOL *stop){
        CXHouseProjectModelFrame *frame = [[CXHouseProjectModelFrame alloc]init];
        frame.model = model;
        [self.frameArrays addObject:frame];
    }];
    if(self.frameArrays.count){
        [self.listTableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kColorWithRGB(255, 255, 255);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXHouseProjectModelFrame *frame = self.frameArrays[indexPath.section];
    return frame.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXHouseProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[CXHouseProjectListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.dataFrame = self.frameArrays[indexPath.section];

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.f, 5.f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = cell.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.layer.mask = maskLayer;
    
    if([cell isKindOfClass:[CXHouseProjectListTableViewCell class]]){
        [cell setValue:self.frameArrays[indexPath.section] forKey:@"dataFrame"];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXHouseProjectModel *model = self.listDataArray[indexPath.section];
    CXHouseProjectDetailRootViewController *vc = [[CXHouseProjectDetailRootViewController alloc]init];
    vc.projId = model.projId;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (SDRootTopView *)rootTopView{
    if(nil == _rootTopView){
        _rootTopView = [self getRootTopView];
        [_rootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
        [_rootTopView setNavTitle:self.titleName];
    }
    return _rootTopView;
}

- (UITableView *)listTableView{
    if(nil == _listTableView){
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(15*uinitpx, navHigh, Screen_Width- 30*uinitpx, Screen_Height - navHigh) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = kColorWithRGB(255, 255, 255);
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.showsVerticalScrollIndicator = NO;
        CXWeakSelf(self);
        [_listTableView addLegendHeaderWithRefreshingBlock:^(){
            weakself.pageNumber = 1;
            [weakself requestListData];
        }];
        [_listTableView addLegendFooterWithRefreshingBlock:^(){
            if(weakself.pageNumber < totalPage){
                weakself.pageNumber ++;
                [weakself requestListData];
            }else{
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
                [weakself.listTableView.footer endRefreshing];
            }
        }];
    }
    return _listTableView;
}

- (NSMutableArray *)listDataArray{
    if(nil == _listDataArray){
        _listDataArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _listDataArray;
}
- (NSMutableArray *)frameArrays{
    if(nil == _frameArrays){
        _frameArrays = @[].mutableCopy;
    }
    return _frameArrays;
}

@end
