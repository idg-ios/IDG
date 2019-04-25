//
//  CXYunJingWorkCircleTableViewCell.h
//  InjoyYJ1
//
//  Created by wtz on 2017/8/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAllPeoplleWorkCircleModel.h"

@interface CXYunJingWorkCircleTableViewCell : UITableViewCell

/** 文字高度 */
typedef NS_ENUM(NSInteger, ShowCellType) {
    /** 文字高度小于指定高度全显示 */
    LessAllShowCellType = 1,
    /** 文字高度大于指定高度全显示 */
    MoreAllShowCellType = 2,
    /** 文字高度大于指定高度部分显示 */
    MoreNotAllShowCellType = 3
};

typedef void(^updateCellHeightCallBack)(NSIndexPath * indexPath,ShowCellType type);

@property (nonatomic, assign) ShowCellType type;

@property (nonatomic, copy) updateCellHeightCallBack updateCellHeightCallBack;

- (void)setCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model AndNSIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getYujingCellHeightWithModel:(CXAllPeoplleWorkCircleModel *)model AndType:(ShowCellType)type;

@end
