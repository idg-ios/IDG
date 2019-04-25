//
//  CXBussinessTripListViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBussinessTripListViewController.h"
#import "HttpTool.h"
#import "UIView+YYAdd.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "YYModel.h"
#import "CXBussinessTripListModel.h"
#import "CXTopSwitchView.h"
#import "CXVacationApplicationListCell.h"
#import "CXBussinessTripListCell.h"
#import "CXBussinessTripListCellFrame.h"
#import "CXBusinessTripCityModel.h"
#import "CXBussinessTripEditViewController.h"

#import "MBProgressHUD+CXCategory.h"

#define topSwitchHeight 50.f
typedef NS_ENUM(NSInteger, PSZT) {
    approvaling = 1,
    approvaled = 2,
    unApprovaled = 3
    
};
@interface CXBussinessTripListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)SDRootTopView *rootTopView;
@property(nonatomic, strong)UITableView *listTableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger pageNumber;
@property(nonatomic, strong)CXTopSwitchView *topSwithView;
@property(nonatomic, strong)NSMutableArray *heightArray;
@property(nonatomic, assign)PSZT type;
@property(nonatomic, strong)NSArray *frameArrays;
@property(nonatomic, strong)NSArray *cityArray;
@end

static NSString *const CXBussinessTripListCellIdentity = @"CXBussinessTripListCellIdentity";
@implementation CXBussinessTripListViewController{
    NSInteger totalPage;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //页面返回,重新请求数据
    self.pageNumber = 1;
    if(self.lbType == CXBusinessTripPS){
        [self requestPSDataFromServer];
    }else{
        [self requestDataFromServer:self.type];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];//MVVM设计
    [self.view addSubview:self.rootTopView];
    if(self.lbType != CXBusinessTripPS){
        [self.view addSubview:self.topSwithView];
    }
    [self.view addSubview:self.listTableView];
    self.pageNumber = totalPage = 1;
    self.type = approvaling;
    [self requestCitiesForTrip];
  
    // Do any additional setup after loading the view.
}
#pragma mark - 业务方法
- (void)requestDataFromServer:(PSZT)type{
    NSString *url = [NSString stringWithFormat:@"%@travel/list/%zd.json", urlPrefix, self.pageNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%zd", type] forKey:@"isApprove"];
    if(self.pageNumber == 1){
        [self.dataArray removeAllObjects];
        [self.listTableView reloadData];
    }
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        if([JSON[@"status"]integerValue] == 200){
            totalPage = [JSON[@"pageCount"]integerValue];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CXBussinessTripListModel class] json:JSON[@"data"]];
            if(tempArray){
                [self.dataArray addObjectsFromArray:tempArray];
                [self createCityName];
                [self.listTableView reloadData];

            }
            
            
        }  else if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        
         [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
    }];
}
- (void)requestPSDataFromServer{
    NSString *url = [NSString stringWithFormat:@"%@travel/approveList/%zd.json",urlPrefix,self.pageNumber];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            totalPage = [JSON[@"pageCount"]integerValue];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CXBussinessTripListModel class] json:JSON[@"data"]];
            if(tempArray){
                if(self.pageNumber == 1){
                    [self.dataArray removeAllObjects];
                    [self.listTableView reloadData];
                }
                [self.dataArray addObjectsFromArray:tempArray];
                [self createCityName];
                [self.listTableView reloadData];
            }
            
            
        }   else if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView.header endRefreshing];
            [self.listTableView.footer endRefreshing];
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
            
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView setNeedShowEmptyTipByCount:self.dataArray.count];
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        
         [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
    }];
}
- (void)requestCitiesForTrip{
    NSString *url = [NSString stringWithFormat:@"%@travel/cityList.json",urlPrefix];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool getWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            self.cityArray = [NSArray yy_modelArrayWithClass:[CXBusinessTripCityModel class] json:JSON[@"data"]];
        }else{
            CXAlert(JSON[@"msg"]);
        }
        if(self.lbType == CXBusinessTripPS){
            [self requestPSDataFromServer];
        }else{
            [self requestDataFromServer:self.type];
        }
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(@"出差城市列表获取失败");
        if(self.lbType == CXBusinessTripPS){
            [self requestPSDataFromServer];
        }else{
            [self requestDataFromServer:self.type];
        }
    }];
}
- (void)createCityName{
    if(!self.cityArray.count){
        return;
    }
    [self.dataArray enumerateObjectsUsingBlock:^(CXBussinessTripListModel *model, NSUInteger idx, BOOL *stop){
        if(model.budget == nil){
            model.budget = [NSDecimalNumber zero];
        }
        NSArray *cityIdArray = model.city.copy;
        SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithAccount:model.apply];
        NSString *realName = userModel.name?:@"";
        model.realName = realName?:@"";
        NSMutableArray *cityNameArray = [NSMutableArray array];
        [cityIdArray enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stops){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.id = %@",object];
            CXBusinessTripCityModel *city = [self.cityArray filteredArrayUsingPredicate:predicate].firstObject;
            if(city){
                [cityNameArray addObject:city.name];
            }else{
                [cityNameArray addObject:[NSString stringWithFormat:@"%@",object]];
            }
        }];
        NSString *cName = [cityNameArray componentsJoinedByString:@","];
        model.cityName = cName;
    }];
}
#pragma mark - UITableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXBussinessTripListModel *model = self.dataArray[indexPath.row];
    CXBussinessTripEditViewController *vc = [[CXBussinessTripEditViewController alloc]init];
    vc.eid = model.businessId;
    vc.approvalStatue = self.type;
    @weakify(self);
    if(self.lbType == CXBusinessTripPS){
        vc.type = isApproval;
        vc.applyId = model.applyId;
    }else{
        vc.type = isDetail;
    }
    vc.callBack = ^{
        @strongify(self);
        [self.listTableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if([cell isKindOfClass:[CXBussinessTripListCell class]]){
//        CXBussinessTripListCell *listCell = (CXBussinessTripListCell *)cell;
//        listCell.dataFrame = self.frameArrays[indexPath.row];
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXBussinessTripListCell *cell = [tableView dequeueReusableCellWithIdentifier:CXBussinessTripListCellIdentity forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
//        CXBussinessTripListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (nil == cell) {
//            cell = [[CXBussinessTripListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    //    cell.dataFrame = self.frameArrays[indexPath.row];
//        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CXBussinessTripListCellFrame *frame = self.frameArrays[indexPath.row];
//    return frame.cellHeight;
    return UITableViewAutomaticDimension;
}
#pragma mark - 数据懒加载
- (SDRootTopView *)rootTopView{
    if(nil == _rootTopView){
        _rootTopView = [self getRootTopView];
        if(self.lbType == CXBusinessTripPS){
            [_rootTopView setNavTitle:@"差旅审批"];
        }else{
            [_rootTopView setNavTitle:@"我的出差"];
        }
        [_rootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
//        [_rootTopView setUpRightBarItemTitle:@"添加" addTarget:self action:@selector(addTap)];
    }
    return _rootTopView;
}
- (UITableView *)listTableView{
    if(nil == _listTableView){
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHigh+topSwitchHeight, Screen_Width, Screen_Height-navHigh-topSwitchHeight) style:UITableViewStylePlain];
        if(self.lbType == CXBusinessTripPS){
            _listTableView.top = navHigh;
            _listTableView.height = Screen_Height-navHigh;
        }
        _listTableView.separatorColor = kColorWithRGB(163, 163, 163);
        _listTableView.backgroundColor = kColorWithRGB(255, 255, 255);
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.estimatedRowHeight = 150;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.separatorInset = UIEdgeInsetsZero;
        [_listTableView registerClass:[CXBussinessTripListCell class] forCellReuseIdentifier:CXBussinessTripListCellIdentity];
        CXWeakSelf(self)
        [_listTableView addLegendHeaderWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            if(weakself.lbType == CXBusinessTripPS){
                [weakself requestPSDataFromServer];
            }else{
                [weakself requestDataFromServer:weakself.type];
            }
        }];
      
        [_listTableView addLegendFooterWithRefreshingBlock:^{
            if(weakself.pageNumber<totalPage){
                weakself.pageNumber++;
                if(weakself.lbType == CXBusinessTripPS){
                    [weakself requestPSDataFromServer];
                }else{
                    [weakself requestDataFromServer:weakself.type];
                }
            }else{
                CXAlert(@"没有更多数据了");
                [weakself.listTableView.footer endRefreshing];
            }
        }];
        
    }
    return _listTableView;
}

- (NSMutableArray *)dataArray{
    if(nil == _dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)heightArray{
    if(nil == _heightArray){
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
- (CXTopSwitchView *)topSwithView{
    if(nil == _topSwithView){
        _topSwithView = [[CXTopSwitchView alloc]initWithFrames:CGRectMake(0, navHigh, Screen_Width, topSwitchHeight)];
        CXWeakSelf(self)
        _topSwithView.callBack = ^(NSString *title){
            weakself.pageNumber = 1;
            if([title isEqualToString: @"同意"]){
                weakself.type = approvaled;
                [weakself requestDataFromServer:approvaled];
            }else if ([title isEqualToString:@"审批中"]){
                weakself.type = approvaling;
                [weakself requestDataFromServer:approvaling];
            }else if ([title isEqualToString:@"驳回"]){
                weakself.type = unApprovaled;
                [weakself requestDataFromServer:unApprovaled];
                
            }
        };
    }
    return _topSwithView;
}
- (NSArray *)frameArrays{
   __block NSMutableArray *tempArray = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(CXBussinessTripListModel *model, NSUInteger idx, BOOL *stop){
        CXBussinessTripListCellFrame *frame = [[CXBussinessTripListCellFrame alloc]init];
        frame.dataModel = model;
        [tempArray addObject:frame];
        _frameArrays = tempArray.copy;
    }];
    return _frameArrays;
}
- (NSArray *)cityArray{
    if(nil == _cityArray){
        _cityArray = @[].copy;
    }
    return _cityArray;
}
@end
