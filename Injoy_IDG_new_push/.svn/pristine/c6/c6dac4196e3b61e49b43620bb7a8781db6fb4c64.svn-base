//
//  CXAddPotentialFollowVIew.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAddPotentialFollowVIew.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#define uinitpx (Screen_Width/375.0)
#define selfHeight (219 * uinitpx)
#define titleFont [UIFont systemFontOfSize:16.f]
#define titleColor kColorWithRGB(132, 142, 153)
#define contentsFont [UIFont systemFontOfSize:16.f]
#define contentColor kColorWithRGB(31, 34, 40)
#define leftMarin (15.0 * uinitpx)
#define topMargin (16.0 * uinitpx)
#define rightLabelX (99 * uinitpx)
#define titleLabelHeight (22 * uinitpx)
@interface CXAddPotentialFollowVIew()
//日期
@property (nonatomic, strong) UILabel *dateTitleLabel;
@property (nonatomic, strong) CXEditLabel *dateLabel;

//与会者
@property (nonatomic, strong) UILabel *YHZTitleLabel;
@property (nonatomic, strong) CXEditLabel *YHZLabel;
//跟进状态
@property (nonatomic, strong) UILabel *followStateTitleLabel;
@property (nonatomic, strong) CXEditLabel *followStateLabel;
//Keynote
@property (nonatomic, strong) UILabel *keyNoteTitlelabel;
@property (nonatomic, strong) CXEditLabel *keyNoteLabel;

