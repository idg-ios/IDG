//
//  CXDDXVoiceMeetingListViewController.m
//  InjoyDDXXST
//
//  Created by wtz on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXVoiceMeetingListViewController.h"
#import "CXTopView.h"
#import "Masonry.h"
#import "CXGroupSelectContactViewController.h"
#import "CXIMHelper.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXDDXVoiceMeetingListModel.h"
#import "CXDDXVoiceMeetingListCell.h"
#import "CXDDXVoiceMeetingDetailViewController.h"
#import "CXInputDialogView.h"
#import "UIView+CXCategory.h"


@interface CXDDXVoiceMeetingListViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;

@property(weak, nonatomic) CXTopView *topView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXDDXVoiceMeetingListModel *> *dataSourceArr;
/** 已选用户 */
@property(copy, nonatomic) NSArray *selectUserArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXDDXVoiceMeetingListViewController

#pragma mark - get & set

- (NSMutableArray<CXDDXVoiceMeetingListModel *> *)dataSourceArr {
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
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"语音会议"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopView {
    CXTopView *topView = [[CXTopView alloc] initWithTitles:@[@"发起会议", @"查找会议"] style:withoutBlueColor];
    topView.callBack = ^(NSString *title) {
        if ([@"发起会议" isEqualToString:title]) {
            [self showHudInView:self.view hint:nil];
            //发起会议
            __weak typeof(self) weakSelf = self;
            CXGroupSelectContactViewController *selectColleaguesViewController = [[CXGroupSelectContactViewController alloc] init];
            selectColleaguesViewController.navTitle = @"发起会议";
            selectColleaguesViewController.filterUsersArray = @[[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:[AppDelegate getUserHXAccount]]];
            selectColleaguesViewController.selectContactUserCallBack = ^(NSArray *selectContactUserArr) {
                weakSelf.selectUserArr = [selectContactUserArr copy];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置会议名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alertView.tag = 1001;
                [alertView show];
            };
            [self.navigationController pushViewController:selectColleaguesViewController animated:YES];
            [self hideHud];
        }
        if ([@"查找会议" isEqualToString:title]) {
            CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
            dialogView.onApplyWithContent = ^(NSString *content) {
                self.searchText = content;
                [self getListWithPage:1];
            };
            [dialogView show];
        }
    };
    self.topView = topView;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self getRootTopView].mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CXTopViewHeight);
    }];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.topView.mas_bottom).offset(10.f);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    @weakify(self)
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self)
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }];
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self)
        [self getListWithPage:self.pageNumber + 1];
    }];
    [self.listTableView.footer setHidden:YES];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getListWithPage:self.pageNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXDDXVoiceMeetingListModel *model = [self.dataSourceArr objectAtIndex:indexPath.row];
    //跳转到语音会议界面
    CXDDXVoiceMeetingDetailViewController *voiceMeetingDetailViewController = [[CXDDXVoiceMeetingDetailViewController alloc] initWithCXDDXVoiceMeetingListModel:model];
    [self.navigationController pushViewController:voiceMeetingDetailViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXDDXVoiceMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXDDXVoiceMeetingListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [cell setCXDDXVoiceMeetingListModel:self.dataSourceArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDCellHeight;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        if(alertView.tag == 1001){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    } else {
        UITextField *textFd = [alertView textFieldAtIndex:0];
        if (!textFd.text.length) {
            [self.view makeToast:@"语音会议名称不能为空！" duration:2 position:@"center"];
            return;
        } else {
            if([self.selectUserArr count] > 39){
                [self.view makeToast:@"语音会议人数最多40人，请重新选择！" duration:2 position:@"center"];
                return;
            }
            [self showHudInView:self.view hint:@"正在创建语音会议"];
            __weak typeof(self) weakSelf = self;
            NSString *url = [NSString stringWithFormat:@"%@vedioMeet/save", urlPrefix];
            NSMutableDictionary *params = @{}.mutableCopy;
            if (self.selectUserArr && [self.selectUserArr count] > 0) {
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                for (SDCompanyUserModel *userModel in self.selectUserArr) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:[NSString stringWithFormat:@"%ld", (long) [userModel.eid integerValue]] forKey:@"eid"];
                    [dic setValue:userModel.name forKey:@"name"];
                    [dic setValue:userModel.imAccount forKey:@"imAccount"];
                    [dataArray addObject:dic];
                }
                NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
                [params setValue:[[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding] forKey:@"cc"];
            }
            SDCompanyUserModel *myUserModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
            [params setValue:myUserModel.userId forKey:@"ygId"];
            [params setValue:myUserModel.name forKey:@"ygName"];
            [params setValue:VAL_DpId forKey:@"ygDeptId"];
            [params setValue:myUserModel.deptName forKey:@"ygDeptName"];
            [params setValue:myUserModel.job forKey:@"ygJob"];
            [params setValue:textFd.text forKey:@"title"];
            [HttpTool postWithPath:url params:params success:^(id JSON) {
                [weakSelf hideHud];
                NSDictionary *jsonDict = JSON;
                if ([jsonDict[@"status"] integerValue] == 200) {
                    //跳转到语音会议界面
                    CXDDXVoiceMeetingListModel *model = [[CXDDXVoiceMeetingListModel alloc] init];
                    model.eid = @([JSON[@"data"][@"eid"] integerValue]);
                    CXDDXVoiceMeetingDetailViewController *voiceMeetingDetailViewController = [[CXDDXVoiceMeetingDetailViewController alloc] initWithCXDDXVoiceMeetingListModel:model];
                    [self.navigationController pushViewController:voiceMeetingDetailViewController animated:YES];
                    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                    }
                }
//                else if ([jsonDict[@"status"] integerValue] == 400){
//                    [self.view setNeedShowAttentionAndEmptyPictureText:jsonDict[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//                }
                else {
                    [self.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
                }
            }              failure:^(NSError *error) {
                [weakSelf hideHud];
                [self.view makeToast:KNetworkFailRemind duration:2 position:@"center"];
            }];
        }
    }
}

#pragma mark <---请求列表--->

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@vedioMeet/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.footer setHidden:!hasNextPage];
            NSArray<CXDDXVoiceMeetingListModel *> *data = [NSArray yy_modelArrayWithClass:[CXDDXVoiceMeetingListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            [self.listTableView reloadData];
        }else if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipByCount:self.dataSourceArr.count];
    }              failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipByCount:self.dataSourceArr.count];
    }];
}

@end
