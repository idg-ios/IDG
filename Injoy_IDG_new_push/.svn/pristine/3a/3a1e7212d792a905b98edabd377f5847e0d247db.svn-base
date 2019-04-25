//
//  CXReimbursementApprovalListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXReimbursementApprovalListTableViewCell.h"
#import "UIView+Category.h"
#import "Masonry.h"

@interface CXReimbursementApprovalListTableViewCell()

@property (nonatomic, strong) CXReimbursementApprovalListModel * model;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * sqrTitleLabel;
@property (nonatomic, strong) UILabel * sqrContentLabel;
@property (nonatomic, strong) UILabel * sjjeTitleLabel;
@property (nonatomic, strong) UILabel * sjjeContentLabel;
@property (nonatomic, strong) UILabel * sqrqTitleLabel;
@property (nonatomic, strong) UILabel * sqrqContentLabel;

@property(strong, nonatomic) UILabel *approvalUserNameLabel;

@end

@implementation CXReimbursementApprovalListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (CXReimbursementApprovalListModel *)model{
    if(!_model){
        _model = [[CXReimbursementApprovalListModel alloc] init];
    }
    return _model;
}

- (void)layoutCell
{
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _titleLabel.textColor = kTitleLabelTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_sqrTitleLabel){
        [_sqrTitleLabel removeFromSuperview];
        _sqrTitleLabel = nil;
    }
    _sqrTitleLabel = [[UILabel alloc] init];
    _sqrTitleLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sqrTitleLabel.textColor = kDetailLabelTextColor;
    _sqrTitleLabel.backgroundColor = [UIColor clearColor];
    _sqrTitleLabel.textAlignment = NSTextAlignmentRight;
    
    if(_sqrContentLabel){
        [_sqrContentLabel removeFromSuperview];
        _sqrContentLabel = nil;
    }
    _sqrContentLabel = [[UILabel alloc] init];
    _sqrContentLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sqrContentLabel.textColor = kDetailLabelTextColor;
    _sqrContentLabel.backgroundColor = [UIColor clearColor];
    _sqrContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_sjjeTitleLabel){
        [_sjjeTitleLabel removeFromSuperview];
        _sjjeTitleLabel = nil;
    }
    _sjjeTitleLabel = [[UILabel alloc] init];
    _sjjeTitleLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sjjeTitleLabel.textColor = kDetailLabelTextColor;
    _sjjeTitleLabel.backgroundColor = [UIColor clearColor];
    _sjjeTitleLabel.textAlignment = NSTextAlignmentRight;
    
    if(_sjjeContentLabel){
        [_sjjeContentLabel removeFromSuperview];
        _sjjeContentLabel = nil;
    }
    _sjjeContentLabel = [[UILabel alloc] init];
    _sjjeContentLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sjjeContentLabel.textColor = kDetailLabelTextColor;
    _sjjeContentLabel.backgroundColor = [UIColor clearColor];
    _sjjeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_sqrqTitleLabel){
        [_sqrqTitleLabel removeFromSuperview];
        _sqrqTitleLabel = nil;
    }
    _sqrqTitleLabel = [[UILabel alloc] init];
    _sqrqTitleLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sqrqTitleLabel.textColor = kDetailLabelTextColor;
    _sqrqTitleLabel.backgroundColor = [UIColor clearColor];
    _sqrqTitleLabel.textAlignment = NSTextAlignmentRight;
    
    if(_sqrqContentLabel){
        [_sqrqContentLabel removeFromSuperview];
        _sqrqContentLabel = nil;
    }
    _sqrqContentLabel = [[UILabel alloc] init];
    _sqrqContentLabel.font = [UIFont systemFontOfSize:kDetailLabelFontSize];
    _sqrqContentLabel.textColor = kDetailLabelTextColor;
    _sqrqContentLabel.backgroundColor = [UIColor clearColor];
    _sqrqContentLabel.textAlignment = NSTextAlignmentLeft;
    
    _approvalUserNameLabel = [[UILabel alloc] init];
    _approvalUserNameLabel.font = kFontTimeSizeForForm;
    _approvalUserNameLabel.text = @"未审批";
    [self.contentView addSubview:_approvalUserNameLabel];
}

