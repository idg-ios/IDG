//
//  ICEFORCEAlreadyRootTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEAlreadyRootModel.h"
NS_ASSUME_NONNULL_BEGIN
@class ICEFORCEAlreadyRootTableViewCell;
@protocol ICEFORCEAlreadyRootDelegate<NSObject>
- (void)showAlreadyRootCell:(ICEFORCEAlreadyRootTableViewCell *)cell selectModel:(ICEFORCEAlreadyRootModel *)model selectButton:(UIButton *)sender;
@end

@interface ICEFORCEAlreadyRootTableViewCell : UITableViewCell
@property (nonatomic ,strong) ICEFORCEAlreadyRootModel *model;
@property (nonatomic ,weak) id<ICEFORCEAlreadyRootDelegate>delegateCell;
@end

NS_ASSUME_NONNULL_END
