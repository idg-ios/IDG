//
//  CXYMNewProjectCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNewProjectCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXYMNewProjectCell ()

@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UIImageView *arrowImageView;//新建类型的指示图标

@end;

@implementation CXYMNewProjectCell

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
    self.contentView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    self.subContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subContentView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    [self.contentView addSubview:self.subContentView];
    CGFloat margin = [CXYMAppearanceManager appStyleMargin];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.bottom.mas_equalTo(0);
    }];
    self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.subContentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(margin);
        make.width.height.mas_equalTo(60);
    }];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [CXYMAppearanceManager textSuperLagerFont];
    self.titleLabel.textColor = [CXYMAppearanceManager textNormalColor];
    [self.subContentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(margin);
        make.right.mas_equalTo(-margin);
    }];
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_more"];
    [self.subContentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
