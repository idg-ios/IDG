
//  UILabel + HPCategory.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/1.
//  Copyright © 2018年 Injoy. All rights reserved.


#import "UILabel + HPCategory.h"
#import <objc/runtime.h>
CG_INLINE CGFloat UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets){
    return insets.left - insets.right;
}
CG_INLINE CGFloat UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets){
    return insets.top - insets.bottom;
}
CG_INLINE void RePlaceMethod(Class _class, SEL _originSelector, SEL _newSelector){
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    BOOL isAdded = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if(isAdded){
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, newMethod);
    }
}
@implementation UILabel(HPCategory)

const char *key = "HPcategory";
const char *kContentInsets = "kContentInsets";
- (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RePlaceMethod([self class], @selector(drawRect:), @selector(sw_drawTextInRect:));
        RePlaceMethod([self class], @selector(sizeThatFits:), @selector(sw_sizeThatFits:));
    });
}
- (void)sw_drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = self.sw_contentInsets;
    [self sw_drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
- (CGSize)sw_sizeThatFits:(CGSize)size{
    UIEdgeInsets insets = self.sw_contentInsets;
    size = [self sw_sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(insets), size.height - UIEdgeInsetsGetVerticalValue(insets))];
    size.width += UIEdgeInsetsGetHorizontalValue(insets);
    size.height += UIEdgeInsetsGetVerticalValue(insets);
    return size;
}
- (void)setContent:(NSString *)content{
    self.numberOfLines = 0;
    self.text = content;
    [self relayout];
}
- (void)relayout{
    CGFloat Height = self.frame.size.height;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    if(Height < size.height){
        if(self.needUpdateFrameBlock){
            self.needUpdateFrameBlock(self, size.height);
        }
    }
}
- (void)setNeedUpdateFrameBlock:(void (^)(UILabel *, CGFloat))needUpdateFrameBlock{
    objc_setAssociatedObject(self, key, needUpdateFrameBlock, OBJC_ASSOCIATION_COPY);
}
-(void (^)(UILabel *, CGFloat))needUpdateFrameBlock{
    return objc_getAssociatedObject(self, key);
}
- (void)setSw_contentInsets:(UIEdgeInsets)sw_contentInsets{
    objc_setAssociatedObject(self, kContentInsets, [NSValue valueWithUIEdgeInsets:sw_contentInsets], OBJC_ASSOCIATION_RETAIN);
 
}
- (UIEdgeInsets)sw_contentInsets{
    return [objc_getAssociatedObject(self, kContentInsets) UIEdgeInsetsValue];
}
@end

