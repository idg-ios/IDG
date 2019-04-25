//
//  CXIDGAnnualLuckyDrawDetailInfoViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGAnnualLuckyDrawDetailInfoViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "UIView+CXCategory.h"
#import "CXSignListUserModel.h"
#import "CXAnnualLuckyQDUserListViewController.h"

@interface CXIDGAnnualLuckyDrawDetailInfoViewController ()

#define kNHXXTextColor RGBACOLOR(251.0, 251.0, 222.0, 1.0)
#define kNHXXTextFontSize 16.0

/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
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

@implementation CXIDGAnnualLuckyDrawDetailInfoViewController

#pragma mark - get & set

#define kTextColor [UIColor blackColor]

#define kMoreBtnWidth 50.0

- (NSMutableArray<CXSignListUserModel *> *)signListUserModelArray{
    if(!_signListUserModelArray){
        _signListUserModelArray = @[].mutableCopy;
    }
    return _signListUserModelArray;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    UIImageView * backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"nhxxbj"];
    backImageView.highlightedImage = [UIImage imageNamed:@"nhxxbj"];
    backImageView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    [self.view addSubview:backImageView];
    
    self.scrollContentView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    
    [self loadCurrentMeeting];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"年会信息"];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpScrollView {
    /// 左边距
    CGFloat leftMargin = 5.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineWidth = Screen_Width;
    
    //年会主题
    _nhztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, 0.f, Screen_Width - leftMargin, viewHeight)];
    _nhztLabel.title = [NSString stringWithFormat:@"◆ 年会主题："];
    _nhztLabel.content = self.currentAnnualMeetingModel.title?self.currentAnnualMeetingModel.title:@"";
    _nhztLabel.allowEditing = NO;
    _nhztLabel.textColor = kNHXXTextColor;
    _nhztLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _nhztLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_nhztLabel];
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _nhztLabel.bottom, lineWidth, lineHeight);
    
    //年份
    _nfLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _nfLabel.title = @"◆ 年　　份：";
    _nfLabel.content = self.currentAnnualMeetingModel.year?self.currentAnnualMeetingModel.year:@"";
    _nfLabel.textColor = kNHXXTextColor;
    _nfLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _nfLabel.allowEditing = NO;
    _nfLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_nfLabel];
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _nfLabel.bottom, lineWidth, lineHeight);
    
    //年会时间
    _nhsjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _nhsjLabel.title = @"◆ 年会时间：";
    _nhsjLabel.content = self.currentAnnualMeetingModel.meetTime?self.currentAnnualMeetingModel.meetTime:@"";
    _nhsjLabel.textColor = kNHXXTextColor;
    _nhsjLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _nhsjLabel.allowEditing = NO;
    _nhsjLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_nhsjLabel];
    
    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _nhsjLabel.bottom, lineWidth, lineHeight);
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(Screen_Width - leftMargin - kMoreBtnWidth, line_3.bottom + (viewHeight - (kNHXXTextFontSize + 4.0))/2, kMoreBtnWidth, (kNHXXTextFontSize + 4.0));
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn setTitle:@"更多" forState:UIControlStateHighlighted];
    [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _moreBtn.layer.cornerRadius = (kNHXXTextFontSize + 4.0)/2.0;
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize - 2.0];
    _moreBtn.enabled = YES;
    _moreBtn.backgroundColor = RGBACOLOR(220.0, 167.0, 84.0, 1.0);
    [self.scrollContentView addSubview:_moreBtn];
    
    //签到人员
    _qdryLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - 3*leftMargin - kMoreBtnWidth, viewHeight)];
    _qdryLabel.title = @"◆ 签到人员：";
    _qdryLabel.content = @" ";
    NSMutableString *content = [[NSMutableString alloc] init];
    if (self.signListUserModelArray.count == 1) {
        [content appendString:self.signListUserModelArray.firstObject.name];
        self.qdryLabel.content = content;
    } else if (self.signListUserModelArray.count > 1) {
        for(CXSignListUserModel * user in self.signListUserModelArray){
            [content appendString:[NSString stringWithFormat:@"、%@",user.name]];
        }
        self.qdryLabel.content = [content substringFromIndex:1];
    }
    _qdryLabel.textColor = kNHXXTextColor;
    _qdryLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _qdryLabel.allowEditing = NO;
    _qdryLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_qdryLabel];
    
    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = CGRectMake(0.f, _qdryLabel.bottom, lineWidth, lineHeight);
    
    _rcapLabel = [[UILabel alloc] init];
    _rcapLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _rcapLabel.textColor = kNHXXTextColor;
    _rcapLabel.backgroundColor = [UIColor clearColor];
    _rcapLabel.textAlignment = NSTextAlignmentLeft;
    _rcapLabel.text = @"◆ 日程安排：";
    [_rcapLabel sizeToFit];
    _rcapLabel.frame = CGRectMake(leftMargin, line_4.bottom + (viewHeight - kNHXXTextFontSize)/2, _rcapLabel.size.width, kNHXXTextFontSize);
    [self.scrollContentView addSubview:_rcapLabel];
    
    _rcapContentLabel = [[UILabel alloc] init];
    _rcapContentLabel.text = self.currentAnnualMeetingModel.remark?self.currentAnnualMeetingModel.remark:@" ";
    _rcapContentLabel.font = [UIFont systemFontOfSize:kNHXXTextFontSize];
    _rcapContentLabel.textColor = kNHXXTextColor;
    _rcapContentLabel.numberOfLines = 0;
    _rcapContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _rcapContentLabel.backgroundColor = [UIColor clearColor];
    _rcapContentLabel.textAlignment = NSTextAlignmentLeft;
    CGSize rcapContentLabelSize = [_rcapContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin - _rcapLabel.size.width, MAXFLOAT)];
    _rcapContentLabel.frame = CGRectMake(leftMargin + _rcapLabel.size.width + leftMargin, line_4.bottom + (viewHeight - kNHXXTextFontSize)/2, Screen_Width - 2*leftMargin - _rcapLabel.size.width, rcapContentLabelSize.height);
    [self.scrollContentView addSubview:_rcapContentLabel];
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _rcapContentLabel.bottom + 5.0);
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    return line;
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

- (void)loadCurrentMeeting {
    CXWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail/sign", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
        CXStrongSelf(self)
        if ([JSON[@"status"] intValue] == 200) {
            self.currentAnnualMeetingModel = [CXIDGCurrentAnnualMeetingModel yy_modelWithDictionary:JSON[@"data"][@"detail"]];
            self.signListUserModelArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXSignListUserModel.class json:JSON[@"data"][@"signList"]]];
            [self setUpScrollView];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

@end
