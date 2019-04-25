//
//  SDMailRemindController.m
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/7/1.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDMailRemindController.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "SDDataBaseHelper.h"
#import "AppDelegate.h"


@interface SDMailRemindController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _page;
    int _totalPage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SDMailRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    [self setUpNavigationBar];
    
    //下载数据
    [self downloadDailyList];
    
}

#pragma mark 搭建界面
-(void)buildUI
{
    _page = 1;
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

#pragma mark 导航栏头部
-(void)setUpNavigationBar
{
    SDRootTopView *rootTopView  = [self getRootTopView];
    
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customLeftBtn setBackgroundImage:[UIImage imageNamed:@"invite_back_icon"] forState:UIControlStateNormal];
    customLeftBtn.frame = CGRectMake(10, 25, 30, 30);
    [customLeftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootTopView addSubview:customLeftBtn];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的邮箱";
    
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(Screen_Width/2-60, 25, 120, 40);
    
    [rootTopView addSubview:title];
}

#pragma mark - button点击事件
- (void)leftBtnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- 网络获取数据
- (void)downloadDailyList {
    
    //2.设置登录参数
    NSDictionary *dict = @{ @"uid":[AppDelegate getUserID], @"pageNumber":[NSString stringWithFormat:@"%d",_page]};
    NSString *url = [NSString stringWithFormat:@"%@mail/receiveList", urlPrefix];
    NSLog(@"url is %@", url);
    
    //3.请求
    [HttpTool postWithPath:url params:dict success:^(id JSON) {
        //自动返回主线程
        [NSThread currentThread];
        
        NSDictionary *dict = JSON;
        
        NSNumber *status = [dict objectForKey:@"status"];
        
        id msg= [dict objectForKey:@"msg"];
        _totalPage = [dict[@"total"] intValue];
//        [self calPage:total];
        NSString *message = [NSString stringWithFormat:@"%@",msg];
        if([message isEqualToString:@"<null>"])
            message = @"" ;
        
        NSLog(@"dict %@",dict);
        if (status.intValue == 200) {
            
            if(_page ==1)
            {
                if(_dataArray.count >0)
                    [_dataArray removeAllObjects];
            }
            NSArray *array = [dict objectForKey:@"data"];
            [_dataArray addObject:array];
            [self.tableView reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }];
}


#pragma mark--设置刷新
-(void)refresh
{
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained SDMailRemindController *mailRemindVC = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        mailRemindVC->_page = 1;
        
        [weakSelf downloadDailyList];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if(mailRemindVC->_page <= mailRemindVC->_totalPage-1)
        {
            mailRemindVC->_page ++;
            [weakSelf downloadDailyList];
        }
        else
        {
            [mailRemindVC.view makeToast:@"已到最后一页" duration:0.5 position:@"bottom"];
            [mailRemindVC performSelector:@selector(stopLoading) withObject:nil afterDelay:0.5];
        }
    }];
    
}

-(void)stopLoading
{
    
    [self.tableView.legendFooter endRefreshing];
    
}

#pragma mark tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = _dataArray[section];
    return subArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55+100.f;
}

@end
