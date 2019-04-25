//
//  SDSelectAdress.m
//  SDMarketingManagement
//
//  Created by fanzhong on 15/5/26.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDSelectAdress.h"
#import "SDLocModel.h"

@interface SDSelectAdress ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *adressList;


@end

@implementation SDSelectAdress

- (void)viewDidLoad {
    [super viewDidLoad];
    SDRootTopView *topView = [self getRootTopView];
    [topView setNavTitle:@"选择地址"];
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    [customLeftBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    customLeftBtn.frame = CGRectMake(10, 25, backImage.size.width, backImage.size.height);
    [customLeftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:customLeftBtn];
    [self creatTableView];
    
}

- (void)leftBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

static NSString *cellName = @"adressCell";
#pragma mark - tableview
- (void)creatTableView
{
    self.adressList = [[UITableView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
    self.adressList.delegate = self;
    self.adressList.dataSource = self;
    [self.adressList registerClass:[UITableViewCell class] forCellReuseIdentifier:cellName];

    [self.view addSubview:self.adressList];
}


#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    SDLocModel *model = self.adressArray[indexPath.row];
    cell.textLabel.text = model.locName;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 返回可以编辑
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
