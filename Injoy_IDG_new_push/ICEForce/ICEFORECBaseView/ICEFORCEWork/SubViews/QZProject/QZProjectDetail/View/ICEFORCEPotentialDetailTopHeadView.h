//
//  ICEFORCEPotentialDetailTopHeadView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEFORCEPotentialDetailTopHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *indusGLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *pjMangeName;
@property (weak, nonatomic) IBOutlet UILabel *invLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;



+ (instancetype)viewFromXIB;

@end
