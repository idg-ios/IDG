//
//  CXIDGGroupAddUsersViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGGroupAddUsersViewController.h"
#import "CXIMHelper.h"
#import "ChineseToPinyin.h"
#import "SDIMContactsViewController.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "YYModel.h"
#import "CXLoaclDataManager.h"
#import "CXIDGGroupAddUsersTableViewCell.h"
#import "CXLoaclDataManager.h"
#import "HttpTool.h"

@interface CXIDGGroupAddUsersViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

//导航栏
@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (nonatomic, strong) UITableView* tableView;
//数据源
@property (nonatomic, strong) NSMutableDictionary* dataSource;
//是否是搜索的
@property (nonatomic) BOOL isFromSearch;
//联系人数据源
@property (nonatomic, strong) NSMutableArray* contactsSource;
//右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
//sectionTitle数组
@property (nonatomic, strong) NSMutableArray* sectionIndexTitlesArr;
//搜索的数据源
@property (nonatomic, strong) NSMutableArray* searchArray;

@property (strong, nonatomic) NSMutableArray* chatContactsArray;

@property (nonatomic, strong) UIView* topSelectBackView;
//搜索的数据源
@property (nonatomic, strong) UIScrollView* topSelectScrollView;

@property (nonatomic, strong) UISearchBar* mySearchBar;
//选中的联系人
@property (nonatomic, strong) NSMutableArray<SDCompanyUserModel *>* selectedUserArray;


@end

@implementation CXIDGGroupAddUsersViewController

#define kHeadImageLeftSpace 2.5
#define kHeadImageWidth 44.0

#pragma mark - 懒加载
- (UIScrollView *)topSelectScrollView {
    if(!_topSelectScrollView){
        _topSelectScrollView = [[UIScrollView alloc] init];
        _topSelectScrollView.backgroundColor = [UIColor whiteColor];
        _topSelectScrollView.frame = CGRectMake(kHeadImageLeftSpace, 2*kHeadImageLeftSpace, ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4), kHeadImageWidth);
        _topSelectScrollView.contentSize = CGSizeMake((kHeadImageLeftSpace*14), kHeadImageWidth);
        _topSelectScrollView.showsVerticalScrollIndicator = YES;
        [self.topSelectBackView addSubview:_topSelectScrollView];
    }
    return _topSelectScrollView;
}

- (UISearchBar *)mySearchBar {
    if(!_mySearchBar){
        _mySearchBar = [[UISearchBar alloc] init];
        _mySearchBar.frame = CGRectMake(kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4) + kHeadImageLeftSpace, 2*kHeadImageLeftSpace, Screen_Width - (kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4) + kHeadImageLeftSpace), kHeadImageWidth);
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:44];
        [_mySearchBar setBackgroundImage:searchBarBg];
        _mySearchBar.delegate = self;
        _mySearchBar.placeholder = @"搜索";
        [self.topSelectBackView addSubview:_mySearchBar];
    }
    return _mySearchBar;
}

- (NSMutableArray<SDCompanyUserModel *> *)selectedUserArray {
    if(!_selectedUserArray){
        _selectedUserArray = @[].mutableCopy;
    }
    return _selectedUserArray;
}

- (UIView *)topSelectBackView {
    if(!_topSelectBackView){
        _topSelectBackView = [[UIView alloc] init];
        _topSelectBackView.backgroundColor = [UIColor whiteColor];
        _topSelectBackView.frame = CGRectMake(0, navHigh, Screen_Width, kHeadImageLeftSpace*4 + kHeadImageWidth);
        [self.view addSubview:_topSelectBackView];
    }
    return _topSelectBackView;
}

