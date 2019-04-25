//
//  CXBussinessTripListCell.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBussinessTripListCell.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "CXBussinessTripListModel.h"


#define margin 10.f
#define hmargin 8.f
#define cellWidth Screen_Width-2*margin
@interface CXBussinessTripListCell()
@property(nonatomic, strong)UILabel *nameLabel;
//@property(nonatomic, strong)UILabel *approvalUserNameLabel;
//@property(nonatomic, strong)UILabel *applyDateTitleLabel;
@property(nonatomic, strong)UILabel *applyDateLabel;
//@property(nonatomic, strong)UILabel *preMoneyTitleLabel;
@property(nonatomic, strong)UILabel *preMoneyLabel;
//@property(nonatomic, strong)UILabel *cityTitleLabel;
@property(nonatomic, strong)UILabel *cityLabel;
//@property(nonatomic, strong)UILabel *reasonTitleLabel;
@property(nonatomic, strong)UILabel *reasonLabel;
//@property(nonatomic, strong)UIView *line;
@property (nonatomic, strong) UILabel *opinionLabel;
@end

@implementation CXBussinessTripListCell

#pragma mark --setter && getter
- (void)setModel:(CXBussinessTripListModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@的出差",model.apply ? : @"zhangyi"];
    self.applyDateLabel.text = model.applyDate ? : @"2019-10-10";
    self.preMoneyLabel.text = [NSString stringWithFormat:@"%@",model.budget ? : @"200.00"];
    if (model.city == nil || model.city.count == 0) {
        self.cityLabel.text = @"";
    }else if(model.city.count == 1){
        self.cityLabel.text = model.city[0];
    }else{
        self.cityLabel.text = [model.city componentsJoinedByString:@","];
    }
//    self.cityLabel.text = model.city.count > 0 ? [model.city componentsJoinedByString:@","] : @"";
    self.reasonLabel.text = model.remark ? : @"这是一段长文本,长度达到一定时会多行显示,长度达到一定时会多行显示,长度达到一定时会多行显示,长度达到一定时会多行显示,";
//    self.opinionLabel.text = model.reason ? : @"";
    NSString *opinion = [NSString stringWithFormat:@"审批意见:%@",model. reason];
    
    
    if (model.isApprove == 3) {//驳回
        NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"审批意见:  %@",model.reason]];
        NSDictionary * attris = @{NSForegroundColorAttributeName:RGBACOLOR(55, 55, 55, 1)};
        [mutableAttriStr setAttributes:attris range:NSMakeRange(0,5)];
        self.opinionLabel.attributedText = mutableAttriStr;
        
    } else {
        self.opinionLabel.text = @"";
    }
}

