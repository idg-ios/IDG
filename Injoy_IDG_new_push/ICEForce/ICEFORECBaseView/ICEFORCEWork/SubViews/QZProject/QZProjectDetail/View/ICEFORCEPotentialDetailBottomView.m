//
//  ICEFORCEPotentialDetailBottomView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPotentialDetailBottomView.h"

@implementation ICEFORCEPotentialDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.stateLabel cornerRadius:self.stateLabel.frame.size.height/2 borderColor:nil borderWidth:0];

}


+ (instancetype)viewFromXIB{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}
@end
