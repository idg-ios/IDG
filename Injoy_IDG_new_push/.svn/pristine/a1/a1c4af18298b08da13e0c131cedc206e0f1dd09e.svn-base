//
//  CX.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/6.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGBasicInfoView.h"

#define margin 15.f
#define kLabelHeight 32.f
#define kTopMargin 14.0
@interface CXIDGBasicInfoView()
@property (nonatomic, strong) UILabel *dateTitleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *stageTitleLabel;
@property (nonatomic, strong) UILabel *stageLabel;
@property (nonatomic, strong) UILabel *cityTitleLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *groupTitleLabel;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *managerNameTitleLabel;
@property (nonatomic, strong) UILabel *managerNameLabel;
@property (nonatomic, strong) UILabel *projteamTitleLabel;
@property (nonatomic, strong) UILabel *projteamLabel;
@property (nonatomic, strong) UILabel *projNameTitleLabel;
@property (nonatomic, strong) UILabel *projNameLabel;

@property (nonatomic, strong) UILabel *projStatesTileLabel;
@property (nonatomic, strong) UILabel *projStatesLabel;
@property (nonatomic, strong) UILabel *XMLSTitleLabel;
@property (nonatomic, strong) UILabel *XMLSLabel;
@property (nonatomic, strong) UILabel *LCTitleLabel;
@property (nonatomic, strong) UILabel *LCLabel;
@property (nonatomic, strong) UILabel *JDFZTitleLabel;
@property (nonatomic, strong) UILabel *JDFZLabel;
@property (nonatomic, strong) UILabel *XMFZTitleLabel;
@property (nonatomic, strong) UILabel *XMFZLabel;
@property (nonatomic, strong) UILabel *LYQDTitleLabel;
@property (nonatomic, strong) UILabel *LYQDLabel;
@property (nonatomic, strong) UILabel *LYRTitleLabel;
@property (nonatomic, strong) UILabel *LYRLabel;
@property (nonatomic, strong) UILabel *contributerTitleLabel;
@property (nonatomic, strong) UILabel *contributerLabel;

@property (nonatomic, strong) UILabel *YWJSTitleLabel;
@property (nonatomic, strong) UILabel *YWJSLabel;

@property (nonatomic, copy) NSMutableArray *titLabelArrays;
@property (nonatomic, copy) NSMutableArray *contentLabelArrays;

@property (nonatomic, strong) UIScrollView *myScrollView;
@end

@implementation CXIDGBasicInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUpUI];
        [self addSubview:self.myScrollView];
    }
    return self;
}

