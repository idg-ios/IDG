//
//  ICEFORCEQZProjectEditViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/19.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEQZProjectEditViewController.h"

#import "HttpTool.h"
#import "MBProgressHUD+CXCategory.h"

#import "ICEFORCESelectListView.h"
#import "ICEFORCEPickerViewController.h"
#import "ICEFORCEPersonListViewController.h"

@interface ICEFORCEQZProjectEditViewController ()

/** 行业小组 */
@property (nonatomic ,strong) UITextField *teamTextField;
@property (nonatomic ,strong) ICEFORCESelectListView *teamListView;
@property (nonatomic ,strong) NSString *teamID;
@property (nonatomic ,strong) UIView *teamView;
@property (nonatomic ,assign) BOOL teamListViewIsShow;

/** 行业状态 */
@property (nonatomic ,strong) UITextField *stateTextField;
@property (nonatomic ,strong) ICEFORCESelectListView *stateListView;
@property (nonatomic ,strong) NSString *stateID;
@property (nonatomic ,strong) UIView *stateView;
@property (nonatomic ,assign) BOOL stateListViewIsShow;

/** 行业内容 */
@property (nonatomic ,strong) UITextField *pjDescTextField;

/** 行业技能 */
@property (nonatomic ,strong) UITextField *skillTextField;
@property (nonatomic ,strong) ICEFORCEPickerViewController *pickerView;
@property (nonatomic ,strong) NSString *skillKey;

/** 行业金额 */
@property (nonatomic ,strong) UITextField *moneyTextField;

/** 行业负责人 */
@property (nonatomic ,strong) UITextField *chargeTextField;
@property (nonatomic ,strong) NSArray *chargeArray;
@property (nonatomic ,strong) NSString *chargeString;

/** 行业小组成员 */
@property (nonatomic ,strong) UITextField *memberTextField;
@property (nonatomic ,strong) NSArray *memberArray;
@property (nonatomic ,strong) NSString *memberString;


@end

@implementation ICEFORCEQZProjectEditViewController

#pragma mark - 懒加载
-(UITextField *)teamTextField{
    if (!_teamTextField) {
        _teamTextField = [[UITextField alloc]init];
        _teamTextField.textColor = [UIColor grayColor];
    }
    return _teamTextField;
}
-(ICEFORCESelectListView *)teamListView{
    if (!_teamListView) {
        _teamListView = [[ICEFORCESelectListView alloc]init];
        _teamListView.hidden = YES;
    }
    return _teamListView;
}


-(UITextField *)stateTextField{
    if (!_stateTextField) {
        _stateTextField = [[UITextField alloc]init];
        _stateTextField.textColor = [UIColor grayColor];
    }
    return _stateTextField;
}
-(ICEFORCESelectListView *)stateListView{
    if (!_stateListView) {
        _stateListView = [[ICEFORCESelectListView alloc]init];
        _stateListView.hidden = YES;
    }
    return _stateListView;
}

-(UITextField *)pjDescTextField{
    if (!_pjDescTextField) {
        _pjDescTextField = [[UITextField alloc]init];
        _pjDescTextField.textColor = [UIColor grayColor];

    }
    return _pjDescTextField;
}
-(UITextField *)skillTextField{
    if (!_skillTextField) {
        _skillTextField = [[UITextField alloc]init];
        _skillTextField.textColor = [UIColor grayColor];

    }
    return _skillTextField;
}