#pragma mark --instancetype
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
////        [self setUpUI];
//        [self setupSubview];
//    }
//    return self;
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    //姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = RGBACOLOR(55, 55, 55, 1);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.text = @"的申请";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(10);
    }];
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.text = @"申请日期:";
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = RGBACOLOR(55, 55, 55, 1);
    [self.contentView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    self.applyDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.applyDateLabel.text = @"2018-09-12";
    self.applyDateLabel.font = [UIFont systemFontOfSize:15];
    self.applyDateLabel.textColor = RGBACOLOR(158, 158, 158, 1);
    [self.contentView addSubview:self.applyDateLabel];
    [self.applyDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(dateLabel.mas_right);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-margin);
    }];
    //金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.text = @"出差金额预算(元):";
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = RGBACOLOR(55, 55, 55, 1);
    [self.contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
        make.top.mas_equalTo(self.applyDateLabel.mas_bottom).mas_offset(0);
    }];
    self.preMoneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.preMoneyLabel.text = @"2018";
    self.preMoneyLabel.font = [UIFont systemFontOfSize:15];
    self.preMoneyLabel.textColor = RGBACOLOR(158, 158, 158, 1);
    [self.contentView addSubview:self.preMoneyLabel];
    [self.preMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(moneyLabel.mas_right);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(dateLabel.mas_bottom).mas_offset(0);
    }];
    //出差城市
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cityLabel.text = @"出差城市:";
    cityLabel.font = [UIFont systemFontOfSize:15];
    cityLabel.textColor = RGBACOLOR(55, 55, 55, 1);
    [self.contentView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
        make.top.mas_equalTo(moneyLabel.mas_bottom).mas_offset(0);
    }];
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cityLabel.text = @"2018";
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    self.cityLabel.textColor = RGBACOLOR(158, 158, 158, 1);
    [self.contentView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cityLabel.mas_right);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(self.preMoneyLabel.mas_bottom).mas_offset(0);
    }];
    //出差事由
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    reasonLabel.font = [UIFont systemFontOfSize:15];
    reasonLabel.text = @"出差事由:";
    reasonLabel.textColor = RGBACOLOR(55, 55, 55, 1);
    [self.contentView addSubview:reasonLabel];
    [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cityLabel.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(cityLabel.mas_left);
        make.width.mas_equalTo(70);
    }];
    //理由
    self.reasonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reasonLabel.numberOfLines = 0;
    self.reasonLabel.font = [UIFont systemFontOfSize:15];
    self.reasonLabel.textColor = RGBACOLOR(158, 158, 158, 1);
    [self.contentView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reasonLabel.mas_top);
        make.left.mas_equalTo(reasonLabel.mas_right);
//        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-margin);
    }];
    //审批意见
    self.opinionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.opinionLabel.numberOfLines = 0;
    //    self.reasonLabel.backgroundColor = [UIColor blueColor];
    self.opinionLabel.font = [UIFont systemFontOfSize:15];
    self.opinionLabel.textColor = RGBACOLOR(158, 158, 158, 1);
    [self.contentView addSubview:self.opinionLabel];
    [self.opinionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).mas_offset(13);//
        make.left.mas_equalTo(reasonLabel.mas_left);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-margin);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, self.frame.size.height-1, Screen_Width-20, 0.5);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}
