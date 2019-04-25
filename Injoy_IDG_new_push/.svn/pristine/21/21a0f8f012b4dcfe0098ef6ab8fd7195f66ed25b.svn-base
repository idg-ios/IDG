//
//  CXNewColleagueCell.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXNewColleagueModel.h"

@class CXNewColleagueCell;
@protocol CXNewColleagueCellDelegate <NSObject>
@optional
- (void)newColleagueCell:(CXNewColleagueCell *)cell willHandle:(BOOL)isAgree atIndexPath:(NSIndexPath *)indexPath;
@end

@interface CXNewColleagueCell : UITableViewCell

/** <#comment#> */
@property (nonatomic, strong) CXNewColleagueModel *colleageModel;
/** <#comment#> */
@property (nonatomic, weak) id<CXNewColleagueCellDelegate> delegate;

@end
