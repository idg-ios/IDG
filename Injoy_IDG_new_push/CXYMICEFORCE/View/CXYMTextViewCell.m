//
//  CXYMTextViewCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMTextViewCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"
#import "CXYMPlaceholderTextView.h"


@implementation CXYMTextViewCell

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
    CGFloat margin = [CXYMAppearanceManager appStyleMargin];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [CXYMAppearanceManager textLightGrayColor];
    self.titleLabel.font = [CXYMAppearanceManager textNormalFont];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(25);
    }];
    self.textView = [[CXYMPlaceholderTextView alloc] initWithPlaceholder:@"" textMaxLength:100];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-margin);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
