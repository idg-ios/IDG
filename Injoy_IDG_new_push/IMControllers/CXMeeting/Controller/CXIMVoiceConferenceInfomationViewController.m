//
//  CXIMVoiceConferenceInfomationViewController.m
//  SDMarketingManagement
//
//  Created by Rao on 16/4/14.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXGroupMembersCollectionView.h"
#import "CXIMVoiceConferenceInfomationViewController.h"
#import "Masonry.h"
#import "SDDataBaseHelper.h"
#import "SDIMAllGroupChatMembersViewController.h"

@interface CXIMVoiceConferenceInfomationViewController ()
@property (strong, nonatomic) SDRootTopView* rootTopView;
@property (strong, nonatomic) CXGroupInfo* currentGroupDetail;
/// 滚动视图
@property (strong, nonatomic) UIScrollView* scrollView;
/// 设置导航条
- (void)setUpNavBar;
- (void)setUpSubview;
/// 设置滚动视图子视图
- (void)setUpScrollViewSubviews;
@end

@implementation CXIMVoiceConferenceInfomationViewController

#pragma mark - get set

- (UIScrollView*)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 66)];
    }
    return _scrollView;
}

#pragma mark - view lifecycle

- (instancetype)initWithGroupDetailInfomation:(CXGroupInfo*)groupDetailInfomation
{
    if (self = [super init]) {
        self.currentGroupDetail = groupDetailInfomation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpSubview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /// 滚动视图.
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), contentHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - function

/// 设置导航条
- (void)setUpNavBar;
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"会议信息"];

    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpSubview;
{
    [self.view addSubview:self.scrollView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.rootTopView);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.rootTopView.mas_bottom);
    }];

    /// 设置滚动视图子视图
    [self setUpScrollViewSubviews];
}

CGFloat contentHeight = 0.f;

