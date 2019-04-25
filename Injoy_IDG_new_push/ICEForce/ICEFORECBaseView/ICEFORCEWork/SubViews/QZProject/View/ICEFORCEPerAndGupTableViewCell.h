//
//  ICEFORCEPerAndGupTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEPotentialProjectmModel.h"

@class ICEFORCEPerAndGupTableViewCell;

@protocol ICEFORCEPotentialProjectDelegate <NSObject>

@optional
//后面的字符串只是暂时添加 存在真实数据后 在修改
- (void)showStateCell:(ICEFORCEPerAndGupTableViewCell *)cell selectModel:(ICEFORCEPotentialProjectmModel *)model;

@end

@interface ICEFORCEPerAndGupTableViewCell : UITableViewCell
@property (nonatomic ,strong) ICEFORCEPotentialProjectmModel *model;

@property (nonatomic ,weak) id <ICEFORCEPotentialProjectDelegate> delegateCell;
@end
