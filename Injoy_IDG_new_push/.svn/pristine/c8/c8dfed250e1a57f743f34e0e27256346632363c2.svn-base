//
//  CXHouseProjectDetailInfo2.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectDetailInfo2.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"

@interface CXHouseProjectDetailInfo2()
/***** 建筑面积相关 ****/
@property (nonatomic, strong) CXEditLabel *floorSpaceLabel;
/***** 土地指标 ****/
@property (nonatomic, strong) CXEditLabel *landIndicatorLabel;
/***** 证照及法律手续 ****/
@property (nonatomic, strong) CXEditLabel *legalFormlitiesLabel;
/***** 市场描述 ****/
@property (nonatomic, strong) CXEditLabel *marketDescLabel;
/***** 风险提示 ****/
@property (nonatomic, strong) CXEditLabel *riskDescLabel;
/***** 交易对手及合作伙伴 ****/
@property (nonatomic, strong) CXEditLabel *teamDescLabel;
/***** 时间节点 ***********/
@property (nonatomic, strong) CXEditLabel *timeNodeLabel;
/***** 交易思路 ****/
@property (nonatomic, strong) CXEditLabel *tradeThinkingLabel;
/***** 退出总结 ****/
@property (nonatomic, strong) CXEditLabel *withdrawSummaryLabel;

@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) UIScrollView *myScrollView;
@end
@implementation CXHouseProjectDetailInfo2
#define margin 10.f
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = kColorWithRGB(255, 255, 255);
//        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    [self addSubview:self.myScrollView];
    [self.labelArray enumerateObjectsUsingBlock:^(CXEditLabel *label, NSUInteger idx, BOOL *stop){
        label.numberOfLines = 0;
        [self.myScrollView addSubview:label];
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.floorSpaceLabel.frame = CGRectMake(margin, 0, Screen_Width - 2*margin, self.floorSpaceLabel.textHeight + self.floorSpaceLabel.paddingTopBottom);
    self.landIndicatorLabel.frame = CGRectMake(margin, self.floorSpaceLabel.bottom, Screen_Width - 2*margin, self.landIndicatorLabel.textHeight + self.landIndicatorLabel.paddingTopBottom);
    self.legalFormlitiesLabel.frame = CGRectMake(margin, self.landIndicatorLabel.bottom, Screen_Width - 2*margin, self.legalFormlitiesLabel.textHeight + self.legalFormlitiesLabel.paddingTopBottom);
    self.marketDescLabel.frame = CGRectMake(margin, self.legalFormlitiesLabel.bottom, Screen_Width - 2*margin, self.marketDescLabel.textHeight + self.marketDescLabel.paddingTopBottom);
    self.riskDescLabel.frame = CGRectMake(margin, self.marketDescLabel.bottom, Screen_Width - 2*margin, self.riskDescLabel.textHeight + self.riskDescLabel.paddingTopBottom);
    self.teamDescLabel.frame = CGRectMake(margin, self.riskDescLabel.bottom, Screen_Width - 2*margin, self.teamDescLabel.textHeight + self.teamDescLabel.paddingTopBottom);
    self.timeNodeLabel.frame = CGRectMake(margin, self.teamDescLabel.bottom, Screen_Width - 2*margin, self.timeNodeLabel.textHeight + self.timeNodeLabel.paddingTopBottom);
    self.tradeThinkingLabel.frame = CGRectMake(margin, self.timeNodeLabel.bottom, Screen_Width - 2*margin, self.tradeThinkingLabel.textHeight + self.tradeThinkingLabel.paddingTopBottom);
    self.withdrawSummaryLabel.frame = CGRectMake(margin, self.tradeThinkingLabel.bottom, Screen_Width - 2*margin, self.withdrawSummaryLabel.textHeight + self.withdrawSummaryLabel.paddingTopBottom);
    NSLog(@"%@ %f %@", NSStringFromCGRect(self.withdrawSummaryLabel.frame), self.withdrawSummaryLabel.bottom, NSStringFromCGRect(self.withdrawSummaryLabel.bounds));
    CGPoint bottomPoint = [self.myScrollView convertPoint:CGPointMake(0, self.withdrawSummaryLabel.bottom) toView:[UIApplication sharedApplication].delegate.window];
    self.myScrollView.contentSize = CGSizeMake(Screen_Width, bottomPoint.y);//self.withdrawSummaryLabel.bottom + 50.f +navHigh);
    
}
#pragma mark - 数据懒加载
- (UIScrollView *)myScrollView{
    if(nil == _myScrollView){
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.frame))];
    }
    return _myScrollView;
}
- (NSMutableArray *)labelArray{
    if(nil == _labelArray){
        _labelArray = [NSMutableArray arrayWithObjects:self.floorSpaceLabel, self.landIndicatorLabel, self.legalFormlitiesLabel, self.marketDescLabel, self.riskDescLabel, self.teamDescLabel, self.timeNodeLabel, self.tradeThinkingLabel, self.withdrawSummaryLabel, nil];
    }
    return _labelArray;
}

