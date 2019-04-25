// RDVTabBarItem.h
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarItem.h"

@interface RDVTabBarItem () {
    NSString* _title;
    UIOffset _imagePositionAdjustment;
    NSDictionary* _unselectedTitleAttributes;
    NSDictionary* _selectedTitleAttributes;
}

@property UIImage* unselectedBackgroundImage;
@property UIImage* selectedBackgroundImage;
@property UIImage* unselectedImage;
@property UIImage* selectedImage;

@end

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization
{
    // Setup defaults

    [self setBackgroundColor:[UIColor whiteColor]];

    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        _unselectedTitleAttributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:SDTabbarTitleFont],
//            NSForegroundColorAttributeName : [UIColor blackColor],
            // 超信tabbar未选中文字颜色
            NSForegroundColorAttributeName : SDTabbarTitleGrayColor
        };
        _selectedTitleAttributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:SDTabbarTitleFont],
            NSForegroundColorAttributeName : kIconBlueColor,
        };
    }
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        {
            _unselectedTitleAttributes = @{
                UITextAttributeFont : [UIFont systemFontOfSize:SDTabbarTitleFont],
                UITextAttributeTextColor : SDTabbarTitleGrayColor,
            };
            _selectedTitleAttributes = @{
                NSFontAttributeName : [UIFont systemFontOfSize:SDTabbarTitleFont],
                UITextAttributeTextColor : kIconBlueColor,
            };
        }
#endif
    }

    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    _badgeBackgroundColor = RGBACOLOR(172, 21, 45, 1.0);
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:SDTabbarTitleFont];
    _badgePositionAdjustment = UIOffsetZero;
}
#pragma mark--强制改了selectTitleAttr的属性
- (void)drawRect:(CGRect)rect
{

    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary* titleAttributes = nil;
    UIImage* backgroundImage = nil;
    UIImage* image = nil;
    CGFloat imageStartingY = 0.0f;

    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];

        // 修改tabBarItem选中的title状态
        _selectedTitleAttributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:SDTabbarTitleFont],
            // 超信tabbar选中文字颜色
            NSForegroundColorAttributeName : kIconBlueColor,
        };
        titleAttributes = [self selectedTitleAttributes];

        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPoint aPoints[2];//坐标点
        aPoints[0] =CGPointMake(0, 0);//坐标1
        aPoints[1] =CGPointMake(self.frame.size.width, 0);//坐标2
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextSetLineWidth(context, 1.5);
        //--------------------wtz这里改变选中的tab线的颜色－－－－－－－－－－－－
//        CGContextSetRGBStrokeColor(context, 251/255.0, 155/255.0, 0, 1);
        CGContextSetRGBStrokeColor(context, 221/255.0, 223/255.0, 225/255.0, 1);
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
        
    }
    else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPoint aPoints[2];//坐标点
        aPoints[0] =CGPointMake(0, 0);//坐标1
        aPoints[1] =CGPointMake(self.frame.size.width, 0);//坐标2
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextSetLineWidth(context, 1.5f);
        CGContextSetRGBStrokeColor(context, 221/255.0, 223/255.0, 225/255.0, 1);
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    }

    imageSize = [image size];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    [backgroundImage drawInRect:self.bounds];

    // Draw image and title

    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal,
                              roundf(frameSize.height / 2 - imageSize.height / 2) + _imagePositionAdjustment.vertical,
                              imageSize.width, imageSize.height)];
    }
    else {

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:titleAttributes
                                             context:nil].size;

            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);

            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal,
                                  imageStartingY + _imagePositionAdjustment.vertical,
                                  imageSize.width, imageSize.height)];

            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);

            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal,
                                   imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                   titleSize.width, titleSize.height)
                withAttributes:titleAttributes];
        }
        else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            titleSize = [_title sizeWithFont:titleAttributes[UITextAttributeFont]
                           constrainedToSize:CGSizeMake(frameSize.width, 20)];
            UIOffset titleShadowOffset = [titleAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);

            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal,
                                  imageStartingY + _imagePositionAdjustment.vertical,
                                  imageSize.width, imageSize.height)];

            CGContextSetFillColorWithColor(context, [titleAttributes[UITextAttributeTextColor] CGColor]);

            UIColor* shadowColor = titleAttributes[UITextAttributeTextShadowColor];

            if (shadowColor) {
                CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                    1.0, [shadowColor CGColor]);
            }

            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal,
                                   imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                   titleSize.width, titleSize.height)
                      withFont:titleAttributes[UITextAttributeFont]
                 lineBreakMode:NSLineBreakByTruncatingTail];
#endif
        }
    }

    // Draw badges

    if ([[self badgeValue] length]) {
        CGSize badgeSize = CGSizeZero;

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{ NSFontAttributeName : [self badgeTextFont] }
                                                  context:nil].size;
        }
        else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            badgeSize = [_badgeValue sizeWithFont:[self badgeTextFont]
                                constrainedToSize:CGSizeMake(frameSize.width, 20)];
#endif
        }

        CGFloat textOffset = 2.0f;

        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }

        CGRect badgeBackgroundFrame = CGRectMake(roundf(frameSize.width / 2 + (image.size.width / 2) * 0.8) +
                [self badgePositionAdjustment].horizontal-4,
            textOffset + [self badgePositionAdjustment].vertical,
            badgeSize.width + 2 * textOffset - 2, badgeSize.height + 2 * textOffset -2);

        if([self.badgeValue isEqualToString:@" "]){
            badgeBackgroundFrame = CGRectMake(roundf(frameSize.width / 2 + (image.size.width / 2) * 0.8) +
                                              [self badgePositionAdjustment].horizontal-4,
                                              textOffset + [self badgePositionAdjustment].vertical,
                                              10, 10);
        }
        
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);

            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        }
        else if ([self badgeBackgroundImage]) {
            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
        }

        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            NSMutableParagraphStyle* badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];

            NSDictionary* badgeTextAttributes = @{
                NSFontAttributeName : [self badgeTextFont],
                NSForegroundColorAttributeName : [self badgeTextColor],
                NSParagraphStyleAttributeName : badgeTextStyle,
            };

            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset-1,
                                              CGRectGetMinY(badgeBackgroundFrame) + textOffset-1,
                                              badgeSize.width, badgeSize.height)
                           withAttributes:badgeTextAttributes];
        }
        else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
                                              CGRectGetMinY(badgeBackgroundFrame) + textOffset,
                                              badgeSize.width, badgeSize.height)
                                 withFont:[self badgeTextFont]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
#endif
        }
    }

    CGContextRestoreGState(context);
}

#pragma mark - Image configuration

- (UIImage*)finishedSelectedImage
{
    return [self selectedImage];
}

- (UIImage*)finishedUnselectedImage
{
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage*)selectedImage withFinishedUnselectedImage:(UIImage*)unselectedImage
{
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }

    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

- (void)setBadgeValue:(NSString*)badgeValue
{
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}

#pragma mark - Background configuration

- (UIImage*)backgroundSelectedImage
{
    return [self selectedBackgroundImage];
}

- (UIImage*)backgroundUnselectedImage
{
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage*)selectedImage withUnselectedImage:(UIImage*)unselectedImage
{
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }

    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

@end
