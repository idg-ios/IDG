//
//  SDMySuggestDetailViewController.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDMySuggestDetailViewController.h"
#import "HttpTool.h"

@interface SDMySuggestDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SDRootTopView *rootTopView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SDMySuggestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTopView];
    [self setTableView];
    [self downloadDetailData];
}

#pragma mark -- 添加头部导航栏
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"我的建议"];
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
}

-(void)setTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,navHigh, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)setupData
{
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray addObject:[NSString stringWithFormat:@"建议时间 : %@",self.mySuggestDict[@"createTime"]]];
    [_dataArray addObject:[NSString stringWithFormat:@"建议标题 : %@",self.mySuggestDict[@"name"]]];
    [_dataArray addObject:[NSString stringWithFormat:@"建议内容 : %@",self.mySuggestDict[@"remark"]]];
    if (self.mySuggestDict[@"replyContnet"])
    {
        [_dataArray addObject:[NSString stringWithFormat:@"叮当享服务 : %@",self.mySuggestDict[@"replyContnet"]]];
    }
    [_tableView reloadData];
}

#pragma marks <---UITableViewDelegate--->
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews)
    {
        if (view.tag == 101 )
        {
            [view removeFromSuperview];
        }
        if (view.tag == 102)
        {
            [view removeFromSuperview];
        }
    }
    
    UIView *lingView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, Screen_Width, 1)];
    lingView.tag = 101;
    lingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Interval, 10, Screen_Width-Interval, 20)];
    label.text = [_dataArray objectAtIndex:indexPath.row];
    label.tag = 102;
    [cell.contentView addSubview:lingView];
    [cell.contentView addSubview:label];
    if (indexPath.row == 1)
    {
        CGRect contentFrame= [[_dataArray objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(Screen_Width-Interval*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil];
        label.frame = CGRectMake(Interval, 10, Screen_Width-Interval*2,contentFrame.size.height);
        label.numberOfLines = 0;
        lingView.frame = CGRectMake(0, contentFrame.size.height +19, Screen_Width, 1);
    }else if (indexPath.row == 2)
    {
        CGRect contentFrame= [[_dataArray objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(Screen_Width-Interval*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil];
        label.frame = CGRectMake(Interval, 10, Screen_Width-Interval*2,contentFrame.size.height);
        label.numberOfLines = 0;
        if (_dataArray.count > 3)
        {
            lingView.frame = CGRectMake(0, contentFrame.size.height +19, Screen_Width, 4);
            lingView.backgroundColor = [UIColor lightGrayColor];
        }else
        {
            [lingView removeFromSuperview];
        }
        
    }else if(indexPath.row == 3){
        CGRect contentFrame= [[_dataArray objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(Screen_Width-Interval*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil];
        label.frame = CGRectMake(Interval, 10, Screen_Width-Interval*2,contentFrame.size.height);
        label.numberOfLines = 0;
        [lingView removeFromSuperview];
    }
    
    return cell;
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        CGRect contentFrame= [[_dataArray objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(Screen_Width-Interval*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} context:nil];
        if (_dataArray.count >3 && indexPath.row == 2)
        {
            return contentFrame.size.height+23;
        }else
        {
            return contentFrame.size.height+20;
        }
        
    }else
    {
        return 40;
    }
    
}
#pragma mark -- 下载数据
-(void)downloadDetailData
{
    NSString* url = [NSString stringWithFormat:@"%@advise/%ld", urlPrefix,self.listId];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@((int)self.listId) forKey:@"id"];
    
    [HttpTool getWithPath:url
                   params:params
                  success:^(id JSON) {
                      [self hideHud];
                      NSDictionary* dict = JSON;
                      NSNumber* status = [dict objectForKey:@"status"];
                      if ([status integerValue] == 200) {
                          self.mySuggestDict = [NSMutableDictionary dictionary];
                          self.mySuggestDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"datas"]];
                          [self setupData];
                      }
                      else {
                          [self.view makeToast:JSON[@"msg"] duration:1 position:@"center"];
                      }
                  }
                  failure:^(NSError* error) {
                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                      [alert show];
                  }];
    
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
