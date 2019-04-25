//
//  CXUserStateCell.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXUserStateCell;
@protocol CXUserStateCellDelegate<NSObject>

@optional
- (void)userStateCell:(CXUserStateCell *)cell willChangeEnableState:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath;

@end

@interface CXUserStateCell : UITableViewCell

/** 头像地址 */
@property (nonatomic, copy) NSString *avatarUrl;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 部门 */
@property (nonatomic, copy) NSString *dept;
/** 职位 */
@property (nonatomic, copy) NSString *job;
/** 是否启用 */
@property (nonatomic, assign) BOOL enable;
/** 索引 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 代理 */
@property (nonatomic, weak) id<CXUserStateCellDelegate> delegate;

@end
