//
//  CXYMActionSheetView.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMActionSheetView.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXYMActionSheetView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sheetArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, copy) NSString *title;
@end

static NSString *const actionSheetCellIdentity = @"actionSheetCellIdentity";
@implementation CXYMActionSheetView

#define kYMRowHeight 40
#define kYMHeaderVeiwHeight 48

#pragma mark -- setter && getter
- (void)setHeadBackgroudColor:(UIColor *)headBackgroudColor{
    _headerView.backgroundColor = headBackgroudColor;
}
- (void)setSureButtonTextFont:(UIColor *)sureButtonTextFont{
    
}

-(void)setSureButtonTextColor:(UIColor *)sureButtonTextColor{
    
}
- (void)setCancelButtonTextFont:(UIColor *)cancelButtonTextFont{
    
}
- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor{
    
}
//
- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerView.backgroundColor = [UIColor yy_colorWithHexString:@"#F5F6F8"];
    }
    return _headerView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        _tableView.rowHeight = kYMRowHeight;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:actionSheetCellIdentity];
    }
    return _tableView;
}
#pragma  mark -- init
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        NSAssert(NO, @"Invalid origin provided to ActionSheetPicker ( %@ )", aDecoder);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        NSAssert(NO, @"Invalid origin provided to ActionSheetPicker ( %@ )", @(frame));
        [self setupSubview];
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
//        NSAssert(NO, @"Invalid origin provided to ActionSheetPicker");
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title sheetArray:(NSArray<NSString *> *)sheetArray{
    self = [super init];
    if (self) {
        self.sheetArray = [sheetArray copy];
        self.title = [title copy];
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    //bg
    self.frame = [UIScreen mainScreen].bounds;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.bgView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    self.bgView.backgroundColor = [UIColor darkGrayColor];
    self.bgView.alpha = .8;
    [self addSubview:self.bgView];
    //tableview
    self.tableView.alpha = 1;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
    //cancel
    UIButton *cancelbutton = [[UIButton alloc] initWithFrame:CGRectZero];
//    cancelbutton.frame = CGRectMake(10, 10, 50, kYMHeaderVeiwHeight);
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelbutton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:cancelbutton];
    //sure
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    sureButton.frame = CGRectMake(Screen_Width - 100, 10, 50, kYMHeaderVeiwHeight);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:sureButton];
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.frame = CGRectMake(100, 10, Screen_Width - 200, kYMHeaderVeiwHeight);
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titleLabel];
    //add subview
    self.tableView.scrollEnabled = self.sheetArray.count > 5 ? YES : NO;
    CGFloat tableViewHeight = self.sheetArray.count > 5 ? 5 * kYMRowHeight : self.sheetArray.count * kYMRowHeight;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(tableViewHeight + kYMHeaderVeiwHeight);
    }];
    //header
    self.headerView.bounds = CGRectMake(0, 0, Screen_Width, kYMHeaderVeiwHeight);
//    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:cancelbutton];
    [cancelbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(50);
    }];
    [self.headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-100);
    }];
    [self.headerView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(50);
    }];
    
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sheetArray.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kYMHeaderVeiwHeight;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:actionSheetCellIdentity forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.sheetArray.count > 0 ? self.sheetArray[indexPath.row] : @" ";
    if (_selectedIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
        
    }
    return cell;
}
- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
    oldcell.accessoryType = UITableViewCellAccessoryNone;
    oldcell.textLabel.textColor = [UIColor blackColor];
    _selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor = [UIColor redColor];
}

#pragma mark -- cancel && sure
- (void)cancelClick{
    [self dismiss];
}
- (void)sureClick{
    if (self.block) {
        if(self.selectedIndexPath){
            self.block(self.selectedIndexPath.row,self.sheetArray[self.selectedIndexPath.row]);
        }else{
            self.block(-1,@"");
        }
    }
    [self dismiss];
}
#pragma mark --show && dismiss
- (void)show{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [UIView animateWithDuration:.25 animations:^{
        [keyWindow addSubview:self];
    }];
   
}

- (void)dismiss{
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:.25 animations:^{
        [self.tableView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
  
}

@end