- (CXEditLabel *)floorSpaceLabel{
    if(nil == _floorSpaceLabel){
        _floorSpaceLabel = [[CXEditLabel alloc]init];
        _floorSpaceLabel.title = @"建筑面积相关：";
    }
    return _floorSpaceLabel;
}

- (CXEditLabel *)legalFormlitiesLabel{
    if(nil == _legalFormlitiesLabel){
        _legalFormlitiesLabel = [[CXEditLabel alloc]init];
        _legalFormlitiesLabel.text = @"证照及法律手续：";
    }
    return _legalFormlitiesLabel;
}

- (CXEditLabel *)landIndicatorLabel{
    if(nil == _landIndicatorLabel){
        _landIndicatorLabel = [[CXEditLabel alloc]init];
        _landIndicatorLabel.title = @"土地指标：";
    }
    return _landIndicatorLabel;
}

- (CXEditLabel *)marketDescLabel{
    if(nil == _marketDescLabel){
        _marketDescLabel = [[CXEditLabel alloc]init];
        _marketDescLabel.title = @"市场描述：";
    }
    return _marketDescLabel;
}

- (CXEditLabel *)riskDescLabel{
    if(nil == _riskDescLabel){
        _riskDescLabel = [[CXEditLabel alloc]init];
        _riskDescLabel.title = @"风险提示：";
    }
    return _riskDescLabel;
}

- (CXEditLabel *)teamDescLabel{
    if(nil == _teamDescLabel){
        _teamDescLabel = [[CXEditLabel alloc]init];
        _teamDescLabel.title = @"交易对手及合作伙伴：";
    }
    return _teamDescLabel;
}

- (CXEditLabel *)timeNodeLabel{
    if(nil == _timeNodeLabel){
        _timeNodeLabel = [[CXEditLabel alloc]init];
        _timeNodeLabel.title = @"时间节点：";
    }
    return _timeNodeLabel;
}

- (CXEditLabel*)tradeThinkingLabel{
    if(nil == _tradeThinkingLabel){
        _tradeThinkingLabel = [[CXEditLabel alloc]init];
        _tradeThinkingLabel.title = @"交易总结：";
    }
    return _tradeThinkingLabel;
}

- (CXEditLabel *)withdrawSummaryLabel{
    if(nil == _withdrawSummaryLabel){
        _withdrawSummaryLabel = [[CXEditLabel alloc]init];
        _withdrawSummaryLabel.title = @"退出总结：";
    }
    return _withdrawSummaryLabel;
}
- (void)setModel:(CXHouseProjectDetialInfoModel *)model{
    _model = model;
    self.floorSpaceLabel.content = model.floorSpace?:@" ";
    self.landIndicatorLabel.content = model.landIndicator?:@"   ";
    self.legalFormlitiesLabel.content = model.legalFormalities?:@"  ";
    self.marketDescLabel.content = model.marketDesc?:@" ";
    self.riskDescLabel.content = model.riskDesc?:@" ";
    self.teamDescLabel.content = model.teamDesc?:@" ";
    self.timeNodeLabel.content = model.timeNode?:@" ";
    self.tradeThinkingLabel.content = model.tradeThinking?:@"   ";
    self.withdrawSummaryLabel.content = model.withdrawSummary?:@"   ";
    [self setUpUI];
}

@end
