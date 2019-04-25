//
//  ICEFORCEPotentialDetailOtherHeadView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEFORCEPotentialDetailOtherHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mroeButton;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

+ (instancetype)viewFromXIB;
@end
