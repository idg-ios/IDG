//
//  ICEFORCEPotentialDetailViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPotentialDetailViewController.h"

#import "HttpTool.h"

#import "ICEFORCEPotentialDetailTableViewCell.h"
#import "ICEFORCEPotentialDetailOtherTableViewCell.h"
#import "ICEFORCEPotentialDetailTopHeadView.h"
#import "ICEFORCEPotentialDetailOtherHeadView.h"
#import "ICEFORCEPotentialDetailFooterView.h"

#import "ICEFORCEPotentialDetailBottomView.h"
#import "ICEFORCESelectListView.h"
#import "ICEFORCEPotentialDetailModel.h"
#import "ICEFORCEWorkProjectModel.h"

#import "ICEFORCEScoreRecordViewController.h"
#import "ICEFORCEProjectShareViewController.h"
#import "ICEFORCEPorjecDetailViewController.h"
#import "ICEFORCEAddlyPorjecViewController.h"
#import "ICEFORCEQZProjectEditViewController.h"

@interface ICEFORCEPotentialDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailTopHeadView *topHeadView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailOtherHeadView *presentHeadView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailOtherHeadView *progressHeadView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailOtherHeadView *enclosureHeadView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailFooterView *footerView;

@property (nonatomic ,strong) ICEFORCEPotentialDetailBottomView *bottomView;

@property (nonatomic ,strong)  ICEFORCEPotentialDetailModel *detailModel ;

@property (nonatomic ,strong) NSMutableArray *projectArray;
/** 权限列表 */
@property (nonatomic ,copy) NSArray *segmentList;

@property (nonatomic ,strong) ICEFORCESelectListView *pjStateListView;

@end

@implementation ICEFORCEPotentialDetailViewController

-(NSMutableArray *)projectArray{
    if (!_projectArray) {
        _projectArray = [[NSMutableArray alloc]init];
    }
    return _projectArray;
}

-(ICEFORCEPotentialDetailTopHeadView *)topHeadView{
    if (!_topHeadView) {
        _topHeadView = [ICEFORCEPotentialDetailTopHeadView viewFromXIB];
    }
    return _topHeadView;
}
-(ICEFORCEPotentialDetailOtherHeadView *)presentHeadView{
    if (!_presentHeadView) {
        _presentHeadView = [ICEFORCEPotentialDetailOtherHeadView viewFromXIB];
        _presentHeadView.nameLabel.text = @"项目介绍";
        _presentHeadView.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _presentHeadView.mroeButton.hidden = YES;
        
    }
    return _presentHeadView;
}

