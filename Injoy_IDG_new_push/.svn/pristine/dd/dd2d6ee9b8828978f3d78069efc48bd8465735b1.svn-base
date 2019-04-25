//
// Created by ^ on 2017/11/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

const CGFloat CXBottomSubmitView_height = 57.f;

#import "CXBottomSubmitView.h"
#import "Masonry.h"

@interface CXBottomSubmitView ()

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation CXBottomSubmitView {
    CXFormType _formType;
}
- (UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelButton setTitle:@"不同意" forState:0];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:0];
        _cancelButton.backgroundColor = [UIColor redColor];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.layer.cornerRadius = 5;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (void)cancelButtonClick{
    if (self.callBack) {
        self.callBack(@"不同意");
    }
}
- (void)submitBtnEvent:(UIButton *)sender {
    if (self.callBack) {
        self.callBack([sender titleForState:UIControlStateNormal]);
    }
}

- (void)setUpSubviews {
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_submitBtn];
    _submitBtn.layer.cornerRadius = 5.f;
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
   
    
    [_submitBtn.titleLabel setTextColor:[UIColor whiteColor]];
    _submitBtn.backgroundColor = [UIColor redColor];
    [_submitBtn addTarget:self
                  action:@selector(submitBtnEvent:)
        forControlEvents:UIControlEventTouchUpInside];

    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 20, 10, 20));
        make.top.left.mas_equalTo(10);
        make.bottom.right.mas_equalTo(-10);
    }];
    
    if (_formType == CXFormTypeCreate || _formType == CXFormTypeModify) {
        [_submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
   
    }
    if (_formType == CXFormTypeApproval) {
        [_submitBtn setTitle:@"同  意" forState:UIControlStateNormal];
        //新增不同意
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
//            make.left.mas_equalTo(_submitBtn.mas_right).mas_offset(10);
            make.width.mas_equalTo(Screen_Width / 2 - 20);
        }];
        
        [_submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
//            make.right.mas_equalTo(self.cancelButton.mas_left).mas_offset(-10);
            make.right.mas_equalTo(-Screen_Width / 2 );
        }];
    }
}

- (instancetype)initWithType:(CXFormType)formType {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXBottomSubmitView_height}]) {
        _formType = formType;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubviews];
    }
    return self;
}

- (void)setSubmitTitle:(NSString *)submitTitle{
    _submitTitle = submitTitle;
    if(_submitTitle && [_submitTitle length] > 0){
        [_submitBtn setTitle:_submitTitle forState:UIControlStateNormal];
    }
}
-(instancetype)initWithFrame:(CGRect)frame andType:(CXFormType)formType{
    if(self = [super initWithFrame:frame]){
        _formType = formType;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubviews];
    }
    return self;
}
@end
