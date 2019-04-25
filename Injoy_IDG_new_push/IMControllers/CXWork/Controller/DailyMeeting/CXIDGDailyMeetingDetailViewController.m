//
//  CXIDGDailyMeetingDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/6/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGDailyMeetingDetailViewController.h"
#import "CXEditLabel.h"
#import "CXERPAnnexView.h"
#import "Masonry.h"
#import "CXDailyMeetingDetailModel.h"
#import "HttpTool.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+YYAdd.h"
#import "NSDate+YYAdd.h"
#import "CXUserSelectController.h"
#import "CXIDGDailyMeetingDetailContactsViewController.h"
#import "SDIMPersonInfomationViewController.h"

@interface CXIDGDailyMeetingDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 头部视图 */
@property (nonatomic, strong) UIView *topView;
/** 参与人数label */
@property (nonatomic, strong) UILabel *memberCountLabel;
/** 查看参与人 */
@property (nonatomic, strong) UIButton *viewMemberButton;
/** 参与人集合视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 会议名称~会议地点的容器 */
@property (nonatomic, strong) UIView *meetInfoView;
/** 会议名称标题 */
@property (nonatomic, strong) UILabel *hymcLabel;
/** 会议名称内容 */
@property (nonatomic, strong) UILabel *hymcnrLabel;
/** 会议时间标题 */
@property (nonatomic, strong) UILabel *hysjLabel;
/** 会议时间内容 */
@property (nonatomic, strong) UILabel *hysjnrLabel;
/** 会议地点标题 */
@property (nonatomic, strong) UILabel *hyddLabel;
/** 会议地点内容 */
@property (nonatomic, strong) UILabel *hyddnrLabel;

/** 间隔View */
@property (nonatomic, strong) UIView *meetInfoBottomView;

/** 会议内容的容器 */
@property (nonatomic, strong) UIView *meetContentView;
/** 会议内容标题 */
@property (nonatomic, strong) UILabel *hynrLabel;
/** 会议内容内容 */
@property (nonatomic, strong) UILabel *hynrnrLabel;

/** 间隔View */
@property (nonatomic, strong) UIView *meetContentBottomView;

/** 详情数据 */
@property (nonatomic, strong) CXDailyMeetingDetailModel *detailModel;
/**
 附件
 */
@property (nonatomic ,strong) CXERPAnnexView *annexView;

@end

@implementation CXIDGDailyMeetingDetailViewController

#define kLeftMargin 15.0
#define kTopMargin 12.0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self getMeetingDetail];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"日常会议"];//日常会议
    [self.RootTopView setUpLeftBarItemGoBack];
    
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
        [self.scrollView addSubview:view];
        view;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.topView addSubview:collectionView];
        collectionView;
    });
    
    self.viewMemberButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看全部>>" forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(132, 142, 153, 1.0) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button addTarget:self action:@selector(onViewMemberButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        button;
    });
    
    self.memberCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = RGBACOLOR(132, 142, 153, 1.0);
        label.font = [UIFont systemFontOfSize:14.0];
        [self.topView addSubview:label];
        label;
    });
    
    self.meetInfoView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        view;
    });
    
    self.hymcLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = RGBACOLOR(132, 142, 153, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.hymcnrLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = RGBACOLOR(50, 50, 50, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.hysjLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = RGBACOLOR(132, 142, 153, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.hysjnrLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = RGBACOLOR(50, 50, 50, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.hyddLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = RGBACOLOR(132, 142, 153, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.hyddnrLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = RGBACOLOR(50, 50, 50, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.meetInfoBottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
        [self.scrollView addSubview:view];
        view;
    });
    
    self.meetContentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        view;
    });
    
    self.hynrLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = RGBACOLOR(132, 142, 153, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetContentView addSubview:label];
        label;
    });
    
    self.hynrnrLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = RGBACOLOR(31, 34, 40, 1.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.meetContentView addSubview:label];
        label;
    });
    //附件
