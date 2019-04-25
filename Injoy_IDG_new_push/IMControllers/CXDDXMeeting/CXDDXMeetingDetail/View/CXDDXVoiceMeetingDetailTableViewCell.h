//
//  CXDDXVoiceMeetingDetailTableViewCell.h
//  InjoyDDXXST
//
//  Created by wtz on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXDDXVoiceModel.h"

@interface CXDDXVoiceMeetingDetailTableViewCell : UITableViewCell

- (void)setCXDDXVoiceModel:(CXDDXVoiceModel *)model;

- (void)voiceImageViewActive;

- (void)reloadImageView;

@end
