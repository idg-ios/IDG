//
//  ICEFORCEWorkHeadView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEWorkHeadView.h"

@implementation ICEFORCEWorkHeadView


- (IBAction)clickOne:(UIButton *)sender {
    
    if ([self.delegateCell respondsToSelector:@selector(selectButton:buttonTag:)]) {
        [self.delegateCell selectButton:sender buttonTag:sender.tag];
    }
    
}


+ (instancetype)viewFromXIB{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}

@end
