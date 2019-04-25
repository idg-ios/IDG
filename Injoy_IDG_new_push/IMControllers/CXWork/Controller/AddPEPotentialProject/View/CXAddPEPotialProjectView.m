//
//  CXAddPEPotialProjectView.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/7.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAddPEPotialProjectView.h"
#import "CXLabelTextVIew.h"
#import "CXEditLabel.h"
#import "HttpTool.h"

@interface CXAddPEPotialProjectView()<CXLabelTextViewDelegate>
@property (nonatomic, strong) UIScrollView *myContentScrollView;
@property (nonatomic, strong) UILabel *titleLabel;  //大大的基本资料
//项目名称
@property (nonatomic, strong) UILabel *projNameTitleLabel;
@property (nonatomic, strong) CXEditLabel *projNameLabel;
//当前轮次
@property (nonatomic, strong) UILabel *currentLCTitleLabel;
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
@property (nonatomic, strong) UILabel *importantStatusTitleLabel;
@property (nonatomic, strong) CXEditLabel *importantStatusLabel;

//业务介绍
@property (nonatomic, strong) UILabel *ywjsTitleLabel;
@property (nonatomic, strong) UILabel *ywjsLabel;
//大大的跟进情况
@property (nonatomic, strong) UILabel *followUpLabel;
//添加跟进情况
@property (nonatomic, strong) UIButton *addFollowUpBtn;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *industryList;

@property (nonatomic, assign) BOOL isEdit;
@end
#define uinitPx (Screen_Width / 375.0)
#define leftMargin (15 * uinitPx)
#define topMargin (12 * uinitPx)
#define bigTitleHeight (33 * uinitPx)
#define kLabelCellHeight (54 * uinitPx)
#define kcontentLabelLeftmargin (159 * uinitPx)
CG_INLINE void RePlaceMethod(Class _originClass, Class _newClass,SEL _originSelector, SEL _newSelector){
    Method oriMethod = class_getInstanceMethod(_originClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_newClass, _newSelector);
    BOOL isAdded = class_addMethod(_originClass, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if(isAdded){
        class_replaceMethod(_originClass, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, newMethod);
    }
}
@implementation CXAddPEPotialProjectView{
    UIView *marginView;
    CXPEPotentialProjectModel *_model;
    UIView *line1;
    UIView *line2;
    UIView *line3;
    UIView *line4;
    UIView *line5;
    UIView *line6;
    UIView *line7;
    UIView *line8;
    UIView *line9;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = SDBackGroudColor;
        RePlaceMethod([CXEditLabel class], [self class], NSSelectorFromString(@"dropdownImageView"),NSSelectorFromString(@"newdropdownImageView"));
        [self findIndustryList];
    }
    return self;
}
-(UIImageView *)newdropdownImageView{
    if([self valueForKey:@"_dropdownImageView"] == nil){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"arrow_spread")];
        [self setValue:imgView forKey:@"_dropdownImageView"];
        [self addSubview:(UIImageView *)[self valueForKey:@"_dropdownImageView"]];
    }
    return [self valueForKey:@"_dropdownImageView"];
}


