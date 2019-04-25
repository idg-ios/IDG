//
//  UIView+CXCategory.m
//  SDMarketingManagement
//
//  Created by lancely on 5/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "UIView+CXCategory.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"

#define kBadgeViewTag '@'
#define kBadgeViewWH 20
#define kBadgeViewDefaultTop 2
#define kBadgeViewDefaultRight 55
#define kMeBadgeViewDefaultRight (Screen_Width - 22)


#define kEmptyTipLabelTag 723741

#define kEmptyTipPicTag 723799

#define kAttentionTipLabelTag 723798

#define kShareButtonTag 235242

@implementation UIView (CXCategory)

- (void)disableTouchesDelay {
    if ([self respondsToSelector:@selector(setDelaysContentTouches:)]) {
        id view = self;
        [view setDelaysContentTouches:NO];
    }
    for (id view in self.subviews) {
        if ([view respondsToSelector:@selector(setDelaysContentTouches:)]) {
            [view setDelaysContentTouches:NO];
        }
    }
}

- (void)addBadge {
    [self removeBadge];
    CGFloat width = 10.f;
    UIView *badgeView = [self createBadgeView];
    badgeView.layer.cornerRadius = width * .5;
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.top.equalTo(badgeView.superview).offset(kBadgeViewDefaultTop + 3.f);
        make.left.equalTo(badgeView.superview).offset(kBadgeViewDefaultRight + 4.f);
    }];
}

- (void)addNumBadge:(NSString *)firstType, ... {
    va_list types;
    id type;
    NSInteger msgCount = 0;
    if (firstType) {
        if ([VAL_PUSHES_MSGS(firstType) count] > 0) {
            msgCount = [VAL_PUSHES_MSGS(firstType) count];
        }
        va_start(types, firstType);
        while ((type = va_arg(types, id))) {
            if ([VAL_PUSHES_MSGS(type) count] > 0) {
                msgCount += [VAL_PUSHES_MSGS(type) count];
            }
        }
        va_end(types);
    }

    [self removeBadge];
    UIView *badgeView = [self createNumBadgeView:[NSString stringWithFormat:@"%ld", msgCount]];
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(badgeView.frame.size);
        make.top.equalTo(badgeView.superview).offset(kBadgeViewDefaultTop);
        make.leading.equalTo(badgeView.superview).offset(kBadgeViewDefaultRight);
    }];
}

- (void)addMeNumBadgeWithText:(NSString *)text{
    [self removeBadge];
    UIView *badgeView = [self createNumBadgeView:text];
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(badgeView.frame.size);
        make.top.equalTo(badgeView.superview).offset(kBadgeViewDefaultTop);
        make.leading.equalTo(badgeView.superview).offset(kMeBadgeViewDefaultRight);
    }];
}

#pragma mark - 并未使用推送时
- (void)getNumBadge:(NSInteger)msgCount{
    
    UIView *badgeView = [self createNumBadgeView:[NSString stringWithFormat:@"%ld", msgCount]];
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(badgeView.frame.size);
        make.top.equalTo(badgeView.superview).offset(kBadgeViewDefaultTop);
        make.leading.equalTo(badgeView.superview).offset(kBadgeViewDefaultRight);
    }];
}



- (NSInteger)countNumBadge:(NSString *)firstType, ... {
    va_list types;
    id type;
    NSInteger msgCount = 0;
    if (firstType) {
        if ([VAL_PUSHES_MSGS(firstType) count] > 0) {
            msgCount = [VAL_PUSHES_MSGS(firstType) count];
        }
        va_start(types, firstType);
        while ((type = va_arg(types, id))) {
            if ([VAL_PUSHES_MSGS(type) count] > 0) {
                msgCount += [VAL_PUSHES_MSGS(type) count];
            }
        }
        va_end(types);
    }
    return msgCount;
}

- (void)removeBadge {
    UIView *view = [self viewWithTag:kBadgeViewTag];
    [view removeFromSuperview];
}

