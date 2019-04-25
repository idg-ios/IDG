//
//  ICEFORCEScoreHeadView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEScoreHeadView.h"

@implementation ICEFORCEScoreHeadView

+ (instancetype)viewFromXIB
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}
- (IBAction)clickSection:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectSection:selectButton:)]) {
        [self.delegate selectSection:self.section selectButton:sender];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
