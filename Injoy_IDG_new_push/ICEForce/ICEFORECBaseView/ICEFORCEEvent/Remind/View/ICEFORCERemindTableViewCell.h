//
//  ICEFORCERemindTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ICEFORCERemindTableViewCell;
@protocol ICEFORCERemindDelegate<NSObject>
@optional
//后面的字符串只是暂时添加 存在真实数据后 在修改
- (void)selectRemindCell:(ICEFORCERemindTableViewCell *)cell selectDataSource:( NSDictionary *)dataSource;
@end

@interface ICEFORCERemindTableViewCell : UITableViewCell

@property (nonatomic ,weak) id <ICEFORCERemindDelegate> delegateCell;


@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
