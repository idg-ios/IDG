//
//  CXSuperConfigViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/11/10.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperConfigViewController.h"
#import "UIView+CXCategory.h"
#import "HttpTool.h"
#import "CXSuperConfigCell.h"

@interface CXSuperConfigViewController () <UITableViewDataSource, UITableViewDelegate, CXSuperConfigCellDelegate>

/** <#comment#> */
@property (nonatomic, strong) UITableView *tableView;
/** 配置详情 */
@property (nonatomic, strong) NSMutableDictionary *config;

@end

#define kCellID @"cell"

@implementation CXSuperConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self getConfig];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"超级配置"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(leftBarItemOnTap)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        [tableView disableTouchesDelay];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[CXSuperConfigCell class] forCellReuseIdentifier:kCellID];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    CXSuperConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (indexPath.row == 0) {
        BOOL enable_location = [self.config[@"location"] integerValue] == 1;
        cell.title = @"提供定位";
        cell.enable = enable_location;
    }
    else if (indexPath.row == 1) {
        BOOL enable_ReadFlag = [self.config[@"isRead"] integerValue] == 1;
        cell.title = @"已阅未阅";
        cell.enable = enable_ReadFlag;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - CXSuperConfigCellDelegate
- (void)superConfigCell:(CXSuperConfigCell *)cell willChangeEnableState:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath {
    NSString *paramName;
    NSNumber *paramValue = enable == YES ? @1 : @2;
    
    // 定位开关
    if (indexPath.row == 0) {
        paramName = @"location";
    }
    // 已阅未阅开关
    else if (indexPath.row == 1) {
        paramName = @"isRead";
    }
    
    NSDictionary *params = @{
                             paramName: paramValue
                             };
    HUD_SHOW(nil);
    [HttpTool postWithPath:@"/sysSetting/update.json" params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.config[paramName] = paramValue;
            [self.tableView reloadData];
            
            // 定位开关
            if (indexPath.row == 0) {
                [[NSUserDefaults standardUserDefaults] setBool:enable forKey:OPEN_GET_LOCATION];
            }
            // 已阅未阅开关
            else if (indexPath.row == 1) {
                [[NSUserDefaults standardUserDefaults] setBool:enable forKey:OPEN_READ_FLAG];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - Event
- (void)leftBarItemOnTap {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private
- (void)getConfig {
    HUD_SHOW(nil);
    [HttpTool getWithPath:@"/sysSetting/detail.json" params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.config = [NSMutableDictionary dictionaryWithDictionary:JSON[@"data"]];
            [self.tableView reloadData];
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
