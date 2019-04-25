//
//  ICEFORCEWorkPotentialProjectViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEWorkPotentialProjectViewController.h"

#import "ICEFORCEPotentialGroupViewController.h"
#import "ICEFORCEPotentialPersonalViewController.h"

#import "WMSegmentViewController.h"

#import "ICEFORCENewlyAddPotentialProjectViewController.h"

@interface ICEFORCEWorkPotentialProjectViewController ()<WMSegmentDelegate>

@property (nonatomic ,strong) ICEFORCEPotentialPersonalViewController *personal;
@property (nonatomic ,strong) ICEFORCEPotentialGroupViewController *group;

@end

@implementation ICEFORCEWorkPotentialProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange:) name:AppStateDidChangeNotification object:nil];
}
#pragma mark - 刷新界面
- (void)stateChange:(id)sender {
    
    [self.personal reloadData];

    [self.group reloadData];
}
#pragma mark - kvo 注销
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)loadSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"潜在项目"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"ICEFORCENewlyAdd"] addTarget:self action:@selector(newlyAddObject:)];
    
    [rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(searchBtnClick:)];
    
    
    ICEFORCEPotentialPersonalViewController *personal = [[ICEFORCEPotentialPersonalViewController alloc]init];
    ICEFORCEPotentialGroupViewController *group = [[ICEFORCEPotentialGroupViewController alloc]init];
    self.personal = personal;
    self.group = group;
    NSArray *titles = @[@"个人", @"小组"];
    
    WMSegmentViewController *wm = [[WMSegmentViewController alloc] init];
    wm.delegate = self;
    wm.view.frame = CGRectMake(0, CGRectGetMaxY(rootTopView.frame), Screen_Width, Screen_Height-CGRectGetMaxY(rootTopView.frame));
    [wm segmentWithTitles:titles images:@[@"1",@"1"] selectImages:@[@"1",@"1"]];
    
    [wm segmentWithChildViewArrays:@[personal,group]];
    [self.view addSubview:wm.view];
    [self addChildViewController:wm];
    
}
#pragma mark - 搜索
-(void)searchBtnClick:(UIButton *)sneder{
    
}
static NSInteger selectIndex;
-(void)selectTopTitleForIndex:(NSInteger)index{
    selectIndex = index;
}

#pragma mark - 新增
-(void)newlyAddObject:(UIButton *)sender{
    ICEFORCENewlyAddPotentialProjectViewController *newlyAdd = [[ICEFORCENewlyAddPotentialProjectViewController alloc]init];
    newlyAdd.newlyAddBlock = ^(BOOL refreshView) {
        
        if (selectIndex == 0) {
            [self.personal reloadData];
        }else{
             [self.group reloadData];
        }
        
    };
    [self.navigationController pushViewController:newlyAdd animated:YES];
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
