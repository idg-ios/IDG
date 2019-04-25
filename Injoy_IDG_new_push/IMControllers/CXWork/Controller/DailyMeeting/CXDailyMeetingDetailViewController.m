//
//  CXDailyMeetingDetailViewController.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDailyMeetingDetailViewController.h"
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

@interface CXDailyMeetingDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 头部视图 */
@property (nonatomic, strong) UIView *topView;
/** 参与人集合视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 参与人数label */
@property (nonatomic, strong) UILabel *memberCountLabel;
/** 查看参与人 */
@property (nonatomic, strong) UIButton *viewMemberButton;
/** 标题的容器视图 */
@property (nonatomic, strong) UIView *titleView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 标签 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *tagLabels;

/** 会议地点~会议内容的容器 */
@property (nonatomic, strong) UIView *meetInfoView;
/** 会议地点 */
@property (nonatomic, strong) CXEditLabel *placeLabel;
/** 开始时间 */
@property (nonatomic, strong) CXEditLabel *ksLabel;
/** 结束时间 */
@property (nonatomic, strong) CXEditLabel *jsLabel;
/** 会议内容 */
@property (nonatomic, strong) CXEditLabel *contentLabel;
/** 附件 */
@property (nonatomic, strong) CXERPAnnexView *annexView;

/** 详情数据 */
@property (nonatomic, strong) CXDailyMeetingDetailModel *detailModel;

@end

@implementation CXDailyMeetingDetailViewController {
    UIView *_ksTimeLine;
    UIView *_jsTimeLine;
    UIView *_placeLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self getMeetingDetail];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"日常会议"];
    [self.RootTopView setUpLeftBarItemGoBack];
    
    self.view.backgroundColor = kColorWithRGB(239, 236, 243);
    
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.topView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(72, 165, 232);
        [self.scrollView addSubview:view];
        view;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
//        collectionView.scrollEnabled = NO;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.topView addSubview:collectionView];
        collectionView;
    });
    
    self.viewMemberButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(onViewMemberButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        button;
    });
    
    self.memberCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.topView addSubview:label];
        label;
    });
    
    self.titleView = ({
        UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
        view;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.titleView addSubview:label];
        label;
    });
    
    self.meetInfoView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        view;
    });
    
    self.ksLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        label.title = @"开始时间：";
        label.allowEditing = NO;
        label.numberOfLines = 0;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    _ksTimeLine = [self createSeparatorLineInView:self.meetInfoView];
    
    self.jsLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        label.title = @"结束时间：";
        label.allowEditing = NO;
        label.numberOfLines = 0;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    _jsTimeLine = [self createSeparatorLineInView:self.meetInfoView];
    
    self.placeLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        label.title = @"会议地点：";
        label.allowEditing = NO;
        label.numberOfLines = 0;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    _placeLine = [self createSeparatorLineInView:self.meetInfoView];
    
    self.contentLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        label.title = @"会议内容：";
        label.allowEditing = NO;
        label.numberOfLines = 0;
        [self.meetInfoView addSubview:label];
        label;
    });
    
    self.annexView = ({
        CXERPAnnexView *annexView = [[CXERPAnnexView alloc] initWithFrame:CGRectZero type:CXERPAnnexViewTypePictureVoiceAndAnnex];
        [self.scrollView addSubview:annexView];
        annexView;
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, navHigh, GET_WIDTH(self.view), GET_HEIGHT(self.view) - navHigh);
    
    self.topView.frame = CGRectMake(0, 0, GET_WIDTH(self.scrollView), 135);
    self.collectionView.frame = CGRectMake(0, 0, GET_WIDTH(self.topView), 90);
    self.viewMemberButton.size = CGSizeMake(48, 20);
    self.viewMemberButton.layer.cornerRadius = GET_HEIGHT(self.viewMemberButton) * 0.5;
    self.viewMemberButton.top = GET_MAX_Y(self.collectionView) + 2;
    self.viewMemberButton.right = GET_WIDTH(self.topView) - 10;
    [self.memberCountLabel sizeToFit];
    self.memberCountLabel.centerY = GET_MID_Y(self.viewMemberButton);
    self.memberCountLabel.right = GET_MIN_X(self.viewMemberButton) - 10;
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.view) - 20, MAXFLOAT)];
    self.titleLabel.frame = CGRectMake(10, 11, titleLabelSize.width, titleLabelSize.height);
    self.titleView.frame = CGRectMake(0, GET_MAX_Y(self.topView), GET_WIDTH(self.scrollView), 22 + titleLabelSize.height);
    
    // 标签
    for (NSInteger i = 0; i < self.tagLabels.count; i++) {
        UILabel *label = self.tagLabels[i];
        // 左右的间距
        CGFloat paddingLeft = 5;
        CGFloat h = 22;
        CGFloat x = ({
            i == 0 ? 12 : GET_MAX_X(self.tagLabels[i - 1]) + 6;
        });
        CGFloat bottom = GET_MIN_Y(self.titleView) + 6;
        CGFloat w = ({
            [label sizeToFit];
            GET_WIDTH(label) + paddingLeft * 2;
        });
        label.left = x;
        label.width = w;
        label.height = h;
        label.bottom = bottom;
        // 显示不下就隐藏
        if (GET_MAX_X(label) > GET_WIDTH(self.scrollView)) {
            label.hidden = YES;
        }
    }
    self.ksLabel.frame = CGRectMake(GET_MIN_X(self.titleLabel), 0, GET_WIDTH(self.scrollView) - 2*GET_MIN_X(self.titleLabel), self.ksLabel.textHeight + self.ksLabel.paddingTopBottom);
    if (GET_HEIGHT(self.ksLabel) < kCellHeight) {
        self.ksLabel.height = kCellHeight;
    }
    
    _ksTimeLine.frame = CGRectMake(0, GET_MAX_Y(self.ksLabel), GET_WIDTH(self.scrollView), 1 / UIScreen.mainScreen.scale);
    
    self.jsLabel.frame = CGRectMake(GET_MIN_X(self.ksLabel), GET_MAX_Y(_ksTimeLine), GET_WIDTH(self.ksLabel), self.jsLabel.textHeight + self.jsLabel.paddingTopBottom);
    if (GET_HEIGHT(self.jsLabel) < kCellHeight) {
        self.jsLabel.height = kCellHeight;
    }
    
    _jsTimeLine.frame = CGRectMake(0, GET_MAX_Y(self.jsLabel), GET_WIDTH(self.scrollView), 1 / UIScreen.mainScreen.scale);
    
    self.placeLabel.frame = CGRectMake(GET_MIN_X(self.jsLabel), GET_MAX_Y(_jsTimeLine), GET_WIDTH(self.jsLabel), self.placeLabel.textHeight + self.placeLabel.paddingTopBottom);
    if (GET_HEIGHT(self.placeLabel) < kCellHeight) {
        self.placeLabel.height = kCellHeight;
    }
    _placeLine.frame = CGRectMake(0, GET_MAX_Y(self.placeLabel), GET_WIDTH(self.scrollView), 1 / UIScreen.mainScreen.scale);
    
    self.contentLabel.frame = CGRectMake(GET_MIN_X(self.placeLabel), GET_MAX_Y(_placeLine), GET_WIDTH(self.placeLabel), self.contentLabel.textHeight + self.placeLabel.paddingTopBottom);
    if (GET_HEIGHT(self.contentLabel) < kCellHeight) {
        self.contentLabel.height = kCellHeight;
    }
    self.meetInfoView.frame = CGRectMake(0, GET_MAX_Y(self.titleView), GET_WIDTH(self.scrollView), GET_MAX_Y(self.contentLabel));
    
    self.annexView.frame = CGRectMake(0, GET_MAX_Y(self.meetInfoView) + 10, GET_WIDTH(self.scrollView), CXERPAnnexView_height);
    
    self.scrollView.contentSize = CGSizeMake(GET_WIDTH(self.scrollView), GET_MAX_Y(self.annexView) + 22 + titleLabelSize.height);
}

