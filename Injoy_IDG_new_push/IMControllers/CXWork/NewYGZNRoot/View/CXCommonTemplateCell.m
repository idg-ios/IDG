//
//  CXCommonTemplateCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXCommonTemplateCell.h"
#import "Masonry.h"
#import "CXCommonTemplateModel.h"

@interface CXCommonTemplateCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CXCommonTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCommonTemplateModel:(CXCommonTemplateModel *)commonTemplateModel{
    _commonTemplateModel = commonTemplateModel;
    _titleLabel.text = commonTemplateModel.title;
    _timeLabel.text = commonTemplateModel.publishTime;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.height.mas_equalTo(0);
    }];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).mas_offset(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
