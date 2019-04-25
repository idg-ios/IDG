//
//  CXSuperConfigCell.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXSuperConfigCell;
@protocol CXSuperConfigCellDelegate<NSObject>

@optional
- (void)superConfigCell:(CXSuperConfigCell *)cell willChangeEnableState:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath;

@end

@interface CXSuperConfigCell : UITableViewCell

/** 名字 */
@property (nonatomic, copy) NSString *title;
/** 是否启用 */
@property (nonatomic, assign) BOOL enable;
/** 索引 */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 代理 */
@property (nonatomic, weak) id<CXSuperConfigCellDelegate> delegate;

@end
