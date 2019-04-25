//
//  SDSelectMemberViewController.m
//  InjoyIDG
//
//  Created by HelloIOS on 2018/7/18.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDSelectMemberViewController.h"
#import "CXSeleMemberCell.h"
#import "UIView+YYAdd.h"
//#import "SDDRMeetingViewController.h"
#import "CXGroupInfo.h"
#import "UIImageView+WebCache.h"
//#import "CXMultiplayerVideoViewController.h"

@interface SDSelectMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
/**  */
@property (nonatomic, strong) NSMutableArray<CXGroupMember *> *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
/**  */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 群组信息 */
@property (nonatomic,strong) CXGroupInfo *groupDetailInfo;
/** 通话邀请人 */
@property (nonatomic, strong) CXGroupMember *owner;


@property (nonatomic, strong) NSMutableArray<CXGroupMember *> *searchArray;
@property (nonatomic, assign) BOOL isSearch;

/** 第二次选人的时候有多少个是已选的 */
@property (nonatomic, assign) NSInteger twoSelectNumber;

@end

@implementation SDSelectMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(34, 35, 40);
    // Do any additional setup after loading the view.
    
    [self getData];
    [self loadTopView];
    [self loadCollectionView];
    [self loadSearchView];
    [self loadTableView];
}

- (void)setInternalSelectedUsers:(NSMutableArray<CXGroupMember *> *)internalSelectedUsers{
    _internalSelectedUsers = [internalSelectedUsers mutableCopy];
}

-(void)getData{
    self.dataArray = [NSMutableArray array];
    if (_internalSelectedUsers == nil) {
        _internalSelectedUsers = [NSMutableArray array];
    }else{
        _twoSelectNumber = _internalSelectedUsers.count;
    }
    self.searchArray = [NSMutableArray array];
    [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:self.groupId completion:^(CXGroupInfo *group, NSError *error) {
        if (!error) {
            [[CXLoaclDataManager sharedInstance] updateLocalDataWithGroupId:self.groupId AndGroup:group];
            self.groupDetailInfo = group;
            
            //加上群主的信息
            [self.dataArray addObject:self.groupDetailInfo.ownerDetail];
            //加上群成员的信息
            [self.dataArray addObjectsFromArray:self.groupDetailInfo.members];
            
           
            
            for (CXGroupMember *member in self.dataArray) {
                
                //查找自己的信息
                if ([member.userId isEqual: VAL_HXACCOUNT]) {
                    //现在已选择的数据里面添加自己的信息，自己是邀请人肯定自己已经是被选择的
                    if (!self.isTwoSelect) {//如果是第二次选择就不用添加了
                        [_internalSelectedUsers addObject:member];
                    }
                    self.owner = member;
                    break;
                }
            }
            
            
            [self.collectionView reloadData];
            [self.tableView reloadData];
        }
    }];
    

}

-(void)loadTopView{
    SDRootTopView *topView = [self getRootTopView];
    topView.navTitleLabel.text = @"选择成员";
    topView.backgroundColor = kColorWithRGB(26, 25, 31);
    [topView setUpLeftBarItemTitle:@"取消" addTarget:self action:@selector(diss)];
    
    [topView setUpRightBarItemTitle:@"完成" addTarget:self action:@selector(complete)];
}

-(void)diss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)complete{
    if (self.isTwoSelect) {
        
        [_delegate getTwoSelectMemberArray:_internalSelectedUsers];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
//        CXMultiplayerVideoViewController *vc = [[CXMultiplayerVideoViewController alloc] init];
//        vc.isVideo = self.isVideo;
//        vc.memberArray = [NSMutableArray arrayWithArray:_internalSelectedUsers];
//        vc.roomId = self.groupId;
//        vc.owner = self.owner;
//        vc.senderOrReceiveType = SDIMSenderOrReceiveTypeSender;
//        vc.displaySize = CGSizeMake(Screen_Width, Screen_Height);
//        vc.audioOrVideoType = CXIMMediaCallTypeDRVideo;
//        [self presentViewController:vc animated:YES completion:nil];
        
//        SDDRMeetingViewController *vc = [[SDDRMeetingViewController alloc] init];
//        vc.isVideo = self.isVideo;
//        vc.memberArray = [NSMutableArray arrayWithArray:_internalSelectedUsers];
//        vc.roomId = self.groupId;
//        vc.owner = self.owner;
//        vc.senderOrReceiveType = SDIMSenderOrReceiveTypeSender;
//        vc.displaySize = CGSizeMake(Screen_Width, Screen_Height);
//        vc.audioOrVideoType = CXIMMediaCallTypeDRVideo;
//        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(void)loadCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((Screen_Width-6*10)/5, (Screen_Width-6*10)/5);
    self.collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, (Screen_Width-6*10)/5+20) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = kColorWithRGB(34, 34, 44);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}

