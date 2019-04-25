//
// Created by ^ on 2017/11/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXVacationApplicationListCell.h"
#import "Masonry.h"
#import "CXVacationApplicationModel.h"

@interface CXVacationApplicationListCell ()
@property(strong, nonatomic) UILabel *approvalUserNameLabel;
@property(strong, nonatomic) UILabel *nameLabel;
/// 休假类型
@property(strong, nonatomic) UILabel *kindLabel;
/// 开始时间
@property(strong, nonatomic) UILabel *startTimeLabel;
/// 结束时间
@property(strong, nonatomic) UILabel *endTimeLabel;
/// 休假时长
@property(strong, nonatomic) UILabel *timeLabel;

@property(strong, nonatomic) UILabel *reasonLabel;//审批意见
@end

@implementation CXVacationApplicationListCell

#pragma mark -- setter && getter
- (void)setModel:(CXVacationApplicationModel *)model{
    _model = model;
//    self.nameLabel.text = [NSString stringWithFormat:@"%@的销假", [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithAccount:model.userName].name];
    if (model.signed_objc == 1) {//批审中
        self.approvalUserNameLabel.text = [NSString stringWithFormat:@"%@批审中",model.currentApprove];
        self.approvalUserNameLabel.textColor = kColorWithRGB(212.f, 115.f, 80.f);
        self.reasonLabel.text = @"";
    } else if(model.signed_objc  == 2){//批审通过
        self.approvalUserNameLabel.text = @"批审通过";
        self.approvalUserNameLabel.textColor = kColorWithRGB(56.f, 125.f, 19.f);
        self.reasonLabel.text = @"";
    }else if(model.signed_objc == 3){//批审驳回
        self.approvalUserNameLabel.text = @"批审驳回";
        self.approvalUserNameLabel.textColor = kColorWithRGB(189.f, 83.f, 85.f);
        self.reasonLabel.text = [NSString stringWithFormat:@"审批意见： %@",model.approveReason ? : @""];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@的请假", model.userName ? : model.name];
    _kindLabel.text = [NSString stringWithFormat:@"请假类型：%@", model.leaveType ? : model.holidayType];
    _startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@", model.leaveStart];
    _endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@", model.leaveEnd];
    _timeLabel.text = [NSString stringWithFormat:@"请假时长：%.1f天", model.leaveDay];
    //    self.reasonLabel.text = [NSString stringWithFormat:@"审批意见： "];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    CGFloat margin = 10.0;
    self.nameLabel = [self createLabelWithTextColor:[UIColor blackColor]];
    self.nameLabel.font = kFontSizeForDetail;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(margin);
    }];
    self.approvalUserNameLabel = [self createLabelWithTextColor:[UIColor blackColor]];
    self.approvalUserNameLabel.textAlignment = NSTextAlignmentRight;
    [self.approvalUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];
    self.kindLabel = [self createLabelWithTextColor:kColorWithRGB(158.f, 158.f, 158.f)];
    [self.kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(margin);
    }];
  
    self.startTimeLabel = [self createLabelWithTextColor:kColorWithRGB(158.f, 158.f, 158.f)];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kindLabel.mas_left);
        make.top.mas_equalTo(self.kindLabel.mas_bottom).mas_offset(margin);
    }];
    self.endTimeLabel = [self createLabelWithTextColor:kColorWithRGB(158.f, 158.f, 158.f)];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startTimeLabel.mas_left);
        make.top.mas_equalTo(self.startTimeLabel.mas_bottom).mas_offset(margin);
    }];
    self.timeLabel = [self createLabelWithTextColor:kColorWithRGB(158.f, 158.f, 158.f)];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endTimeLabel.mas_left);
        make.top.mas_equalTo(self.endTimeLabel.mas_bottom).mas_offset(margin);
    }];
    self.reasonLabel = [self createLabelWithTextColor:kColorWithRGB(158.f, 158.f, 158.f)];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(margin);
        make.bottom.mas_equalTo(-margin);
    }];
}

