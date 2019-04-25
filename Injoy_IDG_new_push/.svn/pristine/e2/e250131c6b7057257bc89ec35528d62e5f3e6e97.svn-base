//
//  CXNoteCollectionViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoteCollectionViewController.h"
#import "CXNoteCollectionListViewController.h"

#define kCellInsets UIEdgeInsetsMake(0, 8, 0, 8)

@interface CXNoteCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, copy) NSArray<NSArray<NSDictionary *> *> *list;

@end

@implementation CXNoteCollectionViewController

#define kNormalCellId @"cell"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[
                  @[@{ @"icon": @"cpaccount", @"title": @"公司账号" }, @{ @"icon": @"billinginfo", @"title": @"开票信息" }, @{ @"icon": @"cpaddress", @"title": @"公司地址" }],
                  @[@{ @"icon": @"cardno", @"title": @"个人卡号" }, @{ @"icon": @"idno", @"title": @"证件号码" }, @{ @"icon": @"logiaddress", @"title": @"物流地址" }],
                  @[@{ @"icon": @"collectionother", @"title": @"其他" }]
                  ];
    
    [self setup];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"备忘收藏"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        tableView.backgroundColor = kColorWithRGB(241, 238, 245);
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kNormalCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:kCellInsets];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:kCellInsets];
        }
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource
-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
    NSDictionary *item = self.list[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:item[@"icon"]];
    cell.textLabel.text = item[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *item = self.list[indexPath.section][indexPath.row];
    NSString *title = item[@"title"];
    
    NSInteger rowIndex = ({
        NSInteger idx = 0;
        for (NSInteger i = 0; i < indexPath.section; i++) {
            idx += self.list[i].count;
        }
        idx += indexPath.row;
        idx;
    });
    
    CXNoteCollectionListViewController *listVC = [[CXNoteCollectionListViewController alloc] init];
    listVC.listType = (CXNoteCollectionListType)rowIndex;
    listVC.title = title;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:kCellInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:kCellInsets];
    }
}

#pragma mark - Event
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
