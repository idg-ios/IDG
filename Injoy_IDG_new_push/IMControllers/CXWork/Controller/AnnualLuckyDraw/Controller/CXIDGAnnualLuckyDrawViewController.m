//
//  CXIDGAnnualLuckyDrawViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/5.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGAnnualLuckyDrawViewController.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "CXIDGInvertedTriangleView.h"
#import "CXIDGCurrentAnnualMeetingModel.h"
#import "CXIDGCurrentAnnualItemListModel.h"
#import "CXAnnualItemListTableViewCell.h"
#import "CXAnnualTPListTableViewCell.h"
#import "CXIDGPrizeModel.h"
#import "CXPrizeOwnerListModel.h"
#import "CXIDGAnnualLuckyDrawDetailInfoViewController.h"
#import "CXEditLabel.h"
#import "CXAnnualHJListTableViewCell.h"
#import "CXScanViewController.h"
#import "CXIDGAnnualLuckyDrawQDCodeViewController.h"
#import "CXIDGNHDMModel.h"
#import "BulletView.h"
#import "BulletManager.h"
#import "BulletBackgroudView.h"
#import "CXIDGAnnualLuckyXCViewController.h"
#import "CXSignListUserModel.h"
#import "CXAnnualLuckyQDUserListViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CXIDGAnnualLuckyDrawViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

/** rootTopView */
@property(strong, nonatomic) SDRootTopView *rootTopView;
/** 聊天tableView */
@property(strong, nonatomic) UITableView *tableView;
/** 是聊天键盘弹起 */
@property (nonatomic,assign) BOOL isTalkTextView;
/** 底部操作栏 */
@property (nonatomic,strong) UIView *toolView;
/** 弹起键盘按钮 */
@property (nonatomic,strong) UIButton * showKeyBoardBtn;
/** 文本输入 */
@property (nonatomic,strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic,strong) UIButton *sendBtn;
/** firstLineView */
@property (nonatomic, strong) UIView * firstLineView;
/** secondLineView */
@property (nonatomic, strong) UIView * secondLineView;
/** 互动按钮 */
@property (nonatomic,strong) UIButton *hdBtn;
/** thirdLineView */
@property (nonatomic, strong) UIView * thirdLineView;
/** 年会按钮 */
@property (nonatomic,strong) UIButton *nhBtn;
/** 相册按钮 */
@property (nonatomic,strong) UIButton *xcBtn;
/** 年会信息Model */
@property (nonatomic,strong) CXIDGCurrentAnnualMeetingModel * currentAnnualMeetingModel;
/** xcClickView */
@property (nonatomic, strong) UIView * xcClickView;
/** hdClickView */
@property (nonatomic, strong) UIView * hdClickView;
/** nhxxClickView */
@property (nonatomic, strong) UIView * nhClickView;
/** dataSource */
@property (nonatomic, strong) NSMutableArray<CXIDGCurrentAnnualItemListModel *> * dataSource;
/** 类型 */
@property (nonatomic) IDGAnnualLuckyViewType type;
/** tpView */
@property (nonatomic, strong) UIView * tpView;
/** selectedDataSource */
@property (nonatomic, strong) NSMutableArray<CXIDGCurrentAnnualItemListModel *> * selectedDataSource;
/** prizeArray */
@property (nonatomic, strong) NSMutableArray<CXIDGPrizeModel *> * prizeArray;
/** prizeOwnerArray */
@property (nonatomic, strong) NSMutableArray<CXPrizeOwnerListModel *> * prizeOwnerArray;
/** selectedPrizeModel */
@property (nonatomic, strong) CXIDGPrizeModel * selectedPrizeModel;
/** nhdmArray */
@property (nonatomic, strong) NSMutableArray<CXIDGNHDMModel *> * nhdmArray;
/** bulletManager */
@property (nonatomic, strong) BulletManager *bulletManager;
/** bulletBgView */
@property (nonatomic, strong) BulletBackgroudView *bulletBgView;
/** 年会主题 */
@property(strong, nonatomic) CXEditLabel *nhztLabel;
/** 年份 */
@property(strong, nonatomic) CXEditLabel *nfLabel;
/** 年会时间 */
@property(strong, nonatomic) CXEditLabel *nhsjLabel;
/** 更多按钮 */
@property(strong, nonatomic) UIButton *moreBtn;
/** 签到人员 */
@property(strong, nonatomic) CXEditLabel *qdryLabel;
/** 日程安排 */
@property(strong, nonatomic) UILabel *rcapLabel;
/** 日程安排内容 */
@property(strong, nonatomic) UILabel *rcapContentLabel;
/** 签到人员数组 */
@property(strong, nonatomic) NSMutableArray<CXSignListUserModel *> *signListUserModelArray;

@end

@implementation CXIDGAnnualLuckyDrawViewController

#pragma mark - LazyLoad
- (NSMutableArray<CXSignListUserModel *> *)signListUserModelArray{
    if(!_signListUserModelArray){
        _signListUserModelArray = @[].mutableCopy;
    }
    return _signListUserModelArray;
}

- (BulletBackgroudView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[BulletBackgroudView alloc] init];
        _bulletBgView.frame = CGRectMake(0, 130, CGRectGetWidth(self.view.frame), 360);
        _bulletBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bulletBgView];
        [self.view bringSubviewToFront:self.bulletBgView];
    }
    return _bulletBgView;
}

- (CXIDGCurrentAnnualMeetingModel *)currentAnnualMeetingModel{
    if(!_currentAnnualMeetingModel){
        _currentAnnualMeetingModel = [[CXIDGCurrentAnnualMeetingModel alloc] init];
    }
    return _currentAnnualMeetingModel;
}