- (void)addEmptyTipWithAttentionText:(NSString *)attentionText {
    [self removeEmptyTip];
    UILabel *label = [self createEmptyTipLabelWithAttentionText:attentionText];
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        [self.superview addSubview:label];
    }
    else {
        [self addSubview:label];
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self bringSubviewToFront:label];
}

- (void)addEmptyPicTipWithPictureName:(NSString *)pictureName {
    [self removeEmptyPicTip];
    UIImageView *imageView = [self createEmptyTipPicWithPictureName:pictureName];
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        [self.superview addSubview:imageView];
    }
    else {
        [self addSubview:imageView];
    }
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.centerY.equalTo(self).offset(-60);
        make.size.mas_equalTo(CGSizeMake(120, 90));
    }];
    [self bringSubviewToFront:imageView];
}

- (void)addAttentionTipWithText:(NSString *)text {
    [self removeAttentionTip];
    UILabel *label = [self createAttentionTipLabelWithText:text];
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        [self.superview addSubview:label];
    }
    else {
        [self addSubview:label];
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self bringSubviewToFront:label];
}

- (void)removeEmptyTip {
    [[self viewWithTag:kEmptyTipLabelTag] removeFromSuperview];
    [[self.superview viewWithTag:kEmptyTipLabelTag] removeFromSuperview];
}

- (void)removeEmptyPicTip {
    [[self viewWithTag:kEmptyTipPicTag] removeFromSuperview];
    [[self.superview viewWithTag:kEmptyTipPicTag] removeFromSuperview];
}

- (void)removeAttentionTip {
    [[self viewWithTag:kAttentionTipLabelTag] removeFromSuperview];
    [[self.superview viewWithTag:kAttentionTipLabelTag] removeFromSuperview];
}

- (void)setNeedShowEmptyTipByCount:(NSInteger)dataCount {
    if (dataCount > 0) {
        [self removeEmptyTip];
    } else {
        [self addEmptyTipWithAttentionText:nil];
    }
}

- (void)setNeedShowEmptyTipAndEmptyPictureByCount:(NSInteger)dataCount AndPictureName:(NSString *)pictureName AndAttentionText:(NSString *)attentionText{
    if (dataCount > 0) {
        [self removeEmptyTip];
        [self removeEmptyPicTip];
    } else {
        [self addEmptyTipWithAttentionText:attentionText];
        [self addEmptyPicTipWithPictureName:pictureName];
    }
}

- (void)setNeedShowAttentionText:(NSString *)text {
    if(text && [text length] > 0){
        [self removeEmptyTip];
        [self addAttentionTipWithText:text];
    }else{
        [self removeAttentionTip];
    }
}

- (void)setNeedShowAttentionAndEmptyPictureText:(NSString *)text AndPictureName:(NSString *)pictureName{
    if(text && [text length] > 0){
        [self removeEmptyTip];
        [self addEmptyPicTipWithPictureName:pictureName];
        [self addAttentionTipWithText:text];
    }else{
        [self removeAttentionTip];
        [self removeEmptyPicTip];
    }
}

- (UIButton *)setShareButtonWithTitle:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl {
    return [self setShareButtonWithTitle:shareTitle content:shareContent url:shareUrl dataCount:1];
}

- (UIButton *)setShareButtonWithTitle:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl dataCount:(NSInteger)dataCount {
    UIButton *shareButton = [self viewWithTag:kShareButtonTag];
    if (shareButton == nil) {
        shareButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = kShareButtonTag;
            btn.contentMode = UIViewContentModeCenter;
            [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            CGFloat kOffset = Screen_Width / 375;
            [btn sizeToFit];
            btn.right = GET_WIDTH(self) - 20 * kOffset;
            btn.bottom = GET_HEIGHT(self) - 20 * kOffset;
            btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;

            [self addSubview:btn];
            [self bringSubviewToFront:btn];
            btn;
        });
    }
    [shareButton setBlockForControlEvents:UIControlEventTouchUpInside block:^(id _Nonnull sender) {
        if (dataCount > 0) {
//            CXShareView *shareView = [CXShareView view];
//            shareView.shareTitle = shareTitle;
//            shareView.shareContent = shareContent;
//            shareView.shareUrl = shareUrl;
//            [shareView show];
        } else {
            CXAlert(@"当前页面无内容可分享");
        }
    }];

    return shareButton;
}