@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, assign) BOOL isDetail;
@end
CG_INLINE NSString *getStringDate(NSDate *date){
    NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    return [fomatter stringFromDate:date];
}
@implementation CXAddPotentialFollowVIew{
    UIView *line1;
    UIView *line2;
    UIView *line3;
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)]){
        self.backgroundColor = SDBackGroudColor;
        [self setUpLine];
        [self addSubview:self.myScrollView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.myScrollView.frame = CGRectMake(0, 0, Screen_Width, selfHeight);
    
    self.dateTitleLabel.text  = @"日期";
    [self.dateTitleLabel sizeToFit];
    self.dateTitleLabel.frame = CGRectMake(leftMarin, topMargin, self.dateTitleLabel.frame.size.width, titleLabelHeight);
    self.dateLabel.frame      = CGRectMake(rightLabelX, topMargin, Screen_Width - rightLabelX - leftMarin, titleLabelHeight);
    line1.frame               = CGRectMake(rightLabelX, CGRectGetMaxY(self.dateTitleLabel.frame) + topMargin, Screen_Width - rightLabelX, 1.0f);
    
    self.YHZTitleLabel.text   = @"与会者";
    [self.YHZTitleLabel sizeToFit];
    self.YHZTitleLabel.frame  = CGRectMake(leftMarin, CGRectGetMaxY(line1.frame) + topMargin, self.YHZTitleLabel.frame.size.width, titleLabelHeight);
    self.YHZLabel.frame       = CGRectMake(rightLabelX, CGRectGetMaxY(line1.frame) + topMargin, Screen_Width - rightLabelX - leftMarin, titleLabelHeight);
    line2.frame               = CGRectMake(rightLabelX, CGRectGetMaxY(self.YHZLabel.frame) + topMargin, Screen_Width - rightLabelX, 1.0f);
    
    self.followStateTitleLabel.text   = @"跟进状态";
    [self.followStateTitleLabel sizeToFit];
    self.followStateTitleLabel.frame  = CGRectMake(leftMarin, CGRectGetMaxY(line2.frame) + topMargin, self.followStateTitleLabel.frame.size.width, titleLabelHeight);
    self.followStateLabel.frame       = CGRectMake(rightLabelX, CGRectGetMaxY(line2.frame) + topMargin, Screen_Width - rightLabelX - leftMarin, titleLabelHeight);
    line3.frame                       = CGRectMake(rightLabelX, CGRectGetMaxY(self.followStateTitleLabel.frame) + topMargin, Screen_Width - rightLabelX, 1.0f);
    
    self.keyNoteTitlelabel.text   = @"Keynote";
    [self.keyNoteTitlelabel sizeToFit];
    self.keyNoteTitlelabel.frame  = CGRectMake(leftMarin, CGRectGetMaxY(line3.frame) + topMargin, self.keyNoteTitlelabel.frame.size.width, titleLabelHeight);
    if(height > titleLabelHeight && trim(self.model.keyNote).length)
        self.keyNoteLabel.frame       = CGRectMake(rightLabelX, CGRectGetMaxY(line3.frame) + topMargin, Screen_Width - rightLabelX - leftMarin, height);
    else{
        self.keyNoteLabel.frame       = CGRectMake(rightLabelX, CGRectGetMaxY(line3.frame) + topMargin, Screen_Width - rightLabelX - leftMarin, titleLabelHeight);
    }
    CGRect frame;
    frame                    = self.myScrollView.frame;
    if((CGRectGetMaxY(self.keyNoteLabel.frame) + topMargin) < (Screen_Height - navHigh)){
        frame.size.height    = CGRectGetMaxY(self.keyNoteLabel.frame) + topMargin;
    }else{
        frame.size.height    = Screen_Height - navHigh;
    }
    self.myScrollView.frame  = frame;
    //  CGPoint point = [self.myScrollView convertPoint:CGPointMake(0, CGRectGetMaxY(self.keyNoteLabel.frame) + topMargin) toView:[UIApplication sharedApplication].delegate.window];
    self.myScrollView.contentSize = CGSizeMake(Screen_Width, CGRectGetMaxY(self.keyNoteLabel.frame) + topMargin);
    
    
    
}
- (void)setUpLine{
    line1 = [self createLineView];
    line2 = [self createLineView];
    line3 = [self createLineView];
}
- (UIView *)createLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kIDGNewLineColor;
    return line;
}
- (void)updateFrame:(CGFloat)cheight{
    height = cheight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (UIScrollView *)myScrollView{
    if(nil == _myScrollView){
        _myScrollView = [[UIScrollView alloc]init];
        _myScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
        [_myScrollView addSubview:self.dateTitleLabel];
        [_myScrollView addSubview:self.dateLabel];
        [_myScrollView addSubview:line1];
        [_myScrollView addSubview:self.YHZTitleLabel];
        [_myScrollView addSubview:self.YHZLabel];
        [_myScrollView addSubview:line2];
        [_myScrollView addSubview:self.followStateTitleLabel];
        [_myScrollView addSubview:self.followStateLabel];
        [_myScrollView addSubview:line3];
        [_myScrollView addSubview:self.keyNoteTitlelabel];
        [_myScrollView addSubview:self.keyNoteLabel];
        
    }
    return _myScrollView;
}
- (UILabel *)dateTitleLabel{
    if(nil == _dateTitleLabel){
        _dateTitleLabel = [[UILabel alloc]init];
        _dateTitleLabel.font = titleFont;
        _dateTitleLabel.textColor = titleColor;
    }
    return _dateTitleLabel;
}
- (CXEditLabel *)dateLabel{
    if(nil == _dateLabel){
        _dateLabel               = [[CXEditLabel alloc]init];
        _dateLabel.showNewDropdown  = YES;
        _dateLabel.inputType     = CXEditLabelInputTypeDate;
        _dateLabel.font          = contentsFont;
        _dateLabel.textColor     = contentColor;
        CXWeakSelf(self)
        _dateLabel.didFinishEditingBlock = ^(CXEditLabel *label){
            weakself.model.devDate = label.content;
        };
    }
    return _dateLabel;
}
- (UILabel *)YHZTitleLabel{
    if(nil == _YHZTitleLabel){
        _YHZTitleLabel           = [[UILabel alloc]init];
        _YHZTitleLabel.font      = titleFont;
        _YHZTitleLabel.textColor = titleColor;
    }
    return  _YHZTitleLabel;
}
- (CXEditLabel *)YHZLabel{
    if(nil == _YHZLabel){
        _YHZLabel = [[CXEditLabel alloc]init];
        _YHZLabel.font          = contentsFont;
        _YHZLabel.textColor     = contentColor;
        CXWeakSelf(self)
        _YHZLabel.didFinishEditingBlock = ^(CXEditLabel *label){
            weakself.model.followPerson = label.content;
        };
    }
    return _YHZLabel;
}
- (UILabel *)followStateTitleLabel{
    if(nil == _followStateTitleLabel){
        _followStateTitleLabel           = [[UILabel alloc]init];
        _followStateTitleLabel.font      = titleFont;
        _followStateTitleLabel.textColor = titleColor;
        
    }
    return _followStateTitleLabel;
}
- (CXEditLabel *)followStateLabel{
    if(nil == _followStateLabel){
        _followStateLabel                  = [[CXEditLabel alloc]init];
        _followStateLabel.selectViewTitle = @"跟进状态";
        _followStateLabel.showNewDropdown     = YES;
        _followStateLabel.font             = contentsFont;
        _followStateLabel.textColor        = contentColor;
        _followStateLabel.inputType        = CXEditLabelInputTypeCustomPicker;
        _followStateLabel.pickerTextArray  = @[@"继续跟进", @"放弃", @"观望"];
        _followStateLabel.pickerValueArray = @[@"flowUp", @"abandon", @"WS"];
        if (self.isDetail) {
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
            if([editLabel.content isEqualToString:@"继续跟进"]){
                self.followStateLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"继续跟进",
                                                      CXEditLabelCustomPickerValueKey : @"flowUp"
                                                      };
                self.followStateLabel.content = @"继续跟进";
                self.model.invFlowUp = @"flowUp";
            }else if([editLabel.content isEqualToString:@"放弃"]){
                self.followStateLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"放弃",
                                                      CXEditLabelCustomPickerValueKey : @"abandon"
                                                      };
                self.followStateLabel.content = @"放弃";
                self.model.invFlowUp = @"abandon";
            }else if([editLabel.content isEqualToString:@"观望"]){
                self.followStateLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"观望",
                                                      CXEditLabelCustomPickerValueKey : @"WS"
                                                      };
                self.followStateLabel.content = @"观望";
                self.model.invFlowUp = @"WS";
            }
        };
    }
    return  _followStateLabel;
}
- (UILabel *)keyNoteTitlelabel{
    if(nil == _keyNoteTitlelabel){
        _keyNoteTitlelabel           = [[UILabel alloc]init];
        _keyNoteTitlelabel.font      = titleFont;
        _keyNoteTitlelabel.textColor = titleColor;
    }
    return _keyNoteTitlelabel;
}
- (CXEditLabel *)keyNoteLabel{
    if(nil == _keyNoteLabel){
        _keyNoteLabel = [[CXEditLabel alloc]init];
        CXWeakSelf(self)
        _keyNoteLabel.font          = contentsFont;
        _keyNoteLabel.textColor     = contentColor;
        _keyNoteLabel.numberOfLines = 0;
        _keyNoteLabel.scale = YES;
        _keyNoteLabel.needUpdateFrameBlock = ^(CXEditLabel *label , CGFloat Height){
            if(trim(label.content).length){
                weakself.model.keyNote = label.content;
            }
            [weakself updateFrame:Height];
        };
    }
    return _keyNoteLabel;
}
- (void)setModel:(CXPotentialFollowListModel *)model{
    if(model == nil){
        return;
    }
    _model                        = model;
    self.dateLabel.content        = model.devDate?:getStringDate([NSDate date]);
    self.YHZLabel.content         = model.followPerson?:@" ";
    self.keyNoteLabel.content     = model.keyNote?:@" ";
    self.isDetail                 = YES;
    [self.followStateLabel removeFromSuperview];
    self.followStateLabel         = nil;
    [self.myScrollView addSubview:self.followStateLabel];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

@end
