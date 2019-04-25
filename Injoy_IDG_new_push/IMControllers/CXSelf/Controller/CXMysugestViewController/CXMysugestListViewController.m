//
//  CXMysugestListViewController.m
//  SDMarketingManagement
//
//  Created by fanzhong on 16/4/21.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXMysugestListViewController.h"
#import "SDMenuView.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SDMySuggestViewController.h"
#import "SDMySuggestDetailViewController.h"
#import "UIView+Category.h"

@interface CXMysugestListViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,SDMenuViewDelegate>

@property (nonatomic, strong) SDRootTopView *rootTopView;
@property (nonatomic, weak)  UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation CXMysugestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建头部导航栏
    [self setUpTopView];
    [self setUpTableView];
    [self refresh];
    [self downloadListData];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark -- 添加头部导航栏
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"我的建议"];
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    //右边添加按钮
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(rightBtnClick:)];
}
#pragma mark -topView上按钮的事件
- (void)rightBtnClick:(UIButton *)sender
{
    _selectButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSArray *dataArray = @[ @"添加"];
        NSArray *imageArray = @[ @"add_mySuggest"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [_selectMemu removeFromSuperview];
    }
}
#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString *)cardName
{
    _selectButton.selected = NO;
    [_selectMemu removeFromSuperview];
    
    if (cardID == 0) {
        
        SDMySuggestViewController *mySuggestVC = [[SDMySuggestViewController alloc] init];
        
        //数据发送成功的回调方法
        __weak typeof(self) weakSelf = self;
        mySuggestVC.dataSuccess = ^{
            weakSelf.page = 1;
            [weakSelf downloadListData];
        };
        [self.navigationController pushViewController:mySuggestVC animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}
#pragma mark -- 视图控制器消失时，移除下拉菜单
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_selectMemu removeFromSuperview];
    _selectButton.selected = NO;
}
#pragma mark -- 创建表格视图
-(void)setUpTableView
{
    _page = 1;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50.f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
#pragma mark -- 表格视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for(UIView * subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@""];
    NSString *str=dict[@"name"];
    //    if (str.length >9) {
    //        cell.textLabel.text = [NSString substring:str ToIndex:9];
    //    }else
    //    {
    //        cell.textLabel.text = str;
    //    }
    
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = [dict[@"createTime"] componentsSeparatedByString:@" "][0];
    timeLabel.font = [UIFont systemFontOfSize:15.0];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(Screen_Width - 30 - timeLabel.size.width, (50 - 15)/2, timeLabel.size.width, 15);
    timeLabel.textColor = SDCellTimeColor;
    [cell.contentView addSubview:timeLabel];
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(10, CGRectGetMinY(timeLabel.frame), CGRectGetMinX(timeLabel.frame) - 10 - 10, 15);
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = [UIFont systemFontOfSize:15.0];
    textLabel.text = str;
    [cell.contentView addSubview:textLabel];
    
    UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 49, Screen_Width, 1)];
    linview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell.contentView addSubview:linview];
    
    //    UILabel * textLabel = [[UILabel alloc] init];
    //    textLabel.frame = CGRectMake(10, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    //    cell.detailTextLabel.text = [dict[@"createTime"] componentsSeparatedByString:@" "][0];
    //    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDMySuggestDetailViewController *mySuggestDetailVC = [[SDMySuggestDetailViewController alloc] init];
    //    mySuggestDetailVC.mySuggestDict = [NSDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    mySuggestDetailVC.listId = [dict[@"id"] integerValue];
    [self.navigationController pushViewController:mySuggestDetailVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
#pragma mark -- 下载数据
-(void)downloadListData
{
    __weak CXMysugestListViewController *listVC = self;
    NSString* url = [NSString stringWithFormat:@"%@advise/%@/%ld/%ld", urlPrefix,[AppDelegate getCompanyID],(long)[[AppDelegate getUserID] integerValue],(long)_page];
    [HttpTool getWithPath:url
                   params:nil
                  success:^(id JSON) {
                      [self hideHud];
                      NSDictionary* dict = JSON;
                      NSNumber* status = [dict objectForKey:@"status"];
                      NSInteger total = [dict[@"total"] integerValue];
                      [self calPage:total];
                      
                      if ([status integerValue] == 200) {
                          
                          if (listVC.page == 1) {
                              [listVC.dataArray removeAllObjects];
                          }
                          NSArray* dataArray = [dict valueForKey:@"datas"];
                          listVC.dataArray = [NSMutableArray array];
                          if(dataArray && [dataArray isKindOfClass:[NSArray class]] && [dataArray count]> 0){
                              for (NSDictionary *dict in dataArray)
                              {
                                  [listVC.dataArray  addObject:dict];
                              }
                          }
                          
                          [listVC.tableView reloadData];
                          [listVC.tableView.legendHeader endRefreshing];
                          [listVC.tableView.legendFooter endRefreshing];
                      }
                      else {
                          [self.view makeToast:JSON[@"msg"] duration:1 position:@"center"];
                      }
                      [listVC.tableView.legendHeader endRefreshing];
                      [listVC.tableView.legendFooter endRefreshing];
                      
                  }
                  failure:^(NSError* error) {
                      [listVC hideHud];
                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                      
                      [alert show];
                      [listVC.tableView.legendHeader endRefreshing];
                      [listVC.tableView.legendFooter endRefreshing];
                  }];
    
}
#pragma mark--设置刷新
- (void)refresh
{
    __unsafe_unretained CXMysugestListViewController* listVC = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        listVC->_page = 1;
        [listVC downloadListData];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if (listVC->_page <= listVC->_totalPage - 1) {
            listVC->_page++;
            [listVC downloadListData];
        }
        else {
            [listVC.view makeToast:@"已到最后一页" duration:1 position:@"bottom"];
            [listVC performSelector:@selector(stopLoading) withObject:nil afterDelay:0.5];
        }
    }];
}

- (void)stopLoading
{
    [self.tableView.legendFooter endRefreshing];
}

#pragma mark -- 计算总页数
- (void)calPage:(NSInteger)total
{
    _totalPage = total / 15;
    if (_totalPage == 0 && total % 15 == 0) {
        _totalPage = 1;
        return;
    }
    
    if (total % 15 != 0) {
        _totalPage++;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _selectButton.selected = NO;
    [_selectMemu removeFromSuperview];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(_selectButton.frame, currentPoint)) {
        return NO;
    }
    return YES;
}
- (void)tapAction:(UITapGestureRecognizer*)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded){
        CGPoint location = [tapGesture locationInView:nil];
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            _selectButton.selected = NO;
            [_selectMemu removeFromSuperview];
        }
    }
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
