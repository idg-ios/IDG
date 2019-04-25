//
//  ICEFORCEScoreHeadView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ICEFORCEScoreHeadDelegate<NSObject>
@optional
-(void)selectSection:(NSInteger)section selectButton:(UIButton *)sender;
@end


@interface ICEFORCEScoreHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *comLabel;

@property (nonatomic ,assign) NSInteger section;
@property (nonatomic ,assign) id <ICEFORCEScoreHeadDelegate>delegate;
+ (instancetype)viewFromXIB;
@end

NS_ASSUME_NONNULL_END
