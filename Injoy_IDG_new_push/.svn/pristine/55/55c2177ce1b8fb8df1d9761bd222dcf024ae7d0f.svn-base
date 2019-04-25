//
//  CXIDGConferenceInformationListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGConferenceInformationListTableViewCell.h"
#import "UIView+Category.h"
#import "HttpTool.h"

#import "MBProgressHUD+CXCategory.h"

#define kLabelLeftSpace 15.0
#define kLabelTopSpace 10.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kTitleLabelFontSize 14.0
#define kTitleLabelTextColor RGBACOLOR(132.0, 142.0, 153.0, 1.0)
#define kOpinionDateLabelFontSize 14.0
#define kOpinionDateLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kConclusionLabelFontSize 14.0
#define kConclusionLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kApprovedByNameLabelFontSize 14.0
#define kApprovedByNameLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)

@interface CXIDGConferenceInformationListTableViewCell()

@property (nonatomic, strong) CXIDGConferenceInformationListModel * model;
@property (nonatomic, strong) UIView * redView;
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
@property (nonatomic, strong) UILabel * opinionDateTitleLabel;
@property (nonatomic, strong) UILabel * opinionDateLabel;
@property (nonatomic, strong) UILabel * conclusionTitleLabel;
@property (nonatomic, strong) UILabel * conclusionLabel;
@property (nonatomic, strong) UILabel * editByNameTitleLabel;
@property (nonatomic, strong) UILabel * editByNameLabel;
@property (nonatomic, strong) UILabel * approvedByNameTitleLabel;
@property (nonatomic, strong) UILabel * approvedByNameLabel;
@property (nonatomic, strong) UIButton * wyspBtn;
@property (nonatomic, strong) UIImageView * detailImageView;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation CXIDGConferenceInformationListTableViewCell

#define kImageLeftSpace 35.0

#define kImageWidth 35.0

