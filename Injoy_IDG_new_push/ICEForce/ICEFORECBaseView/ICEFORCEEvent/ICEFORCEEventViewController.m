//
//  ICEFORCEEventViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEEventViewController.h"
#import "WMSegmentViewController.h"

#import "ICEFORCENeedDealtViewController.h"
#import "ICEFORCERemindViewController.h"

@interface ICEFORCEEventViewController ()<WMSegmentDelegate>

@property (nonatomic ,strong) ICEFORCENeedDealtViewController *needDealt;
@property (nonatomic ,strong) ICEFORCERemindViewController *remind;

@end

@implementation ICEFORCEEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deaitChange:) name:AppDeaitDidChangeNotification object:nil];
}
#pragma mark - 刷新界面
- (void)deaitChange:(id)sender {
    
    [self.needDealt reloadData];
    
    [self.remind reloadData];
}
#pragma mark - kvo 注销
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"事项"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    
    [rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(searchBtnClick:)];

    
    ICEFORCENeedDealtViewController *needDealt = [[ICEFORCENeedDealtViewController alloc]init];
    ICEFORCERemindViewController *remind = [[ICEFORCERemindViewController alloc]init];
   
    self.needDealt = needDealt;
    self.remind = remind;
    
    NSArray *titles = @[@"待办", @"提醒"];
    
    WMSegmentViewController *wm = [[WMSegmentViewController alloc] init];
    wm.delegate = self;
    wm.view.frame = CGRectMake(0, CGRectGetMaxY(rootTopView.frame), Screen_Width, Screen_Height-CGRectGetMaxY(rootTopView.frame));
    [wm segmentWithTitles:titles images:@[@"1",@"1"] selectImages:@[@"1",@"1"]];
    
    [wm segmentWithChildViewArrays:@[needDealt,remind]];
    [self.view addSubview:wm.view];
    [self addChildViewController:wm];
    
}

-(void)searchBtnClick:(UIButton *)sender{
    
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
