//
//  CXButtonDownload.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/10.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXButtonDownload.h"
#import "UIView+YYAdd.h"
@implementation CXButtonDownload
-(void)drawRect:(CGRect)rect{
    if(0<=self.progress<1.0){
        CGPoint originPoint = CGPointMake(rect.size.width/2.0,rect.size.height/2.0);//CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)*10/2.f);
        CGFloat radius = MIN(rect.size.width/2.0, rect.size.height/2.0);
        CGFloat startPoint = -M_PI_2;
        CGFloat endPoint = startPoint+M_PI*2*self.progress;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:originPoint radius:radius startAngle:startPoint endAngle:endPoint clockwise:YES];
        [path addLineToPoint:originPoint];
        [[UIColor colorWithRed:153/225.0 green:153/225.0 blue:153/225.0 alpha:1.0]set];
        [path fill];
    }
}
-(void)progressOnButton{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}
@end
