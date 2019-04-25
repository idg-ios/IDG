//
//  SDIMReceiveAndPayMoneyViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMReceiveAndPayMoneyViewController.h"
#import "Masonry.h"

#define kReceiveOrPayViewHeight (Screen_Width - SDHeadImageViewLeftSpacing*2)*413/676

@interface SDIMReceiveAndPayMoneyViewController()

@property (nonatomic, strong) SDRootTopView* rootTopView;

// 删除聊天记录确认view
@property (nonatomic,strong) UIView *deleteRecordConfirmView;

// 遮盖view
@property (nonatomic,strong) UIView *coverView;

//标题label
@property (nonatomic,strong) UILabel * titleLabel;

//用来记录提示是收款还是付款功能未开通
@property (nonatomic, strong) NSString * alertText;

@end

@implementation SDIMReceiveAndPayMoneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"收付款")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    [self setReceiveOrPayViewWithText:@"我要收款" Title:@"收" Color:SDReceiveMoneyBtnColor AndFrame:CGRectMake(SDHeadImageViewLeftSpacing, navHigh + SDHeadImageViewLeftSpacing, Screen_Width - SDHeadImageViewLeftSpacing*2, kReceiveOrPayViewHeight)];
    
    [self setReceiveOrPayViewWithText:@"我要付款" Title:@"付" Color:SDBtnGreenColor AndFrame:CGRectMake(SDHeadImageViewLeftSpacing, navHigh + SDHeadImageViewLeftSpacing + kReceiveOrPayViewHeight + SDHeadImageViewLeftSpacing, Screen_Width - SDHeadImageViewLeftSpacing*2, kReceiveOrPayViewHeight)];
}

- (void)setReceiveOrPayViewWithText:(NSString *)text Title:(NSString *)title Color:(UIColor *)color AndFrame:(CGRect)rect
{
    UIView * whiteBackView = [[UIView alloc] init];
    whiteBackView.frame = rect;
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.layer.cornerRadius = 5;
    whiteBackView.clipsToBounds = YES;
    [self.view addSubview:whiteBackView];
    
    UIButton * receiveOrPayMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    receiveOrPayMoneyBtn.backgroundColor = color;
    receiveOrPayMoneyBtn.frame = CGRectMake((Screen_Width - 80 - SDHeadImageViewLeftSpacing*2)/2, (kReceiveOrPayViewHeight - 80)/2 - 20, 80, 80);
    receiveOrPayMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:33];
    receiveOrPayMoneyBtn.layer.cornerRadius = 40;
    receiveOrPayMoneyBtn.clipsToBounds = YES;
    [receiveOrPayMoneyBtn setTitle:title forState:UIControlStateNormal];
    [receiveOrPayMoneyBtn setTitle:title forState:UIControlStateHighlighted];
    if([title isEqualToString:@"收"]){
        receiveOrPayMoneyBtn.tag = 1;
    }else{
        receiveOrPayMoneyBtn.tag = 2;
    }
    [receiveOrPayMoneyBtn addTarget:self action:@selector(receiveOrPayMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackView addSubview:receiveOrPayMoneyBtn];
    
    UILabel * receiveOrPayMoneyLabel = [[UILabel alloc] init];
    receiveOrPayMoneyLabel.frame = CGRectMake(0, CGRectGetMaxY(receiveOrPayMoneyBtn.frame) + 30 , Screen_Width - SDHeadImageViewLeftSpacing*2, SDMainMessageFont);
    receiveOrPayMoneyLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    receiveOrPayMoneyLabel.textColor = [UIColor blackColor];
    receiveOrPayMoneyLabel.text = text;
    receiveOrPayMoneyLabel.textAlignment = NSTextAlignmentCenter;
    receiveOrPayMoneyLabel.backgroundColor = [UIColor clearColor];
    [whiteBackView addSubview:receiveOrPayMoneyLabel];
}

- (void)receiveOrPayMoneyBtnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if(btn.tag == 1){
        self.alertText = [NSString stringWithFormat:@"收款功能即将开通"];
        [self setDeleteRecordsConfirmViewDisplay:YES];
    }else if(btn.tag == 2){
        self.alertText = [NSString stringWithFormat:@"付款功能即将开通"];
        [self setDeleteRecordsConfirmViewDisplay:YES];
    }
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除聊天记录确认View
//如果弹出聊天记录确认删除View则需要覆盖一层coverView
-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.hidden = YES;
        _coverView.backgroundColor = RGBACOLOR(0, 0, 0, .3);
        [self.navigationController.view addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }
    return _coverView;
}

//初始化删除聊天记录确认View
-(UIView *)deleteRecordConfirmView{
    if (_deleteRecordConfirmView == nil) {
        _deleteRecordConfirmView = [[UIView alloc] init];
        _deleteRecordConfirmView.backgroundColor = [UIColor whiteColor];
        _deleteRecordConfirmView.hidden = YES;
        [self.navigationController.view insertSubview:_deleteRecordConfirmView aboveSubview:self.coverView];
        [_deleteRecordConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.navigationController.view).multipliedBy(.8);
            make.height.mas_equalTo(130);
            make.center.equalTo(self.navigationController.view);
        }];
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = self.alertText;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_deleteRecordConfirmView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_deleteRecordConfirmView).offset(15);
            make.leading.equalTo(_deleteRecordConfirmView).offset(15);
            make.trailing.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
        
        // 确认按钮
        UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ensureBtn.titleLabel.font = _titleLabel.font;
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ensureBtn addTarget:self action:@selector(deleteRecordsConfirmViewEnsureBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_deleteRecordConfirmView addSubview:ensureBtn];
        [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
    }
    return _deleteRecordConfirmView;
}

//删除聊天记录View的确认按钮点击事件
-(void)deleteRecordsConfirmViewEnsureBtnTapped{
    [self setDeleteRecordsConfirmViewDisplay:NO];
}

//确定是否显示删除聊天记录View和CoverView
-(void)setDeleteRecordsConfirmViewDisplay:(BOOL)needShow
{
    _titleLabel.text = self.alertText;
    self.deleteRecordConfirmView.hidden = self.coverView.hidden = !needShow;
}


@end
