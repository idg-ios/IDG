//
//  ICEFORCEFollowOnTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEFollowOnModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ICEFORCEFollowOnTableViewCell;
@protocol ICEFORCEFollowOnDelegate<NSObject>
- (void)showFollowOnRootCell:(ICEFORCEFollowOnTableViewCell *)cell selectModel:(ICEFORCEFollowOnModel *)model selectButton:(UIButton *)sender;
@end

@interface ICEFORCEFollowOnTableViewCell : UITableViewCell
@property (nonatomic ,strong) ICEFORCEFollowOnModel *model;
@property (nonatomic ,assign) id <ICEFORCEFollowOnDelegate>delegateCell;
@end

NS_ASSUME_NONNULL_END
