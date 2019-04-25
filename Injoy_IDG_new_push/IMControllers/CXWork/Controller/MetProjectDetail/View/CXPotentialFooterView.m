//
//  CXPotentialFooterView.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPotentialFooterView.h"
#import "UIButton+LXMImagePosition.h"
@interface CXPotentialFooterView()
@end
#define uinitpx (Screen_Width / 375.0)
@implementation CXPotentialFooterView
{
    UIView *marginView;
    UIButton *addButton;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:CGRectMake(0, 0, Screen_Width, 67 * uinitpx)]){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    marginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 8.0)];
    marginView.backgroundColor = kColorWithRGB(245, 246, 248);
    [self addSubview:marginView];
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = kColorWithRGB(255, 255, 255);
    [addButton setImage:Image(@"icon_add_red") forState:UIControlStateNormal];
    [addButton setTitle:@"添加跟进情况" forState:UIControlStateNormal];
    [addButton setTitleColor:kColorWithRGB(50, 50, 50) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:18*uinitpx];
    [addButton addTarget:self action:@selector(addActionClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(0, CGRectGetMaxY(marginView.frame), Screen_Width, 57*uinitpx);
    [addButton setImagePosition:LXMImagePositionLeft spacing:8*uinitpx];
    [self addSubview:addButton];
    
}
- (void)addActionClick{
    if(self.addFollowAction){
        self.addFollowAction();
    }
}
@end
