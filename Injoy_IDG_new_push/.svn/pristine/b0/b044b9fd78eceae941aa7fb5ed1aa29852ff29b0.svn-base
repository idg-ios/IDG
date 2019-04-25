//
//  CXYMNewsLetterListCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNewsLetterListCell.h"
#import "CXYMNewsLetter.h"
#import "CXYMAppearanceManager.h"
#import "Masonry.h"
#import "NSDate+CXYMCategory.h"

@interface CXYMNewsLetterListCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *subContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation CXYMNewsLetterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma setter &&getter
-(UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [CXYMAppearanceManager textMediumFont];
        _timeLabel.textColor = RGBACOLOR(175, 177, 180, 1);
        _timeLabel.backgroundColor = RGBACOLOR(237, 238, 240, 1);
       _timeLabel.clipsToBounds = YES;
        _timeLabel.layer.cornerRadius = 2;
    }
    return _timeLabel;
}
- (UIView *)subContentView{
    if(_subContentView == nil){
        _subContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _subContentView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        _subContentView.clipsToBounds = YES;
        _subContentView.layer.cornerRadius = [CXYMAppearanceManager appStyleCornerRadius];
    }
    return _subContentView;
}
- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel .font = [CXYMAppearanceManager textSuperLagerFont];
        _titleLabel .textColor = [CXYMAppearanceManager textNormalColor];
    }
    return _titleLabel;
}
-(UILabel *)groupLabel{
    if(_groupLabel == nil){
        _groupLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupLabel.font = [CXYMAppearanceManager textNormalFont];
        _groupLabel.textColor = [UIColor yy_colorWithHexString:@"#848E99"];
    }
    return _groupLabel;
}
-(UILabel *)contentLabel{
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [CXYMAppearanceManager textMediumFont];
        _contentLabel.textColor = [CXYMAppearanceManager textNormalColor];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}
- (void)setNewsLetter:(CXYMNewsLetter *)newsLetter{
    _newsLetter = newsLetter;
    _timeLabel.text = [NSDate yyyyMMddWithDate:newsLetter.newsDate] ? : @"2017-12-24 12:12";
    _titleLabel.text = newsLetter.docName ? : @"文本标题长度设置";
    _groupLabel.text = newsLetter.indusGroupName ? : @"小组名称";
    _contentLabel.text = newsLetter.summary ? : @"文本内容长度设置文本内容长度设置文本内容长度设置";
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
   
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
   
    [self.contentView addSubview:self.subContentView];
    [self.subContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.bottom.mas_equalTo(-10);
    }];
   
    [self.subContentView addSubview:self.titleLabel ];
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.top.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(20);
    }];
     
     [self.subContentView addSubview:self.groupLabel];
     [self.groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(20);
     }];
    
   
    [self.subContentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.top.mas_equalTo(self.groupLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    [self.subContentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(1);
    }];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.text = @"查看详情";
    detailLabel.font = [CXYMAppearanceManager textMediumFont];
    detailLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [self.subContentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(line.mas_bottom).mas_offset([CXYMAppearanceManager appStyleMargin]);
    }];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowImageView.image = [UIImage imageNamed:@"arrow_more"];
    [self.subContentView addSubview:arrowImageView];
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