- (NSMutableArray<CXIDGCurrentAnnualItemListModel *> *)dataSource{
    if(!_dataSource){
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray<CXIDGCurrentAnnualItemListModel *> *)selectedDataSource{
    if(!_selectedDataSource){
        _selectedDataSource = @[].mutableCopy;
    }
    return _selectedDataSource;
}

- (NSMutableArray<CXIDGPrizeModel *> *)prizeArray{
    if(!_prizeArray){
        _prizeArray = @[].mutableCopy;
    }
    return _prizeArray;
}

- (NSMutableArray<CXPrizeOwnerListModel *> *)prizeOwnerArray{
    if(!_prizeOwnerArray){
        _prizeOwnerArray = @[].mutableCopy;
    }
    return _prizeOwnerArray;
}

- (NSMutableArray<CXIDGNHDMModel *> *)nhdmArray{
    if(!_nhdmArray){
        _nhdmArray = @[].mutableCopy;
    }
    return _nhdmArray;
}

- (BulletManager *)bulletManager{
    if(!_bulletManager){
        _bulletManager = [[BulletManager alloc] init];
        __weak CXIDGAnnualLuckyDrawViewController *myself = self;
        _bulletManager.generateBulletBlock = ^(BulletView *bulletView) {
            [myself addBulletView:bulletView];
        };
    }
    return _bulletManager;
}

- (UIView *)xcClickView{
    if(!_xcClickView){
        _xcClickView = [[UIView alloc] init];
        _xcClickView.frame = CGRectMake(2*kRightBtnWidth + kClickViewLeftSpace, Screen_Height - kToolViewHeight - (kClickViewCellHeight + kClickBottomSpace), kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight + kClickBottomSpace);
        _xcClickView.backgroundColor = [UIColor clearColor];
        _xcClickView.hidden = NO;
        [self.view addSubview:_xcClickView];
        
        UIView * cornerBackView = [[UIView alloc] init];
        cornerBackView.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        cornerBackView.layer.cornerRadius = 2.0;
        cornerBackView.clipsToBounds = YES;
        cornerBackView.backgroundColor = RGBACOLOR(246.0, 244.0, 245.0, 1.0);
        [_xcClickView addSubview:cornerBackView];
        
        CXIDGInvertedTriangleView * invertedTriangleView = [[CXIDGInvertedTriangleView alloc] init];
        invertedTriangleView.frame = CGRectMake(0, kClickViewCellHeight, kRightBtnWidth - (kClickViewLeftSpace*2), kClickBottomSpace);
        [_xcClickView addSubview:invertedTriangleView];
        
        UIButton * jdxxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jdxxBtn.titleLabel.font = [UIFont systemFontOfSize:kClickViewLabelFontSize];
        jdxxBtn.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        [jdxxBtn setTitle:@"相册" forState:UIControlStateNormal];
        [jdxxBtn setTitle:@"相册" forState:UIControlStateHighlighted];
        [jdxxBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateNormal];
        [jdxxBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateHighlighted];
        [jdxxBtn addTarget:self action:@selector(jdxxBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_xcClickView addSubview:jdxxBtn];
    }
    return _xcClickView;
}

- (UIView *)hdClickView{
    if(!_hdClickView){
        _hdClickView = [[UIView alloc] init];
        _hdClickView.frame = CGRectMake(kRightBtnWidth + kClickViewLeftSpace, Screen_Height - kToolViewHeight - (kClickViewCellHeight*2 + kClickBottomSpace + kClickViewLineHeight), kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight*2 + kClickBottomSpace + kClickViewLineHeight);
        _hdClickView.backgroundColor = [UIColor clearColor];
        _hdClickView.hidden = YES;
        [self.view addSubview:_hdClickView];
        
        UIView * cornerBackView = [[UIView alloc] init];
        cornerBackView.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight*2 + kClickViewLineHeight);
        cornerBackView.layer.cornerRadius = 2.0;
        cornerBackView.clipsToBounds = YES;
        cornerBackView.backgroundColor = RGBACOLOR(246.0, 244.0, 245.0, 1.0);
        [_hdClickView addSubview:cornerBackView];
        
        CXIDGInvertedTriangleView * invertedTriangleView = [[CXIDGInvertedTriangleView alloc] init];
        invertedTriangleView.frame = CGRectMake(0, kClickViewCellHeight*2 + kClickViewLineHeight, kRightBtnWidth - (kClickViewLeftSpace*2), kClickBottomSpace);
        [_hdClickView addSubview:invertedTriangleView];
        
        UIButton * jmtpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jmtpBtn.titleLabel.font = [UIFont systemFontOfSize:kClickViewLabelFontSize];
        jmtpBtn.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        [jmtpBtn setTitle:@"节目投票" forState:UIControlStateNormal];
        [jmtpBtn setTitle:@"节目投票" forState:UIControlStateHighlighted];
        [jmtpBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateNormal];
        [jmtpBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateHighlighted];
        [jmtpBtn addTarget:self action:@selector(jmtpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_hdClickView addSubview:jmtpBtn];
        
        UIView * firstLineView = [[UIView alloc] init];
        firstLineView.frame = CGRectMake(kClickViewLineLeftSpace, kClickViewCellHeight, kRightBtnWidth - (kClickViewLeftSpace*2) - kClickViewLineLeftSpace*2, kClickViewLineHeight);
        firstLineView.backgroundColor = RGBACOLOR(226.0, 224.0, 225.0, 1.0);
        [_hdClickView addSubview:firstLineView];
        
        UIButton * xxPKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xxPKBtn.titleLabel.font = [UIFont systemFontOfSize:kClickViewLabelFontSize];
        xxPKBtn.frame = CGRectMake(0, kClickViewCellHeight + kClickViewLineHeight, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        [xxPKBtn setTitle:@"iStar唱将" forState:UIControlStateNormal];
        [xxPKBtn setTitle:@"iStar唱将" forState:UIControlStateHighlighted];
        [xxPKBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateNormal];
        [xxPKBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateHighlighted];
        [xxPKBtn addTarget:self action:@selector(xxPKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_hdClickView addSubview:xxPKBtn];
    }
    return _hdClickView;
}

- (UIView *)nhClickView{
    if(!_nhClickView){
        _nhClickView = [[UIView alloc] init];
        _nhClickView.frame = CGRectMake(kClickViewLeftSpace, Screen_Height - kToolViewHeight - (kClickViewCellHeight*2 + kClickBottomSpace + kClickViewLineHeight), kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight*2 + kClickBottomSpace + kClickViewLineHeight);
        _nhClickView.backgroundColor = [UIColor clearColor];
        _nhClickView.hidden = YES;
        [self.view addSubview:_nhClickView];
        
        UIView * cornerBackView = [[UIView alloc] init];
        cornerBackView.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight*2 + kClickViewLineHeight);
        cornerBackView.layer.cornerRadius = 2.0;
        cornerBackView.clipsToBounds = YES;
        cornerBackView.backgroundColor = RGBACOLOR(246.0, 244.0, 245.0, 1.0);
        [_nhClickView addSubview:cornerBackView];
        
        CXIDGInvertedTriangleView * invertedTriangleView = [[CXIDGInvertedTriangleView alloc] init];
        invertedTriangleView.frame = CGRectMake(0, kClickViewCellHeight*2 + kClickViewLineHeight, kRightBtnWidth - (kClickViewLeftSpace*2), kClickBottomSpace);
        [_nhClickView addSubview:invertedTriangleView];
        
        UIButton * nhxxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nhxxBtn.titleLabel.font = [UIFont systemFontOfSize:kClickViewLabelFontSize];
        nhxxBtn.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        [nhxxBtn setTitle:@"年会信息" forState:UIControlStateNormal];
        [nhxxBtn setTitle:@"年会信息" forState:UIControlStateHighlighted];
        [nhxxBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateNormal];
        [nhxxBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateHighlighted];
        [nhxxBtn addTarget:self action:@selector(nhxxBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_nhClickView addSubview:nhxxBtn];
        
        UIView * firstLineView = [[UIView alloc] init];
        firstLineView.frame = CGRectMake(kClickViewLineLeftSpace, kClickViewCellHeight, kRightBtnWidth - (kClickViewLeftSpace*2) - kClickViewLineLeftSpace*2, kClickViewLineHeight);
        firstLineView.backgroundColor = RGBACOLOR(226.0, 224.0, 225.0, 1.0);
        [_nhClickView addSubview:firstLineView];
        
        UIButton * jmdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jmdBtn.titleLabel.font = [UIFont systemFontOfSize:kClickViewLabelFontSize];
        jmdBtn.frame = CGRectMake(0, kClickViewCellHeight + kClickViewLineHeight, kRightBtnWidth - (kClickViewLeftSpace*2), kClickViewCellHeight);
        [jmdBtn setTitle:@"节目单" forState:UIControlStateNormal];
        [jmdBtn setTitle:@"节目单" forState:UIControlStateHighlighted];
        [jmdBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateNormal];
        [jmdBtn setTitleColor:RGBACOLOR(53.0, 53.0, 53.0, 1.0) forState:UIControlStateHighlighted];
        [jmdBtn addTarget:self action:@selector(jmdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_nhClickView addSubview:jmdBtn];
    }
    return _nhClickView;
}

- (UIView *)toolView{
    if(!_toolView){
        // 底部操作栏
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = RGBACOLOR(243.0, 233.0, 234.0, 0.95);
        _toolView.hidden = NO;
        [self.view addSubview:_toolView];
        
        UIView * topLineView = [[UIView alloc] init];
        topLineView.frame = CGRectMake(0, 0, Screen_Width, 0.5);
        topLineView.backgroundColor = RGBACOLOR(243.0, 233.0, 234.0, 1.0);
        [_toolView addSubview:topLineView];
        
        self.firstLineView = [[UIView alloc] init];
        self.firstLineView.backgroundColor = RGBACOLOR(195.0, 195.0, 195.0, 1.0);
        [_toolView addSubview:self.firstLineView];
        [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.toolView).offset(0);
            make.size.mas_equalTo(CGSizeMake(0.5, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        // 年会
        self.nhBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nhBtn setTitle:@"年会" forState:UIControlStateNormal];
        [self.nhBtn setTitle:@"年会" forState:UIControlStateHighlighted];
        [self.nhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.nhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.nhBtn addTarget:self action:@selector(nhBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.nhBtn.hidden = NO;
        self.nhBtn.backgroundColor = [UIColor clearColor];
        [_toolView addSubview:self.nhBtn];
        [self.nhBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.firstLineView).offset(0);
            make.size.mas_equalTo(CGSizeMake(kRightBtnWidth, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        self.secondLineView = [[UIView alloc] init];
        self.secondLineView.backgroundColor = RGBACOLOR(195.0, 195.0, 195.0, 1.0);
        [_toolView addSubview:self.secondLineView];
        [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nhBtn.mas_trailing).offset(-0.5);
            make.size.mas_equalTo(CGSizeMake(0.5, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        // 互动
        self.hdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.hdBtn setTitle:@"互动" forState:UIControlStateNormal];
        [self.hdBtn setTitle:@"互动" forState:UIControlStateHighlighted];
        [self.hdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.hdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.hdBtn addTarget:self action:@selector(hdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.hdBtn.hidden = NO;
        self.hdBtn.backgroundColor = [UIColor clearColor];
        [_toolView addSubview:self.hdBtn];
        [self.hdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.secondLineView).offset(0.5);
            make.size.mas_equalTo(CGSizeMake(kRightBtnWidth, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        self.thirdLineView = [[UIView alloc] init];
        self.thirdLineView.backgroundColor = RGBACOLOR(195.0, 195.0, 195.0, 1.0);
        [_toolView addSubview:self.thirdLineView];
        [self.thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.hdBtn.mas_trailing).offset(-0.5);
            make.size.mas_equalTo(CGSizeMake(0.5, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        // 相册
        self.xcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.xcBtn setTitle:@"相册" forState:UIControlStateNormal];
        [self.xcBtn setTitle:@"相册" forState:UIControlStateHighlighted];
        [self.xcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.xcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.xcBtn addTarget:self action:@selector(xcBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.xcBtn.hidden = NO;
        self.xcBtn.backgroundColor = [UIColor clearColor];
        [_toolView addSubview:self.xcBtn];
        [self.xcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.thirdLineView).offset(0.5);
            make.size.mas_equalTo(CGSizeMake(kRightBtnWidth, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        // 输入框
        self.textView = [[UITextView alloc] init];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.scrollEnabled = NO;
        self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.delegate = self;
        self.textView.enablesReturnKeyAutomatically = YES;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = RGBACOLOR(104.0, 104.0, 104.0, 1.0).CGColor;
        self.textView.layer.cornerRadius = 2;
        self.textView.hidden = YES;
        [_toolView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolView).offset(5);
            make.bottom.equalTo(self.toolView).offset(-5);
            make.leading.equalTo(self.toolView).offset(8);
            make.trailing.equalTo(self.toolView).offset(-8);
        }];
    }
    return _toolView;
}

- (UIView *)tpView{
    if(!_tpView){
        _tpView = [[UIView alloc] init];
        _tpView.frame = CGRectMake(kTableViewLeftSpace, Screen_Height - kToolViewHeight - kTableViewLeftSpace - kTableViewJMLBHeaderLabelTopSpace - kQRTPBtnHeight - kTableViewJMLBHeaderLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace, kQRTPHeaderAttentionLabelTopSpace + kQRTPBtnHeight + kQRTPHeaderAttentionLabelTopSpace);
        _tpView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tpView];
        
        UIButton * tpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tpBtn.frame = CGRectMake((Screen_Width - 2*kTableViewLeftSpace - kQRTPBtnWidth)/2, (kQRTPHeaderAttentionLabelTopSpace + kQRTPBtnHeight + kQRTPHeaderAttentionLabelTopSpace - kQRTPBtnHeight)/2, kQRTPBtnWidth, kQRTPBtnHeight);
        [tpBtn setTitle:@"确认投票" forState:UIControlStateNormal];
        [tpBtn setTitle:@"确认投票" forState:UIControlStateHighlighted];
        [tpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        tpBtn.layer.cornerRadius = kTpBtnCornerRadius;
        [tpBtn addTarget:self action:@selector(tpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        tpBtn.titleLabel.font = [UIFont systemFontOfSize:kTpBtnFontSize];
        if(!([self.currentAnnualMeetingModel.startVote integerValue] == 1)){
            tpBtn.enabled = NO;
            tpBtn.backgroundColor = [UIColor grayColor];
        }else if([self.currentAnnualMeetingModel.isVote integerValue] == 1){
            tpBtn.enabled = NO;
            tpBtn.backgroundColor = [UIColor grayColor];
        }else{
            tpBtn.enabled = YES;
            tpBtn.backgroundColor = RGBACOLOR(220.0, 167.0, 84.0, 1.0);
        }
        [_tpView addSubview:tpBtn];
    }
    return _tpView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];
    
    [self setUpNavBar];
    
    //大红灯笼背景
    UIImageView * backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"JMDBI"];
    backImageView.highlightedImage = [UIImage imageNamed:@"JMDBI"];
    backImageView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height + kTabbarSafeBottomMargin - navHigh);
    [self.view addSubview:backImageView];
    
    //补全iPhoneX的下方空白
    UIView * bottomColorView = [[UIView alloc] init];
    bottomColorView.frame = CGRectMake(0, Screen_Height, Screen_Width, kTabbarSafeBottomMargin);
    bottomColorView.backgroundColor = RGBACOLOR(243.0, 233.0, 234.0, 0.95);
    [self.view addSubview:bottomColorView];
    
    //补全iPhoneX的下方空白分割线
    UIView * bottomLineView = [[UIView alloc] init];
    bottomLineView.frame = CGRectMake(0, Screen_Height, Screen_Width, 0.5);
    bottomLineView.backgroundColor = RGBACOLOR(195.0, 195.0, 195.0, 1.0);
    [self.view addSubview:bottomLineView];

    //导航栏挪到视图顶层
    [self.view bringSubviewToFront:self.rootTopView];
    
    [self addBottomBar];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    [self nhxxBtnClick];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.bulletManager stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 内部方法
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    return line;
}

- (void)collapseAll{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
}

- (void)addBulletView:(BulletView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.view.frame)+50, 20 + 34 * bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startAnimation];
}

- (void)receivePushNotification:(NSNotification *)notification
{
    if(VAL_PUSHES_MSGS(NH_CODE) && [VAL_PUSHES_MSGS(NH_CODE) count] > 0){
        NSArray * newDMArray = [NSArray yy_modelArrayWithClass:CXIDGNHDMModel.class json:VAL_PUSHES_MSGS(NH_CODE)];
        NSMutableArray * dmArray = @[].mutableCopy;
        for(CXIDGNHDMModel * model in newDMArray){
            if([model.meetId integerValue] == [self.currentAnnualMeetingModel.eid integerValue]){
               [dmArray addObject:model];
            }
        }
        [self.bulletManager addComments:dmArray];
        [self.view bringSubviewToFront:self.bulletBgView];
        [self.bulletManager start];
        [self.nhdmArray addObjectsFromArray:newDMArray];
        VAL_PUSHES_HAVEREAD_NEW(NH_CODE);
    }
}

- (void)loadAnnualItemListData
{
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.currentAnnualMeetingModel = [CXIDGCurrentAnnualMeetingModel yy_modelWithDictionary:JSON[@"data"][@"detail"]];
            
            NSString *url = [NSString stringWithFormat:@"%@annual/item/list/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGCurrentAnnualItemListModel.class json:JSON[@"data"][@"itemList"]]];
                    self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace);
                    UIView * tableHeaderView = [[UIView alloc] init];
                    tableHeaderView.frame = CGRectMake(0, 0, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderHeight);
                    tableHeaderView.backgroundColor = [UIColor clearColor];
                    
                    UILabel * titleLabel = [[UILabel alloc] init];
                    titleLabel.frame = CGRectMake(0, kTableViewJMLBHeaderLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderLabelFontSize);
                    titleLabel.font = [UIFont systemFontOfSize:kTableViewJMLBHeaderLabelFontSize];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.textColor = kLabelTextColor;
                    if(self.type == JMXXType){
                        titleLabel.text = @"年会节目单";
                    }
                    
                    [tableHeaderView addSubview:titleLabel];
                    
                    UIView * lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLabelTopSpace*2 + kTableViewJMLBHeaderLabelFontSize, Screen_Width - 2*kTableViewLeftSpace - 2*kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLineHeight);
                    lineView.backgroundColor = [UIColor whiteColor];
                    [tableHeaderView addSubview:lineView];
                    self.tableView.allowsSelection = YES;
                    [self.tableView setTableHeaderView:tableHeaderView];
                    
                    [_moreBtn removeFromSuperview];
                    [self.tableView reloadData];
                    
                } else {
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    if(point.y > CGRectGetMinY(_toolView.frame)){
        [self.view bringSubviewToFront:_toolView];
        self.isTalkTextView = YES;
    }else{
        [self collapseAll];
        self.isTalkTextView = NO;
    }
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"公司年会"];
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

//添加BottomBar
-(void)addBottomBar
{
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    self.toolView.hidden = NO;
}

#pragma mark - 键盘伸缩通知
-(void)keyboardWillShow:(NSNotification *)aNotification{
    if(self.isTalkTextView){
        [self hideClickView];
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat height = [aValue CGRectValue].size.height;
        self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight - height, Screen_Width, kToolViewHeight);
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else{
        [self collapseAll];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.textView.inputView = nil;
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ToolViewBtnClick
- (void)xcBtnClick
{
    [self setToolViewSubviewHidden];
    self.hdClickView.hidden = YES;
    self.nhClickView.hidden = YES;
    self.xcClickView.hidden = !self.xcClickView.hidden;
    [self.view bringSubviewToFront:self.xcClickView];
}

- (void)hdBtnClick
{
    [self setToolViewSubviewHidden];
    self.xcClickView.hidden = YES;
    self.nhClickView.hidden = YES;
    self.hdClickView.hidden = !self.hdClickView.hidden;
    [self.view bringSubviewToFront:self.hdClickView];
}

- (void)nhBtnClick
{
    [self setToolViewSubviewHidden];
    self.xcClickView.hidden = YES;
    self.hdClickView.hidden = YES;
    self.nhClickView.hidden = !self.nhClickView.hidden;
    [self.view bringSubviewToFront:self.nhClickView];
}

- (void)qdewmBtnClick
{
    [self hideClickView];
    CXIDGAnnualLuckyDrawQDCodeViewController *annualLuckyDrawQDCodeViewController = [[CXIDGAnnualLuckyDrawQDCodeViewController alloc] init];
    annualLuckyDrawQDCodeViewController.currentAnnualMeetingModel = self.currentAnnualMeetingModel;
    [self.navigationController pushViewController:annualLuckyDrawQDCodeViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)jdxxBtnClick
{
    [self hideClickView];
    CXIDGAnnualLuckyXCViewController *annualLuckyXCViewController = [[CXIDGAnnualLuckyXCViewController alloc] init];
    annualLuckyXCViewController.currentAnnualMeetingModel = self.currentAnnualMeetingModel;
    [self.navigationController pushViewController:annualLuckyXCViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)smBtnClick
{
    [self hideClickView];
    CXScanViewController *scanVC = [[CXScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)jmtpBtnClick
{
    [self hideClickView];
    
    self.type = JMTPType;
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.currentAnnualMeetingModel = [CXIDGCurrentAnnualMeetingModel yy_modelWithDictionary:JSON[@"data"][@"detail"]];
            NSString *url = [NSString stringWithFormat:@"%@annual/item/list/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    [self.selectedDataSource removeAllObjects];
                    self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGCurrentAnnualItemListModel.class json:JSON[@"data"][@"itemList"]]];
                    self.currentAnnualMeetingModel.isVote = @([JSON[@"data"][@"isVote"] integerValue]);
                    self.currentAnnualMeetingModel.startVote = @([JSON[@"data"][@"startVote"] integerValue]);
                    self.selectedDataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGCurrentAnnualItemListModel.class json:JSON[@"data"][@"voteItemList"]]];
                    self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace - kTableViewJMLBHeaderLabelTopSpace - kQRTPBtnHeight - kTableViewJMLBHeaderLabelTopSpace);
                    UIView * tableHeaderView = [[UIView alloc] init];
                    tableHeaderView.frame = CGRectMake(0, 0, Screen_Width - 2*kTableViewLeftSpace, kQRTPHeaderHeight);
                    tableHeaderView.backgroundColor = [UIColor clearColor];
                    
                    UILabel * titleLabel = [[UILabel alloc] init];
                    titleLabel.frame = CGRectMake(0, kTableViewJMLBHeaderLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderLabelFontSize);
                    titleLabel.font = [UIFont systemFontOfSize:kTableViewJMLBHeaderLabelFontSize];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.textColor = kLabelTextColor;
                    titleLabel.text = @"年会节目投票";
                    [tableHeaderView addSubview:titleLabel];
                    
                    UIView * lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLabelTopSpace*2 + kTableViewJMLBHeaderLabelFontSize, Screen_Width - 2*kTableViewLeftSpace - 2*kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLineHeight);
                    lineView.backgroundColor = [UIColor whiteColor];
                    [tableHeaderView addSubview:lineView];
                    
                    UILabel * attentionLabel = [[UILabel alloc] init];
                    attentionLabel.frame = CGRectMake(kQRTPHeaderAttentionLabelLeftSpace, kTableViewJMLBHeaderLabelTopSpace*2 + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLineHeight + kQRTPHeaderAttentionLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace - kQRTPHeaderAttentionLabelLeftSpace, kQRTPHeaderAttentionLabelFontSize);
                    attentionLabel.font = [UIFont systemFontOfSize:kQRTPHeaderAttentionLabelFontSize];
                    attentionLabel.backgroundColor = [UIColor clearColor];
                    attentionLabel.textAlignment = NSTextAlignmentLeft;
                    attentionLabel.textColor = kLabelTextColor;
                    attentionLabel.text = @"请在以下节目中，选出您觉得最精彩的节目：";
                    [tableHeaderView addSubview:attentionLabel];
                    if(self.tpView){
                        [self.tpView removeFromSuperview];
                        self.tpView = nil;
                    }
                    self.tpView.hidden = NO;
                    
                    if(!([self.currentAnnualMeetingModel.startVote integerValue] == 1)){
                        self.tableView.allowsSelection = NO;
                    }else if([self.currentAnnualMeetingModel.isVote integerValue] == 1){
                        self.tableView.allowsSelection = NO;
                    }else{
                        self.tableView.allowsSelection = YES;
                    }
                    
                    if(!([self.currentAnnualMeetingModel.startVote integerValue] == 1)){
                        [self.view makeToast:@"投票通道暂未开启!" duration:2 position:@"center"];
                    }else if([self.currentAnnualMeetingModel.isVote integerValue] == 1){
                        [self.view makeToast:@"您已经投过票了!" duration:2 position:@"center"];
                    }else{
                        [self.view makeToast:@"您只能投一次，一次可以投1-3个节目!" duration:2 position:@"center"];
                    }
                    
                    [self.tableView setTableHeaderView:tableHeaderView];
                    [self.tableView reloadData];
                    
                    [_moreBtn removeFromSuperview];
                } else {
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
            
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)xxPKBtnClick
{
    [self hideClickView];
    
    self.type = IStarCJTPXXType;
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.currentAnnualMeetingModel = [CXIDGCurrentAnnualMeetingModel yy_modelWithDictionary:JSON[@"data"][@"detail"]];
            NSString *url = [NSString stringWithFormat:@"%@annual/item/iStar/list/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    [self.selectedDataSource removeAllObjects];
                    self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGCurrentAnnualItemListModel.class json:JSON[@"data"][@"itemList"]]];
                    self.currentAnnualMeetingModel.isVote = @([JSON[@"data"][@"isVote"] integerValue]);
                    self.currentAnnualMeetingModel.startVote = @([JSON[@"data"][@"startVote"] integerValue]);
                    self.selectedDataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGCurrentAnnualItemListModel.class json:JSON[@"data"][@"voteItemList"]]];
                    self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace - kTableViewJMLBHeaderLabelTopSpace - kQRTPBtnHeight - kTableViewJMLBHeaderLabelTopSpace);
                    UIView * tableHeaderView = [[UIView alloc] init];
                    tableHeaderView.frame = CGRectMake(0, 0, Screen_Width - 2*kTableViewLeftSpace, kQRTPHeaderHeight);
                    tableHeaderView.backgroundColor = [UIColor clearColor];
                    
                    UILabel * titleLabel = [[UILabel alloc] init];
                    titleLabel.frame = CGRectMake(0, kTableViewJMLBHeaderLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderLabelFontSize);
                    titleLabel.font = [UIFont systemFontOfSize:kTableViewJMLBHeaderLabelFontSize];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.textColor = kLabelTextColor;
                    titleLabel.text = @"iStar唱将投票";
                    [tableHeaderView addSubview:titleLabel];
                    
                    UIView * lineView = [[UIView alloc] init];
                    lineView.frame = CGRectMake(kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLabelTopSpace*2 + kTableViewJMLBHeaderLabelFontSize, Screen_Width - 2*kTableViewLeftSpace - 2*kTableViewJMLBHeaderLineLeftSpace, kTableViewJMLBHeaderLineHeight);
                    lineView.backgroundColor = [UIColor whiteColor];
                    [tableHeaderView addSubview:lineView];
                    
                    UILabel * attentionLabel = [[UILabel alloc] init];
                    attentionLabel.frame = CGRectMake(kQRTPHeaderAttentionLabelLeftSpace, kTableViewJMLBHeaderLabelTopSpace*2 + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLineHeight + kQRTPHeaderAttentionLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace - kQRTPHeaderAttentionLabelLeftSpace, kQRTPHeaderAttentionLabelFontSize);
                    attentionLabel.font = [UIFont systemFontOfSize:kQRTPHeaderAttentionLabelFontSize];
                    attentionLabel.backgroundColor = [UIColor clearColor];
                    attentionLabel.textAlignment = NSTextAlignmentLeft;
                    attentionLabel.textColor = kLabelTextColor;
                    attentionLabel.text = @"请在以下节目中，选出您觉得最精彩的节目：";
                    [tableHeaderView addSubview:attentionLabel];
                    if(self.tpView){
                        [self.tpView removeFromSuperview];
                        self.tpView = nil;
                    }
                    self.tpView.hidden = NO;
                    
                    if(!([self.currentAnnualMeetingModel.startVote integerValue] == 1)){
                        self.tableView.allowsSelection = NO;
                    }else if([self.currentAnnualMeetingModel.isVote integerValue] == 1){
                        self.tableView.allowsSelection = NO;
                    }else{
                        self.tableView.allowsSelection = YES;
                    }
                    
                    if(!([self.currentAnnualMeetingModel.startVote integerValue] == 1)){
                        [self.view makeToast:@"投票通道暂未开启!" duration:2 position:@"center"];
                    }else if([self.currentAnnualMeetingModel.isVote integerValue] == 1){
                        [self.view makeToast:@"您已经投过票了!" duration:2 position:@"center"];
                    }else{
                        [self.view makeToast:@"您只能投一次，一次可以投1-2个节目!" duration:2 position:@"center"];
                    }
                    
                    [self.tableView setTableHeaderView:tableHeaderView];
                    [self.tableView reloadData];
                    
                    [_moreBtn removeFromSuperview];
                } else {
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
            
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)fsdmBtnClick
{
    [self hideClickView];
    self.showKeyBoardBtn.selected = YES;
    [self setToolViewSubviewHidden];
    if(self.showKeyBoardBtn.selected){
        [self.textView becomeFirstResponder];
    }
}

- (void)zjxxBtnClick
{
    [self hideClickView];
    
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/prize/list/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.type = ZJXXType;
            self.prizeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXIDGPrizeModel.class json:JSON[@"data"]]];
            
            if(self.prizeArray && [self.prizeArray count] > 0){
                
                NSString *url = [NSString stringWithFormat:@"%@annual/prize/name/list/%zd", urlPrefix,self.selectedPrizeModel?[self.selectedPrizeModel.eid integerValue]:[self.prizeArray[0].eid integerValue]];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
                    CXStrongSelf(self)
                    if ([JSON[@"status"] intValue] == 200) {
                        self.prizeOwnerArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXPrizeOwnerListModel.class json:JSON[@"data"]]];
          
                        if(kHJMDHeaderheight + ([self.prizeOwnerArray count])*(AnnualItemListCellLabelTopSpace + AnnualItemListCellLabelFontSize + AnnualItemListCellLabelTopSpace) <= (Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace)){
                            self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, kHJMDHeaderheight + ([self.prizeOwnerArray count])*(AnnualItemListCellLabelTopSpace + AnnualItemListCellLabelFontSize + AnnualItemListCellLabelTopSpace));
                        }else{
                            self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, (Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace));
                        }
                    
                        UIView * tableHeaderView = [[UIView alloc] init];
                        tableHeaderView.frame = CGRectMake(0, 0, Screen_Width - 2*kTableViewLeftSpace, kHJMDHeaderheight);
                        tableHeaderView.backgroundColor = [UIColor clearColor];
                        
                        UILabel * titleLabel = [[UILabel alloc] init];
                        titleLabel.frame = CGRectMake(0, kTableViewJMLBHeaderLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderLabelFontSize);
                        titleLabel.font = [UIFont systemFontOfSize:kTableViewJMLBHeaderLabelFontSize];
                        titleLabel.backgroundColor = [UIColor clearColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.textColor = kLabelTextColor;
                        titleLabel.text = @"获奖名单";
                        [tableHeaderView addSubview:titleLabel];
                        
                        UILabel * backBorderLabel = [[UILabel alloc] init];
                        backBorderLabel.layer.borderWidth = 0.5;
                        backBorderLabel.layer.borderColor = [UIColor whiteColor].CGColor;
                        backBorderLabel.layer.cornerRadius = 4.0;
                        backBorderLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace, kPrizeSelectLabelWidth + 2*kPrizeSelectLabelBorderMargin, kPrizeSelectLabelFontSize + 2*kPrizeSelectLabelBorderMargin);
                        backBorderLabel.backgroundColor = [UIColor clearColor];
                        [tableHeaderView addSubview:backBorderLabel];
                        
                        CXEditLabel *prizeSelectLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(AnnualItemListCellLabelLeftSpace + kPrizeSelectLabelBorderMargin, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace + kPrizeSelectLabelBorderMargin, kPrizeSelectLabelWidth, kPrizeSelectLabelFontSize)];
                        prizeSelectLabel.font = [UIFont systemFontOfSize:kPrizeSelectLabelFontSize];
                        prizeSelectLabel.textColor = kLabelTextColor;
                        prizeSelectLabel.inputType = CXEditLabelInputTypeCustomPicker;
                        prizeSelectLabel.title = @"";
                        prizeSelectLabel.content = self.selectedPrizeModel?self.selectedPrizeModel.name:self.prizeArray[0].name;
                        NSMutableArray * pickerTextArray = @[].mutableCopy;
                        NSMutableArray * pickerValueArray = @[].mutableCopy;
                        for(CXIDGPrizeModel * prizeModel in self.prizeArray){
                            [pickerTextArray addObject:prizeModel.name];
                            [pickerValueArray addObject:prizeModel.eid];
                        }
                        prizeSelectLabel.selectViewTitle = @"奖项";
                        prizeSelectLabel.pickerTextArray = pickerTextArray;
                        prizeSelectLabel.pickerValueArray = pickerValueArray;
                        prizeSelectLabel.selectedPickerData = @{CXEditLabelCustomPickerTextKey: self.selectedPrizeModel?self.selectedPrizeModel.name:self.prizeArray[0].name, CXEditLabelCustomPickerValueKey: self.selectedPrizeModel?self.selectedPrizeModel.eid:self.prizeArray[0].eid};
                        prizeSelectLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
                            CXIDGPrizeModel * selectedPrizeModel = [[CXIDGPrizeModel alloc] init];
                            selectedPrizeModel.eid = editLabel.selectedPickerData[CXEditLabelCustomPickerValueKey];
                            selectedPrizeModel.name = editLabel.selectedPickerData[CXEditLabelCustomPickerTextKey];
                            self.selectedPrizeModel = selectedPrizeModel;
                            [self zjxxBtnClick];
                        };
                        prizeSelectLabel.showWhiteDropdown = YES;
                        [tableHeaderView addSubview:prizeSelectLabel];
                        
                        UILabel * hjrsLabel = [[UILabel alloc] init];
                        hjrsLabel.frame = CGRectMake(Screen_Width - 2*kTableViewLeftSpace - AnnualItemListCellLabelLeftSpace - 200, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace + kPrizeSelectLabelBorderMargin, 200, kPrizeSelectLabelFontSize);
                        hjrsLabel.font = [UIFont systemFontOfSize:kHjrsLabelLabelFontSize];
                        hjrsLabel.backgroundColor = [UIColor clearColor];
                        hjrsLabel.textAlignment = NSTextAlignmentRight;
                        hjrsLabel.textColor = kLabelTextColor;
                        hjrsLabel.text = [NSString stringWithFormat:@"获奖人数：%zd",[self.prizeOwnerArray count]];
                        [tableHeaderView addSubview:hjrsLabel];
                        
                        UIView * lineView = [[UIView alloc] init];
                        lineView.frame = CGRectMake(AnnualItemListCellLabelLeftSpace, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelFontSize + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelLineSpace, Screen_Width - 2*kTableViewLeftSpace - 2*AnnualItemListCellLabelLeftSpace, kTableViewJMLBHeaderLineHeight);
                        lineView.backgroundColor = [UIColor whiteColor];
                        [tableHeaderView addSubview:lineView];
                        
                        UILabel * iconLabel = [[UILabel alloc] init];
                        iconLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace + kIconLeftSpace, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelFontSize + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelLineSpace + kTableViewJMLBHeaderLineHeight + kPrizeSelectLabelLineSpace, kIconWidth, kPrizeSelectIconLabelFontSize);
                        iconLabel.font = [UIFont systemFontOfSize:kPrizeSelectIconLabelFontSize];
                        iconLabel.backgroundColor = [UIColor clearColor];
                        iconLabel.textAlignment = NSTextAlignmentLeft;
                        iconLabel.textColor = kLabelTextColor;
                        iconLabel.text = @"头像";
                        [tableHeaderView addSubview:iconLabel];
                        
                        UILabel * nameLabel = [[UILabel alloc] init];
                        nameLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace + kIconLeftSpace + kIconWidth, kTableViewJMLBHeaderLabelTopSpace + kTableViewJMLBHeaderLabelFontSize + kTableViewJMLBHeaderLabelTopSpace + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelFontSize + kPrizeSelectLabelBorderMargin + kPrizeSelectLabelLineSpace + kTableViewJMLBHeaderLineHeight + kPrizeSelectLabelLineSpace, kNameWidth, kPrizeSelectIconLabelFontSize);
                        nameLabel.font = [UIFont systemFontOfSize:kPrizeSelectIconLabelFontSize];
                        nameLabel.backgroundColor = [UIColor clearColor];
                        nameLabel.textAlignment = NSTextAlignmentLeft;
                        nameLabel.textColor = kLabelTextColor;
                        nameLabel.text = @"姓名";
                        [tableHeaderView addSubview:nameLabel];
                        
                        self.tpView.hidden = YES;
                        self.tableView.allowsSelection = YES;
                        [self.tableView setTableHeaderView:tableHeaderView];
                        [self.tableView reloadData];
                        
                        [_moreBtn removeFromSuperview];
                    } else {
                        CXAlert(JSON[@"msg"]);
                    }
                }failure:^(NSError *error) {
                    CXAlert(KNetworkFailRemind);
                }];
                
            }else{
                TTAlert(@"暂无奖项！");
            }
            
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)jmdBtnClick
{
    self.type = JMXXType;;
    [self hideClickView];
    self.tpView.hidden = YES;
    [self loadAnnualItemListData];
}

