//
//  ICEFORCEPotentialDetailBottomView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEFORCEPotentialDetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *updateBuutton;
@property (weak, nonatomic) IBOutlet UIButton *changeStateButton;

+ (instancetype)viewFromXIB;
@end
