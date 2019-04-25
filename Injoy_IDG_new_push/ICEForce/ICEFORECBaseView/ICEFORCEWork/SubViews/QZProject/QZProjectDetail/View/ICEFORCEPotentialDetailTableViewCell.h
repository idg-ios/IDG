//
//  ICEFORCEPotentialDetailTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger,  ICEFORCEPotentialDetailCellOptions) {
    ICEFORCEPotentialDetailCellOptionText        = 0,
    ICEFORCEPotentialDetailCellOptionAttText     = 1 ,
    ICEFORCEPotentialDetailCellOptionVoice       = 2 ,
    ICEFORCEPotentialDetailCellOptionState       = 3 ,


};

#import <UIKit/UIKit.h>
#import "ICEFORCEWorkProjectModel.h"

@interface ICEFORCEPotentialDetailTableViewCell : UITableViewCell

@property (nonatomic ,assign) ICEFORCEPotentialDetailCellOptions option;

/** 普通内容 */
@property (nonatomic ,strong) NSString *attString;

/** 富文本内容 */
@property (nonatomic ,strong) NSString *selectString;

@property (nonatomic ,strong) ICEFORCEWorkProjectModel *model;


@end