-(void)initLabel{
    _dateLabel = [[UILabel alloc]init];
    _dateTitleLabel = [[UILabel alloc]init];
    _stageLabel = [[UILabel alloc]init];
    _stageTitleLabel = [[UILabel alloc]init];
    _cityTitleLabel = [[UILabel alloc]init];
    _cityLabel = [[UILabel alloc]init];
    _groupTitleLabel = [[UILabel alloc]init];
    _groupLabel = [[UILabel alloc]init];
    _managerNameTitleLabel = [[UILabel alloc]init];
    _managerNameLabel = [[UILabel alloc]init];
    _projteamTitleLabel = [[UILabel alloc]init];
    _projteamLabel = [[UILabel alloc]init];
    _projNameTitleLabel = [[UILabel alloc]init];
    _projNameLabel = [[UILabel alloc]init];
    _projStatesTileLabel = [[UILabel alloc]init];
    _projStatesLabel = [[UILabel alloc]init];
    _XMLSLabel = [[UILabel alloc]init];
    _XMLSTitleLabel = [[UILabel alloc]init];
    _LCTitleLabel = [[UILabel alloc]init];
    _LCLabel = [[UILabel alloc]init];
    _JDFZTitleLabel = [[UILabel alloc]init];
    _JDFZLabel = [[UILabel alloc]init];
    _XMFZTitleLabel = [[UILabel alloc]init];
    _XMFZLabel = [[UILabel alloc]init];
    _LYQDTitleLabel = [[UILabel alloc]init];
    _LYQDLabel = [[UILabel alloc]init];
    _LYRTitleLabel = [[UILabel alloc]init];
    _LYRLabel = [[UILabel alloc]init];
    _contributerTitleLabel = [[UILabel alloc]init];
    _contributerLabel = [[UILabel alloc]init];
}
- (void)setUpUI{
    [self initLabel];
    _titLabelArrays = [[NSMutableArray alloc]initWithObjects:_dateTitleLabel,_stageTitleLabel,_cityTitleLabel,_groupTitleLabel,_managerNameTitleLabel,_projteamTitleLabel,_projNameTitleLabel,_projStatesTileLabel,_XMLSTitleLabel,_LCTitleLabel,_JDFZTitleLabel,_XMFZTitleLabel,_LYQDTitleLabel,_LYRTitleLabel,_contributerTitleLabel,nil];
    _contentLabelArrays = [[NSMutableArray alloc]initWithObjects:_dateLabel,_stageLabel,_cityLabel,_groupLabel,_managerNameLabel,_projteamLabel,_projNameLabel,_projStatesLabel,_XMLSLabel,_LCLabel,_JDFZLabel,_XMFZLabel,_LYQDLabel,_LYRLabel,_contributerLabel,nil];
    
    [_contentLabelArrays enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = kColorWithRGB(31, 34, 40);
        [self.myScrollView addSubview:label];
    }];
    [_titLabelArrays enumerateObjectsUsingBlock:^(UILabel *label , NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = kColorWithRGB(132, 142, 153);
        [self.myScrollView addSubview:label];
    }];
    
    _dateTitleLabel.text = @"立项日期";
    [_dateTitleLabel sizeToFit];
    _dateTitleLabel.frame = CGRectMake(margin, 0 + kTopMargin, _dateTitleLabel.frame.size.width, kLabelHeight);
    
    CGFloat x;
    CGFloat width;
    if( _dateLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_dateTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_dateTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _dateLabel.frame =CGRectMake(x , 0 + kTopMargin, width, kLabelHeight);
    

    _stageTitleLabel.text = @"投资阶段";
    [_stageTitleLabel sizeToFit];
    _stageTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.dateLabel.frame), _stageTitleLabel.frame.size.width, kLabelHeight);
    if( _stageTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_stageTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_stageTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _stageLabel.frame =CGRectMake(x , CGRectGetMaxY(self.dateTitleLabel.frame), width, kLabelHeight);
    
    _cityTitleLabel.text = @"城市";
    [_cityTitleLabel sizeToFit];
    _cityTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.stageTitleLabel.frame), _cityTitleLabel.frame.size.width, kLabelHeight);
    if( _cityTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_cityTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_cityTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _cityLabel.frame =CGRectMake(x , CGRectGetMaxY(self.stageLabel.frame), width, kLabelHeight);
    
    _groupTitleLabel.text = @"行业";
    [_groupTitleLabel sizeToFit];
    _groupTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.cityTitleLabel.frame), _groupTitleLabel.frame.size.width, kLabelHeight);
    if( _groupTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_groupTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_groupTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _groupLabel.frame =CGRectMake(x , CGRectGetMaxY(self.cityTitleLabel.frame), width, kLabelHeight);
    
    _managerNameTitleLabel.text = @"项目负责人";
    [_managerNameTitleLabel sizeToFit];
    _managerNameTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.groupLabel.frame), _managerNameTitleLabel.frame.size.width, kLabelHeight);
    if( _managerNameTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_managerNameTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_managerNameTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _managerNameLabel.frame =CGRectMake(x , CGRectGetMaxY(self.groupLabel.frame), width, kLabelHeight);
    
    _projteamTitleLabel.text = @"小组成员";
    [_projteamTitleLabel sizeToFit];
    _projteamTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.managerNameLabel.frame), _projteamTitleLabel.frame.size.width, kLabelHeight);
    if( _projteamTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_projteamTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_projteamTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _projteamLabel.frame =CGRectMake(x , CGRectGetMaxY(self.managerNameTitleLabel.frame), width, kLabelHeight);
    
    _projNameTitleLabel.text = @"行业小组";
    [_projNameTitleLabel sizeToFit];
    _projNameTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.projteamLabel.frame), _projNameTitleLabel.frame.size.width, kLabelHeight);
    if( _projNameTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_projNameTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_projNameTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _projNameLabel.frame =CGRectMake(x , CGRectGetMaxY(self.projteamLabel.frame), width, kLabelHeight);
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(_projNameLabel.frame) + kLabelHeight/2.0, Screen_Width - 2*margin, 1.0f)];
    line.backgroundColor = kIDGNewLineColor;
    [_myScrollView addSubview:line];
    
    _projStatesTileLabel.text = @"企业阶段";
    [_projStatesTileLabel sizeToFit];
    _projStatesTileLabel.frame = CGRectMake(margin, CGRectGetMaxY(line.frame) + kLabelHeight/2.0, _projStatesTileLabel.frame.size.width, kLabelHeight);
    if( _projStatesTileLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_projStatesTileLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_projStatesTileLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _projStatesLabel.frame =CGRectMake(x , CGRectGetMaxY(line.frame) + kLabelHeight/2.0, width, kLabelHeight);
    
    _XMLSTitleLabel.text = @"项目律师";
    [_XMLSTitleLabel sizeToFit];
    _XMLSTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.projStatesLabel.frame), _XMLSTitleLabel.frame.size.width, kLabelHeight);
    if(_XMLSTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_XMLSTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_XMLSTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _XMLSLabel.frame =CGRectMake(x , CGRectGetMaxY(self.projStatesTileLabel.frame), width, kLabelHeight);
    
    _LCTitleLabel.text = @"融资轮次";
    [_LCTitleLabel sizeToFit];
    _LCTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.XMLSLabel.frame), _LCTitleLabel.frame.size.width, kLabelHeight);
    if( _LCTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_LCTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_LCTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _LCLabel.frame =CGRectMake(x , CGRectGetMaxY(self.XMLSTitleLabel.frame), width, kLabelHeight);
    
    _JDFZTitleLabel.text = @"尽调负责人";
    [_JDFZTitleLabel sizeToFit];
    _JDFZTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.LCTitleLabel.frame), _JDFZTitleLabel.frame.size.width, kLabelHeight);
    if(_JDFZTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_JDFZTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_JDFZTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _JDFZLabel.frame =CGRectMake(x , CGRectGetMaxY(self.LCLabel.frame), width, kLabelHeight);
    
    _XMFZTitleLabel.text = @"项目负责人";
    [_XMFZTitleLabel sizeToFit];
    _XMFZTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.JDFZLabel.frame), _XMFZTitleLabel.frame.size.width, kLabelHeight);
    if( _XMFZTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_XMFZTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_XMFZTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _XMFZLabel.frame =CGRectMake(x , CGRectGetMaxY(self.JDFZTitleLabel.frame), width, kLabelHeight);
    
    
    _LYQDTitleLabel.text = @"来源渠道";
    [_LYQDTitleLabel sizeToFit];
    _LYQDTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.XMFZLabel.frame),_LYQDTitleLabel.frame.size.width, kLabelHeight);
    if(_LYQDTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_LYQDTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_LYQDTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _LYQDLabel.frame =CGRectMake(x , CGRectGetMaxY(self.XMFZTitleLabel.frame), width, kLabelHeight);
    
    _LYRTitleLabel.text = @"来源人";
    [_LYRTitleLabel sizeToFit];
    _LYRTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.LYQDLabel.frame),_LYRTitleLabel.frame.size.width, kLabelHeight);
    if(_LYRTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_LYRTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_LYRTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _LYRLabel.frame =CGRectMake(x , CGRectGetMaxY(self.LYQDTitleLabel.frame), width, kLabelHeight);
    
    _contributerTitleLabel.text = @"contributer";
    [_contributerTitleLabel sizeToFit];
    _contributerTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(self.LYRLabel.frame),_contributerTitleLabel.frame.size.width, kLabelHeight);
    if(_contributerTitleLabel.frame.size.width > 108){
        x =  CGRectGetMaxX(_contributerTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_contributerTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }
    _contributerLabel.frame =CGRectMake(x , CGRectGetMaxY(self.LYRLabel.frame), width, kLabelHeight);
    
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contributerLabel.frame)+ kTopMargin, Screen_Width, 8.f)];
    spaceView.backgroundColor = kColorWithRGB(245, 246, 248);
    [_myScrollView addSubview:spaceView];
    
    _YWJSTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(spaceView.frame) + 8.0, Screen_Width - 2*margin, kLabelHeight)];
    _YWJSTitleLabel.text = @"业务介绍";
    _YWJSTitleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [_myScrollView addSubview:_YWJSTitleLabel];
    
    _YWJSLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.YWJSTitleLabel.frame), Screen_Width - 2*margin, kLabelHeight)];
    _YWJSLabel.font = [UIFont systemFontOfSize:14.f];
    _YWJSLabel.textColor = kColorWithRGB(31, 34, 40);
    [_myScrollView addSubview:_YWJSLabel];
    
    CGPoint point = [self.myScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(_YWJSLabel.frame) + kTopMargin) toView:[UIApplication sharedApplication].delegate.window];
    self->_myScrollView.contentSize = CGSizeMake(Screen_Width, point.y);
}