- (void)setCXReimbursementApprovalListModel:(CXReimbursementApprovalListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    CGFloat leftMargin = 10.0;
    if([self.model.itemType isEqualToString:@"Reimbursement"]){
        _titleLabel.text = @"报销单";
    }else if([self.model.itemType isEqualToString:@"Payment"]){
        _titleLabel.text = @"付款单";
    }else if([self.model.itemType isEqualToString:@"Reim2Pay"]){
        _titleLabel.text = @"报销付款单";
    }else if([self.model.itemType isEqualToString:@"Loan"]){
        _titleLabel.text = @"借款单";
    }else if([self.model.itemType isEqualToString:@"DDFee"]){
        _titleLabel.text = @"尽调费用审批单";
    }else if([self.model.itemType isEqualToString:@"EmployeeVoucher"]){
        _titleLabel.text = @"个人费用报销单";
    }else if([self.model.itemType isEqualToString:@"GeneralVoucher"]){
        _titleLabel.text = @"公共费用报销单";
    }else if([self.model.itemType isEqualToString:@"EmployeeLoan"]){
        _titleLabel.text = @"员工借款单";
    }else if([self.model.itemType isEqualToString:@"PaymentVoucher"]){
        _titleLabel.text = @"付款单";
    }else if([self.model.itemType isEqualToString:@"SpecialVoucher"]){
        _titleLabel.text = @"专项费用报销单";
    }else if([self.model.itemType isEqualToString:@"AssetsVoucher"]){
        _titleLabel.text = @"资产采购单";
    }
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, _titleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_titleLabel];
    
    
    // 橙色
    UIColor *color_1 = kColorWithRGB(212.f, 115.f, 80.f);
    // 绿色
    UIColor *color_3 = kColorWithRGB(56.f, 125.f, 19.f);
    if(_model.stateInt && [_model.stateInt integerValue] == 1){
        _approvalUserNameLabel.textColor = color_1;
    }else if(_model.stateInt && [_model.stateInt integerValue] == 3){
        _approvalUserNameLabel.textColor = color_3;
    }else{
        _approvalUserNameLabel.textColor = color_1;
    }
    
    _approvalUserNameLabel.text = _model.state;
    
    _sqrTitleLabel.text = @"申请人：";
    [_sqrTitleLabel sizeToFit];
    _sqrTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_titleLabel.frame) + kLabelTopSpace, _sqrTitleLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sqrTitleLabel];
    
    _sqrContentLabel.text = _model.create;
    [_sqrContentLabel sizeToFit];
    _sqrContentLabel.frame = CGRectMake(CGRectGetMaxX(_sqrTitleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + kLabelTopSpace, _sqrContentLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sqrContentLabel];
    
    _sjjeTitleLabel.text = @"涉及金额：";
    [_sjjeTitleLabel sizeToFit];
    _sjjeTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_sqrTitleLabel.frame) + kLabelTopSpace, _sjjeTitleLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sjjeTitleLabel];
    
    _sjjeContentLabel.text = _model.amount;
    [_sjjeContentLabel sizeToFit];
    _sjjeContentLabel.frame = CGRectMake(CGRectGetMaxX(_sjjeTitleLabel.frame), CGRectGetMaxY(_sqrTitleLabel.frame) + kLabelTopSpace, _sjjeContentLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sjjeContentLabel];
    
    _sqrqTitleLabel.text = @"申请日期：";
    [_sqrqTitleLabel sizeToFit];
    _sqrqTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_sjjeTitleLabel.frame) + kLabelTopSpace, _sqrqTitleLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sqrqTitleLabel];
    
    _sqrqContentLabel.text = _model.createDate;
    [_sqrqContentLabel sizeToFit];
    _sqrqContentLabel.frame = CGRectMake(CGRectGetMaxX(_sqrqTitleLabel.frame), CGRectGetMaxY(_sjjeTitleLabel.frame) + kLabelTopSpace, _sqrqContentLabel.size.width, kDetailLabelFontSize);
    [self.contentView addSubview:_sqrqContentLabel];
    
    CGFloat margin = 10.f;
    [_approvalUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-margin);
        make.centerY.equalTo(_titleLabel.mas_centerY);
    }];
    
}

@end
