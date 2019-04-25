//
//  CXHouseProjectDetailInfoView.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectDetailInfoView.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "UILabel + HPCategory.h"
@interface CXHouseProjectDetailInfoView()
/***** 建筑面积相关 ****/
@property (nonatomic, strong) UILabel *floorSpaceTitleLabel;
@property (nonatomic, strong) UILabel *floorSpaceLabel;
/***** 土地指标 ****/
@property (nonatomic, strong) UILabel *landIndicatorTitleLabel;
@property (nonatomic, strong) UILabel *landIndicatorLabel;
/***** 证照及法律手续 ****/
@property (nonatomic, strong) UILabel *legalFormalitiesTitleLabel;
@property (nonatomic, strong) UILabel *legalFormlitiesLabel;
/***** 市场描述 ****/
@property (nonatomic, strong) UILabel *marketDescTitleLabel;
@property (nonatomic, strong) UILabel *marketDescLabel;
/***** 风险提示 ****/
@property (nonatomic, strong) UILabel *riskDescTitleLabel;
@property (nonatomic, strong) UILabel *riskDescLabel;
/***** 交易对手及合作伙伴 ****/
@property (nonatomic, strong) UILabel *teamDescTitleLabel;
@property (nonatomic, strong) UILabel *teamDescLabel;
/***** 时间节点 ***********/
@property (nonatomic, strong) UILabel *timeNodeTitleLabel;
@property (nonatomic, strong) UILabel *timeNodeLabel;
/***** 交易思路 ****/
@property (nonatomic, strong) UILabel *tradeThinkingTitleLabel;
@property (nonatomic, strong) UILabel *tradeThinkingLabel;
/***** 退出总结 ****/
@property (nonatomic, strong) UILabel *withdrawSummaryTitleLabel;
@property (nonatomic, strong) UILabel *withdrawSummaryLabel;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) UIScrollView *myScrollView;
@end
#define margin 15.f
#define kLabelHeight 32.f
#define labelmargin 10.f
@implementation CXHouseProjectDetailInfoView{
    CGFloat labelTopMargin;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    [self addSubview:self.myScrollView];
    [self.titleLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = kColorWithRGB(132, 142, 153);
        [self.myScrollView addSubview:label];
    }];

    [self.labelArray enumerateObjectsUsingBlock:^(CXEditLabel *label, NSUInteger idx, BOOL *stop){
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = kColorWithRGB(31, 34, 40);
        label.numberOfLines = 0;
        [self.myScrollView addSubview:label];
    }];
}