#define kmargin 15.f
#define kLabelmargin 77.0f
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_redView){
        [_redView removeFromSuperview];
        _redView = nil;
    }
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = [UIColor redColor];
    
    if(_opinionTypeNameLabel){
        [_opinionTypeNameLabel removeFromSuperview];
        _opinionTypeNameLabel = nil;
    }
    _opinionTypeNameLabel = [[UILabel alloc] init];
    _opinionTypeNameLabel.font = [UIFont boldSystemFontOfSize:kOpinionTypeNameLabelFontSize];
    _opinionTypeNameLabel.textColor = kOpinionTypeNameLabelTextColor;
    _opinionTypeNameLabel.numberOfLines = 0;
    _opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _opinionTypeNameLabel.backgroundColor = [UIColor clearColor];
    _opinionTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionDateTitleLabel){
        [_opinionDateTitleLabel removeFromSuperview];
        _opinionDateTitleLabel = nil;
    }
    _opinionDateTitleLabel = [[UILabel alloc] init];
    _opinionDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _opinionDateTitleLabel.textColor = kTitleLabelTextColor;
    _opinionDateTitleLabel.backgroundColor = [UIColor clearColor];
    _opinionDateTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionDateLabel){
        [_opinionDateLabel removeFromSuperview];
        _opinionDateLabel = nil;
    }
    _opinionDateLabel = [[UILabel alloc] init];
    _opinionDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    _opinionDateLabel.textColor = kOpinionDateLabelTextColor;
    _opinionDateLabel.numberOfLines = 0;
    _opinionDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _opinionDateLabel.backgroundColor = [UIColor clearColor];
    _opinionDateLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_conclusionTitleLabel){
        [_conclusionTitleLabel removeFromSuperview];
        _conclusionTitleLabel = nil;
    }
    _conclusionTitleLabel = [[UILabel alloc] init];
    _conclusionTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _conclusionTitleLabel.textColor = kTitleLabelTextColor;
    _conclusionTitleLabel.numberOfLines = 0;
    _conclusionTitleLabel.backgroundColor = [UIColor clearColor];
    _conclusionTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_conclusionLabel){
        [_conclusionLabel removeFromSuperview];
        _conclusionLabel = nil;
    }
    _conclusionLabel = [[UILabel alloc] init];
    _conclusionLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _conclusionLabel.textColor = kConclusionLabelTextColor;
    _conclusionLabel.numberOfLines = 0;
    _conclusionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _conclusionLabel.backgroundColor = [UIColor clearColor];
    _conclusionLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_editByNameTitleLabel){
        [_editByNameTitleLabel removeFromSuperview];
        _editByNameTitleLabel = nil;
    }
    _editByNameTitleLabel = [[UILabel alloc] init];
    _editByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _editByNameTitleLabel.textColor = kTitleLabelTextColor;
    _editByNameTitleLabel.numberOfLines = 0;
    _editByNameTitleLabel.backgroundColor = [UIColor clearColor];
    _editByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_editByNameLabel){
        [_editByNameLabel removeFromSuperview];
        _editByNameLabel = nil;
    }
    _editByNameLabel = [[UILabel alloc] init];
    _editByNameLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _editByNameLabel.textColor = kConclusionLabelTextColor;
    _editByNameLabel.numberOfLines = 0;
    _editByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _editByNameLabel.backgroundColor = [UIColor clearColor];
    _editByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedByNameTitleLabel){
        [_approvedByNameTitleLabel removeFromSuperview];
        _approvedByNameTitleLabel = nil;
    }
    _approvedByNameTitleLabel = [[UILabel alloc] init];
    _approvedByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _approvedByNameTitleLabel.textColor = kTitleLabelTextColor;
    _approvedByNameTitleLabel.numberOfLines = 0;
    _approvedByNameTitleLabel.backgroundColor = [UIColor clearColor];
    _approvedByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedByNameLabel){
        [_approvedByNameLabel removeFromSuperview];
        _approvedByNameLabel = nil;
    }
    _approvedByNameLabel = [[UILabel alloc] init];
    _approvedByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    _approvedByNameLabel.textColor = kApprovedByNameLabelTextColor;
    _approvedByNameLabel.numberOfLines = 0;
    _approvedByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _approvedByNameLabel.backgroundColor = [UIColor clearColor];
    _approvedByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    _detailLabel.textColor = kColorWithRGB(132, 142, 153);
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_wyspBtn){
        [_wyspBtn removeFromSuperview];
        _wyspBtn = nil;
    }
    _wyspBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wyspBtn setTitle:@"我要审批" forState:UIControlStateNormal];
    [_wyspBtn setTitle:@"我要审批" forState:UIControlStateHighlighted];
    [_wyspBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_wyspBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_wyspBtn addTarget:self action:@selector(wyspBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCXIDGConferenceInformationListModel:(CXIDGConferenceInformationListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    
    _opinionTypeNameLabel.text = !_model.opinionTypeName||[_model.opinionTypeName length] <= 0?@" ":_model.opinionTypeName;
    CGSize opinionTypeNameLabelSize = [_opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - (kLabelLeftSpace + kmargin), MAXFLOAT)];
    _opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace - kLabelLeftSpace , opinionTypeNameLabelSize.height);
    [self.contentView addSubview:_opinionTypeNameLabel];
    
    _opinionDateTitleLabel.text = @"日 期";
    [_opinionDateTitleLabel sizeToFit];
    _opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, _opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_opinionDateTitleLabel];
    
    _opinionDateLabel.text = !_model.opinionDate||[_model.opinionDate length] <= 0?@" ":_model.opinionDate;
    CGSize opinionDateLabelSize = [_opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_opinionDateTitleLabel.frame), MAXFLOAT)];
    _opinionDateLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_opinionDateTitleLabel.frame), opinionDateLabelSize.height);
    [self.contentView addSubview:_opinionDateLabel];
    
    _conclusionTitleLabel.text = @"结 论";
    [_conclusionTitleLabel sizeToFit];
    _conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, _conclusionTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_conclusionTitleLabel];
    
    _conclusionLabel.text = !_model.conclusion||[_model.conclusion length] <= 0?@" ":_model.conclusion;
    CGSize conclusionLabelSize = [_conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - 3*kLabelLeftSpace - CGRectGetMaxX(_conclusionTitleLabel.frame), MAXFLOAT)];
    _conclusionLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - 3*kLabelLeftSpace - CGRectGetMaxX(_conclusionTitleLabel.frame), conclusionLabelSize.height);
    [self.contentView addSubview:_conclusionLabel];
    
    _detailLabel.text = @"会议详情>>";
    [_detailLabel sizeToFit];
    _detailLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace, _detailLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_detailLabel];
    
    _editByNameTitleLabel.text = @"维护人";
    [_editByNameTitleLabel sizeToFit];
    _editByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_detailLabel.frame) + kLabelTopSpace, _editByNameTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_editByNameTitleLabel];
    
    _editByNameLabel.text = !_model.editByName||[_model.editByName length] <= 0?@" ":_model.editByName;
    CGSize editByNameLabelSize = [_editByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_editByNameTitleLabel.frame), MAXFLOAT)];
    _editByNameLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_detailLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_editByNameTitleLabel.frame), editByNameLabelSize.height);
    [self.contentView addSubview:_editByNameLabel];
    
    _approvedByNameTitleLabel.text = @"审批人";
    [_approvedByNameTitleLabel sizeToFit];
    _approvedByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace, _approvedByNameTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_approvedByNameTitleLabel];
    
    _approvedByNameLabel.text = !_model.approvedByName||[_model.approvedByName length] <= 0?@" ":_model.approvedByName;
    CGSize approvedByNameLabelSize = [_approvedByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_approvedByNameTitleLabel.frame), MAXFLOAT)];
    _approvedByNameLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(_approvedByNameTitleLabel.frame), approvedByNameLabelSize.height);
    [self.contentView addSubview:_approvedByNameLabel];
    
    if(_model.team && [_model.team count] > 0 && [_model.team containsObject:VAL_Account] && (!_model.approvedByName || (_model.approvedByName && [_model.approvedByName length] <= 0))){
        _wyspBtn.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace - 20, 60, kTitleLabelFontSize + 40);
        _wyspBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        [self.contentView addSubview:_wyspBtn];
    }else{
        _wyspBtn.frame = CGRectZero;
    }
    
