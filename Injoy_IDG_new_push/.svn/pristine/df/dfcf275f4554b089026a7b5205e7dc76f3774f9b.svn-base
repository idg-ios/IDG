//
//  BulletView.m
//  CommentDemo
//
//  Created by feng jia on 16/2/20.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import "BulletView.h"
#import "UIImageView+WebCache.h"

#define mWidth [UIScreen mainScreen].bounds.size.width
#define mHeight [UIScreen mainScreen].bounds.size.height
#define mDuration   5
#define Padding  5
@interface BulletView ()

@property BOOL bDealloc;
@end

@implementation BulletView

- (void)dealloc {
    [self stopAnimation];
    self.moveBlock = nil;
}

- (instancetype)initWithContent:(CXIDGNHDMModel *)content {
    if (self == [super init]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = RGBACOLOR(229.0, 175.0, 93.0, 0.8);
        if(content.icon && [content.icon length] > 0){
            UIImageView * sdDownLoad = [[UIImageView alloc] init];
            [sdDownLoad setImageWithURL:[NSURL URLWithString:content.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] success:^(UIImage *image, BOOL cached) {
                NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content.msg attributes:@{NSBaselineOffsetAttributeName:@(7)}];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [self circleImageWithImage:image borderWidth:image.size.width/10.0 borderColor:[UIColor clearColor]];  //设置图片源
                textAttachment.bounds = CGRectMake(0, 0, 25.0, 25.0);  //设置图片位置和大小
                NSAttributedString *attachmentAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attrStr insertAttributedString:attachmentAttrStr atIndex:0];
                self.lbComment = [UILabel new];
                self.lbComment.backgroundColor = [UIColor clearColor];
                self.lbComment.attributedText = attrStr;
                self.lbComment.font = [UIFont systemFontOfSize:16.0];
                self.lbComment.textColor = [UIColor whiteColor];
                [self.lbComment sizeToFit];
                float width = self.lbComment.frame.size.width;
                self.bounds = CGRectMake(0, 0, width + Padding*2, 25);
                self.layer.cornerRadius = 25.0/2;
                self.clipsToBounds = YES;
                [self addSubview:self.lbComment];
            } failure:^(NSError *error) {
                NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content.msg attributes:@{NSBaselineOffsetAttributeName:@(7)}];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [self circleImageWithImage:[UIImage imageNamed:@"temp_user_head"] borderWidth:[UIImage imageNamed:@"temp_user_head"].size.width/10.0 borderColor:[UIColor clearColor]];  //设置图片源
                textAttachment.bounds = CGRectMake(0, 0, 25.0, 25.0);  //设置图片位置和大小
                NSAttributedString *attachmentAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attrStr insertAttributedString:attachmentAttrStr atIndex:0];
                self.lbComment = [UILabel new];
                self.lbComment.backgroundColor = [UIColor clearColor];
                self.lbComment.attributedText = attrStr;
                self.lbComment.font = [UIFont systemFontOfSize:16.0];
                self.lbComment.textColor = [UIColor whiteColor];
                [self.lbComment sizeToFit];
                float width = self.lbComment.frame.size.width;
                self.bounds = CGRectMake(0, 0, width + Padding*2, 25);
                self.layer.cornerRadius = 25.0/2;
                self.clipsToBounds = YES;
                [self addSubview:self.lbComment];
            }];
        }else{
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content.msg attributes:@{NSBaselineOffsetAttributeName:@(7)}];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [self circleImageWithImage:[UIImage imageNamed:@"temp_user_head"] borderWidth:[UIImage imageNamed:@"temp_user_head"].size.width/10.0 borderColor:[UIColor clearColor]];  //设置图片源
            textAttachment.bounds = CGRectMake(0, 0, 25.0, 25.0);  //设置图片位置和大小
            NSAttributedString *attachmentAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attrStr insertAttributedString:attachmentAttrStr atIndex:0];
            self.lbComment = [UILabel new];
            self.lbComment.backgroundColor = [UIColor clearColor];
            self.lbComment.attributedText = attrStr;
            self.lbComment.font = [UIFont systemFontOfSize:16.0];
            self.lbComment.textColor = [UIColor whiteColor];
            [self.lbComment sizeToFit];
            float width = self.lbComment.frame.size.width;
            self.bounds = CGRectMake(0, 0, width + Padding*2, 25);
            self.layer.cornerRadius = 25.0/2;
            self.clipsToBounds = YES;
            [self addSubview:self.lbComment];
        }
    }
    return self;
}

- (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    CGFloat imageWidth = sourceImage.size.width - 2 * borderWidth;
    CGFloat imageHeight = sourceImage.size.height - 2 * borderWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sourceImage.size.width, sourceImage.size.height), NO, 0.0);
    UIGraphicsGetCurrentContext();
    CGFloat radius = (imageWidth < imageWidth?imageHeight:imageHeight)*0.5;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake((sourceImage.size.width) * 0.5, (sourceImage.size.height) * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bezierPath.lineWidth = borderWidth;
    [borderColor setStroke];
    [bezierPath stroke];
    [bezierPath addClip];
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, imageWidth, imageHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)startAnimation {
    NSInteger armInt = arc4random()%600;
    
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat wholeWidth = CGRectGetWidth(self.frame) + mWidth + 50 + armInt;
    CGFloat speed = wholeWidth/mDuration;
    CGFloat dur = (CGRectGetWidth(self.frame) + 50 + armInt)/speed;
    
    
    __block CGRect frame = self.frame;
    if (self.moveBlock) {
        //弹幕开始进入屏幕
        self.moveBlock(Start);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //避免重复，通过变量判断是否已经释放了资源，释放后，不在进行操作
        if (self.bDealloc) {
            return;
        }
        //dur时间后弹幕完全进入屏幕
        if (self.moveBlock) {
            self.moveBlock(Enter);
        }
    });
    
    //弹幕完全离开屏幕
    [UIView animateWithDuration:mDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveBlock) {
            self.moveBlock(End);
        }
        [self removeFromSuperview];
    }];
}

- (void)stopAnimation {
    self.bDealloc = YES;
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