- (void)removeShareButton {
    [[self viewWithTag:kShareButtonTag] removeFromSuperview];
}

#pragma mark - 私有方法

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen {
    if (self == nil) {
        return NO;
    }

    CGRect screenRect = [UIScreen mainScreen].bounds;

    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }

    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }

    // 若没有superview
    if (self.superview == nil) {
        return NO;
    }

    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return NO;
    }

    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }

    return YES;
}

- (UIView *)createBadgeView {
    UIView *badgeView = [[UIView alloc] init];
    badgeView.backgroundColor = RGBACOLOR(172, 21, 45, 1.0);
    badgeView.bounds = CGRectMake(0, 0, kBadgeViewWH, kBadgeViewWH);
    badgeView.layer.cornerRadius = badgeView.frame.size.width * .5;
    badgeView.layer.masksToBounds = YES;
    badgeView.tag = kBadgeViewTag;
    return badgeView;
}

- (UIView *)createNumBadgeView:(NSString *)numStr {

    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.frame = CGRectMake(0, 0, kBadgeViewWH, kBadgeViewWH);
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = numStr;
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    numLabel.font = fnt;
    CGSize size = [numLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
    CGFloat nameW = size.width;
    if (nameW > kBadgeViewWH) {
        nameW = ceilf(nameW) + 5.0;
        numLabel.frame = CGRectMake(0, 0, nameW, kBadgeViewWH);
    }

    UIView *badgeView = [[UIView alloc] init];
    badgeView.backgroundColor = RGBACOLOR(172, 21, 45, 1.0);
    badgeView.bounds = CGRectMake(0, 0, kBadgeViewWH, kBadgeViewWH);
    badgeView.layer.cornerRadius = badgeView.frame.size.width * .5;
    if (nameW > kBadgeViewWH) {
        badgeView.bounds = CGRectMake(0, 0, nameW, kBadgeViewWH);
        badgeView.layer.cornerRadius = badgeView.frame.size.width * .33;
    }
    badgeView.layer.masksToBounds = YES;
    badgeView.tag = kBadgeViewTag;
    [badgeView addSubview:numLabel];
    return badgeView;
}


- (UIView *)createNumBadgeView {
    UIView *badgeView = [[UIView alloc] init];
    badgeView.backgroundColor = RGBACOLOR(172, 21, 45, 1.0);
    badgeView.bounds = CGRectMake(0, 0, kBadgeViewWH, kBadgeViewWH);
    badgeView.layer.cornerRadius = badgeView.frame.size.width * .5;
    badgeView.layer.masksToBounds = YES;
    badgeView.tag = kBadgeViewTag;
    return badgeView;
}

- (UILabel *)createEmptyTipLabelWithAttentionText:(NSString *)attentionText {
    UILabel *label = [[UILabel alloc] init];
    label.text = attentionText?attentionText:@"暂无数据";
    label.textColor = RGBACOLOR(132, 142, 153, 1.0);
    label.tag = kEmptyTipLabelTag;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    return label;
}

- (UIImageView *)createEmptyTipPicWithPictureName:(NSString *)pictureName {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:pictureName];
    imageView.highlightedImage = [UIImage imageNamed:pictureName];
    imageView.tag = kEmptyTipPicTag;
    [self addSubview:imageView];
    return imageView;
}

- (UILabel *)createAttentionTipLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = RGBACOLOR(132, 142, 153, 1.0);
    label.tag = kAttentionTipLabelTag;
    label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:label];
    return label;
}

@end
