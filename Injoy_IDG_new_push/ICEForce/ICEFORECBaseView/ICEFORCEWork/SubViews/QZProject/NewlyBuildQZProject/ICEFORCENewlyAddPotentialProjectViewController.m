//
//  ICEFORCENewlyAddPotentialProjectViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCENewlyAddPotentialProjectViewController.h"

#import "CXEditLabel.h"
#import "HttpTool.h"
#import "PlayerManager.h"
#import "MBProgressHUD+CXCategory.h"

#import "ICEFORECIntroduceDetailViewController.h"
#import "ICEFORCESelectListView.h"

#import "ICEFORECVoiceViewController.h"

#import "ICEFORCEPersonListViewController.h"

@interface ICEFORCENewlyAddPotentialProjectViewController ()<PlayingDelegate>

@property (nonatomic ,strong) NSMutableArray *loadData;

@property (nonatomic ,strong) CXEditLabel *projectName;

@property (nonatomic ,strong) CXEditLabel *projectTeam;

@property (nonatomic ,strong) CXEditLabel *projectState;
@property (nonatomic ,strong) UIView *projectStateView;

@property (nonatomic ,strong) CXEditLabel *projectPresent;
@property (nonatomic ,strong) UIButton *voiceButton;
@property (nonatomic ,strong) NSString *pathName;

@property (nonatomic ,strong) CXEditLabel *projectGroup;
@property (nonatomic ,strong) UIView *projectGroupeView;

@property (nonatomic ,strong) CXEditLabel *projectMoney;

@property (nonatomic ,strong) CXEditLabel *projectFZPerson;

@property (nonatomic ,strong) CXEditLabel *projectMember;

@property (nonatomic ,strong) ICEFORCESelectListView *listView;
@property (nonatomic ,strong) ICEFORCESelectListView *listGroupeView;

@property (nonatomic ,assign) BOOL showService;
@property (nonatomic ,assign) BOOL showGroup;

@property (nonatomic ,strong) NSArray *listDataArray;
@property (nonatomic ,strong) NSArray *listGroupDataArray;

#pragma mark - 需要上传的数据字段

/** 项目名称,必填 */
@property (nonatomic ,strong) NSString *pjName;
/** 状态,必填 */
@property (nonatomic ,strong) NSString *stsId;
/** 团队介绍,非必填 */
@property (nonatomic ,strong) NSString *teamDesc;
/** 行业小组,必填 */
@property (nonatomic ,strong) NSString *indusGroup;
/** 拟投资金额,非必填 */
@property (nonatomic ,strong) NSString *planInvAmount;
/** 项目负责人，用逗号隔开，id,非必填 */
@property (nonatomic ,strong) NSString *projManagers;
/** 项目团队成员，逗号隔开。id,非必填 */
@property (nonatomic ,strong) NSString *projTeams;
/** 操作用户名,必填 */
@property (nonatomic ,strong) NSString *username;
/** 项目简介,非必填 */
@property (nonatomic ,strong) NSString *zhDesc;
/** 语音URL,非必填 */
@property (nonatomic ,strong) NSString *voiceUrl;
/** 语音时长,非必填 */
@property (nonatomic ,assign) NSInteger voiceTime;

@property (nonatomic ,strong) NSArray *pjFZArray;
@property (nonatomic ,strong) NSArray *pjCYArray;
@end

@implementation ICEFORCENewlyAddPotentialProjectViewController

