//
//  CXYMSystemMessageCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMSystemMessageCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"
#import "CXYMSystemMessage.h"

@interface CXYMSystemMessageCell ()
@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CXYMSystemMessageCell

- (void)setMessage:(CXYMSystemMessage *)message{
    _message = message;
    _timeLabel.text = message.createTime ? : @"2017-12-24 12:12";
    _titleLabel.text = message.title ? : @"文本标题长度设置";
    _contentLabel.text = message.content ? : @"文本内容长度设置文本内容长度设置文本内容长度设置";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [CXYMAppearanceManager textMediumFont];
//    self.timeLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
//    self.timeLabel.backgroundColor = [UIColor yy_colorWithHexString:@"#CCD0D4"];
    self.timeLabel.textColor = RGBACOLOR(175, 177, 180, 1);
    self.timeLabel.backgroundColor = RGBACOLOR(237, 238, 240, 1);
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.layer.cornerRadius = 2;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    UIView *subContentView = [[UIView alloc] initWithFrame:CGRectZero];
    subContentView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    subContentView.clipsToBounds = YES;
    subContentView.layer.cornerRadius = [CXYMAppearanceManager appStyleCornerRadius];
    [self.contentView addSubview:subContentView];
    [subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.bottom.mas_equalTo(0);
    }];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel .font = [CXYMAppearanceManager textSuperLagerFont];
    self.titleLabel .textColor = [CXYMAppearanceManager textNormalColor];
    [subContentView addSubview:self.titleLabel ];
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.top.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(20);
    }];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.font = [CXYMAppearanceManager textMediumFont];
    self.contentLabel.textColor = [CXYMAppearanceManager textNormalColor];
    self.contentLabel.numberOfLines = 0;
    [subContentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
    }];

    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    [subContentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(1);
    }];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.text = @"查看详情";
    detailLabel.font = [CXYMAppearanceManager textMediumFont];
    detailLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [subContentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(line.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
    }];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.image = [UIImage imageNamed:@"arrow_more"];
    [subContentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.centerY.mas_equalTo(detailLabel.mas_centerY).mas_offset(0);
        make.width.height.mas_equalTo(20);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
