//
//  ICEFORCESelectListView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/15.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCESelectListView.h"
#import "ICEFORCEListTableViewCell.h"

@interface ICEFORCESelectListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation ICEFORCESelectListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubView];
    }
    return self;
}

-(void)loadSubView{
    self.backgroundColor = RGBA(240, 240, 240, 1);
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [MyPublicClass layerMasksToBoundsForAnyControls:self.tableView cornerRadius:8 borderColor:nil borderWidth:0];
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    
    if (self.isShowLine) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
   
}
-(void)reloadData{
     [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *listCell = @"listCellll";
    
    ICEFORCEListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEListTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

    cell.listName.text = [dic objectForKey:self.dataKey];
    cell.listName.textColor = self.changeColor;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    if (self.selectListData) {
        self.selectListData(dic);
    }
    
    [self removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