//    self.annexView = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0, self.hynrnrLabel.bottom, Screen_Width, kLineHeight)];
    self.annexView = [[CXERPAnnexView alloc] initWithFrame:CGRectZero type:CXERPAnnexViewTypePictureVoiceAndAnnex];
    [self.scrollView addSubview:self.annexView];
    
    self.meetContentBottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
        [self.scrollView addSubview:view];
        view;
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, navHigh, GET_WIDTH(self.view), GET_HEIGHT(self.view) - navHigh);
    
    self.topView.frame = CGRectMake(0, 0, GET_WIDTH(self.scrollView), 135);
    
    [self.viewMemberButton sizeToFit];
    self.viewMemberButton.top = kTopMargin;
    self.viewMemberButton.right = GET_WIDTH(self.topView) - kLeftMargin;
    
    [self.memberCountLabel sizeToFit];
    self.memberCountLabel.centerY = GET_MID_Y(self.viewMemberButton);
    self.memberCountLabel.left = kLeftMargin;
    
    self.collectionView.frame = CGRectMake(0, GET_MAX_Y(self.memberCountLabel), GET_WIDTH(self.topView), 82);
    
    self.hymcLabel.frame = CGRectMake(kLeftMargin, 20.0, Screen_Width - 2*kLeftMargin, 14.0);
    CGSize hymcnrLabelSize = [self.hymcnrLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.view) - 2*kLeftMargin, MAXFLOAT)];
    self.hymcnrLabel.frame = CGRectMake(kLeftMargin, self.hymcLabel.bottom + 10.0, Screen_Width - 2*kLeftMargin, hymcnrLabelSize.height);
    
    self.hysjLabel.frame = CGRectMake(kLeftMargin, self.hymcnrLabel.bottom + 20.0, Screen_Width - 2*kLeftMargin, 14.0);
    CGSize hysjnrLabelSize = [self.hysjnrLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.view) - 2*kLeftMargin, MAXFLOAT)];
    self.hysjnrLabel.frame = CGRectMake(kLeftMargin, self.hysjLabel.bottom + 10.0, Screen_Width - 2*kLeftMargin, hysjnrLabelSize.height);
    
    self.hyddLabel.frame = CGRectMake(kLeftMargin, self.hysjnrLabel.bottom + 20.0, Screen_Width - 2*kLeftMargin, 14.0);
    CGSize hyddnrLabelSize = [self.hyddnrLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.view) - 2*kLeftMargin, MAXFLOAT)];
    self.hyddnrLabel.frame = CGRectMake(kLeftMargin, self.hyddLabel.bottom + 10.0, Screen_Width - 2*kLeftMargin, hyddnrLabelSize.height);
    
    self.meetInfoView.frame = CGRectMake(0, self.topView.bottom, Screen_Width, self.hyddnrLabel.bottom + 20.0);
    
    self.meetInfoBottomView.frame = CGRectMake(0, self.meetInfoView.bottom, Screen_Width, 10.0);
    
    self.hynrLabel.frame = CGRectMake(kLeftMargin, 20.0, Screen_Width - 2*kLeftMargin, 14.0);
    CGSize hynrnrLabelSize = [self.hynrnrLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.view) - 2*kLeftMargin, MAXFLOAT)];
    self.hynrnrLabel.frame = CGRectMake(kLeftMargin, self.hynrLabel.bottom + 10.0, Screen_Width - 2*kLeftMargin, hynrnrLabelSize.height);
    
    
    self.meetContentView.frame = CGRectMake(0, self.meetInfoBottomView.bottom, Screen_Width, self.hynrnrLabel.bottom + 20.0);
    
    self.meetContentBottomView.frame = CGRectMake(0, self.meetContentView.bottom, Screen_Width, 20.0);
    //附件
    self.annexView.frame = CGRectMake(0, self.meetContentBottomView.bottom, Screen_Width, kLineHeight);
    self.annexView.detailAnnexDataArray = [self.detailModel.annexList mutableCopy];
    self.scrollView.contentSize = CGSizeMake(Screen_Width, self.annexView.bottom);
}

