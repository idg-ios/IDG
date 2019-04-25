//
//  ChatMoreViewBtn.m
//  im
//
//  Created by lancely on 16/1/13.
//  Copyright © 2016年 chaselen. All rights reserved.
//

#import "ChatMoreViewBtn.h"
#import "Masonry.h"
#import "UIView+Category.h"

@interface ChatMoreViewBtn()

@property (nonatomic,strong) UIButton *imaegBtn;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ChatMoreViewBtn

-(instancetype)initWithImage:(UIImage *)image title:(NSString *)title{
    if (self = [super init]) {
        if(_imaegBtn){
            [_imaegBtn removeFromSuperview];
            _imaegBtn = nil;
        }
        _imaegBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imaegBtn setImage:image forState:UIControlStateNormal];
        _imaegBtn.userInteractionEnabled = NO;
        
        if(_titleLabel){
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_imaegBtn];
        [self addSubview:_titleLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-6);
        make.leading.trailing.equalTo(self);
    }];
    
    [_imaegBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.mas_top).offset(-6);
        make.size.mas_equalTo(CGSizeMake(59, 59));
        make.centerX.equalTo(self);
    }];
    
}

@end
