//
//  ICEFORCEWorkHeadView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICEFORCEWorkHeadView;
@protocol ICEFORCEWorkHeadViewDelegate <NSObject>

@optional
- (void)selectButton:(UIButton *)sender buttonTag:(NSInteger)tag;

@end
@interface ICEFORCEWorkHeadView : UIView

@property (nonatomic ,weak) id <ICEFORCEWorkHeadViewDelegate>delegateCell;

+ (instancetype)viewFromXIB;
@end