#pragma mark - 懒加载
-(CXEditLabel *)projectName{
    if (!_projectName) {
        _projectName = [[CXEditLabel alloc]init];
        _projectName.placeholder = @"项目名称";
        _projectName.title = @"项目名称：";
        _projectName.titleFont = [UIFont systemFontOfSize:14];
        _projectName.contentFont = [UIFont systemFontOfSize:14];

    }
    return _projectName;
}
-(CXEditLabel *)projectTeam{
    if (!_projectTeam) {
        _projectTeam = [[CXEditLabel alloc]init];
        _projectTeam.placeholder = @"项目团队";
        _projectTeam.title = @"项目团队：";
        _projectTeam.titleFont = [UIFont systemFontOfSize:14];
        _projectTeam.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectTeam;
}
-(CXEditLabel *)projectState{
    if (!_projectState) {
        _projectState = [[CXEditLabel alloc]init];
        _projectState.placeholder = @"项目状态";
        _projectState.title = @"项目状态：";
        _projectState.titleFont = [UIFont systemFontOfSize:14];
        _projectState.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectState;
}
-(CXEditLabel *)projectPresent{
    if (!_projectPresent) {
        _projectPresent = [[CXEditLabel alloc]init];
        _projectPresent.placeholder = @"项目介绍";
        _projectPresent.title = @"项目介绍：";
        _projectPresent.titleFont = [UIFont systemFontOfSize:14];
        _projectPresent.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectPresent;
}
-(CXEditLabel *)projectGroup{
    if (!_projectGroup) {
        _projectGroup = [[CXEditLabel alloc]init];
        _projectGroup.placeholder = @"行业小组";
        _projectGroup.title = @"行业小组：";
        _projectGroup.titleFont = [UIFont systemFontOfSize:14];
        _projectGroup.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectGroup;
}
-(CXEditLabel *)projectMoney{
    if (!_projectMoney) {
        _projectMoney = [[CXEditLabel alloc]init];
        _projectMoney.placeholder = @"拟投金额";
        _projectMoney.title = @"拟投金额：";
        _projectMoney.titleFont = [UIFont systemFontOfSize:14];
        _projectMoney.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectMoney;
}
-(CXEditLabel *)projectFZPerson{
    if (!_projectFZPerson) {
        _projectFZPerson = [[CXEditLabel alloc]init];
        _projectFZPerson.placeholder = @"项目负责人（选填）";
        _projectFZPerson.title = @"项目负责人：";
        _projectFZPerson.titleFont = [UIFont systemFontOfSize:14];
        _projectFZPerson.contentFont = [UIFont systemFontOfSize:14];

    }
    return _projectFZPerson;
}
-(CXEditLabel *)projectMember{
    if (!_projectMember) {
        _projectMember = [[CXEditLabel alloc]init];
        _projectMember.placeholder = @"小组成员（选填）";
        _projectMember.title = @"小组成员：";
        _projectMember.titleFont = [UIFont systemFontOfSize:14];
        _projectMember.contentFont = [UIFont systemFontOfSize:14];
    }
    return _projectMember;
}

-(NSMutableArray *)loadData{
    if (!_loadData) {
        _loadData = [[NSMutableArray alloc]init];
    }
    return _loadData;
}

-(ICEFORCESelectListView *)listView{
    if (!_listView) {
        _listView = [[ICEFORCESelectListView alloc]init];
        _showService = NO;
    }
    return _listView;
}

-(ICEFORCESelectListView *)listGroupeView{
    if (!_listGroupeView) {
         _listGroupeView = [[ICEFORCESelectListView alloc]init];
        _showGroup = NO;
    }
    return _listGroupeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    
}
-(void)loadSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"新建潜在项目"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    CXWeakSelf(self);
    
    UIView *projectNameView = [self loadCellViewOriginY:CGRectGetMaxY(rootTopView.frame)+10 cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectName showRightView:NO isEdit:YES selectButtonForTag:101];
    [self.view addSubview:projectNameView];
    self.projectName.didTapLabelBlock = ^(CXEditLabel *editLabel) {
        [weakself listViewHidden:YES];
        [weakself listGroupeViewHidden:YES];

    };
    self.projectName.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        weakself.pjName = editLabel.content;
    };
    
    
    UIView *projectTeamView = [self loadCellViewOriginY:CGRectGetMaxY(projectNameView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectTeam showRightView:NO isEdit:YES selectButtonForTag:102];
    [self.view addSubview:projectTeamView];
    self.projectTeam.didTapLabelBlock = ^(CXEditLabel *editLabel) {
        [weakself listViewHidden:YES];
        [weakself listGroupeViewHidden:YES];
    };
    self.projectTeam.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        weakself.teamDesc = editLabel.content;
    };
    
    
    UIView *projectStateView = [self loadCellViewOriginY:CGRectGetMaxY(projectTeamView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectState showRightView:NO isEdit:NO selectButtonForTag:103];
    [self.view addSubview:projectStateView];
    self.projectStateView = projectStateView;
    
    UIView *projectPresentView = [self loadCellViewOriginY:CGRectGetMaxY(projectStateView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectPresent showRightView:YES isEdit:NO selectButtonForTag:104];
    [self.view addSubview:projectPresentView];
    
    UIView *projectGroupView = [self loadCellViewOriginY:CGRectGetMaxY(projectPresentView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectGroup showRightView:NO isEdit:NO selectButtonForTag:105];
    [self.view addSubview:projectGroupView];
    self.projectGroupeView = projectGroupView;
    
    UIView *projectMoneyView = [self loadCellViewOriginY:CGRectGetMaxY(projectGroupView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectMoney showRightView:NO isEdit:YES selectButtonForTag:106];
    [self.view addSubview:projectMoneyView];
    self.projectMoney.didTapLabelBlock = ^(CXEditLabel *editLabel) {
        [weakself listViewHidden:YES];
        [weakself listGroupeViewHidden:YES];
    };
    self.projectMoney.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        weakself.planInvAmount = editLabel.content;
    };
    UIView *projectFZPersonView = [self loadCellViewOriginY:CGRectGetMaxY(projectMoneyView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectFZPerson showRightView:NO isEdit:NO selectButtonForTag:107];
    [self.view addSubview:projectFZPersonView];
    
    UIView *projectMemberView = [self loadCellViewOriginY:CGRectGetMaxY(projectFZPersonView.frame) cellViewForHeight:50 leftImageName:@"icon_meeting" editView:self.projectMember showRightView:NO isEdit:NO selectButtonForTag:108];
    [self.view addSubview:projectMemberView];
    
    
    UIButton *newlyAdd = [[UIButton alloc]initWithFrame:(CGRectMake((self.view.frame.size.width-180)/2, CGRectGetMaxY(projectMemberView.frame)+80, 180, 40))];
    newlyAdd.backgroundColor = RGBA(88, 172, 239, 1);
    [newlyAdd setTitle:@"完成新建" forState:(UIControlStateNormal)];
    [newlyAdd setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    newlyAdd.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:newlyAdd];
    [newlyAdd addTarget:self action:@selector(newlyAddData:) forControlEvents:(UIControlEventTouchUpInside)];
    [MyPublicClass layerMasksToBoundsForAnyControls:newlyAdd cornerRadius:20 borderColor:nil borderWidth:0];
}

-(UIView  *)loadCellViewOriginY:(CGFloat)originY cellViewForHeight:(CGFloat)height leftImageName:(NSString *)imageName editView:(CXEditLabel *)editView showRightView:(BOOL)showView isEdit:(BOOL)isEdit selectButtonForTag:(NSInteger)tag{
    
    UIView *cellView = [[UIView alloc]initWithFrame:(CGRectMake(0, originY, self.view.frame.size.width, height))];
    cellView.backgroundColor = [UIColor whiteColor];
    
    CGFloat cellViewH = CGRectGetHeight(cellView.frame);
    CGFloat cellViewW = CGRectGetWidth(cellView.frame);
    
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRectMake(15, cellViewH-1, cellView.frame.size.width-30, 1))];
    lineView.backgroundColor = RGBA(242, 242, 242, 1);
    [cellView addSubview:lineView];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(30,0 , 25, cellViewH-1))];
    leftImageView.image = [UIImage imageNamed:imageName];
    leftImageView.contentMode = UIViewContentModeCenter;
    [cellView addSubview:leftImageView];
    
    
    if (showView == YES) {
        
         editView.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame)+15, 0, cellViewW-CGRectGetMaxX(leftImageView.frame)-30-50, cellViewH-1);
       
       self.voiceButton = [[UIButton alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(editView.frame), 0, 50, cellViewH-1))];
        self.voiceButton.hidden = YES;
        [self.voiceButton setImage:[UIImage imageNamed:@"annex_voice_y"] forState:(UIControlStateNormal)];
        [self.voiceButton addTarget:self action:@selector(saveVoice:) forControlEvents:(UIControlEventTouchUpInside)];
        [cellView addSubview:self.voiceButton];
        
    }else{
        editView.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame)+15, 0, cellViewW-CGRectGetMaxX(leftImageView.frame)-30, cellViewH-1);
    }
    
    editView.allowEditing = isEdit;
    [cellView addSubview:editView];
    
    UIButton *editButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editButton.tag = tag;
    editButton.frame = CGRectMake(editView.frame.origin.x, editView.frame.origin.y, editView.frame.size.width, editView.frame.size.height);
    [editButton addTarget:self action:@selector(clickWhichButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [cellView addSubview:editButton];
    if (isEdit == YES) {
        editButton.hidden = YES;
        
    }else{
        editButton.hidden = NO;
    }
    
    
    return cellView;
}
-(void)clickWhichButton:(UIButton *)sender{
    switch (sender.tag) {
        case 103:{
            
            [self listViewHidden:NO];
            [self listGroupeViewHidden:YES];
            if (!_showService) {
               [self loadPorjectStateService];
            }else{
                 [self loadListViewData:self.listDataArray];
            }
           
            
        }
            break;
        case 104:{
            
            [self listViewHidden:YES];
            [self listGroupeViewHidden:YES];
            ICEFORECIntroduceDetailViewController *detail = [[ICEFORECIntroduceDetailViewController alloc]init];
            detail.introduceDetailBlock = ^(ICEFORECVoiceModel * _Nonnull model) {
                if (![MyPublicClass stringIsNull:model.zhDesc]) {
                    self.projectPresent.content = model.zhDesc;
                }else{
                    self.projectPresent.content = @"";
                }
                if (![MyPublicClass stringIsNull:model.path]) {
                    self.voiceButton.hidden = NO;
                    self.pathName = model.srcName;
                }else{
                     self.voiceButton.hidden = YES;
                }
                
                self.zhDesc = model.zhDesc;
                self.voiceUrl = model.path;
                self.voiceTime = model.voiceTime;
                
            };
            [self.navigationController pushViewController:detail animated:YES];
            
            
        }
            break;
        case 105:{
            [self listGroupeViewHidden:NO];
            [self listViewHidden:YES];
            if (!_showGroup) {
                [self loadGroupService];
            }else{
                [self loadGroupListViewData:self.listGroupDataArray];
            }
            
        }
            break;
        case 107:{
            
            ICEFORCEPersonListViewController *scor = [[ICEFORCEPersonListViewController alloc]init];
            scor.titleString = @"项目负责人";
            scor.tempArray = [NSMutableArray arrayWithArray:self.pjFZArray];
            scor.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.pjFZArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userId];
                    [mutName addObject:model.userName];
                }
                self.projManagers = [mutData componentsJoinedByString:@","];
                self.projectFZPerson.content = [mutName componentsJoinedByString:@","];
            };
            [self.navigationController pushViewController:scor animated:YES];
            
            [self listGroupeViewHidden:YES];
            [self listViewHidden:YES];
        }
            break;
        case 108:{
            ICEFORCEPersonListViewController *scor = [[ICEFORCEPersonListViewController alloc]init];
            scor.titleString = @"小组成员";
            scor.tempArray = [NSMutableArray arrayWithArray:self.pjCYArray];
            scor.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.pjCYArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userId];
                    [mutName addObject:model.userName];
                }
                self.projTeams = [mutData componentsJoinedByString:@","];
                self.projectMember.content = [mutName componentsJoinedByString:@","];
            };
            [self.navigationController pushViewController:scor animated:YES];
            
            [self listGroupeViewHidden:YES];
            [self listViewHidden:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark -  项目状态列表请求
-(void)loadPorjectStateService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"newPotentialStatus" forKey:@"type"];
    
    
    [HttpTool getWithPath:GET_SYSCODE_QueryByType params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
             self.listDataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadListViewData:self.listDataArray];
            self.showService = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -  项目状态列表展示
