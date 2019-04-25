//
//  SDIMShieldGroupMessageViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/11.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMShieldGroupMessageViewController.h"
#import "CXIMLib.h"

@interface SDIMShieldGroupMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SDRootTopView *rootTopView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CXGroupInfo * group;
@property (nonatomic,strong) UISwitch *swt;
@property (nonatomic) BOOL isShield;

@end

@implementation SDIMShieldGroupMessageViewController

- (instancetype)initWithGroup:(CXGroupInfo*)group
{
    self = [self init];
    if (self) {
        _group = group;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isShield = [[CXIMService sharedInstance].groupManager isShieldedGroupForId:_group.groupId];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"屏蔽群消息")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backViewController)];
    
//    [self.rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveWhetherShieldGroupMessageViewController)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = SDBackGroudColor;
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveWhetherShieldGroupMessageViewController];
}

- (void)saveWhetherShieldGroupMessageViewController
{
    if(_swt.on == _isShield){
//        TTAlert(@"已成功保存");
        return;
    }else{
        if(_swt.on == YES){
            BOOL succes = [[CXIMService sharedInstance].groupManager shieldGroupForId:_group.groupId];
            if(succes){
//                TTAlert(@"已成功保存");
            }else{
//                TTAlert(@"保存失败");
            }
        }else{
            BOOL succes = [[CXIMService sharedInstance].groupManager unshieldGroupForId:_group.groupId];
            if(succes){
//                TTAlert(@"已成功保存");
            }else{
//                TTAlert(@"保存失败");
            }
        }
    }
}


//- (void)saveWhetherShieldGroupMessageViewController
//{
//    if(_swt.on == _isShield){
//        TTAlert(@"已成功保存");
//        return;
//    }else{
//        if(_swt.on == YES){
//            BOOL succes = [[CXIMService sharedInstance] shieldGroupForId:_group.groupId];
//            if(succes){
//                TTAlert(@"已成功保存");
//            }else{
//                TTAlert(@"保存失败");
//            }
//        }else{
//            BOOL succes = [[CXIMService sharedInstance] unshieldGroupForId:_group.groupId];
//            if(succes){
//                TTAlert(@"已成功保存");
//            }else{
//                TTAlert(@"保存失败");
//            }
//        }
//    }
//}

- (void)backViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UILabel * groupChatNameLabel = [[UILabel alloc] init];
    groupChatNameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont)/2, 200, SDMainMessageFont);
    groupChatNameLabel.textAlignment = NSTextAlignmentLeft;
    groupChatNameLabel.backgroundColor = [UIColor clearColor];
    groupChatNameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    groupChatNameLabel.text = @"屏蔽群消息";
    groupChatNameLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:groupChatNameLabel];
    
    _swt = [[UISwitch alloc] init];
    _swt.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 15, 50, 15);
    _swt.on = _isShield;
    [cell.contentView addSubview:_swt];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
