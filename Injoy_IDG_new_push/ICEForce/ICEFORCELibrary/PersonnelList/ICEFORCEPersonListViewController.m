//
//  ICEFORCEPersonListViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/18.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPersonListViewController.h"
#import "HttpTool.h"

#import "ICEFORCEPersonListTableViewCell.h"


@interface ICEFORCEPersonListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ICEFORCEPersonListDelegate>
@property (nonatomic ,strong) MyPublicTextField *textField;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

/** 存放临时数据 */
@property (nonatomic ,strong) NSMutableArray<ICEFORCEPersonListModel *> *temporaryArray;

@end

@implementation ICEFORCEPersonListViewController

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}
-(NSMutableArray *)temporaryArray{
    if (!_temporaryArray) {
        _temporaryArray = [[NSMutableArray alloc]init];
    }
    return _temporaryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    if (self.tempArray.count != 0) {
        self.temporaryArray = self.tempArray;
    }
    [self loadService:@""];
}
-(void)loadSubView{
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.titleString];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(save:)];
    
    
    MyPublicTextField *oldField = [[MyPublicTextField alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, 45))];
    oldField.delegate = self;
    oldField.textRectDx = 37;
    oldField.editingRectDx = 37;
    oldField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [MyPublicClass setTextField:oldField placeholderColor:[MyPublicClass colorWithHexString:@"#999999"]];
    oldField.backgroundColor = [UIColor whiteColor];
    oldField.placeholder = @"搜索";
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, 25, 25))];
    leftImageView.image = [UIImage imageNamed:@"mine_search"];
    oldField.leftView = leftImageView;
    oldField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:oldField];
    self.textField = oldField;
    [oldField addTarget:self action:@selector(editChange:) forControlEvents:(UIControlEventEditingChanged)];

    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(oldField.frame), self.view.frame.size.width, Screen_Height-CGRectGetMaxY(oldField.frame))) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *listCell = @"listCell";
    
    ICEFORCEPersonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPersonListTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ICEFORCEPersonListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (self.temporaryArray.count>0) {
        for (ICEFORCEPersonListModel *tepModel in self.temporaryArray) {
            if ([tepModel.userName isEqualToString:model.userName]) {
                model = tepModel;
            }
        }
    }
    
    
    cell.model = model;
    cell.path = indexPath;
    cell.delegateCell = self;
    
    return cell;
}

-(void)selectCell:(ICEFORCEPersonListTableViewCell *)cell selectButton:(nonnull UIButton *)sender selectIndex:(nonnull NSIndexPath *)index{
    
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"onSelected"] forState:(UIControlStateSelected)];
    }else{
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"outSelected"] forState:(UIControlStateNormal)];
    }
    
    ICEFORCEPersonListModel *model = [self.dataArray objectAtIndex:index.row];
    model.isSelect = sender.selected;
    if (sender.selected == YES) {
        [self.temporaryArray addObject:model];
    }else{
       
        for (int i = 0; i<self.temporaryArray.count; i++) {
            ICEFORCEPersonListModel *tempModel = [self.temporaryArray objectAtIndex:i];
            if ([tempModel.userName isEqualToString:model.userName]) {
                [self.temporaryArray removeObject:tempModel];

            }
        }
        
    }
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index.row inSection:index.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.textField endEditing:YES];
}

#pragma 保存
-(void)save:(UIButton *)sender{
    [self.textField endEditing:YES];
    
    if (self.temporaryArray.count != 0) {
        if (self.selectPersonBlock) {
            self.selectPersonBlock(self.temporaryArray);
        }
    }else{
        if (self.selectPersonBlock) {
            [self.temporaryArray removeAllObjects];
            self.selectPersonBlock(self.temporaryArray);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editChange:(UITextField *)textField{
    [self loadService:textField.text];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textField endEditing:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textField endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField endEditing:YES];
    
}


-(void)loadService:(NSString *)userName{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    [dic setValue:userName forKey:@"userName"];
    
    [HttpTool postWithPath:POST_USER_QueryByUserName params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            [self.dataArray removeAllObjects];
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            
            for (NSDictionary *dic in dataArray) {
                ICEFORCEPersonListModel *model = [ICEFORCEPersonListModel modelWithDict:dic];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
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