-(ICEFORCEPotentialDetailOtherHeadView *)progressHeadView{
    if (!_progressHeadView) {
        _progressHeadView = [ICEFORCEPotentialDetailOtherHeadView viewFromXIB];
        _progressHeadView.nameLabel.text = @"跟踪进展";
        _progressHeadView.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _progressHeadView.mroeButton.hidden = YES;
        _progressHeadView.descLabel.hidden = YES;
        
    }
    return _progressHeadView;
}
-(ICEFORCEPotentialDetailOtherHeadView *)enclosureHeadView{
    if (!_enclosureHeadView) {
        _enclosureHeadView = [ICEFORCEPotentialDetailOtherHeadView viewFromXIB];
        _enclosureHeadView.nameLabel.text = @"相关附件";
        _enclosureHeadView.nameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _enclosureHeadView;
}

-(ICEFORCEPotentialDetailFooterView *)footerView{
    if (!_footerView) {
        _footerView = [ICEFORCEPotentialDetailFooterView viewFromXIB];
    }
    return _footerView;
}

-(ICEFORCEPotentialDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [ICEFORCEPotentialDetailBottomView viewFromXIB];
    }
    return _bottomView;
}
-(ICEFORCESelectListView *)pjStateListView{
    if (!_pjStateListView) {
        _pjStateListView = [[ICEFORCESelectListView alloc]init];
        _pjStateListView.hidden = YES;
        
    }
    return _pjStateListView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    [self loadService];
}
-(void)loadSubView{

    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.model.projName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"shareTop"] addTarget:self action:@selector(share:)];
    
    [rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"EditImg"] addTarget:self action:@selector(edit:)];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(rootTopView.frame)-90)) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
    [self.view addSubview:self.bottomView];
    [self.bottomView.addButton addTarget:self action:@selector(newAddlyGZ:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView.changeStateButton addTarget:self action:@selector(changeState:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.footerView.seeMoreButton addTarget:self action:@selector(seeMore:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return self.projectArray.count;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 0;
    }else if (indexPath.section == 1){
        
        CGSize size = [MyPublicClass boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) withTextFont:[UIFont systemFontOfSize:15] content:self.detailModel.zhDesc];
        
        if (size.height > 51) {
            return size.height;
        }else{
            return 50;
        }
        
    }else if (indexPath.section == 2){
        return 50;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 180;
    }else if (section == 1){
        return 40;
    }else if (section == 2){
        return 40;
    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 6;
    }else if (section == 1){
        return 6;
    }else if (section == 2){
        return 60;
    }else{
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        self.topHeadView.indusGLabel.text = self.detailModel.indusGroupStr;
        
        self.topHeadView.memberLabel.text = self.detailModel.projTeamNames;
        
        self.topHeadView.pjMangeName.text = self.detailModel.projManagerNames;
        
        self.topHeadView.invLabel.text = self.detailModel.planInvAmount;
        
        self.topHeadView.stateLabel.text = self.detailModel.stsIdStr;
        
        
        return self.topHeadView;
    }else if (section == 1){
        return self.presentHeadView;
    }else if (section == 2){
        return self.progressHeadView;
    }else{
        
        NSArray *progresArray = self.segmentList;
        for (NSDictionary *progresDic in progresArray) {
            NSString *codeString = [progresDic objectForKey:@"code"];
            if ([codeString isEqualToString:@"fileInfo"]) {
                if ([MyPublicClass stringIsNull:[progresDic objectForKey:@"desc"]]) {
                    self.progressHeadView.descLabel.text =@"";
                }else{
                    self.progressHeadView.descLabel.text =[progresDic objectForKey:@"desc"];
                }
                
            }
        }
        return self.enclosureHeadView;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else if (section == 1){
        return nil;
    }else if (section == 2){
        return self.footerView;
    }else{
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        static NSString *presentDetailCell = @"presentDetailCell";
        
        ICEFORCEPotentialDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:presentDetailCell];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPotentialDetailTableViewCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.option = ICEFORCEPotentialDetailCellOptionText;
        cell.attString = self.detailModel.zhDesc;
        
        return cell;
    }else if (indexPath.section == 2){
        
        static NSString *progressDetailCell = @"progressDetailCell";
        
        ICEFORCEPotentialDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:progressDetailCell];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPotentialDetailTableViewCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ICEFORCEWorkProjectModel *model = [self.projectArray objectAtIndex:indexPath.row];
        
        NSString *contentType = model.noteType;
        NSString *followType = model.followType;
        
        if ([contentType isEqualToString:@"TEXT"]) {
            if ([followType isEqualToString:@"UPDATE_STATE"]) {
                
                cell.option = ICEFORCEPotentialDetailCellOptionState;

            }else{
                cell.option = ICEFORCEPotentialDetailCellOptionAttText;

            }
            
        }else{
            cell.option = ICEFORCEPotentialDetailCellOptionVoice;
        }
        
        cell.model = model;
        
        return cell;
    }else if (indexPath.section == 3){
        
        static NSString *progressOtherDetailCell = @"progressOtherDetailCell";
        
        ICEFORCEPotentialDetailOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:progressOtherDetailCell];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPotentialDetailOtherTableViewCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *progresArray = self.segmentList;
        for (NSDictionary *progresDic in progresArray) {
            NSString *codeString = [progresDic objectForKey:@"code"];
            if ([codeString isEqualToString:@"gradeInfo"]) {
                cell.descLabel.text = [progresDic objectForKey:@"desc"];
            }
        }
        
        return cell;
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 3:{
            ICEFORCEScoreRecordViewController *score = [[ICEFORCEScoreRecordViewController alloc]init];
            score.projId = self.model.projId;
            [self.navigationController pushViewController:score animated:YES];
        }
            break;
            
        default:
            break;
    }
    self.pjStateListView.hidden = YES;
    self.bottomView.changeStateButton.selected = NO;
}


#pragma mark - 项目编辑
-(void)edit:(UIButton *)sender{
    ICEFORCEQZProjectEditViewController *edit = [[ICEFORCEQZProjectEditViewController alloc]init];
    edit.QZProjectEditBlock = ^(NSString * _Nonnull message) {
        
        [self loadService];
    };
    edit.model = self.detailModel;
    [self.navigationController pushViewController:edit animated:YES];
}
#pragma mark - 项目分享页面
-(void)share:(UIButton *)sneder{
    ICEFORCEProjectShareViewController *share = [[ICEFORCEProjectShareViewController alloc]init];
    share.pjName = self.model.projName;
    share.projId = self.model.projId;
    [self.navigationController pushViewController:share animated:YES];
}

