//
//  CXSearchView.m
//  CusSearchBarDemo
//
//  Created by HelloIOS on 2018/6/21.
//  Copyright © 2018年 HelloIOS. All rights reserved.
//

#import "CXSearchView.h"
#import "CXProjectSearchItemCell.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "UIView+YYAdd.h"
#import "NSString+YYAdd.h"
#import "MJRefresh.h"
#import "UIButton+LXMImagePosition.h"


NSString * const kCollectionViewCellID = @"cell";
NSString * const kCollectionViewHeaderViewID = @"header";
NSString * const kTableViewCellID = @"tableCellId";


#define kTitleSpace 10.0
#define kTitleLeftSpace 10.0
#define kTextFontSize 16.0
#define kTextFieldHeight 40.0

#define seachBarHeight 50.f
#define rowheight 55.f

@implementation CXSearchView{
    /** 遮罩层 */
    __weak UIView *_maskView;
    //横线
    UIView *line;
    //总页数
    NSInteger pageCount;
    
    //最具影响力公司
    //记录上一次选择的项目经理，用户还原上一次选择的cell
    NSIndexPath *selectManagerIndexPath;
    //记录上一次选择的行业，用户还原上一次选择的cell
    NSIndexPath *selectInduIndexPath;
}

#pragma mark - init
-(instancetype)init{
    self = [super init];
    if (self) {
        self.selectedStageList = [NSMutableArray array];
        self.selectedIndustryList = [NSMutableArray array];
        self.meetingArray = [NSArray array];
        self.industryMICList = [NSArray array];
        self.searchArray = [NSMutableArray array];
    }
    return self;
}
#pragma mark -      获取数据的地方     ************************************/
/** 获取项目管理的项目阶段数据 */
- (void)findStageList {
    if (self.stageList.count) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/project/filter/items/stage",urlPrefix];
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.stageList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

/** 获取项目管理的一级行业数据 */
- (void)findIndustryList {
    if (self.industryList.count) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/project/filter/items/indu",urlPrefix];
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.industryList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

/** 获取约见项目的行业数据 */
-(void)findMeetIndustryList{
    if (self.meetingArray.count) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/project/potential/indus/list",urlPrefix];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.meetingArray = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

/** 获取最具影响力公司（MIC）的项目经理数据 */
- (void)findMICStageList {
    if (self.stageList.count) {
        return;
    }
    [HttpTool postWithPath:@"/project/influ/filter/items/managers.json" params:nil success:^(NSDictionary *JSON) {
        NSLog(@"micData xiangmujingli = %@",JSON);
        if ([JSON[@"status"] intValue] == 200) {
            self.stageList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

/** 获取最具影响力公司（MIC）的行业数据 */
- (void)findMICIndustryList {
    if (self.industryMICList.count) {
        return;
    }
    [HttpTool postWithPath:@"/project/influ/filter/items/indus.json" params:nil success:^(NSDictionary *JSON) {
        NSLog(@"micData hangye = %@",JSON);
        if ([JSON[@"status"] intValue] == 200) {
            self.industryMICList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

-(void)findNewLetterList{
    if (self.stageList.count) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@sysuser/getTeamAll",urlPrefix];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.stageList = JSON[@"data"];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}


/** 获取搜索数据 */
-(void)getSearchData{
    NSString *url = [NSString stringWithFormat:@"%@project/queryHint/list/%zd.json",urlPrefix, self.pageNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.searchBar.text forKey:@"s_projName"];
    CXWeakSelf(self);
    
    [HttpTool postWithPath:url params:params success:^(id JSON){
        CXStrongSelf(self);
        if([JSON[@"status"]integerValue] == 200){
            NSArray *tempArray = [NSArray array];
            tempArray = JSON[@"data"];
            if(self.pageNumber == 1 ){
                [self.searchArray removeAllObjects];
                [self.searchTable reloadData];
            }
            [self.searchArray addObjectsFromArray:tempArray];
            self.searchTable.hidden = NO;
            //            [self setNeedsLayout];
            //            [self layoutIfNeeded];
            CGFloat height;
            if(self.searchArray.count * rowheight > (Screen_Height - navHigh - searchBar_Height)){
                height = Screen_Height - navHigh - searchBar_Height;
            }else{
                height = self.searchArray.count*rowheight;
            }
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.searchTable.frame;
                rect.size.height = height;
                self.searchTable.frame = rect;
                
            }];
            NSLog(@"%f",self.searchTable.frame.size.height);
            
            [self.searchTable reloadData];
            pageCount = [JSON[@"pageCount"]integerValue];
            
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.searchTable.footer endRefreshing];
    } failure:^(NSError *error){
        CXAlert(@"获取查询列表失败");
        [self.searchTable.footer endRefreshing];
    }];
}

#pragma mark -      加载视图的地方     ************************************/
//加载子控件
-(void)layoutSubviews{
    
    _searchBar = ({
        CXSearchBar *searchBar = [[CXSearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 0, self.frame.size.width, 60);
        searchBar.delegate = self;
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
        [self addSubview:searchBar];
        searchBar;
    });
    
    line = [self addDividingLineInView:self below:self.searchBar offset:0];
    
    
    if (self.cxSearchType == CXSearchPM) {
        //项目管理
        self.pageNumber = 1;
        [self findStageList];
        [self findIndustryList];
        [self loadProjectManagerView];
    }else if (self.cxSearchType == CXSearchReport){
        //研究报告
        [self loadReSearchReportView];
    }else if (self.cxSearchType == CXSearchMeet){
        //约见项目
        [self loadMeetingView];
    }else if (self.cxSearchType == CXSearchMIC){
        //最具影响力公司
        self.pageNumber = 1;
        [self findMICStageList];
        [self findMICIndustryList];
        [self loadProjectManagerView];
    }else if (self.cxSearchType == CXSearchTMT){
        //如果后面需要在中间加控件就在这里加
    }else if (self.cxSearchType == CXSearchNewsLetter){
        [self findNewLetterList];
        [self loadProjectManagerView];
    }
    
    
    
   
    _footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:view];
        view;
    });
    
    if (self.cxSearchType == CXSearchTMT) {
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(50);
            //            make.top.equalTo(self->line.mas_bottom);
        }];
    }else{
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(50);
            make.top.equalTo(self->line.mas_bottom);
        }];
    }
    
    
    
    _resetButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:kColorWithRGB(236, 72, 73) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onResetButtonTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:button];
        button;
    });
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 36));
        make.centerY.equalTo(self.footerView);
        make.right.equalTo(self.footerView.mas_centerX).offset(-5);
    }];
    
    
    
    _searchButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kColorWithRGB(236, 72, 73)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onSearchButtonTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:button];
        button;
    });
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 36));
        make.centerY.equalTo(self.footerView);
        make.left.equalTo(self.footerView.mas_centerX).offset(5);
    }];
   
}
/** 加载项目管理和最具影响力公司的中间的View */
-(void)loadProjectManagerView{
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[CXProjectSearchItemCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderViewID];
        
        [self addSubview:collectionView];
        collectionView;
    });
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->line.mas_bottom);
        make.left.right.equalTo(self);
    }];
    
    
    if (self.cxSearchType == CXSearchPM) {
        _searchTable = ({
            UITableView *tableView = [[UITableView alloc] init];
            tableView.delegate = self;
            tableView.dataSource = self;
            
            
            tableView.frame = CGRectMake(0, searchBar_Height, Screen_Width, Screen_Height - navHigh - searchBar_Height);
            
            [self addSubview:tableView];
            tableView.layer.zPosition = 100;
            tableView.hidden = YES;
            CXWeakSelf(self)
            
            
            [tableView.header setRefreshingBlock:^{
                
            }];
            [tableView.footer setRefreshingBlock:^{
                
            }];
            
            tableView;
        });
    }
    
    
    line = [self addDividingLineInView:self below:self.collectionView offset:0];
}

