//
//  CXPotentialFollowListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPotentialFollowListTableViewCell.h"
#import "UIView+Category.h"
#import "UIView+YYAdd.h"
#import "CXAddPotentialFollowViewController.h"
#import "HttpTool.h"
#import "CXMetProjectDetailViewController.h"
#import "CXYMAppearanceManager.h"
#import "Masonry.h"
#import "NSDate+CXYMCategory.h"

@interface CXPotentialFollowListTableViewCell()<UIAlertViewDelegate>

@property (nonatomic, strong) CXPotentialFollowListModel * model;
@property (nonatomic, strong) UILabel * timeTitleLabel;
@property (nonatomic, strong) UILabel * timeContentLabel;
@property (nonatomic, strong) UILabel * gjrTitleLabel;
@property (nonatomic, strong) UILabel * gjrContentLabel;
@property (nonatomic, strong) UILabel * keynoteTitleLabel;
@property (nonatomic, strong) UILabel * keynoteContentLabel;
@property (nonatomic, strong) UILabel * gjztTitleLabel;
@property (nonatomic, strong) UILabel * gjztContentLabel;
@property (nonatomic, strong) UIView * bottomLineView;
@property (nonatomic, strong) UIImageView * editImageView;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, strong) UIImageView * deleteImageView;
@property (nonatomic, strong) UIButton * deleteBtn;

@end

@implementation CXPotentialFollowListTableViewCell
#define contentLabelLeftMargin (143 * uinitPx)
#define contentLabelFont [UIFont systemFontOfSize:14.f]
#define contentLabelTextColor kColorWithRGB(31, 34, 40)
#define titleLabelTextColor kColorWithRGB(132, 142, 153)
#define rowmargin (6.0 * uinitPx)
#define rowHeight (20*uinitPx)
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
//        [self layoutCell];
        [self setupSubview];
    }
    return self;
}