//索引数组
- (NSMutableArray*)indexSectionAry
{
    _indexSectionAry = [[NSMutableArray alloc] init];
    for (SDCompanyUserModel* buddy in _contactsSource) {
        NSString* firstLetter = [[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)];
        if([buddy.realName length] > 0){
            if (0 == isalpha([firstLetter UTF8String][0])) {
                // 如果不是字母
                firstLetter = @"#";
            }
            
            if (![_indexSectionAry containsObject:firstLetter]) {
                [_indexSectionAry addObject:firstLetter];
            }
        }
    }
    // 按照字母升序
    [_indexSectionAry sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    if ([_indexSectionAry containsObject:@"#"]) {
        [_indexSectionAry removeObject:@"#"];
        [_indexSectionAry addObject:@"#"];
    }
    return _indexSectionAry;
}

- (NSArray*)sectionIndexTitlesArr
{
    NSMutableArray* retArr = [[NSMutableArray alloc] init];
    for (int i = 65; i < 65 + 26; i++) {
        [retArr addObject:[NSString stringWithFormat:@"%C", (unichar)i]];
    }
    [retArr addObject:@"#"];
    _sectionIndexTitlesArr = [retArr copy];
    return _sectionIndexTitlesArr;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mySearchBar.text == nil || (self.mySearchBar.text != nil && [self.mySearchBar.text length] <= 0)) {
        [self.mySearchBar setShowsCancelButton:NO];
    }
    
    if ([CXLoaclDataManager sharedInstance].allKJDicContactsArray.count == 0) {//拉取失败,重新请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *url = [NSString stringWithFormat:@"%@/sysuser/new/list", urlPrefix];
            
            [HttpTool getWithPath:url params:nil success:^(id JSON) {
                NSNumber *status = JSON[@"status"];
                if ([status intValue] == 200) {
                    [[CXLoaclDataManager sharedInstance].depKJArray removeAllObjects];
                    [[CXLoaclDataManager sharedInstance].allKJDicContactsArray removeAllObjects];
                    [[CXLoaclDataManager sharedInstance].allKJDepDataArray removeAllObjects];
                    [[CXLoaclDataManager sharedInstance].depArray removeAllObjects];
                    [[CXLoaclDataManager sharedInstance].allDicContactsArray removeAllObjects];
                    [[CXLoaclDataManager sharedInstance].allDepDataArray removeAllObjects];
                    NSArray * contactsArray = JSON[@"data"][@"contacts"];
                    for(NSDictionary * depDataDic in contactsArray){
                        [[CXLoaclDataManager sharedInstance].depKJArray addObject:depDataDic.allKeys[0]];
                        NSArray * depDataArray = depDataDic.allValues[0];
                        //用来保存每一组的userModelArray
                        NSMutableArray * depUsersArray = @[].mutableCopy;
                        for(NSDictionary * contactDic in depDataArray){
                            NSMutableDictionary * mutableDic = contactDic.mutableCopy;
                            if([mutableDic[@"icon"] isKindOfClass:[NSNull class]]){
                                mutableDic[@"icon"] = @"";
                            }
                            [[CXLoaclDataManager sharedInstance].allKJDicContactsArray addObject:mutableDic];
                            
                            SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:contactDic];
                            userModel.userId = @([contactDic[@"userId"] integerValue]);
                            [depUsersArray addObject:userModel];
                        }
                        NSMutableDictionary * userDic = [NSMutableDictionary dictionary];
                        [userDic setValue:depUsersArray forKey:depDataDic.allKeys[0]];
                        [[CXLoaclDataManager sharedInstance].allKJDepDataArray addObject:userDic];
                    }
                    
                    NSArray * allContactsArray = JSON[@"data"][@"allContacts"];
                    for(NSDictionary * depDataDic in allContactsArray){
                        [[CXLoaclDataManager sharedInstance].depArray addObject:depDataDic.allKeys[0]];
                        NSArray * depDataArray = depDataDic.allValues[0];
                        //用来保存每一组的userModelArray
                        NSMutableArray * depUsersArray = @[].mutableCopy;
                        for(NSDictionary * contactDic in depDataArray){
                            NSMutableDictionary * mutableDic = contactDic.mutableCopy;
                            if([mutableDic[@"icon"] isKindOfClass:[NSNull class]]){
                                mutableDic[@"icon"] = @"";
                            }
                            [[CXLoaclDataManager sharedInstance].allDicContactsArray addObject:mutableDic];
                            
                            SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:contactDic];
                            userModel.userId = @([contactDic[@"userId"] integerValue]);
                            [depUsersArray addObject:userModel];
                        }
                        NSMutableDictionary * userDic = [NSMutableDictionary dictionary];
                        [userDic setValue:depUsersArray forKey:depDataDic.allKeys[0]];
                        [[CXLoaclDataManager sharedInstance].allDepDataArray addObject:userDic];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshTable];//重新分区
                        });
                    }
                }else{
                    
                }
            } failure:^(NSError *error) {
                
            }];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [[NSMutableDictionary alloc] init];
    _contactsSource = [[NSMutableArray alloc] initWithCapacity:0];
    [self setUpView];
    [self refreshTable];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 内部方法