#pragma mark - UICollectionView Protocol
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.detailModel.ccList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 75);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
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
            imageView.layer.cornerRadius = 5;
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
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = kNameLabelTag;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_bottom).offset(4);
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
    self.titleLabel.text = detailModel.meet.title;
    
    self.tagLabels = [NSMutableArray array];
    // 参与组+类型
    for (NSInteger i = 0; i < detailModel.groupNames.count + 1; i++) {
        BOOL isLast = i == detailModel.groupNames.count;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        // 参与组
        if (isLast == NO) {
            label.text = trim(detailModel.groupNames[i]);
            label.backgroundColor = kColorWithRGB(255, 139, 20);
        }
        // 类型
        else {
            if (detailModel.meet.type == CXDailyMeetingTypeNormal) {
                label.text = @"普通";
            }
            else if (detailModel.meet.type == CXDailyMeetingTypeWeek) {
                label.text = @"周会";
            }
            else if (detailModel.meet.type == CXDailyMeetingTypeMonth) {
                label.text = @"月会";
            }
            label.backgroundColor = CXDailyMeetingTypeBackgroundColor;
        }
        [self.scrollView addSubview:label];
        [self.tagLabels addObject:label];
    }
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *startDate = [[NSDate dateWithString:detailModel.meet.startTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"yyyy-MM-dd"];
    NSString *startTime = [[NSDate dateWithString:detailModel.meet.startTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"H:mm"];
    NSString *endDate = [[NSDate dateWithString:detailModel.meet.endTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"yyyy-MM-dd"];
    NSString *endTime = [[NSDate dateWithString:detailModel.meet.endTime format:@"yyyy-MM-dd HH:mm:ss"] stringWithFormat:@"H:mm"];
    self.ksLabel.content = [NSString stringWithFormat:@"%@ %@", startDate, startTime];
    self.jsLabel.content = [NSString stringWithFormat:@"%@ %@", endDate, endTime];
    self.placeLabel.content = detailModel.meet.meetPlace;
    self.contentLabel.content = detailModel.meet.remark;
    self.annexView.detailAnnexDataArray = [detailModel.annexList mutableCopy];
    
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
    CXUserSelectController *vc = [[CXUserSelectController alloc] init];
    vc.selectType = AllMembersType;
    vc.title = @"参与人";
    vc.multiSelect = NO;
    vc.displayOnly = YES;
    NSMutableArray<CXUserModel *> *users = @[].mutableCopy;
    [self.detailModel.ccList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXUserModel *u = [[CXUserModel alloc] init];
        NSNumber *uid = obj[@"userId"];
        u.eid = uid.integerValue;
        u.name = obj[@"userName"];
        [users addObject:u];
    }];
    vc.selectedUsers = users;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
