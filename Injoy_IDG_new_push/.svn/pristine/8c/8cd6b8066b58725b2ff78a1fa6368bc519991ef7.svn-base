//
//  CXPopupsViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2018/6/2.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPopupsViewController.h"

#import "CXPopupsTableViewCell.h"

@interface CXPopupsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *contentString;


@end

@implementation CXPopupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    
    [self loadPopupsView];
    
}
-(void)loadPopupsView{
    
    CGFloat h = 0.0f;
    if (self.dataArray.count !=0 && self.dataArray.count <=6) {
        h = 48+self.dataArray.count *54;
    }else{
        h = self.view.frame.size.height*0.7;
    }
    
    
    UIView *basicView = [[UIView alloc]initWithFrame:(CGRectMake(0, self.view.frame.size.height-h, self.view.frame.size.width, h))];
    basicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:basicView];
    
    UIView *topView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 48))];
    topView.backgroundColor = RGBACOLOR(245, 246, 248, 1);
    [basicView addSubview:topView];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, 60, topView.frame.size.height))];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:RGBACOLOR(132, 142, 153, 1) forState:(UIControlStateNormal)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(cancelButton.frame), 0, self.view.frame.size.width-120, topView.frame.size.height))];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titelString;
    
    [topView addSubview:titleLabel];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 60, topView.frame.size.height))];
    [confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmButton setTitleColor:RGBACOLOR(132, 142, 153, 1) forState:(UIControlStateNormal)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:confirmButton];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(topView.frame), basicView.frame.size.width, basicView.frame.size.height-topView.frame.size.height)) style:(UITableViewStylePlain)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [basicView addSubview:tableView];
    self.tableView = tableView;
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *dailyCell = @"popupCell";
    
    CXPopupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dailyCell];
    if (cell == nil) {
        cell = [[CXPopupsTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dailyCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.leftString = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.contentString = [self.dataArray objectAtIndex:indexPath.row];
}

-(void)cancel:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)confirm:(UIButton *)senser{
    if (self.contentString != nil) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"您暂未选择" duration:2.0 position:@"center"];
        return;
    }
    if (self.popupDataBlock) {
        self.popupDataBlock(self.contentString);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