//    if(_detailImageView){
//        [_detailImageView removeFromSuperview];
//        _detailImageView = nil;
//    }
//    _detailImageView = [[UIImageView alloc] init];
//    _detailImageView.frame = CGRectMake(Screen_Width - kLabelLeftSpace - 10.0, (CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace + approvedByNameLabelSize.height + kLabelTopSpace - 17.4)/2, 10.0, 17.4);
//    _detailImageView.image = [UIImage imageNamed:@"DetailImg"];
//    _detailImageView.highlightedImage = [UIImage imageNamed:@"DetailImg"];
//    [self addSubview:_detailImageView];
}

+ (CGFloat)getCXIDGConferenceInformationListTableViewCellHeightWithCXIDGConferenceInformationListModel:(CXIDGConferenceInformationListModel *)model
{
    
    UILabel * opinionTypeNameLabel = [[UILabel alloc] init];
    opinionTypeNameLabel.font = [UIFont boldSystemFontOfSize:kOpinionTypeNameLabelFontSize];
    opinionTypeNameLabel.numberOfLines = 0;
    opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionTypeNameLabel.text = !model.opinionTypeName||[model.opinionTypeName length] <= 0?@"111 ":model.opinionTypeName;
    CGSize opinionTypeNameLabelSize = [opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - (kLabelLeftSpace + kRedViewWidth + kRedViewRightSpace), MAXFLOAT)];
    opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace - kLabelLeftSpace , opinionTypeNameLabelSize.height);
    
    UILabel * opinionDateTitleLabel = [[UILabel alloc] init];
    opinionDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    opinionDateTitleLabel.text = @"日 期";
    [opinionDateTitleLabel sizeToFit];
    opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * opinionDateLabel = [[UILabel alloc] init];
    opinionDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    opinionDateLabel.numberOfLines = 0;
    opinionDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionDateLabel.text = !model.opinionDate||[model.opinionDate length] <= 0?@"111 ":model.opinionDate;
    CGSize opinionDateLabelSize = [opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(opinionDateTitleLabel.frame), MAXFLOAT)];
    opinionDateLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(opinionDateTitleLabel.frame), opinionDateLabelSize.height);
    
    UILabel * conclusionTitleLabel = [[UILabel alloc] init];
    conclusionTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    conclusionTitleLabel.text = @"结 论";
    [conclusionTitleLabel sizeToFit];
    conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, conclusionTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * conclusionLabel = [[UILabel alloc] init];
    conclusionLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    conclusionLabel.numberOfLines = 0;
    conclusionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    conclusionLabel.text = !model.conclusion||[model.conclusion length] <= 0?@"111 ":model.conclusion;
    CGSize conclusionLabelSize = [conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - 3*kLabelLeftSpace - CGRectGetMaxX(conclusionTitleLabel.frame), MAXFLOAT)];
    conclusionLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - 3*kLabelLeftSpace - CGRectGetMaxX(conclusionTitleLabel.frame), conclusionLabelSize.height);
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    detailLabel.text = @"会议详情>>";
    [detailLabel sizeToFit];
    detailLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace, detailLabel.size.width, kTitleLabelFontSize);
    
    UILabel * editByNameTitleLabel = [[UILabel alloc] init];
    editByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    editByNameTitleLabel.textColor = kTitleLabelTextColor;
    editByNameTitleLabel.numberOfLines = 0;
    editByNameTitleLabel.backgroundColor = [UIColor clearColor];
    editByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * editByNameLabel = [[UILabel alloc] init];
    editByNameLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    editByNameLabel.textColor = kConclusionLabelTextColor;
    editByNameLabel.numberOfLines = 0;
    editByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    editByNameLabel.backgroundColor = [UIColor clearColor];
    editByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * approvedByNameTitleLabel = [[UILabel alloc] init];
    approvedByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    approvedByNameTitleLabel.textColor = kTitleLabelTextColor;
    approvedByNameTitleLabel.numberOfLines = 0;
    approvedByNameTitleLabel.backgroundColor = [UIColor clearColor];
    approvedByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * approvedByNameLabel = [[UILabel alloc] init];
    approvedByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    approvedByNameLabel.textColor = kApprovedByNameLabelTextColor;
    approvedByNameLabel.numberOfLines = 0;
    approvedByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    approvedByNameLabel.backgroundColor = [UIColor clearColor];
    approvedByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    editByNameTitleLabel.text = @"维护人";
    [editByNameTitleLabel sizeToFit];
    editByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(detailLabel.frame) + kLabelTopSpace, editByNameTitleLabel.size.width, kTitleLabelFontSize);
    
    editByNameLabel.text = !model.editByName||[model.editByName length] <= 0?@" ":model.editByName;
    CGSize editByNameLabelSize = [editByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(approvedByNameLabel.frame), MAXFLOAT)];
    editByNameLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(detailLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(editByNameTitleLabel.frame), editByNameLabelSize.height);
    
    approvedByNameTitleLabel.text = @"审批人";
    [approvedByNameTitleLabel sizeToFit];
    approvedByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(editByNameLabel.frame) + kLabelTopSpace, approvedByNameTitleLabel.size.width, kTitleLabelFontSize);
    
    approvedByNameLabel.text = !model.approvedByName||[model.approvedByName length] <= 0?@" ":model.approvedByName;
    CGSize approvedByNameLabelSize = [approvedByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - CGRectGetMaxX(approvedByNameTitleLabel.frame), MAXFLOAT)];
    approvedByNameLabel.frame = CGRectMake(kLabelmargin, CGRectGetMaxY(editByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - CGRectGetMaxX(approvedByNameTitleLabel.frame), approvedByNameLabelSize.height);

    return CGRectGetMaxY(approvedByNameLabel.frame) + kLabelTopSpace;
}

- (void)wyspBtnClick{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确定本条信息的准确性！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat:@"%@/project/detail/approve/opinion", urlPrefix];
        NSMutableDictionary * params = @{}.mutableCopy;
        [params setValue:self.model.opinionId forKey:@"opinionId"];
        
        [HttpTool postWithPath:url params:params success:^(id JSON) {
            if ([JSON[@"status"] integerValue] == 200) {
                if (self.spwcCallBack) {
                    self.spwcCallBack();
                }
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }
}

@end