- (void)setUpView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(self.navTitle)];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    [self.rootTopView setUpLeftBarItemTitle:@"取消" addTarget:self action:@selector(dissmiss)];
    [self.rootTopView setUpRightBarItemTitle:[NSString stringWithFormat:@"完成(%zd)",[self.selectedUserArray count]] addTarget:self action:@selector(wcBtnClick)];
    
    self.topSelectBackView.hidden = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh + (kHeadImageLeftSpace*4 + kHeadImageWidth), Screen_Width, Screen_Height - (navHigh + (kHeadImageLeftSpace*4 + kHeadImageWidth))) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorColor = [UIColor clearColor];
    //修改索引颜色
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
    _tableView.sectionIndexColor = kIDGSectionIndexColor;//修改右边索引字体的颜色
    _tableView.sectionIndexTrackingBackgroundColor = kIDGSectionIndexColor;//修改右边索引点击时候的背景色
    // 索引背景透明
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_tableView];
    
    [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)dissmiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)wcBtnClick
{
    if([self.selectedUserArray count] > 0){
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.selectContactUserCallBack) {
                weakSelf.selectContactUserCallBack([self.selectedUserArray mutableCopy]);
            }
        }];
    }else{
        TTAlert(@"请选择联系人!");
    }
}

#pragma mark 刷新通讯录数据table
- (void)refreshTable
{
    NSArray* sourceAry = [NSArray arrayWithArray:[[CXLoaclDataManager sharedInstance] getAllKJDepContacts]];
    [_indexSectionAry removeAllObjects];
    _indexSectionAry = nil;
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    self.contactsSource = [NSMutableArray arrayWithArray:sourceAry];
    NSMutableArray* indexTitleAry = self.indexSectionAry;
    __weak typeof(self) weakSelf = self;
    [indexTitleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [weakSelf.dataSource setValue:[NSMutableArray array] forKey:(NSString*)obj];
    }];
    for (NSString* firstLetter in indexTitleAry) {
        @autoreleasepool {
            // 字母对应的人员数组
            NSMutableArray* valAry = self.dataSource[firstLetter];
            for (SDCompanyUserModel* buddy in self.contactsSource) {
                if ([firstLetter isEqualToString:[[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)]]) {
                    if (![valAry containsObject:buddy]) {
                        [valAry addObject:buddy];
                    }
                }
                else if ([buddy.realName length] > 0 && 0 == isalpha([[ChineseToPinyin pinyinFromChineseString:buddy.realName] UTF8String][0])) {
                    // 如果是#
                    NSMutableArray* tempAry = self.dataSource[@"#"];
                    if (NO == [tempAry containsObject:buddy]) {
                        [tempAry addObject:buddy];
                    }
                }
            }
        }
    }
    [self sectionIndexTitlesArr];
    [self indexSectionAry];
    [self sortContactsDataSource:self.dataSource.copy];
    [self.tableView reloadData];
}

- (void)sortContactsDataSource:(NSMutableDictionary *)dataSource
{
    [dataSource enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray<SDCompanyUserModel *> * obj, BOOL * _Nonnull stop) {
        if(dataSource[key] && [dataSource[key] count] > 0){
            NSMutableArray * userArray = @[].mutableCopy;
            for(SDCompanyUserModel * user in obj){
                [userArray insertObject:user atIndex:[self getIndexInUserArray:userArray WithUser:user]];
            }
            self.dataSource[key] = userArray;
        }
    }];
}

- (NSInteger)getIndexInUserArray:(NSArray<SDCompanyUserModel *> *)userArray WithUser:(SDCompanyUserModel *)aUser
{
    NSInteger i = 0;
    for(SDCompanyUserModel * user in userArray){
        if([[user.name substringToIndex:1] isEqualToString:[aUser.name substringToIndex:1]]){
            return i;
        }
        i++;
    }
    return 0;
}