/** 加载约见项目的中间的View */
-(void)loadMeetingView{
    [self findMeetIndustryList];
    
    _fzrTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"负责人";
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:label];
        label;
    });
    [self.fzrTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(kTitleSpace);
        make.left.equalTo(self).offset(kTitleLeftSpace);
        make.right.equalTo(self).offset(-kTitleLeftSpace);
        make.height.mas_equalTo(kTextFontSize);
    }];
    
    _fzrTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入负责人";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        
        [self addSubview:textField];
        textField;
    });
    
    [self.fzrTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fzrTitleLable.mas_bottom).offset(kTitleSpace);
        make.left.equalTo(self).offset(kTitleLeftSpace);
        make.right.equalTo(self).offset(-kTitleLeftSpace);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[CXProjectSearchItemCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewHeaderViewID];
        
        [self addSubview:collectionView];
        collectionView;
    });
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fzrTextField.mas_bottom).offset(kTitleSpace);
        make.left.right.equalTo(self);
    }];
    
     line = [self addDividingLineInView:self below:self.collectionView offset:0];
}

/** 加载研究报告的中间的View */
-(void)loadReSearchReportView{
    
    
    
    _bgmcTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"报告名称";
        
        label.frame = CGRectMake(kTitleLeftSpace, self.searchBar.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFontSize);
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label;
    });
    
    _bgmcTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入报告名称";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        [self addSubview:textField];
        textField;
    });
    
    _zyTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"摘要";
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label;
    });
    
    _zyTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入摘要";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        [self addSubview:textField];
        textField;
    });
    
    
    
    self.bgmcTextField.frame = CGRectMake(kTitleLeftSpace, self.bgmcTitleLable.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFieldHeight);
    
    self.zyTitleLable.frame = CGRectMake(kTitleLeftSpace, self.bgmcTextField.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFontSize);
    
    self.zyTextField.frame = CGRectMake(kTitleLeftSpace, self.zyTitleLable.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFieldHeight);
    
    line = [self addDividingLineInView:self below:self.zyTextField offset:0];
}

