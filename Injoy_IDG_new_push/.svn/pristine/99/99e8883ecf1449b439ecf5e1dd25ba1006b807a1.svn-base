//
//  CXYMSearchView.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMSearchView.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXYMSearchView ()<UISearchBarDelegate>

@property (nonatomic, strong) UIButton *bgButton;///<背景遮罩
@property (nonatomic, strong) UIView *contentView;///<内容
@property (nonatomic, strong) UISearchBar *searchBar;///<搜索框
@property (nonatomic, strong) UIButton *redoButton;///<重置按钮
@property (nonatomic, strong) UIButton *sureButton;///<确定按钮

@end

@implementation CXYMSearchView
#pragma mark -- instancetype
- (instancetype)init{
    self = [super init];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (instancetype)initWithSearchPlaceholder:(NSString *)placeholder{
    self = [super init];
    if(self){
        self.searchBar.placeholder = placeholder;
        [self setupSubview];
    }
    return self;
}
#pragma mark -- setter && getter
- (UIButton *)bgButton{
    if(_bgButton == nil){
        _bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgButton.backgroundColor = RGBACOLOR(0, 0, 0, .3);
        [_bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:_bgButton];
    }
    return _bgButton;
}
- (UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.bgButton addSubview:_contentView];
    }
    return _contentView;
}
- (UISearchBar *)searchBar{
    if(_searchBar == nil){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入搜索内容";
        [self.contentView addSubview:_searchBar];
    }
    return _searchBar;
}
- (UIButton *)redoButton{
    if(_redoButton == nil){
        _redoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_redoButton setTitle:@"重置" forState:UIControlStateNormal];
        [_redoButton setTitleColor:kColorWithRGB(236, 72, 73) forState:UIControlStateNormal];
        [_redoButton setBackgroundColor:[UIColor whiteColor]];
        _redoButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _redoButton.layer.masksToBounds = YES;
        _redoButton.layer.borderWidth = 1;
        _redoButton.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        _redoButton.layer.cornerRadius = 3;
        [_redoButton addTarget:self action:@selector(redoButtonClick) forControlEvents:UIControlEventTouchDown];
         [self.contentView addSubview:_redoButton];
    }
    return _redoButton;
}
- (UIButton *)sureButton{
    if(_sureButton == nil){
        _sureButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sureButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:kColorWithRGB(236, 72, 73)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_sureButton];
    }
    return _sureButton;
}
- (void)showWithView:(UIView *)view{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if(keyWindow == nil){
        keyWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    [UIView animateWithDuration:.25 animations:^{
        [keyWindow addSubview:self.bgButton];
        [self.bgButton addSubview:self.contentView];
    }];
    
}
- (void)dismiss{
    [self.bgButton removeFromSuperview];
    [self.contentView removeFromSuperview];
    [self.redoButton removeFromSuperview];
    [self.sureButton removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setupSubview{
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = [UIScreen mainScreen].bounds;
 
     [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.mas_equalTo(0);
         make.height.mas_equalTo(300);
         make.top.mas_equalTo(navHigh);
     }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.redoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.sureButton);
        make.right.mas_equalTo(self.sureButton.mas_left).mas_offset(-10);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.redoButton);
        make.left.mas_equalTo(self.redoButton.mas_right).mas_offset(10);
    }];
    
}
#pragma mark -- target

- (void)bgButtonClick{
     [self dismiss] ;
}
- (void)redoButtonClick{
    self.searchBar.text = @"";
//    [self dismiss];
}
- (void)sureButtonClick{
    //去除首尾空行和换行
    NSString *text = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(self.block){
        self.block(text);
    }
    [self dismiss];
}

@end

@interface CXYMItemCell: UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CXYMItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [CXYMAppearanceManager textMediumFont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
     [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_offset(0);
     }];
}
@end


@interface CXYMItemSearchView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *title;

@end

static NSString *const itemCellIdentity = @"itemCellIdentity";
@implementation CXYMItemSearchView

#pragma mark -- setter && getter
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
         [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.searchBar.mas_bottom).mas_offset(15);
             make.left.right.mas_equalTo(0);
             make.bottom.mas_equalTo(self.sureButton.mas_top).mas_offset(-15);
         }];
    }
    return self;
}
-(NSMutableArray *)array{
    if(_array == nil){
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[CXYMItemCell class] forCellWithReuseIdentifier:itemCellIdentity];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
         [self addSubview:_collectionView];
    }
    return _collectionView;
}
-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ItemArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat space = 10;
    return CGSizeMake((Screen_Width - space * 4) / 3.0, 36);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CXYMItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCellIdentity forIndexPath:indexPath];
    if(self.selectedIndexPath == indexPath){
        cell.titleLabel.text = [NSString stringWithFormat:@"✔️%@",self.ItemArray[indexPath.row]];
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, cell.titleLabel.text.length)];
//        cell.titleLabel.attributedText = string;
        cell.titleLabel.textColor = [UIColor redColor];
    }else{
        cell.titleLabel.text = self.ItemArray[indexPath.row];
        cell.titleLabel.backgroundColor = [UIColor yy_colorWithHexString:@"#F5F6F8"];
        cell.titleLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];
    }
    return cell;
}
- (void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    CXYMItemCell *cell = (CXYMItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(self.selectedIndexPath == indexPath){
        cell.titleLabel.backgroundColor = [UIColor blueColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
    }else{
        cell.titleLabel.backgroundColor = [UIColor lightGrayColor];
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    [self.collectionView reloadData];
    
    self.index = indexPath.row;
    self.title = self.ItemArray[indexPath.row];

//    if(self.itemBlock){
//        self.itemBlock(indexPath.row,self.ItemArray[indexPath.row],self.searchBar.text);
//    }
}
-(void)sureButtonClick{
    if(self.itemBlock){
        self.itemBlock(self.index, self.title, self.searchBar.text);
    }
    self.block(self.searchBar.text);
    [self dismiss];
}
-(void)redoButtonClick{
    self.searchBar.text = @"";
    self.selectedIndexPath = nil;
    [self.collectionView reloadData];
}

@end


