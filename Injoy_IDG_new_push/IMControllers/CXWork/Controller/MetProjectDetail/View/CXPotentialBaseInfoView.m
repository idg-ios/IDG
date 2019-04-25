//
//  CXPotentialBaseInfoView.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPotentialBaseInfoView.h"
#import "CXEditLabel.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@interface CXPotentialBaseInfoView()
@property (nonatomic, strong) UIScrollView *myContentScrollView;
@property (nonatomic, strong) UILabel *titleLabel;  ///<大大的基本资料
//项目名称
@property (nonatomic, strong) UILabel *projNameTitleLabel;///<项目名称
@property (nonatomic, strong) CXEditLabel *projNameLabel;///<项目名称
//当前轮次
@property (nonatomic, strong) UILabel *currentLCTitleLabel;///<当前轮次
@property (nonatomic, strong) CXEditLabel *currentLCLabel;
//约见状态
@property (nonatomic, strong) UILabel *metStatusTitleLabel;
@property (nonatomic, strong) CXEditLabel *metStatusLabel;
//行业
@property (nonatomic, strong) UILabel *industryTitleLabel;
@property (nonatomic, strong) CXEditLabel *industryLabel;
//投资机构
@property (nonatomic, strong) UILabel *investGroupTitleLabel;
@property (nonatomic, strong) CXEditLabel *investGroupLabel;
//城市
@property (nonatomic, strong) UILabel *cityTitleLabel;
@property (nonatomic, strong) CXEditLabel *cityLabel;
//跟进状态
@property (nonatomic, strong) UILabel *followStateTitleLabel;
@property (nonatomic, strong) CXEditLabel *followStateLabel;
//接触时间
@property (nonatomic, strong) UILabel *contactTimeTileLabel;
@property (nonatomic, strong) CXEditLabel *contactTimeLabel;
//负责人
@property (nonatomic, strong) UILabel *managerTitleLabel;
@property (nonatomic, strong) CXEditLabel *managerLabel;
//IDG资本投资情况
@property (nonatomic, strong) UILabel *capitalInvestTitleLabel;
@property (nonatomic, strong) CXEditLabel *capitalInvestLabel;
//重点项目
@property (nonatomic, strong) UILabel *importmentTitleLabel;
@property (nonatomic, strong) CXEditLabel *importmentLabel;
//业务介绍
@property (nonatomic, strong) UILabel *ywjsTitleLabel;
@property (nonatomic, strong) UILabel *ywjsLabel;
//大大的跟进情况
@property (nonatomic, strong) UILabel *followUpLabel;
@property (nonatomic, strong) UILabel *followUpContentLabel;

//添加跟进情况
@property (nonatomic, strong) UIButton *addFollowUpBtn;
//修改项目资料
@property (nonatomic, strong) UIButton *editProjectInfoButton;


@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *industryList;

@property (nonatomic, assign) BOOL isEdit;
@end
#define uintpx (Screen_Width/375.0)
#define leftMargin 15.f*uintpx
#define topMargin 10.f*uintpx
#define bigTitleHeight 37.f*uintpx
#define kLabelCellHeight 32.f*uintpx
#define kcontentLabelLeftmargin 143.f*uintpx
#define rowHeight (20 * uintpx)
#define rowMargin (6 * uintpx)

@implementation CXPotentialBaseInfoView{
    UIView *marginView;
    UIView *marginView2;
    CXPEPotentialProjectModel *_model;
}