#pragma mark - UICollectionView Protocol
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.detailModel.ccList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(48, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *member = self.detailModel.ccList[indexPath.row];
    static NSInteger const kImageViewTag = 1001;
    static NSInteger const kNameLabelTag = 1002;
    UIImageView *imageView = [cell.contentView viewWithTag:kImageViewTag];
    UILabel *nameLabel = [cell.contentView viewWithTag:kNameLabelTag];
    if (imageView == nil) {
        imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 0;
            imageView.layer.masksToBounds = YES;
            imageView.tag = kImageViewTag;
            [cell.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(cell.contentView);
                make.height.equalTo(imageView.mas_width);
            }];
            imageView;
        });
    }
    if (nameLabel == nil) {
        nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = kNameLabelTag;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_bottom).offset(8);
                make.left.right.equalTo(cell.contentView);
            }];
            label;
        });
    }
    NSString *imAccount = member[@"imAccount"];
    NSString *avatar = [imAccount isKindOfClass:[NSNull class]] ? @"" : [CXIMHelper getUserAvatarUrlByIMAccount:member[@"imAccount"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:Image(@"temp_user_head") options:EMSDWebImageRetryFailed];
    nameLabel.text = [member[@"userName"] isKindOfClass:NSNull.class] ? @"" : member[@"userName"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDCompanyUserModel* userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:[self.detailModel.ccList[indexPath.row][@"userId"] integerValue]];
    userModel.hxAccount = userModel.imAccount;
    SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
    pivc.imAccount = userModel.imAccount;
    pivc.canPopViewController = YES;
    [self.navigationController pushViewController:pivc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - Private
- (void)getMeetingDetail {
    HUD_SHOW(nil);
    NSString *url = [NSString stringWithFormat:@"/meet/detail/%zd.json", self.eid];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.detailModel = [CXDailyMeetingDetailModel yy_modelWithJSON:JSON[@"data"]];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setDetailModel:(CXDailyMeetingDetailModel *)detailModel {
    _detailModel = detailModel;
    [self.collectionView reloadData];
    self.memberCountLabel.text = [NSString stringWithFormat:@"共%zd人", detailModel.ccList.count];
    
    self.hymcLabel.text = @"会议名称：";
    self.hymcnrLabel.text = detailModel.meet.title && [detailModel.meet.title length] > 0?detailModel.meet.title:@" ";
    
    self.hysjLabel.text = @"会议时间：";
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *startDate = [[NSDate dateWithString:detailModel.meet.startTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"yyyy-MM-dd"];
    NSString *startTime = [[NSDate dateWithString:detailModel.meet.startTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"H:mm"];
    NSString *endDate = [[NSDate dateWithString:detailModel.meet.endTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"yyyy-MM-dd"];
    NSString *endTime = [[NSDate dateWithString:detailModel.meet.endTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"H:mm"];
    NSString * timeStr = @"";
    if ([startDate isEqualToString:endDate]) {
        timeStr = [NSString stringWithFormat:@"%@ %@ - %@",startDate,startTime,endTime];
    }else{
        timeStr = [NSString stringWithFormat:@"%@ %@ - %@ %@",startDate,startTime,endDate,endTime];
    }
    self.hysjnrLabel.text = timeStr && [timeStr length] > 0?timeStr:@" ";
    
    self.hyddLabel.text = @"会议地点：";
    self.hyddnrLabel.text = detailModel.meet.meetPlace && [detailModel.meet.meetPlace length] > 0?detailModel.meet.meetPlace:@" ";
    
    self.hynrLabel.text = @"会议内容：";
    self.hynrnrLabel.text = detailModel.meet.remark && [detailModel.meet.remark length] > 0?detailModel.meet.remark:@" ";
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (UIView *)createSeparatorLineInView:(UIView *)parentView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kColorWithRGB(230, 230, 230);
    view.height = 1;
    [parentView addSubview:view];
    return view;
}

#pragma mark - Event
- (void)onViewMemberButtonTap {
    CXIDGDailyMeetingDetailContactsViewController *vc = [[CXIDGDailyMeetingDetailContactsViewController alloc] init];
    NSMutableArray<CXUserModel *> *users = [NSMutableArray array];
    [self.detailModel.ccList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXUserModel *u = [[CXUserModel alloc] init];
        NSNumber *uid = obj[@"userId"];
        u.eid = uid.integerValue;
        u.name = obj[@"userName"];
        [users addObject:u];
    }];
     
    vc.contacts = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserModelArray:users];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