- (NSString *)followStstueWithKey:(NSString *)key{
    NSDictionary *dic = @{@"WS":@"观望",
                          @"flowUp":@"继续跟进",
                          @"abandon":@"放弃"};
    return dic[key] ? : @"";
}
-(void)setPotentialFollowListModel:(CXPotentialFollowListModel *)PotentialFollowListModel{
    _PotentialFollowListModel = PotentialFollowListModel;
//    _timeContentLabel.text = PotentialFollowListModel.devDate;
    _timeContentLabel.text = [self subDateWithTimeString:PotentialFollowListModel.devDate];
//    _timeContentLabel.text = [self yyyyMMddWithDate:PotentialFollowListModel.devDate];
    _gjrContentLabel.text = PotentialFollowListModel.followPerson;
    _gjztContentLabel.text =  [self followStstueWithKey:PotentialFollowListModel.invFlowUp];
    _keynoteContentLabel.text = PotentialFollowListModel.keyNote;
}
- (NSString *)subDateWithTimeString:(NSString *)dateTimeString{
    if(dateTimeString && [dateTimeString length] > 9){
        NSString * year = [dateTimeString substringToIndex:4];
        NSString * month = [dateTimeString substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [dateTimeString substringWithRange:NSMakeRange(8, 2)];
        return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }
    return @" ";
}

- (void)setupSubview{
    NSLog(@"%@===%@",self.model,self.PEPotentialProjectModel);
    CGFloat leftMargin = 100.0;
    CGFloat heightForRow = 30.0;

    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeTitleLabel.text = @"日期";
    timeTitleLabel.font = [CXYMAppearanceManager textMediumFont];
    timeTitleLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [self.contentView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(heightForRow);
        make.top.mas_equalTo(0);
    }];
    UILabel *gjrTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    gjrTitleLabel.text = @"与会者";
    gjrTitleLabel.font = [CXYMAppearanceManager textMediumFont];
    gjrTitleLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [self.contentView addSubview:gjrTitleLabel];
    [gjrTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(heightForRow);
        make.top.mas_equalTo(timeTitleLabel.mas_bottom).mas_offset(0);
    }];
    UILabel *gjztTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    gjztTitleLabel.text = @"跟进状态";
    gjztTitleLabel.font = [CXYMAppearanceManager textMediumFont];
    gjztTitleLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [self.contentView addSubview:gjztTitleLabel];
    [gjztTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(heightForRow);
        make.top.mas_equalTo(gjrTitleLabel.mas_bottom).mas_offset(0);
    }];
    UILabel *keynoteTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keynoteTitleLabel.text = @"Keynote";
    keynoteTitleLabel.font = [CXYMAppearanceManager textMediumFont];
    keynoteTitleLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    [self.contentView addSubview:keynoteTitleLabel];
    [keynoteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.height.mas_equalTo(heightForRow);
        make.top.mas_equalTo(gjztTitleLabel.mas_bottom).mas_offset(0);
    }];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [editButton setBackgroundImage:[UIImage imageNamed:@"icon_edit"] forState:0];
    [editButton addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeTitleLabel);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.width.height.mas_equalTo(20);
    }];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:0];
    [deleteButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeTitleLabel);
        make.right.mas_equalTo(editButton.mas_left).mas_offset(-[CXYMAppearanceManager appStyleMargin]);
        make.width.height.mas_equalTo(20);
    }];
    
    self.timeContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeContentLabel.font = [CXYMAppearanceManager textMediumFont];
    self.timeContentLabel.textColor = [CXYMAppearanceManager textNormalColor];
    [self.contentView addSubview:self.timeContentLabel];
    [self.timeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargin);
        make.height.mas_equalTo(heightForRow);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-leftMargin);
    }];
    self.gjrContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.gjrContentLabel.font = [CXYMAppearanceManager textMediumFont];
    self.gjrContentLabel.textColor = [CXYMAppearanceManager textNormalColor];
    [self.contentView addSubview:self.gjrContentLabel];
    [self.gjrContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(self.timeContentLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(heightForRow);
        make.right.mas_equalTo(-leftMargin);
    }];
    self.gjztContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.gjztContentLabel.font = [CXYMAppearanceManager textMediumFont];
    self.gjztContentLabel.textColor = [CXYMAppearanceManager textNormalColor];
    [self.contentView addSubview:self.gjztContentLabel];
    [self.gjztContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(self.gjrContentLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(heightForRow);
        make.right.mas_equalTo(-leftMargin);
    }];
    self.keynoteContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.keynoteContentLabel.numberOfLines = 0;
    self.keynoteContentLabel.font = [CXYMAppearanceManager textMediumFont];
    self.keynoteContentLabel.textColor = [CXYMAppearanceManager textNormalColor];
    [self.contentView addSubview:self.keynoteContentLabel];
    [self.keynoteContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(self.gjztContentLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
        make.bottom.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
    }];
    
}
- (void)layoutCell
{
    if(_timeTitleLabel){
        [_timeTitleLabel removeFromSuperview];
        _timeTitleLabel = nil;
    }
    _timeTitleLabel = [[UILabel alloc] init];
    _timeTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _timeTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    _timeTitleLabel.backgroundColor = [UIColor clearColor];
    _timeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_timeContentLabel){
        [_timeContentLabel removeFromSuperview];
        _timeContentLabel = nil;
    }
    _timeContentLabel = [[UILabel alloc] init];
    _timeContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _timeContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    _timeContentLabel.backgroundColor = [UIColor clearColor];
    _timeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_gjrTitleLabel){
        [_gjrTitleLabel removeFromSuperview];
        _gjrTitleLabel = nil;
    }
    _gjrTitleLabel = [[UILabel alloc] init];
    _gjrTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _gjrTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    _gjrTitleLabel.backgroundColor = [UIColor clearColor];
    _gjrTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_gjrContentLabel){
        [_gjrContentLabel removeFromSuperview];
        _gjrContentLabel = nil;
    }
    _gjrContentLabel = [[UILabel alloc] init];
    _gjrContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _gjrContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    _gjrContentLabel.backgroundColor = [UIColor clearColor];
    _gjrContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_gjztTitleLabel){
        [_gjztTitleLabel removeFromSuperview];
        _gjztTitleLabel = nil;
    }
    _gjztTitleLabel = [[UILabel alloc] init];
    _gjztTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _gjztTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    _gjztTitleLabel.backgroundColor = [UIColor clearColor];
    _gjztTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_gjztContentLabel){
        [_gjztContentLabel removeFromSuperview];
        _gjztContentLabel = nil;
    }
    _gjztContentLabel = [[UILabel alloc] init];
    _gjztContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _gjztContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    _gjztContentLabel.backgroundColor = [UIColor clearColor];
    _gjztContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_keynoteTitleLabel){
        [_keynoteTitleLabel removeFromSuperview];
        _keynoteTitleLabel = nil;
    }
    _keynoteTitleLabel = [[UILabel alloc] init];
    _keynoteTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    _keynoteTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    _keynoteTitleLabel.backgroundColor = [UIColor clearColor];
    _keynoteTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_keynoteContentLabel){
        [_keynoteContentLabel removeFromSuperview];
        _keynoteContentLabel = nil;
    }
    _keynoteContentLabel = [[UILabel alloc] init];
    _keynoteContentLabel.numberOfLines = 0;
    _keynoteContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _keynoteContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    [_keynoteContentLabel sizeToFit];
    _keynoteContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    _keynoteContentLabel.backgroundColor = [UIColor clearColor];
    _keynoteContentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_bottomLineView){
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGBACOLOR(239.0, 239.0, 239.0, 1.0);
    
    if(_editImageView){
        [_editImageView removeFromSuperview];
        _editImageView = nil;
    }
    _editImageView = [[UIImageView alloc] init];
    _editImageView.image = [UIImage imageNamed:@"icon_edit"];
    _editImageView.highlightedImage = [UIImage imageNamed:@"icon_edit"];
    
    if(_deleteImageView){
        [_deleteImageView removeFromSuperview];
        _deleteImageView = nil;
    }
    _deleteImageView = [[UIImageView alloc] init];
    _deleteImageView.image = [UIImage imageNamed:@"icon_delete"];
    _deleteImageView.highlightedImage = [UIImage imageNamed:@"icon_delete"];
    
    if(_editBtn){
        [_editBtn removeFromSuperview];
        _editBtn = nil;
    }
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_deleteBtn){
        [_deleteBtn removeFromSuperview];
        _deleteBtn = nil;
    }
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editBtnClick
{
    CXAddPotentialFollowViewController *vc = [[CXAddPotentialFollowViewController alloc] initWithFormType:CXFormTypeModify AndModel:self.model AndCXPEPotentialProjectModel:self.PEPotentialProjectModel];
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    if ([self.parentVC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.parentVC.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)deleteBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要删除这条跟进情况吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)setCXPotentialFollowListModel:(CXPotentialFollowListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    return;
    CGFloat leftMargin = 15.f * uinitPx ;
    //跟进情况
    _timeTitleLabel.text = @"日期";
    [_timeTitleLabel sizeToFit];
    _timeTitleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, _timeTitleLabel.size.width, rowHeight);
    [self.contentView addSubview:_timeTitleLabel];
    
    if(_model.devDate){
        // timeStampString 是服务器返回的13位时间戳
        NSString *timeStampString = _model.devDate;
        // iOS 生成的时间戳是10位
        NSTimeInterval interval =[timeStampString doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        _timeContentLabel.text = dateString;
    }
    CGFloat x,width;
    if(_timeTitleLabel.frame.size.width > contentLabelLeftMargin){
        x = _timeTitleLabel.right + leftMargin;
        width = Screen_Width - _timeTitleLabel.right - 2*leftMargin;
    }else{
        x = contentLabelLeftMargin;
        width = Screen_Width - leftMargin - contentLabelLeftMargin;
    }
    _timeContentLabel.frame = CGRectMake(x, kLabelTopSpace, width - 29*2*uinitPx, rowHeight);
    [self.contentView addSubview:_timeContentLabel];
    
    _editImageView.frame = CGRectMake(Screen_Width - leftMargin - 19.0 * uinitPx, kLabelTopSpace, 19.0*uinitPx, 19.0*uinitPx);
    [self.contentView addSubview:_editImageView];
    
    _editBtn.frame = CGRectMake(Screen_Width - leftMargin - 19.0*uinitPx - 5.0*uinitPx, kLabelTopSpace - 15.0*uinitPx, 19.0*uinitPx + 10.0*uinitPx, 19.0*uinitPx + 20.0*uinitPx);
    [self.contentView addSubview:_editBtn];
    
    _deleteImageView.frame = CGRectMake(Screen_Width - leftMargin - 19.0*uinitPx - 15.0*uinitPx - 19.0*uinitPx, kLabelTopSpace, 19.0*uinitPx, 19.0*uinitPx);
    [self.contentView addSubview:_deleteImageView];
    
    _deleteBtn.frame = CGRectMake(Screen_Width - leftMargin - (19.0 + 15.0 + 19.0 + 5.0) * uinitPx, kLabelTopSpace - 15.0 * uinitPx, (19.0 + 10.0)*uinitPx, (19.0 + 20.0)*uinitPx);
    [self.contentView addSubview:_deleteBtn];
    

    
    _gjrTitleLabel.text = @"与会者";
    [_gjrTitleLabel sizeToFit];
    _gjrTitleLabel.frame = CGRectMake(leftMargin, _timeTitleLabel.bottom + kLabelTopSpace, _gjrTitleLabel.size.width, rowHeight);
    [self.contentView addSubview:_gjrTitleLabel];
    
    if(_gjrTitleLabel.frame.size.width > contentLabelLeftMargin){
        x = _gjrTitleLabel.right + leftMargin;
        width = Screen_Width - _gjrTitleLabel.right - 2*leftMargin;
    }else{
        x = contentLabelLeftMargin;
        width = Screen_Width - leftMargin - contentLabelLeftMargin;
    }
    _gjrContentLabel.text = _model.followPerson;
    _gjrContentLabel.frame = CGRectMake(x, _timeTitleLabel.bottom + kLabelTopSpace, width, rowHeight);
    [self.contentView addSubview:_gjrContentLabel];
    
    _gjztTitleLabel.text = @"跟进状态";
    [_gjztTitleLabel sizeToFit];
    _gjztTitleLabel.frame = CGRectMake(leftMargin, _gjrTitleLabel.bottom + kLabelTopSpace, _gjztTitleLabel.size.width, rowHeight);
    [self.contentView addSubview:_gjztTitleLabel];
   
    if(_gjztTitleLabel.frame.size.width > contentLabelLeftMargin){
        x = _gjztTitleLabel.right + leftMargin;
        width = Screen_Width - _gjztTitleLabel.right - 2*leftMargin;
    }else{
        x = contentLabelLeftMargin;
        width = Screen_Width - leftMargin - contentLabelLeftMargin;
    }
    if([_model.invFlowUp isEqualToString:@"flowUp"]){
        _gjztContentLabel.text = @"继续跟进";
    }else if([_model.invFlowUp isEqualToString:@"abandon"]){
        _gjztContentLabel.text = @"放弃";
    }else if([_model.invFlowUp isEqualToString:@"WS"]){
       _gjztContentLabel.text = @"观望";
    }

    
    _gjztContentLabel.frame = CGRectMake(x, _gjrTitleLabel.bottom + kLabelTopSpace, width, rowHeight);
    [self.contentView addSubview:_gjztContentLabel];
    
    _keynoteTitleLabel.text = @"Keynote";
    [_keynoteTitleLabel sizeToFit];
    _keynoteTitleLabel.frame = CGRectMake(leftMargin, _gjztTitleLabel.bottom + kLabelTopSpace, _keynoteTitleLabel.size.width, rowHeight);
    [self.contentView addSubview:_keynoteTitleLabel];
    
    if(_keynoteTitleLabel.frame.size.width > contentLabelLeftMargin){
        x = _keynoteTitleLabel.right + leftMargin;
        width = Screen_Width - _keynoteTitleLabel.right - 2*leftMargin;
    }else{
        x = contentLabelLeftMargin;
        width = Screen_Width - leftMargin - contentLabelLeftMargin;
    }
    _keynoteContentLabel.text = _model.keyNote ?:@" ";
//    CGSize keynoteContentLabelSize = [_keynoteContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - _timeTitleLabel.right, MAXFLOAT)];
//    NSLog(@"keynoteContentLabelSize==%f",keynoteContentLabelSize.height);
    CGSize rect = [_model.keyNote boundingRectWithSize:CGSizeMake(Screen_Width - leftMargin - _timeTitleLabel.right, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size;
    NSLog(@"rect==%f",rect.height);
    CGSize keynoteContentLabelSize = rect;
    _keynoteContentLabel.frame = CGRectMake(x, _gjztTitleLabel.bottom + kLabelTopSpace, width, keynoteContentLabelSize.height);
    NSLog(@"frame==%@",@(_keynoteContentLabel.frame));

    [self.contentView addSubview:_keynoteContentLabel];
    
    _bottomLineView.frame = CGRectMake(0, 6*kLabelTopSpace + 3*rowHeight + keynoteContentLabelSize.height, Screen_Width, 1.0);
    NSLog(@"bottomLineView===%f",_bottomLineView.bottom);
    [self.contentView addSubview:_bottomLineView];
}

+ (CGFloat)getCellHeightWithCXPotentialFollowListModel:(CXPotentialFollowListModel *)model
{
    UILabel * timeTitleLabel = [[UILabel alloc] init];
    timeTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    timeTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    timeTitleLabel.backgroundColor = [UIColor clearColor];
    timeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * timeContentLabel = [[UILabel alloc] init];
    timeContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    timeContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    timeContentLabel.backgroundColor = [UIColor clearColor];
    timeContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * gjrTitleLabel = [[UILabel alloc] init];
    gjrTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    gjrTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    gjrTitleLabel.backgroundColor = [UIColor clearColor];
    gjrTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * gjrContentLabel = [[UILabel alloc] init];
    gjrContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    gjrContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    gjrContentLabel.backgroundColor = [UIColor clearColor];
    gjrContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * gjztTitleLabel = [[UILabel alloc] init];
    gjztTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    gjztTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    gjztTitleLabel.backgroundColor = [UIColor clearColor];
    gjztTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * gjztContentLabel = [[UILabel alloc] init];
    gjztContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    gjztContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    gjztContentLabel.backgroundColor = [UIColor clearColor];
    gjztContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * keynoteTitleLabel = [[UILabel alloc] init];
    keynoteTitleLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    keynoteTitleLabel.textColor = titleLabelTextColor;//kFollowTitleTextColor;
    keynoteTitleLabel.backgroundColor = [UIColor clearColor];
    keynoteTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * keynoteContentLabel = [[UILabel alloc] init];
    keynoteContentLabel.numberOfLines = 0;
    keynoteContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    keynoteContentLabel.font = contentLabelFont;//[UIFont systemFontOfSize:kFollowTextFontSize];
    [keynoteContentLabel sizeToFit];
    keynoteContentLabel.textColor = contentLabelTextColor;//kFollowContentTextColor;
    keynoteContentLabel.backgroundColor = [UIColor clearColor];
    keynoteContentLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGBACOLOR(239.0, 239.0, 239.0, 1.0);
    
    CGFloat leftMargin = 15.f * uinitPx;
    timeTitleLabel.text = @"日期";
    [timeTitleLabel sizeToFit];
    timeTitleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, timeTitleLabel.size.width, rowHeight);
    
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString = model.devDate;
    // iOS 生成的时间戳是10位
    NSTimeInterval interval =[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    timeContentLabel.text = dateString;
    timeContentLabel.frame = CGRectMake(timeTitleLabel.right, kLabelTopSpace, Screen_Width - leftMargin - timeTitleLabel.right, rowHeight);
    
    gjrTitleLabel.text = @"与会者";
    [gjrTitleLabel sizeToFit];
    gjrTitleLabel.frame = CGRectMake(leftMargin, timeTitleLabel.bottom + kLabelTopSpace, gjrTitleLabel.size.width, rowHeight);
    
    gjrContentLabel.text = model.followPerson;
    gjrContentLabel.frame = CGRectMake(timeTitleLabel.right, timeTitleLabel.bottom + kLabelTopSpace, Screen_Width - leftMargin - gjrTitleLabel.right, rowHeight);
    
    gjztTitleLabel.text = @"跟进状态";
    [gjztTitleLabel sizeToFit];
    gjztTitleLabel.frame = CGRectMake(leftMargin, gjrTitleLabel.bottom + kLabelTopSpace, gjztTitleLabel.size.width, rowHeight);
    
    
    if([model.invFlowUp isEqualToString:@"flowUp"]){
        gjztContentLabel.text = @"继续跟进";
    }else if([model.invFlowUp isEqualToString:@"abandon"]){
        gjztContentLabel.text = @"放弃";
    }else if([model.invFlowUp isEqualToString:@"WS"]){
        gjztContentLabel.text = @"观望";
    }
    
    gjztContentLabel.frame = CGRectMake(gjztTitleLabel.right, gjrTitleLabel.bottom + kLabelTopSpace, Screen_Width - leftMargin - 19.0 - 15.0 - 19.0 - 5.0 - leftMargin - gjztTitleLabel.right, rowHeight);
    
    keynoteTitleLabel.text = @"Keynote";
    [keynoteTitleLabel sizeToFit];
    keynoteTitleLabel.frame = CGRectMake(leftMargin, gjztTitleLabel.bottom + kLabelTopSpace, keynoteTitleLabel.size.width, rowHeight);
    
    keynoteContentLabel.text = model.keyNote?:@"Keynote";
    CGSize keynoteContentLabelSize = [keynoteContentLabel sizeThatFits:CGSizeMake(Screen_Width - leftMargin - timeTitleLabel.right, MAXFLOAT)];
    CGSize rect = [keynoteContentLabel.text boundingRectWithSize:CGSizeMake(Screen_Width - leftMargin - timeTitleLabel.right, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabelFont} context:nil].size;
    NSLog(@"=====%f===%f",keynoteContentLabelSize.height,rect.height);
    keynoteContentLabelSize = rect;
    keynoteContentLabel.frame = CGRectMake(timeTitleLabel.right, gjztTitleLabel.bottom + kLabelTopSpace, Screen_Width - leftMargin - timeTitleLabel.right, keynoteContentLabelSize.height);
    NSLog(@"keynoteContentLabel==%@",@(keynoteContentLabel.frame));

    
    bottomLineView.frame = CGRectMake(0, 6*kLabelTopSpace + 3*rowHeight + keynoteContentLabelSize.height, Screen_Width, 1.0);
    NSLog(@"rowHeight ==== %f",bottomLineView.bottom);
    return bottomLineView.bottom;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat:@"%@/project/potential/follow/delete/%zd", urlPrefix,[self.model.devId integerValue]];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"删除成功!" duration:3.0 position:@"center"];
                [((CXMetProjectDetailViewController *)self.parentVC) loadData];
            } else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }
}

@end