- (UILabel *)createLabelWithTextColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = kFontTimeSizeForForm;
    label.textColor = textColor ;
    [self.contentView addSubview:label];
    return label;
}
/*
#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIColor *bgColor = kColorWithRGB(158.f, 158.f, 158.f);

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontSizeForDetail;
        [self.contentView addSubview:_nameLabel];

        _approvalUserNameLabel = [[UILabel alloc] init];
        _approvalUserNameLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_approvalUserNameLabel];

        _kindLabel = [[UILabel alloc] init];
        _kindLabel.textColor = bgColor;
        _kindLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_kindLabel];

        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.font = kFontTimeSizeForForm;
        _startTimeLabel.textColor = bgColor;
        [self.contentView addSubview:_startTimeLabel];

        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textColor = bgColor;
        _endTimeLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_endTimeLabel];

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFontTimeSizeForForm;
        _timeLabel.textColor = bgColor;
        [self.contentView addSubview:_timeLabel];
        
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.font = kFontTimeSizeForForm;
        _reasonLabel.textColor = bgColor;
//        [self.contentView addSubview:_reasonLabel];

        [self setViewAtuoLayout];
    }
    return self;
}

- (void)setViewAtuoLayout {
    CGFloat margin = 10.f;

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(margin);
        make.top.equalTo(self.contentView.mas_top).offset(margin);
    }];

    [_approvalUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-margin);
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];

    [_kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset(margin);
    }];

    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kindLabel.mas_left);
        make.top.equalTo(_kindLabel.mas_bottom).offset(margin);
    }];

    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startTimeLabel.mas_left);
        make.top.equalTo(_startTimeLabel.mas_bottom).offset(margin);
    }];
    
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_endTimeLabel.mas_left);
//        make.top.equalTo(_endTimeLabel.mas_bottom).offset(margin);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-margin).priorityHigh();
//    }];

//    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_timeLabel.mas_left);
//        make.top.equalTo(_timeLabel.mas_bottom).offset(margin);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-margin).priorityHigh();
//    }];
}




- (void)setAction:(id)vacationApplicationModel {
    CXVacationApplicationModel *model = vacationApplicationModel;
    if (model.signed_objc == 3) {//驳回
        [self.contentView addSubview:self.reasonLabel];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_endTimeLabel.mas_left);
            make.top.equalTo(_endTimeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10).priorityHigh();
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_endTimeLabel.mas_left);
            make.top.equalTo(_endTimeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.reasonLabel.mas_top).with.offset(-10);
        }];
    
    } else {
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_endTimeLabel.mas_left);
            make.top.equalTo(_endTimeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10).priorityHigh();
        }];
    }
    _nameLabel.text = [NSString stringWithFormat:@"%@的请假", model.userName];
    _kindLabel.text = [NSString stringWithFormat:@"请假类型：%@", model.leaveType];
    _startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@", model.leaveStart];
    _endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@", model.leaveEnd];
    _timeLabel.text = [NSString stringWithFormat:@"请假时长：%.1f天", model.leaveDay];
//    _reasonLabel.text = [NSString stringWithFormat:@"审批意见：%@", @""];

    // 橙色
    UIColor *color_1 = kColorWithRGB(212.f, 115.f, 80.f);
    // 红色
    UIColor *color_2 = kColorWithRGB(189.f, 83.f, 85.f);
    // 绿色
    UIColor *color_3 = kColorWithRGB(56.f, 125.f, 19.f);

    if (model.signed_objc == 1) {
        // 审批中
        _approvalUserNameLabel.textColor = color_1;
        _approvalUserNameLabel.text = @"批审中";
        _reasonLabel.text = @"";
    }
    if (model.signed_objc == 2) {
        // 审批通过
        _approvalUserNameLabel.textColor = color_3;
        _approvalUserNameLabel.text = @"批审通过";
        _reasonLabel.text = @"";
    }

    if (model.signed_objc == 3) {
        // 审批驳回
        _approvalUserNameLabel.textColor = color_2;
        _approvalUserNameLabel.text = @"批审驳回";
        _reasonLabel.text = [NSString stringWithFormat:@"审批意见：%@", @""];
    }
}


*/
@end