-(void)loadListViewData:(NSArray *)dataArray{
    
    CXWeakSelf(self);
    self.listView.frame = CGRectMake(15, CGRectGetMaxY(self.projectStateView.frame), self.view.frame.size.width-30, dataArray.count *50);
    self.listView.dataArray = dataArray;
    self.listView.dataKey = @"codeNameZhCn";
    [self.view addSubview:self.listView];
    [self.listView reloadData];
    _listView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        weakself.projectState.content = [dataSource objectForKey:@"codeNameZhCn"];
        weakself.stsId = [dataSource objectForKey:@"codeKey"];
    };
    
}
-(void)listViewHidden:(BOOL)hidden{
    self.listView.hidden = hidden;
}

#pragma mark - 行业小组网络请求
-(void)loadGroupService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    
    [HttpTool getWithPath:GET_DEPT_QueryIndusDept params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            self.listGroupDataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadGroupListViewData:self.listGroupDataArray];
            self.showGroup = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 行业小组界面展示
-(void)loadGroupListViewData:(NSArray *)dataArray{
    
    CXWeakSelf(self);
    self.listGroupeView.frame = CGRectMake(15, CGRectGetMaxY(self.projectGroupeView.frame), self.view.frame.size.width-30, 200);
    self.listGroupeView.dataArray = dataArray;
    self.listGroupeView.dataKey = @"deptName";
    [self.view addSubview:self.listGroupeView];
    [self.listGroupeView reloadData];
    _listGroupeView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        weakself.projectGroup.content = [dataSource objectForKey:@"deptName"];
        weakself.indusGroup = [dataSource objectForKey:@"deptId"];
    };
    
}
-(void)listGroupeViewHidden:(BOOL)hidden{
    self.listGroupeView.hidden = hidden;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self listGroupeViewHidden:YES];
    [self listViewHidden:YES];
}