- (void)layoutSubviews{
    _floorSpaceTitleLabel.text = @"建筑面积相关";
    [_floorSpaceTitleLabel sizeToFit];
    CGFloat height = _floorSpaceTitleLabel.frame.size.height;
    _floorSpaceTitleLabel.frame = CGRectMake(margin, 0, _floorSpaceTitleLabel.frame.size.width, kLabelHeight);
    labelTopMargin = (kLabelHeight - height)/2.0;

    CGFloat x;
    CGFloat width;
    CXWeakSelf(self);
    if( _floorSpaceTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_floorSpaceTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_floorSpaceTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _floorSpaceLabel.frame =CGRectMake(x , 0, width, kLabelHeight);
    _floorSpaceLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _floorSpaceLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _landIndicatorTitleLabel.text = @"土地指标";
    [_landIndicatorTitleLabel sizeToFit];
    _landIndicatorTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_floorSpaceLabel.frame), _landIndicatorTitleLabel.frame.size.width, kLabelHeight);

    if( _landIndicatorTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_landIndicatorTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_landIndicatorTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _landIndicatorLabel.frame =CGRectMake(x , CGRectGetMaxY(_floorSpaceLabel.frame), width, kLabelHeight);
    _landIndicatorLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _landIndicatorLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _legalFormalitiesTitleLabel.text = @"证照及法律手续";
    [_legalFormalitiesTitleLabel sizeToFit];
    _legalFormalitiesTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_landIndicatorLabel.frame), _legalFormalitiesTitleLabel.frame.size.width, kLabelHeight);

    if( _legalFormalitiesTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_legalFormalitiesTitleLabel.frame)+labelmargin;
        width = Screen_Width - 2*margin - CGRectGetWidth(_legalFormalitiesTitleLabel.frame) - labelmargin;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _legalFormlitiesLabel.frame =CGRectMake(x , CGRectGetMaxY(_landIndicatorLabel.frame), width, kLabelHeight);
    _legalFormlitiesLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _legalFormlitiesLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };
    _marketDescTitleLabel.text = @"市场描述";
    [_marketDescTitleLabel sizeToFit];
    _marketDescTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_legalFormlitiesLabel.frame), _marketDescTitleLabel.frame.size.width, kLabelHeight);

    if( _marketDescTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_marketDescTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_marketDescTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _marketDescLabel.frame =CGRectMake(x , CGRectGetMaxY(_legalFormlitiesLabel.frame), width, kLabelHeight);
    _marketDescLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _marketDescLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _riskDescTitleLabel.text = @"风险提示";
    [_riskDescTitleLabel sizeToFit];
    _riskDescTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_marketDescLabel.frame), _riskDescTitleLabel.frame.size.width, kLabelHeight);

    if( _riskDescTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_riskDescTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_riskDescTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _riskDescLabel.frame =CGRectMake(x , CGRectGetMaxY(_marketDescLabel.frame), width, kLabelHeight);
    _riskDescLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _riskDescLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _teamDescTitleLabel.text = @"交易对手及合作伙伴";
    [_teamDescTitleLabel sizeToFit];
    _teamDescTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_riskDescLabel.frame), _teamDescTitleLabel.frame.size.width, kLabelHeight);

    if( _teamDescTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_teamDescTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_teamDescTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _teamDescLabel.frame =CGRectMake(x , CGRectGetMaxY(_riskDescLabel.frame), width, kLabelHeight);
    _teamDescLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _teamDescLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _timeNodeTitleLabel.text = @"时间节点";
    [_timeNodeTitleLabel sizeToFit];
    _timeNodeTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_teamDescLabel.frame), _timeNodeTitleLabel.frame.size.width, kLabelHeight);

    if( _timeNodeTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_timeNodeTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_timeNodeTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _timeNodeLabel.frame =CGRectMake(x , CGRectGetMaxY(_teamDescLabel.frame), width, kLabelHeight);
    _timeNodeLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _timeNodeLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _tradeThinkingTitleLabel.text = @"交易思路";
    [_tradeThinkingTitleLabel sizeToFit];
    _tradeThinkingTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_tradeThinkingLabel.frame), _tradeThinkingTitleLabel.frame.size.width, kLabelHeight);

    if( _tradeThinkingTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_tradeThinkingTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_tradeThinkingTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _tradeThinkingLabel.frame =CGRectMake(x , CGRectGetMaxY(_tradeThinkingLabel.frame), width, kLabelHeight);
    _tradeThinkingLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _tradeThinkingLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };

    _withdrawSummaryTitleLabel.text = @"退出总结";
    [_withdrawSummaryTitleLabel sizeToFit];
    _withdrawSummaryTitleLabel.frame = CGRectMake(margin, CGRectGetMaxY(_tradeThinkingLabel.frame), _withdrawSummaryTitleLabel.frame.size.width, kLabelHeight);

    if( _withdrawSummaryTitleLabel.frame.size.width + margin > 108){
        x =  CGRectGetMaxX(_withdrawSummaryTitleLabel.frame)+5;
        width = Screen_Width - 2*margin - CGRectGetWidth(_withdrawSummaryTitleLabel.frame) - 5;
    }else{
        x= 108;
        width = Screen_Width - 2*margin - 108;
    }

    _withdrawSummaryLabel.frame =CGRectMake(x , CGRectGetMaxY(_tradeThinkingLabel.frame), width, kLabelHeight);
    _withdrawSummaryLabel.sw_contentInsets = UIEdgeInsetsMake(labelTopMargin, 0, -labelTopMargin, 0);
    _withdrawSummaryLabel.needUpdateFrameBlock = ^(UILabel *editLabel , CGFloat height){
        [weakself updateFrameWithLabel:editLabel andHeight:height];
    };
}