/*
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (instancetype)initWithModel:(CXPEPotentialProjectModel *)model{
    self = [super init];
    if (self) {
        _model = model;
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    //基本资料
    UILabel *basicInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    basicInfoLabel.textColor = [CXYMAppearanceManager textNormalColor];
    basicInfoLabel.font = [CXYMAppearanceManager textSuperLagerFont];
    basicInfoLabel.text = @"基本资料";
    [self addSubview:basicInfoLabel];
    CGFloat margin = [CXYMAppearanceManager appStyleMargin];
    [basicInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.height.mas_equalTo(2 *margin);
        make.right.mas_equalTo(-margin);
    }];
    self.titleLabel = basicInfoLabel;
    UIColor *titleTextColor = [CXYMAppearanceManager textLightGrayColor];
    CGFloat titleFont =14;
    //项目名称
    self.projNameTitleLabel = [self createLabelWithTitle:@"项目名称" font:titleFont textColor:titleTextColor linkLabel:basicInfoLabel];
    
    self.projNameLabel = [[CXEditLabel alloc] initWithFrame:CGRectZero];
    self.projNameLabel.placeholder = @"请输入项目名称";
    self.projNameLabel.content = _model.projName;
    [self addSubview:self.projNameLabel];
    [self.projNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(basicInfoLabel.mas_bottom);
        make.left.mas_equalTo(kcontentLabelLeftmargin);
        make.height.mas_equalTo(kLabelCellHeight);
        make.right.mas_equalTo(-leftMargin);
    }];
    //当前轮次,currentLCTitleLabel
    self.currentLCTitleLabel = [self createLabelWithTitle:@"当前轮次" font:titleFont textColor:titleTextColor linkLabel:self.projNameTitleLabel];
    
    self.currentLCLabel = [self createEditLabelWithLinkEditLabel:self.projNameLabel];
    self.currentLCLabel.placeholder = @"请输入当前轮次";
    //约见状态,metStatusTitleLabel
    self.metStatusTitleLabel = [self createLabelWithTitle:@"约见状态" font:titleFont textColor:titleTextColor linkLabel:self.currentLCTitleLabel];
    
    self.metStatusLabel = [self createEditLabelWithLinkEditLabel:self.currentLCLabel];
    //行业,industryTitleLabel
    self.industryTitleLabel = [self createLabelWithTitle:@"行业" font:titleFont textColor:titleTextColor linkLabel:self.metStatusTitleLabel];
    
    self.industryLabel = [self createEditLabelWithLinkEditLabel:self.metStatusLabel];
    //投资机构,investGroupTitleLabel
    self.investGroupTitleLabel = [self createLabelWithTitle:@"投资机构" font:titleFont textColor:titleTextColor linkLabel:self.industryTitleLabel];
    
    self.investGroupLabel = [self createEditLabelWithLinkEditLabel:self.industryLabel];
    self.investGroupLabel.placeholder = @"请输入投资机构";
    //城市,cityTitleLabel
    self.cityTitleLabel = [self createLabelWithTitle:@"城市" font:titleFont textColor:titleTextColor linkLabel:self.investGroupTitleLabel];
    
    self.cityLabel = [self createEditLabelWithLinkEditLabel:self.investGroupLabel];
    self.cityLabel.placeholder = @"请输入城市";
    //跟进状态,followStateTitleLabel
    self.followStateTitleLabel = [self createLabelWithTitle:@"跟进状态" font:titleFont textColor:titleTextColor linkLabel:self.cityTitleLabel];
    
    self.followStateLabel = [self createEditLabelWithLinkEditLabel:self.cityLabel];
    //接触时间,contactTimeTileLabel
    self.contactTimeTileLabel = [self createLabelWithTitle:@"接触时间" font:titleFont textColor:titleTextColor linkLabel:self.followStateTitleLabel];
    
    self.contactTimeLabel = [self createEditLabelWithLinkEditLabel:self.followStateLabel];
    //负责人,managerTitleLabel
    self.managerTitleLabel = [self createLabelWithTitle:@"负责人" font:titleFont textColor:titleTextColor linkLabel:self.contactTimeTileLabel];
    
    self.managerLabel = [self createEditLabelWithLinkEditLabel:self.contactTimeLabel];
    self.currentLCLabel.placeholder = @"请输入负责人";
    //IDG基本投资情况,capitalInvestTitleLabel
    self.capitalInvestTitleLabel = [self createLabelWithTitle:@"IDG基本投资情况" font:titleFont textColor:titleTextColor linkLabel:self.managerTitleLabel];
    
    self.capitalInvestLabel = [self createEditLabelWithLinkEditLabel:self.managerLabel];
    //
    UILabel *firstSeparatorView = [[UILabel alloc] initWithFrame:CGRectZero];
    firstSeparatorView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    [self addSubview:firstSeparatorView];
    [firstSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.capitalInvestTitleLabel.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    //业务介绍
    UILabel *ywjsTitleLabel = [self createLabelWithTitle:@"业务介绍" font:titleFont textColor:titleTextColor linkLabel:firstSeparatorView];
    self.ywjsTitleLabel = ywjsTitleLabel;

    self.ywjsLabel = [[UILabel alloc] init];
    self.ywjsLabel.numberOfLines = 0;
    self.ywjsLabel.font = [UIFont systemFontOfSize:14.f];
    self.ywjsLabel.textColor = titleTextColor;
    CGSize ywjsContentLabelSize = [self.ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    self.ywjsLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.ywjsTitleLabel.frame) + 4, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    [self addSubview: self.ywjsLabel];
    //
    UILabel *secondSeparatorView = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ywjsLabel.frame), Screen_Width, 10)];
    secondSeparatorView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    [self addSubview:secondSeparatorView];
//    [secondSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.ywjsLabel.mas_bottom);
//        make.height.mas_equalTo(10);
//    }];
    //跟进情况
    UILabel *flowUpLabel = [self createLabelWithTitle:@"业务介绍" font:titleFont textColor:[CXYMAppearanceManager textNormalColor] linkLabel:secondSeparatorView];
    self.frame = CGRectMake(0, 0, Screen_Width, flowUpLabel.frame.origin.y);
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(CGFloat )font textColor:(UIColor *)textColor linkLabel:(UILabel *)linkLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(linkLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(leftMargin);
        make.width.mas_equalTo(kcontentLabelLeftmargin);
        make.height.mas_equalTo(kLabelCellHeight);
    }];
    return label;
}

- (CXEditLabel *)createEditLabelWithLinkEditLabel:(CXEditLabel *)linkEditLabel{
    CXEditLabel *editLabel = [[CXEditLabel alloc] init];
    [self addSubview:editLabel];
    [editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kcontentLabelLeftmargin);
        make.top.mas_equalTo(linkEditLabel.mas_bottom);
        make.height.mas_equalTo(kLabelCellHeight);
        make.right.mas_equalTo(-kcontentLabelLeftmargin);
    }];
    return editLabel;
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = SDBackGroudColor;
        self.hasFollowDataSource = YES;
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.myContentScrollView];
    [self.titleArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = kColorWithRGB(132, 142, 153);
        [self.myContentScrollView addSubview:label];
        
    }];
    [self.labelArray enumerateObjectsUsingBlock:^(CXEditLabel *label, NSUInteger idx, BOOL *stop){
        label.contentFont = [UIFont systemFontOfSize:14.0];
        label.textColor = kColorWithRGB(31, 34, 40);
        [self.myContentScrollView addSubview:label];
    }];
    
}
- (void)layoutSubviews{
    if(!_myContentScrollView){
        return;
    }
    self.titleLabel.text = @"基本资料";
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(leftMargin, topMargin, _titleLabel.frame.size.width, bigTitleHeight);
    
    CGFloat x,width;
    self.projNameTitleLabel.text = @"项目名称";
    [self.projNameTitleLabel sizeToFit];
    self.projNameTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.titleLabel.frame), self.projNameTitleLabel.frame.size.width, rowHeight);
    
    if(self.projNameTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.projNameTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.projNameTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.projNameLabel.frame = CGRectMake(x, CGRectGetMaxY(self.titleLabel.frame), width, rowHeight);
    
    self.currentLCTitleLabel.text = @"当前轮次";
    [self.currentLCTitleLabel sizeToFit];
    self.currentLCTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.projNameLabel.frame) + rowMargin, self.currentLCTitleLabel.frame.size.width, rowHeight);
    
    if(self.currentLCTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.currentLCTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.currentLCTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.currentLCLabel.frame = CGRectMake(x, CGRectGetMaxY(self.projNameLabel.frame) + rowMargin, width, rowHeight);
    
    self.metStatusTitleLabel.text = @"约见状态";
    [self.metStatusTitleLabel sizeToFit];
    self.metStatusTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.currentLCLabel.frame) + rowMargin, self.metStatusTitleLabel.frame.size.width, rowHeight);
    
    if(self.metStatusTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.metStatusTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.metStatusTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.metStatusLabel.frame = CGRectMake(x, CGRectGetMaxY(_currentLCLabel.frame) + rowMargin, width, rowHeight);
    
    self.industryTitleLabel.text = @"行业";
    [self.industryTitleLabel sizeToFit];
    self.industryTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.metStatusLabel.frame) + rowMargin, self.industryTitleLabel.frame.size.width, rowHeight);
    
    
    if(self.industryTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.industryTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.industryTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.industryLabel.frame = CGRectMake(x, CGRectGetMaxY(self.metStatusLabel.frame) + rowMargin, width, rowHeight);
    
    self.investGroupTitleLabel.text = @"投资机构";
    [self.investGroupTitleLabel sizeToFit];
    self.investGroupTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.industryLabel.frame) + rowMargin, self.investGroupTitleLabel.frame.size.width, rowHeight);
    
    if(self.investGroupTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.investGroupTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.investGroupTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.investGroupLabel.frame = CGRectMake(x, CGRectGetMaxY(self.industryLabel.frame) + rowMargin, width, rowHeight);
    
    self.cityTitleLabel.text = @"城市";
    [self.cityTitleLabel sizeToFit];
    self.cityTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.investGroupLabel.frame) + rowMargin, self.cityTitleLabel.frame.size.width, rowHeight);
    
    
    if(self.cityTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.cityTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.cityTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.cityLabel.frame = CGRectMake(x, CGRectGetMaxY(self.investGroupLabel.frame) + rowMargin, width, rowHeight);
    
    self.followStateTitleLabel.text = @"跟进状态";
    [self.followStateTitleLabel sizeToFit];
    self.followStateTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.cityLabel.frame) + rowMargin, self.followStateTitleLabel.frame.size.width, rowHeight);
    
    
    if(self.followStateTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.followStateTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.followStateTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.followStateLabel.frame = CGRectMake(x, CGRectGetMaxY(self.cityLabel.frame) + rowMargin, width, rowHeight);
    
    self.contactTimeTileLabel.text = @"接触时间";
    [self.contactTimeTileLabel sizeToFit];
    self.contactTimeTileLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.followStateLabel.frame) + rowMargin, self.contactTimeTileLabel.frame.size.width, rowHeight);
    
    
    if(self.contactTimeTileLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.contactTimeTileLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.contactTimeTileLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.contactTimeLabel.frame = CGRectMake(x, CGRectGetMaxY(self.followStateLabel.frame) + rowMargin, width, rowHeight);
    
    
    self.managerTitleLabel.text = @"负责人";
    [self.managerTitleLabel sizeToFit];
    self.managerTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.contactTimeLabel.frame) + rowMargin, self.managerTitleLabel.frame.size.width, rowHeight);
    
    
    if(self.managerTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.managerTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.managerTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.managerLabel.frame = CGRectMake(x, CGRectGetMaxY(self.contactTimeLabel.frame) + rowMargin, width, rowHeight);
    
    self.capitalInvestTitleLabel.text = @"IDG资本投资情况";
    [self.capitalInvestTitleLabel sizeToFit];
    self.capitalInvestTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.managerLabel.frame) + rowMargin, self.capitalInvestTitleLabel.frame.size.width, rowHeight);
    
    if(self.capitalInvestTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.capitalInvestTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.capitalInvestTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.capitalInvestLabel.frame = CGRectMake(x, CGRectGetMaxY(self.managerLabel.frame) + rowMargin, width,rowHeight);
    
    //重点项目
    self.importmentTitleLabel.text = @"是否重点项目";
    [self.importmentTitleLabel sizeToFit];
    self.importmentTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.capitalInvestTitleLabel.frame) + rowMargin, self.importmentTitleLabel.frame.size.width, rowHeight);
    
    if(self.importmentTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.importmentTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.importmentTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.importmentLabel.frame = CGRectMake(x, CGRectGetMaxY(self.capitalInvestLabel.frame) + rowMargin, width,rowHeight);
    
    
    marginView.frame = CGRectMake(0, CGRectGetMaxY(self.importmentLabel.frame) + rowMargin, Screen_Width, rowMargin);
    
    self.ywjsTitleLabel.text = @"业务介绍";
    [self.ywjsTitleLabel sizeToFit];
    self.ywjsTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(marginView.frame) + topMargin, self.ywjsTitleLabel.frame.size.width, bigTitleHeight);
    
    _ywjsLabel.numberOfLines = 0;
    _ywjsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsLabel.text = self.model.bizDesc;
    _ywjsLabel.font = [UIFont systemFontOfSize:14.f];
    _ywjsLabel.textColor = kColorWithRGB(31, 34, 40);
    
    CGSize ywjsContentLabelSize = [_ywjsLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _ywjsLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.ywjsTitleLabel.frame), Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    
    
    marginView2.frame = CGRectMake(0, CGRectGetMaxY(self.ywjsLabel.frame) + topMargin, Screen_Width, rowMargin);
    
    if(!self.hasFollowDataSource){
        //        CGPoint lastPoint = [self.myContentScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(self.ywjsLabel.frame)) toView:[UIApplication sharedApplication].delegate.window];
        self.myContentScrollView.frame = CGRectMake(0, 0, Screen_Width, CGRectGetMaxY(marginView2.frame));
        self.frame = self.myContentScrollView.frame;
        return;
    }
    self.followUpLabel.text = @"跟进情况";
    [self.followUpLabel sizeToFit];
    self.followUpLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(marginView2.frame), self.followUpLabel.frame.size.width, bigTitleHeight);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
        CGPoint lastPoint = [self.myContentScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(self.followUpLabel.frame)) toView:keyWindow];
    self.myContentScrollView.frame = CGRectMake(0, 0, Screen_Width, lastPoint.y - navHigh);
    self.frame = self.myContentScrollView.frame;
    NSLog(@"%@",@(self.myContentScrollView.frame));
}

- (UIView *)createLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kIDGNewLineColor;
    return view;
}

- (void)setHasFollowDataSource:(BOOL)hasFollowDataSource{
    return;//需求变更,
    _hasFollowDataSource = hasFollowDataSource;
    self.followStateLabel.alpha = hasFollowDataSource;
//没有跟进数据则不显示跟进状态
    if(!hasFollowDataSource){
        [self.followUpLabel removeFromSuperview];
        CGRect rect  = self.frame;
        CGFloat height = rect.size.height - bigTitleHeight - topMargin;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(rect), height);
        [self setNeedsLayout];
//        [self layoutIfNeeded];
    }
}
#pragma mark - 数据懒加载
- (UIButton *)editProjectInfoButton{
    if (_editProjectInfoButton == nil) {
        _editProjectInfoButton = [[UIButton alloc] init];
        _editProjectInfoButton.frame = CGRectMake(Screen_Width - leftMargin - 24, topMargin, 24, 24);
        [_editProjectInfoButton setBackgroundImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        [_editProjectInfoButton addTarget:self action:@selector(editProjectInfoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editProjectInfoButton;
}
#pragma mark -- editProjectInfoButtonClick
- (void)editProjectInfoButtonClick{
    NSLog(@"editProjectInfoButtonClick");
    if(self.block) {
        self.block();
    }
}
- (UIScrollView *)myContentScrollView{
    if(nil == _myContentScrollView){
        _myContentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0)];
        _myContentScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
        [_myContentScrollView addSubview:self.editProjectInfoButton];
        [_myContentScrollView addSubview:self.titleLabel];
        [_myContentScrollView addSubview:self.ywjsLabel];
        [_myContentScrollView addSubview:self.ywjsTitleLabel];
        marginView = [[UIView alloc]init];
        marginView.backgroundColor = SDBackGroudColor;
        [_myContentScrollView addSubview:marginView];
        marginView2 = [[UIView alloc]init];
        marginView2.backgroundColor = SDBackGroudColor;
        [_myContentScrollView addSubview:marginView2];
        [_myContentScrollView addSubview:self.followUpLabel];
        _myContentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myContentScrollView;
}
- (NSMutableArray *)titleArray{
    if(nil == _titleArray){
        _titleArray = [NSMutableArray arrayWithObjects:self.projNameTitleLabel,//项目名称
                       self.currentLCTitleLabel,//当前轮次
                       self.metStatusTitleLabel,//约见状态
                       self.industryTitleLabel,//行业
                       self.investGroupTitleLabel,//投资机构
                       self.cityTitleLabel,//城市
                       self.followStateTitleLabel,//跟进状态
                       self.contactTimeTileLabel,//接触时间
                       self.managerTitleLabel,//负责人
                       self.capitalInvestTitleLabel,//idg投资
                       self.importmentTitleLabel,nil];//重点项目
    }
    return _titleArray;
}
- (NSMutableArray *)labelArray{
    if(nil == _labelArray){
        _labelArray = [NSMutableArray arrayWithObjects:self.projNameLabel,//项目名称
                       self.currentLCLabel,//当前轮次
                       self.metStatusLabel,//约见状态
                       self.industryLabel,//行业
                       self.investGroupLabel,//投资机构
                       self.cityLabel,//城市
                       self.followStateLabel,//跟进状态
                       self.contactTimeLabel,//接触时间
                       self.managerLabel,//负责人
                       self.capitalInvestLabel,//idg投资
                       self.importmentLabel,nil];//重点项目
    }
    return _labelArray;
}
- (UILabel *)titleLabel{
    if(nil == _titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18.f];
        _titleLabel.textColor = kColorWithRGB(50, 50, 50);
    }
    return _titleLabel;
}
- (UILabel *)projNameTitleLabel{
    if(nil == _projNameTitleLabel){
        _projNameTitleLabel = [[UILabel alloc]init];
    }
    return _projNameTitleLabel;
}
- (CXEditLabel *)projNameLabel{
    if(nil == _projNameLabel){
        _projNameLabel = [[CXEditLabel alloc]init];
        _projNameLabel.placeholder = @"请输入项目名称";
    }
    return _projNameLabel;
}
- (UILabel *)currentLCTitleLabel{
    if(nil == _currentLCTitleLabel){
        _currentLCTitleLabel = [[UILabel alloc]init];
    }
    return _currentLCTitleLabel;
}
- (CXEditLabel *)currentLCLabel{
    if(nil == _currentLCLabel){
        _currentLCLabel = [[CXEditLabel alloc]init];
//        _currentLCLabel.placeholder = @"请输入当前轮次";
    }
    return _currentLCLabel;
}
- (UILabel *)metStatusTitleLabel{
    if(nil == _metStatusTitleLabel){
        _metStatusTitleLabel = [[UILabel alloc]init];
    }
    return _metStatusTitleLabel;
}
- (CXEditLabel *)metStatusLabel{
    if(nil == _metStatusLabel){
        _metStatusLabel = [[CXEditLabel alloc]init];
        _metStatusLabel.showNewDropdown = YES;
        _metStatusLabel.allowEditing = YES;
        _metStatusLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _metStatusLabel.selectViewTitle = @"约见状态";
        _metStatusLabel.pickerTextArray = @[@"未约见",@"已约见"];
        _metStatusLabel.pickerValueArray = @[@"unDate",@"date"];
        if(_model){
            if([self.model.invContactStatus isEqualToString:@"unDate"]){
                _metStatusLabel.selectedPickerData = @{
                                                       CXEditLabelCustomPickerTextKey : @"未约见",
                                                       CXEditLabelCustomPickerValueKey : @"unDate"
                                                       };
                _metStatusLabel.content = @"未约见";
            }else if([self.model.invContactStatus isEqualToString:@"date"]){
                _metStatusLabel.selectedPickerData = @{
                                                       CXEditLabelCustomPickerTextKey : @"已约见",
                                                       CXEditLabelCustomPickerValueKey : @"date"
                                                       };
                _metStatusLabel.content = @"已约见";
            }
        }
        CXWeakSelf(self)
        _metStatusLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未约见"]){
                self.metStatusLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"未约见",
                                                           CXEditLabelCustomPickerValueKey : @"unDate"
                                                           };
                self.model.invContactStatus = @"unDate";
            }else if([editLabel.content isEqualToString:@"已约见"]){
                self.metStatusLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"已约见",
                                                           CXEditLabelCustomPickerValueKey : @"date"
                                                           };
                self.model.invContactStatus = @"date";
            }
        };
    }
    return _metStatusLabel;
}
- (CXPEPotentialProjectModel *)rollBackData{
    if(!trim(self.projNameLabel.content).length){
        CXAlert(@"请输入项目名称");
        return nil;
    }
    
    _model.projName = self.projNameLabel.content;
    _model.invDate = self.contactTimeLabel.content;
    _model.invRound = self.currentLCLabel.content;
    _model.invContactStatus = self.metStatusLabel.content;
//        self.model.invContactStatus = self.metStatusLabel.selectedPickerData[CXEditLabelCustomPickerTextKey];
    //    self.model.comIndus = self.industryLabel.selectedPickerData[CXEditLabelCustomPickerTextKey];
    _model.bizDesc = self.ywjsLabel.text;
    _model.invGroup = self.investGroupLabel.content;
    _model.region = self.cityLabel.content;
    if(self.isEdit){
        _model.userName = self.managerLabel.content;
        _model.invFlowUp = self.followStateLabel.content;
    }
    
    return _model;
}
- (UILabel *)industryTitleLabel{
    if(nil == _industryTitleLabel){
        _industryTitleLabel = [[UILabel alloc]init];
    }
    return _industryTitleLabel;
}
- (CXEditLabel *)industryLabel{
    if(nil == _industryLabel){
        _industryLabel = [[CXEditLabel alloc]init];
        _industryLabel.placeholder = @"请输入行业类型";
        _industryLabel.selectViewTitle = @"行业";
        _industryLabel.showNewDropdown = YES;
        _industryLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _industryLabel.pickerTextArray = self.industryList;
        _industryLabel.pickerValueArray = self.industryList;
        if(_model){
            if(self.model.comIndus){
                _industryLabel.content = self.model.comIndus;
                _industryLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : self.model.comIndus,
                                                      CXEditLabelCustomPickerValueKey : self.model.comIndus
                                                      };
            }
        }
        CXWeakSelf(self)
        _industryLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.industryLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : editLabel.content,
                                                      CXEditLabelCustomPickerValueKey : editLabel.content
                                                      };
            self.model.comIndus = editLabel.content;
        };
        
    }
    return _industryLabel;
}
- (UILabel *)investGroupTitleLabel{
    if(nil == _investGroupTitleLabel){
        _investGroupTitleLabel = [[UILabel alloc]init];
    }
    return _investGroupTitleLabel;
}
- (CXEditLabel *)investGroupLabel{
    if(nil == _investGroupLabel){
        _investGroupLabel = [[CXEditLabel alloc]init];
//        _investGroupLabel.placeholder = @"请输入投资机构";
    }
    return _investGroupLabel;
}
- (UILabel *)cityTitleLabel{
    if(nil == _cityTitleLabel){
        _cityTitleLabel = [[UILabel alloc]init];
    }
    return _cityTitleLabel;
}
- (CXEditLabel *)cityLabel{
    if(nil == _cityLabel){
        _cityLabel = [[CXEditLabel alloc]init];
//        _cityLabel.placeholder = @"请输入所在城市";
    }
    return _cityLabel;
}
- (UILabel *)followStateTitleLabel{
    if(nil == _followStateTitleLabel){
        _followStateTitleLabel = [[UILabel alloc]init];
    }
    return _followStateTitleLabel;
}
- (CXEditLabel *)followStateLabel{
    if(nil == _followStateLabel){
        _followStateLabel = [[CXEditLabel alloc]init];
    }
    return _followStateLabel;
}
- (UILabel *)contactTimeTileLabel{
    if(nil == _contactTimeTileLabel){
        _contactTimeTileLabel = [[UILabel alloc]init];
    }
    return _contactTimeTileLabel;
}
- (CXEditLabel *)contactTimeLabel{
    if(nil == _contactTimeLabel){
        _contactTimeLabel  = [[CXEditLabel alloc]init];
        _contactTimeLabel.placeholder = @"请输入时间";
        _contactTimeLabel.inputType = CXEditLabelInputTypeDate;
        _contactTimeLabel.allowEditing = YES;
    }
    return _contactTimeLabel;
}
- (UILabel *)managerTitleLabel{
    if(nil == _managerTitleLabel){
        _managerTitleLabel = [[UILabel alloc]init];
    }
    return _managerTitleLabel;
}
- (CXEditLabel *)managerLabel{
    if(nil == _managerLabel){
        _managerLabel = [[CXEditLabel alloc]init];
    }
    return _managerLabel;
}
- (UILabel *)capitalInvestTitleLabel{
    if(nil == _capitalInvestTitleLabel){
        _capitalInvestTitleLabel = [[UILabel alloc]init];
    }
    return _capitalInvestTitleLabel;
}
- (CXEditLabel *)capitalInvestLabel{
    if(nil == _capitalInvestLabel){
        _capitalInvestLabel = [[CXEditLabel alloc]init];
        _capitalInvestLabel.placeholder = @"请选择投资情况";
        _capitalInvestLabel.selectViewTitle = @"投资情况";
        _capitalInvestLabel.showNewDropdown = YES;
        _capitalInvestLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _capitalInvestLabel.pickerTextArray = @[@"未投资", @"已投资"];
        _capitalInvestLabel.pickerValueArray = @[@"unInv", @"inv"];
        if(_model){
            if([self.model.invStatus isEqualToString:@"unInv"]){
                _capitalInvestLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"未投资",
                                                           CXEditLabelCustomPickerValueKey : @"unInv"
                                                           };
                _capitalInvestLabel.content = @"未投资";
            }else if([self.model.invStatus isEqualToString:@"inv"]){
                _capitalInvestLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"已投资",
                                                           CXEditLabelCustomPickerValueKey : @"inv"
                                                           };
                _capitalInvestLabel.content = @"已投资";
            }
        }
        CXWeakSelf(self)
        _capitalInvestLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未投资"]){
                self.capitalInvestLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"未投资",
                                                               CXEditLabelCustomPickerValueKey : @"unInv"
                                                               };
                self.model.invStatus = @"unInv";
            }else if([editLabel.content isEqualToString:@"已投资"]){
                self.capitalInvestLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"已投资",
                                                               CXEditLabelCustomPickerValueKey : @"inv"
                                                               };
                self.model.invStatus = @"inv";
            }
        };
    }
    return _capitalInvestLabel;
}
//重点项目
- (UILabel *)importmentTitleLabel{
    if(nil == _importmentTitleLabel){
        _importmentTitleLabel = [[UILabel alloc]init];
        _importmentTitleLabel.text = @"是否重点项目";
    }
    return _importmentTitleLabel;
}
- (CXEditLabel *)importmentLabel{
    if(_importmentLabel == nil){
        //重点项目
        _importmentLabel = [[CXEditLabel alloc] initWithFrame:CGRectZero];
        
        _importmentLabel.placeholder = @"是否重点项目";
        _importmentLabel.showDropdown = YES;
        _importmentLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _importmentLabel.pickerTextArray = @[@"是",@"是(新增)",@"否"];
        _importmentLabel.pickerValueArray = @[@(1),@(2),@(3)];
        if (self.isEdit) {
            if([self.model.importantStatus integerValue] == 1){
                _importmentLabel.selectedPickerData = @{
                                                             CXEditLabelCustomPickerTextKey : @"是",
                                                             CXEditLabelCustomPickerValueKey : @"1"
                                                             };
                _importmentLabel.content = @"是";
            }else if([[self.model.importantStatus stringValue] isEqualToString:@"2"]){
                _importmentLabel.selectedPickerData = @{
                                                             CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                             CXEditLabelCustomPickerValueKey : @"2"
                                                             };
                _importmentLabel.content = @"是(新增)";
            }else if([[self.model.importantStatus stringValue] isEqualToString:@"3"]){
                _importmentLabel.selectedPickerData = @{
                                                             CXEditLabelCustomPickerTextKey : @"否",
                                                             CXEditLabelCustomPickerValueKey : @"3"
                                                             };
                _importmentLabel.content = @"否";
            }
        }else{
            self.model.importantStatus = _importmentLabel.pickerValueArray.firstObject;
            _importmentLabel.content = _importmentLabel.pickerTextArray.firstObject;
            _importmentLabel.selectedPickerData = @{
                                                         CXEditLabelCustomPickerTextKey : _importmentLabel.pickerTextArray.firstObject,
                                                         CXEditLabelCustomPickerValueKey : _importmentLabel.pickerValueArray.firstObject
                                                         };
        }
        CXWeakSelf(self)
        _importmentLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"是"]){
                self.importmentLabel.selectedPickerData = @{
                                                                 CXEditLabelCustomPickerTextKey : @"是",
                                                                 CXEditLabelCustomPickerValueKey : @"1"
                                                                 };
                self.model.importantStatus = @(1);
            }else if([editLabel.content isEqualToString:@"2"]){
                self.importmentLabel.selectedPickerData = @{
                                                                 CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                                 CXEditLabelCustomPickerValueKey : @"2"
                                                                 };
                self.model.importantStatus = @(2);
            }else if([editLabel.content isEqualToString:@"3"]){
                self.importmentLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"否",
                                                               CXEditLabelCustomPickerValueKey : @"3"
                                                               };
                self.model.importantStatus = @(3);
            }
        };
        
    }
    return _importmentLabel;
}
- (UILabel *)ywjsTitleLabel{
    if(nil == _ywjsTitleLabel){
        _ywjsTitleLabel = [[UILabel alloc]init];
        _ywjsTitleLabel.font = [UIFont systemFontOfSize:18.0];
        _ywjsTitleLabel.textColor = kColorWithRGB(50, 50, 50);
    }
    return _ywjsTitleLabel;
}
- (UILabel *)ywjsLabel{
    if(nil == _ywjsLabel){
        _ywjsLabel = [[UILabel alloc]init];
    }
    return _ywjsLabel;
}
- (CXPEPotentialProjectModel *)model{
    if(nil == _model){
        _model = [[CXPEPotentialProjectModel alloc]init];
    }
    return _model;
}
- (UILabel *)followUpLabel{
    if(nil == _followUpLabel){
        _followUpLabel = [[UILabel alloc]init];
        _followUpLabel.font = [UIFont systemFontOfSize:18.0];
        _followUpLabel.textColor = kColorWithRGB(50, 50, 50);
    }
    return _followUpLabel;
}
- (NSMutableArray *)industryList{
    if(!_industryList){
        _industryList = @[].mutableCopy;
    }
    return _industryList;
}

- (void)setModel:(CXPEPotentialProjectModel *)model{
    _model = model;
    self.isEdit = YES;
  
    self.projNameLabel.content = model.projName ?:@" ";self.projNameLabel.allowEditing = NO;
    self.contactTimeLabel.content = model.invDate ?:@" ";self.contactTimeLabel.allowEditing = NO;
    self.currentLCLabel.content = model.invRound ?:@" ";self.currentLCLabel.allowEditing = NO;
    self.metStatusLabel.content = [model.invContactStatus isEqualToString:@"date"] ? @"已约见": @"未约见";
    self.metStatusLabel.showDropdown = NO;
    self.metStatusLabel.allowEditing = NO;
    self.industryLabel.content = model.comIndus ?:@" ";
    self.industryLabel.allowEditing = NO;
    self.industryLabel.showDropdown = NO;
    self.ywjsLabel.text = model.bizDesc ? :@" ";
    self.investGroupLabel.content = model.invGroup ?:@" ";self.investGroupLabel.allowEditing = NO;
    self.cityLabel.content = model.region ?:@" ";self.cityLabel.allowEditing = NO;
    self.capitalInvestLabel.content = model.invStatus ?:@" ";//IDG
    self.capitalInvestLabel.allowEditing = NO;
    if ([model.invStatus isEqualToString:@"unInv"]){
        self.capitalInvestLabel.content = @"未投资";
    }else{
        self.capitalInvestLabel.content = @"已投资";
    }
    self.capitalInvestLabel.allowEditing = NO;
    self.capitalInvestLabel.showDropdown = NO;
    self.managerLabel.content = model.userName ?:@" ";
    self.managerLabel.allowEditing = NO;
    //flowUp 继续跟进   abandon 放弃  WS 观望
    if ([model.invFlowUp isEqualToString:@"flowUp"]){
        self.followStateLabel.content = @"继续跟进";
    }else if ([model.invFlowUp isEqualToString:@"abandon"]){
        self.followStateLabel.content = @"放弃";
    }else if ([model.invFlowUp isEqualToString:@"WS"]){
        self.followStateLabel.content = @"观望";
    }
    self.followStateLabel.allowEditing = NO;
    self.importmentLabel.allowEditing = NO;
    self.importmentLabel.showDropdown = NO;
    if ([[model.importantStatus stringValue] isEqualToString:@"1"]){
        self.importmentLabel.content = @"是";
    }else if ([[model.importantStatus stringValue] isEqualToString:@"2"]){
        self.importmentLabel.content = @"是(新增)";
    }else if ([[model.importantStatus stringValue] isEqualToString:@"3"]){
        self.importmentLabel.content = @"否";
    }
    //下面注释原因不明晰
//    _metStatusLabel = nil;
//    _industryLabel = nil;
//    _capitalInvestLabel = nil;
    
}

@end
