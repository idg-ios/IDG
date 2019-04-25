//
//  CXYMNormalListCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNormalListCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXYMNormalListCell ()

@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation CXYMNormalListCell

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
    CGFloat margin = [CXYMAppearanceManager appStyleMargin];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = kColorWithRGB(31, 34, 40);
    self.titleLabel.font = [CXYMAppearanceManager textNormalFont];
    [self.contentView addSubview:self.titleLabel];
   
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.textColor = kColorWithRGB(31, 34, 40);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [CXYMAppearanceManager textNormalFont];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(140);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(self.contentLabel.mas_top).mas_offset(0);
    }];
    self.starImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.starImageView.image = [UIImage imageNamed:@"voiceExit"];
    self.starImageView.alpha = self.isRequire;
    [self.contentView addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(10);
        make.right.mas_equalTo(self.titleLabel.mas_left).mas_offset(-2);
    }];
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.arrowImageView.alpha = self.isChange;
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];
    
}
- (void)setIsRequire:(BOOL)isRequire{
    _isRequire = isRequire;
    self.starImageView.alpha = isRequire;
}
- (void)setIsChange:(BOOL)isChange{
    _isChange = isChange;
    self.arrowImageView.alpha = isChange;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