-(void)loadSearchView{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.frame = CGRectMake(0, self.collectionView.bottom, Screen_Width, 40);
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.placeholder = @"请输入搜索内容";
    self.searchBar.backgroundColor = [UIColor clearColor];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];

    if (searchField) {
        searchField.backgroundColor = kColorWithRGB(48, 49, 53);
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.layer.borderWidth = 2.0;
        searchField.layer.borderColor = kColorWithRGB(48, 49, 53).CGColor;
        searchField.layer.cornerRadius = 3;
        searchField.layer.masksToBounds = YES;
        searchField.frame = CGRectMake(15, 12, Screen_Width-39, 36);
    }
    [self.view addSubview:self.searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        [self.searchArray removeAllObjects];
        [self.dataArray enumerateObjectsUsingBlock:^(CXGroupMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name containsString:searchBar.text]) {
                [self.searchArray addObject:obj];
            }
        }];
    }
    [self.tableView reloadData];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

-(void)loadTableView{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, self.searchBar.bottom, Screen_Width, Screen_Height-self.searchBar.bottom);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kColorWithRGB(34, 34, 44);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark -  UITableViewDelegate + UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchArray.count;
    }else{
        return self.dataArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    CXSeleMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CXSeleMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CXGroupMember *model = nil;
    if (self.isSearch) {
        model = self.searchArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
    cell.nickName.text = model.name;
    
    if ([self isContainModel:model]) {
        cell.selectImage.image = [UIImage imageNamed:@"onSelected"];
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"outSelected"];
    }
    
    return cell;
}

-(BOOL)isContainModel:(CXGroupMember *)model{
    for (CXGroupMember *member in _internalSelectedUsers) {
        
        if ([member.userId isEqualToString:model.userId]) {
            return YES;
        }
    }
    
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (_internalSelectedUsers.count == 9) {
//        TTAlert(@"暂时最多9人同时语音通话。");
//        return;
//    }
    
    CXGroupMember *model;
    if (self.isSearch) {
        model = self.searchArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    //如果是本人则不能选
    if ([model.userId isEqualToString:VAL_HXACCOUNT]) {
        return;
    }
    
    
    if ([self isContainModel:model]) {
        if ([self getIndexWithInternalSelectedUsers:model] < _twoSelectNumber) {//如果第二次选中的元素是传进来的元素就不让取消选择
            return;
        }
        [_internalSelectedUsers removeObject:model];
    }else{
        [_internalSelectedUsers addObject:model];
    }
    
    if (_internalSelectedUsers.count%5 == 1) {
        long num = _internalSelectedUsers.count / 5;
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.frame = CGRectMake(0, navHigh, Screen_Width, ((Screen_Width-6*10)/5+10)*(num+1)+10);
            self.searchBar.frame = CGRectMake(0, self.collectionView.bottom, Screen_Width, 40);
            self.tableView.frame = CGRectMake(0, self.searchBar.bottom, Screen_Width, Screen_Height-self.searchBar.bottom);
        }];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.collectionView reloadData];
}

-(int)getIndexWithInternalSelectedUsers:(CXGroupMember *)model{
    for (int i = 0; i < _internalSelectedUsers.count; i++) {
        CXGroupMember *member = _internalSelectedUsers[i];
        if ([member.userId isEqualToString:model.userId]) {
            return i;
        }
    }
    
    return NSNotFound;
}


#pragma mark - UICollectionViewDelegate + UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _internalSelectedUsers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    CXGroupMember *model = _internalSelectedUsers[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, (Screen_Width-6*10)/5, (Screen_Width-6*10)/5);
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    [cell addSubview:imageView];
    [imageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((Screen_Width-6*10)/5, (Screen_Width-6*10)/5);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
