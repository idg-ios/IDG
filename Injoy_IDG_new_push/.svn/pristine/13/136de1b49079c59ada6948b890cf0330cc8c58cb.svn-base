//
//  CXFeeTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXFeeTableViewCell.h"
#import "UIView+Category.h"

@interface CXFeeTableViewCell()

@property (nonatomic, strong) CXFeeModel * model;
@property (nonatomic, strong) UILabel * xmTitleLabel;
@property (nonatomic, strong) UILabel * xmContentLabel;
@property (nonatomic, strong) UILabel * jyTitleLabel;
@property (nonatomic, strong) UILabel * jyContentLabel;
@property (nonatomic, strong) UILabel * fpjeTitleLabel;
@property (nonatomic, strong) UILabel * fpjeContentLabel;
@property (nonatomic, strong) UILabel * rmbjeTitleLabel;
@property (nonatomic, strong) UILabel * rmbjeContentLabel;

@end

@implementation CXFeeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self layoutCell];
    }
    return self;
}

- (CXFeeModel *)model{
    if(!_model){
        _model = [[CXFeeModel alloc] init];
    }
    return _model;
}

- (void)layoutCell
{
    if(_xmTitleLabel){
        [_xmTitleLabel removeFromSuperview];
        _xmTitleLabel = nil;
    }
    _xmTitleLabel = [[UILabel alloc] init];
    _xmTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _xmTitleLabel.textColor = kFeeTitleLabelTextColor;
    _xmTitleLabel.numberOfLines = 0;
    _xmTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _xmTitleLabel.backgroundColor = [UIColor clearColor];
    _xmTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_xmContentLabel){
        [_xmContentLabel removeFromSuperview];
        _xmContentLabel = nil;
    }
    _xmContentLabel = [[UILabel alloc] init];
    _xmContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _xmContentLabel.textColor = kFeeContentLabelTextColor;
    _xmContentLabel.backgroundColor = [UIColor clearColor];
    _xmContentLabel.numberOfLines = 0;
    _xmContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _xmContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_jyTitleLabel){
        [_jyTitleLabel removeFromSuperview];
        _jyTitleLabel = nil;
    }
    _jyTitleLabel = [[UILabel alloc] init];
    _jyTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _jyTitleLabel.textColor = kFeeTitleLabelTextColor;
    _jyTitleLabel.backgroundColor = [UIColor clearColor];
    _jyTitleLabel.numberOfLines = 0;
    _jyTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _jyTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_jyContentLabel){
        [_jyContentLabel removeFromSuperview];
        _jyContentLabel = nil;
    }
    _jyContentLabel = [[UILabel alloc] init];
    _jyContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _jyContentLabel.textColor = kFeeContentLabelTextColor;
    _jyContentLabel.backgroundColor = [UIColor clearColor];
    _jyContentLabel.numberOfLines = 0;
    _jyContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _jyContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_fpjeTitleLabel){
        [_fpjeTitleLabel removeFromSuperview];
        _fpjeTitleLabel = nil;
    }
    _fpjeTitleLabel = [[UILabel alloc] init];
    _fpjeTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _fpjeTitleLabel.textColor = kFeeTitleLabelTextColor;
    _fpjeTitleLabel.backgroundColor = [UIColor clearColor];
    _fpjeTitleLabel.numberOfLines = 0;
    _fpjeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _fpjeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_fpjeContentLabel){
        [_fpjeContentLabel removeFromSuperview];
        _fpjeContentLabel = nil;
    }
    _fpjeContentLabel = [[UILabel alloc] init];
    _fpjeContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _fpjeContentLabel.textColor = kFeeContentLabelTextColor;
    _fpjeContentLabel.backgroundColor = [UIColor clearColor];
    _fpjeContentLabel.numberOfLines = 0;
    _fpjeContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _fpjeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_rmbjeTitleLabel){
        [_rmbjeTitleLabel removeFromSuperview];
        _rmbjeTitleLabel = nil;
    }
    _rmbjeTitleLabel = [[UILabel alloc] init];
    _rmbjeTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _rmbjeTitleLabel.textColor = kFeeTitleLabelTextColor;
    _rmbjeTitleLabel.backgroundColor = [UIColor clearColor];
    _rmbjeTitleLabel.numberOfLines = 0;
    _rmbjeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _rmbjeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_rmbjeContentLabel){
        [_rmbjeContentLabel removeFromSuperview];
        _rmbjeContentLabel = nil;
    }
    _rmbjeContentLabel = [[UILabel alloc] init];
    _rmbjeContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    _rmbjeContentLabel.textColor = kFeeContentLabelTextColor;
    _rmbjeContentLabel.backgroundColor = [UIColor clearColor];
    _rmbjeContentLabel.numberOfLines = 0;
    _rmbjeContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _rmbjeContentLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXFeeModel:(CXFeeModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    CGFloat leftMargin = 10.0;
    _xmTitleLabel.text = @"项　　目：";
    [_xmTitleLabel sizeToFit];
    _xmTitleLabel.frame = CGRectMake(leftMargin, kFeeLabelTopSpace, _xmTitleLabel.size.width, kFeeTitleLabelFontSize);
    [self.contentView addSubview:_xmTitleLabel];
    
    _xmContentLabel.text = [NSString stringWithFormat:@"%@ %@",_model.baseType,_model.subType ? : @""];
    CGSize xmContentLabelSize = [_xmContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(_xmTitleLabel.frame), MAXFLOAT)];
    _xmContentLabel.frame = CGRectMake(CGRectGetMaxX(_xmTitleLabel.frame), kFeeLabelTopSpace, xmContentLabelSize.width, xmContentLabelSize.height);
    [self.contentView addSubview:_xmContentLabel];
    
    _jyTitleLabel.text = @"摘　　要：";
    [_jyTitleLabel sizeToFit];
    _jyTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_xmContentLabel.frame) + kFeeLabelTopSpace, _jyTitleLabel.size.width, kFeeTitleLabelFontSize);
    [self.contentView addSubview:_jyTitleLabel];
    
    _jyContentLabel.text = [NSString stringWithFormat:@"%@",_model.summary?_model.summary:@" "];
    CGSize jyContentLabelSize = [_jyContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(_jyTitleLabel.frame), MAXFLOAT)];
    _jyContentLabel.frame = CGRectMake(CGRectGetMaxX(_jyTitleLabel.frame), CGRectGetMaxY(_xmContentLabel.frame) + kFeeLabelTopSpace, jyContentLabelSize.width, jyContentLabelSize.height);
    [self.contentView addSubview:_jyContentLabel];
    
    _fpjeTitleLabel.text = @"发票金额：";
    [_fpjeTitleLabel sizeToFit];
    _fpjeTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_jyContentLabel.frame) + kFeeLabelTopSpace, _fpjeTitleLabel.size.width, kFeeTitleLabelFontSize);
    [self.contentView addSubview:_fpjeTitleLabel];
    
    _fpjeContentLabel.text = [NSString stringWithFormat:@"%@",_model.amt];
    CGSize fpjeContentLabelSize = [_fpjeContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(_fpjeTitleLabel.frame), MAXFLOAT)];
    _fpjeContentLabel.frame = CGRectMake(CGRectGetMaxX(_fpjeTitleLabel.frame), CGRectGetMaxY(_jyContentLabel.frame) + kFeeLabelTopSpace, fpjeContentLabelSize.width, fpjeContentLabelSize.height);
    [self.contentView addSubview:_fpjeContentLabel];
    
    _rmbjeTitleLabel.text = @"RMB金额：";
    [_rmbjeTitleLabel sizeToFit];
    _rmbjeTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(_fpjeContentLabel.frame) + kFeeLabelTopSpace, _rmbjeTitleLabel.size.width, kFeeTitleLabelFontSize);
    [self.contentView addSubview:_rmbjeTitleLabel];
    
    _rmbjeContentLabel.text = [NSString stringWithFormat:@"%@",_model.rmbAmt?_model.rmbAmt:@" "];
    CGSize rmbjeContentLabelSize = [_rmbjeContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(_rmbjeTitleLabel.frame), MAXFLOAT)];
    _rmbjeContentLabel.frame = CGRectMake(CGRectGetMaxX(_rmbjeTitleLabel.frame), CGRectGetMaxY(_fpjeContentLabel.frame) + kFeeLabelTopSpace, rmbjeContentLabelSize.width, rmbjeContentLabelSize.height);
    [self.contentView addSubview:_rmbjeContentLabel];
}

