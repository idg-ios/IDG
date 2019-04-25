//
// Created by ^ on 2017/10/27.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXApprovalListCell.h"
#import "Masonry.h"
#import "UIImageView+EMWebCache.h"
#import "YYCategories.h"

@interface CXApprovalListCell ()
@property(strong, nonatomic) UIImageView *headImageView;
/// 姓名
@property(strong, nonatomic) UILabel *nameLabel;
/// 职位
@property(strong, nonatomic) UILabel *jobLabel;
/// 日期
@property(strong, nonatomic) UILabel *dateLabel;
/// 内容
@property(strong, nonatomic) UILabel *remarkView;
/// 气泡
@property(nonatomic, strong) UIImageView *bgImageView;
@end

@implementation CXApprovalListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        // 头像
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp_user_head"]];
        [self.contentView addSubview:_headImageView];

        // 姓名
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kColorWithRGB(76.f, 76.f, 76.f);
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = kFontSizeForDetail;
        [self.contentView addSubview:_nameLabel];

        // 职务
        _jobLabel = [[UILabel alloc] init];
        _jobLabel.font = [UIFont systemFontOfSize:14.f];
        _jobLabel.textColor = kColorWithRGB(148.f, 148.f, 148.f);
        [self.contentView addSubview:_jobLabel];

        // 时间
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14.f];
        _dateLabel.textColor = kColorWithRGB(148.f, 148.f, 148.f);
        [self.contentView addSubview:_dateLabel];

        // 内容
        _remarkView = [[UILabel alloc] init];
        _remarkView.numberOfLines = 0;
        _remarkView.lineBreakMode = NSLineBreakByWordWrapping;
        _remarkView.textColor = kColorWithRGB(50.f, 50.f, 52.f);
        _remarkView.font = kFontSizeForDetail;
        [self.contentView addSubview:_remarkView];

        UIImage *bgImage = [UIImage imageNamed:@"approvalbackground"];

        _bgImageView = [[UIImageView alloc] initWithImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f) resizingMode:UIImageResizingModeStretch]];
        [self.contentView addSubview:_bgImageView];

        [self.contentView bringSubviewToFront:_remarkView];

        [self setViewAtuoLayout];
    }
    return self;
}

- (void)setViewAtuoLayout {

    CGFloat margin = 10.f;

    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(margin);
        make.top.equalTo(self.contentView.mas_top).mas_equalTo(margin);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(margin);
        make.top.equalTo(_headImageView.mas_top);
        make.width.mas_greaterThanOrEqualTo(margin);
        make.width.mas_lessThanOrEqualTo(150.f);
    }];

    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(margin);
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];

    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-margin);
    }];

    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left).offset(margin);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(margin);
        make.right.equalTo(self.contentView.mas_right).offset(-margin);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-margin);
    }];

    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_remarkView).insets(UIEdgeInsetsMake(0.f, -2 * margin, 0.f, -margin / 2.f));
    }];
}

- (void)setAction:(CXApprovalListModel *)approvalListModel {
    [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:approvalListModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {

    }];
    self.nameLabel.text = approvalListModel.userName;
    self.dateLabel.text = approvalListModel.createTime;
    self.jobLabel.text = approvalListModel.job;
    self.remarkView.text = approvalListModel.approvalRemark;
}

@end
