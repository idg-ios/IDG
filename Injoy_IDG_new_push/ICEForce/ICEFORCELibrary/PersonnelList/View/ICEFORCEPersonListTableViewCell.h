//
//  ICEFORCEPersonListTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/18.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEPersonListModel.h"
NS_ASSUME_NONNULL_BEGIN
@class ICEFORCEPersonListTableViewCell;
@protocol ICEFORCEPersonListDelegate<NSObject>

@optional
-(void)selectCell:(ICEFORCEPersonListTableViewCell *)cell selectButton:(UIButton *)sender selectIndex:(NSIndexPath *)index;
@end


@interface ICEFORCEPersonListTableViewCell : UITableViewCell

@property (nonatomic ,strong) ICEFORCEPersonListModel *model;

@property (nonatomic ,strong) NSIndexPath *path;
@property (nonatomic ,weak) id <ICEFORCEPersonListDelegate>delegateCell;
@end

NS_ASSUME_NONNULL_END
