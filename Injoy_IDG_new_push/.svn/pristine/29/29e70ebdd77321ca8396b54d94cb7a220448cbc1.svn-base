//
//  CXYMAddressBookCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/12/5.
//  Copyright © 2018 Injoy. All rights reserved.
//

#import "CXYMAddressBookCell.h"

#import "Masonry.h"

@implementation CXYMAddressBookCell

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
    
    self.avaterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.avaterImageView];
    [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.width.height.mas_equalTo(48);//80-16*2
    }];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = RGBACOLOR(31, 34, 40, 1.0);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
    make.left.mas_equalTo(self.avaterImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-SDHeadImageViewLeftSpacing);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
