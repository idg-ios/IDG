//
//  CXNoteCollectionListViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoteCollectionListViewController.h"
#import "MJRefresh.h"
#import "CXNoteCollectionCell.h"
#import "CXMineFormBuilder.h"
#import "HttpTool.h"
#import "NSDictionary+CXCategory.h"
#import "UIView+CXCategory.h"

@interface CXNoteCollectionListViewController () <UITableViewDataSource, UITableViewDelegate>

/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 表单创建器 */
@property (nonatomic, strong) CXMineFormBuilder *builder;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 列表数据 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *listData;

@end

@implementation CXNoteCollectionListViewController

- (NSMutableArray<NSDictionary *> *)listData {
    if (!_listData) {
        _listData = @[].mutableCopy;
    }
    return _listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.tableView.header beginRefreshing];
}

- (void)setup {
    [self.RootTopView setNavTitle:self.title];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(leftBarItemOnTap)];
    [self.RootTopView setUpRightBarItemImage:Image(@"add") addTarget:self action:@selector(rightBarItemOnTap)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView addLegendHeaderWithRefreshingBlock:^{
            self.page = 1;
            [self getListWithPage:1];
        }];
        [tableView addLegendFooterWithRefreshingBlock:^{
            [self getListWithPage:self.page + 1];
        }];
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CXNoteCollectionCell heightOfListType:self.listType];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.listData[indexPath.row];
    static NSString *ID = @"CXNoteCollectionCell";
    CXNoteCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CXNoteCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID listType:self.listType];
    }
    // 公司账号
    if (self.listType == CXNoteCollectionListTypeCompanyAccount) {
        cell.labels[0].text = [NSString stringWithFormat:@"公司名称：%@", data[@"companyName"]];
        cell.labels[1].text = [NSString stringWithFormat:@"开户行：%@", data[@"openBank"]];
        cell.labels[2].text = [NSString stringWithFormat:@"账号：%@", data[@"accountNum"]];
    }
    // 开票信息
    else if (self.listType == CXNoteCollectionListTypeBilling) {
        cell.labels[0].text = [NSString stringWithFormat:@"公司名称：%@", data[@"companyName"]];
        cell.labels[1].text = [NSString stringWithFormat:@"纳税号：%@", data[@"taxNumber"]];
        cell.labels[2].text = [NSString stringWithFormat:@"开户行：%@", data[@"openBank"]];
    }
    // 公司地址
    else if (self.listType == CXNoteCollectionListTypeCompanyAddress) {
        cell.labels[0].text = [NSString stringWithFormat:@"公司名称：%@", data[@"companyName"]];
        cell.labels[1].text = [NSString stringWithFormat:@"公司地址：%@", data[@"address"]];
        cell.labels[2].text = [NSString stringWithFormat:@"公司电话：%@", data[@"telephone"]];
        cell.labels[1].textColor = cell.labels[2].textColor = kColorWithRGB(120, 120, 120);
    }
    // 个人卡号
    else if (self.listType == CXNoteCollectionListTypeCardNumber) {
        cell.labels[0].text = [NSString stringWithFormat:@"卡号：%@", data[@"card"]];
        cell.labels[1].text = [NSString stringWithFormat:@"开户行：%@", data[@"bank"]];
        cell.labels[2].text = [NSString stringWithFormat:@"客服电话：%@", data[@"telephone"]];
        cell.labels[1].textColor = cell.labels[2].textColor = kColorWithRGB(120, 120, 120);
    }
    // 证件号码
    else if (self.listType == CXNoteCollectionListTypeIdNumber) {
        cell.labels[0].text = [NSString stringWithFormat:@"证件类型：%@", data[@"type"]];
        cell.labels[1].text = [NSString stringWithFormat:@"证件号码：%@", data[@"idNumber"]];
    }
    // 物流地址
    else if (self.listType == CXNoteCollectionListTypeLogisticsAddress) {
        cell.labels[0].text = [NSString stringWithFormat:@"收件人：%@", data[@"addressee"]];
        cell.labels[1].text = [NSString stringWithFormat:@"联系电话：%@", data[@"telephone"]];
        cell.labels[2].text = [NSString stringWithFormat:@"收件地址：%@", data[@"receiveAddress"]];
    }
    // 其他
    else if (self.listType == CXNoteCollectionListTypeOther) {
        cell.labels[0].text = [NSString stringWithFormat:@"标题：%@", data[@"title"]];
        cell.labels[1].text = [NSString stringWithFormat:@"创建时间：%@", data[@"createTime"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.listData[indexPath.row];
    NSUInteger eid = [data[@"eid"] unsignedIntegerValue];
    NSArray<NSString *> *detailUrls = @[
                                      @"/companyAccount/detail/{eid}.json",
                                      @"/invoice/detail/{eid}.json",
                                      @"/companyAddress/detail/{eid}.json",
                                      @"/personageCard/detail/{eid}.json",
                                      @"/idNumber/detail/{eid}.json",
                                      @"/logiAddress/detail/{eid}.json",
                                      @"/other/detail/{eid}.json"
                                      ];
    NSString *url = detailUrls[self.listType];
    url = [url stringByReplacingOccurrencesOfString:@"{eid}" withString:@(eid).stringValue];
    
    UIViewController *formVC = [self makeFormControllerWithType:CXFormTypeModify];
    self.builder.eid = eid;
    self.builder.detailUrl = url;
    [self.navigationController pushViewController:formVC animated:YES];
}

#pragma mark - Private
- (void)getListWithPage:(NSInteger)page {
    NSArray<NSString *> *listUrls = @[
                                    @"/companyAccount/list/{pageNumber}.json",
                                    @"/invoice/list/{pageNumber}.json",
                                    @"/companyAddress/list/{pageNumber}.json",
                                    @"/personageCard/list/{pageNumber}.json",
                                    @"/idNumber/list/{pageNumber}.json",
                                    @"/logiAddress/list/{pageNumber}.json",
                                    @"/other/list/{pageNumber}.json"
                                    ];
    NSString *url = listUrls[self.listType];
    url = [url stringByReplacingOccurrencesOfString:@"{pageNumber}" withString:@(page).stringValue];
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            if (page == 1) {
                [self.listData removeAllObjects];
            }
            BOOL hasNextPage = [JSON[@"pageCount"] integerValue] > page;
            self.tableView.footer.hidden = hasNextPage == NO;
            NSArray<NSDictionary *> *data = JSON[@"data"];
            [data makeObjectsPerformSelector:@selector(removeNSNull)];
            [self.listData addObjectsFromArray:data];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.listData.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        if (page == 1) {
            [self.tableView.header endRefreshing];
        }
        else {
            [self.tableView.footer endRefreshing];
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
        if (page == 1) {
            [self.tableView.header endRefreshing];
        }
        else {
            [self.tableView.footer endRefreshing];
        }
    }];
}

- (void)leftBarItemOnTap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarItemOnTap {
    UIViewController *formVC = [self makeFormControllerWithType:CXFormTypeCreate];
    [self.navigationController pushViewController:formVC animated:YES];
}

- (UIViewController *)makeFormControllerWithType:(CXFormType)formType {
    self.builder = ({
        CXMineFormBuilder *builder = [[CXMineFormBuilder alloc] init];
        builder.formType = formType;
        builder.title = self.title;
        builder;
    });
    CXMineFormBuilder *formBuilder = self.builder;
    
    // 公司账号
    if (self.listType == CXNoteCollectionListTypeCompanyAccount) {
        formBuilder.submitUrl = @"/companyAccount/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司名称：" filedName:@"companyName" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"开  户  行：" filedName:@"openBank" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"　　账号：" filedName:@"accountNum" inputType:CXEditLabelInputTypeText]];
    }
    // 开票信息
    else if (self.listType == CXNoteCollectionListTypeBilling) {
        formBuilder.submitUrl = @"/invoice/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司名称：" placeholder:@"请输入公司名称" filedName:@"companyName" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"纳  税  号：" placeholder:@"请输入纳税号" filedName:@"taxNumber" inputType:CXEditLabelInputTypeASCII]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"开票地址：" placeholder:@"请输入开票地址" filedName:@"invoiceAddress" inputType:CXEditLabelInputTypeText]].required = NO;
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"账号：　　" placeholder:@"请输入账号" filedName:@"account" inputType:CXEditLabelInputTypeText]].required = NO;
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"开  户  行：" placeholder:@"请输入开户行" filedName:@"openBank" inputType:CXEditLabelInputTypeText]].required = NO;
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"电话：　　" placeholder:@"请输入电话" filedName:@"telephone" inputType:CXEditLabelInputTypeCustomPhone]].required = NO;
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司传真：" placeholder:@"请输入公司传真" filedName:@"fax" inputType:CXEditLabelInputTypeCustomPhone]].required = NO;
    }
    // 公司地址
    else if (self.listType == CXNoteCollectionListTypeCompanyAddress) {
        formBuilder.submitUrl = @"/companyAddress/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司名称：" filedName:@"companyName" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司地址：" filedName:@"address" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"公司电话：" filedName:@"telephone" inputType:CXEditLabelInputTypeCustomPhone]];
    }
    // 个人卡号
    else if (self.listType == CXNoteCollectionListTypeCardNumber) {
        formBuilder.submitUrl = @"/personageCard/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"开  户  行：" filedName:@"bank" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"　　卡号：" filedName:@"card" inputType:CXEditLabelInputTypeNumber]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"客服电话：" filedName:@"telephone" inputType:CXEditLabelInputTypeCustomPhone]];
    }
    // 证件号码
    else if (self.listType == CXNoteCollectionListTypeIdNumber) {
        formBuilder.submitUrl = @"/idNumber/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"证件类型：" filedName:@"type" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"证件号码：" filedName:@"idNumber" inputType:CXEditLabelInputTypeText]];
    }
    // 物流地址
    else if (self.listType == CXNoteCollectionListTypeLogisticsAddress) {
        formBuilder.submitUrl = @"/logiAddress/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"收  件  人：" filedName:@"addressee" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"联系电话：" filedName:@"telephone" inputType:CXEditLabelInputTypeCustomPhone]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"收件地址：" filedName:@"receiveAddress" inputType:CXEditLabelInputTypeText]];
    }
    // 其他
    else if (self.listType == CXNoteCollectionListTypeOther) {
        formBuilder.submitUrl = @"/other/save.json";
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"标题：" filedName:@"title" inputType:CXEditLabelInputTypeText]];
        [formBuilder addFormItem:[[CXMineFormItem alloc] initWithTitle:@"内容：" filedName:@"remark" inputType:CXEditLabelInputTypeText]];
    }
//    [formBuilder addAnnexItem];
    formBuilder.onPostSuccess = ^{
        [self.tableView.header beginRefreshing];
    };
    return formBuilder.viewController;
}

@end