- (void)nhxxBtnClick
{
    [self hideClickView];
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail/sign", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.currentAnnualMeetingModel = [CXIDGCurrentAnnualMeetingModel yy_modelWithDictionary:JSON[@"data"][@"detail"]];
            self.signListUserModelArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXSignListUserModel.class json:JSON[@"data"][@"signList"]]];
            self.currentAnnualMeetingModel.isVote = @([JSON[@"data"][@"isVote"] integerValue]);
            self.currentAnnualMeetingModel.startVote = @([JSON[@"data"][@"startVote"] integerValue]);
            
            self.tableView.frame = CGRectMake(kTableViewLeftSpace, navHigh + kTableViewLeftSpace, Screen_Width - 2*kTableViewLeftSpace, Screen_Height - navHigh - kToolViewHeight - 2*kTableViewLeftSpace);
            
            UIView * tableHeaderView = [[UIView alloc] init];
            tableHeaderView.frame = CGRectMake(0, 0, Screen_Width - 2*kTableViewLeftSpace, kTableViewJMLBHeaderHeight);
            tableHeaderView.backgroundColor = [UIColor clearColor];
            
            /// 大行高
            CGFloat viewHeight = 45.f;
            /// 小行高
            CGFloat smallViewHeight = 30.f;

            UILabel * titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(-kTableViewLeftSpace, 0, Screen_Width, viewHeight);
            titleLabel.font = [UIFont systemFontOfSize:kNHTitleLabelFontSize];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            titleLabel.text = @"2019年IDG资本新年晚会";
            [tableHeaderView addSubview:titleLabel];
            
            UIImageView * firstImageView = [[UIImageView alloc] init];
            firstImageView.frame = CGRectMake((Screen_Width - kNHLargeImageWidth)/2 - kTableViewLeftSpace, CGRectGetMaxY(titleLabel.frame) + kNHLargeGoldBackSpace, kNHLargeImageWidth, kNHLargeImageHeight);
            firstImageView.image = [UIImage imageNamed:@"largeGlodLightImage"];
            firstImageView.highlightedImage = [UIImage imageNamed:@"largeGlodLightImage"];
            [tableHeaderView addSubview:firstImageView];
            
            UILabel * timeTitleLabel = [[UILabel alloc] init];
            timeTitleLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(titleLabel.frame) + kNHLargeSpace, Screen_Width, smallViewHeight);
            timeTitleLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            timeTitleLabel.textAlignment = NSTextAlignmentCenter;
            timeTitleLabel.backgroundColor = [UIColor clearColor];
            timeTitleLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            timeTitleLabel.text = @"时间:";
            [tableHeaderView addSubview:timeTitleLabel];
            
            UILabel * timeLabel = [[UILabel alloc] init];
            timeLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(timeTitleLabel.frame), Screen_Width, smallViewHeight);
            timeLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            timeLabel.text = @"2019年1月16日 (周三) 18:30";
            [tableHeaderView addSubview:timeLabel];
            
            UIImageView * secondImageView = [[UIImageView alloc] init];
            secondImageView.frame = CGRectMake((Screen_Width - kNHSmallImageWidth)/2 - kTableViewLeftSpace - kNHSmallGoldBackLeftOffset, CGRectGetMaxY(timeLabel.frame) + kNHGoldBackSpace, kNHSmallImageWidth, kNHSmallImageHeight);
            secondImageView.image = [UIImage imageNamed:@"smallGoldBackImage"];
            secondImageView.highlightedImage = [UIImage imageNamed:@"smallGoldBackImage"];
            [tableHeaderView addSubview:secondImageView];
            
            UILabel * locationTitleLabel = [[UILabel alloc] init];
            locationTitleLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(timeLabel.frame) + kNHSmallSpace, Screen_Width, smallViewHeight);
            locationTitleLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            locationTitleLabel.textAlignment = NSTextAlignmentCenter;
            locationTitleLabel.backgroundColor = [UIColor clearColor];
            locationTitleLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            locationTitleLabel.text = @"地点:";
            [tableHeaderView addSubview:locationTitleLabel];
            
            UILabel * locationLabel = [[UILabel alloc] init];
            locationLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(locationTitleLabel.frame), Screen_Width, smallViewHeight);
            locationLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            locationLabel.textAlignment = NSTextAlignmentCenter;
            locationLabel.backgroundColor = [UIColor clearColor];
            locationLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            locationLabel.text = @"北京市朝阳区呼家楼京广中心";
            [tableHeaderView addSubview:locationLabel];
            
            UILabel * locationSecondLabel = [[UILabel alloc] init];
            locationSecondLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(locationLabel.frame), Screen_Width, smallViewHeight);
            locationSecondLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            locationSecondLabel.textAlignment = NSTextAlignmentCenter;
            locationSecondLabel.backgroundColor = [UIColor clearColor];
            locationSecondLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            locationSecondLabel.text = @"北京瑰丽酒店二层大宴会厅";
            [tableHeaderView addSubview:locationSecondLabel];
            
            UIImageView * thirdImageView = [[UIImageView alloc] init];
            thirdImageView.frame = CGRectMake((Screen_Width - kNHSmallImageWidth)/2 - kTableViewLeftSpace - kNHSmallGoldBackLeftOffset, CGRectGetMaxY(locationSecondLabel.frame) + kNHGoldBackSpace, kNHSmallImageWidth, kNHSmallImageHeight);
            thirdImageView.image = [UIImage imageNamed:@"smallGoldBackImage"];
            thirdImageView.highlightedImage = [UIImage imageNamed:@"smallGoldBackImage"];
            [tableHeaderView addSubview:thirdImageView];
            
            UILabel * hdlcTitleLabel = [[UILabel alloc] init];
            hdlcTitleLabel.frame = CGRectMake(-kTableViewLeftSpace, CGRectGetMaxY(locationSecondLabel.frame) + kNHSmallSpace, Screen_Width, smallViewHeight);
            hdlcTitleLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            hdlcTitleLabel.textAlignment = NSTextAlignmentCenter;
            hdlcTitleLabel.backgroundColor = [UIColor clearColor];
            hdlcTitleLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            hdlcTitleLabel.text = @"流程:";
            [tableHeaderView addSubview:hdlcTitleLabel];
            
            UILabel * hdlcLabel = [[UILabel alloc] init];
            hdlcLabel.frame = CGRectMake(0, CGRectGetMaxY(hdlcTitleLabel.frame), Screen_Width, smallViewHeight);
            hdlcLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            hdlcLabel.textAlignment = NSTextAlignmentLeft;
            hdlcLabel.backgroundColor = [UIColor clearColor];
            hdlcLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            hdlcLabel.text = @"     18:30-19:30    冷餐会";
            [tableHeaderView addSubview:hdlcLabel];
            
            UILabel * hdlcSecondLabel = [[UILabel alloc] init];
            hdlcSecondLabel.frame = CGRectMake(0, CGRectGetMaxY(hdlcLabel.frame), Screen_Width, smallViewHeight);
            hdlcSecondLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            hdlcSecondLabel.textAlignment = NSTextAlignmentLeft;
            hdlcSecondLabel.backgroundColor = [UIColor clearColor];
            hdlcSecondLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            hdlcSecondLabel.text = @"     19:30-20:50    IDG员工talent show";
            [tableHeaderView addSubview:hdlcSecondLabel];
            
            UILabel * hdlcThirdLabel = [[UILabel alloc] init];
            hdlcThirdLabel.frame = CGRectMake(0, CGRectGetMaxY(hdlcSecondLabel.frame), Screen_Width, smallViewHeight);
            hdlcThirdLabel.font = [UIFont systemFontOfSize:kNHContentLabelFontSize];
            hdlcThirdLabel.textAlignment = NSTextAlignmentLeft;
            hdlcThirdLabel.backgroundColor = [UIColor clearColor];
            hdlcThirdLabel.textColor = RGBACOLOR(251.0, 248.0, 197.0, 1.0);
            hdlcThirdLabel.text = @"     20:50-21:30    iStar唱将大比拼";
            [tableHeaderView addSubview:hdlcThirdLabel];
            
            self.tableView.allowsSelection = YES;
            [self.tableView setTableHeaderView:tableHeaderView];
            
            self.tpView.hidden = YES;
            
            self.type = NHXXType;
            
            [self.tableView reloadData];
            
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)tpBtnClick
{
    if(self.type == JMTPType){
        NSString *url = [NSString stringWithFormat:@"%@annual/item/vote/items/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableString *content = [[NSMutableString alloc] init];
        if (self.selectedDataSource.count == 1) {
            [content appendString:self.selectedDataSource.firstObject.eid.stringValue];
            [params setValue:content forKey:@"itemIds"];
        } else if (self.selectedDataSource.count > 1) {
            for(CXIDGCurrentAnnualItemListModel * model in self.selectedDataSource){
                [content appendString:[NSString stringWithFormat:@",%@",model.eid.stringValue]];
            }
            [params setValue:[content substringFromIndex:1] forKey:@"itemIds"];
        }else if(self.selectedDataSource.count <= 0){
            TTAlert(@"请您先选择节目才能投票！");
            return;
        }
        [params setValue:self.currentAnnualMeetingModel.eid forKey:@"meetId"];
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                TTAlert(@"投票成功");
                self.currentAnnualMeetingModel.startVote = @(1);
                self.currentAnnualMeetingModel.isVote = @(1);
                if(self.tpView){
                    [self.tpView removeFromSuperview];
                    self.tpView = nil;
                }
                self.tpView.hidden = NO;
                self.tableView.allowsSelection = NO;
                [self.tableView reloadData];
            }
            else if ([JSON[@"status"] intValue] == 400) {
                [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
            }else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }else if(self.type == IStarCJTPXXType){
        NSString *url = [NSString stringWithFormat:@"%@annual/item/iStar/vote/items/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableString *content = [[NSMutableString alloc] init];
        if (self.selectedDataSource.count == 1) {
            [content appendString:self.selectedDataSource.firstObject.eid.stringValue];
            [params setValue:content forKey:@"itemIds"];
        } else if (self.selectedDataSource.count > 1) {
            for(CXIDGCurrentAnnualItemListModel * model in self.selectedDataSource){
                [content appendString:[NSString stringWithFormat:@",%@",model.eid.stringValue]];
            }
            [params setValue:[content substringFromIndex:1] forKey:@"itemIds"];
        }else if(self.selectedDataSource.count <= 0){
            TTAlert(@"请您先选择节目才能投票！");
            return;
        }
        [params setValue:self.currentAnnualMeetingModel.eid forKey:@"meetId"];
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                TTAlert(@"投票成功");
                self.currentAnnualMeetingModel.startVote = @(1);
                self.currentAnnualMeetingModel.isVote = @(1);
                if(self.tpView){
                    [self.tpView removeFromSuperview];
                    self.tpView = nil;
                }
                self.tpView.hidden = NO;
                self.tableView.allowsSelection = NO;
                [self.tableView reloadData];
            }
            else if ([JSON[@"status"] intValue] == 400) {
                [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
            }else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }
}

- (void)moreBtnClick{
    CXAnnualLuckyQDUserListViewController *vc = [[CXAnnualLuckyQDUserListViewController alloc] init];
    NSMutableArray<SDCompanyUserModel *> *users = @[].mutableCopy;
    [self.signListUserModelArray enumerateObjectsUsingBlock:^(CXSignListUserModel * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        SDCompanyUserModel *u = [[SDCompanyUserModel alloc] init];
        u = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:user.imAccount];
        [users addObject:u];
    }];
    vc.users = users;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setToolViewSubviewHidden
{
    self.xcBtn.hidden = self.showKeyBoardBtn.selected;
    self.secondLineView.hidden = self.showKeyBoardBtn.selected;
    self.hdBtn.hidden = self.showKeyBoardBtn.selected;
    self.thirdLineView.hidden = self.showKeyBoardBtn.selected;
    self.nhBtn.hidden = self.showKeyBoardBtn.selected;
    self.textView.hidden = !self.showKeyBoardBtn.selected;
    self.sendBtn.hidden = !self.showKeyBoardBtn.selected;
    if(!self.showKeyBoardBtn.selected){
        [self collapseAll];
    }
}

- (void)hideClickView
{
    self.xcClickView.hidden = YES;
    self.hdClickView.hidden = YES;
    self.nhClickView.hidden = YES;
    [self.selectedDataSource removeAllObjects];
}

#pragma mark - 发送文本
- (void)sendBtnClick
{
    if(!self.textView.text || (self.textView.text && [self.textView.text length] <= 0)){
        return;
    }else{
        [self sendTextMessage];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendTextMessage];
        return NO;
    }
    return YES;
}

#pragma mark - sendMessages
// 发送文本消息
-(void)sendTextMessage{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length <= 0) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/barrage/%zd", urlPrefix,[self.currentAnnualMeetingModel.eid integerValue]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.currentAnnualMeetingModel.eid forKey:@"meetId"];
    [params setValue:text forKey:@"msg"];
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.textView.text = nil;
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == JMXXType || self.type == JMTPType || self.type == ZJXXType || self.type == IStarCJTPXXType){
        return AnnualItemListCellLabelTopSpace + AnnualItemListCellLabelFontSize + AnnualItemListCellLabelTopSpace;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.type == JMXXType || self.type == JMTPType || self.type == IStarCJTPXXType){
        return [self.dataSource count];
    }else if(self.type == ZJXXType){
        return [self.prizeOwnerArray count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.type == JMXXType){
        static NSString * CXAnnualItemListTableViewCellName = @"CXAnnualItemListTableViewCell";
        CXAnnualItemListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CXAnnualItemListTableViewCellName];
        if(!cell){
            cell = [[CXAnnualItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CXAnnualItemListTableViewCellName];
        }
        CXIDGCurrentAnnualItemListModel * model = [self.dataSource objectAtIndex:indexPath.row];
        [cell setCXIDGCurrentAnnualItemListModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(self.type == JMTPType){
        static NSString * CXAnnualTPListTableViewCellName = @"CXAnnualTPListTableViewCell";
        CXAnnualTPListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CXAnnualTPListTableViewCellName];
        if(!cell){
            cell = [[CXAnnualTPListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CXAnnualTPListTableViewCellName];
        }
        CXIDGCurrentAnnualItemListModel * indexModel = self.dataSource[indexPath.row];
        BOOL isIn = NO;
        if(self.selectedDataSource && [self.selectedDataSource count] > 0){
            for(CXIDGCurrentAnnualItemListModel * listModel in self.selectedDataSource.copy){
                if([indexModel.eid integerValue] == [listModel.eid integerValue]){
                    isIn = YES;
                    break;
                }
            }
        }
        CXIDGCurrentAnnualItemListModel * model = [self.dataSource objectAtIndex:indexPath.row];
        [cell setCXIDGCurrentAnnualItemListModel:model AndSelected:isIn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(self.type == ZJXXType){
        static NSString * CXAnnualHJListTableViewCellName = @"CXAnnualHJListTableViewCell";
        CXAnnualHJListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CXAnnualHJListTableViewCellName];
        if(!cell){
            cell = [[CXAnnualHJListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CXAnnualHJListTableViewCellName];
        }
        CXPrizeOwnerListModel * model = [self.prizeOwnerArray objectAtIndex:indexPath.row];
        [cell setCXPrizeOwnerListModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(self.type == IStarCJTPXXType){
        static NSString * CXAnnualTPListTableViewCellName = @"CXAnnualTPListTableViewCell";
        CXAnnualTPListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CXAnnualTPListTableViewCellName];
        if(!cell){
            cell = [[CXAnnualTPListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CXAnnualTPListTableViewCellName];
        }
        CXIDGCurrentAnnualItemListModel * indexModel = self.dataSource[indexPath.row];
        BOOL isIn = NO;
        if(self.selectedDataSource && [self.selectedDataSource count] > 0){
            for(CXIDGCurrentAnnualItemListModel * listModel in self.selectedDataSource.copy){
                if([indexModel.eid integerValue] == [listModel.eid integerValue]){
                    isIn = YES;
                    break;
                }
            }
        }
        CXIDGCurrentAnnualItemListModel * model = [self.dataSource objectAtIndex:indexPath.row];
        [cell setCXIDGCurrentAnnualItemListModel:model AndSelected:isIn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.type == JMTPType){
        CXIDGCurrentAnnualItemListModel * indexModel = self.dataSource[indexPath.row];
        BOOL isIn = NO;
        if(self.selectedDataSource && [self.selectedDataSource count] > 0){
            for(CXIDGCurrentAnnualItemListModel * listModel in self.selectedDataSource.copy){
                if([indexModel.eid integerValue] == [listModel.eid integerValue]){
                    [self.selectedDataSource removeObject:listModel];
                    isIn = YES;
                    break;
                }
            }
        }
        if(!isIn){
            if([self.selectedDataSource count] >= 3){
                TTAlert(@"最多只能给三个节目投票!");
                return;
            }
            [self.selectedDataSource addObject:indexModel];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if(self.type == IStarCJTPXXType){
        CXIDGCurrentAnnualItemListModel * indexModel = self.dataSource[indexPath.row];
        BOOL isIn = NO;
        if(self.selectedDataSource && [self.selectedDataSource count] > 0){
            for(CXIDGCurrentAnnualItemListModel * listModel in self.selectedDataSource.copy){
                if([indexModel.eid integerValue] == [listModel.eid integerValue]){
                    [self.selectedDataSource removeObject:listModel];
                    isIn = YES;
                    break;
                }
            }
        }
        if(!isIn){
            if([self.selectedDataSource count] >= 2){
                TTAlert(@"最多只能给二个节目投票!");
                return;
            }
            [self.selectedDataSource addObject:indexModel];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
