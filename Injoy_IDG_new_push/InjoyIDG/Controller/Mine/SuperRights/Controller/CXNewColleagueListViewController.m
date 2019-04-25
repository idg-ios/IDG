//
//  CXNewColleagueListViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNewColleagueListViewController.h"
#import "CXNewColleagueModel.h"
#import "CXNewColleagueCell.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "HttpTool.h"
#import "CXUserSelectController.h"

@interface CXNewColleagueListViewController () <UITableViewDataSource, UITableViewDelegate, CXNewColleagueCellDelegate>

/** <#comment#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#comment#> */
@property (nonatomic, copy) NSArray<CXNewColleagueModel *> *dataList;

@end

#define kColleageCellId @"CXNewColleagueCell"

@implementation CXNewColleagueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.tableView.header beginRefreshing];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"新同事"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(leftBarItemOnTap)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        [tableView disableTouchesDelay];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[CXNewColleagueCell class] forCellReuseIdentifier:kColleageCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewColleagueList)];
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXNewColleagueCell *cell = [tableView dequeueReusableCellWithIdentifier:kColleageCellId];
    CXNewColleagueModel *colleague = self.dataList[indexPath.row];
    cell.colleageModel = colleague;
    cell.delegate = self;
    return cell;
}

#pragma mark - CXNewColleagueCellDelegate
- (void)newColleagueCell:(CXNewColleagueCell *)cell willHandle:(BOOL)isAgree atIndexPath:(NSIndexPath *)indexPath {
    CXNewColleagueModel *colleague = self.dataList[indexPath.row];
    
    NSMutableDictionary *params = @{
                             @"eid": @(colleague.eid),
                             @"status" : @(isAgree ? 1 : 2)
                             }.mutableCopy;
    
    // 同意需要选择一个上级
    if (isAgree) {
        CXUserSelectController *vc = [[CXUserSelectController alloc] init];
        vc.title = @"选择上级";
        vc.multiSelect = NO;
        vc.displayOnly = NO;
        vc.selectType = SuperiorType;
        vc.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
            if (users.count <= 0) {
                return;
            }
            params[@"pid"] = @(users.firstObject.eid);
            [self handleNewColleagueWithParams:params status200Callback:^{
                NSMutableArray<CXNewColleagueModel *> *newArray = [NSMutableArray arrayWithArray:self.dataList];
                [newArray removeObjectAtIndex:indexPath.row];
                self.dataList = newArray;
                [self.tableView reloadData];
                !self.onPostSuccess ?: self.onPostSuccess();
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self handleNewColleagueWithParams:params status200Callback:^{
            NSMutableArray<CXNewColleagueModel *> *newArray = [NSMutableArray arrayWithArray:self.dataList];
            [newArray removeObjectAtIndex:indexPath.row];
            self.dataList = newArray;
            [self.tableView reloadData];
            !self.onPostSuccess ?: self.onPostSuccess();
        }];
    }
}

#pragma mark - Private

- (void)leftBarItemOnTap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getNewColleagueList {
    [HttpTool postWithPath:@"/sysuser/new/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.dataList = [NSArray yy_modelArrayWithClass:[CXNewColleagueModel class] json:JSON[@"data"]];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataList.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.tableView.header endRefreshing];
    }];
}

- (void)handleNewColleagueWithParams:(NSMutableDictionary *)params status200Callback:(void(^)())callback {
    HUD_SHOW(nil);
    [HttpTool postWithPath:@"/sysuser/new/approval.json" params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            !callback ?: callback();
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