/// 设置滚动视图子视图
- (void)setUpScrollViewSubviews;
{
    /// 会议成员
    UILabel* meetingMemberLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:meetingMemberLabel];
    meetingMemberLabel.textColor = [UIColor lightGrayColor];
    [meetingMemberLabel setText:@"    会议成员"];
    [meetingMemberLabel setTextAlignment:NSTextAlignmentLeft];
    meetingMemberLabel.backgroundColor = kColorWithRGB(235, 236, 241);

    CGFloat meetingMemberLabelHeight = 40.f;

    [meetingMemberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(0.f);
        make.height.mas_equalTo(meetingMemberLabelHeight);
    }];

    /// 高度增加
    contentHeight += meetingMemberLabelHeight;

    /// 成员视图

    NSMutableArray* allMembersArr = [NSMutableArray arrayWithArray:self.currentGroupDetail.members];
    CXGroupMember* ownerModel = [[CXGroupMember alloc] init];
    ownerModel.userId = self.currentGroupDetail.owner;
    [allMembersArr insertObject:ownerModel atIndex:0];

    int totalMembers = (int)[allMembersArr count];
    if (totalMembers > 12) {
        totalMembers = 12;
    }
    int row = 0;
    float column = 4.f; // 4列
    row = (int)ceil(totalMembers / column);
    // 80为头像高度,5为空格
    CGFloat nineViewHeight = row * 80 + (row + 1) * 10;
    CXGroupMembersCollectionView* nineView = [[CXGroupMembersCollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.bounds), nineViewHeight) groupMembers:allMembersArr];
    nineView.navigationController_ = self.navigationController;
    [self.scrollView addSubview:nineView];
    nineView.backgroundColor = [UIColor clearColor];
    [nineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(nineViewHeight);
        make.top.mas_equalTo(meetingMemberLabel.mas_bottom);
    }];

    contentHeight += nineViewHeight;

    /// 分隔线高度
    CGFloat separateHeight = 1.f;

    /// 分隔线
    UILabel* separateLabel = [[UILabel alloc] init];
    separateLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:separateLabel];

    [separateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(separateHeight);
        make.top.equalTo(nineView.mas_bottom).offset(10);
    }];

    contentHeight += separateHeight;

    /// 文本高度
    CGFloat labelHeight = 50.f;

    /// 全部成员
    UIButton* allMembersLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:allMembersLabel];
    [allMembersLabel setTitle:[NSString stringWithFormat:@"    全部成员(%d)", (int)[allMembersArr count]] forState:UIControlStateNormal];
    [allMembersLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allMembersLabel.backgroundColor = [UIColor whiteColor];
    [allMembersLabel addTarget:self action:@selector(memberBtnEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    allMembersLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [allMembersLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(labelHeight);
        make.top.equalTo(separateLabel.mas_bottom);
    }];

    contentHeight += labelHeight;

    /// 分隔段落
    CGFloat separatedParagraphHeight = 20.f;
    UILabel* separatedParagraphLabel = [[UILabel alloc] init];
    separatedParagraphLabel.backgroundColor = kColorWithRGB(235, 236, 241);
    [self.scrollView addSubview:separatedParagraphLabel];

    [separatedParagraphLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(allMembersLabel.mas_bottom);
        make.height.mas_equalTo(separatedParagraphHeight);
    }];

    contentHeight += separatedParagraphHeight;

    /// 会议主题
    UILabel* conferenceThemeLabel = [[UILabel alloc] init];
    conferenceThemeLabel.backgroundColor = [UIColor whiteColor];
    conferenceThemeLabel.textColor = [UIColor blackColor];
    [self.scrollView addSubview:conferenceThemeLabel];
    conferenceThemeLabel.text = [NSString stringWithFormat:@"    会议主题:%@", [self.currentGroupDetail groupName]];
    [conferenceThemeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(labelHeight);
        make.top.equalTo(separatedParagraphLabel.mas_bottom);
    }];

    contentHeight += labelHeight;

    /// 分隔线
    UILabel* separateLabel_1 = [[UILabel alloc] init];
    separateLabel_1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:separateLabel_1];
    [separateLabel_1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(conferenceThemeLabel.mas_bottom);
        make.height.mas_equalTo(separateHeight);
    }];

    contentHeight += separateHeight;

    /// 会议主持
    UILabel* conferenceOwerLabel = [[UILabel alloc] init];
    conferenceOwerLabel.backgroundColor = [UIColor whiteColor];
    conferenceOwerLabel.textColor = [UIColor blackColor];
    SDCompanyUserModel* userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:self.currentGroupDetail.owner];
    conferenceOwerLabel.text = [NSString stringWithFormat:@"    会议主持:%@", userModel.realName];
    [self.scrollView addSubview:conferenceOwerLabel];

    [conferenceOwerLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(labelHeight);
        make.top.equalTo(separateLabel_1.mas_bottom);
    }];

    contentHeight += labelHeight;

    /// 分隔线
    UILabel* separateLabel_2 = [[UILabel alloc] init];
    separateLabel_2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:separateLabel_2];
    [separateLabel_2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(separateHeight);
        make.top.equalTo(conferenceOwerLabel.mas_bottom);
    }];

    contentHeight += separateHeight;

    /// 会议时间

    NSDateFormatter* dateFm = [[NSDateFormatter alloc] init];
    [dateFm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dt = [dateFm dateFromString:self.currentGroupDetail.createTime];
    NSString* timeVal = [dateFm stringFromDate:dt];

    UILabel* conferenceCreateTimeLabel = [[UILabel alloc] init];
    conferenceCreateTimeLabel.textColor = [UIColor blackColor];
    conferenceCreateTimeLabel.backgroundColor = [UIColor whiteColor];
    conferenceCreateTimeLabel.text = [NSString stringWithFormat:@"    会议时间:%@", [timeVal substringToIndex:[@"yyyy-MM-dd" length]] ?: @""];
    [self.scrollView addSubview:conferenceCreateTimeLabel];
    [conferenceCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(labelHeight);
        make.top.equalTo(separateLabel_2.mas_bottom);
    }];

    contentHeight += labelHeight;
}

- (void)memberBtnEvent:(UIButton*)sender
{
    SDIMAllGroupChatMembersViewController* groupAllMembersViewController = [[SDIMAllGroupChatMembersViewController alloc] init];
    groupAllMembersViewController.groupId = self.currentGroupDetail.groupId;
    groupAllMembersViewController.groupType = CXGroupTypeVoiceConference;
    groupAllMembersViewController.isSendCall = NO;
    [self.navigationController pushViewController:groupAllMembersViewController animated:YES];
}

@end
