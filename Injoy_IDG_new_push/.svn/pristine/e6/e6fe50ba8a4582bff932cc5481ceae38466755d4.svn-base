//
//  CXYJNewColleaguesTableViewCell.m
//  InjoyYJ1
//
//  Created by wtz on 2017/9/5.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYJNewColleaguesTableViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "SDDataBaseHelper.h"
#import "SDContactsDetailController.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface CXYJNewColleaguesTableViewCell()

#define kNameFontSize 16.0
#define kTimeFontSize 15.0
#define kDeptNameFontSize 15.0
#define kJobFontSize 15.0
#define kNameBottomSpace (SDHeadWidth - kNameFontSize - kDeptNameFontSize - 4)

@property (nonatomic, strong) CXYJNewColleaguesModel * model;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *deptNameLabel;
@property (nonatomic,strong) UILabel *jobLabel;

@end

@implementation CXYJNewColleaguesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, CGRectGetMinY(_headImageView.frame) + 2, 300, kNameFontSize);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeFontSize];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 200, CGRectGetMinY(_nameLabel.frame) - (kNameFontSize - kTimeFontSize)/2, 200, kTimeFontSize);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    
    if(_deptNameLabel){
        [_deptNameLabel removeFromSuperview];
        _deptNameLabel = nil;
    }
    _deptNameLabel = [[UILabel alloc] init];
    _deptNameLabel.font = [UIFont systemFontOfSize:kDeptNameFontSize];
    _deptNameLabel.textColor = [UIColor blackColor];
    _deptNameLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kNameBottomSpace, 200, kDeptNameFontSize);
    _deptNameLabel.textAlignment = NSTextAlignmentLeft;
    
    
    if(_jobLabel){
        [_jobLabel removeFromSuperview];
        _jobLabel = nil;
    }
    _jobLabel = [[UILabel alloc] init];
    _jobLabel.font = [UIFont systemFontOfSize:kDeptNameFontSize];
    _jobLabel.textColor = [UIColor blackColor];
    _jobLabel.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 200, CGRectGetMinY(_deptNameLabel.frame), 200, kDeptNameFontSize);
    _jobLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)setYJNewColleaguesApplication:(CXYJNewColleaguesModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:_model.imAccount];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = userModel.name?userModel.name:(_model.name?_model.name:@"");
    [self.contentView addSubview:_nameLabel];

    _timeLabel.text = _model.joinTime;
    [self.contentView addSubview:_timeLabel];
    
    _deptNameLabel.text = userModel.deptName?userModel.deptName:_model.deptName;
    [self.contentView addSubview:_deptNameLabel];
    
    _jobLabel.text = userModel.job?userModel.job:_model.job;
    [self.contentView addSubview:_jobLabel];
}

@end