- (UIView *)addDividingLineInView:(UIView *)superView below:(UIView *)view offset:(CGFloat)offset {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorWithRGB(241, 241, 241);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(offset);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    return line;
}

#pragma mark - 搜索按钮处理方法
//搜索按钮方法
- (void)onSearchButtonTap {
    if (self.cxSearchType == CXSearchPM) {//项目管理
            if (self.searchPMBlock) {
                NSArray<NSNumber *> *stages = [self.selectedStageList valueForKey:@"machId"];
                NSArray<NSNumber *> *industries = [self.selectedIndustryList valueForKey:@"baseId"];
                NSString *keyword = [self.searchBar.text stringByTrim];
                self.searchPMBlock(stages, industries, keyword);
            }
            
    }else if (self.cxSearchType == CXSearchReport){//研究报告
        if (self.researchReportBlock) {
            NSString *bgmc = [self.bgmcTextField.text stringByTrim];
            NSString *zy = [self.zyTextField.text stringByTrim];
            NSString *keyword = [self.searchBar.text stringByTrim];
            self.researchReportBlock(bgmc, zy, keyword);
        }
        
    }else if (self.cxSearchType == CXSearchMeet){//约见项目
        if (self.meetBlock) {
            NSString *fzr = [self.fzrTextField.text stringByTrim];
            NSString *industries = self.selectIndustry;
            NSString *keyword = [self.searchBar.text stringByTrim];
            self.meetBlock(fzr, industries, keyword);
            
        }
        
    }else if (self.cxSearchType == CXSearchMIC){//最具影响力公司
        if (self.searchMICBlock) {
            NSString *manager = [self.s_projManager objectForKey:@"account"];
            NSString *industries = self.s_indusType;
            NSString *searchText = [self.searchBar.text stringByTrim];
            self.searchMICBlock(manager, industries, searchText);
            
        }
        
    }else if (self.cxSearchType == CXSearchTMT){//TMT
        if (self.searchTMTBlock) {
            self.searchTMTBlock(self.searchBar.text);
        }
        
    }else if (self.cxSearchType == CXSearchNewsLetter){
        NSString *s_projManagerStr = [self.s_projManager objectForKey:@"deptId"];
        self.searchNewsLetter(self.searchBar.text, s_projManagerStr);
    }
    //范类
    if (self.searchBlock) {
        self.searchBlock(self.searchBar.text);
    }
    
    
    
    [self hide];

}

/** 重置方法 */
- (void)onResetButtonTap {
    self.searchBar.text = nil;
    self.fzrTextField.text = nil;
    self.selectIndustry = nil;
    self.bgmcTextField.text = nil;
    self.zyTextField.text = nil;
    self.s_projManager = nil;
    self.s_indusType = nil;
    [self.selectedStageList removeAllObjects];
    [self.selectedIndustryList removeAllObjects];
    [self.collectionView reloadData];
}


#pragma mark - UISearchBar
//点交叉关闭
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
//选择键盘return
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self onSearchButtonTap];
}

