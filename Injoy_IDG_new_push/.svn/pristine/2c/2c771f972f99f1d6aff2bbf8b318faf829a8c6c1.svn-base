//
//  CXNewConversionCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/6.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewConversionCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface CXNewConversionCell ()
@property (nonatomic, strong) UIImageView *avaerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation CXNewConversionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SDCompanyUserModel *)model{
    _model = model;
    [_avaerImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
    [self setupNameLabel];
}
- (void)setupNameLabel{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc ] initWithString:self.model.name];
    NSRange range = [self.model.name rangeOfString:self.searchText];
    if (range.location != NSNotFound) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
        _nameLabel.attributedText = attributedString;
    } else {
        _nameLabel.text = self.model.name ? : @"";
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.avaerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.avaerImageView];
    [self.avaerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
    }];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(self.avaerImageView.mas_right).mas_offset(10);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