- (void)setupUI{
    [self.titleArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = kColorWithRGB(132, 142, 153);
        [self.myContentScrollView addSubview:label];

    }];
    [self.labelArray enumerateObjectsUsingBlock:^(CXEditLabel *label, NSUInteger idx, BOOL *stop){
        label.contentFont = [UIFont systemFontOfSize:16.0];
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
    self.projNameTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.titleLabel.frame), self.projNameTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.projNameTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.projNameTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.projNameTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.projNameLabel.frame = CGRectMake(x, CGRectGetMaxY(self.titleLabel.frame), width, kLabelCellHeight);
    
    line1.frame = CGRectMake(x, CGRectGetMaxY(self.projNameLabel.frame), width + leftMargin, 1.f);
    
    self.currentLCTitleLabel.text = @"当前轮次";
    [self.currentLCTitleLabel sizeToFit];
    self.currentLCTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line1.frame), self.currentLCTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.currentLCTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.currentLCTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.currentLCTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.currentLCLabel.frame = CGRectMake(x, CGRectGetMaxY(line1.frame), width, kLabelCellHeight);
    
    line2.frame = CGRectMake(x, CGRectGetMaxY(self.currentLCLabel.frame), width + leftMargin, 1.f);
    
    self.metStatusTitleLabel.text = @"约见状态";
    [self.metStatusTitleLabel sizeToFit];
    self.metStatusTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line2.frame), self.metStatusTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.metStatusTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.metStatusTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.metStatusTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.metStatusLabel.frame = CGRectMake(x, CGRectGetMaxY(line2.frame), width, kLabelCellHeight);
    
    line3.frame = CGRectMake(x, CGRectGetMaxY(self.metStatusLabel.frame), width + leftMargin, 1.f);
    
    self.industryTitleLabel.text = @"行业";
    [self.industryTitleLabel sizeToFit];
    self.industryTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line3.frame), self.industryTitleLabel.frame.size.width, kLabelCellHeight);
    
    
    if(self.industryTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.industryTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.industryTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.industryLabel.frame = CGRectMake(x, CGRectGetMaxY(line3.frame), width, kLabelCellHeight);
    
    line4.frame = CGRectMake(x, CGRectGetMaxY(self.industryLabel.frame), width + leftMargin, 1.f);
    
    self.investGroupTitleLabel.text = @"投资机构";
    [self.investGroupTitleLabel sizeToFit];
    self.investGroupTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line4.frame), self.investGroupTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.investGroupTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.investGroupTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.investGroupTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.investGroupLabel.frame = CGRectMake(x, CGRectGetMaxY(line4.frame), width, kLabelCellHeight);
    
    line5.frame = CGRectMake(x, CGRectGetMaxY(self.investGroupLabel.frame), width + leftMargin, 1.f);
    
    self.cityTitleLabel.text = @"城市";
    [self.cityTitleLabel sizeToFit];
    self.cityTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line5.frame), self.cityTitleLabel.frame.size.width, kLabelCellHeight);
    
    
    if(self.cityTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.cityTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.cityTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.cityLabel.frame = CGRectMake(x, CGRectGetMaxY(line5.frame), width, kLabelCellHeight);
    
    line6.frame = CGRectMake(x, CGRectGetMaxY(self.cityLabel.frame), width + leftMargin, 1.0f);
    
    if(self.isEdit){
        line8.frame = CGRectMake(x, CGRectGetMaxY(self.cityLabel.frame), width + leftMargin, 1.0f);
        self.followStateTitleLabel.text = @"跟进状态";
        [self.followStateTitleLabel sizeToFit];
        self.followStateTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line8.frame), self.followStateTitleLabel.frame.size.width, kLabelCellHeight);
        
        
        if(self.followStateTitleLabel.frame.size.width > kcontentLabelLeftmargin){
            x = CGRectGetMaxX(self.followStateTitleLabel.frame) + leftMargin;
            width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.followStateTitleLabel.frame);
        }else{
            x = kcontentLabelLeftmargin;
            width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
        }
        self.followStateLabel.frame = CGRectMake(x, CGRectGetMaxY(line8.frame), width, kLabelCellHeight);
        
        line6.frame = CGRectMake(x, CGRectGetMaxY(self.followStateLabel.frame), width + leftMargin, 1.f);
    }

    self.contactTimeTileLabel.text = @"接触时间";
    [self.contactTimeTileLabel sizeToFit];
    self.contactTimeTileLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line6.frame), self.contactTimeTileLabel.frame.size.width, kLabelCellHeight);
    
    
    if(self.contactTimeTileLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.contactTimeTileLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.contactTimeTileLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.contactTimeLabel.frame = CGRectMake(x, CGRectGetMaxY(line6.frame), width, kLabelCellHeight);
    
    line7.frame = CGRectMake(x, CGRectGetMaxY(self.contactTimeLabel.frame), width + leftMargin, 1.0f);
    
    if(self.isEdit){
        line9.frame = CGRectMake(x, CGRectGetMaxY(self.contactTimeLabel.frame), width + leftMargin, 1.0f);
        
        self.managerTitleLabel.text = @"负责人";
        [self.managerTitleLabel sizeToFit];
        self.managerTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line9.frame), self.managerTitleLabel.frame.size.width, kLabelCellHeight);
        
        
        if(self.managerTitleLabel.frame.size.width > kcontentLabelLeftmargin){
            x = CGRectGetMaxX(self.managerTitleLabel.frame) + leftMargin;
            width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.managerTitleLabel.frame);
        }else{
            x = kcontentLabelLeftmargin;
            width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
        }
        self.managerLabel.frame = CGRectMake(x, CGRectGetMaxY(line9.frame), width, kLabelCellHeight);
        
        line7.frame = CGRectMake(x, CGRectGetMaxY(self.managerLabel.frame), width + leftMargin, 1.0f);

    }
    self.capitalInvestTitleLabel.text = @"IDG资本投资情况";
    [self.capitalInvestTitleLabel sizeToFit];
    self.capitalInvestTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line7.frame), self.capitalInvestTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.capitalInvestTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.capitalInvestTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.capitalInvestTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.capitalInvestLabel.frame = CGRectMake(x, CGRectGetMaxY(line7.frame), width, kLabelCellHeight);
    
    //
    self.importantStatusTitleLabel.text = @"是否重点项目";
    [self.importantStatusTitleLabel sizeToFit];
    self.importantStatusTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(line7.frame) + kLabelCellHeight, self.importantStatusTitleLabel.frame.size.width, kLabelCellHeight);
    
    if(self.importantStatusTitleLabel.frame.size.width > kcontentLabelLeftmargin){
        x = CGRectGetMaxX(self.importantStatusTitleLabel.frame) + leftMargin;
        width = Screen_Width - 2*leftMargin - CGRectGetMaxX(self.importantStatusTitleLabel.frame);
    }else{
        x = kcontentLabelLeftmargin;
        width = Screen_Width - leftMargin - kcontentLabelLeftmargin;
    }
    self.importantStatusLabel.frame = CGRectMake(x, CGRectGetMaxY(self.capitalInvestLabel.frame), width, kLabelCellHeight);
    
    marginView.frame = CGRectMake(0, CGRectGetMaxY(self.importantStatusLabel.frame), Screen_Width, 8.0);
    //
    self.ywjsTitleLabel.text = @"业务介绍";
    [self.ywjsTitleLabel sizeToFit];
    self.ywjsTitleLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(marginView.frame) + topMargin, self.ywjsTitleLabel.frame.size.width, bigTitleHeight);
    
    _ywjsLabel.font = [UIFont systemFontOfSize:16.f];
    _ywjsLabel.numberOfLines = 0;
    _ywjsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsLabel.backgroundColor = [UIColor clearColor];
    _ywjsLabel.textAlignment = NSTextAlignmentLeft;
    if(!self.model.bizDesc || (self.model.bizDesc && [self.model.bizDesc length] <= 0)){
        _ywjsLabel.text = @"请输入业务介绍";
        _ywjsLabel.textColor = RGBACOLOR(142.0, 142.0, 147.0, 1.0);
    }else{
        _ywjsLabel.text = self.model.bizDesc;
        _ywjsLabel.textColor = [UIColor blackColor];
    }
    CGSize ywjsContentLabelSize = [_ywjsLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _ywjsLabel.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.ywjsTitleLabel.frame) + 4, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    CGPoint lastPoint = [self.myContentScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(self.ywjsLabel.frame)) toView:[UIApplication sharedApplication].delegate.window];
    self.myContentScrollView.contentSize = CGSizeMake(Screen_Width, lastPoint.y);
    if(CGRectGetMaxY(_ywjsLabel.frame) < CGRectGetMaxY(self.frame)){
        self.myContentScrollView.frame = CGRectMake(0, 0, Screen_Width, CGRectGetMaxY(_ywjsLabel.frame)+topMargin + 4);
    }
    
}
- (void)findIndustryList {
    if (self.industryList.count) {
        return;
    }
    [HttpTool getWithPath:@"/project/potential/indus/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSMutableArray * data = [NSMutableArray arrayWithArray:JSON[@"data"]];
            for(NSObject * object in data){
                if(![object isKindOfClass:[NSNull class]]){
                    [self.industryList addObject:object];
                }
            }
                [self addSubview:self.myContentScrollView];
                [self setupUI];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}
- (UIView *)createLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kIDGNewLineColor;
    return view;
}
- (void)ywjsClick
{
    if([self.ywjsLabel.text isEqualToString:@"请输入业务介绍"]){
        self.ywjsLabel.text = @"";
    }
    CXLabelTextView *keyboard = [[CXLabelTextView alloc] initWithKeyboardType:UIKeyboardTypeDefault AndLabel:self.ywjsLabel];
    keyboard.delegate = self;
    keyboard.maxLengthOfString = 200;//pe业务介绍,最多200字
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:keyboard];
}
-(void)textView:(CXLabelTextView *)textView textWhenTextViewFinishingEdit:(NSString *)text
{
    self.model.bizDesc = text;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - 数据懒加载
- (UIScrollView *)myContentScrollView{
    if(nil == _myContentScrollView){
        _myContentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.frame))];
        _myContentScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
        [_myContentScrollView addSubview:self.titleLabel];
        [_myContentScrollView addSubview:self.ywjsLabel];
        [_myContentScrollView addSubview:self.ywjsTitleLabel];
        line1 = [self createLine];
        line2 = [self createLine];
        line3 = [self createLine];
        line4 = [self createLine];
        line5 = [self createLine];
        line6 = [self createLine];
        line7 = [self createLine];
        line8 = [self createLine];
        line9 = [self createLine];
        [_myContentScrollView addSubview:line1];
        [_myContentScrollView addSubview:line2];
        [_myContentScrollView addSubview:line3];
        [_myContentScrollView addSubview:line4];
        [_myContentScrollView addSubview:line5];
        [_myContentScrollView addSubview:line6];
        [_myContentScrollView addSubview:line7];
        [_myContentScrollView addSubview:line8];
        [_myContentScrollView addSubview:line9];
        marginView = [[UIView alloc]init];
        marginView.backgroundColor = SDBackGroudColor;
        [_myContentScrollView addSubview:marginView];
        _myContentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myContentScrollView;
}
- (NSMutableArray *)titleArray{
    if(nil == _titleArray){
        _titleArray = [NSMutableArray arrayWithObjects:self.projNameTitleLabel,self.currentLCTitleLabel,self.metStatusTitleLabel,self.industryTitleLabel,self.investGroupTitleLabel,self.cityTitleLabel,self.followStateTitleLabel,self.contactTimeTileLabel,self.managerTitleLabel,self.capitalInvestTitleLabel,self.importantStatusTitleLabel, nil];
    }
    return _titleArray;
}
- (NSMutableArray *)labelArray{
    if(nil == _labelArray){
        _labelArray = [NSMutableArray arrayWithObjects:self.projNameLabel, self.currentLCLabel, self.metStatusLabel, self.industryLabel, self.investGroupLabel, self.cityLabel, self.followStateLabel, self.contactTimeLabel, self.managerLabel, self.capitalInvestLabel,self.importantStatusLabel, nil];
    }
    return _labelArray;
}
- (UILabel *)titleLabel{
    if(nil == _titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
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
        _currentLCLabel.placeholder = @"请输入当前轮次";
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
        _metStatusLabel.showDropdown = YES;
        _metStatusLabel.allowEditing = YES;
        _metStatusLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _metStatusLabel.selectViewTitle = @"约见状态";
        _metStatusLabel.pickerTextArray = @[@"未约见",@"已约见"];
        _metStatusLabel.pickerValueArray = @[@"unDate",@"date"];
        CXWeakSelf(self)
        if (self.isEdit){//(self.formType == CXFormTypeDetail || self.formType == CXFormTypeModify) {
            CXStrongSelf(self)
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
        }else{
            self.model.invContactStatus = _metStatusLabel.pickerValueArray.firstObject;
            _metStatusLabel.content = _metStatusLabel.pickerTextArray.firstObject;
            _metStatusLabel.selectedPickerData = @{
                                              CXEditLabelCustomPickerTextKey : _metStatusLabel.pickerTextArray.firstObject,
                                              CXEditLabelCustomPickerValueKey : _metStatusLabel.pickerValueArray.firstObject
                                              };
        }
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

 //修改model属性
 
- (CXPEPotentialProjectModel *)rollBackData{
    if(!trim(self.projNameLabel.content).length){
        CXAlert(@"请输入项目名称");
        return nil;
    }
    
    _model.projName = self.projNameLabel.content;//名称
    _model.invRound = self.currentLCLabel.content;//轮次
//    self.model.invContactStatus = self.metStatusLabel.selectedPickerData[CXEditLabelCustomPickerTextKey];
//    self.model.comIndus = self.industryLabel.selectedPickerData[CXEditLabelCustomPickerTextKey];
    _model.invGroup = self.investGroupLabel.content;//投资机构
    _model.region = self.cityLabel.content;//城市
    _model.invDate = self.contactTimeLabel.content;//时间
    _model.bizDesc = [self.ywjsLabel.text isEqualToString:@"请输入业务介绍"] ? @"" : self.ywjsLabel.text;//业务介绍
    if ([self.importantStatusLabel.content isEqualToString:@"是"]) {
        _model.importantStatus = @(1);
    } else  if ([self.importantStatusLabel.content isEqualToString:@"是(新增)"]) {
        _model.importantStatus = @(2);
    } else{
        _model.importantStatus = @(3);
    }
    if(self.isEdit){
        _model.userName = self.managerLabel.content;
//        _model.invFlowUp = self.followStateLabel.content;
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
        _industryLabel.showDropdown = YES;
        _industryLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _industryLabel.selectViewTitle = @"行业";
        _industryLabel.pickerTextArray = self.industryList;
        _industryLabel.pickerValueArray = self.industryList;
        if (self.isEdit){//(self.formType == CXFormTypeDetail || self.formType == CXFormTypeModify) {
            if(self.model.comIndus){
                _industryLabel.content = self.model.comIndus;
                _industryLabel.selectedPickerData = @{
                                                CXEditLabelCustomPickerTextKey : self.model.comIndus,
                                                CXEditLabelCustomPickerValueKey : self.model.comIndus
                                                };
            }
        }else{
            self.model.comIndus = _industryLabel.pickerValueArray.firstObject;
            _industryLabel.content = _industryLabel.pickerTextArray.firstObject;
            _industryLabel.selectedPickerData = @{
                                            CXEditLabelCustomPickerTextKey : _industryLabel.pickerTextArray.firstObject,
                                            CXEditLabelCustomPickerValueKey : _industryLabel.pickerValueArray.firstObject
                                            };
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
        _investGroupLabel.placeholder = @"请输入投资机构";
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
        _cityLabel.placeholder = @"请输入所在城市";
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
        _followStateLabel.placeholder = @"请输入跟进状态";
        _followStateLabel.allowEditing = YES;
        _followStateLabel.showDropdown = YES;
        _followStateLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _followStateLabel.selectViewTitle = @"跟进状态";
//        flowUp 继续跟进   abandon 放弃  WS 观望
        _followStateLabel.pickerTextArray = @[@"继续跟进", @"放弃", @"观望"];
        _followStateLabel.pickerValueArray = @[@"flowUp", @"abandon", @"WS"];
        if (self.isEdit) {
            if([self.model.invFlowUp isEqualToString:@"flowUp"]){
                _followStateLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"继续跟进",
                                                           CXEditLabelCustomPickerValueKey : @"flowUp"
                                                           };
                _followStateLabel.content = @"继续跟进";
            }else if([self.model.invFlowUp isEqualToString:@"abandon"]){
                _followStateLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"放弃",
                                                           CXEditLabelCustomPickerValueKey : @"abandon"
                                                           };
                _followStateLabel.content = @"放弃";
            }else if([self.model.invFlowUp isEqualToString:@"WS"]){
                _followStateLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"观望",
                                                           CXEditLabelCustomPickerValueKey : @"WS"
                                                           };
                _followStateLabel.content = @"观望";
            }
        }else{
            self.model.invFlowUp = _followStateLabel.pickerValueArray.firstObject;
            _followStateLabel.content = _followStateLabel.pickerTextArray.firstObject;
            _followStateLabel.selectedPickerData = @{
                                                       CXEditLabelCustomPickerTextKey : _followStateLabel.pickerTextArray.firstObject,
                                                       CXEditLabelCustomPickerValueKey : _followStateLabel.pickerValueArray.firstObject
                                                       };
        }
        CXWeakSelf(self)
        _followStateLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"继续跟进"]){//        flowUp 继续跟进   abandon 放弃  WS 观望
                self.followStateLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"继续跟进",
                                                               CXEditLabelCustomPickerValueKey : @"flowUp"
                                                               };
                self.model.invFlowUp = @"flowUp";
            }else if([editLabel.content isEqualToString:@"放弃"]){
                self.followStateLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"放弃",
                                                               CXEditLabelCustomPickerValueKey : @"abandon"
                                                               };
                self.model.invFlowUp = @"abandon";
            }else if([editLabel.content isEqualToString:@"观望"]){
                self.followStateLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"观望",
                                                               CXEditLabelCustomPickerValueKey : @"WS"
                                                               };
                self.model.invFlowUp = @"WS";
            }
        };
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
        _managerLabel.userInteractionEnabled = NO;//负责人不能修改,只能是当前登录账户
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
        _capitalInvestLabel.showDropdown = YES;
        _capitalInvestLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _capitalInvestLabel.selectViewTitle = @"投资情况";
        _capitalInvestLabel.pickerTextArray = @[@"未投资", @"已投资"];
        _capitalInvestLabel.pickerValueArray = @[@"unInv", @"inv"];
        if (self.isEdit) {
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
        }else{
            self.model.invStatus = _capitalInvestLabel.pickerValueArray.firstObject;
            _capitalInvestLabel.content = _capitalInvestLabel.pickerTextArray.firstObject;
            _capitalInvestLabel.selectedPickerData = @{
                                                 CXEditLabelCustomPickerTextKey : _capitalInvestLabel.pickerTextArray.firstObject,
                                                 CXEditLabelCustomPickerValueKey : _capitalInvestLabel.pickerValueArray.firstObject
                                                 };
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
- (UILabel *)importantStatusTitleLabel{
    if(nil == _importantStatusTitleLabel){
        _importantStatusTitleLabel = [[UILabel alloc]init];
        _importantStatusTitleLabel.text = @"是否重点项目";
    }
    return _importantStatusTitleLabel;
}
- (CXEditLabel *)importantStatusLabel{
    if(_importantStatusLabel == nil){
        //重点项目
        _importantStatusLabel = [[CXEditLabel alloc] initWithFrame:CGRectZero];
        _importantStatusLabel.selectViewTitle = @"是否重点项目";
//        _importantStatusLabel.placeholder = @"是否重点项目";
        _importantStatusLabel.showDropdown = YES;
        _importantStatusLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _importantStatusLabel.pickerTextArray = @[@"是",@"是(新增)",@"否"];
        _importantStatusLabel.pickerValueArray = @[@(1),@(2),@(3)];
        if (self.isEdit) {
            if([self.model.importantStatus integerValue] == 1){
                _importantStatusLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"是",
                                                           CXEditLabelCustomPickerValueKey : @"1"
                                                           };
                _importantStatusLabel.content = @"是";
            }else if([[self.model.importantStatus stringValue] isEqualToString:@"2"]){
                _importantStatusLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                           CXEditLabelCustomPickerValueKey : @"2"
                                                           };
                _importantStatusLabel.content = @"是(新增)";
            }else if([[self.model.importantStatus stringValue] isEqualToString:@"3"]){
                _importantStatusLabel.selectedPickerData = @{
                                                           CXEditLabelCustomPickerTextKey : @"否",
                                                           CXEditLabelCustomPickerValueKey : @"3"
                                                           };
                _importantStatusLabel.content = @"否";
            }
        }else{
            self.model.importantStatus = _importantStatusLabel.pickerValueArray.firstObject;
            _importantStatusLabel.content = _importantStatusLabel.pickerTextArray.firstObject;
            _importantStatusLabel.selectedPickerData = @{
                                                       CXEditLabelCustomPickerTextKey : _importantStatusLabel.pickerTextArray.firstObject,
                                                       CXEditLabelCustomPickerValueKey : _importantStatusLabel.pickerValueArray.firstObject
                                                       };
        }
        CXWeakSelf(self)
        _importantStatusLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"是"]){
                self.importantStatusLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"是",
                                                               CXEditLabelCustomPickerValueKey : @"1"
                                                               };
                self.model.importantStatus = @(1);
            }else if([editLabel.content isEqualToString:@"2"]){
                self.importantStatusLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                               CXEditLabelCustomPickerValueKey : @"2"
                                                               };
                self.model.importantStatus = @(2);
            }else if([editLabel.content isEqualToString:@"3"]){
                self.capitalInvestLabel.selectedPickerData = @{
                                                               CXEditLabelCustomPickerTextKey : @"否",
                                                               CXEditLabelCustomPickerValueKey : @"3"
                                                               };
                self.model.importantStatus = @(3);
            }
        };

    }
    return _importantStatusLabel;
}
- (UILabel *)ywjsTitleLabel{
    if(nil == _ywjsTitleLabel){
        _ywjsTitleLabel = [[UILabel alloc]init];
        _ywjsTitleLabel.font = [UIFont systemFontOfSize:18.0];
        _ywjsTitleLabel.textColor = kColorWithRGB(50, 50, 50);
        _ywjsTitleLabel.userInteractionEnabled = YES;
        [_ywjsTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ywjsClick)]];
    }
    return _ywjsTitleLabel;
}
- (UILabel *)ywjsLabel{
    if(nil == _ywjsLabel){
        _ywjsLabel = [[UILabel alloc]init];
        _ywjsLabel.userInteractionEnabled = YES;
        [_ywjsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ywjsClick)]];
    }
    return _ywjsLabel;
}
- (CXPEPotentialProjectModel *)model{
    if(nil == _model){
        _model = [[CXPEPotentialProjectModel alloc]init];
    }
    return _model;
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
    self.projNameLabel.content = model.projName ?:@" ";
    self.contactTimeLabel.content = model.invDate ?:@" ";
    self.currentLCLabel.content = model.invRound ?:@" ";
    self.metStatusLabel.content = model.invContactStatus ?:@" ";
    self.followStateLabel.content = model.invFlowUp ?:@" ";

    self.industryLabel.content = model.comIndus ?:@" ";
    self.ywjsLabel.text = model.bizDesc ?:@" ";
    self.investGroupLabel.content = model.invGroup ?:@" ";
    self.cityLabel.content = model.region ?:@" ";
    self.capitalInvestLabel.content = model.invStatus ?:@" ";
    self.managerLabel.content = model.userName ?:@" ";
//    self.importantStatusLabel.content = [NSString stringWithFormat:@"%@", model.importantStatus] ;
    if ([[model.importantStatus stringValue] isEqualToString:@"1"]) {
        self.importantStatusLabel.content = @"是";
    } else if ([[model.importantStatus stringValue] isEqualToString:@"2"]) {
        self.importantStatusLabel.content = @"是(新增)";
    }else{
        self.importantStatusLabel.content = @"否";
    }
    
    _metStatusLabel = nil;
    _followStateLabel = nil;
    _industryLabel = nil;
    _capitalInvestLabel = nil;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)dealloc{
    RePlaceMethod([self class], [CXEditLabel class],NSSelectorFromString(@"newdropdownImageView"),NSSelectorFromString(@"dropdownImageView"));
}
@end
