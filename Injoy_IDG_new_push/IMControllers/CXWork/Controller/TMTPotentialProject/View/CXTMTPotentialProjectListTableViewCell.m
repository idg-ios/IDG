//
//  CXTMTPotentialProjectListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/27.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXTMTPotentialProjectListTableViewCell.h"
#import "UIView+Category.h"

@interface CXTMTPotentialProjectListTableViewCell()

@property (nonatomic, strong) CXTMTPotentialProjectListModel * model;
@property (nonatomic, strong) UIImageView * projGroupImageView;
@property (nonatomic, strong) UILabel * projNameLabel;
@property (nonatomic, strong) UILabel * projManagerNameLabel;
@property (nonatomic, strong) UILabel * businessLabel;
@property (nonatomic, strong) UILabel * induNameLabel;

@end

@implementation CXTMTPotentialProjectListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_projGroupImageView){
        [_projGroupImageView removeFromSuperview];
        _projGroupImageView = nil;
    }
    _projGroupImageView = [[UIImageView alloc] init];
    
    if(_projNameLabel){
        [_projNameLabel removeFromSuperview];
        _projNameLabel = nil;
    }
    _projNameLabel = [[UILabel alloc] init];
    _projNameLabel.font = [UIFont systemFontOfSize:kProjNameLabelFontSize];
    _projNameLabel.textColor = kProjNameLabelTextColor;
    _projNameLabel.backgroundColor = [UIColor clearColor];
    _projNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_projManagerNameLabel){
        [_projManagerNameLabel removeFromSuperview];
        _projManagerNameLabel = nil;
    }
    _projManagerNameLabel = [[UILabel alloc] init];
    _projManagerNameLabel.font = [UIFont systemFontOfSize:kProjManagerNameLabelFontSize];
    _projManagerNameLabel.textColor = kProjManagerNameLabelTextColor;
    _projManagerNameLabel.backgroundColor = [UIColor clearColor];
    _projManagerNameLabel.textAlignment = NSTextAlignmentRight;
    
    if(_induNameLabel){
        [_induNameLabel removeFromSuperview];
        _induNameLabel = nil;
    }
    _induNameLabel = [[UILabel alloc] init];
    _induNameLabel.font = [UIFont systemFontOfSize:kInduNameLabelFontSize];
    _induNameLabel.textColor = kInduNameLabelTextColor;
    _induNameLabel.numberOfLines = 0;
    _induNameLabel.backgroundColor = [UIColor clearColor];
    _induNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_businessLabel){
        [_businessLabel removeFromSuperview];
        _businessLabel = nil;
    }
    _businessLabel = [[UILabel alloc] init];
    _businessLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _businessLabel.textColor = kBusinessLabelTextColor;
    _businessLabel.numberOfLines = 0;
    _businessLabel.backgroundColor = [UIColor clearColor];
    _businessLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXTMTPotentialProjectListModel:(CXTMTPotentialProjectListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _projGroupImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"projGroup8"]];
    _projGroupImageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"projGroup8"]];
    _projGroupImageView.frame = CGRectMake(kImageLeftSpace, kImageTopSpace, kImageViewWidth, kImageViewWidth);
    [self.contentView addSubview:_projGroupImageView];
    
    _projManagerNameLabel.text = _model.followUpPersonName;
    [_projManagerNameLabel sizeToFit];
    _projManagerNameLabel.frame = CGRectMake(Screen_Width - kImageLeftSpace - _projManagerNameLabel.size.width, CGRectGetMinY(_projGroupImageView.frame) + 1, _projManagerNameLabel.size.width, kProjManagerNameLabelFontSize);
    [self.contentView addSubview:_projManagerNameLabel];
    
    _projNameLabel.text = _model.projName;
    _projNameLabel.frame = CGRectMake(CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace, CGRectGetMinY(_projGroupImageView.frame), Screen_Width - (CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace) - _projManagerNameLabel.size.width - kImageLeftSpace, kProjNameLabelFontSize);
    [self.contentView addSubview:_projNameLabel];
    
    _induNameLabel.text = _model.indu;
    _induNameLabel.frame = CGRectMake(CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace, CGRectGetMaxY(_projNameLabel.frame) + kLabelMiddleSpace, Screen_Width - (CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace) - kImageLeftSpace, kInduNameLabelFontSize);
    [self.contentView addSubview:_induNameLabel];
    
    _businessLabel.text = _model.zhDesc;
    _businessLabel.frame = CGRectMake(CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace, CGRectGetMaxY(_induNameLabel.frame) + kLabelMiddleSpace, Screen_Width - (CGRectGetMaxX(_projGroupImageView.frame) + kLabelLeftImageSpace) - kImageLeftSpace, kBusinessLabelFontSize);
    [self.contentView addSubview:_businessLabel];
}

@end
