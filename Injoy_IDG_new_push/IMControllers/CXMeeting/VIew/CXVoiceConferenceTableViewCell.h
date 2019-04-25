//
//  CXVoiceConferenceTableViewCell.h
//  SDMarketingManagement
//
//  Created by Rao on 16/5/3.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXVoiceConferenceTableViewCell : UITableViewCell
/// 群组头像
@property (weak, nonatomic) IBOutlet UIImageView* groupImageView;
/// 群组标题
@property (weak, nonatomic) IBOutlet UILabel* groupTitleLabel;
/// 有多少人
@property (weak, nonatomic) IBOutlet UILabel* groupMemberCountLabel;
/// 群组时间
@property (weak, nonatomic) IBOutlet UILabel* groupTimeLabel;

@end