//点取消关闭
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchTable.hidden = YES;
    self.searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

//监控文本变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.cxSearchType == CXSearchPM) {
        [self getSearchData];
    }
}



#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellID];
    }
    
    cell.textLabel.attributedText = [self getAttributeString:self.searchArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchBar.text = self.searchArray[indexPath.row];
    self.searchTable.hidden = YES;
    [self.searchBar resignFirstResponder];
}

//对搜索的内容进行处理，搜索内容中与搜索框输入内容相同的文字要红色
- (NSAttributedString *)getAttributeString:(NSString *)str{
    if(nil == str || !trim(str).length){
        return nil;
    }
    NSMutableAttributedString *attriteString = [[NSMutableAttributedString alloc]initWithString:str];
    if([str rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound){
        NSRange range = [str rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
        [attriteString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    }
    return attriteString;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.cxSearchType == CXSearchPM) {
        return 2;
    }else if (self.cxSearchType == CXSearchMeet){
        return 1;
    }else if (self.cxSearchType == CXSearchNewsLetter){
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.cxSearchType == CXSearchPM) {
        if (section == 0) {
            return self.isExpandStage ? self.stageList.count : 0;
            
        }
        else {
            return self.isExpandIndustry ? self.industryList.count : 0;
            
        }
    }else if (self.cxSearchType == CXSearchMeet){
        return self.isExpandIndustry ? self.meetingArray.count : 0;
    }else if (self.cxSearchType == CXSearchMIC){
        if (section == 0) {
            NSInteger num = self.isExpandStage ? self.stageList.count : 0;
            return num;
            
        }
        else {
            return self.isExpandIndustry ? self.industryMICList.count : 0;
            
        }
    }else if(self.cxSearchType == CXSearchNewsLetter){
        return self.stageList.count;
    }else{
        return 0;
    }
    
    
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CXProjectSearchItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    if (self.cxSearchType == CXSearchPM) {
        // 项目阶段
        if (indexPath.section == 0) {
            
            NSDictionary *stage = self.stageList[indexPath.row];
            cell.text = stage[@"machName"];
            cell.checked = [self.selectedStageList containsObject:stage];
            //        cell.text = @"项目阶段";
        }
        // 一级行业
        else {
            NSDictionary *industry = self.industryList[indexPath.row];
            cell.text = industry[@"baseName"];
            cell.checked = [self.selectedIndustryList containsObject:industry];
            //        cell.text = @"一级行业";
        }
    }else if (self.cxSearchType == CXSearchMeet){
        
        cell.text = self.meetingArray[indexPath.row];
        cell.checked = [self.selectIndustry isEqualToString:self.meetingArray[indexPath.row]];
        
        
    }else if (self.cxSearchType == CXSearchNewsLetter){
        NSDictionary *stage = self.stageList[indexPath.row];
        cell.text = stage[@"deptName"];
//        cell.checked = [self.selectIndustry isEqualToString:self.stageList[indexPath.row]];
        cell.checked = [self.s_projManager isEqualToDictionary:stage];
    }
    else{
        // 项目经理
        if (indexPath.section == 0) {
            NSDictionary *stage = self.stageList[indexPath.row];
            cell.text = stage[@"userName"];
            cell.checked = [self.s_projManager isEqualToDictionary:stage];
        }
        // 行业
        else {
            NSString *industry = self.industryMICList[indexPath.row];
            cell.text = industry;
            cell.checked = [self.s_indusType isEqualToString:industry];
        }
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-40)/3, 36);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.cxSearchType == CXSearchNewsLetter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeaderViewID forIndexPath:indexPath];
        return headerView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeaderViewID forIndexPath:indexPath];
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-30, 0.5)];
        line.backgroundColor = kColorWithRGB(241, 241, 241);
        [headerView addSubview:line];
        
        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.equalTo(headerView);
            }];
            label;
        });
        
        UIButton *showTypeControlButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            [btn setTitleColor:kColorWithRGB(124, 124, 124) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateSelected];
            [btn setImagePosition:1 spacing:3];
            [btn addTarget:self action:@selector(onShowTypeControlButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.centerY.equalTo(titleLabel);
            }];
            btn;
        });
        
        if (self.cxSearchType == CXSearchPM) {
            NSArray *texts = @[@"项目阶段", @"一级行业"];
            titleLabel.text = texts[indexPath.section];
            showTypeControlButton.tag = indexPath.section;
            if (indexPath.section == 0) {
                showTypeControlButton.selected = self.isExpandStage;
            }
            else {
                showTypeControlButton.selected = self.isExpandIndustry;
            }
        }else if (self.cxSearchType == CXSearchMeet){
            titleLabel.text = @"行业";
            showTypeControlButton.selected = self.isExpandIndustry;
        }else if (self.cxSearchType == CXSearchMIC){
            NSArray *texts = @[@"项目经理", @"行业"];
            titleLabel.text = texts[indexPath.section];
            showTypeControlButton.tag = indexPath.section;
            if (indexPath.section == 0) {
                showTypeControlButton.selected = self.isExpandStage;
            }
            else {
                showTypeControlButton.selected = self.isExpandIndustry;
            }
        }
        
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.cxSearchType == CXSearchNewsLetter) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(collectionView.bounds.size.width, 40);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cxSearchType == CXSearchPM) {
        // 项目阶段
        if (indexPath.section == 0) {
            NSDictionary *stage = self.stageList[indexPath.row];
            
            if ([self.selectedStageList containsObject:stage]) {
                [self.selectedStageList removeObject:stage];
            }
            else {
                [self.selectedStageList addObject:stage];
            }
        }
        // 一级行业
        else {
            NSDictionary *industry = self.industryList[indexPath.row];
            if ([self.selectedIndustryList containsObject:industry]) {
                [self.selectedIndustryList removeObject:industry];
            }
            else {
                [self.selectedIndustryList addObject:industry];
            }
        }
    }else if (self.cxSearchType == CXSearchMeet){
        self.selectIndustry = self.meetingArray[indexPath.row];
        if (self.selectIndex != nil) {
            [self.collectionView reloadItemsAtIndexPaths:@[self.selectIndex]];
        }
        self.selectIndex = indexPath;
    }else if (self.cxSearchType == CXSearchMIC){
        // 项目阶段
        if (indexPath.section == 0) {
            NSDictionary *stage = self.stageList[indexPath.row];
            self.s_projManager = stage;
            
            if (selectManagerIndexPath !=  nil) {
                [self.collectionView reloadItemsAtIndexPaths:@[selectManagerIndexPath]];
            }
            selectManagerIndexPath = indexPath;
            
        }
        // 一级行业
        else {
            NSString *industry = self.industryMICList[indexPath.row];
            self.s_indusType = industry;
            if (selectInduIndexPath !=  nil) {
                [self.collectionView reloadItemsAtIndexPaths:@[selectInduIndexPath]];
            }
            selectInduIndexPath = indexPath;
        }
        
        
    }else if (self.cxSearchType == CXSearchNewsLetter){
        NSDictionary *stage = self.stageList[indexPath.row];
        self.s_projManager = stage;
        
        if (selectManagerIndexPath !=  nil) {
            [self.collectionView reloadItemsAtIndexPaths:@[selectManagerIndexPath]];
        }
        selectManagerIndexPath = indexPath;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

//展开section的方法
- (void)onShowTypeControlButtonTap: (UIButton *)btn {
    NSInteger section = btn.tag;
    if (self.cxSearchType == CXSearchPM) {
        
        if (section == 0) {
            self.expandStage = !self.expandStage;
        }
        else {
            self.expandIndustry = !self.expandIndustry;
        }
    }else if(self.cxSearchType == CXSearchMeet){
        self.expandIndustry = !self.expandIndustry;
    }else{
        if (section == 0) {
            self.expandStage = !self.expandStage;
        }
        else {
            self.expandIndustry = !self.expandIndustry;
        }
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

#pragma mark - 添加搜索视图，隐藏加载视图
- (void)showInView:(UIView *)view {
    //    [self findDataList];
    
    UIView *maskView = ({
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        [view addSubview:maskView];
        [maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        maskView;
    });
    _maskView = maskView;
    [view addSubview:self];
    
    //    if ([view.viewController isKindOfClass:[SDRootViewController class]]) {
    //        UIView *rootTopView = [view viewWithTag:kRootTopViewTag];
    //        if (rootTopView) {
    //            [view bringSubviewToFront:rootTopView];
    //        }
    //    }
}
/** 隐藏搜索视图 */
- (void)hide {
    
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

@end