+ (CGFloat)getCellHeightWithCXFeeModel:(CXFeeModel *)model
{
    UILabel * xmTitleLabel = [[UILabel alloc] init];
    xmTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    xmTitleLabel.textColor = kFeeTitleLabelTextColor;
    xmTitleLabel.numberOfLines = 0;
    xmTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    xmTitleLabel.backgroundColor = [UIColor clearColor];
    xmTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * xmContentLabel = [[UILabel alloc] init];
    xmContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    xmContentLabel.textColor = kFeeContentLabelTextColor;
    xmContentLabel.backgroundColor = [UIColor clearColor];
    xmContentLabel.numberOfLines = 0;
    xmContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    xmContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * jyTitleLabel = [[UILabel alloc] init];
    jyTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    jyTitleLabel.textColor = kFeeTitleLabelTextColor;
    jyTitleLabel.backgroundColor = [UIColor clearColor];
    jyTitleLabel.numberOfLines = 0;
    jyTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    jyTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * jyContentLabel = [[UILabel alloc] init];
    jyContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    jyContentLabel.textColor = kFeeContentLabelTextColor;
    jyContentLabel.backgroundColor = [UIColor clearColor];
    jyContentLabel.numberOfLines = 0;
    jyContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    jyContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * fpjeTitleLabel = [[UILabel alloc] init];
    fpjeTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    fpjeTitleLabel.textColor = kFeeTitleLabelTextColor;
    fpjeTitleLabel.backgroundColor = [UIColor clearColor];
    fpjeTitleLabel.numberOfLines = 0;
    fpjeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fpjeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * fpjeContentLabel = [[UILabel alloc] init];
    fpjeContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    fpjeContentLabel.textColor = kFeeContentLabelTextColor;
    fpjeContentLabel.backgroundColor = [UIColor clearColor];
    fpjeContentLabel.numberOfLines = 0;
    fpjeContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fpjeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * rmbjeTitleLabel = [[UILabel alloc] init];
    rmbjeTitleLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    rmbjeTitleLabel.textColor = kFeeTitleLabelTextColor;
    rmbjeTitleLabel.backgroundColor = [UIColor clearColor];
    rmbjeTitleLabel.numberOfLines = 0;
    rmbjeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rmbjeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * rmbjeContentLabel = [[UILabel alloc] init];
    rmbjeContentLabel.font = [UIFont systemFontOfSize:kFeeTitleLabelFontSize];
    rmbjeContentLabel.textColor = kFeeContentLabelTextColor;
    rmbjeContentLabel.backgroundColor = [UIColor clearColor];
    rmbjeContentLabel.numberOfLines = 0;
    rmbjeContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rmbjeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat leftMargin = 10.0;
    xmTitleLabel.text = @"项　　目：";
    [xmTitleLabel sizeToFit];
    xmTitleLabel.frame = CGRectMake(leftMargin, kFeeLabelTopSpace, xmTitleLabel.size.width, kFeeTitleLabelFontSize);
    
    NSLog(@"=======%@",model.subType);
    NSString * subType = [model.subType isEqualToString:@"null"] ? @"" : model.subType;
    xmContentLabel.text = [NSString stringWithFormat:@"%@ %@",model.baseType ? : @"",subType ];
    CGSize xmContentLabelSize = [xmContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(xmTitleLabel.frame), MAXFLOAT)];
    xmContentLabel.frame = CGRectMake(CGRectGetMaxX(xmTitleLabel.frame), kFeeLabelTopSpace, xmContentLabelSize.width, xmContentLabelSize.height);
    
    jyTitleLabel.text = @"摘　　要：";
    [jyTitleLabel sizeToFit];
    jyTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(xmContentLabel.frame) + kFeeLabelTopSpace, jyTitleLabel.size.width, kFeeTitleLabelFontSize);
    
    jyContentLabel.text = [NSString stringWithFormat:@"%@",model.summary];
    CGSize jyContentLabelSize = [jyContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(jyTitleLabel.frame), MAXFLOAT)];
    jyContentLabel.frame = CGRectMake(CGRectGetMaxX(jyTitleLabel.frame), CGRectGetMaxY(xmContentLabel.frame) + kFeeLabelTopSpace, jyContentLabelSize.width, jyContentLabelSize.height);
    
    fpjeTitleLabel.text = @"发票金额：";
    [fpjeTitleLabel sizeToFit];
    fpjeTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(jyContentLabel.frame) + kFeeLabelTopSpace, fpjeTitleLabel.size.width, kFeeTitleLabelFontSize);
    
    fpjeContentLabel.text = [NSString stringWithFormat:@"%@",model.amt];
    CGSize fpjeContentLabelSize = [fpjeContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(fpjeTitleLabel.frame), MAXFLOAT)];
    fpjeContentLabel.frame = CGRectMake(CGRectGetMaxX(fpjeTitleLabel.frame), CGRectGetMaxY(jyContentLabel.frame) + kFeeLabelTopSpace, fpjeContentLabelSize.width, fpjeContentLabelSize.height);
    
    rmbjeTitleLabel.text = @"RMB金额：";
    [rmbjeTitleLabel sizeToFit];
    rmbjeTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(fpjeContentLabel.frame) + kFeeLabelTopSpace, rmbjeTitleLabel.size.width, kFeeTitleLabelFontSize);
    
    rmbjeContentLabel.text = [NSString stringWithFormat:@"%@",model.rmbAmt?model.rmbAmt:@" "];
    CGSize rmbjeContentLabelSize = [rmbjeContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - CGRectGetMaxX(rmbjeTitleLabel.frame), MAXFLOAT)];
    rmbjeContentLabel.frame = CGRectMake(CGRectGetMaxX(rmbjeTitleLabel.frame), CGRectGetMaxY(fpjeContentLabel.frame) + kFeeLabelTopSpace, rmbjeContentLabelSize.width, rmbjeContentLabelSize.height);
    
    return CGRectGetMaxY(rmbjeContentLabel.frame) + kFeeLabelTopSpace;
}

#pragma mark --低版本cell分割线
- (void)drawRect:(CGRect)rect {
    if([UIDevice currentDevice].systemVersion.doubleValue  < 10){
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
        CGContextSetStrokeColorWithColor(context, [UIColor yy_colorWithHexString:@"e2e2e2"].CGColor);
        CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
    }
}

@end