- (void)setSelectedUserIntoTopScrollView:(NSMutableArray<SDCompanyUserModel *> *)selectedUserArray{
    for(UIView * subView in self.topSelectScrollView.subviews){
        [subView removeFromSuperview];
    }
    if([selectedUserArray count] <= 0){
        self.topSelectScrollView.frame = CGRectZero;
        self.topSelectScrollView.contentSize = CGSizeMake(0, 0);
        self.mySearchBar.frame = CGRectMake(kHeadImageLeftSpace, 2*kHeadImageLeftSpace, Screen_Width - kHeadImageLeftSpace, kHeadImageWidth);
    }else{
        if([selectedUserArray count] <= 4 && [selectedUserArray count] > 0){
            self.topSelectScrollView.frame = CGRectMake(kHeadImageLeftSpace, 2*kHeadImageLeftSpace, ((kHeadImageLeftSpace*2 + kHeadImageWidth)*[selectedUserArray count]), kHeadImageWidth);
            self.topSelectScrollView.contentSize = CGSizeMake(((kHeadImageLeftSpace*2 + kHeadImageWidth)*[selectedUserArray count]), kHeadImageWidth);
            self.mySearchBar.frame = CGRectMake(kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*[selectedUserArray count]) + kHeadImageLeftSpace, 2*kHeadImageLeftSpace, Screen_Width - (kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*[selectedUserArray count]) + kHeadImageLeftSpace), kHeadImageWidth);
        }else{
            self.topSelectScrollView.frame = CGRectMake(kHeadImageLeftSpace, 2*kHeadImageLeftSpace, ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4), kHeadImageWidth);
            self.topSelectScrollView.contentSize = CGSizeMake(((kHeadImageLeftSpace*2 + kHeadImageWidth)*[selectedUserArray count]), kHeadImageWidth);
            self.topSelectScrollView.contentOffset = CGPointMake((kHeadImageLeftSpace*2 + kHeadImageWidth)*([selectedUserArray count] - 4), 0);
            self.mySearchBar.frame = CGRectMake(kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4) + kHeadImageLeftSpace, 2*kHeadImageLeftSpace, Screen_Width - (kHeadImageLeftSpace + ((kHeadImageLeftSpace*2 + kHeadImageWidth)*4) + kHeadImageLeftSpace), kHeadImageWidth);
        }
        for(NSInteger i = 0; i < [selectedUserArray count]; i++){
            UIImageView * headImageView = [[UIImageView alloc] init];
            headImageView.frame = CGRectMake(((kHeadImageLeftSpace*2 + kHeadImageWidth)*i) + kHeadImageLeftSpace, 0, kHeadImageWidth, kHeadImageWidth);
            headImageView.tag = 10088 + i;
            SDCompanyUserModel * userModel = selectedUserArray[i];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:(userModel.icon && ![userModel.icon isKindOfClass:[NSNull class]])?userModel.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick:)];
            [headImageView addGestureRecognizer:tap];
            headImageView.userInteractionEnabled = YES;
            [self.topSelectScrollView addSubview:headImageView];
        }
    }
}

