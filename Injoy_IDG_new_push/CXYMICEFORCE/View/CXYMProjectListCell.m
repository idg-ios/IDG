//
//  CXYMProjectListCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMProjectListCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXYMProjectListCell ()
@property (nonatomic, strong) UIView *subContentView;
@end

@implementation CXYMProjectListCell

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
    self.contentView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    self.subContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subContentView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    self.subContentView.clipsToBounds = YES;
    self.subContentView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.subContentView];
    CGFloat margin = [CXYMAppearanceManager appStyleMargin];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(8.0);
        make.bottom.mas_equalTo(0);
    }];
    self.projectTypeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.subContentView addSubview:self.projectTypeImageView];
    [self.projectTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(46);
    }];
    self.peojectNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.peojectNameLabel.font = [UIFont systemFontOfSize:18];
    [self.subContentView addSubview:self.peojectNameLabel];
    [self.peojectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.projectTypeImageView.mas_right).mas_offset(margin);
        make.height.mas_equalTo(25);
    }];
    self.projectMajorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.projectMajorLabel.textColor = kColorWithRGB(174, 17, 41);
    self.projectMajorLabel.font = [CXYMAppearanceManager textSmallFont];
    self.projectMajorLabel.textAlignment = NSTextAlignmentRight;
    [self.subContentView addSubview:self.projectMajorLabel];
    [self.projectMajorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(20);
    }];
    self.projectTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.projectTypeLabel.textColor = kColorWithRGB(132, 142, 153);
    self.projectTypeLabel.font = [CXYMAppearanceManager textMediumFont];
    [self.subContentView addSubview:self.projectTypeLabel];
    [self.projectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.peojectNameLabel.mas_bottom);
        make.left.mas_equalTo(self.peojectNameLabel);
        make.height.mas_equalTo(20);
    }];
    self.projectDescribeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.projectDescribeLabel.textColor = kColorWithRGB(132, 142, 153);
    self.projectDescribeLabel.font = [CXYMAppearanceManager textMediumFont];
    [self.subContentView addSubview:self.projectDescribeLabel];
    [self.projectDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(self.peojectNameLabel);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-margin);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