- (UIScrollView *)myScrollView{
    if(nil == _myScrollView){
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.frame))];
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
    }
    return _myScrollView;
}

- (void)setModel:(CXIDGBasicInformationModel *)model{
    self.dateLabel.text = model.inDate;
    self.cityLabel.text = model.city;
    self.XMLSLabel.text = model.projLawyerName;
    self.stageLabel.text = model.projStageName;
    self.managerNameLabel.text = model.projManagerName;
    self.projteamLabel.text = [model.teamName componentsJoinedByString:@","];
    self.groupLabel.text = model.induName;
    self.projNameLabel.text = model.projGroupName;
    self.projStatesLabel.text = model.comPhaseName;
    self.LYQDLabel.text = model.projSourName;
    self.LYRLabel.text = model.projSourPer;
    self.XMFZLabel.text = model.projManagerName;
    self.JDFZLabel.text = model.projDDManagerName;
    self.LCLabel.text = model.invRoundName;
    self.contributerLabel.text = [model.contributors componentsJoinedByString:@","];
    self.YWJSLabel.text = model.business;
    self.YWJSLabel.numberOfLines = 0;
    CGRect frame = self.YWJSLabel.frame;
    [_YWJSLabel sizeToFit];
    if(_YWJSLabel.frame.size.height > frame.size.height){
        frame.size.height = _YWJSLabel.frame.size.height;
        self.YWJSLabel.frame = frame;
        CGPoint point = [self.myScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(_YWJSLabel.frame)) toView:[UIApplication sharedApplication].delegate.window];
        self.myScrollView.contentSize = CGSizeMake(Screen_Width, point.y + 20.0);
    }
    _model = model;
}
- (NSString *)processTime:(NSString *)timeinterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timeinterval longLongValue])/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}



@end