#pragma mark - 点击变更项目状态
-(void)changeState:(UIButton *)sender{
    
    if ((sender.selected =! sender.selected)) {
        self.pjStateListView.hidden = NO;
        [self loadPorjectStateService];
        
    }else{
        self.pjStateListView.hidden = YES;
        
    }
    
}
#pragma mark - 点击新增跟踪进展
-(void)newAddlyGZ:(UIButton *)sender{
    ICEFORCEAddlyPorjecViewController *addGZ = [[ICEFORCEAddlyPorjecViewController alloc]init];
    addGZ.AddlPJRefreshBlock = ^(NSString * _Nonnull messgae) {
        [self loadService];
    };
    addGZ.pjName = self.model.projName;
    addGZ.pjNameID = self.model.projId;
    [self.navigationController pushViewController:addGZ animated:YES];
}

#pragma mark - 查看跟多项目进展
-(void)seeMore:(UIButton *)sender{
    
    ICEFORCEPorjecDetailViewController *pjGZ = [[ICEFORCEPorjecDetailViewController alloc]init];
      pjGZ.pjId = self.model.projId;
    pjGZ.navString = self.model.projName;
    [self.navigationController pushViewController:pjGZ animated:YES];
}

#pragma mark - 网络请求
-(void)loadService{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        [self loadPJDetailService:semaphore];
    });
    dispatch_group_async(group, queue, ^{
        [self loadSNSFloowService:semaphore];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
}

#pragma mark - 跟踪进展详情网络请求
-(void)loadPJDetailService:(dispatch_semaphore_t)semaphore{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:self.model.projId forKey:@"projId"];
    [dic setValue:VAL_Account forKey:@"username"];
    
    [HttpTool getWithPath:GET_PROJ_Query_Detail params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSDictionary *dataDic = [[[JSON objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"baseInfoMap"];
            self.detailModel = [ICEFORCEPotentialDetailModel modelWithDict:dataDic];
            self.segmentList = [[[JSON objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"segmentList"];
            self.bottomView.stateLabel.text = [NSString stringWithFormat:@"项目状态:%@",self.detailModel.stsIdStr];

            dispatch_semaphore_signal(semaphore);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
#pragma mark - 跟踪进展网络请求
-(void)loadSNSFloowService:(dispatch_semaphore_t)semaphore{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(0) forKey:@"pageNo"];
    [dic setValue:@(3) forKey:@"pageSize"];
    [dic setValue:self.model.projId forKey:@"projId"];
    [self.projectArray removeAllObjects];
    [HttpTool postWithPath:POST_PROJ_Notes params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            for (NSDictionary *dataDic in dataArray) {
                ICEFORCEWorkProjectModel *model = [ICEFORCEWorkProjectModel modelWithDict:dataDic];
                [self.projectArray addObject:model];
                
            }
            dispatch_semaphore_signal(semaphore);
        }
       
        
    } failure:^(NSError *error) {
        
    }];
    
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
    self.pjStateListView.frame = CGRectMake(0, CGRectGetMinY(self.bottomView.frame)-dataArray.count *50+40, self.view.frame.size.width, dataArray.count *50);
    self.pjStateListView.dataArray = dataArray;
    self.pjStateListView.dataKey = @"codeNameZhCn";
    self.pjStateListView.changeColor = [UIColor blueColor];
    [self.view addSubview:self.pjStateListView];
    [self.pjStateListView reloadData];
    _pjStateListView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        [weakself changeStateService:[dataSource objectForKey:@"codeKey"] codeName:[dataSource objectForKey:@"codeNameZhCn"]];
    };
    
}
#pragma mark - 项目变更请求
-(void)changeStateService:(NSString *)stsId codeName:(NSString *)codeNameZhCn{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:self.model.projId forKey:@"projId"];
    [dic setValue:stsId forKey:@"stsId"];

    
    [HttpTool postWithPath:POST_PROJ_ChangeStatus params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            self.bottomView.stateLabel.text = [NSString stringWithFormat:@"项目状态:%@",codeNameZhCn];
            self.topHeadView.stateLabel.text = codeNameZhCn;
            CXAlert(@"变更成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:AppStateDidChangeNotification object:nil];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.pjStateListView.hidden = YES;
    self.bottomView.changeStateButton.selected = NO;
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
