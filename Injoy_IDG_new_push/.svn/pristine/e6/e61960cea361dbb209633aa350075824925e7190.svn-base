//
//  ChatMoreView.m
//  im
//
//  Created by lancely on 16/1/13.
//  Copyright © 2016年 chaselen. All rights reserved.
//

#import "ChatMoreView.h"
#import "ChatMoreViewBtn.h"
#import "UIView+Category.h"
#import "SDSelectMemberViewController.h"

#define kLeftSpacing ((Screen_Width - 59*4)/5/2)
#define kBtnWidth (kLeftSpacing*2 + 59)

@interface ChatMoreView()
@property (nonatomic) ChatMoreViewType chatMoreViewType;
@end

@implementation ChatMoreView

-(instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame AndChatMoreViewType:(ChatMoreViewType)type{
    self.chatMoreViewType = type;
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{

    self.size = CGSizeMake(Screen_Width, self.chatMoreViewType == ChatMoreViewNotGroupType ? 188 + kTabbarSafeBottomMargin : 98 + kTabbarSafeBottomMargin);
    CGSize size = CGSizeMake(Screen_Width, self.chatMoreViewType == ChatMoreViewNotGroupType ? 188 : 98);
//    self.size = CGSizeMake(Screen_Width, 188+kTabbarSafeBottomMargin);
//    CGSize size = CGSizeMake(Screen_Width, 188+kTabbarSafeBottomMargin);
    NSInteger btnCount = self.chatMoreViewType == ChatMoreViewNotGroupType ? 7 : 4;

    NSInteger colCount = 4;
    NSInteger rowCount = ceil(btnCount / 4.0);
    CGFloat width = kBtnWidth;
    CGFloat height = size.height / rowCount;
    for (NSInteger i = 0; i < btnCount; i++) {
        UIImage *img = [self imageForIndex:i];
        NSString *title = [self titleForIndex:i];
        ChatMoreViewBtn *btn = [[ChatMoreViewBtn alloc] initWithImage:img title:title];
        btn.tag = i;
        [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)]];
        NSInteger rowIndex = i / colCount; // 当前按钮行号
        CGFloat x = kLeftSpacing + i*kBtnWidth;
        if(i == 4 || i == 5 || i == 6){
            x = kLeftSpacing + (i - 4)*kBtnWidth;
        }
        CGFloat y;
        if(self.chatMoreViewType == ChatMoreViewNotGroupType){
            if(i == 0 || i == 1 || i == 2 || i == 3){
                y = rowIndex * height  + 7;
            }else{
                y = rowIndex * height;
            }
        }else{
            y = rowIndex * height;
        }
        btn.frame = CGRectMake(x , y , width, height);
        
        [self addSubview:btn];
    }
}

-(UIImage *)imageForIndex:(NSInteger)index{
    NSString *imgName = @"";
    switch (index) {
        case 0:
            imgName = @"newchatBar_colorMore_photo";
            break;
        case 1:
            imgName = @"newchatBar_colorMore_location";
            break;
        case 2:
            imgName = @"newchatBar_colorMore_camera";
            break;
        case 3:
            imgName = @"newchatBar_colorMore_video";
            break;
        case 4:
            imgName = @"newchatBar_colorMore_audioCall";
            break;
        case 5:
            imgName = @"newchatBar_colorMore_videoCall";
            break;
        case 6:
            imgName = @"burnAfterRead";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imgName];
}

-(NSString *)titleForIndex:(NSInteger)index{
    NSString *title = @"";
    switch (index) {
        case 0:
            title = @"图片";
            break;
        case 1:
            title = @"位置";
            break;
        case 2:
            title = @"照相机";
            break;
        case 3:
            title = @"视频";
            break;
        case 4:
            title = @"语音通话";
            break;
        case 5:
            title = @"视频通话";
            break;
        case 6:
            title = @"阅后即焚";
            break;
        default:
            break;
    }
    return title;
}

-(void)buttonTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
        if ([self.delegate respondsToSelector:@selector(chatMoreView:didTapButtonWithType:)]) {
            [self.delegate chatMoreView:self didTapButtonWithType:gestureRecognizer.view.tag];
        }
    
}

@end
