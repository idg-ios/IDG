//
//  CXYMSubmitViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/11/30.
//  Copyright © 2018 Injoy. All rights reserved.
//

#import "CXYMSubmitViewController.h"
#import "Masonry.h"

@interface CXYMSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *navigationTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) UIButton *submitButton;

@end

static NSString * const CXYMSubmitViewCellIdentity = @"CXYMSubmitViewCellIdentity";
@implementation CXYMSubmitViewController

#pragma mark --instancetype
- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.navigationTitle = title.copy;
    }
    return self;
}
#pragma mark --setter && getter
- (NSMutableArray *)contentArray{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[];
    }
    return _titleArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CXYMSubmitViewCellIdentity];
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIButton *)submitButton{
    if (_submitButton == nil) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_submitButton];
    }
    return _submitButton;
}
#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.RootTopView setNavTitle: self.navigationTitle];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CXYMSubmitViewCellIdentity forIndexPath:indexPath];
    
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