-(UITextField *)moneyTextField{
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc]init];
        _moneyTextField.textColor = [UIColor grayColor];

    }
    return _moneyTextField;
}
-(UITextField *)chargeTextField{
    if (!_chargeTextField) {
        _chargeTextField = [[UITextField alloc]init];
        _chargeTextField.textColor = [UIColor blueColor];

    }
    return _chargeTextField;
}
-(UITextField *)memberTextField{
    if (!_memberTextField) {
        _memberTextField = [[UITextField alloc]init];
        _memberTextField.textColor = [UIColor blueColor];

    }
    return _memberTextField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
}
-(void)loadSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.model.projName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    UIView *teamView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.teamTextField textFieldPlaceholder:@"" textFieldIsEdit:NO buttonTag:101];
    [self.view addSubview:teamView];
    self.teamView = teamView;
    self.teamListViewIsShow = YES;

    
    UIView *stateView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(teamView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.stateTextField textFieldPlaceholder:@"" textFieldIsEdit:NO buttonTag:102];
    [self.view addSubview:stateView];
    self.stateView = stateView;
    self.stateListViewIsShow = YES;
    
    
    UIView *descView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(stateView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.pjDescTextField textFieldPlaceholder:@"请输入项目介绍" textFieldIsEdit:YES buttonTag:103];
    [self.view addSubview:descView];
    
    UIView *skillView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(descView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.skillTextField textFieldPlaceholder:@"请选择行业" textFieldIsEdit:NO buttonTag:104];
    [self.view addSubview:skillView];
    
    UIView *moneyView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(skillView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.moneyTextField textFieldPlaceholder:@"请输入拟投金额" textFieldIsEdit:YES buttonTag:105];
    [self.view addSubview:moneyView];
    
    UIView *chargeView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(moneyView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.chargeTextField textFieldPlaceholder:@"请选择行业负责人" textFieldIsEdit:NO buttonTag:106];
    [self.view addSubview:chargeView];
    
    UIView *memberView = [self loadSubViewForRect:(CGRectMake(0, CGRectGetMaxY(chargeView.frame), self.view.frame.size.width, 50)) leftImageName:@"icon_meeting" textField:self.memberTextField textFieldPlaceholder:@"请选择小组成员" textFieldIsEdit:NO buttonTag:107];
    [self.view addSubview:memberView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:(CGRectMake( self.view.frame.size.width/4, CGRectGetMaxY(memberView.frame)+100, self.view.frame.size.width/2, 40))];
    button.backgroundColor = RGBA(88, 172, 239, 1);
    [button setTitle:@"完成" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(subtim:) forControlEvents:(UIControlEventTouchUpInside)];
    [MyPublicClass layerMasksToBoundsForAnyControls:button cornerRadius:button.frame.size.height/2 borderColor:nil borderWidth:0];
    
    [self loadDataSource];
}
#pragma mark - 数据初始化
-(void)loadDataSource{
    self.teamTextField.text = self.model.indusGroupStr;
    self.stateTextField.text = self.model.stsIdStr;
    self.pjDescTextField.text = self.model.zhDesc;
    self.skillTextField.text = self.model.comInduStr;
    self.moneyTextField.text = self.model.planInvAmount;
    self.chargeTextField.text = self.model.projManagerNames;
    self.memberTextField.text = self.model.projTeamNames;
    
    self.teamID = self.model.indusGroup;
    self.stateID = self.model.stsId;
    self.skillKey = self.model.comIndu;
    self.chargeString = self.model.projManagers;
    self.memberString = self.model.projTeams;
}
#pragma mark - 界面布局
-(UIView *)loadSubViewForRect:(CGRect)rect leftImageName:(NSString *)imageName textField:(UITextField *)textField textFieldPlaceholder:(NSString *)placeholder textFieldIsEdit:(BOOL)isEdit buttonTag:(NSInteger)tag{
    UIView *subView = [[UIView alloc]initWithFrame:rect];
    
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRectMake(15, CGRectGetHeight(subView.frame)-1, CGRectGetWidth(subView.frame)-30, 1))];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [subView addSubview:lineView];
    
    UIImageView *letfImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(15, 0, 40, CGRectGetHeight(subView.frame)-1))];
    letfImageView.image = [UIImage imageNamed:imageName];
    letfImageView.contentMode = UIViewContentModeCenter;
    [subView addSubview:letfImageView];
    
    textField.frame = CGRectMake(CGRectGetMaxX(letfImageView.frame), 0, CGRectGetWidth(subView.frame)-CGRectGetMaxX(letfImageView.frame)-15, CGRectGetHeight(subView.frame)-1);
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeholder;
    [subView addSubview:textField];
    textField.userInteractionEnabled = isEdit;
    
    UIButton *editButton = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame)))];
    editButton.hidden = isEdit;
    editButton.tag = tag;
    [editButton addTarget:self action:@selector(edit:) forControlEvents:(UIControlEventTouchUpInside)];
    [subView addSubview:editButton];
    
    return subView;
    
}

