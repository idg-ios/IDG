//
//  ICEFORCEAlreadyInvestedRootViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEAlreadyInvestedRootViewController.h"

#import "WMSegmentViewController.h"

#import "ICEFORCEAlreadyGroupViewController.h"
#import "ICEFORCEAlreadyPersonalViewController.h"


@interface ICEFORCEAlreadyInvestedRootViewController ()<WMSegmentDelegate>

@end

@implementation ICEFORCEAlreadyInvestedRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
}
-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"已投资项目"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(searchData:)];
    
   
    ICEFORCEAlreadyPersonalViewController *personal = [[ICEFORCEAlreadyPersonalViewController alloc]init];
    ICEFORCEAlreadyGroupViewController *group = [[ICEFORCEAlreadyGroupViewController alloc]init];
   
    NSArray *titles = @[@"个人", @"小组"];
    
    WMSegmentViewController *wm = [[WMSegmentViewController alloc] init];
    wm.delegate = self;
    wm.view.frame = CGRectMake(0, CGRectGetMaxY(rootTopView.frame), Screen_Width, Screen_Height-CGRectGetMaxY(rootTopView.frame));
    [wm segmentWithTitles:titles images:@[@"1",@"1"] selectImages:@[@"1",@"1"]];
    
    [wm segmentWithChildViewArrays:@[personal,group]];
    [self.view addSubview:wm.view];
    [self addChildViewController:wm];
    
}
#pragma mark - segment代理
-(void)selectTopTitleForIndex:(NSInteger)index{
    
}
#pragma mark - 搜索按钮
-(void)searchData:(UIButton *)sender{
    
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
