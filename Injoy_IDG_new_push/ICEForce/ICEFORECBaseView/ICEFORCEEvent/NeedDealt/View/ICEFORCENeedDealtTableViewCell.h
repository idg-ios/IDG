//
//  ICEFORCENeedDealtTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ICEFORCENeedDealtTableViewCell;
@protocol ICEFORCENeedDealtDelegate<NSObject>
@optional
//后面的字符串只是暂时添加 存在真实数据后 在修改
- (void)selectNeedDealtCell:(ICEFORCENeedDealtTableViewCell *)cell selectDataSource:( NSDictionary *)dataSource;
@end

@interface ICEFORCENeedDealtTableViewCell : UITableViewCell

@property (nonatomic ,weak) id <ICEFORCENeedDealtDelegate> delegateCell;
@property (nonatomic ,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
