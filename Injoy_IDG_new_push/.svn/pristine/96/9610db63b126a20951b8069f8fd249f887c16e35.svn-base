//
//  SDNeedDealViewController.m
//  SDMarketingManagement
//
//  Created by Mac on 15-4-28.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDNeedDealViewController.h"
#import "SDAboutMyWorkTableViewCell.h"
#import "NSString+TextHelper.h"
@interface SDNeedDealViewController ()

@end

@implementation SDNeedDealViewController
{

    UIView *slideView;
    NSArray *contentArr;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    contentArr = [NSArray arrayWithObjects:@"公鸡出差一个月，回来后听说鹌鹑没事老来找母鸡玩！公鸡便开始怀疑起母鸡来！果然，没过两天，母鸡就生了个鹌鹑蛋！公鸡大怒！母鸡慌忙解释：“靠，早产啦！",@"可以了吗加拿大（Canada），为北美洲最北的国家，西抵太平洋，东迄大西洋，北至北冰洋，东北部和丹麦领地格陵兰岛相望，东部和法属圣皮埃尔和密克隆群岛相望，南方与美国本土接壤，西北方与美国阿拉斯加州为邻。领土面积为998万平方千米，位居世界第二[1] 。加拿大素有“枫叶之国”的美誉，首都是渥太华加拿大（Canada），为北美洲最北的国家，西抵太平洋，东迄大西洋，北至北冰洋，东北部和丹麦领地格陵兰岛相望，东部和法属圣皮埃尔和密克隆群岛相望，南方与美国本土接壤，西北方与美国阿拉斯加州为邻。领土面积为998万平方千米，位居世界第二[1] 。加拿大素有“枫叶之国”的美誉，首都是渥太华",@"加拿大（Canada），为北美洲最北的国家，西抵太平洋，东迄大西洋，北至北冰洋，东北部和丹麦领地格陵兰岛相望，东部和法属圣皮埃尔和密克隆群岛相望，南方与美国本土接壤，西北方与美国阿拉斯加州为邻。领土面积为998万平方千米，位居世界第二[1] 。加拿大素有“枫叶之国”的美誉，首都是渥太华。", nil];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--点击跳转控件
-(void)setUI
{
    NSArray *array = [NSArray arrayWithObjects:@"日志",@"指令",@"审批",nil];
    for(int i = 0 ; i < 3 ; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*Screen_Width/3, 66, Screen_Width/3, 40)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[button setBackgroundColor:[UIColor blueColor]];
               [self.view addSubview:button];
    
    }
    slideView = [[UIView alloc]initWithFrame:CGRectMake(0, 107, Screen_Width/3, 2)];
    slideView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:slideView];
    NSLog(@"button is %@",self.view.subviews);
}
-(void)onClick:(id)sender
{
    UIButton *button =sender;
    CGRect buttonRect=button.frame;
    CGRect rect =slideView.frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        slideView.frame=CGRectMake(buttonRect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        
    }];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark--tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"SDAboutMyWorkTableViewCell";
    [_aboutMyWorkTableview registerNib:[UINib nibWithNibName:@"SDAboutMyWorkTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    SDAboutMyWorkTableViewCell *cell = [_aboutMyWorkTableview dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    NSLog(@"row is%ld",(long)indexPath.row);
    cell.content.text = contentArr[indexPath.row];
    CGRect rect = cell.content.frame;
    cell.bgView.frame = CGRectMake(0, 0, cell.bgView.frame.size.width,cell.frame.size.height);
    
    rect.size.height = cell.bgView.frame.size.height-63;
    cell.content.frame = rect;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = contentArr[indexPath.row];
    int height = 93+[str heightForString:str fontSize:17 andWidth:[UIScreen mainScreen].bounds.size.width];
    if(height > 303)
        return 303;
    return height;
    
    
    
    
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