- (void)headImageViewClick:(UIGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 10088;
    [self.selectedUserArray removeObjectAtIndex:index];
    [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
    [self.tableView reloadData];
    [self.rootTopView setUpRightBarItemTitle:[NSString stringWithFormat:@"完成(%zd)",[self.selectedUserArray count]] addTarget:self action:@selector(wcBtnClick)];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return (NSInteger)[[self.dataSource allKeys] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isFromSearch) {
        return (NSInteger)[[self.dataSource valueForKey:_indexSectionAry[section]] count];
    }
    else {
        return self.searchArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CXIDGGroupAddUsersTableViewCell";
    CXIDGGroupAddUsersTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[CXIDGGroupAddUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        for (UIView* subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (!self.isFromSearch) {
        SDCompanyUserModel* userModel = self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row];
        NSInteger selectIndex = 2;
        for(SDCompanyUserModel * user in self.filterUsersArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                selectIndex = 1;
            }
        }
        for(SDCompanyUserModel * user in self.selectedUserArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                selectIndex = 3;
            }
        }
        if([userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
            selectIndex = 1;
        }
        [cell setUserModel:userModel AndSelected:selectIndex];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if(indexPath.row < [self.dataSource[_indexSectionAry[indexPath.section]] count] - 1){
            UIView * bottomWhiteView = [[UIView alloc] init];
            bottomWhiteView.frame = CGRectMake(10, SDCellHeight - 0.5, Screen_Width - 10*2, 0.5);
            bottomWhiteView.backgroundColor = RGBACOLOR(214.0, 214.0, 214.0, 1.0);;
            [cell.contentView addSubview:bottomWhiteView];
        }
    }
    else {
        SDCompanyUserModel* userModel = self.searchArray[indexPath.row];
        NSInteger selectIndex = 2;
        for(SDCompanyUserModel * user in self.filterUsersArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                selectIndex = 1;
            }
        }
        for(SDCompanyUserModel * user in self.selectedUserArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                selectIndex = 3;
            }
        }
        if([userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
            selectIndex = 1;
        }
        [cell setUserModel:userModel AndSelected:selectIndex];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if(indexPath.row < [self.searchArray count] - 1){
            UIView * bottomWhiteView = [[UIView alloc] init];
            bottomWhiteView.frame = CGRectMake(10, SDCellHeight - 0.5, Screen_Width - 10*2, 0.5);
            bottomWhiteView.backgroundColor = RGBACOLOR(214.0, 214.0, 214.0, 1.0);;
            [cell.contentView addSubview:bottomWhiteView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 14)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (!self.isFromSearch) {
        NSString* title = [_indexSectionAry[section] uppercaseString];
        lable.text = [NSString stringWithFormat:@"  %@", title];
        lable.font = [UIFont systemFontOfSize:12.0f];
        if ([title isEqualToString:@"↑"]) {
            lable.text = @"";
        }
    }
    else {
        lable.text = nil;
    }
    return lable;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return [self sectionIndexTitlesArr];
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [[_indexSectionAry valueForKey:@"uppercaseString"] indexOfObject:title];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isFromSearch) {
        __block SDCompanyUserModel* userModel = self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row];
        userModel.hxAccount = userModel.imAccount;
        for(SDCompanyUserModel * user in self.filterUsersArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                return;
            }
        }
        if([userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
            return;
        }
        for(SDCompanyUserModel * user in self.selectedUserArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                [self.selectedUserArray removeObject:user];
                [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
                [self.tableView reloadData];
                [self.rootTopView setUpRightBarItemTitle:[NSString stringWithFormat:@"完成(%zd)",[self.selectedUserArray count]] addTarget:self action:@selector(wcBtnClick)];
                return;
            }
        }
        [self.selectedUserArray addObject:userModel];
        [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
        [self.tableView reloadData];
    }
    else {
        __block SDCompanyUserModel* userModel = self.searchArray[indexPath.row];
        userModel.hxAccount = userModel.imAccount;
        for(SDCompanyUserModel * user in self.filterUsersArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                return;
            }
        }
        if([userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
            return;
        }
        for(SDCompanyUserModel * user in self.selectedUserArray){
            if([user.imAccount isEqualToString:userModel.imAccount]){
                [self.selectedUserArray removeObject:user];
                [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
                [self.tableView reloadData];
                [self.rootTopView setUpRightBarItemTitle:[NSString stringWithFormat:@"完成(%zd)",[self.selectedUserArray count]] addTarget:self action:@selector(wcBtnClick)];
                return;
            }
        }
        [self.selectedUserArray addObject:userModel];
        [self setSelectedUserIntoTopScrollView:self.selectedUserArray];
        [self searchBarCancelButtonClicked:self.mySearchBar];
        [self.tableView reloadData];
    }
    [self.rootTopView setUpRightBarItemTitle:[NSString stringWithFormat:@"完成(%zd)",[self.selectedUserArray count]] addTarget:self action:@selector(wcBtnClick)];
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.mySearchBar resignFirstResponder];
    return indexPath;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar setShowsCancelButton:NO];
    return YES;
}

//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:NO];
    self.mySearchBar.text = nil;
    self.isFromSearch = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    //搜索内容随着输入及时地显示出来
    if ([searchText length] == 0) {
        [self.mySearchBar setShowsCancelButton:NO];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = NO;
        [self.tableView reloadData];
        return;
    }
    else {
        [self.mySearchBar setShowsCancelButton:NO];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = YES;
        [self handleSearchBarContent:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:NO];
    [self handleSearchBarContent:searchBar.text];
}

#pragma mark 重新加载搜索到数据
- (void)handleSearchBarContent:(NSString*)searchStr
{
    NSMutableArray* searchDataSource = [NSMutableArray array];
    for (SDCompanyUserModel* userModel in self.contactsSource) {
        if ([NSString containWithSelectedStr:userModel.realName contain:searchStr]) {
            [searchDataSource addObject:userModel];
        }
    }
    self.searchArray = searchDataSource;
    [self.tableView reloadData];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.mySearchBar resignFirstResponder];
}

@end