- (void)updateFrameWithLabel:(UILabel *)label andHeight:(CGFloat)height{
    if(label == _floorSpaceLabel){
        _floorSpaceLabel.height = height;
        _landIndicatorTitleLabel.top = _floorSpaceLabel.bottom;
        _landIndicatorLabel.top = _floorSpaceLabel.bottom;
        _legalFormlitiesLabel.top = _landIndicatorLabel.bottom;
        _legalFormalitiesTitleLabel.top = _landIndicatorLabel.bottom;
        _marketDescTitleLabel.top = _legalFormlitiesLabel.bottom;
        _marketDescLabel.top = _legalFormlitiesLabel.bottom;
        _riskDescTitleLabel.top = _marketDescLabel.bottom;
        _riskDescLabel.top = _marketDescLabel.bottom;
        _teamDescLabel.top = _riskDescLabel.bottom;
        _teamDescTitleLabel.top = _riskDescLabel.bottom;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _landIndicatorLabel){
        _landIndicatorLabel.height = height;
        _legalFormlitiesLabel.top = _landIndicatorLabel.bottom;
        _legalFormalitiesTitleLabel.top = _landIndicatorLabel.bottom;
        _marketDescTitleLabel.top = _legalFormlitiesLabel.bottom;
        _marketDescLabel.top = _legalFormlitiesLabel.bottom;
        _riskDescTitleLabel.top = _marketDescLabel.bottom;
        _riskDescLabel.top = _marketDescLabel.bottom;
        _teamDescLabel.top = _riskDescLabel.bottom;
        _teamDescTitleLabel.top = _riskDescLabel.bottom;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _legalFormlitiesLabel){
        _legalFormlitiesLabel.height = height;
        _marketDescTitleLabel.top = _legalFormlitiesLabel.bottom;
        _marketDescLabel.top = _legalFormlitiesLabel.bottom;
        _riskDescTitleLabel.top = _marketDescLabel.bottom;
        _riskDescLabel.top = _marketDescLabel.bottom;
        _teamDescLabel.top = _riskDescLabel.bottom;
        _teamDescTitleLabel.top = _riskDescLabel.bottom;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _marketDescLabel){
        _marketDescLabel.height = height;
        _riskDescTitleLabel.top = _marketDescLabel.bottom;
        _riskDescLabel.top = _marketDescLabel.bottom;
        _teamDescLabel.top = _riskDescLabel.bottom;
        _teamDescTitleLabel.top = _riskDescLabel.bottom;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _riskDescLabel){
        _riskDescLabel.height = height;
        _teamDescLabel.top = _riskDescLabel.bottom;
        _teamDescTitleLabel.top = _riskDescLabel.bottom;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _teamDescLabel){
        _teamDescLabel.height = height;
        _timeNodeTitleLabel.top = _teamDescLabel.bottom;
        _timeNodeLabel.top = _teamDescLabel.bottom;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _timeNodeLabel){
        _timeNodeLabel.height = height;
        _tradeThinkingLabel.top = _timeNodeLabel.bottom;
        _tradeThinkingTitleLabel.top = _timeNodeLabel.bottom;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _tradeThinkingLabel){
        _tradeThinkingLabel.height = height;
        _withdrawSummaryTitleLabel.top = _tradeThinkingLabel.bottom;
        _withdrawSummaryLabel.top = _tradeThinkingLabel.bottom;
    }else if (label == _withdrawSummaryLabel){
        _withdrawSummaryLabel.height  = height;
    }
    _myScrollView.contentSize = CGSizeMake(Screen_Width, _withdrawSummaryLabel.bottom - _floorSpaceLabel.top);//CGRectGetMaxY(_withdrawSummaryLabel.bounds) - CGRectGetMinY(_floorSpaceLabel.bounds));
}
#pragma mark - 数据懒加载
- (UIScrollView *)myScrollView{
    if(nil == _myScrollView){
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.frame))];
    }
    return _myScrollView;
}
- (NSMutableArray *)titleLabelArray{
    if(nil == _titleLabelArray){
        _titleLabelArray = [NSMutableArray arrayWithObjects:self.floorSpaceTitleLabel, self.landIndicatorTitleLabel, self.legalFormalitiesTitleLabel, self.marketDescTitleLabel, self.riskDescTitleLabel, self.teamDescTitleLabel, self.timeNodeTitleLabel, self.tradeThinkingTitleLabel, nil];
    }
    return _titleLabelArray;
}
- (NSMutableArray *)labelArray{
    if(nil == _labelArray){
        _labelArray = [NSMutableArray arrayWithObjects:self.floorSpaceLabel, self.landIndicatorLabel, self.legalFormlitiesLabel, self.marketDescLabel, self.riskDescLabel, self.teamDescLabel, self.timeNodeLabel, self.tradeThinkingLabel, self.withdrawSummaryLabel, nil];
    }
    return _labelArray;
}
- (UILabel *)floorSpaceTitleLabel{
    if(nil == _floorSpaceTitleLabel){
        _floorSpaceTitleLabel = [[UILabel alloc]init];
    }
    return _floorSpaceTitleLabel;
}
- (UILabel *)floorSpaceLabel{
    if(nil == _floorSpaceLabel){
        _floorSpaceLabel = [[UILabel alloc]init];
    }
    return _floorSpaceLabel;
}
- (UILabel *)legalFormalitiesTitleLabel{
    if(nil == _legalFormlitiesLabel){
        _legalFormalitiesTitleLabel = [[UILabel alloc]init];
    }
    return _legalFormalitiesTitleLabel;
}
- (UILabel *)legalFormlitiesLabel{
    if(nil == _legalFormlitiesLabel){
        _legalFormlitiesLabel = [[UILabel alloc]init];
    }
    return _legalFormlitiesLabel;
}
- (UILabel *)landIndicatorTitleLabel{
    if(nil == _landIndicatorTitleLabel){
        _landIndicatorTitleLabel = [[UILabel alloc]init];
    }
    return _landIndicatorTitleLabel;
}
- (UILabel *)landIndicatorLabel{
    if(nil == _landIndicatorLabel){
        _landIndicatorLabel = [[UILabel alloc]init];
    }
    return _landIndicatorLabel;
}
- (UILabel *)marketDescTitleLabel{
    if(nil == _marketDescTitleLabel){
        _marketDescTitleLabel = [[UILabel alloc]init];
    }
    return _marketDescTitleLabel;
}
- (UILabel *)marketDescLabel{
    if(nil == _marketDescLabel){
        _marketDescLabel = [[UILabel alloc]init];
    }
    return _marketDescLabel;
}
- (UILabel *)riskDescTitleLabel{
    if(nil == _riskDescTitleLabel){
        _riskDescTitleLabel = [[UILabel alloc]init];
    }
    return _riskDescTitleLabel;
}
- (UILabel *)riskDescLabel{
    if(nil == _riskDescLabel){
        _riskDescLabel = [[UILabel alloc]init];
    }
    return _riskDescLabel;
}
- (UILabel *)teamDescTitleLabel{
    if(nil == _teamDescTitleLabel){
        _teamDescTitleLabel = [[UILabel alloc]init];
    }
    return _teamDescTitleLabel;
}
- (UILabel *)teamDescLabel{
    if(nil == _teamDescLabel){
        _teamDescLabel = [[UILabel alloc]init];
    }
    return _teamDescLabel;
}
- (UILabel *)timeNodeTitleLabel{
    if(nil == _timeNodeTitleLabel){
        _timeNodeTitleLabel = [[UILabel alloc]init];
    }
    return _timeNodeTitleLabel;
}
- (UILabel *)timeNodeLabel{
    if(nil == _timeNodeLabel){
        _timeNodeLabel = [[UILabel alloc]init];
    }
    return _timeNodeLabel;
}
- (UILabel *)tradeThinkingTitleLabel{
    if(nil == _tradeThinkingTitleLabel){
        _tradeThinkingTitleLabel = [[UILabel alloc]init];
    }
    return _tradeThinkingTitleLabel;
}
- (UILabel *)tradeThinkingLabel{
    if(nil == _tradeThinkingLabel){
        _tradeThinkingLabel = [[UILabel alloc]init];
    }
    return _tradeThinkingLabel;
}
- (UILabel *)withdrawSummaryTitleLabel{
    if(nil == _withdrawSummaryTitleLabel){
        _withdrawSummaryTitleLabel = [[UILabel alloc]init];
    }
    return _withdrawSummaryTitleLabel;
}
- (UILabel *)withdrawSummaryLabel{
    if(nil == _withdrawSummaryLabel){
        _withdrawSummaryLabel = [[UILabel alloc]init];
    }
    return _withdrawSummaryLabel;
}
- (void)setModel:(CXHouseProjectDetialInfoModel *)model{
    _model = model;
    self.floorSpaceLabel.content = model.floorSpace;
    self.landIndicatorLabel.content = model.landIndicator;
    self.legalFormlitiesLabel.content = model.legalFormalities;
    self.marketDescLabel.content = model.marketDesc;
    self.riskDescLabel.content = model.riskDesc;
    self.teamDescLabel.content = model.teamDesc;
    self.timeNodeLabel.content = model.timeNode;
    self.tradeThinkingLabel.content = model.tradeThinking;
    self.withdrawSummaryLabel.content = model.withdrawSummary;
    [self setNeedsLayout];
}
@end