-(void)edit:(UIButton *)sender{
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 101:{
            if (self.teamListViewIsShow == YES) {
                
                self.teamListView.hidden = NO;
                self.teamListViewIsShow = NO;
                [self loadGroupService];
            }else{
                self.teamListView.hidden = YES;
                self.teamListViewIsShow = YES;
            }
        }
            break;
            
        case 102:{
            if (self.stateListViewIsShow == YES) {
                
                self.stateListView.hidden = NO;
                self.stateListViewIsShow = NO;
                [self loadPorjectStateService];
            }else{
                self.stateListView.hidden = YES;
                self.stateListViewIsShow = YES;
            }
        }
            break;
        case 104:{
            
           
            [self LoadSkillService];
        }
            break;
        case 106:{
            ICEFORCEPersonListViewController *scor = [[ICEFORCEPersonListViewController alloc]init];
            scor.titleString = @"项目负责人";
            scor.tempArray = [NSMutableArray arrayWithArray:self.chargeArray];
            scor.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.chargeArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userId];
                    [mutName addObject:model.userName];
                }
                 self.chargeString = [mutData componentsJoinedByString:@","];
                 self.chargeTextField.text = [mutName componentsJoinedByString:@","];
            };
            [self.navigationController pushViewController:scor animated:YES];
        }
            break;
        case 107:{
            ICEFORCEPersonListViewController *scor = [[ICEFORCEPersonListViewController alloc]init];
            scor.titleString = @"小组成员";
            scor.tempArray = [NSMutableArray arrayWithArray:self.memberArray];
            scor.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.memberArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userId];
                    [mutName addObject:model.userName];
                }
                self.memberString = [mutData componentsJoinedByString:@","];
                self.memberTextField.text = [mutName componentsJoinedByString:@","];
            };
            [self.navigationController pushViewController:scor animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - 行业小组网络请求
-(void)loadGroupService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    
    [HttpTool getWithPath:GET_DEPT_QueryIndusDept params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray * listGroupDataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadGroupListViewData:listGroupDataArray];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 行业小组界面展示
-(void)loadGroupListViewData:(NSArray *)dataArray{
    CXWeakSelf(self);
    self.teamListView.frame = CGRectMake(15, CGRectGetMaxY(self.teamView.frame), self.view.frame.size.width-30, 300);
    self.teamListView.dataArray = dataArray;
    self.teamListView.dataKey = @"deptName";
    [self.view addSubview:self.teamListView];
    [self.teamListView reloadData];
    _teamListView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        weakself.teamTextField.text = [dataSource objectForKey:@"deptName"];
        weakself.teamID = [dataSource objectForKey:@"deptId"];
        weakself.teamListViewIsShow = YES;

    };
    
}

#pragma mark -  项目状态列表请求
-(void)loadPorjectStateService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"potentialStatus" forKey:@"type"];
    
    
    [HttpTool getWithPath:GET_SYSCODE_QueryByType params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray * listDataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadListViewData:listDataArray];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 项目状态列表展示
-(void)loadListViewData:(NSArray *)dataArray{
    
    CXWeakSelf(self);
    self.stateListView.frame = CGRectMake(0, CGRectGetMaxY(self.stateView.frame), self.view.frame.size.width, dataArray.count *50);
    self.stateListView.dataArray = dataArray;
    self.stateListView.dataKey = @"codeNameZhCn";
    [self.view addSubview:self.stateListView];
    [self.stateListView reloadData];
    _stateListView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        weakself.stateTextField.text = [dataSource objectForKey:@"codeNameZhCn"];
        weakself.stateID = [dataSource objectForKey:@"codeKey"];
        weakself.stateListViewIsShow = YES;

    };
}

#pragma mark - 获取行业
-(void)LoadSkillService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"induType" forKey:@"type"];

    [HttpTool getWithPath:GET_SYSCODE_QueryByType params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray * dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadPickerViewForData:dataArray];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - x行业列表展示
-(void)loadPickerViewForData:(NSArray *)data{
    CXWeakSelf(self);
    self.pickerView = [[ICEFORCEPickerViewController alloc]init];
    self.pickerView.SelectBlock = ^(ICEFORCEPickerModel * _Nonnull model) {
        weakself.skillTextField.text = model.codeNameZhCn;
        weakself.skillKey = model.codeKey;
    };
    self.pickerView.dataArray = data;
    self.pickerView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:self.pickerView animated:YES completion:^{
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.teamListView.hidden = YES;
    self.teamListViewIsShow = YES;
    
    self.stateListView.hidden = YES;
    self.stateListViewIsShow = YES;
}

#pragma mark - 提交数据
-(void)subtim:(UIButton *)sender{
    
    if ([MyPublicClass stringIsNull:self.teamTextField.text]) {
        CXAlert(@"行业小组不能为空");
        return;
    }
    
    if ([MyPublicClass stringIsNull:self.stateTextField.text]) {
        CXAlert(@"行业状态不能为空");
        return;
    }
    
    if ([MyPublicClass stringIsNull:self.skillTextField.text]) {
        CXAlert(@"行业技能不能为空");
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.model.projName forKey:@"projName"];
    [dic setValue:self.model.projId forKey:@"projId"];
    [dic setValue:self.stateID forKey:@"stsId"];
    [dic setValue:self.pjDescTextField.text forKey:@"zhDesc"];
    [dic setValue:self.teamID forKey:@"indusGroup"];
    [dic setValue:self.skillKey forKey:@"comIndu"];
    [dic setValue:self.moneyTextField.text forKey:@"planInvAmount"];
    [dic setValue:self.chargeString forKey:@"projManagers"];
    [dic setValue:self.memberString forKey:@"projTeams"];
    [dic setValue:VAL_Account forKey:@"username"];
    
    [self updateService:dic];
    
}
-(void)updateService:(NSMutableDictionary *)data{
    
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_PROJ_Update params:data success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            if (self.QZProjectEditBlock) {
                self.QZProjectEditBlock(@"ok");
            }
            
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            CXAlert(@"提交失败");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
        
    }];
    
    
    

    
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