#pragma mark -- 废弃
/*
-(void)setUpUI{
    UIColor *bgColor = kColorWithRGB(158.f, 158.f, 158.f);
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = kFontSizeForDetail;
    [self.contentView addSubview:_nameLabel];
    
    _approvalUserNameLabel = [[UILabel alloc] init];
    _approvalUserNameLabel.font = kFontTimeSizeForForm;
    _approvalUserNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_approvalUserNameLabel];
    
    _applyDateTitleLabel = [[UILabel alloc]init];
    _applyDateTitleLabel.font = kFontTimeSizeForForm;
    _applyDateTitleLabel.text = @"申请日期：";
    [_applyDateTitleLabel sizeToFit];
    [self.contentView addSubview:_applyDateTitleLabel];
    
    _applyDateLabel = [[UILabel alloc] init];
    _applyDateLabel.textColor = bgColor;
    _applyDateLabel.numberOfLines = 0;
    _applyDateLabel.font = kFontTimeSizeForForm;
    [self.contentView addSubview:_applyDateLabel];
    
    _preMoneyTitleLabel = [[UILabel alloc]init];
    _preMoneyTitleLabel.text = @"出差金额预算(元)：";
    _preMoneyTitleLabel.font = kFontTimeSizeForForm;
    [_preMoneyTitleLabel sizeToFit];
    [self.contentView addSubview:_preMoneyTitleLabel];
    
    _preMoneyLabel = [[UILabel alloc] init];
    _preMoneyLabel.font = kFontTimeSizeForForm;
    _preMoneyLabel.textColor = bgColor;
    _preMoneyLabel.numberOfLines = 0;
    [self.contentView addSubview:_preMoneyLabel];
    
    _cityTitleLabel = [[UILabel alloc]init];
    _cityTitleLabel.font = kFontTimeSizeForForm;
    _cityTitleLabel.text = @"出差城市：";
    [_cityTitleLabel sizeToFit];
    [self.contentView addSubview:_cityTitleLabel];
    
    _cityLabel = [[UILabel alloc] init];
    _cityLabel.textColor = bgColor;
    _cityLabel.font = kFontTimeSizeForForm;
    _cityLabel.numberOfLines = 0;
    [self.contentView addSubview:_cityLabel];
    
    _reasonTitleLabel = [[UILabel alloc]init];
    _reasonTitleLabel.font = kFontTimeSizeForForm;
    _reasonTitleLabel.text = @"出差事由：";
    [_reasonTitleLabel sizeToFit];
    [self.contentView addSubview:_reasonTitleLabel];
    
    _reasonLabel = [[UILabel alloc] init];
    _reasonLabel.font = kFontTimeSizeForForm;
    _reasonLabel.textColor = bgColor;
    _reasonLabel.numberOfLines = 0;
    [self.contentView addSubview:_reasonLabel];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = kColorWithRGB(163, 163, 163);
    [self.contentView addSubview:_line];
}

-(void)setContentWithModel:(CXBussinessTripListModel *)model{
   
//    _nameLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@的出差",model.realName] andFont:kFontSizeForDetail];

    _nameLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@的出差",model.apply] andFont:kFontSizeForDetail];
    _applyDateLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@",model.applyDate] andFont:kFontTimeSizeForForm];
    _preMoneyLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@",model.budget.stringValue] andFont:kFontTimeSizeForForm];
    _cityLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@", model.cityName] andFont:kFontTimeSizeForForm];
    _reasonLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@", model.remark]  andFont:kFontTimeSizeForForm];
    // 橙色
    UIColor *color_1 = kColorWithRGB(212.f, 115.f, 80.f);
    // 红色
    UIColor *color_2 = kColorWithRGB(189.f, 83.f, 85.f);
    // 绿色
    UIColor *color_3 = kColorWithRGB(56.f, 125.f, 19.f);
    if(model.isApprove == 1){
        _approvalUserNameLabel.text = @"批审中";
        _approvalUserNameLabel.textColor = color_1;
    }else if (model.isApprove == 2){
        _approvalUserNameLabel.text = @"批审通过";
        _approvalUserNameLabel.textColor = color_3;
    }else if (model.isApprove == 3){
        _approvalUserNameLabel.text = @"批审驳回";
        _approvalUserNameLabel.textColor = color_2;
    }
   
}
- (void)settingFrame{
   
    self.nameLabel.frame = self.dataFrame.nameLabelF;
    self.approvalUserNameLabel.frame = self.dataFrame.approvalLabelF;
    self.applyDateTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.nameLabel.frame), _applyDateTitleLabel.frame.size.width, _applyDateTitleLabel.frame.size.height);
    self.applyDateLabel.frame = self.dataFrame.approvalDateLabelF;
    self.preMoneyTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.applyDateLabel.frame)+hmargin, _preMoneyTitleLabel.frame.size.width, _preMoneyTitleLabel.frame.size.height);
    self.preMoneyLabel.frame = self.dataFrame.preMoneyLabelF;
    
    self.cityTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.preMoneyLabel.frame)+hmargin, _cityTitleLabel.frame.size.width, _cityTitleLabel.frame.size.height);
    self.cityLabel.frame = self.dataFrame.cityLabelF;
    
    self.reasonTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.cityTitleLabel.frame) + hmargin, _reasonTitleLabel.frame.size.width, _reasonTitleLabel.frame.size.height);
    self.reasonLabel.frame = self.dataFrame.reasonLabelF;
    
    self.line.frame = self.dataFrame.lineF;
     
}
- (void)setDataFrame:(CXBussinessTripListCellFrame *)dataFrame{
    _dataFrame = dataFrame;
    [self settingFrame];
    [self setContentWithModel:_dataFrame.dataModel];
    
}
- (NSMutableAttributedString *)setString:(NSString *)str andFont:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *dic = @{NSFontAttributeName:font};
    
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    return setString;
}
 */

@end
