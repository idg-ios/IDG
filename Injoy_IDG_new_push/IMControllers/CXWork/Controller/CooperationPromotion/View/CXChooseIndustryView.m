//
//  CXChooseIndustryView.m
//  InjoyERP
//
//  Created by wtz on 2017/5/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXChooseIndustryView.h"

#define kLeftSpace kFormViewMargin
#define kImageLeftSpace 70
#define kRightSpace 10
#define kTextImageSpace 8

@implementation CXChooseIndustryView

#pragma mark - init
-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    UILabel * industryLabel = [[UILabel alloc] init];
    industryLabel.frame = CGRectMake(kLeftSpace, (3*kCellHeight - kFontSizeValueForForm)/2, 100, kFontSizeValueForForm);
    industryLabel.text = @"行业:";
    industryLabel.backgroundColor = [UIColor clearColor];
    industryLabel.textAlignment = NSTextAlignmentLeft;
    industryLabel.textColor = [UIColor blackColor];
    industryLabel.font = kFontSizeForDetail;
    [self addSubview:industryLabel];
    
    for(int i=0;i<6;i++){
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"outSelected"];
        imageView.highlightedImage = [UIImage imageNamed:@"outSelected"];
        
        UILabel * industryContentLabel = [[UILabel alloc] init];
        industryLabel.backgroundColor = [UIColor clearColor];
        industryLabel.textAlignment = NSTextAlignmentLeft;
        industryLabel.textColor = [UIColor blackColor];
        industryLabel.font = [UIFont systemFontOfSize:kFontSizeValueForForm];
        
        UIButton * industryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageView.tag = i + 20;
        industryBtn.tag = i;
        if(i==0){
            imageView.frame = CGRectMake(kImageLeftSpace, (3*kCellHeight - 3*kFontSizeValueForForm)/4 - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"综合行业";
            imageView.image = [UIImage imageNamed:@"selected"];
            imageView.highlightedImage = [UIImage imageNamed:@"selected"];
        }else if(i==1){
            imageView.frame = CGRectMake(kImageLeftSpace + (Screen_Width - kRightSpace - kImageLeftSpace)/2, (3*kCellHeight - 3*kFontSizeValueForForm)/4 - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"服装鞋帽业";
        }else if(i==2){
            imageView.frame = CGRectMake(kImageLeftSpace, 2*(3*kCellHeight - 3*kFontSizeValueForForm)/4 + kFontSizeValueForForm - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"食品行业";
        }else if(i==3){
            imageView.frame = CGRectMake(kImageLeftSpace + (Screen_Width - kRightSpace - kImageLeftSpace)/2, 2*(3*kCellHeight - 3*kFontSizeValueForForm)/4 + kFontSizeValueForForm - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"五金工具业";
        }else if(i==4){
            imageView.frame = CGRectMake(kImageLeftSpace, 3*(3*kCellHeight - 3*kFontSizeValueForForm)/4 + 2*kFontSizeValueForForm - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"电器业";
        }else if(i==5){
            imageView.frame = CGRectMake(kImageLeftSpace + (Screen_Width - kRightSpace - kImageLeftSpace)/2, 3*(3*kCellHeight - 3*kFontSizeValueForForm)/4 + 2*kFontSizeValueForForm - 1, kFontSizeValueForForm + 2, kFontSizeValueForForm + 2);
            industryContentLabel.text = @"电商业";
        }
        
        industryContentLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + kTextImageSpace, CGRectGetMinY(imageView.frame) + 1, 100, kFontSizeValueForForm);
        industryBtn.frame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMinY(imageView.frame), (Screen_Width - kRightSpace - kImageLeftSpace)/2, kFontSizeValueForForm + 2);
        [industryBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageView];
        [self addSubview:industryContentLabel];
        [self addSubview:industryBtn];
    }
    
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 3*kCellHeight, Screen_Width, 1);
    lineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    [self addSubview:lineView];
}

- (void)tapBtn:(id)sender{
    UIButton * btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    UIImageView * imageView = (UIImageView *)[self viewWithTag:(tag + 20)];
    if([imageView.image isEqual:[UIImage imageNamed:@"selected"]]){
        imageView.image = [UIImage imageNamed:@"outSelected"];
        imageView.highlightedImage = [UIImage imageNamed:@"outSelected"];
    }else{
        imageView.image = [UIImage imageNamed:@"selected"];
        imageView.highlightedImage = [UIImage imageNamed:@"selected"];
    }
}
@end