#pragma mark - 播放语音
-(void)saveVoice:(UIButton *)sender{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *docment = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *file = [docment stringByAppendingPathComponent:[NSString stringWithFormat:@"voice/%@",self.pathName]];
    if ([manger fileExistsAtPath:file]) {
        [self playNetWorkAudioByPath:file];
    }
    
}
// 播放录音文件
- (void)playNetWorkAudioByPath:(NSString *)audioPath {
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager playAudioWithFileName:audioPath delegate:self];
}
//停止播放录音
- (void)playingStoped {
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
    
    
}
- (void)dealloc {
    //暂停录音播放
    [self playingStoped];
    
}
#pragma mark - 新建潜在项目
-(void)newlyAddData:(UIButton *)sender{
    
    if ([MyPublicClass stringIsNull:self.pjName]) {
        CXAlert(@"项目名称不能为空");
        return;
    }
    if ([MyPublicClass stringIsNull:self.stsId]) {
        CXAlert(@"项目状态不能为空");
        return;
    }
    if ([MyPublicClass stringIsNull:self.indusGroup]) {
        CXAlert(@"行业小组不能为空");
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.pjName forKey:@"projName"];
    [dic setValue:self.stsId forKey:@"stsId"];
    [dic setValue:self.zhDesc forKey:@"zhDesc"];
    [dic setValue:self.indusGroup forKey:@"indusGroup"];
    [dic setValue:self.planInvAmount forKey:@"planInvAmount"];
    [dic setValue:self.projManagers forKey:@"projManagers"];
    [dic setValue:self.projTeams forKey:@"projTeams"];
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:self.teamDesc forKey:@"teamDesc"];
    [dic setValue:self.voiceUrl forKey:@"voiceUrl"];
    [dic setValue:@(self.voiceTime) forKey:@"audioTime"];
   
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_PROJ_Add params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            if (self.newlyAddBlock) {
                self.newlyAddBlock(YES);
            }
            
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            CXAlert(@"保存失败");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
        
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
