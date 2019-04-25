//
//  ICEFORCEScoreRecordViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEScoreRecordViewController.h"

#import "HttpTool.h"

#import "ICEFORCEDefaultTableViewCell.h"
#import "ICEFORCEScoreTableViewCell.h"
#import "ICEFORCEScoreHeadView.h"

#import "ICEFORCEScoreRecordModel.h"
#import "ICEFORCEScoreRecordCellModel.h"

@interface ICEFORCEScoreRecordViewController ()<UITableViewDelegate,UITableViewDataSource,ICEFORCEScoreHeadDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) ICEFORCEScoreHeadView *headView;
@property (nonatomic ,strong) NSMutableArray *dataSectionArray;
@property (nonatomic ,strong) NSMutableArray *topDataArray;
@property (nonatomic ,strong) NSMutableArray *otherDataArray;


@end

@implementation ICEFORCEScoreRecordViewController


-(NSMutableArray *)otherDataArray{
    if (!_otherDataArray) {
        _otherDataArray = [[NSMutableArray alloc]init];
    }
    return _otherDataArray;
}
-(NSMutableArray *)topDataArray{
    if (!_topDataArray) {
        _topDataArray = [[NSMutableArray alloc]init];
    }
    return _topDataArray;
}
-(NSMutableArray *)dataSectionArray{
    if (!_dataSectionArray) {
        _dataSectionArray = [[NSMutableArray alloc]init];
    }
    return _dataSectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    
    [self loadServicee];
    
}

-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"评分记录"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, Screen_Height-CGRectGetMaxY(rootTopView.frame))) style:(UITableViewStyleGrouped)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSectionArray count]+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.topDataArray count]+1;
    }else{
        ICEFORCEScoreRecordModel *model = [self.dataSectionArray objectAtIndex:section-1];
        if (model.isShowSection == NO) {
            return 0;
        }else{
            return [[self.otherDataArray objectAtIndex:section-1] count]+1;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
        
    }else{
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else{
        ICEFORCEScoreRecordModel *model = [self.dataSectionArray objectAtIndex:section-1];
        _headView = [ICEFORCEScoreHeadView viewFromXIB];
        _headView.dateLabel.text = model.scoreDate;
        _headView.comLabel.text = [NSString stringWithFormat:@"已有%ld人打分",(long)model.scoreCount.integerValue];
        _headView.delegate = self;
        _headView.section = section;
        return _headView;
    }
    
}
-(void)selectSection:(NSInteger)section selectButton:(nonnull UIButton *)sender{
    
    ICEFORCEScoreRecordModel *model = [self.dataSectionArray objectAtIndex:section-1];
    
    if (model.isShowSection == NO) {
        model.isShowSection = YES;
        //        [self sectionListService:model selectSection:section];
    }else{
        model.isShowSection = NO;
        
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
}
#pragma mark - 分区列表请求网络
//-(void)sectionListService:(ICEFORCEScoreRecordModel *)model selectSection:(NSInteger)section{
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    
//    [dic setValue:model.scoreDate forKey:@"scoreDate"];
//    [dic setValue:model.projId forKey:@"projId"];
//    
//    
//    [HttpTool postWithPath:POST_PROJ_Score_Detail params:dic success:^(id JSON) {
//        NSInteger status = [JSON[@"status"] integerValue];
//        if (status == 200) {
//            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
//            NSMutableArray *dataMutArray = [[NSMutableArray alloc]init];
//            for (NSDictionary *dataDic in dataArray) {
//                
//                ICEFORCEScoreRecordCellModel *scoreCell = [ICEFORCEScoreRecordCellModel modelWithDict:dataDic];
//                [dataMutArray addObject:scoreCell];
//            }
//             [self.otherDataArray addObject:dataMutArray];
//             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
//}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        static NSString *DefaultCell = @"DefaultCell";
        
        ICEFORCEDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultCell];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEDefaultTableViewCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }else{
        
        static NSString *ScoreCell = @"ScoreCell";
        
        ICEFORCEScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScoreCell];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEScoreTableViewCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0 ) {
            
            ICEFORCEScoreRecordCellModel *model = [self.topDataArray objectAtIndex:indexPath.row-1];
            cell.model = model;
        }else{
            ICEFORCEScoreRecordCellModel *model = [[self.otherDataArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
            cell.model = model;
        }
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 跟踪项目进展网络请求
-(void)loadServicee{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:self.projId forKey:@"projId"];
    
    
    [HttpTool postWithPath:POST_PROJ_Score_List params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray *dataArray = [[[JSON objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"latest"];
            for (NSDictionary *dataDic in dataArray) {
                
                ICEFORCEScoreRecordCellModel *scoreCell = [ICEFORCEScoreRecordCellModel modelWithDict:dataDic];
                [self.topDataArray addObject:scoreCell];
            }
            
            NSArray *historyArray = [[[JSON objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"history"];
            for (NSDictionary *historyDic in historyArray) {
                NSDictionary *historyInfo = [historyDic objectForKey:@"baseInfo"];
                ICEFORCEScoreRecordModel *model = [ICEFORCEScoreRecordModel modelWithDict:historyInfo];
                model.isShowSection = NO;
                [self.dataSectionArray addObject:model];
            }
            
            NSArray *listArray = [[[JSON objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"history"];
            
            for (NSDictionary *listDic in listArray) {
                
                NSArray *list = [listDic objectForKey:@"list"];
                NSMutableArray *listMut = [[NSMutableArray alloc]init];
                for (NSDictionary *listDic2 in list) {
                    ICEFORCEScoreRecordCellModel *listModel = [ICEFORCEScoreRecordCellModel modelWithDict:listDic2];
                    [listMut addObject:listModel];
                }
                [self.otherDataArray addObject:listMut];
                
            }
            
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        
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
